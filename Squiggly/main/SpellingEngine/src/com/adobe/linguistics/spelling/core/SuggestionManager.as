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
	import com.adobe.linguistics.spelling.core.env.InternalConstants;
	import com.adobe.linguistics.spelling.core.rule.PrefixEntry;
	import com.adobe.linguistics.spelling.core.rule.SuffixEntry;
	import com.adobe.linguistics.spelling.core.utils.*;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class SuggestionManager
	{
		
		private var _attributeMgr:LinguisticRule;
		private var _maxSug:int;
		private var _languageCode:String;
		private var _ckey:String;
		private var _cUpperTry:String;
		private var _cLowerTry:String;
		private var _cAllTry:String;
		private var _maxngramsugs:int;
		private var _fastMode:Boolean;
		
		private var _word:String;
		private var _guessSuggestions:SuggestionsResult;
		private var _guessWordList:SuggestionsResult;
		private var guess:Array = new Array (InternalConstants.MAX_GUESS);
		private var gscore:Array = new Array ( InternalConstants.MAX_GUESS);
		
		public function SuggestionManager( attrMgr:LinguisticRule, fastMode:Boolean = true )
		{
			this._maxSug = InternalConstants.MAXSUGGESTION;
			this._attributeMgr = attrMgr;
			this._ckey = this._attributeMgr.keyString;

			this._cAllTry  = this._attributeMgr.tryString;
			this._cUpperTry = "";
			this._cLowerTry = ""; // lower and netual...
			for ( var i:int = 0; (this._attributeMgr.tryString != null)&&(i < this._attributeMgr.tryString.length); ++i ) {
				if ( this._attributeMgr.tryString.charAt(i) == this._attributeMgr.tryString.charAt(i).toLocaleLowerCase() ) {
					this._cLowerTry+=this._attributeMgr.tryString.charAt(i);
				} else {
					this._cUpperTry+= this._attributeMgr.tryString.charAt(i);
				}
				
			}

			this._maxngramsugs = InternalConstants.MAXNGRAMSUGS;
			this._fastMode = fastMode;
			
			//initialized viriable for performance...
			_word=null;
			_guessSuggestions = new SuggestionsResult(InternalConstants.MAX_ROOTS, compareSuggestion );
			_guessWordList = new SuggestionsResult( InternalConstants.MAX_GUESS, compareSuggestion );
			if ( this._attributeMgr.maxNgramSuggestions > 0 ) this._maxngramsugs = this._attributeMgr.maxNgramSuggestions;
		}
		
		public function get fastMode():Boolean {
			return this._fastMode;
		}
		
		public function set fastMode( value:Boolean ) :void {
			this._fastMode = value;
		}
		
		private static function compareSuggestion( obj1:*, obj2:*):int {
			return (obj1.score-obj2.score);
		}
		
		
		public function set languageCode(value:String) :void {
			this._languageCode = value;	
		}
		
		public function get languageCode():String {
			return this._languageCode;
		}
		
		public function nsuggest( result:Array, word:String ):int {

			if ( !((result.length+this._maxngramsugs) <= this._maxSug) ) return result.length;


			var nsug:int = result.length;
			var i:int,j:int,sc:int, opt:int, n:int = word.length;
			var arr:Array;
			var sd:SquigglyDictionary;
			var dict:Dictionary;
			_word = word;
			var initCap:Boolean = (word.charAt(0) == word.charAt(0).toLocaleLowerCase() )? false:true;
			var wordCapValue:int = word.charAt(0).toLocaleUpperCase().charCodeAt(0);
			_guessSuggestions.clear();
			
			/* A filter based on string length, it could be */
			var rangeOffset:int =5;
			var endRange:int = word.length + (rangeOffset-2);
			var startRange:int =  (word.length>(rangeOffset+2)) ? (word.length-rangeOffset):2  ;
	
					var counter:Number=0
					var startTime:Number = getTimer();

			// exhaustively search through all root words
			// keeping track of the MAX_ROOTS most similar root words
			
			// word reversing wrapper for complex prefixes
			
			// set character based ngram suggestion for words with non-BMP Unicode characters
			
			//a filter for performance improvement...
			var firstCodeValue:Number =word.charCodeAt(0), lastCodeValue:Number = word.charCodeAt(word.length-1);
			
			
			for ( i=0;i<this._attributeMgr.dictionaryManager.dictonaryList.length; ++i ) {
				sd = this._attributeMgr.dictionaryManager.dictonaryList[i];
				dict = sd.dictionary;
				
				var lowerS:String;
				var he:HashEntry;
				opt = InternalConstants.NGRAM_LONGER_WORSE + InternalConstants.NGRAM_LOWERING;
				for( var key:String in dict ) {
					if ( (key.length < startRange) || (key.length > endRange) ) continue;
					if ( (this._fastMode) && (firstCodeValue != key.charCodeAt(0)) && (lastCodeValue != key.charCodeAt(key.length-1)) ) continue;
					counter++;

					sc = ngram( 3, _word,key,opt) + leftCommonSubString(_word, key, initCap, wordCapValue);
					
					if ( sc > 0  ) {
						if ( _guessSuggestions.size < InternalConstants.MAX_ROOTS ) {
							if ( dict[key].affixFlagVector && 
								(dict[key].testAffix( this._attributeMgr.forbiddenWord ) ||
								dict[key].testAffix( this._attributeMgr.onlyInCompound) ||
								dict[key].testAffix( this._attributeMgr.noSuggest ) ||
								dict[key].testAffix( InternalConstants.ONLYUPCASEFLAG )
								)) continue; 
							_guessSuggestions.insert( new SuggestionEntry(sc,key, dict[key] ) );
							if ( _guessSuggestions.size == InternalConstants.MAX_ROOTS ) {
								_guessSuggestions.buildheap();
							}
						}else {
							if ( sc > _guessSuggestions.front.score ) {
								_guessSuggestions.front.score = sc;
								_guessSuggestions.front.key =  key;
								_guessSuggestions.front.hashEntry = dict[key];
								_guessSuggestions.updateFront();
							}
						}
					}
				}
			}
			
			var thresh:int = 0;
			var mw:String;
			for ( var sp:int = 1; sp < 4; ++sp) {
				mw = word;
				for ( var k:int=sp; k<n; k+=4) {
					mw = mw.substring(0,k) + "*" + mw.substring(k+1);
				}
				thresh = thresh + ngram( n, word, mw, InternalConstants.NGRAM_ANY_MISMATCH + InternalConstants.NGRAM_LOWERING);
			}
			thresh = thresh /3;
			thresh --;

			// now expand affixes on each of these root words and
			// and use length adjusted ngram scores to select
			// possible suggestions
			_guessWordList.clear();


			//work arround for inconsitent ordered Dictionary table. bof
			if ( _guessSuggestions.isEmpty() ) return result.length;
			var lowestScore:int = _guessSuggestions.front.score;
			var indexArr:Array;
			if ( _guessSuggestions.size != _guessSuggestions.maxSize ){
				indexArr=_guessSuggestions.data.slice(0,_guessSuggestions.size).sortOn("key",Array.DESCENDING | Array.RETURNINDEXEDARRAY);
			}else{
				indexArr=_guessSuggestions.data.sortOn("key",Array.DESCENDING | Array.RETURNINDEXEDARRAY);
			}
			//work arround for inconsitent ordered Dictionary table. bof

			// root list;
			for each ( i in indexArr ) {
				//work arround for inconsitent ordered Dictionary table. bof
				if ( i==0 || _guessSuggestions.data[i].score == lowestScore ) continue;
				//work arround for inconsitent ordered Dictionary table. bof
				
				var candList:Array = new Array();
				var candOriginalList:Array = new Array();
				expandRootWord(candList,candOriginalList, InternalConstants.MAX_WORDS, _guessSuggestions.data[i].key, _guessSuggestions.data[i].hashEntry, word );
				for ( j=0; j < candList.length; ++j) {
					sc = ngram ( n, word, candList[j], InternalConstants.NGRAM_ANY_MISMATCH + InternalConstants.NGRAM_LOWERING) + leftCommonSubString(word, candList[j],initCap, wordCapValue);
					if ( (sc>thresh) ) {
						if ( _guessWordList.size < InternalConstants.MAX_GUESS ) {
							_guessWordList.insert( new GuessWord(sc,candList[j], null ) );
							if ( _guessWordList.size == InternalConstants.MAX_GUESS ) {
								_guessWordList.buildheap();
							}
						}else {
							if ( sc > _guessWordList.front.score ) {
								_guessWordList.front.score = sc;
								_guessWordList.front.key =  candList[j];
								_guessWordList.front.original = null;
								_guessWordList.updateFront();
							}
						}
						
					}
				}
			}

			// now we are done generating guesses
			// sort in order of decreasing score
			var guessArr:Array = _guessWordList.toArray().sortOn("score",Array.NUMERIC | Array.DESCENDING);


			// weight suggestions with a similarity index, based on
			// the longest common subsequent algorithm and resort
			var refobj:RefObject = new RefObject(0);
			var gl:String;
			for ( i=guessArr.length-1;i>= 0; --i ) {
				gl = guessArr[i].key.toLocaleLowerCase();
				var _lcs:int = StringUtils.lcslen(word, gl);
				// same characters with different casing
				if ( (n==gl.length) && (n == _lcs) ) {
					guessArr[i].score += 2000;
					break;
				}
				// heuristic weigthing of ngram scores
				guessArr[i].score += 
					// length of longest common subsequent minus length difference
					2 * _lcs - Math.abs((int) (n - guessArr[i].key.length)) +
					// weight length of the left common substring
					leftCommonSubString(word, gl,initCap, wordCapValue) +
					// weight equal character positions
					((_lcs == StringUtils.commonCharacterPositions(word, gl, refobj)) ? 1: 0) +
					// swap character (not neighboring)
					((refobj.ref) ? 1000 : 0);
			}

			guessArr = guessArr.sortOn("score", Array.NUMERIC | Array.DESCENDING);
			
			
			// copy over
			var oldnsug:int = nsug;
			var same:int = 0;
			for ( i=0;i< guessArr.length; ++i ) {
				if ( (nsug < this._maxSug) && (result.length < (oldnsug + this._maxngramsugs)) && (!same || (guessArr[i].score > 1000)) ) {
					var unique:int = 1;
					// leave only excellent suggestions, if exists
					if ( guessArr[i].score > 1000 ) same = 1;
					// don't suggest previous suggestions or a previous suggestion with prefixes or affixes
					for ( j=0;j< result.length; ++j) {
						if ( ( guessArr[i].key.indexOf(result[j]) != -1) || !checkWord(guessArr[i].key) ) unique = 0;
					}
					if ( unique ) {
						result.push( guessArr[i].key );
					}
				}
				
			}
			
					var endTime:Number = getTimer();
			return nsug;
		}
		
		private function testValidSuggestion(element:*, gw:GuessWord):Boolean {
			if ( gw.key.indexOf( element ) ) 
				return false;
			if ( !checkWord(element) ) return false; 
			return true;
		}

		private function expandRootWord(guessWordList:Array, guessOriginalList:Array, maxn:int, root:String, he:HashEntry, badWord:String) :void {
			// first add root word to list
			var nh:int = 0, i:int, j:int;
			var sfx:SuffixEntry;
			var pfx:PrefixEntry;
			var newWord:String;
			var crossFlagArray:Array = new Array();
			if ( (guessWordList.length < maxn) && 
			!( (he.affixFlagVector != null) &&
			( (this._attributeMgr.needAffix && he.testAffix(this._attributeMgr.needAffix)) || ( this._attributeMgr.onlyInCompound && he.testAffix(this._attributeMgr.onlyInCompound))))
			){
				guessWordList[nh] = root;
				guessOriginalList[nh] = root;
				crossFlagArray[nh] = false;
				nh++;
			}
			
			// handle suffixes
			for ( i=0; (he.affixFlagVector !=null) && (i<he.affixFlagVector.length);++i) {
				sfx= this._attributeMgr.suffixFlagTable[he.affixFlagVector.charAt(i)];
				while( sfx  ) {
					var index:int = badWord.lastIndexOf(sfx.affixKey);
					if ( (index != -1) && ( index== (badWord.length-sfx.affixKey.length)) ) {
						newWord = sfx.add(root);
						if ( newWord) {
							guessWordList[nh] = newWord;
							guessOriginalList[nh] = root;
							crossFlagArray[nh] = sfx.permissionToCombine;
							nh++;
						}
					}
					sfx = sfx.nextElementWithFlag; 
				}
			}
			
			// handle cross products of prefixes and suffixes
			var n:int = nh;
			for ( j=1;j<n;++j) {
				if( crossFlagArray[j] ) {
					for ( i=0;(he.affixFlagVector !=null) && (i<he.affixFlagVector.length);++i) {
						pfx = this._attributeMgr.prefixFlagTable[he.affixFlagVector.charAt(i)];
						while( pfx ) {
							if ( badWord.indexOf(pfx.affixKey)== 0 ) {
								newWord = pfx.add(guessWordList[j]);
								if ( newWord) {
									guessWordList[nh] = newWord;
									guessOriginalList[nh] = root;
									crossFlagArray[nh] = pfx.permissionToCombine;
									nh++;
								}
							}
							pfx = pfx.nextElementWithFlag;
						}
					}
				}
			}
			
			// now handle pure prefixes
			for ( i=0; (he.affixFlagVector !=null) && (i<he.affixFlagVector.length);++i) {
				pfx= this._attributeMgr.prefixFlagTable[he.affixFlagVector.charAt(i)];
				while( pfx  ) {
					if ( badWord.indexOf(pfx.affixKey) == 0 ) {
						newWord = pfx.add(root);
						if ( newWord) {
							guessWordList[nh] = newWord;
							guessOriginalList[nh] = root;
							crossFlagArray[nh] = pfx.permissionToCombine;
							nh++;
						}
					}
					pfx = pfx.nextElementWithFlag; 
				}
			}
				
		}
		
		/*
		 * ToDo: Since this is a generic algorithm, we might want move this code to StringUtils class.
		 */
		private function ngram(n:int, s1:String, s2:String, opt:int):int {

			var i:int,j:int,k:int,m:int,n:int;
	    	var nscore:int = 0, ns:int, l1:int, l2:int;

			l1 = s1.length;
			l2 = s2.length;
			if ( opt & InternalConstants.NGRAM_LOWERING ) s2=s2.toLowerCase();
			for ( i = 0; i<l1; i++ ) {
				if ( s2.indexOf( s1.charAt(i) ) != -1 ) ns++;
			}
			nscore = nscore + ns;
			if ( ns >= 2 ) {
				for (  j = 2; j<=n; j++ ) {
					ns = 0;
					for (  i = 0; i <=(l1-j); i++ ) {
	//					var tmp:String = s1.substr(i,i+j);
	//					tmp = s1.substring(i,i+j);
						if ( s2.indexOf( s1.substring(i,i+j) ) != -1 ) ns++;   // it could be signaficantly optimized If we can avoid to use substr() function....
					}
					nscore = nscore + ns;
					if (ns < 2) break;
				}
			}
			ns = 0;
			if (opt & InternalConstants.NGRAM_LONGER_WORSE) ns = (l2-l1)-2;
			if (opt & InternalConstants.NGRAM_ANY_MISMATCH) ns = Math.abs(l2-l1)-2;
			ns = (nscore - ((ns > 0) ? ns : 0));
			return ns;
			return 1;
		}

		
		/*
		 * Deprecated function for now...
		 * History: 
		 *          A pre-version of implementation for error correction. After I optimized the code for performance,
		 *          I drop this function by that time, but you know performance meassuring is a tricky problem... 
		 * ToDo: Need a revisit when we implementing complex-affix support and compound-word support.
		 */
		private function ngram1(n:int, s1:String, s2:String, opt:int):int {
	    	var nscore:int = 0, ns:int, l1:int, l2:int;
			
			var i:int,j:int,k:int,m:int,n:int;
			
			l1 = s1.length;
			l2 = s2.length;
			if ( opt & InternalConstants.NGRAM_LOWERING ) s2=s2.toLowerCase();
			for (  j = 1; j<=n; j++ ) {
				ns = 0;
				for (  i = 0; i <=(l1-j); i++ ) {
//					var tmp:String = s1.substr(i,i+j);
//					tmp = s1.substring(i,i+j);
					if ( s2.indexOf( s1.substring(i,i+j) ) != -1 ) ns++;   // it could be signaficantly optimized If we can avoid to use substr() function....
				}
				nscore = nscore + ns;
				if (ns < 2) break;
			}
			ns = 0;
			if (opt & InternalConstants.NGRAM_LONGER_WORSE) ns = (l2-l1)-2;
			if (opt & InternalConstants.NGRAM_ANY_MISMATCH) ns = Math.abs(l2-l1)-2;
			ns = (nscore - ((ns > 0) ? ns : 0));
			return ns;
			return 1;
		}
		
		/*
		 * ToDo: since this is a generic algorithm, we might want to move this function to StringUtils class.
		 */
		private function leftCommonSubString(s1:String,s2:String, initCap:Boolean, s1CapValue:int):int {
			var res:int = 1;
			if ( s1.charCodeAt(0) != s2.charCodeAt(0) && ( !initCap ) && (s1CapValue != s2.charCodeAt(0)) ) return 0;
			for( var i:int=1; (i< s1.length) && (s1.charCodeAt(i) == s2.charCodeAt(i)); ++i ) {
				res++;
			}
			return res;
		}
		
		
		public function suggest( result:Array, word:String, capType:int):int {
			var nsug:int = 0;

			// suggestions for an uppercase word (html -> HTML)
			if ( (nsug < this._maxSug) && (nsug > -1 ) ) {
				nsug = capchars(result,word,nsug);
			}
			
			// perhaps we made a typical fault of spelling
			if ( (nsug < this._maxSug) && (nsug > -1 ) ) {
				nsug = replchars( result, word, nsug );	
			}
			
			// perhaps we made chose the wrong char from a related set
			if ( (nsug < this._maxSug) && (nsug > -1 ) ) {
				nsug = mapchars( result, word, nsug );	
			}

			// did we swap the order of chars by mistake
			if ( (nsug < this._maxSug) && (nsug > -1 ) ) {
				nsug = swapchar( result, word, nsug );	
			}
			
			// did we swap the order of non adjacent chars by mistake
			if ( (nsug < this._maxSug) && (nsug > -1 ) ) {
				nsug = longswapchar( result, word, nsug );	
			}

			// did we just hit the wrong key in place of a good char (case and keyboard)
			if ( (nsug < this._maxSug) && (nsug > -1 ) ) {
				nsug = badcharkey( result, word, nsug );	
			}
			 // did we add a char that should not be there
			if ( (nsug < this._maxSug) && (nsug > -1 ) ) {
				nsug = extrachar( result, word, nsug );	
			}
			
			// did we forgot a char
			if ( (nsug < this._maxSug) && (nsug > -1 ) ) {
				nsug = forgotchar( result, word, nsug, capType );	
			}

			// did we move a char
			if ( (nsug < this._maxSug) && (nsug > -1 ) ) {
				nsug = movechar( result, word, nsug );	
			}

			// did we just hit the wrong key in place of a good char
			if ( (nsug < this._maxSug) && (nsug > -1 ) ) {
				nsug = badchar( result, word, nsug, capType );	
			}
			
			// did we double two characters
			if ( (nsug < this._maxSug) && (nsug > -1 ) ) {
				nsug = doubletwochars( result, word, nsug );	
			}
			
			// perhaps we forgot to hit space and two words ran together
			if ( (nsug < this._maxSug) && (nsug > -1 ) ) {
				nsug = twowords( result, word, nsug );	
			}

			return nsug;
		}
		
		
		
		private function mapchars( result:Array, word:String, nsug:int ) :int {
			if (word.length < 2) return nsug;
			if ( (nsug == this._maxSug) || (this._attributeMgr.mapFilterTable.length == 0) ) return nsug;
			var mapTable:Array = this._attributeMgr.mapFilterTable;
			var counter:int = 0;
			nsug = map_related(result, word, nsug, 0 ,mapTable, counter);
			
			return nsug;
		}		

		private function map_related( result:Array, word:String, nsug:int, startIndex:int, mapTable:Array, counter:int) :int {
			var totalCheckCount:int = 8; // for performance issue only... 8 means four level detection...
			var candidate:String;
			var in_map:int = 0;
			var j:int;
			counter++;
			if ( counter > totalCheckCount ) return nsug; // for performance issue only...
			if ( nsug == this._maxSug ) return nsug;
			if ( startIndex == word.length ) {
				var cwrd:int = 1;
				for (  j=0; j < result.length; ++j ) {
					if ( result[j]== word ) cwrd=0;
				}
				if ( cwrd && checkWord(word) ) {
					result.push(word);
					nsug++;
				}
				return nsug;
				
			}
			for ( var i:int = 0;i<mapTable.length ;++i ) {
				if ( mapTable[i].mapCharSet.indexOf(word.charAt(startIndex)) != -1 ) {
					in_map= 1;
					for ( j =0; j< mapTable[i].mapCharSet.length; ++j ) {
						candidate = word.substring(0,startIndex) +mapTable[i].mapCharSet.charAt(j)+word.substring(startIndex+1);
						nsug = map_related(result,candidate,nsug,(startIndex+1),mapTable, counter);
					}
				}				
			}
			
			if( !in_map) {
				nsug = map_related(result,word,nsug,(startIndex+1),mapTable, counter);
			}
			return nsug;
		} 
		
		private function twowords( result:Array, word:String, nsug:int ) :int {
			var candidate:String;
			var cwrd:int=1;
			var count:int=0;
			if (word.length < 3) return result.length;
			if ( result.length >= this._maxSug ) return result.length;
			
			for( var i:int=1;i<word.length;++i) {
				candidate = word.substring(0,i);
				if ( !checkWord(candidate) ) continue;
				candidate = word.substring(i);
				if ( checkWord(candidate) ) {
					candidate = word.substring(0,i) +" " + word.substring(i);
					for ( var j:int=0; j < result.length; ++j ) {
						if ( result[j]== candidate ) cwrd=0;
					}
					if ( cwrd ) {
						if ( result.length >= this._maxSug ) return result.length;
						result.push(candidate);
						nsug++;
					}
				}
			}

			return nsug;
		}		

		private function doubletwochars( result:Array, word:String, nsug:int ) :int {
			var candidate:String;
			var nstate:int=0;
			if (word.length < 5) return nsug;
			for (var i:int=2;i<word.length;++i) {
				if( word.charCodeAt(i) == word.charCodeAt(i-2) ) {
					nstate++;
					if ( nstate==3) {
						candidate = word.substring(0,i-1)+word.substring(i+1);
						nsug = testSuggestion( result,candidate, nsug);
						if ( nsug == -1 || nsug == this._maxSug ) return nsug;
						nstate = 0;
					}
				}else {
					nstate=0;
				}
			}
			return nsug;
		}

		private function badchar( result:Array, word:String, nsug:int, capType:int ) :int {
			if ( this._cAllTry == null ) return nsug;
			if (word.length < 2) return nsug;
			var candidate:String;
			var i:int, j:int;			
			switch(capType) {
				case InternalConstants.NOCAP: {
					// first for init capticalized case...
					for ( i = 0; i< this._cAllTry.length;++i) {
						candidate = this._cAllTry.charAt(i)+word.substring(1);
						nsug = testSuggestion( result,candidate, nsug);
						if ( nsug == -1 || nsug == this._maxSug ) return nsug;
					}
					// for the rest of the word...
					for ( i = 0; i< this._cLowerTry.length;++i) {
						for ( j=1;j<word.length;++j) {
							candidate = word.substring(0,j)+this._cLowerTry.charAt(i)+word.substring(j+1);
							nsug = testSuggestion( result,candidate, nsug);
							if ( nsug == -1 || nsug == this._maxSug ) return nsug;
						}
					}
					break;
				}
				case InternalConstants.INITCAP:{
					// first for init capticalized case...
					for ( i = 0; i< this._cAllTry.length;++i) {
						candidate = this._cAllTry.charAt(i)+word.substring(1);
						nsug = testSuggestion( result,candidate, nsug);
						if ( nsug == -1 || nsug == this._maxSug ) return nsug;
					}
					// for the rest of the word...
					for ( i = 0; i< this._cLowerTry.length;++i) {
						for ( j=1;j<word.length;++j) {
							candidate = word.substring(0,j)+this._cLowerTry.charAt(i)+word.substring(j+1);
							nsug = testSuggestion( result,candidate, nsug);
							if ( nsug == -1 || nsug == this._maxSug ) return nsug;
						}
					}
					break;
				}
				case InternalConstants.HUHCAP: { 
				}
				case InternalConstants.HUHINITCAP:{ 
					for ( i = 0; i< this._cAllTry.length;++i) {
						for ( j=0;j<word.length;++j) {
							candidate = word.substring(0,j)+this._cAllTry.charAt(i)+word.substring(j+1);
							nsug = testSuggestion( result,candidate, nsug);
							if ( nsug == -1 || nsug == this._maxSug ) return nsug;
						}
					}
					break;
				}
				case InternalConstants.ALLCAP: {
					for ( i = 0; i< this._cUpperTry.length;++i) {
						for ( j=0;j<word.length;++j) {
							candidate = word.substring(0,j)+this._cUpperTry.charAt(i)+word.substring(j+1);
							nsug = testSuggestion( result,candidate, nsug);
							if ( nsug == -1 || nsug == this._maxSug ) return nsug;
						}
					}
					break;
				}
			}
			
			return nsug;
		}		

		// did we move a char
		private function movechar( result:Array, word:String, nsug:int ) :int {
			var candidate:String;
			var i:int,j:int;
			var char:String;
			if (word.length < 3) return nsug;
			for ( i=0;i<word.length-2;++i) {
				char = word.charAt(i);
				for ( j=i+2;j<word.length;++j) {
					candidate = word.substring(0,i)+word.substring(i+1,j+1)+char+word.substring(j+1);
					nsug = testSuggestion( result,candidate, nsug);
					if ( nsug == -1 || nsug == this._maxSug ) return nsug;
				}
			}
			
			for ( i=word.length-1;i>=2;--i) {
				char = word.charAt(i);
				for ( j=i-2;j>=0; --j) {
					candidate = word.substring(0,j)+char+word.substring(j,i)+word.substring(i+1);
					nsug = testSuggestion( result,candidate, nsug);
					if ( nsug == -1 || nsug == this._maxSug ) return nsug;
				}
			}
			
			return nsug;
		}		

		private function forgotchar( result:Array, word:String, nsug:int, capType:int ) :int {
			if ( this._cAllTry == null ) return nsug;
			var candidate:String;
			var i:int, j:int;			
			if (word.length < 2) return nsug;
			switch(capType) {
				case InternalConstants.NOCAP: {
					for (i =0; i< this._cAllTry.length; ++i ) {
						candidate= _cAllTry.charAt(i) + word.substring(0);
						nsug = testSuggestion( result,candidate, nsug);
						if ( nsug == -1 || nsug == this._maxSug ) return nsug;
					}

					for (i =0; i< this._cLowerTry.length; ++i ) {
						for ( j=1; j< word.length;j++) {
							candidate= word.substring(0,j)+_cLowerTry.charAt(i) + word.substring(j);
							nsug = testSuggestion( result,candidate, nsug);
							if ( nsug == -1 || nsug == this._maxSug ) return nsug;
						}
						candidate= word+_cLowerTry.charAt(i);
						nsug = testSuggestion( result,candidate, nsug);
						if ( nsug == -1 || nsug == this._maxSug ) return nsug;
					}
					break;
				}
				case InternalConstants.INITCAP:{
					// first for init capticalized case...
					for (i =0; i< this._cAllTry.length; ++i ) {
						candidate= _cAllTry.charAt(i) + word.substring(0);
						nsug = testSuggestion( result,candidate, nsug);
						if ( nsug == -1 || nsug == this._maxSug ) return nsug;
					}

					for (i =0; i< this._cLowerTry.length; ++i ) {
						for ( j=1; j< word.length;j++) {
							candidate= word.substring(0,j)+_cLowerTry.charAt(i) + word.substring(j);
							nsug = testSuggestion( result,candidate, nsug);
							if ( nsug == -1 || nsug == this._maxSug ) return nsug;
						}
						candidate= word+_cLowerTry.charAt(i);
						nsug = testSuggestion( result,candidate, nsug);
						if ( nsug == -1 || nsug == this._maxSug ) return nsug;
					}
					break;
				}
				case InternalConstants.HUHCAP: { 
				}
				case InternalConstants.HUHINITCAP:{ 
					for (i =0; i< this._cAllTry.length; ++i ) {
						for ( j=1; j< word.length;j++) {
							candidate= word.substring(0,j)+_cAllTry.charAt(i) + word.substring(j);
							nsug = testSuggestion( result,candidate, nsug);
							if ( nsug == -1 || nsug == this._maxSug ) return nsug;
						}
						candidate= word+_cAllTry.charAt(i);
						nsug = testSuggestion( result,candidate, nsug);
						if ( nsug == -1 || nsug == this._maxSug ) return nsug;
					}
					break;
				}
				case InternalConstants.ALLCAP: {
					for (i =0; i< this._cUpperTry.length; ++i ) {
						for ( j=0; j< word.length;j++) {
							candidate= word.substring(0,j)+_cUpperTry.charAt(i) + word.substring(j);
							nsug = testSuggestion( result,candidate, nsug);
							if ( nsug == -1 || nsug == this._maxSug ) return nsug;
						}
						candidate= word+_cUpperTry.charAt(i);
						nsug = testSuggestion( result,candidate, nsug);
						if ( nsug == -1 || nsug == this._maxSug ) return nsug;
					}
					break;
				}
			}
			return nsug;
		}		

		// error is word has an extra letter it does not need 
		private function extrachar( result:Array, word:String, nsug:int ) :int {
			var candidate:String;
			if (word.length < 2) return nsug;
			for ( var i:int=0; i< word.length ; ++i ) {
				candidate = word.substring(0,i) + word.substring(i+1);
				nsug = testSuggestion( result,candidate, nsug);
				if ( nsug == -1 || nsug == this._maxSug ) return nsug;
			}
			return nsug;
		}		
		
		// error is wrong char in place of correct one (case and keyboard related version)
		private function badcharkey( result:Array, word:String, nsug:int ) :int {
			var candidate:String;
			if (word.length < 2) return nsug;
			var startIndex:int = 0;
			// swap out each char one by one and try uppercase and neighbor
			// keyboard chars in its place to see if that makes a good word
			for ( var i:int =0; i<word.length; ++i) {
				// check with uppercase letters
				if ( word.charAt(i).toLocaleUpperCase() != word.charAt(i) ) {
					candidate = word.substring(0,i)+word.charAt(i).toLocaleUpperCase()+word.substring(i+1);
					nsug = testSuggestion( result,candidate, nsug);
					if ( nsug == -1 || nsug == this._maxSug ) return nsug;
				}
				// check neighbor characters in keyboard string
				if ( this._ckey == null ) continue;
				startIndex = this._ckey.indexOf(word.charAt(i),startIndex);
				while ( startIndex != -1 ) {
					if ( (startIndex!=0) && (_ckey.charAt(startIndex-1) != "|" ) ) {
						candidate = word.substring(0,i)+_ckey.charAt(startIndex-1)+word.substring(i+1);
						nsug = testSuggestion( result,candidate, nsug);
						if ( nsug == -1 || nsug == this._maxSug ) return nsug;
					}
					if ( (_ckey.charAt(startIndex+1)!="|") && (startIndex != _ckey.length - 1) ) {
						candidate = word.substring(0,i)+_ckey.charAt(startIndex+1) + word.substring(i+1);
						nsug = testSuggestion( result,candidate, nsug);
						if ( nsug == -1 || nsug == this._maxSug ) return nsug;
					}
					startIndex = this._ckey.indexOf(word.charAt(i),startIndex+1);
				}
			}
			
			return nsug;
		}		

		private function longswapchar( result:Array, word:String, nsug:int ) :int {
			var candidate:String;
			if (word.length < 2) return nsug;
			for ( var i:int =0 ; i< word.length-2; ++i ) {
				for ( var j:int = i+2;j< word.length;++j) {
					candidate = word.substring(0,i)+ word.charAt(j) + word.substring(i+1,j) + word.charAt(i) + word.substring(j+1);
					nsug = testSuggestion( result,candidate, nsug);
					if ( nsug == -1 || nsug == this._maxSug ) return nsug;
				}
			}
			return nsug;
		}		

		private function swapchar( result:Array, word:String, nsug:int ) :int {
			var candidate:String;
			if (word.length < 2) return nsug;
			var i:int;
			var wl:int = word.length;
			// try swapping adjacent chars one by one
			for (i=0;i< wl-1;++i) {
				candidate = word.substring(0,i)+word.charAt(i+1)+word.charAt(i) + word.substring(i+2);
				nsug = testSuggestion( result,candidate, nsug);
				if ( nsug == -1 || nsug == this._maxSug ) return nsug;
			}
			
			if ( wl == 4 || wl == 5 ) {
				candidate = word.charAt(1) + word.charAt(0);
				if ( wl == 5) candidate +=word.charAt(2);
				candidate += word.charAt(wl - 1) + word.charAt(wl - 2); 
				nsug = testSuggestion( result,candidate, nsug);
				if ( nsug == -1 || nsug == this._maxSug ) return nsug;
				if ( wl == 5 )  {
					candidate = word.charAt(0) + word.charAt(2) + word.charAt(1) + candidate.substr(3);
					nsug = testSuggestion( result,candidate, nsug);
					if ( nsug == -1 || nsug == this._maxSug ) return nsug;
				}
			}
			return nsug;
			
		}		
		private function replchars( result:Array, word:String, nsug:int ) :int {
			var candidate:String;
			if (word.length < 2) return nsug;
			var searchIndex:int=0;
			if ( (this._attributeMgr.simpleFilterTable==null) || (this._attributeMgr.simpleFilterTable.length == 0) ) return nsug;
			for ( var i:int = 0; i < this._attributeMgr.simpleFilterTable.length; ++i ) {
				while ( (searchIndex = word.indexOf( this._attributeMgr.simpleFilterTable[i].matchString,searchIndex)) != -1 ){
					searchIndex = searchIndex + this._attributeMgr.simpleFilterTable[i].matchString.length;
					candidate = word.substr(0, searchIndex-this._attributeMgr.simpleFilterTable[i].matchString.length) + 
					this._attributeMgr.simpleFilterTable[i].replacement + 
					word.substr(searchIndex);
					nsug = testSuggestion( result,candidate, nsug);
					if ( nsug == -1 || nsug == this._maxSug ) return nsug;
				}
				
			}
			return nsug;
		}
		
		private function capchars( result:Array, word:String, nsug:int) : int {
			var candidate:String = word.toLocaleUpperCase();
			return testSuggestion(result,candidate,nsug);
		}
		
		private function testSuggestion(result:Array, word:String, nsug:int):int {
			var cwrd:int=1;
			if ( result.length >= this._maxSug ) return nsug;
			for ( var i:int=0; i < result.length; ++i ) {
				if ( result[i]== word ) cwrd=0;
			}
			
			if ( (cwrd) && checkWord(word) ) {
				result.push(word);
				nsug++;
			}
			return nsug;
		}

		// see if a candidate suggestion is spelled correctly
		// needs to check both root words and words with affixes
		
		// ToDo the following in next release...
		// obsolote MySpell-HU modifications:
		// return value 2 and 3 marks compounding with hyphen (-)
		// `3' marks roots without suffix   

		private function checkWord(word:String):int {
			var rv:HashEntry = null;
			var nosuffix:int =0;
			if ( this._attributeMgr ) {
				rv = _attributeMgr.lookup(word);
				if ( rv ) {
					if ( (rv.affixFlagVector) && ( rv.testAffix(this._attributeMgr.forbiddenWord) || rv.testAffix(this._attributeMgr.noSuggest) )  ){
						return 0;
					}
					while ( rv ) {
						if ( (rv.affixFlagVector) &&  ( rv.testAffix(this._attributeMgr.needAffix) || rv.testAffix(InternalConstants.ONLYUPCASEFLAG) || rv.testAffix(this._attributeMgr.onlyInCompound) )  ) {
							rv = rv.next
						}else break;
					}
				}else rv = _attributeMgr.optPrefixCheck2(word, 0,0) // only prefix, and prefix + suffix XXX
				
				if ( rv ) {
					nosuffix = 1;
				}else {
					rv = _attributeMgr.optSuffixCheck2(word,0,null,0,0);
				}
				//this is added after we have two level suffix stripping
				if (!rv &&  this._attributeMgr.haveContClass) {
					rv = this._attributeMgr.optTwoSuffixCheck(word, 0, null, 0);
					if (!rv) rv = this._attributeMgr.optTwoPrefixCheck(word,1, 0);
				}
				
				// check forbidden words
				if ( (rv) && (rv.affixFlagVector) && ( rv.testAffix(this._attributeMgr.forbiddenWord) || rv.testAffix(InternalConstants.ONLYUPCASEFLAG) 
				|| rv.testAffix(this._attributeMgr.noSuggest) || rv.testAffix(this._attributeMgr.onlyInCompound) ) ) {
					return 0;
				}
				if ( rv ) {
					//// XXX obsolote ToDo
					return 1;
				}
				
			}
			return 0;
		}
		
	}
}


