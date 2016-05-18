package org.apache.flex.utilities.converter.mavenextension;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.flex.utilities.converter.air.AirConverter;
import org.apache.flex.utilities.converter.flash.FlashConverter;
import org.apache.flex.utilities.converter.flex.FlexConverter;
import org.apache.flex.utilities.converter.fontkit.FontkitConverter;
import org.apache.flex.utilities.converter.retrievers.download.DownloadRetriever;
import org.apache.flex.utilities.converter.api.ProxySettings;
import org.apache.flex.utilities.converter.retrievers.types.PlatformType;
import org.apache.flex.utilities.converter.retrievers.types.SdkType;
import org.apache.flex.utilities.converter.wrapper.WrapperConverter;
import org.apache.maven.MavenExecutionException;
import org.apache.maven.artifact.resolver.ArtifactResolutionRequest;
import org.apache.maven.artifact.resolver.ArtifactResolutionResult;
import org.apache.maven.eventspy.AbstractEventSpy;
import org.apache.maven.execution.ExecutionEvent;
import org.apache.maven.execution.MavenSession;
import org.apache.maven.repository.RepositorySystem;
import org.codehaus.plexus.logging.Logger;
import org.eclipse.aether.RepositoryEvent;
import org.eclipse.aether.artifact.Artifact;

import javax.inject.Inject;
import javax.inject.Named;
import javax.inject.Singleton;
import java.io.File;
import java.net.Authenticator;
import java.net.PasswordAuthentication;

/**
 * Maven EventSpy that listens for resolution requests and in case of Flex related
 * artifacts, it pre-checks their availability. If they are not available, it uses
 * the apache flex sdk converter to automatically download and convert the missing
 * artifacts before continuing the build normally.
 *
 * Created by christoferdutz on 17.04.15.
 */
@Named
@Singleton
public class FlexEventSpy extends AbstractEventSpy {

    @Inject
    protected RepositorySystem repositorySystem;

    @Inject
    protected Logger logger;

    protected MavenSession mavenSession;

    protected boolean internalLookup = false;
    protected boolean flexSplashScreenShown = false;

    protected ProxySettings proxySettings = null;

    public FlexEventSpy() {
    }

    @Override
    public void init(Context context) throws Exception {
    }

