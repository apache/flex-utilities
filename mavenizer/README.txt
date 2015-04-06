/////////////////////////////////////////////////////////////////////////////////////////
The Mavenizer tool is used to convert the Apache and Adobe Flex SDKs and Air SDKs into
Maven artifacts. Automatically creating the Directories, pom-files, copying and moving 
the resources to the correct destinations.

These artifacts can be used in Maven builds using the Flexmojos plugin (Starting with
version 6.x).
/////////////////////////////////////////////////////////////////////////////////////////

The generator automatically converts the desired FDKs into a mavenized form, all you 
need, is to download and unzip the archives containing the sdks and execute the 
generator passing in the source and target directory as parameter. 

The Generator doesn't stupidly copy all java libraries to the destination, but checks
if the given artifact has already been deployed to maven central or by deploying an
other FDK previously. For this check you do need an internet connection to do the
conversion, otherwise I think this will probably take forever.

Internally it consists of 3 components: 
- One for deploying the Flash artifacts
- One for deploying the Air artifacts
- One for deploying the Flex artifacts

As the Adobe FDKs all contained the AIR SDK and the Flash runtime the FDK directories
are processed by each of the FDK directories. When deploying the Flex SDK the references
to the flash and air artifacts are done based upon the playerglobal.swc and 
airglobal.swc. The Generator compares the checksum of the file contained in the FDK
with that of already deployed artifacts (I think in one of the 3.x FDKs the 
"AIR SDK Readme.txt" stated the version to be a different version than it actually was).

The Flash version used isn't detected by looking at the playerglobal.swc but by having
a look at the content of the file "flex-config.xml" in the directory 
"{fdkroot}/frameworks". Unfortunately I couldn't find a similar reference to a desired
AIR version in any of the config files.

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
								!!! WARNING !!!
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
I would suggest not to generate the artifacts into your local repo directly, but
to generate it to an empty directory and then move it from there.
/////////////////////////////////////////////////////////////////////////////////////////

Here come the steps needed to build the Generator (Assuming you already have a working
Maven installation)

1. Checkout the code (The directory containing the pom.xml I will call {home} from now on)
2. Go to the directory {home}
3. Execute "mvn package"

You should now have a jar file called flex-sdk-converter-1.0.0.jar in your {home}/core/target
directory.

Using the generator:

1. Prepare the source directory:
	a) Create a directory anywhere (I will call it {sdkhome} from now on).
	b) Create a directory {sdkhome}/air (optionally if you want to deploy Air SDKs).
		I) Copy the AIR SDK archives you downloaded into {sdkhome}/air 
		II) Unpack the archives in that directory, so the path to the "AIR SDK Readme.txt"
		    is as follows "{sdkhome}/air/AdobeAIRSDK-{Airversion}-{Airplatform}/AIR SDK Readme.txt"
			(Actually the name of the "AdobeAIRSDK-*" directory doesn't matter, it's just important
			for the sequence in which the artifacts are generated)
	c) Create a directory {sdkhome}/flex (optionally if you want to deploy Flex SDKs).
		I) Copy the Flex SDK archives you downloaded into {sdkhome}/flex
		II) Unpack the archived in that directory, so the path to the "flex-sdk-description.xml"
		    is as follows "{sdkhome}/flex/flex_sdk_{Flexversion}/flex-sdk-description.xml"
			(Actually the name of the "flex_sdk_*" directory doesn't matter, it's just important
			for the sequence in which the artifacts are generated)
	d) Create a directory anywhere which will contain the output (I will call it {fdktarget} 
	   from now on)
	e) Change to the directory {home}/core/target
	f) Execute the following command: "java -cp flex-sdk-converter-1.0.0.jar "{sdkhome}" "{fdktarget}""
	   (You should wrap the both directory names in double-quotes if they contain spaces)

/////////////////////////////////////////////////////////////////////////////////////////
Some notes to things I noticed in dealing with some of the SDKs
/////////////////////////////////////////////////////////////////////////////////////////
	   
Flex SDK 2.0:
- Version is strange "3.0 Moxie M2.180927". Has to be changed to 2.0.1.180927 in flex-sdk-description.xml 

With the first three Flex SDKs (3.0.0.477A, 3.0.1.1732A and 3.2.0.3958A) I did have some 
trouble finding out the AIR version as well as the binary artifacts. The sizes and 
checksums of the airglobal.swc didnt match any of the official AIR artifacts and the adl 
command didn't output a version. Currently without tweaking these FDKs are generated 
without working AIR support.
If however you need one of these FDKs you can simply make the generator use the air 
version you want, by copying the airglobal.swc of the version you want to use into the
directory "{fdkroot}/frameworks/libs/air" assuming you have deployed any FDK or Air SDK 
containing that version of airglobal, the generator will correctly add dependencies to
that AIR version.

Flex 4.8.0.1359417:
- Needs a "player" directory in "framework" in order to execute compc (Copy from Flex 4.6.0).
- Needs all the dependencies in place "textlayout", "osmf" and the stuff that needs to
  be copied into the "{fdkroot}/lib/external" and "{fdkroot}/lib/external/optional" 
  directories. For more instructions on this, please read the README.txt in the root of
  Your FDK.
- Needs to detect the AIR version the FDK is compatible with, this is currently determined 
  by checking the version of the airglobal.swc in the framework/libs/air/airglobal.swc. 
  Simply copy this from the 4.6 FDK

/////////////////////////////////////////////////////////////////////////////////////////
Some of the urls to access the binary distributions:  
/////////////////////////////////////////////////////////////////////////////////////////
  
AIR SDKs (From Adobe):  
http://helpx.adobe.com/air/kb/archived-air-sdk-version.html

Flex SDKs (From Adobe):
(Unfortunately the page seems messed-up, but you can get the URLs from there)
http://sourceforge.net/adobe/flexsdk/wiki/downloads/

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


