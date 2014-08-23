@echo off
rem Licensed to the Apache Software Foundation (ASF) under one or more
rem contributor license agreements.  See the NOTICE file distributed with
rem this work for additional information regarding copyright ownership.
rem The ASF licenses this file to You under the Apache License, Version 2.0
rem (the "License"); you may not use this file except in compliance with
rem the License.  You may obtain a copy of the License at
rem
rem     http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.

REM This copies dictionaries and libs to Release folder, do this after you build them in Flex builder 3/4
mkdir Release
mkdir Release\SquigglySDK
mkdir Release\SquigglySDK\libs
mkdir Release\SquigglySDK\src
mkdir Release\SquigglySDK\src\dictionaries
mkdir Release\SquigglySDK\src\dictionaries\en_US
copy ..\AdobeSpellingEngine\bin\AdobeSpellingEngine.swc .\Release\SquigglySDK\libs
copy ..\AdobeSpellingUI\bin\AdobeSpellingUI.swc .\Release\SquigglySDK\libs
copy ..\AdobeSpellingUIEx\bin\AdobeSpellingUIEx.swc .\Release\SquigglySDK\libs
copy ..\AdobeSpellingUITLF\bin\AdobeSpellingUITLF.swc .\Release\SquigglySDK\libs
copy ..\AdobeSpellingFramework\bin\AdobeSpellingFramework.swc .\Release\SquigglySDK\libs
copy ..\AdobeLinguisticUtils\bin\AdobeLinguisticUtils.swc .\Release\SquigglySDK\libs
copy ..\..\releases\0.3\Dictionary\en_US.* .\Release\SquigglySDK\src\dictionaries\en_US
copy ..\..\releases\0.3\Dictionary\*.txt .\Release\SquigglySDK\src\dictionaries\en_US
copy ..\*.pdf .\Release\SquigglySDK\src\dictionaries\en_US
copy ..\*.txt .\Release\SquigglySDK
copy ..\..\releases\0.3\Dictionary\*.xml .\Release\SquigglySDK\src

