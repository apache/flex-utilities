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

/*
	CharConv.cpp

	Author: Sudhakar Pandey <sudhakar@adobe.com>
*/


#include <iostream>
#include <cstring>
#include <stdexcept>
#include "EncConv.h"

extern "C" 
{
    #include "unicode/ucnv.h"   //Adding this as an alternative to native iconv library
    #include "unicode/ustring.h"   //Adding this as an alternative to native iconv library
}
#ifndef MAX
		#define	MAX(a,b) (((a)>(b))?(a):(b))
	#endif /* MAX */
// =============================================================================

namespace EncConv
{

// -----------------------------------------------------------------------------

U16Char_t* convSpecialCharsInU16Str(const U16Char_t* src)
{
	const LM_UInt32 srcLen = GetNumOfUnits(src);
	U16Char_t* pdst = new U16Char_t [srcLen + 1];
	 
	LM_UInt32 i;
	for(i = 0; i < srcLen; ++i)
	{
		U16Char_t c = src[i];
		switch (c)
		{
		case 0x2018:		// U+2018: Left Single Quotation Mark
		case 0x2019:		// U+2019: Right Single Quotation Mark
					c = '\'';	break;
		case 0x201C:		// U+201C: Left Double Quotation Mark
		case 0x201D:		// U+201D: Right Double Quotation Mark
					c = '"';	break;
		}
		pdst[i] = c;
	}
	pdst[i] = 0;
	return pdst;
	//delete[] pdst;
	//should be deleted by calling releaseU16CharString() function.
}

const char * getPlatformEncoding(const char* enc)
{
	//If encoding is null or not specified then try the default encoding "ISO-8859-1"
	if(strlen(enc) == 0)
		return "ISO-8859-1";
	if(strcmp(enc,"ISO8859-1") == 0)
		return "ISO-8859-1";
	else if (strcmp(enc,"ISO8859-2") == 0)
		return "ISO-8859-2";
	else if (strcmp(enc,"ISO8859-3") == 0)
		return "ISO-8859-3";
	else if (strcmp(enc,"ISO8859-4") == 0)
		return "ISO-8859-4";
	else if (strcmp(enc,"ISO8859-5") == 0)
		return "ISO-8859-5";
	else if (strcmp(enc,"ISO8859-6") == 0)
		return "ISO-8859-6";
	else if (strcmp(enc,"ISO8859-7") == 0)
		return "ISO-8859-7";
	else if (strcmp(enc,"ISO8859-8") == 0)
		return "ISO-8859-8";
	else if (strcmp(enc,"ISO8859-9") == 0)
		return "ISO-8859-9";
	else if (strcmp(enc,"ISO8859-10") == 0)
		return "ISO-8859-10";
	else if (strcmp(enc,"KOI8-R") == 0)
		return "KOI8-R";
	else if (strcmp(enc,"KOI8-U") == 0)
		return "KOI8-U";
	else if (strcmp(enc,"microsoft-cp1251") == 0)
		return "cp1251";
	else if (strcmp(enc,"ISO8859-13") == 0)
		return "ISO-8859-13";
	else if (strcmp(enc,"ISO8859-14") == 0)
		return "ISO-8859-14";
	else if (strcmp(enc,"ISO8859-15") == 0)
		return "ISO-8859-15";
	else if (strcmp(enc,"ISCII-DEVANAGARI") == 0)
		return "ibm-1137";
	else if (strcmp(enc,"TIS620-2533") == 0)
		return "TIS-620";
	else if (strcmp(enc,"UTF-8") == 0)
		return "UTF-8";
	else
		return enc;
}


const std::string convU16StrToCharStr(const U16Char_t* src, const char* Encoding)
{
	//static char const* const tocode = CHARCONV_ICONV_UTF16;
	char const* const tocode = getPlatformEncoding(Encoding);
    
    UErrorCode status = U_ZERO_ERROR;

#ifdef ENCCONV_DEBUG
	std::cout << "\t" "convString" << std::endl;
	std::cout << "\t\t" "tocode   = " << tocode   << std::endl;
	//std::cout << "\t\t" "fromcode = " << fromcode << std::endl;
#endif

	//iconv_t cd = iconv_open(tocode, fromcode);
    // Initializing ICU converter
	UConverter *conv = ucnv_open(tocode, &status);

#ifdef CHARCONV_DEBUG
	std::cout << "\t\t" "aft ucnv_open: status = " << status << std::endl;
#endif
	if (conv == NULL)
	{ // try default encoding "ISO-8859-1"
		//throw std::runtime_error("Unable to create Unicode converter object");
		status = U_ZERO_ERROR;
		conv = ucnv_open("ISO-8859-1", &status);
	}

	//still if conv is null simply return blank string

	if (conv == NULL)
	{ 
		return std::string("");
	}

	U16Char_t const* srcWrk = src;
	const size_t srcSizeInUnits = GetNumOfUnits(src);
	const size_t srcSizeInBytes = srcSizeInUnits * sizeof(U16Char_t);
	const size_t dstSizeInBytes = MAX(256, (srcSizeInUnits + 1)) * 4;	// How much byte buffer is needed? (UTF16 --> MBCS)
	char* dst = new char [dstSizeInBytes];
	if(dst==NULL) 
	{
		//Fix for #3211945
		ucnv_close(conv);
		return std::string("");
	}
	char* dstWrk =(char*)(dst);
	size_t srcLeftInBytes = srcSizeInBytes;
	size_t dstLeftInBytes = dstSizeInBytes - sizeof(char);
    status = U_ZERO_ERROR;

		ucnv_fromUChars(conv, dstWrk, dstLeftInBytes, (UChar*)srcWrk, -1, &status);
		U16Char_t* reverseConvertedVal = convCharStrToU16Str(dstWrk,Encoding);
		if(strcmp((char*)reverseConvertedVal,(char*)src)!=0)
		{
			EncConv::releaseU16Str(reverseConvertedVal);
			//Fix for #3211945
			dstWrk = NULL;
			ucnv_close(conv);
	        delete[] dst;
			
			return std::string("");
		}
		EncConv::releaseU16Str(reverseConvertedVal);
		
	
#ifdef CHARCONV_DEBUG
		std::cout << "\t\t" "aft iconv: status = " << status << std::endl;
#endif
		if (status != U_ZERO_ERROR )
		{
			//	throw std::runtime_error("Unable to convert to string");
			*dstWrk = 0;
		}


		std::string dst2(dst);
		//Fix for #3211945 
		dstWrk = NULL;
        delete[] dst;
	//const int err = iconv_close(cd);

    ucnv_close(conv);

	//if (err == -1)
	//	throw std::runtime_error("Unable to deallocate iconv_t object");

        return dst2;
}

U16Char_t* convCharStrToU16Str(const char* src, const char* Encoding)
{

	//static char const* const tocode = CHARCONV_ICONV_UTF16;
	char const* const fromcode = getPlatformEncoding(Encoding);
    
    UErrorCode status = U_ZERO_ERROR;

#ifdef ENCCONV_DEBUG
	std::cout << "\t" "convString" << std::endl;
	//std::cout << "\t\t" "tocode   = " << tocode   << std::endl;
	std::cout << "\t\t" "fromcode = " << fromcode << std::endl;
#endif

	//iconv_t cd = iconv_open(tocode, fromcode);
    // Initializing ICU converter
    UConverter *conv= ucnv_open(fromcode, &status);
#ifdef CHARCONV_DEBUG
	std::cout << "\t\t" "aft ucnv_open: status = " << status << std::endl;
#endif
	if (conv == NULL)
	{ // try default encoding "ISO-8859-1"
		//throw std::runtime_error("Unable to create Unicode converter object");
		conv = ucnv_open("ISO-8859-1", &status);
	}

	

	char const* srcWrk = src;
	const size_t srcSizeInBytes = std::strlen(src);
	const size_t dstSizeInBytes = MAX(256, (srcSizeInBytes + 1)) * sizeof(U16Char_t);
	U16Char_t* dst = new U16Char_t [dstSizeInBytes / sizeof(U16Char_t)];
	U16Char_t* dstWrk = dst;
	size_t srcLeftInBytes = srcSizeInBytes;
	size_t dstLeftInBytes = dstSizeInBytes - sizeof(U16Char_t);

    status = U_ZERO_ERROR;

	//still if conv is null simply return blank string

	if (conv == NULL)
	{ 
		dst[0] = NULL;
		//Fix for #3211945
		dstWrk = NULL;
		return dst;
	}

	ucnv_toUChars(conv, (UChar *) dstWrk, dstLeftInBytes, (char*)srcWrk, srcLeftInBytes, &status);
	
#ifdef CHARCONV_DEBUG
		std::cout << "\t\t" "aft iconv: status = " << status << std::endl;
#endif
		if (status != U_ZERO_ERROR )
		{
			//	throw std::runtime_error("Unable to convert to string");
			*dstWrk = 0;
		}


	//const int err = iconv_close(cd);

    ucnv_close(conv);

	//if (err == -1)
	//	throw std::runtime_error("Unable to deallocate iconv_t object");
	//Fix for #3211945
	dstWrk = NULL;
	return dst;

}

void releaseU16Str(const U16Char_t* buf)
{
		if(buf != NULL)
		{
			delete[] buf;
			buf = NULL;
		}
		return;
}

}// namespace
// -----------------------------------------------------------------------------

