/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.flex.utilities.converter.mavenextension;

import org.apache.flex.utilities.converter.air.AirConverter;
import org.apache.flex.utilities.converter.flash.FlashConverter;
import org.apache.flex.utilities.converter.flex.FlexConverter;
import org.apache.flex.utilities.converter.fontkit.FontkitConverter;
import org.apache.flex.utilities.converter.retrievers.download.DownloadRetriever;
import org.apache.flex.utilities.converter.retrievers.types.SdkType;
import org.apache.maven.AbstractMavenLifecycleParticipant;
import org.apache.maven.MavenExecutionException;
import org.apache.maven.artifact.Artifact;
import org.apache.maven.artifact.resolver.ArtifactResolutionRequest;
import org.apache.maven.artifact.resolver.ArtifactResolutionResult;
import org.apache.maven.execution.MavenSession;
import org.apache.maven.repository.RepositorySystem;
import org.codehaus.plexus.component.annotations.Component;
import org.codehaus.plexus.component.annotations.Requirement;
import org.codehaus.plexus.logging.Logger;

import java.io.File;

/**
 * Created by christoferdutz on 16.04.15.
 */
@Component(role = AbstractMavenLifecycleParticipant.class, hint = "flex-sdk-initializer")
public class FlexSdkInitializer extends AbstractMavenLifecycleParticipant {

    public static final String AIR_GROUP_ID = "com.adobe.air";
    public static final String FLASH_GROUP_ID = "com.adobe.flash";
    public static final String FLEX_GROUP_ID = "org.apache.flex";
    public static final String FONTKIT_GROUP_ID = "com.adobe";

    public static final String FRAMEWORK = "framework";
    public static final String COMPILER = "compiler";
    public static final String FONTKIT = "fontkit";

    public static final String POM = "pom";
    public static final String JAR = "jar";

    @Requirement
    protected Logger logger;

    @Requirement
    private RepositorySystem repositorySystem;

