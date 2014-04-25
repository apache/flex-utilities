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

	Author: Masa Hokari <mhokari@adobe.com>
*/

#ifndef __CHARCONV_H__
#define __CHARCONV_H__

#if defined(WIN_PLATFORM)
	#include <windows.h>
#endif





#include <string>

namespace CharConv
{

// -----------------------------------------------------------------------------

enum Encoding
{
	Encoding_Invalid,
	Encoding_UTF8,
	Encoding_UTF16,
	Encoding_UTF32,
	Encoding_CurrentLocaleSpecific
};

#if defined(WIN_PLATFORM)
	typedef UINT PlatformEncoding;			// WideCharToMultiByte

#endif



const std::string  makeString(wchar_t const* src, Encoding enc = Encoding_CurrentLocaleSpecific);






// -----------------------------------------------------------------------------

}	// namespace

#endif
