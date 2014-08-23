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
	CharConv.h

	Author: Sudhakar Pandey <sudhakar@adobe.com>
*/

#ifndef __ENCCONV_H__
#define __ENCCONV_H__


#include <string>
extern "C"
{
    #include "unicode/ucnv.h"
}
typedef unsigned short U16Char_t;
typedef unsigned long	LM_UInt32;

namespace EncConv
{
	template<class CharType>
	static size_t GetNumOfUnits(CharType const* src)
	{
		size_t numOfUnits = 0;
		while (*src++ != 0)
			++numOfUnits;

		return numOfUnits;
	}

	const char * getPlatformEncoding(char* enc);
	const std::string convU16StrToCharStr(const U16Char_t* src, const char* Encoding);
	U16Char_t* convCharStrToU16Str(const char* src, const char* Encoding);

	U16Char_t* convSpecialCharsInU16Str( const U16Char_t* src); // caller need not allocate memory for the return value U16Char_t* 
	void releaseU16Str(const U16Char_t* buf);

}	// namespace

#endif
