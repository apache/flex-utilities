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

import org.apache.maven.model.Model;
import org.apache.maven.model.io.xpp3.MavenXpp3Reader;
import org.apache.maven.repository.internal.DefaultArtifactDescriptorReader;
import org.apache.maven.repository.internal.DefaultVersionRangeResolver;
import org.apache.maven.repository.internal.DefaultVersionResolver;
import org.apache.maven.repository.internal.MavenRepositorySystemUtils;
import org.codehaus.plexus.util.xml.pull.XmlPullParserException;
import org.eclipse.aether.DefaultRepositorySystemSession;
import org.eclipse.aether.RepositorySystem;
import org.eclipse.aether.RepositorySystemSession;
import org.eclipse.aether.artifact.Artifact;
import org.eclipse.aether.artifact.DefaultArtifact;
import org.eclipse.aether.connector.basic.BasicRepositoryConnectorFactory;
import org.eclipse.aether.deployment.DeployRequest;
import org.eclipse.aether.deployment.DeploymentException;
import org.eclipse.aether.impl.*;
import org.eclipse.aether.installation.InstallationException;
import org.eclipse.aether.internal.impl.DefaultDependencyCollector;
import org.eclipse.aether.internal.impl.DefaultTransporterProvider;
import org.eclipse.aether.repository.Authentication;
import org.eclipse.aether.repository.LocalRepository;
import org.eclipse.aether.repository.RemoteRepository;
import org.eclipse.aether.spi.connector.RepositoryConnectorFactory;
import org.eclipse.aether.spi.connector.transport.TransporterFactory;
import org.eclipse.aether.spi.connector.transport.TransporterProvider;
import org.eclipse.aether.transport.file.FileTransporterFactory;
import org.eclipse.aether.transport.http.HttpTransporterFactory;
import org.eclipse.aether.transport.wagon.WagonTransporterFactory;
import org.eclipse.aether.util.repository.AuthenticationBuilder;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;

/**
 * Updated Version of the SDKDeployer which no longer relies on an installed Maven
 * system and which performs the deployment inside the VM without having to spawn new
 * VMs for each artifact in order to deploy the files using a Maven commandline
 * execution.
 *
 * Created with IntelliJ IDEA.
 * User: cdutz
 * Date: 03.11.13
 *
 * @author Christofer Dutz
 */
public class SDKInVMDeployer {

    private String directory;
    private String url;
    private String username;
    private String password;


    public SDKInVMDeployer(String[] parameters) {
        this.directory = parameters[0];
        this.url = parameters[1];
        if (parameters.length > 2) {
            this.username = parameters[2];
            this.password = parameters[3];
        }
    }

    public static void main(String[] args) {
        if ((args.length != 2) && (args.length != 4)) {
            printUsage();
            System.exit(0);
        }

        final SDKInVMDeployer deployer = new SDKInVMDeployer(args);
        deployer.start();
    }

    private static void printUsage() {
        System.out.println("\nUsage: java -cp flex-sdk-converter-1.0.jar SDKInVMDeployer \"directory\" \"url\" [\"username\", \"password\"]\n");
        System.out.println("The SDKDeployer needs at least 2 ordered parameters separated by spaces:");
        System.out.println("\t1- directory: The path to the directory containing the artifacts that should be deployed.");
        System.out.println("\t2- url: URL where the artifacts will be deployed.");
        System.out.println("If the targeted repository requires authentication two more parameters have to be provided:");
        System.out.println("\t3- username: The username used to authenticate on the target repository.");
        System.out.println("\t4- password: The password used to authenticate on the target repository.");
    }

