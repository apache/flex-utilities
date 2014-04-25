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

# Set FLEX_SDK env var to a flex sdk with a serrano air overlay

FLEX_SDK=/Applications/Adobe\ Flash\ Builder\ 4.6/sdks/4.5.1-air3.0
if [[ $# = 1 ]] ; then 
    FLEX_SDK="$1"
fi 

rm -f HunspellNativeExtension.swc

"$FLEX_SDK"/bin/acompc -target-player=13	\
    -source-path src	\
    -include-classes	\
    com.adobe.linguistics.extensions.HunspellNativeExtension	\
    -output=HunspellNativeExtension.swc

