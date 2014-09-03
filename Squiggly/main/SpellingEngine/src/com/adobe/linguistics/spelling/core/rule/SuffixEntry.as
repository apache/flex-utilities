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


package com.adobe.linguistics.spelling.core.rule
{
	import com.adobe.linguistics.spelling.core.HashEntry;
	import com.adobe.linguistics.spelling.core.env.InternalConstants;

	public class SuffixEntry extends AffixEntry
	{
		private var _flagNext:SuffixEntry;
		private var _keyNext:SuffixEntry;
		private var _conditionPattern2:RegExp = null;;
		private var _noTestFlag:Boolean = false;
		public function SuffixEntry(affixFlag:int, stripString:String, affixValue:String, conditionString:String, morph:String = "", permission:Boolean = false, contclass:String=null)
		{
			super(affixFlag,stripString,affixValue,conditionString,morph, permission, 1,contclass);
			this.nextElementWithFlag = null;
			this.nextElementWithKey = null;
			if ( this.stripValue != "" ) {
				if ( this.conditionString == "." ) {
						this._conditionPattern2 = null;
						this._noTestFlag = true;
					
				}else {
					var stripPattern:RegExp = new RegExp ( "^(.*)"+this.stripValue+"$" );
					var strArr:Array;
					if ( (strArr = this.conditionString.match(stripPattern) ) != null ) {
						if ( strArr[1] != "" ) {
							this._conditionPattern2 = new RegExp( "^.*" + strArr[1] + "$" );
						}else {
							this._conditionPattern2 = null;
							this._noTestFlag = true;
						}
					}else {
						this._conditionPattern2 = this.conditionPattern;
					}
				}
			}
			
		}
		
		public function add(root:String):String {
			if ( this.conditionPattern.test(root) )
				return root.substring(0, (root.length-this.stripValue.length) ) + this.affixKey;
			return null; 
		}
		
		public function get nextElementWithKey():SuffixEntry {
			return this._keyNext;
		}
		
		public function set nextElementWithKey(pfxEntry:SuffixEntry):void {
			this._keyNext = pfxEntry;
		}
		
		public function get nextElementWithFlag():SuffixEntry {
			return this._flagNext;
		}
		
		public function set nextElementWithFlag(pfxEntry:SuffixEntry):void {
			this._flagNext = pfxEntry;
		}

		// see if this suffix is present in the word
		public function checkWord( word:String, sfxopts:int, ppfx:AffixEntry, needFlag:int, inCompound:int):HashEntry {
			var disLen:int = word.length - this.affixKey.length;
			var he:HashEntry = null;
			var i:int;

			// if this suffix is being cross checked with a prefix
			// but it does not support cross products skip it
			if ( (sfxopts& InternalConstants.aeXPRODUCT) != 0 && this.permissionToCombine != true ) return null;

			// upon entry suffix is 0 length or already matches the end of the word.
			// So if the remaining root word has positive length
			// and if there are enough chars in root word and added back strip chars
			// to meet the number of characters conditions, then test it
			if ( (disLen > 0 || (disLen == 0 && this.attributeManager.fullStrip)) ) {
				// generate new root word by removing suffix and adding
				// back any characters that would have been stripped or
				// or null terminating the shorter string
				word = word.substr(0, word.length - this.affixKey.length) + this.stripValue;
				// now make sure all of the conditions on characters
				// are met.  Please see the appendix at the end of
				// this file for more info on exactly what is being
				// tested
				// if all conditions are met then check if resulting
				// root word in the dictionary
				if ( this._noTestFlag || this.conditionPattern.test( word ) ) {
					// look word in hash table
					for ( i=0; i < this.attributeManager.dictionaryManager.dictonaryList.length && !he; ++i ) {
						he = this.attributeManager.dictionaryManager.dictonaryList[i].getElement(word);
						while( he ) {
							if ( he.testAffix(this.flag) && ( (!needFlag) || he.testAffix(needFlag) ) ) {
								return he;
							}
							he = he.next;
						}
					}

				} 
				
			}
			return he;
		}

	}
}