    @Override
    public void afterProjectsRead(MavenSession session) throws MavenExecutionException {
        super.afterProjectsRead(session);

        // Get the maven local repo directory.
        File mavenLocalRepoDir = new File(session.getLocalRepository().getBasedir());

        logger.info("                                                                   \n" +
                "                                      `,;':,                :';;;  \n" +
                "                                     `:;''';'             `++'';;, \n" +
                "                                     :;'''++;'           .+'+''';;;\n" +
                "                          :          ;'''++++''         ,';+++''';'\n" +
                "              ,. `,  ,. ..: , `,    `'''+++##;'',      ;;'+#+++''''\n" +
                "             ; ; ; ;; ;`: :,: ; ;    ;'+++;  #;;;;;:::;;;;+  +++'':\n" +
                "             ; ; : ;; ;., : : ;.     ;;++#    ';;;;;;;;;;+   .+++; \n" +
                "             `;: :; `;: :;: , :;`     +;+#    ,;;;:::::;:    ;#+', \n" +
                "  ;++++:'++      :                ;+,; ++;#    +;::::::;    ,+;;:  \n" +
                " ++++++,'++                  `++'       +'''`   ;::::::,   +:;;:   \n" +
                "`+++.   '++    ++++++  +++   +++         '''''   ;:::::   :;;;;    \n" +
                "+++`    '++   ++++++++ +++` `++:         :'';;;   ;::`   :::::     \n" +
                "+++     '++  +++'  :++: +++ +++           ;;;;;'        ::::::     \n" +
                "+++     '++  +++    ++' `+++++`           ;;;;;;:      .:::::`     \n" +
                "+++++++ '++  +++:::+++.  +++++            ;;;;;;;      ,:::::      \n" +
                "+++++++ '++  +++++++++   :+++'            ;;;;;;;      ,:::::      \n" +
                "+++'''  '++  +++;;;:`    +++++            ;;;;;;`      ::::::.     \n" +
                "+++     '++  +++        +++ +++           ;;;;;:        ::::::     \n" +
                "+++     :++. ++++   `  :++, ,++;         ''';;.   `..:   ::::;`    \n" +
                "+++      ++'  +++++++  +++   +++        :''';    ,,,,,:   ;;;;;    \n" +
                ";++`     +++   ++++++ +++     +++      .+';+    :,,,,,,:   `';;;   \n" +
                " ++'                                  `+'''    ::,,,,,:::    ';;'  \n" +
                " :++                                  #;''    +:::,,,::::    .'':; \n" +
                "                                     ';;''   ::::::::::::'   ,';;:.\n" +
                "                                     ;;;;''`;+;;::`  .::;;'.,';;;;:\n" +
                "                                    `::;;;''':;;       `;;;'';;;;;;\n" +
                "                                     :::;;;'';:          ;;';;;;;:;\n" +
                "                                     ,:::;;;',            ',;;;;::`\n" +
                "                                      .:::;:.              ;:;;::: \n" +
                "                                       ::;,                 `,;;`  \n");

        logger.info("-------------------------------------------------------------------");
        logger.info("- Intializing Apache Flex related resources");
        logger.info("-------------------------------------------------------------------");
        String flexVersion = session.getCurrentProject().getProperties().getProperty("flex.sdk.version", null);
        String flashVersion = session.getCurrentProject().getProperties().getProperty("flash.sdk.version", null);
        String airVersion = session.getCurrentProject().getProperties().getProperty("air.sdk.version", null);
        boolean useFontkit = Boolean.valueOf(
                session.getCurrentProject().getProperties().getProperty("flex.fontkit", "false"));

        if (flexVersion != null) {
            logger.info("flex.sdk.version = " + flexVersion);
            Artifact flexFramework = resolve(FLEX_GROUP_ID, FRAMEWORK, flexVersion, POM, session);;
            Artifact flexCompiler = resolve(FLEX_GROUP_ID, COMPILER, flexVersion, POM, session);

            if (flexFramework == null || flexCompiler == null) {
                logger.info(" - Installing");
                // Use the Mavenizer to download and install the fex artifacts.
                try {
                    DownloadRetriever downloadRetriever = new DownloadRetriever();
                    File flexSdkRoot = downloadRetriever.retrieve(SdkType.FLEX, flexVersion);
                    FlexConverter flexConverter = new FlexConverter(flexSdkRoot, mavenLocalRepoDir);
                    flexConverter.convert();
                } catch (Exception ce) {
                    throw new MavenExecutionException(
                            "Caught exception while downloading and converting artifact.", ce);
                }
            } else {
                logger.info(" - OK");
            }
        } else {
            logger.info("flex.sdk.version = not set");
        }

        logger.info("-------------------------------------------------------------------");

        if (flashVersion != null) {
            logger.info("flash.sdk.version = " + flashVersion);
            Artifact flashFramework = resolve(FLASH_GROUP_ID, FRAMEWORK, flashVersion, POM, session);

            if (flashFramework == null) {
                logger.info(" - Installing");
                // Use the Mavenizer to download and install the playerglobal artifact.
                try {
                    DownloadRetriever downloadRetriever = new DownloadRetriever();
                    File flashSdkRoot = downloadRetriever.retrieve(SdkType.FLASH, flashVersion);
                    FlashConverter flashConverter = new FlashConverter(flashSdkRoot, mavenLocalRepoDir);
                    flashConverter.convert();
                } catch (Exception ce) {
                    throw new MavenExecutionException(
                            "Caught exception while downloading and converting artifact.", ce);
                }
            } else {
                logger.info(" - OK");
            }
        } else {
            logger.info("flash.sdk.version = not set");
        }

        logger.info("-------------------------------------------------------------------");

        if (airVersion != null) {
            logger.info("air.sdk.version = " + airVersion);
            Artifact airFramework = resolve(AIR_GROUP_ID, FRAMEWORK, flexVersion, POM, session);
            Artifact airCompiler = resolve(AIR_GROUP_ID, COMPILER, flexVersion, POM, session);

            if (airFramework == null || airCompiler == null) {
                logger.info(" - Installing");
                // Use the Mavenizer to download and install the airglobal artifact.
                try {
                    DownloadRetriever downloadRetriever = new DownloadRetriever();
                    File airSdkRoot = downloadRetriever.retrieve(SdkType.AIR, airVersion);
                    AirConverter airConverter = new AirConverter(airSdkRoot, mavenLocalRepoDir);
                    airConverter.convert();
                } catch (Exception ce) {
                    throw new MavenExecutionException(
                            "Caught exception while downloading and converting artifact.", ce);
                }
            } else {
                logger.info(" - OK");
            }
        } else {
            logger.info("air.sdk.version = not set");
        }

        logger.info("-------------------------------------------------------------------");

        if (useFontkit) {
            logger.info("flex.fontkit = true");
            Artifact fontkit = resolve(FONTKIT_GROUP_ID, FONTKIT, "1.0", JAR, session);

            if (fontkit == null) {
                logger.info(" - Installing");
                // Use the Mavenizer to download and install the airglobal artifact.
                try {
                    DownloadRetriever downloadRetriever = new DownloadRetriever();
                    File fontkitRoot = downloadRetriever.retrieve(SdkType.FONTKIT);
                    FontkitConverter fontkitConverter = new FontkitConverter(fontkitRoot, mavenLocalRepoDir);
                    fontkitConverter.convert();
                } catch (Exception ce) {
                    throw new MavenExecutionException(
                            "Caught exception while downloading and converting artifact.", ce);
                }
            } else {
                logger.info(" - OK");
            }
        } else {
            logger.info("flex.fontkit = not set or set to 'false'");
        }

        logger.info("-------------------------------------------------------------------");
        logger.info("- Finished initializing Apache Flex related resources");
        logger.info("-------------------------------------------------------------------");
    }

    public Artifact resolve(String groupId, String artifactId, String version, String type, MavenSession session) {
        Artifact artifact =
                repositorySystem.createArtifact(groupId, artifactId, version, type);
        if (!artifact.isResolved()) {
            ArtifactResolutionRequest req = new ArtifactResolutionRequest();
            req.setArtifact(artifact);
            req.setLocalRepository(session.getLocalRepository());
            req.setRemoteRepositories(session.getRequest().getRemoteRepositories());
            ArtifactResolutionResult res = repositorySystem.resolve(req);
            if (!res.isSuccess()) {
                return null;
            }
        }
        return artifact;
    }

}
