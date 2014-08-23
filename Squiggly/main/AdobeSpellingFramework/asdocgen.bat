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

REM This generates the ASDoc for Engine and SInC. Modify the path as you need. TODO: move to build folder.
"C:\Program Files\Adobe\Adobe Flash Builder 4\sdks\4.0.0\bin\asdoc" -source-path src -doc-classes com.adobe.linguistics.spelling.framework.ResourceConfig com.adobe.linguistics.spelling.framework.SpellingConfiguration com.adobe.linguistics.spelling.framework.SpellingService com.adobe.linguistics.spelling.framework.UserDictionary -library-path "C:\Program Files\Adobe\Adobe Flash Builder 4\sdks\4.0.0\frameworks\libs" -exclude-dependencies=true -output docs -main-title "AdobeSpellingFramework API Documentation 0.4" -package com.adobe.linguistics.spelling.framework "This package provides spell checking framework for easy integration with the Squiggly spelling engine."
