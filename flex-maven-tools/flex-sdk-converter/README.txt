Apache Flex SDK Converter
=========================
	The Mavenizer tool is used to convert the Apache and Adobe Flex SDKs and Air
	SDKs into Maven artifacts. Automatically creating the Directories, pom-files,
	copying and moving the resources to the correct destinations.

	These artifacts can be used in Maven builds using the Flexmojos plugin
	(Starting with version 6.x).

	The Apache Flex SDK Converter comes with all the means to download, convert
	and deploy a mavenized form of an Apache Flex SDK.

    The Converter does not simply copy all java libraries to the destination; it checks
    if the given artifact has already been deployed to maven central or by deploying an
    other FDK previously. For this check you do need an internet connection to do the
    conversion, otherwise it will probably take forever.

    Internally it consists of 3 components:
    - One Retriever
    	- DownloadRetriever: For downloading binary artifacts
    - Four Converters
    	- One for producing the Apache Flex SDK artifacts
    	- One for producing the Adobe Flash artifacts
    	- One for producing the Adobe Air artifacts
    	- One for producing the Adobe Fontkit artifacts
    - Two Deployers
    	- One using Aether with no requirement to Maven (Faster, but less configurable)
    	- One using a local Maven installation (A lot slower, but fully configurable)



Getting the latest sources via git
==================================

    Getting the source code is the recommended way to get the Apache Flex SDK
    Converter.

    You can always checkout the latest source via git using the following
    command:

	 git clone https://git-wip-us.apache.org/repos/asf/flex-utilities.git flex-utilities
	 cd flex-utilities/mavenizer
	 git checkout develop

Building the Apache Flex SDK Converter
======================================

    The Apache Flex SDK Converter is a relatively simple project. It requires some
    build tools which must be installed prior to building the compiler and it depends
    on some external software which are downloaded as part of the build process.
    Some of these have different licenses. See the Software Dependencies section
    for more information on the external software dependencies.

Install Prerequisites
---------------------

    Before building the Apache Flex Compiler you must install the following software
    and set the corresponding environment variables using absolute file paths.
    Relative file paths will result in build errors.

    ==================================================================================
    SOFTWARE                                    ENVIRONMENT VARIABLE (absolute paths)
    ==================================================================================

    Java SDK 1.6 or greater (*1)                JAVA_HOME

    Maven 3.1.0 or greater (*1)                 MAVEN_HOME

    ==================================================================================

    *1) The bin directories for MAVEN_HOME and JAVA_HOME should be added to your
        PATH.

        On Windows, set PATH to

            PATH=%PATH%;%MAVEN_HOME%\bin;%JAVA_HOME%\bin

        On the Mac (bash), set PATH to

            export PATH="$PATH:$MAVEN_HOME/bin:$JAVA_HOME/bin"

         On Linux make sure you path include MAVEN_HOME and JAVA_HOME.

Software Dependencies
---------------------

    The Apache Flex SDK Converter uses third-party code that will be downloaded as
    part of the build.

    The Apache Version 2.0 license is in the LICENSE file.

    The following dependencies have licenses which are, or are compatible with,
    the Apache Version 2.0 license.  You will not be prompted to acknowledge the
    download.  Most of the jars are installed in your maven local repository and
    are included in the assembly jars.

TODO: Add them all here ...

Building the Source in the Source Distribution
----------------------------------------------

    The project is built with Apache Maven so for a reference to Maven commands
    please have a look at the Maven documentation.

    When you have all the prerequisites in place and the environment variables
    set (see Install Prerequisites above) use

        cd <mavenizer.dir>
        mvn install

    to download the thirdparty dependencies and build the binary from the source.

    To clean the build, of everything other than the downloaded third-party
    dependencies use

        mvn clean

    The packages can be found in the "target" subdirectories.

    The particularly interesting one is the Standalone Command Line Interface:
    - cli/target/apache-flex-sdk-converter-1.0.0-SNAPSHOT.jar



