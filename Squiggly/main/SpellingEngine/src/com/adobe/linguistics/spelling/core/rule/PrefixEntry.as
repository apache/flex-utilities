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
	public class PrefixEntry extends AffixEntry
	{
		private var _flagNext:PrefixEntry;
		private var _keyNext:PrefixEntry;
		public function PrefixEntry(affixFlag:int, stripString:String, affixValue:String, conditionString:String, morph:String = "", permission:Boolean = false,contclass:String=null)
		{
			super(affixFlag,stripString,affixValue,conditionString,morph, permission, 0,contclass);
			this.nextElementWithFlag = null;
			this.nextElementWithKey = null;
		}
		
		public function add(root:String):String {
			if ( this.conditionPattern.test(root) )
				return this.affixKey + root.substring(this.stripValue.length );
			return null; 
		}
		
		public function get nextElementWithKey():PrefixEntry {
			return this._keyNext;
		}
		
		public function set nextElementWithKey(pfxEntry:PrefixEntry):void {
			this._keyNext = pfxEntry;
		}
		
		public function get nextElementWithFlag():PrefixEntry {
			return this._flagNext;
		}
		
		public function set nextElementWithFlag(pfxEntry:PrefixEntry):void {
			this._flagNext = pfxEntry;
		}
		
		// check if this prefix entry matches
		public function checkWord( word:String, inCompound:int, needFlag:int):HashEntry {
			var disLen:int = word.length - this.affixKey.length;
			var he:HashEntry = null;
			var i:int;
			// on entry prefix is 0 length or already matches the beginning of the word.
			// So if the remaining root word has positive length
			// and if there are enough chars in root word and added back strip chars
			// to meet the number of characters conditions, then test it
			if ( disLen > 0 || (disLen == 0 && this.attributeManager.fullStrip) ) {
				// generate new root word by removing prefix and adding
				// back any characters that would have been stripped
				word = this.stripValue + word.substr(this.affixKey.length);
				// now make sure all of the conditions on characters
				// are met.  Please see the appendix at the end of
				// this file for more info on exactly what is being
				// tested
				// if all conditions are met then check if resulting
				// root word in the dictionary
				if ( this.conditionPattern.test( word ) ) {
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
					//if ((opts & aeXPRODUCT) && in_compound)
					if ( this.permissionToCombine ) {
						he = this.attributeManager.suffixCheck2(word, InternalConstants.aeXPRODUCT,this, needFlag, inCompound);
						if (he) return he; 
					}
				} 
				
			}
			return he;
		}



	}
}