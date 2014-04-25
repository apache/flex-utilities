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

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <dlfcn.h>
#include <string>
#include <Adobe AIR/Adobe AIR.h>

#include "hunspell.hxx"
#include "HunspellNativeExtension.h"
#include "EncConv.h"
#include "Utilities.h"
#define HUNSPELL_INIT_SUCCESS 1

using namespace EncConv;


// Symbols tagged with EXPORT are externally visible.
// Must use the -fvisibility=hidden gcc option.
#define EXPORT __attribute__((visibility("default")))

void* hinstLib;
typedef Hunspell * (*HUNSPELL_INIT)(char *, char*);
typedef int (*HUNSPELL_SPELL)(Hunspell *, char *);
typedef int (*HUNSPELL_SUGGEST)(Hunspell *, char ***, char *);
typedef void (*HUNSPELL_FREE_LIST)(Hunspell *, char ***, int);
typedef char *(*HUNSPELL_GET_ENCODING)(Hunspell *);
typedef void (*HUNSPELL_UNINIT)(Hunspell *);

extern "C"
{
	
    Hunspell * getHunspellObject(std::string locale)
    {
        Hunspell_cache_iterator iter;
        if((iter=Hunspell_cache.find(locale)) == Hunspell_cache.end() )
            return NULL;
        else
            return iter->second;
    }

    
    FREObject talkBack(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
       // const uint8_t *locale = 0;
        const uint8_t *inpWord = 0;
        uint32_t len = 0;
        FREObject retObj=0;
        
        //get first argument
        if(FREGetObjectAsUTF8(argv[0], &len, &inpWord) != FRE_OK)
            return retObj;
        
        FRENewObjectFromUTF8((uint32_t)(strlen((char *)inpWord)),(const uint8_t*)(inpWord), &retObj);
        
        return retObj;
        
    }
    
    
    FREObject initHunspellObject(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]){
        const uint8_t *locale = 0;
        const uint8_t *dictionaryPath = 0;
        uint32_t len = -1;
        FREObject retObj=0;
       
        Hunspell * hunspellObject;
        //get first argument
        if(FREGetObjectAsUTF8(argv[1], &len, &dictionaryPath) != FRE_OK)
            return retObj;
        len = 0;
        
        //get second argument
        if(FREGetObjectAsUTF8(argv[0], &len, &locale) != FRE_OK)
            return retObj;
        
        //check in cache and return if already present
        if(!(Hunspell_cache.find(std::string((char *)locale))==Hunspell_cache.end()))
		{
			FRENewObjectFromInt32(HUNSPELL_INIT_SUCCESS, &retObj);
			return retObj;
		}
        
       // U16Char_t * dic_path_U16= EncConv::convCharStrToU16Str((char *)dictionaryPath, "UTF-8");
       // U16Char_t *locale_U16= EncConv::convCharStrToU16Str((char *)locale, "UTF-8");
  
       // std::wstring aff_file= std::wstring((wchar_t *)dic_path_U16)+std::wstring(L"/Dictionaries/")+std::wstring((wchar_t *)locale_U16)+std::wstring(L"/")+std::wstring((wchar_t *)locale_U16)+std::wstring(L".aff");
       // std::wstring dic_file= std::wstring((wchar_t *)dic_path_U16)+std::wstring(L"/Dictionaries/")+std::wstring((wchar_t *)locale_U16)+std::wstring(L"/")+std::wstring((wchar_t *)locale_U16)+std::wstring(L".dic");
       // std::wstring lib_file= std::wstring((wchar_t *)dic_path_U16)+std::wstring(L"/libhunspell.dylib");
     
        
        
        //creating OS specific aff,dic file paths refer: DanishOS Issue of CS6 AHP 
   //     std::string aff_file_U8= makeString(aff_file.c_str());
   //     std::string dic_file_U8= makeString(dic_file.c_str());
        
        //make the file url's
        std::string lib_file_U8= std::string((char *)dictionaryPath)+std::string("/libhunspell.dylib");
        std::string aff_file_U8= std::string((char *)dictionaryPath)+std::string("/Dictionaries/")+std::string((char *)locale)+std::string("/")+std::string((char *)locale)+std::string(".aff");
        std::string dic_file_U8= std::string((char *)dictionaryPath)+std::string("/Dictionaries/")+std::string((char *)locale)+std::string("/")+std::string((char *)locale)+std::string(".dic");
        
      
    //    fprintf(stderr,"Path, %s", lib_file_U8.c_str());
    //    fprintf(stderr,"Path, %s", aff_file_U8.c_str());
    //    fprintf(stderr,"Path, %s", lib_file_U8.c_str());
        
        
        //check for file is present
        
        if( (FileExists(aff_file_U8.c_str()) && FileExists(dic_file_U8.c_str()) && FileExists(lib_file_U8.c_str())) == false )
        {
            FRENewObjectFromInt32(RESOURCE_FILES_MISSING, &retObj);
            return retObj;
        }
        
        //make a new hunspell object
    //    hinstLib = dlopen("/Users/ugoyal/Desktop/ThirdPartyResources/libhunspell.dylib", RTLD_LAZY); 
        hinstLib = dlopen(lib_file_U8.c_str(), RTLD_LAZY); 
        
        if (hinstLib != NULL) 
        { 
            HUNSPELL_INIT initAdd = (HUNSPELL_INIT) dlsym(hinstLib, "Hunspell_create"); 
            
            // If the function address is valid, call the function.
            
            if (NULL != initAdd) 
            {
                hunspellObject = (initAdd) ((char *)aff_file_U8.c_str(), (char *)dic_file_U8.c_str());
              // hunspellObject = (*initAdd)("/Users/ugoyal/Desktop/ThirdPartyResources/Dictionaries/de_DE/de_DE.aff","/Users/ugoyal/Desktop/ThirdPartyResources/Dictionaries/de_DE/de_DE.dic");
            }
            
        } 
        
        //add to hunspell cache	
        if(Hunspell_cache.find(std::string((char *)locale))==Hunspell_cache.end())	
            Hunspell_cache[std::string((char *)locale)]= hunspellObject;
        
     
        if(hunspellObject)
        {
            FRENewObjectFromInt32(HUNSPELL_INIT_SUCCESS, &retObj);
        }
        else
        {
            FRENewObjectFromInt32(HUNSPELL_INIT_FAIL, &retObj);
        }
        
        return retObj;
    }
    
    FREObject checkWord(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        const uint8_t *locale = 0;
        const uint8_t *inpWord = 0;
        uint32_t len = -1;
        FREObject retObj=0;
        int rv=0;
        
        U16Char_t* inpWordU16 = NULL;
        std::string  inpWordDictEncoded;
        bool isConversionUnSuccesful=false;
        //get first argument
        if(FREGetObjectAsUTF8(argv[1], &len, &locale) != FRE_OK)
            return retObj;
        len = 0;
        
        //get second argument
        if(FREGetObjectAsUTF8(argv[0], &len, &inpWord) != FRE_OK)
            return retObj;
        
        //get the hunspell object from cache
        Hunspell * hunspellObject=getHunspellObject(std::string((char *)locale));
		
        if(!hunspellObject) 
            return retObj;
		
        
        //convert input utf8 to u16 string
         inpWordU16 = EncConv::convCharStrToU16Str((char *)inpWord, "UTF-8");
        
        //get dictionary encoding
       HUNSPELL_GET_ENCODING getEncAdd=(HUNSPELL_GET_ENCODING) dlsym(hinstLib, "Hunspell_get_dic_encoding");
        char * m_MainEncoding= (*getEncAdd)(hunspellObject);
        
        //convert u16 to dictionary encoding
        inpWordDictEncoded=EncConv::convU16StrToCharStr(inpWordU16,m_MainEncoding);
        
        if(inpWordDictEncoded.length()==0)
        {
            isConversionUnSuccesful = true;
        }
        
        //Get spellAddress
        HUNSPELL_SPELL spellAdd= (HUNSPELL_SPELL) dlsym(hinstLib, "Hunspell_spell");
        
        //Do spell check with converted word else try with UTF-8
        if((!isConversionUnSuccesful) )
        {
            rv= (*spellAdd)(hunspellObject, (char * )inpWordDictEncoded.c_str());
           
        }
        else
        { 
            rv= (*spellAdd)(hunspellObject, (char * )inpWord);
        }
		
        //return results
        EncConv::releaseU16Str(inpWordU16);
        FRENewObjectFromInt32(rv, &retObj);
        return retObj;
    }
    
    FREObject getSuggestions(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
        const uint8_t *locale = 0;
        const uint8_t *inpWord = 0;
        uint32_t len = -1;
        FREObject retObj=0;
        FREObject oneSuggestion=0;
        
        U16Char_t* inpWordU16 = NULL;
        std::string  inpWordDictEncoded;
        bool isConversionUnSuccesful=false;
        char * oneSuggestionEncoded=NULL;
        U16Char_t * oneSuggestionU16=NULL;
        std::string oneSuggestionU8;
        
        //assign memory to retobj
        FRENewObject((const uint8_t*)"Array", 0, NULL, &retObj, 0);
        
        //get first argument
        if(FREGetObjectAsUTF8(argv[1], &len, &locale) != FRE_OK)
            return retObj;
        len = 0;
        
        //get second argument
        if(FREGetObjectAsUTF8(argv[0], &len, &inpWord) != FRE_OK)
            return retObj;
        
        //get the hunspell object from cache
        Hunspell * hunspellObject=getHunspellObject(std::string((char *)locale));
		
        if(!hunspellObject) return retObj;
        
        //convert input utf8 to u16 string
        inpWordU16 = EncConv::convCharStrToU16Str((char *)inpWord, "UTF-8");
        
        //get dictionary encoding
    HUNSPELL_GET_ENCODING getEncAdd=(HUNSPELL_GET_ENCODING) dlsym(hinstLib, "Hunspell_get_dic_encoding");
        char * m_MainEncoding= (getEncAdd)(hunspellObject);
        
        //convert u16 to dictionary encoding
        inpWordDictEncoded=EncConv::convU16StrToCharStr(inpWordU16,m_MainEncoding);
        
        if(inpWordDictEncoded.length()==0)
        {
            isConversionUnSuccesful = true;
        }
        
        //get suggestAddress &freelistAddress
        HUNSPELL_SUGGEST suggestAdd= (HUNSPELL_SUGGEST) dlsym(hinstLib, "Hunspell_suggest");
        HUNSPELL_FREE_LIST freeListAdd= (HUNSPELL_FREE_LIST) dlsym(hinstLib, "Hunspell_free_list");
        
        char** suggList = NULL;
        int numSugg = 0;
        
        //Try getting suggestions with encoded word else try with UTF8
        if(suggestAdd && !isConversionUnSuccesful)
        {
            numSugg = (suggestAdd)(hunspellObject,&suggList,(char *) (inpWordDictEncoded.c_str()));
        }
        else
        {
            numSugg = (suggestAdd)(hunspellObject,&suggList ,(char *) (inpWord));
        }
        
        
        if(numSugg)
        {
            FRESetArrayLength( retObj, numSugg );
            
            for(int iCount=0; iCount <numSugg; iCount++)
            {
                oneSuggestionEncoded=suggList[iCount];
                oneSuggestionU16=EncConv::convCharStrToU16Str(oneSuggestionEncoded, m_MainEncoding);
                oneSuggestionU8= EncConv::convU16StrToCharStr(oneSuggestionU16, "UTF-8");
                FRENewObjectFromUTF8((uint32_t)(oneSuggestionU8.length()),(const uint8_t*)(oneSuggestionU8.c_str()), &oneSuggestion);
                FRESetArrayElementAt(retObj, iCount, oneSuggestion);
                EncConv::releaseU16Str(oneSuggestionU16);
            }
            (freeListAdd)(hunspellObject, &suggList,numSugg);
            
        }
        
        EncConv::releaseU16Str(inpWordU16);
        
        return retObj;
    }

    
    
	void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, 
		uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet)
	{
        *numFunctionsToSet = 4;
        FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction)*5);
        
        func[0].name = (const uint8_t*)"talkBack";
        func[0].functionData = NULL;
        func[0].function = &talkBack;
        
        func[1].name = (const uint8_t*)"initHunspellObject";
        func[1].functionData = NULL;
        func[1].function = &initHunspellObject;
        
        func[2].name = (const uint8_t*)"checkWord";
        func[2].functionData = NULL;
        func[2].function = &checkWord;
        
        func[3].name = (const uint8_t*)"getSuggestions";
        func[3].functionData = NULL;
        func[3].function = &getSuggestions;
        
        *functionsToSet = func;
	}

	void ContextFinalizer(FREContext ctx)
	{
	}

	// Framework entry point
	EXPORT
	void ExtInitializer(void** extDataToSet, 
		FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
	{
        *extDataToSet = NULL;
		*ctxInitializerToSet = ContextInitializer;
		*ctxFinalizerToSet = ContextFinalizer;
	}

	// Framework entry point
	EXPORT
	void ExtFinalizer(void* extData)
	{
        HUNSPELL_UNINIT uninitAdd= (HUNSPELL_UNINIT) dlsym(hinstLib, "Hunspell_destroy");
        //clear all hunspell cache
        for(Hunspell_cache_iterator hunspell_cache_iter= Hunspell_cache.begin(); hunspell_cache_iter != Hunspell_cache.end(); hunspell_cache_iter++)
        {
            (uninitAdd)(hunspell_cache_iter->second);
            hunspell_cache_iter->second=NULL;
        }
	}
}
