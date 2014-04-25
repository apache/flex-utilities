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

	import com.adobe.linguistics.spelling.core.env.ExternalConstants;
	import com.adobe.linguistics.spelling.core.env.InternalConstants;
	import com.adobe.linguistics.spelling.core.utils.*;
	
	public class SquigglyEngine
	{

		private var _ignoreCappedWord:Boolean;		// Hello is always correct
		private var _ignoreAllUpperCase:Boolean;	// HELLO is always correct
		private var _ignoreWordWithNumber:Boolean;	// win2003 is always correct
		private var wordBreak:Array;				// Used to hold BREAK characters for BREAK rule
		private const SPELL_COMPOUND:int =				(1 << 0);
		private const SPELL_FORBIDDEN:int =				(1 << 1);
		private const SPELL_ALLCAP:int =				(1 << 2);
		private const SPELL_NOCAP:int =					(1 << 3);
		private const SPELL_INITCAP:int =				(1 << 4);

		private const MAXDIC:int =						20;
		private const MAXSHARPS:int =					5;

		private var attributeMgr:LinguisticRule;
		private var dictMgr:DictionaryManager;
		private var sugestionMgr:SuggestionManager;
		private var encoding:String;
		private var wordbreak:Array;//an Array that holds the word breaks
		private var langCode:int;
		private var complexPrefixes:int;
		private var maxWordLength:int;

		public function SquigglyEngine( rule:LinguisticRule, dict:SquigglyDictionary )
		{
			if ( rule == null ) throw new Error("illegal argument for constructor", 200901);
			if ( dict == null ) throw new Error("illegal argument for constructor", 200901);
			
			maxWordLength = InternalConstants.MAXWORDLEN;
			
			dictMgr = new DictionaryManager();
			dictMgr.addDictionary(dict);
			attributeMgr = rule;
			attributeMgr.dictionaryManager = dictMgr;
			sugestionMgr = new SuggestionManager( rule, false);
			this.wordbreak=attributeMgr.breakTable;
			this.ignoreWordWithNumber = false;
			this.ignoreCappedWord = false;
			this.ignoreAllUpperCase = false;

		}
		
		public function set ignoreWordWithNumber( value:Boolean):void {
			this._ignoreWordWithNumber =value;
		}
		public function get ignoreWordWithNumber():Boolean {
			return this._ignoreWordWithNumber;
		}
		
		public function set ignoreCappedWord(value:Boolean):void {
			this._ignoreCappedWord = value;
		}
		public function get ignoreCappedWord():Boolean {
			return this._ignoreCappedWord;
		}
		
		public function set ignoreAllUpperCase(value:Boolean ):void {
			this._ignoreAllUpperCase = value;
		}
		public function get ignoreAllUpperCase():Boolean {
			return this._ignoreAllUpperCase;
		}
		
		public function set fastMode(value:Boolean ) :void {
			this.sugestionMgr.fastMode = value;
		}
		
		public function get fastMode():Boolean {
			return this.sugestionMgr.fastMode;
		}
		
		public function addDictionary( dict:SquigglyDictionary ) : Boolean {
			return dictMgr.addDictionary(dict);
		}
		
		public function spell( word:String ) :Boolean {
			if ( word.length > maxWordLength ) return false;
			
			word = StringUtils.normalize(word);
			
			var captype:int = InternalConstants.NOCAP;
			var hasNumber:Boolean =false; //assuming that there are no numbers;
			var abbv:int = 0;
			var i:int;
			var rv:HashEntry = null;
			var info:SpellingInfo = new SpellingInfo(0);
			var wspace:String;
			// input conversion USING ICONV TABLE
/*	//Commented code is a unit test code
			var teststr:String="marùvîà ";
			var teststr2:String;
this.attributeMgr.conv(teststr,convWord,true);
	teststr2=convWord.pop();
	if(teststr2){
	trace("Called Word "+teststr+"converted word "+teststr2);
	}
	else 
	trace("NUUUllll");
*/

			var convWord:Array=new Array;
			if(this.attributeMgr && this.attributeMgr.iconvFilterTable && this.attributeMgr.iconvFilterTable.length!=0){
			this.attributeMgr.conv(word,convWord,InternalConstants.CONV_ICONV);
			wspace=convWord.pop();
			if(wspace) word=wspace;
			}
			
			// first skip over any leading or trailing blanks
			word = StringUtils.trim( word );
			
			// now strip off any trailing periods (recording their presence)
			for ( i = word.length-1; (i>=0) && (word.charCodeAt(i) == 46) ; --i ) { // '.'
				abbv++;
			}
			word = word.substr(0, word.length- abbv );
			captype = StringUtils.getCapType(word);
			hasNumber=StringUtils.getHasNumber(word);
			if ( (dictMgr.isEmpty()) || (word.length == 0) ) return false;
			
			// allow numbers with dots, dashes and commas (but forbid double separators: "..", "--" etc.)
			const NBEGIN:int = 0, NNUM:int=1, NSEP:int=2;
			var nstate:int = NBEGIN;
			var charCode:int;
			for ( i=0 ; i < word.length ; ++i ) {
				charCode =  word.charCodeAt(i);
				if ( (charCode <= 57 ) && ( charCode >= 48) ) { // '0' to '9'
					nstate = NNUM;
				}else if ( (charCode==44) || (charCode==45) || (charCode==46) ) { //',' or '.' or '-'
					if ( (nstate == NSEP) || ( i==0 ) ) return false;
					nstate = NSEP;
				}else break;
			}
			if ( (i==word.length) && ( nstate == NNUM ) ) return true;//checks if all are just numbers
			// ignore word with Number.
			if ( ignoreWordWithNumber && hasNumber)return true;//Ignore word with numbers!
				
			// ignore cappitalized word  or ignore all upper case word.
			if ( (ignoreCappedWord &&( (captype&InternalConstants.HUHINITCAP) || (captype&InternalConstants.INITCAP))&&(hasNumber==false) ) || (ignoreAllUpperCase&&(captype & InternalConstants.ALLCAP)&&(hasNumber==false)) ) return true;	//return only if it does not have number	
			
			
			switch(captype) {
				case InternalConstants.HUHCAP:
				case InternalConstants.HUHINITCAP:
				case InternalConstants.NOCAP:
					rv = checkWord(word,info);
					if ( (abbv!=0) && (rv == null ) ) {
						word += ".";
						rv = checkWord(word,info);
					}
					break;
				case InternalConstants.ALLCAP:
					rv = checkWord(word,info);
					if( rv ) break;
					if ( (abbv!=0 ) ) {
						word +=".";
						rv = checkWord(word,info);
						if ( rv ) break;
					}
					// ToDo:   Spec. prefix handling for Catalan, French, Italian:
					// prefixes separated by apostrophe (SANT'ELIA -> Sant'+Elia).
					// need better understand...
					
					//sharps handle....

					word = word.charAt(0).toUpperCase()+word.slice(1).toLocaleLowerCase();
					
				case InternalConstants.INITCAP: 
					if (captype == InternalConstants.INITCAP) info.Info +=ExternalConstants.SPELL_INITCAP;
					wspace = word.toLocaleLowerCase();
					rv = checkWord(word,info);
					if (captype == InternalConstants.INITCAP) info.Info -=ExternalConstants.SPELL_INITCAP;
					
					// forbid bad capitalization
					// (for example, ijs -> Ijs instead of IJs in Dutch)
					// use explicit forms in dic: Ijs/F (F = FORBIDDENWORD flag)
					if (info.Info & ExternalConstants.SPELL_FORBIDDEN) {
						rv = null;
					}
					
					if ( rv && (captype == InternalConstants.ALLCAP ) ) {
						if ( attributeMgr && rv.affixFlagVector && attributeMgr.keepCase && rv.testAffix(attributeMgr.keepCase) ) rv = null;
					}
					if ( rv) break;
					
					rv = checkWord(wspace,info);
					if ( !rv && abbv ) {
						wspace += ".";
						rv = checkWord(wspace,info);
						if ( !rv) {
							word += ".";
							if (captype == InternalConstants.INITCAP) info.Info +=ExternalConstants.SPELL_INITCAP;
							rv = checkWord(word,info);
							if (captype == InternalConstants.INITCAP) info.Info -=ExternalConstants.SPELL_INITCAP;
							if ( rv && (captype == InternalConstants.ALLCAP ) ) {
								if ( attributeMgr && rv.affixFlagVector && attributeMgr.keepCase && rv.testAffix(attributeMgr.keepCase) ) rv = null;
							}
						}
					} 
					if ( rv && (captype == InternalConstants.ALLCAP ) ) {
						if ( attributeMgr && rv.affixFlagVector && attributeMgr.keepCase && rv.testAffix(attributeMgr.keepCase) ) rv = null;
					}
					break;
				default:
			}
			
			if ( rv ) return true;
			
			//implementation break-table... recursive breaking at break points
			
			if(wordbreak){
				var nbr:int=0;
				var parseArr:Array;
				var searchIndex:int=0;
				for(i=0; i<wordbreak.length;i++){
					//Search for number of break points in this word
					searchIndex=0;
					wspace=word;
					while (wspace && ((searchIndex=wspace.indexOf(wordbreak[i])) != -1 )) {
						nbr++;
						if(nbr>InternalConstants.MAX_WORD_BREAKS) return false;//Limiting maximum Word breaks
						if(searchIndex<word.length)wspace=wspace.substr(searchIndex+1);
					}		
				}
				 
				
				for(var j:int=0; j<wordbreak.length;j++){
				
					if(word.search(wordbreak[j])!=-1 && (parseArr=word.split(wordbreak[j]))!=null)
					{
									
						for(i=0;i<parseArr.length;i++)
							if(! spell(parseArr[i]) ) return false;//keep checking all parts of the input word. If any part is wrongly spelt send false
						
						return true;//no part is spelled wrong so send correct
					}
								
				}
							
			}
		
			return false;
		}
		
		public function suggest( word:String ) : Array {
			if ( word.length > maxWordLength ) return null;
			var captype:int = InternalConstants.NOCAP;
			var capwords:int = 0;

			var abbv:int = 0;
			var i:int,ns:int;
			var wspace:String;
			var slst:Array = new Array();
			var convWord:Array=new Array;
			// input conversion USING ICONV TABLE
			if(this.attributeMgr && this.attributeMgr.iconvFilterTable.length!=0){
				this.attributeMgr.conv(word,convWord,InternalConstants.CONV_ICONV);
			wspace=convWord.pop();
			if(wspace)word=wspace;
			}
			
			// first skip over any leading or trailing blanks
			word = StringUtils.trim( word );
			// now strip off any trailing periods (recording their presence)
			for ( i = word.length-1; (i>=0) && (word.charCodeAt(i) == 46) ; --i ) { // '.'
				abbv++;
			}
			word = word.substr(0, word.length- abbv );
			captype = StringUtils.getCapType(word);
			if ( (dictMgr.isEmpty()) || (word.length == 0) ) return null;
			switch(captype) {
				case InternalConstants.NOCAP: {
					ns = sugestionMgr.suggest( slst, word, InternalConstants.NOCAP );
					break;
				}
				case InternalConstants.INITCAP:{
					capwords = 1;
					ns = sugestionMgr.suggest( slst, word, InternalConstants.INITCAP );
					if ( ns ==  -1) break;
					wspace = word.toLocaleLowerCase();
					ns = sugestionMgr.suggest( slst, wspace, InternalConstants.NOCAP );
					break;
				}
				case InternalConstants.HUHINITCAP:{ 
					capwords = 1;
				}
				case InternalConstants.HUHCAP: { // ToDo: still a lot of work...
					ns = sugestionMgr.suggest( slst, word, InternalConstants.HUHCAP );
					break;
				}
				case InternalConstants.ALLCAP: {
					wspace = word.toLocaleLowerCase();
					ns = sugestionMgr.suggest( slst, wspace, InternalConstants.NOCAP );
					if ( ns ==  -1) break;
					if ( this.attributeMgr.keepCase && spell(word ) ) {
						//ns = insert_sug(slst, wspace, ns); ToDo
					}
					wspace = word.charAt(0).toUpperCase()+word.slice(1).toLocaleLowerCase();	
					ns = sugestionMgr.suggest( slst, wspace, InternalConstants.INITCAP );
					break;
				}
			}
			
			// try ngram approach since found nothing
			if ( this.attributeMgr && (this.attributeMgr.maxNgramSuggestions != 0)) {
				ns = sugestionMgr.nsuggest(slst,word);
			}
			
			// try dash suggestion (Afo-American -> Afro-American)
			
			// capitalize
			if (capwords) {
				for ( i=0;i<slst.length; ++i ) {
					slst[i] = slst[i].charAt(0).toUpperCase()+slst[i].slice(1);	
				}
			}
			
			// expand suggestions with dot(s)
			if ( abbv && this.attributeMgr.suggestionsWithDots ) {
				for ( i=0;i<slst.length; ++i ) {
					slst[i] += ".";	
				}
				
			}
			
			// remove bad capitalized and forbidden forms

			// remove original one
			for ( i=0;i<slst.length;++i) {
				if ( slst[i] == word ) 
					slst.splice(i,1);
			}
			
			// remove duplications
			
			// output conversion
			
			if(this.attributeMgr && this.attributeMgr.oconvFilterTable && this.attributeMgr.oconvFilterTable.length!=0){
				for(i=0;i<slst.length;++i){
					if(this.attributeMgr.conv(slst[i],convWord,InternalConstants.CONV_OCONV))	
					{wspace=convWord.pop();delete(slst[i]); slst[i]=wspace;} 
				}
			}
			
			// if suggestions removed by nosuggest, onlyincompound parameters


			return (slst.length!=0) ? slst :null;
		}
		
		private function checkWord( word:String, info:SpellingInfo ):HashEntry {
			var i:int;
			var he:HashEntry = null;
			if ( attributeMgr.ignoredChars )  {
				word = StringUtils.removeIgnoredChars(word, attributeMgr.ignoredChars);
			}
			// word reversing wrapper for complex prefixes
			/*
			if(complexprefixes) {
				word=reverseword(word);
			}
			*/
			
			// look word in hash table
			for ( i=0; i < dictMgr.dictonaryList.length && !he; ++i ) {
				he = dictMgr.dictonaryList[i].getElement(word);
				// check forbidden and onlyincompound words
				if ( he && (he.affixFlagVector != null) && 
					((attributeMgr) && ( he.testAffix(attributeMgr.forbiddenWord)))
				
				) {
					// ToDo: LANG_hu section: set dash information for suggestions
					return null;
				}
				// ToDo: he = next not needaffix, onlyincompound homonym or onlyupcase word
/*				while (he && (he.affixFlagVector) &&
					((attributeMgr.needAffix && testAffix(he.affixFlagVector, attributeMgr.needAffix)) ||
						(pAMgr->get_onlyincompound() && TESTAFF(he->astr, pAMgr->get_onlyincompound(), he->alen)) ||
						(info && (*info & SPELL_INITCAP) && TESTAFF(he->astr, ONLYUPCASEFLAG, he->alen))
					)) //he = he.next; should maintain a next homonym which is not being maintained as of now next_homonym;
*/			}
					
			// check with affixes
			if ( !he && attributeMgr ) {
				he = attributeMgr.affixCheck2(word,0,0);
				//DO not allow affixed forms of forbidden words
				if ( he && (he.affixFlagVector != null) && (attributeMgr) && he.testAffix(attributeMgr.forbiddenWord) ) {
					// ToDo: LANG_hu section: set dash information for suggestions
					return null;
				}
			}
			
			return he;
		}
		

	}
}