    @Override
    public void onEvent(Object o) throws Exception {
        if(o instanceof ExecutionEvent) {
            mavenSession = ((ExecutionEvent) o).getSession();

            // Get proxy settings from the maven settings and save them in the
            // ProxySettings "singleton".
            org.apache.maven.settings.Proxy settingsProxy = mavenSession.getSettings().getActiveProxy();
            if(settingsProxy != null) {
                String protocol = settingsProxy.getProtocol();
                String host = settingsProxy.getHost();
                int port = settingsProxy.getPort();
                String nonProxyHost = settingsProxy.getNonProxyHosts();
                final String username = settingsProxy.getUsername();
                final String password = settingsProxy.getPassword();
                proxySettings = new ProxySettings(protocol, host, port, nonProxyHost, username, password);
                ProxySettings.setProxySettings(proxySettings);
                if (!StringUtils.isEmpty(proxySettings.getUsername()) &&
                        !StringUtils.isEmpty(proxySettings.getPassword())) {
                    Authenticator authenticator = new Authenticator() {
                        @Override
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(proxySettings.getUsername(),
                                    proxySettings.getPassword().toCharArray());
                        }
                    };
                    Authenticator.setDefault(authenticator);
                }
            }
        } else if(o instanceof RepositoryEvent) {
            RepositoryEvent repositoryEvent = (RepositoryEvent) o;
            if(repositoryEvent.getType() == RepositoryEvent.EventType.ARTIFACT_RESOLVING) {
                if(!internalLookup) {
                    try {
                        internalLookup = true;
                        Artifact artifact = repositoryEvent.getArtifact();

                        if (artifact.getGroupId().startsWith("org.apache.flex") &&
                                !artifact.getGroupId().contains(".flexjs") &&
                                !"rb.swc".equals(artifact.getExtension())) {
                            // Output a cool splash-screen ... sorry for that ... couldn't resist :-)
                            if(!flexSplashScreenShown) {
                                showFlexSplashScreen();
                            }

                            if("org.apache.flex.compiler".equals(artifact.getGroupId()) &&
                                    artifact.getArtifactId().startsWith("falcon-")) {
/*                                logger.info("Falcon artifacts are publicly available as Maven artifacts. " +
                                        "Please setup your Maven configuration.\nFor more information please visit: " +
                                        "https://cwiki.apache.org/confluence/display/FLEX/Building+Flex+applications+with+Maven");*/
                            }
                            else if("org.apache.flex.flexjs.framework".equals(artifact.getGroupId())) {
/*                                logger.info("FlexJS artifacts are publicly available as Maven artifacts. " +
                                        "Please setup your Maven configuration.\nFor more information please visit: " +
                                        "https://cwiki.apache.org/confluence/display/FLEX/Building+Flex+applications+with+Maven");*/
                            }
                            else if(!canResolve(artifact.getGroupId(), artifact.getArtifactId(), artifact.getVersion(),
                                    artifact.getExtension(), artifact.getClassifier())) {
                                logger.info("Couldn't find artifact: " + artifact.getGroupId() + ":" +
                                        artifact.getBaseVersion() + ":" + artifact.getArtifactId() + ":" +
                                        artifact.getExtension());
                                initFlex(artifact.getVersion());
                            }
                        } else if (artifact.getGroupId().startsWith("com.adobe.flash")) {
                            if(!canResolve(artifact.getGroupId(), artifact.getArtifactId(), artifact.getVersion(),
                                    artifact.getExtension(), artifact.getClassifier())) {
                                logger.info("Couldn't find artifact: " + artifact.getGroupId() + ":" +
                                        artifact.getBaseVersion() + ":" + artifact.getArtifactId() + ":" +
                                        artifact.getExtension());
                                initFlash(artifact.getVersion());
                            }
                        } else if (artifact.getGroupId().startsWith("com.adobe.air")) {
                            if(!canResolve(artifact.getGroupId(), artifact.getArtifactId(), artifact.getVersion(),
                                    artifact.getExtension(), artifact.getClassifier())) {
                                logger.info("Couldn't find artifact: " + artifact.getGroupId() + ":" +
                                        artifact.getBaseVersion() + ":" + artifact.getArtifactId() + ":" +
                                        artifact.getExtension());
                                initAir(artifact.getVersion());
                            }
                        } else if (artifact.getGroupId().equals("com.adobe") && artifact.getArtifactId().equals("fontkit")) {
                            if(!canResolve(artifact.getGroupId(), artifact.getArtifactId(), artifact.getVersion(),
                                    artifact.getExtension(), artifact.getClassifier())) {
                                logger.info("Couldn't find artifact: " + artifact.getGroupId() + ":" +
                                        artifact.getBaseVersion() + ":" + artifact.getArtifactId() + ":" +
                                        artifact.getExtension());
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

    protected boolean canResolve(String groupId, String artifactId, String version,
                                                            String type, String classifier) {
        try {
            ArtifactResolutionRequest req = new ArtifactResolutionRequest();
            req.setLocalRepository(mavenSession.getLocalRepository());
            req.setRemoteRepositories(mavenSession.getRequest().getRemoteRepositories());
            if((classifier == null) || (classifier.length() == 0)) {
                req.setArtifact(repositorySystem.createArtifact(groupId, artifactId, version, type));
            } else {
                req.setArtifact(repositorySystem.createArtifactWithClassifier(groupId, artifactId, version, type, classifier));
            }
            ArtifactResolutionResult res = repositorySystem.resolve(req);
            return res.isSuccess();
        } catch (Throwable e) {
            return false;
        }
    }

    protected void initFlex(String version) throws MavenExecutionException {
        logger.info("===========================================================");
        logger.info(" - Installing Apache Flex SDK " + version);
        try {
            File localRepoBaseDir = new File(mavenSession.getLocalRepository().getBasedir());
            DownloadRetriever downloadRetriever = new DownloadRetriever();
            File sdkRoot = downloadRetriever.retrieve(SdkType.FLEX, version, null);

            // In order to create a fully functional wrapper we need to download
            // SWFObject and merge that with the fdk first.
            File swfObjectRoot = downloadRetriever.retrieve(SdkType.SWFOBJECT, null, null);
            FileUtils.copyDirectory(swfObjectRoot, sdkRoot);

            // In order to compile some of the themes, we need to download a
            // playerglobal version.
            logger.info("In order to convert some of the skins in the Apache Flex SDK, " +
                    "a Flash SDK has to be downloaded.");
            File flashSdkRoot = downloadRetriever.retrieve(SdkType.FLASH, "10.2", null);
            FileUtils.copyDirectory(flashSdkRoot, sdkRoot);

            // Convert the FDK itself.
            FlexConverter converter = new FlexConverter(sdkRoot, localRepoBaseDir);
            converter.convert();

            // Convert the wrapper.
            WrapperConverter wrapperConverter = new WrapperConverter(sdkRoot, localRepoBaseDir);
            wrapperConverter.convert();
        } catch (Throwable ce) {
            throw new MavenExecutionException(
                    "Caught exception while downloading and converting artifact.", ce);
        }
        logger.info(" - Finished installing Apache Flex SDK " + version);
    }

    protected void initFlash(String version) throws MavenExecutionException {
        logger.info("===========================================================");
        logger.info(" - Installing Adobe Flash SDK " + version);
        try {
            File localRepoBaseDir = new File(mavenSession.getLocalRepository().getBasedir());
            DownloadRetriever downloadRetriever = new DownloadRetriever();
            File sdkRoot = downloadRetriever.retrieve(SdkType.FLASH, version);
            FlashConverter converter = new FlashConverter(sdkRoot, localRepoBaseDir);
            converter.convert();
        } catch (Throwable ce) {
            throw new MavenExecutionException(
                    "Caught exception while downloading and converting artifact.", ce);
        }
        logger.info(" - Finished installing Adobe Flash SDK " + version);
    }

    protected void initAir(String version) throws MavenExecutionException {
        logger.info("===========================================================");
        logger.info(" - Installing Adobe AIR SDK " + version);
        try {
            File localRepoBaseDir = new File(mavenSession.getLocalRepository().getBasedir());
            DownloadRetriever downloadRetriever = new DownloadRetriever();

            PlatformType platformType;
            if(System.getProperty("platform-type") == null) {
                platformType = PlatformType.getCurrent();
            } else {
                platformType = PlatformType.valueOf(System.getProperty("platform-type"));
            }
            File sdkRoot = downloadRetriever.retrieve(SdkType.AIR, version, platformType);
            AirConverter converter = new AirConverter(sdkRoot, localRepoBaseDir);
            converter.convert();
        } catch (Throwable ce) {
            throw new MavenExecutionException(
                    "Caught exception while downloading and converting artifact.", ce);
        }
        logger.info(" - Finished installing Adobe AIR SDK " + version);
    }

    protected void initFontkit() throws MavenExecutionException {
        logger.info("===========================================================");
        logger.info(" - Installing Adobe Fontkit libraries");
        try {
            File localRepoBaseDir = new File(mavenSession.getLocalRepository().getBasedir());
            DownloadRetriever downloadRetriever = new DownloadRetriever();
            File sdkRoot = downloadRetriever.retrieve(SdkType.FONTKIT);
            FontkitConverter converter = new FontkitConverter(sdkRoot, localRepoBaseDir);
            converter.convert();
        } catch (Throwable ce) {
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
