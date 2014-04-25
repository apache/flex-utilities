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
	public class OptimizedPrefixEntry extends AffixEntry
	{
		private var _flagNext:OptimizedPrefixEntry;
		private var _keyNext:OptimizedPrefixEntry;
		private var _flags:Array;
		private var _pfxTable:Array;
		public function OptimizedPrefixEntry(pfxEntry:PrefixEntry)
		{
			
			super(pfxEntry.flag,pfxEntry.stripValue,pfxEntry.affixKey,pfxEntry.conditionString,pfxEntry.morphologicalFields, pfxEntry.permissionToCombine, 0,pfxEntry.contclass);
			_flags = new Array();
			this._pfxTable = new Array();
			this.nextElementWithFlag = null;
			this.nextElementWithKey = null;
			_flags.push(this.flag);
			this._pfxTable.push(pfxEntry);
			this.flag = -1;
			this.conditionString = "";
		}

		public function isSimilarObject(pfxEntry:PrefixEntry):Boolean {
			var chkString:String=this.contclass+pfxEntry.contclass;
			if(chkString)chkString=chkString.split('').sort().join('').replace(/(.)\1+/gi,'$1');//this pattern removes any repetition from strings. this will work only because we are converting n' or q' to Long numbers in decode flags
			if ( (this.stripValue == pfxEntry.stripValue) && (this.affixKey == pfxEntry.affixKey) && (this.permissionToCombine == pfxEntry.permissionToCombine) && (this.morphologicalFields == pfxEntry.morphologicalFields)&&(this.contclass==chkString) )	return true;
			return false;
		} 
		
		public function extendObject( pfxEntry:PrefixEntry ):Boolean {
			if ( !isSimilarObject(pfxEntry) )	{
				return false;
			}
			_flags.push( pfxEntry.flag);
			this._pfxTable.push( pfxEntry );
		
			var newConditionString:String;
			newConditionString = this.conditionPattern.source + "|" + "^"+pfxEntry.conditionString+".*"+"$";
			this.conditionPattern  = new RegExp ( newConditionString);
			this.contclass=pfxEntry.contclass;
			return true;
		}

		public function get nextElementWithKey():OptimizedPrefixEntry {
			return this._keyNext;
		}
		
		public function set nextElementWithKey(pfxEntry:OptimizedPrefixEntry):void {
			this._keyNext = pfxEntry;
		}
		
		public function get nextElementWithFlag():OptimizedPrefixEntry {
			return this._flagNext;
		}
		
		public function set nextElementWithFlag(pfxEntry:OptimizedPrefixEntry):void {
			this._flagNext = pfxEntry;
		}
		
		public function get flags():Array {
			return this._flags;
		}

		/*
		 * Deprecated function for now...
		 * History: 
		 *          A pre-version of implementation for error detection. After I optimized the code for performance,
		 *          I drop this function by that time, but you know performance meassuring is a tricky problem... 
		 * ToDo: Need a revisit when we implementing complex-affix support and compound-word support.
		 */
		// check if this prefix entry matches
		public function checkWord( word:String, sfxopts:int, ppfx:AffixEntry, inCompound:int, needFlag:int):HashEntry {
			var disLen:int = word.length - this.affixKey.length;
			var he:HashEntry = null;
			var i:int;
			// if this suffix is being cross checked with a prefix
			// but it does not support cross products skip it
			if ( (sfxopts& InternalConstants.aeXPRODUCT) != 0 && this.permissionToCombine != true ) return null;
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
							if ( he.testAffixs(this._flags) && ( (!needFlag) || he.testAffix(needFlag) ) ) {
								return he;
							}
							he = he.next;
						}
					}
				} 
				
			}
			return he;
		}

		// check if this prefix entry matches
		public function checkWord2( word:String, inCompound:int, needFlag:int):HashEntry {
			var disLen:int = word.length - this.affixKey.length;
			var he:HashEntry = null;
			var i:int,j:int;
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
							if ( he.testAffixs(this._flags) && ( (!needFlag) || he.testAffix(needFlag) ) ) {
								for ( j=0;j<this._pfxTable.length;++j) {
									if ( (this._pfxTable[j] ).conditionPattern.test(word) ) {
										if ( he.testAffix(this._flags[j]) ){
											return he;
										}
									}
								}
							}
							he = he.next;
						}
					}
					//if ((opts & aeXPRODUCT) && in_compound)
					if ( this.permissionToCombine ) {
						for(i=0; j<this.flags[i];i++)
						{
							he = this.attributeManager.optSuffixCheck2(word, InternalConstants.aeXPRODUCT,this, needFlag, inCompound,this.flags[i]);
							
							if (he) 
							{
							
								for ( j=0;j<this._pfxTable.length;++j) 
								{
									if ( (this._pfxTable[j] ).conditionPattern.test(word) && (this._pfxTable[j].flag ==this.flags[i]) )
									{
										
											return he;
										
									}
								}
							he = null;	
							} 
						}
					}
				} 
				
			}
			return he;
		}
		 
		//checkTwoWord
		public function checkTwoWord( word:String, inCompound:int, needFlag:int):HashEntry {
			var disLen:int = word.length - this.affixKey.length;
			var he:HashEntry = null;
			var i:int,j:int;
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
					// do not look word in hash table
					
					//if ((opts & aeXPRODUCT) && in_compound)
					if ( this.permissionToCombine && inCompound!=1/*IN_CPD_BEGIN*/) {//TODO: figure this constant
						for(i=0; j<this.flags[i];i++)
						{
						
							he = this.attributeManager.optTwoSuffixCheck(word, InternalConstants.aeXPRODUCT,this,needFlag,this.flags[i]);//this is the c2
							if (he) {
								for ( j=0;j<this._pfxTable.length;++j) { //Squiggly will handle undrinkables from here
									if ( (this._pfxTable[j] ).conditionPattern.test(word)&& (this._pfxTable[j].flag ==this.flags[i]) ) 
									{
									
											return he;
										
									}
								}
								he = null;
							}
						}
					}
				} 
				
			}
			return he;
		}
		//--

	}
}