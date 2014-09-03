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
	import com.adobe.linguistics.spelling.core.utils.StringUtils;
	
	public class OptimizedSuffixEntry  extends AffixEntry
	{
		private var _flagNext:OptimizedSuffixEntry;
		private var _keyNext:OptimizedSuffixEntry;
		private var _flags:Array;
		private var _sfxTable:Array;
		private var _reverseAffixKey:String;
		public function OptimizedSuffixEntry(sfxEntry:SuffixEntry)
		{
			super(sfxEntry.flag,sfxEntry.stripValue,sfxEntry.affixKey,sfxEntry.conditionString,sfxEntry.morphologicalFields, sfxEntry.permissionToCombine, sfxEntry.type,sfxEntry.contclass);
			_flags = new Array();
			_sfxTable = new Array();
			this.nextElementWithFlag = null;
			this.nextElementWithKey = null;
			_flags.push(this.flag);
			_sfxTable.push(sfxEntry);
			this.reverseAffixKey = StringUtils.reverseString(this.affixKey);
			this.flag = -1;
			this.conditionString = "";
		}
		
		public function isSimilarObject(sfxEntry:SuffixEntry):Boolean {
			var chkString:String=this.contclass+sfxEntry.contclass;
			if(chkString)chkString=chkString.split('').sort().join('').replace(/(.)\1+/gi,'$1');//this pattern removes any repetition from strings. this will work only because we are converting n' or q' to Long numbers in decode flags
			if ( (this.stripValue == sfxEntry.stripValue) && (this.affixKey == sfxEntry.affixKey) && (this.permissionToCombine == sfxEntry.permissionToCombine) && (this.morphologicalFields == sfxEntry.morphologicalFields) &&(this.contclass==chkString) )	return true;
			return false;
		} 
		
		public function extendObject( sfxEntry:SuffixEntry ):Boolean {
			
			 if ( !isSimilarObject(sfxEntry) ) return false;
			_flags.push(sfxEntry.flag);
			_sfxTable.push(sfxEntry);
			var newConditionString:String;
			newConditionString = this.conditionPattern.source + "|" + "^"+".*"+sfxEntry.conditionString+"$";
			this.conditionPattern  = new RegExp ( newConditionString);
			//now add in contclass
			this.contclass=sfxEntry.contclass;
			return true;
		}
		
		public function set reverseAffixKey(value:String):void {
			this._reverseAffixKey = value;
		}
		
		public function get reverseAffixKey():String {
			return this._reverseAffixKey;
		}
		
		public function get nextElementWithKey():OptimizedSuffixEntry {
			return this._keyNext;
		}
		
		public function set nextElementWithKey(pfxEntry:OptimizedSuffixEntry):void {
			this._keyNext = pfxEntry;
		}
		
		public function get nextElementWithFlag():OptimizedSuffixEntry {
			return this._flagNext;
		}
		
		public function set nextElementWithFlag(pfxEntry:OptimizedSuffixEntry):void {
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
		// see if this suffix is present in the word
		public function checkWord( word:String, needFlag:int, inCompound:int):HashEntry {
			var disLen:int = word.length - this.affixKey.length;
			var he:HashEntry = null;
			var i:int;

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
					//if ((opts & aeXPRODUCT) && in_compound)
					if ( this.permissionToCombine ) {
						he = this.attributeManager.optPrefixCheck(word, InternalConstants.aeXPRODUCT,this, needFlag, inCompound);
						if (he) return he; 
					}
				} 
				
			}
			return he;
		}
		
		//for develepors only, function used for printing flags when flag_mode=FLAG.LONG presently not being called anywhere
		public function printFlag(flag:Number):void{
			var result:String =  String.fromCharCode(flag>>8) + String.fromCharCode(flag-((flag>>8)<<8));
			var x:String= this.affixKey;
		}
		// see if this suffix is present in the word
		public function checkWord2( word:String, sfxopts:int, ppfx:AffixEntry, needFlag:int, inCompound:int, cclass:int, pfxcclass:int=0):HashEntry {
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
				if ( this.conditionPattern.test( word ) ) {
					// look word in hash table
					for ( i=0; i < this.attributeManager.dictionaryManager.dictonaryList.length && !he; ++i ) {
						he = this.attributeManager.dictionaryManager.dictonaryList[i].getElement(word);
						while( he ) {
							if (  (( he.testAffixs(this._flags) ) && ( (!needFlag) || he.testAffix(needFlag) ))||(ppfx && ppfx.contclass) ) {
								for ( var j:int=0;j<this._sfxTable.length;++j) {
									if ( (this._sfxTable[j] ).conditionPattern.test(word) ) {
										if(!ppfx)
										{
											if(cclass)
											{
												if (he.testAffix(this._flags[j]) && HashEntry.TESTAFF(this.contclass,cclass) )//should handle cases like drink->able->s also in un-run-able-s if run-->able and able-->s and s-->un this should suffice
													return he;
											}
											else											
											{	if(he.testAffix(this._flags[j]))//should handle all normal cases like drink->able or drink->s
												return he;
											}
											
																						
										}
										else
										{
											if(this.contclass && he.testAffix(this._flags[j]) && HashEntry.TESTAFF(this.contclass,cclass) && !pfxcclass) // handle when suffix has contclass like l'->autre->s
											{
											return he;
											}
											if(ppfx.contclass && HashEntry.TESTAFF(ppfx.contclass,this._flags[j]) && he.testAffix(cclass) && !pfxcclass) //handle when prefix has contclass like milli->litre->s
											{
												return he;	
											}
											if(he.testAffix(this._flags[j]) && he.testAffix(cclass))//handle normal cases when both pfx and sfx exist in hash affix string
											{
											return he;
											}
											
											//special case of un-drink-able-s
											if(    (he.testAffix(pfxcclass) && ppfx.contclass && HashEntry.TESTAFF(ppfx.contclass,this._flags[j]) && this.contclass && HashEntry.TESTAFF(this.contclass,cclass)) 
											   ||  (he.testAffix(this._flags[j]) && this.contclass && HashEntry.TESTAFF(this.contclass,cclass) && HashEntry.TESTAFF(this.contclass,pfxcclass))
											   )
											{
												return he;
											}
											
																						
										}
											
										}
								}
							}
							he = he.next;
						}
					}

				} 
				
			}
			return he;
		}
		
		// Function for two level suffix checkword
		// see if this suffix is present in the word
		public function checkTwoWord( word:String, sfxopts:int, ppfx:AffixEntry, needFlag:int, cclass:int, pfxcclass:int=0):HashEntry {
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
				// if all conditions are met then see if for conditional suffix and if this has been stripped by a possible
				// contclass check the remaining word 
				// eg: if drinkables was original word and after possible stripping of s we have drinkable very if 
				// now check drinkable, able will be stripped and drink will be found that hash entry will then be returned
				if ( this.conditionPattern.test( word ) ) {//checks a whole group of 
					
					if(ppfx)
					{ //check for conditional suffix
						if( contclass!=null && HashEntry.TESTAFF(contclass, pfxcclass))
						{
							he = this.attributeManager.optSuffixCheck2(word, 0, null,needFlag,0,cclass,pfxcclass);//we are not sending ppfx here as it will not be needed.
						}
						else
						{
							he = this.attributeManager.optSuffixCheck2(word, sfxopts, ppfx,needFlag,0,cclass,pfxcclass);
						}
					}
					else
					{
						he = this.attributeManager.optSuffixCheck2(word, 0, null,needFlag,0,cclass,0);
					}
					if (he) {
						for ( var j:int=0;j<this._sfxTable.length;++j) { //Squiggly will handle drink->able->s from here
							if ( (this._sfxTable[j]).conditionPattern.test(word) && cclass==(this._sfxTable[j]).flag) {//only permit words which end with s in drinkables
								
									return he;
							
							}
						}
						he = null;
					}
					
				} 
				
			}
			
			return he;
		}
		//--
	}
}