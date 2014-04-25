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

REM This generates the ASDoc for Engine and SInC. Modify the path as you need.
"C:\flexsdk4.1\bin\asdoc" -source-path ..\AdobeSpellingUI\src ..\AdobeSpellingUITLF\src ..\AdobeSpellingEngine\src ..\AdobeLinguisticUtils\src ..\AdobeSpellingFramework\src -doc-classes com.adobe.linguistics.spelling.SpellUI com.adobe.linguistics.spelling.SpellUIForTLF com.adobe.linguistics.spelling.HunspellDictionary com.adobe.linguistics.spelling.SpellChecker com.adobe.linguistics.spelling.UserDictionary com.adobe.linguistics.utils.TextTokenizer com.adobe.linguistics.utils.Token com.adobe.linguistics.spelling.framework.ResourceTable com.adobe.linguistics.spelling.framework.SpellingConfiguration com.adobe.linguistics.spelling.framework.SpellingService com.adobe.linguistics.spelling.ui.IHighlighter com.adobe.linguistics.spelling.ui.HaloHighlighter com.adobe.linguistics.spelling.ui.SparkHighlighter com.adobe.linguistics.spelling.ui.TLFHighlighter -library-path ..\AdobeSpellingEngine\bin  ..\AdobeLinguisticUtils\bin ..\AdobeSpellingUI\bin ..\AdobeSpellingUITLF\bin "C:\flexsdk4.1\frameworks\libs" -exclude-dependencies=true -examples-path "..\ASDocExamples" -output Release\SquigglyDoc -main-title "Squiggly API Documentation 0.5" -package com.adobe.linguistics.spelling "This package providing spell checking functionality to your action script applications. This includes the core spell checking engine and the optional SpellUI class for easy integration with your existing Flex projects." -package com.adobe.linguistics.spelling.ui "This package provides text highlighting related functionalities" -package com.adobe.linguistics.spelling.framework "This package provides spelling service and spelling configuration related functionalities" -package com.adobe.linguistics.utils "This package provides text parsing and tokenizing related classes"
