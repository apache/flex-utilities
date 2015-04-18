package org.apache.flex.utilities.converter.mavenextension;

import org.apache.commons.io.FileUtils;
import org.apache.flex.utilities.converter.air.AirConverter;
import org.apache.flex.utilities.converter.flash.FlashConverter;
import org.apache.flex.utilities.converter.flex.FlexConverter;
import org.apache.flex.utilities.converter.fontkit.FontkitConverter;
import org.apache.flex.utilities.converter.retrievers.download.DownloadRetriever;
import org.apache.flex.utilities.converter.retrievers.types.SdkType;
import org.apache.maven.MavenExecutionException;
import org.apache.maven.artifact.resolver.ArtifactResolutionRequest;
import org.apache.maven.artifact.resolver.ArtifactResolutionResult;
import org.apache.maven.eventspy.AbstractEventSpy;
import org.apache.maven.execution.MavenSession;
import org.apache.maven.repository.RepositorySystem;
import org.codehaus.plexus.PlexusContainer;
import org.codehaus.plexus.logging.Logger;
import org.eclipse.aether.RepositoryEvent;
import org.eclipse.aether.artifact.Artifact;

import javax.inject.Inject;
import javax.inject.Named;
import javax.inject.Singleton;
import java.io.File;

/**
 * Created by christoferdutz on 17.04.15.
 */
@Named
@Singleton
public class FlexEventSpy extends AbstractEventSpy {

    @Inject
    protected RepositorySystem repositorySystem;

    @Inject
    protected Logger logger;

    @Inject
    protected PlexusContainer plexusContainer;

    protected boolean internalLookup = false;
    protected boolean flexSplashScreenShown = false;

    public FlexEventSpy() {
    }

    @Override
    public void init(Context context) throws Exception {
    }

    @Override
    public void onEvent(Object o) throws Exception {
        if(o instanceof RepositoryEvent) {
            RepositoryEvent repositoryEvent = (RepositoryEvent) o;
            if(repositoryEvent.getType() == RepositoryEvent.EventType.ARTIFACT_RESOLVING) {
                if(!internalLookup) {
                    try {
                        internalLookup = true;
                        Artifact artifact = repositoryEvent.getArtifact();
                        if (artifact.getGroupId().startsWith("org.apache.flex")) {
                            if(!flexSplashScreenShown) {
                                showFlexSplashScreen();
                            }
                            if(resolve(artifact.getGroupId(), artifact.getArtifactId(), artifact.getVersion(),
                                    artifact.getExtension(), artifact.getClassifier()) == null) {
                                initFlex(artifact.getVersion());
                            }
                        } else if (artifact.getGroupId().startsWith("com.adobe.flash")) {
                            if(resolve(artifact.getGroupId(), artifact.getArtifactId(), artifact.getVersion(),
                                    artifact.getExtension(), artifact.getClassifier()) == null) {
                                initFlash(artifact.getVersion());
                            }
                        } else if (artifact.getGroupId().startsWith("com.adobe.air")) {
                            if(resolve(artifact.getGroupId(), artifact.getArtifactId(), artifact.getVersion(),
                                    artifact.getExtension(), artifact.getClassifier()) == null) {
                                initAir(artifact.getVersion());
                            }
                        } else if (artifact.getGroupId().equals("com.adobe") && artifact.getArtifactId().equals("fontkit")) {
                            if(resolve(artifact.getGroupId(), artifact.getArtifactId(), artifact.getVersion(),
                                    artifact.getExtension(), artifact.getClassifier()) == null) {
                                initFontkit();
                            }
                        }
                    } finally {
                        internalLookup = false;
                    }
                }
            }
        }
    }

    protected org.apache.maven.artifact.Artifact resolve(String groupId, String artifactId, String version,
                                                         String type, String classifier) {
        org.apache.maven.artifact.Artifact artifact;
        if((classifier == null) || (classifier.length() == 0)) {
            artifact = repositorySystem.createArtifact(groupId, artifactId, version, type);
        } else {
            artifact = repositorySystem.createArtifactWithClassifier(groupId, artifactId, version, type, classifier);
        }
        if (!artifact.isResolved()) {
            try {
                MavenSession mavenSession = plexusContainer.lookup(MavenSession.class);
                ArtifactResolutionRequest req = new ArtifactResolutionRequest();
                req.setArtifact(artifact);
                req.setLocalRepository(mavenSession.getLocalRepository());
                req.setRemoteRepositories(mavenSession.getRequest().getRemoteRepositories());
                ArtifactResolutionResult res = repositorySystem.resolve(req);
                if (!res.isSuccess()) {
                    return null;
                }
            } catch (Exception e) {
                return null;
            }
        }
        return artifact;
    }

    protected void initFlex(String version) throws MavenExecutionException {
        logger.info("===========================================================");
        logger.info(" - Installing Apache Flex SDK " + version);
        try {
            MavenSession mavenSession = plexusContainer.lookup(MavenSession.class);
            File localRepoBaseDir = new File(mavenSession.getLocalRepository().getBasedir());
            DownloadRetriever downloadRetriever = new DownloadRetriever();
            File sdkRoot = downloadRetriever.retrieve(SdkType.FLEX, version);

            // In order to compile some of the themes, we need to download a
            // playerglobal version.
            logger.info("In order to convert the Apache Flex SDK, a Flash SDK has to be downloaded.");
            File flashSdkRoot = downloadRetriever.retrieve(SdkType.FLASH, "10.2");
            FileUtils.copyDirectory(flashSdkRoot, sdkRoot);

            FlexConverter converter = new FlexConverter(sdkRoot, localRepoBaseDir);
            converter.convert();
        } catch (Exception ce) {
            logger.error("Error", ce);
            ce.printStackTrace();
            throw new MavenExecutionException(
                    "Caught exception while downloading and converting artifact.", ce);
        }
        logger.info(" - Finished installing Apache Flex SDK " + version);
    }

