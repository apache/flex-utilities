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

#include<fstream>
#include <tchar.h>
using namespace std;

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

bool FileExists(const char* inFilePath)
		{
			if(inFilePath == NULL) return false;
			ifstream file(inFilePath, ios::in);
			if (file.good())
			{
				file.close();
				return true;
			}
			else
			{
				return false;
			}
		}

bool FileExists(std::wstring fileURL)
{
	FILE* stream = _tfopen(fileURL.c_str(), _T("r"));
	bool exists = stream != NULL;
	if (exists)
		fclose(stream);
	return exists;
}

static PlatformEncoding getPlatformEncoding(const Encoding enc)
{
	switch(enc)
	{
	case Encoding_UTF8:						return CP_UTF8;
	case Encoding_UTF16:					return 1200;
	case Encoding_CurrentLocaleSpecific:	return CP_ACP;	// CP_THREAD_ACP
	}
	return 0;

}

static const std::string _makeString(wchar_t const* const src, Encoding enc)
{
	const UINT cp = getPlatformEncoding(enc);
	const int numOfUnitsReqed = ::WideCharToMultiByte(
		/* UINT		codePage			*/	cp,
		/* DWORD	dwFlags				*/	0,
		/* LPCWSTR	lpWideCharStr		*/	src,
		/* int		cchWideChar			*/	-1,
		/* LPSTR	lpMultiByteStr		*/	NULL,
		/* int		cbMultiByte			*/	0,
		/* LPCSTR	lpDefaultChar		*/	NULL,
		/* LPBOOL	lpUsedDefaultChar	*/	NULL);
	if (numOfUnitsReqed == 0)
	{
		const DWORD err = GetLastError();
		throw std::runtime_error("Unable to calculate string length");
	}

	const LPSTR buf = new CHAR [numOfUnitsReqed];
	const int numOfUnitsUsed = ::WideCharToMultiByte(
		/* UINT		codePage			*/	cp,
		/* DWORD	dwFlags				*/	0,
		/* LPCWSTR	lpWideCharStr		*/	src,
		/* int		cchWideChar			*/	-1,
		/* LPSTR	lpMultiByteStr		*/	buf,
		/* int		cbMultiByte			*/	numOfUnitsReqed,
		/* LPCSTR	lpDefaultChar		*/	NULL,
		/* LPBOOL	lpUsedDefaultChar	*/	NULL);
	if (numOfUnitsUsed == 0)
	{
		const DWORD err = GetLastError();
		throw std::runtime_error("Unable to convert to multi-byte string");
	}

	std::string dst(buf);
	delete[] buf;
	return dst;

}


const std::string  makeString(wchar_t const* src, Encoding enc= Encoding_CurrentLocaleSpecific)
{
	return _makeString(src, enc);
}
