package flex;

import java.io.*;
import java.util.*;
import java.util.zip.*;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import common.BaseGenerator;
import common.MavenMetadata;

/**
 * Created with IntelliJ IDEA.
 * User: cdutz
 * Date: 11.05.12
 * Time: 14:53
 */
public class FlexCompilerGenerator extends BaseGenerator {

    public void process(final File sdkSourceDirectory, final boolean isApache, final File sdkTargetDirectory, final String sdkVersion)
            throws Exception {

        final File sdkCompilerLibsDirectory = new File(sdkSourceDirectory, "lib");
        final List<File> jars = new ArrayList<File>();
        jars.addAll(Arrays.asList(sdkCompilerLibsDirectory.listFiles(new FilenameFilter() {
            public boolean accept(File dir, String name) {
                return name.endsWith(".jar");
            }
        })));

        // The Apache SDKs have an additional "external" directory
        // containing external libs. These have to be added too.
        final File externalLibsDirectory = new File(sdkCompilerLibsDirectory, "external");
        if(externalLibsDirectory.exists() && externalLibsDirectory.isDirectory()) {
            final File[] externalJars = externalLibsDirectory.listFiles(new FilenameFilter() {
                public boolean accept(File dir, String name) {
                    return name.endsWith(".jar");
                }
            });
            jars.addAll(Arrays.asList(externalJars));
        }

        // The Apache SDKs have an additional "optional" directory
        // containing external libs. These have to be added too.
        final File optionalLibsDirectory = new File(externalLibsDirectory, "optional");
        if (optionalLibsDirectory.exists() && optionalLibsDirectory.isDirectory()) {
            final File[] optionalJars = optionalLibsDirectory.listFiles(new FilenameFilter() {
                public boolean accept(File dir, String name) {
                    return name.endsWith(".jar");
                }
            });
            jars.addAll(Arrays.asList(optionalJars));
        }

        // A pom artifact will be generated that has all libs as a dependency.
        final MavenMetadata metadata = new MavenMetadata();
        metadata.setGroupId((isApache) ? "org.apache.flex" : "com.adobe.flex");
        metadata.setArtifactId("compiler");
        metadata.setVersion(sdkVersion);
        metadata.setPackaging("pom");

        // Create an empty pom document.
        final Document pom = createPomDocument(metadata);

        // Get the root element, as we will be adding the dependencies to that.
        final Element root = pom.getDocumentElement();
        // Add a "dependencies" element.
        final Element dependencies = pom.createElementNS(BaseGenerator.MAVEN_SCHEMA_URI, "dependencies");
        root.appendChild(dependencies);

        // Generate artifacts for every jar in the input directories.
        for(final File sourceJarFile : jars) {
            // Calculate a checksum for the current file. We will use this checksum to query maven central
            // in order to find out if this lib has already been published. If it has, there is no need to
            // publish it again under a new name. In case a matching artifact is found the generated FDK
            // will use the already deployed version. Additionally the checksum will be saved and if a
            // fdk generated after this one uses the same version of a lib, the version of the older fdk is
            // used also reducing the amount of jars that have to be re-deployed.
            final String checksum = calculateChecksum(sourceJarFile);

            // Try to get artifact metadata based upon the checksum by looking up the internal cache.
            MavenMetadata artifactMetadata = BaseGenerator.checksums.get(checksum);
            // Reusing artifact from other sdk version.
            if(artifactMetadata != null) {
                System.out.println("Reusing artifact (" + checksum + ") : " + artifactMetadata.getGroupId() + ":" +
                        artifactMetadata.getArtifactId() + ":" + artifactMetadata.getVersion());
                appendArtifact(artifactMetadata, dependencies);
            }
            // Id no artifact was found in the local cache, continue processing.
            else {
                // Do a lookup in maven central.
                artifactMetadata = lookupMetadataForChecksum(checksum);

                // The file was available on maven central, so use that version instead of the one coming with the sdk.
                if(artifactMetadata != null) {
                    appendArtifact(artifactMetadata, dependencies);
                }
                // The file was not available on maven central, so we have to add it manually.
                else {
                    // The artifact name is the name of the jar.
                    final String dependencyArtifactId =
                            sourceJarFile.getName().substring(0, sourceJarFile.getName().lastIndexOf("."));

                    // Generate a new metadata object
                    artifactMetadata = new MavenMetadata();
                    artifactMetadata.setGroupId((isApache) ? "org.apache.flex.compiler" : "com.adobe.flex.compiler");
                    artifactMetadata.setArtifactId(dependencyArtifactId);
                    artifactMetadata.setVersion(sdkVersion);
                    artifactMetadata.setPackaging("jar");

                    // Create the name of the directory that will contain the artifact.
                    final File targetJarDirectory = new File(sdkTargetDirectory,
                            ((isApache) ? "org\\apache\\flex\\compiler\\" : "com\\adobe\\flex\\compiler\\") +
                            artifactMetadata.getArtifactId() + "\\" + artifactMetadata.getVersion());
                    // Create the directory.
                    if(targetJarDirectory.mkdirs()) {
                        // Create the filename of the artifact.
                        final File targetJarFile = new File(targetJarDirectory, artifactMetadata.getArtifactId() + "-" +
                                artifactMetadata.getVersion() + "." + artifactMetadata.getPackaging());

                        // Copy the file to it's destination.
                        copyFile(sourceJarFile, targetJarFile);

                        // Add the dependency to the compiler-poms dependency section.
                        appendArtifact(artifactMetadata, dependencies);
                    } else {
                        throw new RuntimeException("Could not create directory: " + targetJarDirectory.getAbsolutePath());
                    }

                    // Create the pom document that will reside next to the artifact lib.
                    final Document artifactPom = createPomDocument(artifactMetadata);
                    final File artifactPomFile =
                            new File(targetJarDirectory, dependencyArtifactId + "-" + sdkVersion + ".pom");
                    writeDocument(artifactPom, artifactPomFile);

                    // The asdoc library needs us to zip up an additional directory and
                    // deploy that as "asdoc-{version}-template.zip"
                    if("asdoc".equals(dependencyArtifactId)) {
                        final File asdocTemplatesDirectory = new File(sdkSourceDirectory, "asdoc/templates");
                        if(asdocTemplatesDirectory.exists()) {
                            createAsdocTemplatesZip(asdocTemplatesDirectory, targetJarDirectory, sdkVersion);
                        }
                    }
                }

                // Remember the checksum for later re-usage.
                BaseGenerator.checksums.put(checksum, artifactMetadata);
            }
        }

        // Add a reference to the versions pom of the framework. This is needed so the compiler can check which
        // versions of the framework libs belong to the current compiler version. This is especially needed to
        // perform the check if the correct version of framework.swc is included in the dependencies. This step
        // was needed due to the re-deployment of patched FDKs in 2011/2012 in which the framework.swc no longer
        // has the same version as the compiler.
        final MavenMetadata frameworkVersions = new MavenMetadata();
        frameworkVersions.setGroupId((isApache) ? "org.apache.flex" : "com.adobe.flex");
        frameworkVersions.setArtifactId("framework");
        frameworkVersions.setVersion(sdkVersion);
        frameworkVersions.setPackaging("pom");
        appendArtifact(frameworkVersions, dependencies);

        // Write the compiler-pom document to file.
        final File pomFile = new File(sdkTargetDirectory,
                ((isApache) ? "org\\apache\\flex\\compiler\\" : "com\\adobe\\flex\\compiler\\") + sdkVersion + "\\compiler-" + sdkVersion + ".pom");
        writeDocument(pom, pomFile);
    }

