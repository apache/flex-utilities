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
package org.apache.flex.utilities.converter.deployer.maven;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: fthomas
 * Date: 11.08.12
 * Time: 18:17
 *
 * @author Frederic Thomas
 * @author Jose Barragan
 */
public class MavenDeployer {

    private String directory;
    private String repositoryId;
    private String url;
    private String mvn;

    /**
     * @param parameters
     */
    public MavenDeployer(String[] parameters) {
        super();
        this.directory = parameters[0];
        this.repositoryId = parameters[1];
        this.url = parameters[2];
        this.mvn = parameters[3];
    }

    public static void main(String[] args) {
        if (args.length != 4) {
            printUsage();
            System.exit(0);
        }

        MavenDeployer deployer = new MavenDeployer(args);
        deployer.start();
    }

    private static void printUsage() {
        System.out.println("\nUsage: java -cp flex-sdk-converter-1.0.jar org.apache.flex.utilities.converter.deployer.maven.SDKDeployer \"directory\" \"repositoryId\" \"url\" \"mvn\"\n");
        System.out.println("The org.apache.flex.utilities.converter.deployer.maven.SDKDeployer needs 4 ordered parameters separated by spaces:");
        System.out.println("\t1- directory: The path to the directory to deploy.");
        System.out.println("\t2- repositoryId: Server Id to map on the <id> under <server> section of settings.xml.");
        System.out.println("\t3- url: URL where the artifacts will be deployed.");
        System.out.println("\t4- mvn: The path to the mvn.bat / mvn.sh.");
    }

    private void start() {
        try {
            File dir = new File(directory);

            doDir(dir);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    private void doDir(File dir) throws IOException, InterruptedException {
        File[] listFiles = dir.listFiles(new PomFilter());
        if (listFiles != null) {
            for (File pom : listFiles) {
                doPom(pom);
            }
        }

        File[] listDirs = dir.listFiles(new DirFilter());
        if (listDirs != null) {
            for (File subdir : listDirs) {
                doDir(subdir);
            }
        }
    }

    private void doPom(File pom) throws IOException, InterruptedException {
        File base = pom.getParentFile();
        final String fileName = pom.getName();
        String artifactName = fileName.substring(0, fileName.lastIndexOf("-"));

        if (artifactName != null) {
            File artifacts[] = new File(pom.getParent()).listFiles(new ArtifactFilter());
	        List<String> processCmdBase = new ArrayList<String>(10);
	        processCmdBase.add(mvn);
	        processCmdBase.add("deploy:deploy-file");
	        processCmdBase.add("-DrepositoryId=" + repositoryId);
	        processCmdBase.add("-Durl=" + url);

	        ProcessBuilder processBuilder = null;


            String packaging;
            String classifier = null;

	        List<String> processCmd = null;
            if (artifacts != null && artifacts.length > 0) {
                for (File artifact : artifacts) {
	                processCmd = new ArrayList<String>(10);
	                processCmd.addAll(processCmdBase);
                    classifier = packaging = null;
                    artifactName = artifact.getName();

                    packaging = (artifactName.endsWith("rb.swc")) ? "rb.swc" : artifactName.substring(artifactName.lastIndexOf(".") + 1);

                    try {
                        classifier = artifactName
                                .substring(artifactName.indexOf(base.getName()) + base.getName().length() + 1, artifactName.length() - packaging.length() - 1);
                    } catch (StringIndexOutOfBoundsException ex) {/*has no classifier*/}

	                processCmd.add("-Dfile=" + artifact.getAbsolutePath());
	                processCmd.add("-DpomFile=" + pom.getAbsolutePath());
                    if (classifier != null && classifier.length() > 0) {
	                    processCmd.add("-Dclassifier=" + classifier);
                    }
	                processCmd.add("-Dpackaging=" + packaging);
	                processBuilder = new ProcessBuilder(processCmd);
	                exec(processBuilder.start());
                }
            } else {
	            processCmd = new ArrayList<String>(10);
	            processCmd.addAll(processCmdBase);
	            processCmd.add("-Dfile=" + pom.getAbsolutePath());
	            processCmd.add("-DpomFile=" + pom.getAbsolutePath());
	            processBuilder = new ProcessBuilder(processCmd);
	            exec(processBuilder.start());
            }

        }
    }

    private void exec(Process p) throws InterruptedException, IOException {
        String line;
        BufferedReader bri = new BufferedReader(new InputStreamReader(p.getInputStream()));
        BufferedReader bre = new BufferedReader(new InputStreamReader(p.getErrorStream()));
        while ((line = bri.readLine()) != null) {
            System.out.println(line);
        }
        while ((line = bre.readLine()) != null) {
            System.out.println(line);
        }
        p.waitFor();
        bri.close();
        bre.close();
        System.out.println("Done.");
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
            return !pathname.getName().endsWith(".pom");
        }
    }
}