Using the Apache Flex SDK Converter
===================================

	The CLI (Command Line Interface) allows the Apache Flex SDK Converter
	to be executed from the command-line. Assuming the Java executable is
	available on the current systems path, it can be called using:

 	cd <mavenizer.dir>/cli/target
	java -jar apache-flex-sdk-converter-1.0.0-SNAPSHOT.jar

	If executed without any command, it will output a list of commands and
	available properties.

	In general it is able to perform 4 different commands:

	- help		Prints a list of all commands and options available.
	- list     	Lists all versions and platforms available for download
	- download  Downloads selected versions and assembles an FDK
	- convert   Converts a previously installed (using the installer) or
				assembled (using download command) FDK into a mavenized form.
	- deploy    Uploads previously created maven artifacts to a remote repository.

Some typical usage scenarios
----------------------------

	- Create a mavenized version of a previously installed FDK (Using the installer):
	   	"... -fdkDir <FDK install dir> -mavenDir <maven local repo> convert"

	- Download and create an FDK (Flex 4.14.1 with playerglobal 17.0 and 16.0
		AIR SDK 17.0 for Windows and Mac and the fontkit libs):
   		"... -fdkDir <FDK target dir> -flexVersion 4.14.1 -flashVersions 17.0,16.0 \
   			-airVersion 17.0 -platform WINDOWS,MAC -fontkit download"

	- Download and convert an FDK (FDK assembled in temp directory using Air for
		current systems platform only):
   		"... -flexVersion 4.14.1 -flashVersions 17.0 -airVersion 17.0 -fontkit \
   			-mavenDir <maven local repo> download convert"

	- Deploy a bunch of maven artifacts to a remote maven repository:
   		"... -mavenDir <dir with maven artifacts> -repoUrl <url> \
   			-repoUsername <username> -repoPassword <pasword> deploy"

	- "The works": Download, Convert and Deploy using only temp directories:
   		"... -flexVersion 4.14.1 -flashVersions 17.0 -airVersion 17.0 -fontkit \
   			-repoUrl <url> -repoUsername <username> -repoPassword <pasword> \
   			download convert deploy"


Thanks for using Apache Flex.  Enjoy!

                                          The Apache Flex Project
                                          <http://flex.apache.org>





/////////////////////////////////////////////////////////////////////////////////////////
Some information (HOWTO) to go with the deployer artifacts
/////////////////////////////////////////////////////////////////////////////////////////

The deployers are separate modules. Currently two implementations exist.
1. The Maven deployer (located in deployers/maven/target/maven-deployer-1.0.0-full.jar)
2. The Aether deployer (located in deployers/aether/target/aether-deployer-1.0.0-full.jar)

The Maven-Deployer expects Maven to be installed on your system and issues a set of
commandline commands in order to deploy the artifacts. This is the safest approach if you
haven any special settings that need to be handled in order to deploy the artifacts.

The Aether-Deplyoer uses the Maven-Internal aether libraries to deploy the artifacts from
within the running JVM. This makes this approach a lot faster than the Maven-Deployer.

/////////////////////////////////////////
Usage for the Maven Deployer:
/////////////////////////////////////////

java -cp {home}/deployers/maven/target/maven-deployer-1.0.0-full.jar "directory" "repositoryId" "url" "mvn"

The Maven-Deployer needs 4 ordered parameters separated by spaces:
    1- directory: The path to the directory to deploy.
    2- repositoryId: Server Id to map on the <id> under <server> section of settings.xml.
    3- url: URL where the artifacts will be deployed.
    4- mvn: The path to the mvn.bat / mvn.sh.

/////////////////////////////////////////
Usage for the Maven Deployer:
/////////////////////////////////////////

java -cp {home}/deployers/aether/target/maven-aether-1.0.0-full.jar "directory" "url" ["username" "password]

The Aether-Deployer needs 2 ordered parameters separated by spaces:
    1- directory: The path to the directory to deploy.
    2- url: URL where the artifacts will be deployed.
Optionally you can provide the username and password that is used for deploying artifacts.
    3- username: The username needed to log-in to the remote repository.
    4- password: The password needed to log-in to the remote repository.