    protected void initFlash(String version) throws MavenExecutionException {
        logger.info("===========================================================");
        logger.info(" - Installing Adobe Flash SDK " + version);
        try {
            MavenSession mavenSession = plexusContainer.lookup(MavenSession.class);
            File localRepoBaseDir = new File(mavenSession.getLocalRepository().getBasedir());
            DownloadRetriever downloadRetriever = new DownloadRetriever();
            File sdkRoot = downloadRetriever.retrieve(SdkType.FLASH, version);
            FlashConverter converter = new FlashConverter(sdkRoot, localRepoBaseDir);
            converter.convert();
        } catch (Exception ce) {
            throw new MavenExecutionException(
                    "Caught exception while downloading and converting artifact.", ce);
        }
        logger.info(" - Finished installing Adobe Flash SDK " + version);
    }

    protected void initAir(String version) throws MavenExecutionException {
        logger.info("===========================================================");
        logger.info(" - Installing Adobe AIR SDK " + version);
        try {
            MavenSession mavenSession = plexusContainer.lookup(MavenSession.class);
            File localRepoBaseDir = new File(mavenSession.getLocalRepository().getBasedir());
            DownloadRetriever downloadRetriever = new DownloadRetriever();
            File sdkRoot = downloadRetriever.retrieve(SdkType.AIR, version);
            AirConverter converter = new AirConverter(sdkRoot, localRepoBaseDir);
            converter.convert();
        } catch (Exception ce) {
            throw new MavenExecutionException(
                    "Caught exception while downloading and converting artifact.", ce);
        }
        logger.info(" - Finished installing Adobe AIR SDK " + version);
    }

    protected void initFontkit() throws MavenExecutionException {
        logger.info("===========================================================");
        logger.info(" - Installing Adobe Fontkit libraries");
        try {
            MavenSession mavenSession = plexusContainer.lookup(MavenSession.class);
            File localRepoBaseDir = new File(mavenSession.getLocalRepository().getBasedir());
            DownloadRetriever downloadRetriever = new DownloadRetriever();
            File sdkRoot = downloadRetriever.retrieve(SdkType.FONTKIT);
            FontkitConverter converter = new FontkitConverter(sdkRoot, localRepoBaseDir);
            converter.convert();
        } catch (Exception ce) {
            throw new MavenExecutionException(
                    "Caught exception while downloading and converting artifact.", ce);
        }
        logger.info(" - Finished installing Adobe Fontkit libraries");
    }


    protected void showFlexSplashScreen() {
        logger.info("                                                                   \n" +
                "                                          `,;':,                :';;;  \n" +
                "                                         `:;''';'             `++'';;, \n" +
                "                                         :;'''++;'           .+'+''';;;\n" +
                "                              :          ;'''++++''         ,';+++''';'\n" +
                "                  ,. `,  ,. ..: , `,    `'''+++##;'',      ;;'+#+++''''\n" +
                "                 ; ; ; ;; ;`: :,: ; ;    ;'+++;  #;;;;;:::;;;;+  +++'':\n" +
                "                 ; ; : ;; ;., : : ;.     ;;++#    ';;;;;;;;;;+   .+++; \n" +
                "                 `;: :; `;: :;: , :;`     +;+#    ,;;;:::::;:    ;#+', \n" +
                "      ;++++:'++      :                ;+,; ++;#    +;::::::;    ,+;;:  \n" +
                "     ++++++,'++                  `++'       +'''`   ;::::::,   +:;;:   \n" +
                "    `+++.   '++    ++++++  +++   +++         '''''   ;:::::   :;;;;    \n" +
                "    +++`    '++   ++++++++ +++` `++:         :'';;;   ;::`   :::::     \n" +
                "    +++     '++  +++'  :++: +++ +++           ;;;;;'        ::::::     \n" +
                "    +++     '++  +++    ++' `+++++`           ;;;;;;:      .:::::`     \n" +
                "    +++++++ '++  +++:::+++.  +++++            ;;;;;;;      ,:::::      \n" +
                "    +++++++ '++  +++++++++   :+++'            ;;;;;;;      ,:::::      \n" +
                "    +++'''  '++  +++;;;:`    +++++            ;;;;;;`      ::::::.     \n" +
                "    +++     '++  +++        +++ +++           ;;;;;:        ::::::     \n" +
                "    +++     :++. ++++   `  :++, ,++;         ''';;.   `..:   ::::;`    \n" +
                "    +++      ++'  +++++++  +++   +++        :''';    ,,,,,:   ;;;;;    \n" +
                "    ;++`     +++   ++++++ +++     +++      .+';+    :,,,,,,:   `';;;   \n" +
                "     ++'                                  `+'''    ::,,,,,:::    ';;'  \n" +
                "     :++                                  #;''    +:::,,,::::    .'':; \n" +
                "                                         ';;''   ::::::::::::'   ,';;:.\n" +
                "                                         ;;;;''`;+;;::`  .::;;'.,';;;;:\n" +
                "                                        `::;;;''':;;       `;;;'';;;;;;\n" +
                "                                         :::;;;'';:          ;;';;;;;:;\n" +
                "                                         ,:::;;;',            ',;;;;::`\n" +
                "                                          .:::;:.              ;:;;::: \n" +
                "                                           ::;,                 `,;;`  \n");
        flexSplashScreenShown = true;
    }

}