    /**
     * Zips up the stuff in the asdoc templates directory.
     *
     * @param asdocTemplatesDirectory asdoc templates directory
     * @param asdocDestinationDir directory containing the asdoc lib
     * @param asdocVersion version of the asdoc lib
     * @throws Exception
     */
    private void createAsdocTemplatesZip(File asdocTemplatesDirectory, File asdocDestinationDir, String asdocVersion) throws Exception {
        // ZIP up every file (not directory) in the framework directory and the entire themes directory.
        final File sourceFiles[] = asdocTemplatesDirectory.listFiles(new FileFilter() {
            public boolean accept(File pathname) {
                return pathname.isFile();
            }
        });
        final File zipInputFiles[] = new File[sourceFiles.length + 1];
        System.arraycopy(sourceFiles, 0, zipInputFiles, 0, sourceFiles.length);
        final File imagesDirectory = new File(asdocTemplatesDirectory, "images");
        zipInputFiles[sourceFiles.length] = imagesDirectory;

        // Add all the content to a zip-file.
        final File targetFile = new File(asdocDestinationDir,
                "asdoc-" + asdocVersion + "-template.zip");
        final ZipOutputStream zipOutputStream = new ZipOutputStream(new FileOutputStream(targetFile));
        for(final File file : zipInputFiles) {
            addFileToZip(zipOutputStream, file, asdocTemplatesDirectory);
        }
        zipOutputStream.close();
    }

    private void addFileToZip(ZipOutputStream zipOutputStream, File inputFile, File rootDirectory) throws Exception {
        // If this is a directory, add all it's children.
        if(inputFile.isDirectory()) {
            final File directoryContent[] = inputFile.listFiles();
            if(directoryContent != null) {
                for(final File file : directoryContent) {
                    addFileToZip(zipOutputStream, file, rootDirectory);
                }
            }
        }
        // If this is a file, add it to the zips output.
        else {
            byte[] buf = new byte[1024];
            final FileInputStream in = new FileInputStream(inputFile);
            final String zipPath = inputFile.getAbsolutePath().substring(rootDirectory.getAbsolutePath().length() + 1);
            zipOutputStream.putNextEntry(new ZipEntry(zipPath));
            int len;
            while ((len = in.read(buf)) > 0) {
                zipOutputStream.write(buf, 0, len);
            }
            zipOutputStream.closeEntry();
            in.close();
        }
    }
}