    private void start() {
        try {
            final DefaultServiceLocator locator = new DefaultServiceLocator();
            locator.addService(RepositoryConnectorFactory.class, BasicRepositoryConnectorFactory.class);
            locator.addService(VersionResolver.class, DefaultVersionResolver.class);
            locator.addService(VersionRangeResolver.class, DefaultVersionRangeResolver.class);
            locator.addService(ArtifactDescriptorReader.class, DefaultArtifactDescriptorReader.class);
            locator.addService(DependencyCollector.class, DefaultDependencyCollector.class);
            locator.addService(RepositoryConnectorFactory.class, BasicRepositoryConnectorFactory.class);
            locator.addService(TransporterProvider.class, DefaultTransporterProvider.class);
            locator.addService(TransporterFactory.class, FileTransporterFactory.class);
            locator.addService(TransporterFactory.class, HttpTransporterFactory.class);
            locator.addService(TransporterFactory.class, WagonTransporterFactory.class);

            final RepositorySystem repositorySystem = locator.getService(RepositorySystem.class);

            if (repositorySystem == null) {
                System.out.println("Couldn't initialize local maven repository system.");
                System.exit(0);
            } else {
                // Setup the repository system session based upon the current maven settings.xml.
                final DefaultRepositorySystemSession session = MavenRepositorySystemUtils.newSession();
                final LocalRepository localRepo = new LocalRepository(directory);
                RemoteRepository.Builder repoBuilder = new RemoteRepository.Builder("repo", "default", url);
                if ((username != null) && (password != null)) {
                    final Authentication authentication = new AuthenticationBuilder().addUsername(
                            username).addPassword(password).build();
                    repoBuilder.setAuthentication(authentication);
                }
                final RemoteRepository remoteRepository = repoBuilder.build();

                session.setLocalRepositoryManager(repositorySystem.newLocalRepositoryManager(session, localRepo));

                // Process all content of the mavenizer target directory.
                final File rootDir = new File(directory);
                processDir(rootDir, repositorySystem, session, remoteRepository);
            }
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    private void processDir(File curDir, RepositorySystem repositorySystem, RepositorySystemSession session,
                            RemoteRepository remoteRepository)
            throws IOException, XmlPullParserException, InstallationException, DeploymentException {
        // If the current directory contained any poms,
        // process them as artifacts.
        final File[] poms = curDir.listFiles(new PomFilter());
        if (poms != null) {
            for (File pom : poms) {
                processArtifact(pom, repositorySystem, session, remoteRepository);
            }
        }

        // If the current directory contained any directories,
        // continue processing their content.
        final File[] dirs = curDir.listFiles(new DirFilter());
        if (dirs != null) {
            for (File dir : dirs) {
                processDir(dir, repositorySystem, session, remoteRepository);
            }
        }
    }

    private void processArtifact(File pomFile, RepositorySystem repositorySystem, RepositorySystemSession session,
                                 RemoteRepository remoteRepository)
            throws IOException, XmlPullParserException, InstallationException, DeploymentException {
        final Reader reader = new FileReader(pomFile);
        try {
            final File artifactDirectory = pomFile.getParentFile();
            final MavenXpp3Reader xpp3Reader = new MavenXpp3Reader();
            final Model model = xpp3Reader.read(reader);

            // Make the deployer deploy the pom itself.
            final DeployRequest artifactInstallRequest = new DeployRequest();
            artifactInstallRequest.setRepository(remoteRepository);
            Artifact pomArtifact = new DefaultArtifact(
                    model.getGroupId(), model.getArtifactId(), "pom", model.getVersion());
            pomArtifact = pomArtifact.setFile(pomFile);
            artifactInstallRequest.addArtifact(pomArtifact);

            // Add any additional files to this installation.
            final String artifactBaseName = model.getArtifactId() + "-" + model.getVersion();
            final File artifactFiles[] = artifactDirectory.listFiles(new ArtifactFilter());
            for (final File artifactFile : artifactFiles) {
                final String fileName = artifactFile.getName();
                final String classifier;
                // This file has a classifier.
                if (fileName.charAt(artifactBaseName.length()) == '-') {
                    classifier = fileName.substring(artifactBaseName.length() + 1,
                            fileName.indexOf(".", artifactBaseName.length()));
                }
                // This file doesn't have a classifier.
                else {
                    classifier = "";
                }
                final String extension = fileName.substring(
                        artifactBaseName.length() + 1 + ((classifier.length() > 0) ? classifier.length() + 1 : 0));
                Artifact fileArtifact = new DefaultArtifact(model.getGroupId(), model.getArtifactId(),
                        classifier, extension, model.getVersion());
                fileArtifact = fileArtifact.setFile(artifactFile);
                artifactInstallRequest.addArtifact(fileArtifact);
            }

            // Actually install the artifact.
            System.out.println("Installing Artifact: " + pomArtifact.getGroupId() + ":" +
                    pomArtifact.getArtifactId() + ":" + pomArtifact.getVersion());
            for (final Artifact artifact : artifactInstallRequest.getArtifacts()) {
                System.out.println(" - File with extension " + artifact.getExtension() +
                        ((artifact.getClassifier().length() > 0) ? " and classifier " + artifact.getClassifier() : ""));
            }

            repositorySystem.deploy(session, artifactInstallRequest);
        } finally {
            reader.close();
        }
    }

    private class PomFilter implements java.io.FileFilter {
        @Override
        public boolean accept(File pathname) {
            return pathname.getName().endsWith(".pom");
        }
    }

    private class DirFilter implements java.io.FileFilter {
        @Override
        public boolean accept(File pathname) {
            return pathname.isDirectory();
        }
    }

    private class ArtifactFilter implements java.io.FileFilter {
        @Override
        public boolean accept(File pathname) {
            return !pathname.getName().endsWith(".pom") && !pathname.isDirectory();
        }
    }

}
