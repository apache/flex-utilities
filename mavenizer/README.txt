1. Download all the SDKs (Flex & AIR).
2. Extract all of them into one directory.
3. Modify the "flex-sdk-description.xml" of the Flex SDK 2.0.1.180927 so the version is "2.0.1"
4. Create a target directory where all the artifacts will be generated.
5. Execute the tool:
    java SDKGenerator "source-directory" "target-directory"

Flex SDK 2.0:
- Version is strange "3.0 Moxie M2.180927". Has to be changed to 2.0.1.180927 in flex-sdk-description.xml

Flex 3.0.0.477A:
- Create text-file called "AIR SDK Readme.txt" in the Flex 3.0.0.477A SDK with following content:
Adobe AIR 1.?.? SDK

Flex 3.0.1.1732A:
- Create text-file called "AIR SDK Readme.txt" in the Flex 3.0.1.1732A SDK with following content:
Adobe AIR 1.?.? SDK

Flex 3.2.0.3958A:
- Create text-file called "AIR SDK Readme.txt" in the Flex 3.1.0.2710A SDK with following content:
Adobe AIR 1.?.? SDK

Flex 4.8.0.1359417:
- Needs "player" directory in "framework" in order to execute compc (Copy from Flex 4.6.0).
- "osmf" and "textlayout" are not included in 4.8.0 so they need to be copied from 4.6.0 (Rember to also copy the RSLs)
- Needs to detect the AIR version the FDK is compatable with, this is currently determined by checking the version of
    the airglobal.swc in the framework/libs/air/airglobal.swc. Simply copy this from the 4.6 FDK
