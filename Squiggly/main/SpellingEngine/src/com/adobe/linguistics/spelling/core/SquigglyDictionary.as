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



package  com.adobe.linguistics.spelling.core
{

	import com.adobe.linguistics.spelling.core.container.HashTable;
	import com.adobe.linguistics.spelling.core.env.InternalConstants;
	import com.adobe.linguistics.spelling.core.error.*;
	import com.adobe.linguistics.spelling.core.utils.StringUtils;
	
	import flash.utils.Dictionary;
	
	
	public class SquigglyDictionary
	{
		private var _hashtbl:HashTable;
		private var _forbiddenword:int;
		private var _ignoredCharSet:String;
		private var _flag_mode:int;
		private var _languageCode:String;



		public function SquigglyDictionary(attrMgr:LinguisticRule)
		{
			_hashtbl = new HashTable( true ); // useWeakReferences:Boolean = true
			
			if ( !attrMgr) {
				_forbiddenword = InternalConstants.FORBIDDENWORD;
				_ignoredCharSet = null;
				_flag_mode = InternalConstants.FLAG_CHAR;
				_languageCode = null;
			}
		}
		
		private function set forbiddenword(value:int ) :void {
			this._forbiddenword = value;
		}
		
		public function get forbiddenword():int {
			return this._forbiddenword;
		}
		
		private function set ignoredCharSet(value:String):void {
			this._ignoredCharSet = value;
		}
		
		public function get ignoredCharSet():String {
			return this._ignoredCharSet;
		}
		
		private function set flag_mode(value:int):void {
			this._flag_mode = value;
		} 
		
		public function get flag_mode():int {
			return this._flag_mode;
		}
		
		private function set languageCode(value:String ) :void {
			this._languageCode = value;
		}
		
		public function get languageCode():String {
			return this._languageCode;
		}

		public function containsKey(key:String ):Boolean
		{
			return _hashtbl.containsKey(key );
		}
		
		public function getElement( key:String ):HashEntry {
			var res:* = _hashtbl.getElement(key );
			return (res is HashEntry) ? res:null;
//			return _hashtbl.getElement(key );
		}
		
		public function put(key:String, affixString:String=null, description:String = null):Boolean {
			return addWord( key, affixString, description );	
		}
		
		public function get dictionary():Dictionary {
			return this._hashtbl.hashMap;
		}
		
		public function filter( callback:Function, thisObject:* = null):Array {
			var res:Array = new Array();
			var index:int;
			var dict:Dictionary = this._hashtbl.hashMap;
			for ( var key:* in dict ) {
				if ( callback( key, index, res ) ) {
					res.push( key );
				}
			}
			
			return (res.length == 0) ? null: res;
		}
		
		
		public function addWord( word:String, affix:String = null, desc:String = null ) :Boolean {
			var res:Boolean = false;
			if ( word == null ) return false;
			var captype:int = StringUtils.getCapType(word);
			if ( addWordWithAffix(word,affix,desc,false ) )
				res = true;
			addHiddenCapitalizedWord(word,captype, affix,desc);
			return res;		
		}

		private function addHiddenCapitalizedWord( word:String, captype:int, affix:String=null, desc:String=null ) :Boolean {
			// add inner capitalized forms to handle the following allcap forms:
			// Mixed caps: OpenOffice.org -> OPENOFFICE.ORG
			// Allcaps with suffixes: CIA's -> CIA'S
			if (((captype == InternalConstants.HUHCAP) || (captype == InternalConstants.HUHINITCAP) ||((captype == InternalConstants.ALLCAP) && (affix != null))) &&
			!((affix != null) && HashEntry.TESTAFF(affix, _forbiddenword))) {
				affix += String.fromCharCode(InternalConstants.ONLYUPCASEFLAG);
				word = word.toLocaleLowerCase();
				word = word.charAt(0).toLocaleUpperCase() + word.substr(1);
				addWordWithAffix(word,affix,desc,true);
			}
			return true;
		}

		private function addWordWithAffix( word:String, affix:String, desc:String, onlyupcase:Boolean ):Boolean {
			var upcasehomonym:Boolean = false;
			if (_ignoredCharSet != null) {
				word = StringUtils.removeIgnoredChars(word, _ignoredCharSet);
			}
//ToDo: the following comment should be removed after we have complex-affix support.
//
//			if (complexprefixes) {
//				reverseword(word);
//			}
//        hp->var = H_OPT;
//        if (aliasm) {
//            hp->var += H_OPT_ALIASM;
//            store_pointer(hpw + wbl + 1, get_aliasm(atoi(desc)));
//        } else {
//            strcpy(hpw + wbl + 1, desc);
//            if (complexprefixes) {
//                if (utf8) reverseword_utf(HENTRY_DATA(hp));
//                else reverseword(HENTRY_DATA(hp));
//            }
//        }
//        if (strstr(HENTRY_DATA(hp), MORPH_PHON)) hp->var += H_OPT_PHON;
			
			if ( _hashtbl.containsKey(word) ) {

				var hentry:HashEntry = _hashtbl.getElement(word);
				while ( hentry.next != null ) {
					// remove hidden onlyupcase homonym
					if ( !onlyupcase ) {
						if ( (hentry.affixFlagVector != null) && hentry.testAffix(InternalConstants.ONLYUPCASEFLAG) ) {
							hentry.affixFlagVector = affix;
							hentry.variableFields = desc; /* need a better implementation,refer the beginning of this function */
							return true;
						}
					}else {
						upcasehomonym = true;
					}
					hentry = hentry.next;
				}
				// remove hidden onlyupcase homonym
				if ( !onlyupcase ) {
					if ( (hentry.affixFlagVector != null) && hentry.testAffix(InternalConstants.ONLYUPCASEFLAG) ) {
						hentry.affixFlagVector = affix;
						hentry.variableFields = desc; /* need a better implementation,refer the beginning of this function */
						return true;
					}
				}else {
					upcasehomonym = true;
				}

				if ( !upcasehomonym ) {
					hentry.addEntry(affix,desc);
					return true;
				}else
					return false;
			}else {
				_hashtbl.put(word, new HashEntry(affix,desc) );
				return true;
			}
		}		


	}
}
