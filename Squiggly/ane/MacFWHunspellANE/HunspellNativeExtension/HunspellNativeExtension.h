////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

#ifndef HunspellNativeExtension_HunspellNativeExtension_h
#define HunspellNativeExtension_HunspellNativeExtension_h

#include<map>
#define HUNSPELL_INIT_FAIL -1
#define RESOURCE_FILES_MISSING -2

#define HUNSPELL_INIT_SUCCESS 1


typedef std::map< std::string, Hunspell * > Hunspell_cache_type;
typedef std::map< std::string, Hunspell * >::iterator Hunspell_cache_iterator;

static Hunspell_cache_type Hunspell_cache;

//Hunspell * getHunspellObject(std::string locale);

#endif