internal class GuessWord {
	private var _score:int;
	private var _key:String;
	private var _original:String;
	
	public function GuessWord(score:int, key:String, original:String){
		this.key = key;
		this.score = score;
		this.original = original;
	}
	
	public function get score():int {
		return this._score;
	}
	public function set score(value:int) :void {
		this._score = value;
	}
	
	public function get key():String {
		return this._key;
	}
	public function set key(value:String) :void {
		this._key = value;
	}
	public function get original():String {
		return this._original;
	}
	public function set original(value:String) :void {
		this._original = value;
	}
}

internal class SuggestionEntry {
	import com.adobe.linguistics.spelling.core.HashEntry;
	private var _score:int;
	private var _key:String;
	private var _hashEntry:HashEntry; 
	
	public function SuggestionEntry(score:int, key:String, hashEntry:HashEntry) {
		this.key = key;
		this.score = score;
		this.hashEntry = hashEntry;
		
	}
	
	public function get score():int {
		return this._score;
	}
	public function set score(value:int) :void {
		this._score = value;
	}
	
	public function get key():String {
		return this._key;
	}
	public function set key(value:String) :void {
		this._key = value;
	}
	
	public function get hashEntry():HashEntry {
		return this._hashEntry;
	}
	
	public function set hashEntry(value:HashEntry ) :void {
		this._hashEntry = value;
	}
	
}
