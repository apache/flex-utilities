import java.io.*;

/**
 * Created with IntelliJ IDEA.
 * User: fthomas
 * Date: 11.08.12
 * Time: 18:17
 */
public class SDKDeployer {
    private String directory;
    private String repositoryId;
    private String url;
    private String mvn;

    /**
     * @param parameters
     */
    public SDKDeployer(String[] parameters) {
        super();
        this.directory = parameters[0];
        this.repositoryId = parameters[1];
        this.url = parameters[2];
        this.mvn = parameters[3];
    }

    public static void main(String[] args) {
        if (args.length < 4) {
            System.out.println("\nUsage: java -cp flex-sdk-deployer-1.0.jar SDKDeployer \"directory\" \"repositoryId\" \"url\" \"mvn\"\n");
            System.out.println("The SDKDeployer needs 4 ordered parameters separated by spaces:");
            System.out.println("\t1- directory: The path to the directory to deploy.");
            System.out.println("\t2- repositoryId: Server Id to map on the <id> under <server> section of settings.xml.");
            System.out.println("\t3- url: URL where the artifacts will be deployed.");
            System.out.println("\t4- mvn: The path to the mvn.bat / mvn.sh.");
            return;
        }

        SDKDeployer deployer = new SDKDeployer(args);
        deployer.start();
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
            final File artifacts[] = new File(pom.getParent()).listFiles(new ArtifactFilter());
            final String DEPLOY = mvn + " deploy:deploy-file -DrepositoryId=" + repositoryId + " -Durl=" + url;

            String packaging;
            String classifier = null;

            String mavenDeploy = DEPLOY;

            if (artifacts != null && artifacts.length > 0) {
                for (File artifact : artifacts) {
                    classifier = packaging = null;
                    artifactName = artifact.getName();

                    packaging = (artifactName.endsWith("rb.swc")) ? "rb.swc" : artifactName.substring(artifactName.lastIndexOf(".") + 1);

                    try {
                        classifier = artifactName
                                .substring(artifactName.indexOf(base.getName()) + base.getName().length() + 1, artifactName.length() - packaging.length() - 1);
                    } catch (StringIndexOutOfBoundsException ex) {/*has no classifier*/}
                    ;

                    mavenDeploy = DEPLOY;
                    mavenDeploy += " -Dfile=\"" + artifact.getAbsolutePath() + "\"";
                    mavenDeploy += " -DpomFile=\"" + pom.getAbsolutePath() + "\"";
                    if (classifier != null && classifier.length() > 0) {
                        mavenDeploy += " -Dclassifier=\"" + classifier + "\"";
                    }
                    mavenDeploy += " -Dpackaging=\"" + packaging + "\"";
                    exec(mavenDeploy);
                }
            } else {
                mavenDeploy += " -Dfile=\"" + pom.getAbsolutePath() + "\"";
                mavenDeploy += " -DpomFile=\"" + pom.getAbsolutePath() + "\"";
                exec(mavenDeploy);
            }
        }
    }

    private void exec(String exec) throws InterruptedException, IOException {
        System.out.println(exec);
        Process p = Runtime.getRuntime().exec(exec);
        String line;
        BufferedReader bri = new BufferedReader(new InputStreamReader(p.getInputStream()));
        BufferedReader bre = new BufferedReader(new InputStreamReader(p.getErrorStream()));
        while ((line = bri.readLine()) != null) {
            System.out.println(line);
        }
        bri.close();
        while ((line = bre.readLine()) != null) {
            System.out.println(line);
        }
        bre.close();
        p.waitFor();
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
