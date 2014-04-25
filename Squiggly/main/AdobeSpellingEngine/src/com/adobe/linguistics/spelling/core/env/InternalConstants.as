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


package com.adobe.linguistics.spelling.core.env
{
	/*
	 * Internal-Internal public Constant properties...
	 * In the future, we might want to merge this class with ExternalConstant class...
	 * This one is sharing by HunSpell related algorithm...
	 */
	public class InternalConstants
	{
		// casing
		static public const NOCAP:int =					1;
		static public const INITCAP:int =				2;
		static public const ALLCAP:int =				4;
		static public const HUHCAP:int =				8;
		static public const HUHINITCAP:int =			16;

		
		static public const FLAG_LONG:int = 			1;
		static public const FLAG_NUM:int = 				2;
		static public const FLAG_UNI:int = 				3;
		static public const FLAG_CHAR:int = 			0;

		// default flags
		static public const DEFAULTFLAGS:int = 			65510;
		static public const FORBIDDENWORD:int = 		65511;
		static public const ONLYUPCASEFLAG:int = 		65511;

		static public const MAXWORDLEN:int =			100;

		static public const FLAG_NULL:int = 			0x00;
		
		// affentry options
		static public const aeXPRODUCT:int =			(1 << 0);
		
		static public const SPELL_KEYSTRING:String = 	"qwertyuiop|asdfghjkl|zxcvbnm"; 

		// internal const for ngram algorithm.
	    public static const NGRAM_LOWERING:int = 		(1 << 2);
		public static const NGRAM_LONGER_WORSE:int = 	(1 << 0);
		public static const NGRAM_ANY_MISMATCH:int = 	(1 << 1);

	    static public const MAX_ROOTS:int = 			100;
	    static public const MAX_WORDS:int = 			100;
	    static public const MAX_GUESS:int = 			200;
	    static public const MAXNGRAMSUGS:int=			4;
	    static public const MAXPHONSUGS:int=			2;

		static public const DEFAULTENCODING:String = 	"utf-8";
		
		
		static public const MAXSUGGESTION:int =			10;
		// internal const for ICONV or OCONV RULE.
		static public const CONV_ICONV:Boolean=			true;
		static public const CONV_OCONV:Boolean=			false;
		
		//Maximum word breaks allowed
		static public const MAX_WORD_BREAKS:int=		10;
		
		//Constants for Loading of Dictionaries in Parts
		static public const DICT_LOAD_DELAY:int=		10; //this is timeout delay between loading of two parts of dictionaries. In milliseconds
		static public const WORDS_PER_SPLIT:int=		20000;// this is the default value of number of words to be loaded in each split.
		public function InternalConstants()
		{
		}

	}
}