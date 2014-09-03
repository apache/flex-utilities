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


package com.adobe.linguistics.spelling.core
{
//	import com.adobe.linguistics.spelling.core.PhoneticTable;
	import com.adobe.linguistics.spelling.core.env.*;
	import com.adobe.linguistics.spelling.core.error.*;
	import com.adobe.linguistics.spelling.core.rule.*;
	import com.adobe.linguistics.spelling.core.utils.SimpleNumberParser;
	
	import flash.utils.Dictionary;


	public class LinguisticRule
	{


		private var _encoding:String // ToDo, not sure how to handle this encoding stuff...

		private var snp:SimpleNumberParser = new SimpleNumberParser();
		
		private var _prefixFlagTable:Array;
		private var _prefixKeyTable:Array;
		private var _suffixFlagTable:Array;
		private var _suffixKeyTable:Array;
		private var _optSuffixKeyTable:Dictionary;
		private var _optPrefixKeyTable:Dictionary;
//these are attributes
		private var _keyString:String;
		private var _tryString:String;
		private var _noSuggest:Number;// don't suggest words signed with NOSUGGEST flag
		private var _forbiddenWord:Number; // forbidden word signing flag
		private var _circumfix:Number=0; //Circumfix Flag
		private var _ignoredChars:String; // letters + spec. word characters
		private var _wordChars:String; //extends tokenizer of Hunspell command line interface with additional word character. For example, dot, dash, n-dash, numbers, percent sign are word character in Hungarian.
		private var _languageCode:String; 
		private var _version:String;
		private var _maxngramsugs:int = -1; // undefined
		private var _nosplitsugs:int = 0;
		private var _sugswithdots:int = 0;
		private var _fullStrip:int;
		private var _keepCase:Number;
		private var _haveContClass:Boolean;//added to support (double) prefixes
		
		private var _flagMode:int;
		private var _needAffix:Number;
		private var _contClasses:Dictionary;//this is list of all possible contclasses
		/* ToDo */
		
		private var _onlyInCompound:Number = 0;
//		private var _phoneTable:PhoneticTable; //phone table
/*


ToDO: should be removed after we have complex-affix support and compound-word support..


  pHMgr = ptr[0];
  alldic = ptr;
  maxdic = md;
  keystring = NULL;
  trystring = NULL;
  encoding=NULL;
  utf8 = 0;
  complexprefixes = 0;
  maptable = NULL;
  nummap = 0;
  breaktable = NULL;
  numbreak = 0;
  reptable = NULL;
  numrep = 0;
  iconvtable = NULL;
  oconvtable = NULL;
  checkcpdtable = NULL;
  // allow simplified compound forms (see 3rd field of CHECKCOMPOUNDPATTERN)
  simplifiedcpd = 0;
  numcheckcpd = 0;
  defcpdtable = NULL;
  numdefcpd = 0;
  phone = NULL;
  compoundflag = FLAG_NULL; // permits word in compound forms
  compoundbegin = FLAG_NULL; // may be first word in compound forms
  compoundmiddle = FLAG_NULL; // may be middle word in compound forms
  compoundend = FLAG_NULL; // may be last word in compound forms
  compoundroot = FLAG_NULL; // compound word signing flag
  compoundpermitflag = FLAG_NULL; // compound permitting flag for suffixed word
  compoundforbidflag = FLAG_NULL; // compound fordidden flag for suffixed word
  checkcompounddup = 0; // forbid double words in compounds
  checkcompoundrep = 0; // forbid bad compounds (may be non compound word with a REP substitution)
  checkcompoundcase = 0; // forbid upper and lowercase combinations at word bounds
  checkcompoundtriple = 0; // forbid compounds with triple letters
  simplifiedtriple = 0; // allow simplified triple letters in compounds (Schiff+fahrt -> Schiffahrt)
  forbiddenword = FORBIDDENWORD; // forbidden word signing flag
  nosuggest = FLAG_NULL; // don't suggest words signed with NOSUGGEST flag
  lang = NULL; // language
  langnum = 0; // language code (see http://l10n.openoffice.org/languages.html)
  needaffix = FLAG_NULL; // forbidden root, allowed only with suffixes
  cpdwordmax = -1; // default: unlimited wordcount in compound words
  cpdmin = -1;  // undefined
  cpdmaxsyllable = 0; // default: unlimited syllablecount in compound words
  cpdvowels=NULL; // vowels (for calculating of Hungarian compounding limit, O(n) search! XXX)
  cpdvowels_utf16=NULL; // vowels for UTF-8 encoding (bsearch instead of O(n) search)
  cpdvowels_utf16_len=0; // vowels
  pfxappnd=NULL; // previous prefix for counting the syllables of prefix BUG
  sfxappnd=NULL; // previous suffix for counting a special syllables BUG
  cpdsyllablenum=NULL; // syllable count incrementing flag
  checknum=0; // checking numbers, and word with numbers
  wordchars=NULL; // letters + spec. word characters
  wordchars_utf16=NULL; // letters + spec. word characters
  wordchars_utf16_len=0; // letters + spec. word characters
  ignorechars=NULL; // letters + spec. word characters
  ignorechars_utf16=NULL; // letters + spec. word characters
  ignorechars_utf16_len=0; // letters + spec. word characters
  version=NULL; // affix and dictionary file version string
  havecontclass=0; // flags of possible continuing classes (double affix)
  // LEMMA_PRESENT: not put root into the morphological output. Lemma presents
  // in morhological description in dictionary file. It's often combined with PSEUDOROOT.
  lemma_present = FLAG_NULL; 
  circumfix = FLAG_NULL; 
  onlyincompound = FLAG_NULL; 
  maxngramsugs = -1; // undefined
  nosplitsugs = 0;
  sugswithdots = 0;
  keepcase = 0;
  checksharps = 0;
  substandard = FLAG_NULL;
  fullstrip = 0;
  */
		
		private var _simpleFilterTable:Array;
		private var _mapFilterTable:Array;
		private var _iconvFilterTable:Array; //Contains conversion table for ICONV conversion
		private var _oconvFilterTable:Array;//Contains conversion table for OCONV conversion
		private var _breakTable:Array;//Contains list of characters in BREAK rule
		private var _aliasfTable:Array;//Contains conversion table for AF rule
		/* internal use only properties. */
		private var _pfxEntry:PrefixEntry;
		private var _sfxEntry:SuffixEntry;
		private var _optSfxEntry:OptimizedSuffixEntry;
		private var _optPfxEntry:OptimizedPrefixEntry;
		private var _dictMgr:DictionaryManager;
		
		public function LinguisticRule()
		{
			
			this._prefixFlagTable = new Array()
			this._prefixKeyTable = new Array();
			this._suffixFlagTable = new Array();
			this._suffixKeyTable = new Array();
			this._optSuffixKeyTable = new Dictionary(true);
			this._optPrefixKeyTable = new Dictionary(true);
			
			this._simpleFilterTable = new Array();
			this._mapFilterTable = new Array();
			this._iconvFilterTable=new Array();
			this._oconvFilterTable=new Array();
			this._breakTable=new Array();//We are not adding any break points by default. Hunspell C does this for -, ^-, -$
			this._aliasfTable=new Array();
//			this._phoneTable=new PhoneticTable(); 
			
			
			/* init the attributes */
			this.noSuggest = InternalConstants.FLAG_NULL;
			this.tryString= null;
			this.keyString= null;
			this.ignoredChars = null;
			this.wordChars = null;
			this.version = null;
			this.languageCode = null;
			this.forbiddenWord = InternalConstants.FORBIDDENWORD;
			this.needAffix=InternalConstants.FLAG_NULL;
			this.circumfix=InternalConstants.FLAG_NULL;
			this.maxNgramSuggestions = -1; // undefined
			this.nosplitSuggestions = 0;
			this.suggestionsWithDots = 0;
			this.fullStrip = 0;
			this.keepCase = 0;
			this.onlyInCompound = 0;
			this.flagMode = InternalConstants.FLAG_CHAR;
			this._contClasses= new Dictionary;
			/* */
			
			
			this._dictMgr = null;
			

		}

		/*
		 * Deprecated function for now...
		 * History: 
		 *          A pre-version of implementation for error detection. After I optimized the code for performance,
		 *          I drop this function by that time, but you know performance meassuring is a tricky problem... 
		 * ToDo: Need a revisit when we implementing complex-affix support and compound-word support.
		 */
		// check if word with affixes is correctly spelled
		public function affixCheck( word:String, needFlag:int, inCompound:int ):HashEntry {
			var rv:HashEntry = null;
			// check all prefixes (also crossed with suffixes if allowed) 
			rv = optSuffixCheck(word, needFlag, inCompound);
			if( rv ) return rv;
			// if still not found check all suffixes
			rv = optPrefixCheck(word, 0, null, inCompound, needFlag);
			return rv;
		}

		// This function checks if word with affixes is correctly spelled.
		public function affixCheck2( word:String, needFlag:int, inCompound:int ):HashEntry {
			var rv:HashEntry = null;
			if ( word.length <2 ) return rv;
			// check onelevel prefix case or one level prefix+one level suffix: un->run or under->taker (note: hypothetical words) also will check milli->litre->s and d'->autre->s
			rv = optPrefixCheck2(word, inCompound, needFlag);
			if( rv ) return rv;
			// check all one level suffix drink->able or drink->s
			rv = optSuffixCheck2(word,0,null, needFlag, inCompound);
			
			
			//double affix checking 
			if(this.haveContClass)
			{
				if(rv) return rv;
				//check all 2 level suffixes case: drink->able->s
				rv= optTwoSuffixCheck(word,0, null, needFlag,0);
				
				if(rv) return rv;
				//check prefix and then 2 level suffix case un->drink->able->s
				rv= optTwoPrefixCheck(word, 0, needFlag);
				
			}
				
				return rv;
		}


		/*
		 * Deprecated function for now...
		 * History: 
		 *          A pre-version of implementation for error detection. After I optimized the code for performance,
		 *          I drop this function by that time, but you know performance meassuring is a tricky problem... 
		 * ToDo: Need a revisit when we implementing complex-affix support and compound-word support.
		 */
		public function optPrefixCheck(word:String, sfxopts:int, ppfx:AffixEntry, needFlag:int, inCompound:int) :HashEntry {
			var rv:HashEntry = null;
			var tmpWord:String;
			// first handle the special case of 0 length prefixes
			if ( _optPrefixKeyTable[''] != undefined ) {
				_optPfxEntry = _optPrefixKeyTable[''];
				while ( _optPfxEntry ) {
					// fogemorpheme
					// permit prefixes in compounds
						// check prefix
					rv = _optPfxEntry.checkWord(word, sfxopts, ppfx, inCompound, needFlag);
					if ( rv ) {
						return rv;
					}
					_optPfxEntry = _optPfxEntry.nextElementWithKey;
				}
			}
			
			// now handle the general case
			for ( var i:int =1; i < word.length ; ++i ) {
				tmpWord = word.substr(0,i);
				if ( _optPrefixKeyTable[tmpWord] != undefined ) {
					_optPfxEntry = _optPrefixKeyTable[tmpWord];
					// fogemorpheme
					// permit prefixes in compounds
						// check prefix
					while ( _optPfxEntry ) {
						rv = _optPfxEntry.checkWord(word, sfxopts, ppfx, inCompound, needFlag);
						if ( rv) {
							return rv;
						}
						_optPfxEntry = _optPfxEntry.nextElementWithKey;
					}
				}
			}
			
			return rv;
		}

// This function checks one level prefix OR one level prefix+ one level suffix
		public function optPrefixCheck2(word:String, inCompound:int, needFlag:int) :HashEntry {
			var rv:HashEntry = null;
			var tmpWord:String;
			var i:int;
			var locOptPfxEntry:OptimizedPrefixEntry=null;//local optimised prefix entry added because we are adding optTwoPrefixCheck
			// first handle the special case of 0 length prefixes
			if ( _optPrefixKeyTable[''] != undefined ) {
				for ( i=0; i<_optPrefixKeyTable[''].length; ++i ) {
					locOptPfxEntry=_optPrefixKeyTable[''][i];
					// fogemorpheme
					// permit prefixes in compounds
						// check prefix
					while ( locOptPfxEntry ) {
						rv = locOptPfxEntry.checkWord2(word, inCompound, needFlag);
						if ( rv) {
							return rv;
						}
						locOptPfxEntry = locOptPfxEntry.nextElementWithKey;
					}
				}
			}
			
			// now handle the general case
			var firstKeyStr:String = word.charAt(0);
			var secondKeyNum:Number = word.charCodeAt(1);
			var breakFlag:Boolean = false;
			if ( _optPrefixKeyTable[firstKeyStr] != undefined ) {
				for ( i=0; i< _optPrefixKeyTable[firstKeyStr].length; ++i ) {
					locOptPfxEntry=_optPrefixKeyTable[firstKeyStr][i];
					if ( (locOptPfxEntry.affixKey.length!=1) ) {
						if ( locOptPfxEntry.affixKey.charCodeAt(1)> secondKeyNum )
							break;
						if ( locOptPfxEntry.affixKey.charCodeAt(1)< secondKeyNum) {
							if (breakFlag) break;
							else continue;
						}
						breakFlag = true;
					}
					if (word.indexOf(locOptPfxEntry.affixKey) != 0)
						continue; 
					// fogemorpheme
					// permit prefixes in compounds
						// check prefix
					while ( locOptPfxEntry ) {
						rv = locOptPfxEntry.checkWord2(word, inCompound, needFlag);
						if ( rv) {
							return rv;
						}
						locOptPfxEntry = locOptPfxEntry.nextElementWithKey;
					}
				}
			}
			
			return rv;
		}

		// This is a new function added to include one level prefix checking followed by two level suffix checking
		public function optTwoPrefixCheck(word:String, inCompound:int, needFlag:int) :HashEntry {
			var rv:HashEntry = null;
			//pfx=null;//TODO:Need to figure these out, seems they will be needed for compound rules. keeping for some time
			//sfxrevkey=null;//TODO:Need to figure these out, seems they will be needed for compound rules. keeping for some time
			var tmpWord:String;
			var i:int;
			var locOptPfxEntry:OptimizedPrefixEntry=null;//local optimised prefix entry
			// first handle the special case of 0 length prefixes
			if ( _optPrefixKeyTable[''] != undefined ) {
				for ( i=0; i<_optPrefixKeyTable[''].length; ++i ) {
					locOptPfxEntry=_optPrefixKeyTable[''][i];
					
					while ( locOptPfxEntry ) {
						rv = locOptPfxEntry.checkTwoWord(word, inCompound, needFlag); 
						if ( rv) {
							return rv;
						}
						locOptPfxEntry = locOptPfxEntry.nextElementWithKey;
					}
				}
			}
			
			// now handle the general case
			var firstKeyStr:String = word.charAt(0);
			var secondKeyNum:Number = word.charCodeAt(1);
			var breakFlag:Boolean = false;
			if ( _optPrefixKeyTable[firstKeyStr] != undefined ) {
				for ( i=0; i< _optPrefixKeyTable[firstKeyStr].length; ++i ) {
					locOptPfxEntry=_optPrefixKeyTable[firstKeyStr][i];
					if ( (locOptPfxEntry.affixKey.length!=1) ) {
						if ( locOptPfxEntry.affixKey.charCodeAt(1)> secondKeyNum )
							break;
						if ( locOptPfxEntry.affixKey.charCodeAt(1)< secondKeyNum) {
							if (breakFlag) break;
							else continue;
						}
						breakFlag = true;
					}
					if (word.indexOf(locOptPfxEntry.affixKey) != 0)
						continue; 
					while ( locOptPfxEntry ) {
						rv = locOptPfxEntry.checkTwoWord(word, inCompound, needFlag);
						if ( rv) {
							return rv;
						}
						locOptPfxEntry = locOptPfxEntry.nextElementWithKey;
					}
				}
			}
			return rv;//this most certainly will return NULL
		}
		

		/*
		 * Deprecated function for now...
		 * History: 
		 *          A pre-version of implementation for error detection. After I optimized the code for performance,
		 *          I drop this function by that time, but you know performance meassuring is a tricky problem... 
		 * ToDo: Need a revisit when we implementing complex-affix support and compound-word support.
		 */
		public function optSuffixCheck( word:String, needFlag:int, inCompound:int):HashEntry {
			var rv:HashEntry  = null;
			var tmpWord:String;
			// first handle the special case of 0 length suffixes
			if ( this._optSuffixKeyTable[''] != undefined  ) {
				_optSfxEntry = this._optSuffixKeyTable[''];
				while ( _optSfxEntry ) {
					// fogemorpheme
					// permit prefixes in compounds
						// check prefix
					rv = _optSfxEntry.checkWord(word, inCompound, needFlag);
					if ( rv ) {
						return rv;
					}
					_optSfxEntry = _optSfxEntry.nextElementWithKey;
				}
				
			}
			// now handle the general case
			for ( var i:int =word.length-1; i > 0 ; --i ) {
				tmpWord = word.substr(i);
				if ( _optSuffixKeyTable[tmpWord] != undefined ) {
					_optSfxEntry = _optSuffixKeyTable[tmpWord];
					// fogemorpheme
					// permit prefixes in compounds
						// check prefix
					while ( _optSfxEntry ) {
						rv = _optSfxEntry.checkWord(word, inCompound, needFlag);
						if ( rv) {
							return rv;
						}
						_optSfxEntry = _optSfxEntry.nextElementWithKey;
					}
				}
			}
			
			return rv;
		}

//This function takes care of all one level suffix stripping. This is called from other affix stripping functions also
		public function optSuffixCheck2( word:String, sfxopts:int, ppfx:AffixEntry, needFlag:int, inCompound:int, cclass:int=0, pfxcclass:int=0):HashEntry {
			var rv:HashEntry  = null;
			var tmpWord:String;
			var locOptSfxEntry:OptimizedSuffixEntry=null;//local optimised suffic entry
			// first handle the special case of 0 length suffixes
			if ( this._optSuffixKeyTable[''] != undefined  ) {
				locOptSfxEntry=this._optSuffixKeyTable[''];
				while ( locOptSfxEntry ) {
					//if(!cclass|| locOptSfxEntry.contclass)
					//{
						
					
					
					// fogemorpheme
					// permit prefixes in compounds
						// check prefix
						
					//if((_optSfxEntry &&!(_optSfxEntry.contclass && HashEntry.TESTAFF(_optSfxEntry.contclass, this._needAffix)))||(ppfx&& !(ppfx.contclass && HashEntry.TESTAFF(ppfx.contclass,this._needAffix))))// needaffix on prefix or first suffix
					//{
						
						rv = locOptSfxEntry.checkWord2(word, sfxopts, ppfx, inCompound, needFlag, cclass, pfxcclass);
						if ( rv ) {
							_optSfxEntry = locOptSfxEntry;//WIll possibily needed in compound check
							return rv;
						}
				//	}
					//}
					locOptSfxEntry = locOptSfxEntry.nextElementWithKey;
				}
				
			}
			// now handle the general case
			for ( var i:int =word.length-1; i >= 0 ; --i ) {
				tmpWord = word.substr(i);
				if ( _optSuffixKeyTable[tmpWord] != undefined ) {
					locOptSfxEntry = (_optSuffixKeyTable[tmpWord] is OptimizedSuffixEntry)? _optSuffixKeyTable[tmpWord] : null;
					// fogemorpheme
					// permit prefixes in compounds
						// check prefix
					while ( locOptSfxEntry ) {
						//if(_optSfxEntry &&HashEntry.TESTAFF(_optSfxEntry.contclass, this._needAffix)||(ppfx&& HashEntry.TESTAFF(ppfx.contclass,this._needAffix)))// needaffix on prefix or first suffix
						//{
							
							rv = locOptSfxEntry.checkWord2(word, sfxopts, ppfx, inCompound, needFlag, cclass, pfxcclass);
							if ( rv) {
								_optSfxEntry = locOptSfxEntry;//WIll possibily needed in compound check
								return rv;
							}
						//}
							locOptSfxEntry = locOptSfxEntry.nextElementWithKey;
					}
				}
			}
			
			return rv;
		}
		
		// This is a new function added to include two level suffix checking
		public function optTwoSuffixCheck(word:String, sfxopts:int, ppfx:AffixEntry,needFlag:int,pfxcclass:int=0) :HashEntry {
			var rv:HashEntry  = null;
			var tmpWord:String;
			var locOptSfxEntry:OptimizedSuffixEntry;//local optimised suffic entry
			// first handle the special case of 0 length suffixes
			if ( this._optSuffixKeyTable[''] != undefined  ) 
			{
				locOptSfxEntry=this._optSuffixKeyTable[''];
				while ( locOptSfxEntry ) 
				{
					for(var j:int=0; locOptSfxEntry.flags && j<locOptSfxEntry.flags.length; j++)
					{
						if(this.contClasses[locOptSfxEntry.flags[j]]==true)
						{ //if this can be a possible contclass check furthur
							rv = locOptSfxEntry.checkTwoWord(word, sfxopts, ppfx, needFlag, locOptSfxEntry.flags[j], pfxcclass );
							if (rv) 
							{
								_optSfxEntry = locOptSfxEntry;//WIll possibily needed in compound check
								return rv;
							}
						
						}
					}
					// get next suffix entry from table
					locOptSfxEntry = locOptSfxEntry.nextElementWithKey;
				}
			}

			//now handle the general case
			for ( var i:int =word.length-1; i >= 0 ; --i ) 
			{
				tmpWord = word.substr(i);
				if ( _optSuffixKeyTable[tmpWord] != undefined ) 
				{
					locOptSfxEntry = (_optSuffixKeyTable[tmpWord] is OptimizedSuffixEntry)? _optSuffixKeyTable[tmpWord] : null;
					
					while ( locOptSfxEntry )
					{
						for(j=0;locOptSfxEntry.flags && j<locOptSfxEntry.flags.length; j++)
						{
							if(this.contClasses[locOptSfxEntry.flags[j]]==true)
							{	
							 //if this can be a possible contclass check furthur
							rv = locOptSfxEntry.checkTwoWord(word, sfxopts, ppfx, needFlag,locOptSfxEntry.flags[j], pfxcclass );
							if ( rv) 
								{
								_optSfxEntry = locOptSfxEntry;//WIll possibily needed in compound check
								return rv;	
								}
							}
						}
						locOptSfxEntry = locOptSfxEntry.nextElementWithKey;
					}
				}
			}
			
			return rv;//will be null in most cases
			
		}

		/*
		 * Deprecated function for now...
		 * History: 
		 *          A pre-version of implementation for error detection. After I optimized the code for performance,
		 *          I drop this function by that time, but you know performance meassuring is a tricky problem... 
		 * ToDo: Need a revisit when we implementing complex-affix support and compound-word support.
		 */
		public function suffixCheck2( word:String, sfxopts:int, ppfx:AffixEntry, needFlag:int, inCompound:int):HashEntry {
			var rv:HashEntry  = null;
			var tmpWord:String;
			// first handle the special case of 0 length suffixes
			if ( this._suffixKeyTable[''] != undefined  ) {
				_sfxEntry = this._suffixKeyTable[''];
				while ( _sfxEntry ) {
					// fogemorpheme
					// permit prefixes in compounds
						// check prefix
					rv = _sfxEntry.checkWord(word, sfxopts, ppfx, inCompound, needFlag);
					if ( rv ) {
						return rv;
					}
					_sfxEntry = _sfxEntry.nextElementWithKey;
				}
				
			}
			// now handle the general case
			for ( var i:int =word.length-1; i > 0 ; --i ) {
				tmpWord = word.substr(i);
				if ( _suffixKeyTable[tmpWord] != undefined ) {
					_sfxEntry = _suffixKeyTable[tmpWord];
					// fogemorpheme
					// permit prefixes in compounds
						// check prefix
					while ( _sfxEntry ) {
						rv = _sfxEntry.checkWord(word, sfxopts, ppfx, inCompound, needFlag);
						if ( rv) {
							return rv;
						}
						_sfxEntry = _sfxEntry.nextElementWithKey;
					}
				}
			}
			
			return rv;
		}

		
		/*
		 * Deprecated function for now...
		 * History: 
		 *          A pre-version of implementation for error detection. After I optimized the code for performance,
		 *          I drop this function by that time, but you know performance meassuring is a tricky problem... 
		 * ToDo: Need a revisit when we implementing complex-affix support and compound-word support.
		 */
		private function prefixCheck2(word:String, inCompound:int, needFlag:int) :HashEntry {
			var rv:HashEntry = null;
			var tmpWord:String;
			// first handle the special case of 0 length prefixes
			if ( _prefixKeyTable[''] != undefined ) {
				_pfxEntry = _prefixKeyTable[''];
				while ( _pfxEntry ) {
					// fogemorpheme
					// permit prefixes in compounds
						// check prefix
					rv = _pfxEntry.checkWord(word, inCompound, needFlag);
					if ( rv ) {
						return rv;
					}
					_pfxEntry = _pfxEntry.nextElementWithKey;
				}
			}
			
			// now handle the general case
			for ( var i:int =1; i < word.length ; ++i ) {
				tmpWord = word.substr(0,i);
				if ( _prefixKeyTable[tmpWord] != undefined ) {
					_pfxEntry = _prefixKeyTable[tmpWord];
					// fogemorpheme
					// permit prefixes in compounds
						// check prefix
					while ( _pfxEntry ) {
						rv = _pfxEntry.checkWord(word, inCompound, needFlag);
						if ( rv) {
							return rv;
						}
						_pfxEntry = _pfxEntry.nextElementWithKey;
					}
				}
			}
			
			return rv;
		}
		
		public function lookup(word:String ):HashEntry {
			var he:HashEntry = null;
			var i:int;
			// look word in hash table
			for ( i=0; i < this._dictMgr.dictonaryList.length && !he; ++i ) {
				he = this._dictMgr.dictonaryList[i].getElement(word);
			}
			return he;
		}
		
		public function set flagMode(value:int) :void {
			this._flagMode = value;
		}
		
		public function get flagMode():int {
			return this._flagMode;
		}
		
		public function set encoding(value:String) :void {
			this._encoding = value;
		}
		
		public function get encoding():String {
			return this._encoding;
		}
		
		public function set keepCase(value:Number):void {
			this._keepCase = value;
		}
		
		public function get keepCase():Number {
			return this._keepCase;
		}
		
		public function set haveContClass(value:Boolean):void {
			this._haveContClass = value;
		}
		
		public function get haveContClass():Boolean {
			return this._haveContClass;
		}
		
		public function set needAffix(value:Number):void {
			this._needAffix = value;
		}
		public function get needAffix():Number {
			return this._needAffix;
		}

		
		public function set circumfix(value:Number):void {
			this._circumfix = value;
		}
		public function get circumfix():Number {
			return this._circumfix;
		}

		public function set onlyInCompound(value:Number):void {
			this._onlyInCompound = value;
		}
		public function get onlyInCompound():Number {
			return this._onlyInCompound;
		}

		public function set dictionaryManager(value:DictionaryManager) :void {
			this._dictMgr = value;
		}
		
		public function get dictionaryManager():DictionaryManager {
			return this._dictMgr;
		}


		public function set fullStrip(value:int):void {
			this._fullStrip = value;
		}
		
		public function get fullStrip():int {
			return this._fullStrip;
		}
		
		public function set suggestionsWithDots(value:int):void {
			this._sugswithdots = value;
		}
		
		public function get suggestionsWithDots():int {
			return this._sugswithdots;
		}
		
		public function set nosplitSuggestions(value:int ) :void {
			this._nosplitsugs = value;
		}
		
		public function get nosplitSuggestions():int {
			return this._nosplitsugs;
		}
		
		public function set maxNgramSuggestions(value:int ) :void {
			this._maxngramsugs = value;
		}
		
		public function get maxNgramSuggestions():int {
			return this._maxngramsugs;
		}
		
		public function set version(value:String) :void {
			this._version = value;
		}
		
		public function get version():String {
			return this._version;
		}
		
		public function set languageCode(value:String) :void {
			this._languageCode = value;	
		}
		
		public function get languageCode():String {
			return this._languageCode;
		}
		
		public function set wordChars(value:String):void {
			this._wordChars= value;
		}
		
		public function get wordChars():String {
			return this._wordChars;
		}

		public function addMapFilter(mapString:String ):Boolean {
			var mf:MapFilter = new MapFilter(mapString);
			for ( var i:int; i< this._mapFilterTable.length; ++i ) {
				if ( this._mapFilterTable[i].mapCharSet == mapString ) {
					return false;
				}
			}
			this._mapFilterTable.push(mf);
			return true;
		}

		public function addSimpleFilter(matchString:String, replacement:String):Boolean {
			var sf:SimpleFilter = new SimpleFilter( matchString, replacement);
			for ( var i:int; i< this._simpleFilterTable.length; ++i ) {
				if ( (this._simpleFilterTable[i].matchString==matchString) && (this._simpleFilterTable[i].replacement==replacement ) ) {
					return false;
				}
			}
			this._simpleFilterTable.push(sf);
			return true;
		}
		
	
		//--adding to iconv/oconv table
		
		public function addConvFilter(matchString:String, replacement:String, ioflag:Boolean):Boolean {
			var convTable:Array;
			convTable=(ioflag==true)?this._iconvFilterTable:this._oconvFilterTable;
			for ( var i:int; convTable && i< convTable.length; ++i ) {
				if ( (convTable[i].matchString==matchString) && (convTable[i].replacement==replacement ) ) {
					return false;
				}
			}
			var sf:SimpleFilter = new SimpleFilter( matchString, replacement);
			convTable.push(sf);
			return true;
		}
		
		public function addAffixEntry(affixFlag:int, stripString:String, affixValue:String, conditionsStr:String, morph:String = "", permission:Boolean = false, affixType:int = 0, contclass:String=null):Boolean{
			if ( stripString == null || affixValue == null || conditionsStr==null || conditionsStr=="" ) return false;
			if ( affixType == 0 ) {
				if ( stripString == null || affixValue == null || conditionsStr==null || conditionsStr=="" ) return false;
				var pfxEntry:PrefixEntry = new PrefixEntry(affixFlag,stripString,affixValue,conditionsStr,morph,permission,contclass);
				pfxEntry.attributeManager = this;
				addPrefixEntry(pfxEntry);
				addOptPrefixEntry(pfxEntry);
			}else {
				if ( stripString == null || affixValue == null || conditionsStr==null || conditionsStr=="" ) return false;
				var sfxEntry:SuffixEntry = new SuffixEntry(affixFlag,stripString,affixValue,conditionsStr,morph,permission,contclass);
				sfxEntry.attributeManager = this;
				addSuffixEntry(sfxEntry);	
				addOptSuffixEntry(sfxEntry);
			}
			return true;
		}

		private function addOptPrefixEntry(pfxEntry:PrefixEntry):Boolean {
			var optPfxEntry:OptimizedPrefixEntry
			var hashKey:String = pfxEntry.affixKey.charAt(0);
			optPfxEntry = new OptimizedPrefixEntry(pfxEntry);
			optPfxEntry.attributeManager = this;
			//insert prefix key table....
			if ( _optPrefixKeyTable[hashKey] == undefined ) {
				_optPrefixKeyTable[hashKey] = new Array();
				_optPrefixKeyTable[hashKey].push(optPfxEntry);
			}
			else {
				for each( var optPfxKeyEntry:OptimizedPrefixEntry  in _optPrefixKeyTable[hashKey] ){
					if ( optPfxKeyEntry.affixKey == pfxEntry.affixKey ) {
						while( optPfxKeyEntry.nextElementWithKey != null ) {
							if ( optPfxKeyEntry.isSimilarObject(pfxEntry) ) {
								optPfxKeyEntry.extendObject(pfxEntry);
								return true;
							}
							optPfxKeyEntry = optPfxKeyEntry.nextElementWithKey; 
						}
						if ( optPfxKeyEntry.isSimilarObject(pfxEntry) ) {
							optPfxKeyEntry.extendObject(pfxEntry);
							return true;
						}
						optPfxKeyEntry.nextElementWithKey = optPfxEntry;
						return true;
					}
				}
				_optPrefixKeyTable[hashKey].push(optPfxEntry);
				_optPrefixKeyTable[hashKey].sortOn("affixKey");
			}				
			return true;
			
		}

		
		private function addOptSuffixEntry(sfxEntry:SuffixEntry):Boolean {
			var optSfxEntry:OptimizedSuffixEntry

			//insert suffix key table....
			if ( _optSuffixKeyTable[sfxEntry.affixKey] == undefined ) {
				optSfxEntry = new OptimizedSuffixEntry(sfxEntry);
				optSfxEntry.attributeManager = this;
				_optSuffixKeyTable[sfxEntry.affixKey] = optSfxEntry;
			}
			else {
				var optSfxKeyEntry:OptimizedSuffixEntry = _optSuffixKeyTable[sfxEntry.affixKey];
				while( optSfxKeyEntry.nextElementWithKey != null ) {
					if ( optSfxKeyEntry.isSimilarObject(sfxEntry) ) {
						optSfxKeyEntry.extendObject(sfxEntry);
						return true;
					}
					optSfxKeyEntry = optSfxKeyEntry.nextElementWithKey; 
				}
				if ( optSfxKeyEntry.isSimilarObject(sfxEntry) ) {
					optSfxKeyEntry.extendObject(sfxEntry);
					return true;
				}
				optSfxEntry = new OptimizedSuffixEntry(sfxEntry);
				optSfxEntry.attributeManager = this;
				optSfxKeyEntry.nextElementWithKey = optSfxEntry;
			}				
			return true;
			
		}
		
		
		
		private function addPrefixEntry(pfxEntry:PrefixEntry):Boolean {
			// We may combine prefix/suffix insertion into one function in the future, it could be good for reduce the code size.
			// Since may there is some difference between prefix and suffix, so leave it with different class and different table....
			// need better consideration for performance and code style in next step...
			var flagChar:String;
			flagChar = String.fromCharCode(pfxEntry.flag);
			// insert prefix flag table...
			if ( _prefixFlagTable[flagChar] == undefined )
				_prefixFlagTable[flagChar] = pfxEntry;
			else {
				var pfxFlagEntry:PrefixEntry = _prefixFlagTable[flagChar];
				while( pfxFlagEntry.nextElementWithFlag != null ) {
					pfxFlagEntry = pfxFlagEntry.nextElementWithFlag; 
				}
				pfxFlagEntry.nextElementWithFlag = pfxEntry;
			}
			
			//insert prefix key table....
			if ( _prefixKeyTable[pfxEntry.affixKey] == undefined ) 
				_prefixKeyTable[pfxEntry.affixKey] = pfxEntry;
			else {
				var pfxKeyEntry:PrefixEntry = _prefixKeyTable[pfxEntry.affixKey];
				while( pfxKeyEntry.nextElementWithKey != null ) {
					pfxKeyEntry = pfxKeyEntry.nextElementWithKey; 
				}
				pfxKeyEntry.nextElementWithKey = pfxEntry;
			}			
			return true;
		}
		
		private function addSuffixEntry(sfxEntry:SuffixEntry ):Boolean {
			// We may combine prefix/suffix insertion into one function in the future, it could be good for reduce the code size.
			// Since may there is some difference between prefix and suffix, so leave it with different class and different table....
			// need better consideration for performance and code style in next step...
			var flagChar:String;
			flagChar = String.fromCharCode(sfxEntry.flag);
			// insert suffix flag table...
			if ( _suffixFlagTable[flagChar] == undefined )
				_suffixFlagTable[flagChar] = sfxEntry;
			else {
				var sfxFlagEntry:SuffixEntry = _suffixFlagTable[flagChar];
				while( sfxFlagEntry.nextElementWithFlag != null ) {
					sfxFlagEntry = sfxFlagEntry.nextElementWithFlag; 
				}
				sfxFlagEntry.nextElementWithFlag = sfxEntry;
			}
			
			//insert suffix key table....
			if ( _suffixKeyTable[sfxEntry.affixKey] == undefined ) 
				_suffixKeyTable[sfxEntry.affixKey] = sfxEntry;
			else {
				var sfxKeyEntry:SuffixEntry = _suffixKeyTable[sfxEntry.affixKey];
				while( sfxKeyEntry.nextElementWithKey != null ) {
					sfxKeyEntry = sfxKeyEntry.nextElementWithKey; 
				}
				sfxKeyEntry.nextElementWithKey = sfxEntry;
			}				
			
			return true;
		}
		
		/*
		 * Deprecated function for now...
		 * History: 
		 *          A pre-version of implementation for error detection. After I optimized the code for performance,
		 *          I drop this function by that time, but you know performance meassuring is a tricky problem... 
		 * ToDo: Need a revisit when we implementing complex-affix support and compound-word support.
		 */
		public function addAffixEntry2(affixFlag:int, stripString:String, affixValue:String, conditionsStr:String, morph:String = "", permission:Boolean = false, affixType:int = 0):Boolean{
			if ( stripString == null || affixValue == null || conditionsStr==null || conditionsStr=="" ) return false;
			if ( affixType == 0 ) {
				if ( stripString == null || affixValue == null || conditionsStr==null || conditionsStr=="" ) return false;
				var pfxEntry:PrefixEntry = new PrefixEntry(affixFlag,stripString,affixValue,conditionsStr,morph,permission);
				pfxEntry.attributeManager = this;
				addPrefixEntry(pfxEntry);
			}else {
				if ( stripString == null || affixValue == null || conditionsStr==null || conditionsStr=="" ) return false;
				var sfxEntry:SuffixEntry = new SuffixEntry(affixFlag,stripString,affixValue,conditionsStr,morph,permission);
				sfxEntry.attributeManager = this;
				addSuffixEntry(sfxEntry);	
			}
			return true;
		}
		
		public function get prefixFlagTable():Array {
			return this._prefixFlagTable;
		}
		
		public function get prefixKeyTable():Array {
			return this._prefixKeyTable;
		}
		
		public function get suffixFlagTable():Array {
			return this._suffixFlagTable;
		}
		
		public function get suffixKeyTable():Array {
			return this._suffixKeyTable;
		}
		
		public function set forbiddenWord(value:Number) :void {
			this._forbiddenWord = value;
		}
		
		public function get forbiddenWord():Number {
			return this._forbiddenWord;
		}
		
		public function set ignoredChars(value:String ) :void {
			this._ignoredChars = value;
		}
		
		public function get ignoredChars():String {
			return this._ignoredChars;
		}
		
		public function set keyString(value:String):void {
			this._keyString = value;
		}
		
		public function get keyString():String {
			if ( this._keyString == null ) this._keyString=InternalConstants.SPELL_KEYSTRING;
			return this._keyString;
		}
		
		public function set tryString(value:String):void {
			this._tryString = value;
		}
		
		public function get tryString():String {
			return this._tryString;
		}
		
		public function get contClasses():Dictionary {
			return _contClasses;
		}
		
		
		public function set noSuggest(value:Number ):void {
			this._noSuggest = value;
		}
		public function get noSuggest():Number {
			return this._noSuggest;
		}
		
		public function get simpleFilterTable():Array {
			return this._simpleFilterTable;
		}
		
		public function get iconvFilterTable():Array {
			return this._iconvFilterTable;
		}
		
		public function get oconvFilterTable():Array {
			return this._oconvFilterTable;
		}
		
/*		public function get phoneTable():PhoneticTable {
			return this._phoneTable;
		}
*/		
		public function get breakTable():Array {
			return this._breakTable;
		}
		public function get aliasfTable():Array{
			return this._aliasfTable;
		}

		
		public function get mapFilterTable():Array {
			return this._mapFilterTable;
		}
				
	/*This function is used for supporting ICONV/OCONV rule. This function is called whenever an input or output conversion is needed.*/			
		public function conv(word:String,convWord:Array,ioflag:Boolean):Boolean{
			var searchIndex:int=0;
			var change:Boolean=false;
			var wspace:String;
			var convTable:Array=(ioflag)?this._iconvFilterTable:this._oconvFilterTable;
			if ( (convTable==null) || (convTable.length == 0) ) return false;
			for ( var i:int = 0; i < convTable.length; ++i ) {
				while ( (searchIndex = word.indexOf( convTable[i].matchString,searchIndex)) != -1 ){
					searchIndex = searchIndex + convTable[i].matchString.length;
					wspace = word.substr(0, searchIndex-convTable[i].matchString.length) + 
						convTable[i].replacement + 
						word.substr(searchIndex);
					if(wspace)
						word=wspace;
					change=true;
				}
				
			}
			convWord.push(wspace);
			return change;
		}

	}
}