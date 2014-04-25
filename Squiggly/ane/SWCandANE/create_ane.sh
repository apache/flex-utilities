#!/bin/sh
################################################################################
##
##  Licensed to the Apache Software Foundation (ASF) under one or more
##  contributor license agreements.  See the NOTICE file distributed with
##  this work for additional information regarding copyright ownership.
##  The ASF licenses this file to You under the Apache License, Version 2.0
##  (the "License"); you may not use this file except in compliance with
##  the License.  You may obtain a copy of the License at
##
##      http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.
##
################################################################################

set -x

FLEX_SDK=/Applications/Adobe\ Flash\ Builder\ 4.6/sdks/4.5.1-air3.0

if [[ $# = 1 ]] ; then 
    FLEX_SDK="$1"
fi 

JAR="/usr/bin/jar"

PASS=adobe	# Others used: none, test

rm -rf extensions/src/assets
rm -f HunspellNativeExtension.ane

mkdir -p extensions/src/assets
cp "./HunspellNativeExtension.swc" extensions/src/assets

mkdir -p extensions/src/assets/swc-contents
pushd extensions/src/assets/swc-contents
$JAR xf ../HunspellNativeExtension.swc catalog.xml library.swf
popd

mkdir -p extensions/src/assets/platform
mkdir -p extensions/src/assets/platform/mac
mkdir -p extensions/src/assets/platform/windows

cp -R "../MacFWHunspellANE/HunspellNativeExtension/build/Release/HunspellNativeExtension.framework"	\
    extensions/src/assets/platform/mac
cp -f "./extensions/src/windows/HunspellNativeExtension.dll"	\
extensions/src/assets/platform/windows
cp extensions/src/assets/swc-contents/library.swf extensions/src/assets/platform/mac
cp extensions/src/assets/swc-contents/library.swf extensions/src/assets/platform/windows
cp "./AdobeGtlibTeam.p12" extensions/src/assets/AdobeGtlibTeam.p12
echo "testing"
echo
ls -l "$FLEX_SDK"/lib/adt.jar
echo

"$FLEX_SDK"/bin/adt -package	\
    -storetype PKCS12 -keystore extensions/src/assets/AdobeGtlibTeam.p12 -storepass $PASS	\
    -target ane HunspellNativeExtension.ane extensions/src/extension.xml	\
    -swc HunspellNativeExtension.swc	\
    -platform Windows-x86 -C extensions/src/assets/platform/windows/ library.swf   \
    HunspellNativeExtension.dll    \
    -platform MacOS-x86	\
    -C extensions/src/assets/platform/mac .

