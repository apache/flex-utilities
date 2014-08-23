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
	import com.adobe.linguistics.spelling.core.LinguisticRule;
	
	public class AffixEntry
	{
		private var _flag:int;
		private var _stripValue:String; /*stripping characters from beginning (at prefix rules) or end (at suffix rules) of the word  */
		private var _affixValue:String; /* affix (optionally with flags of continuation classes, separated by a slash)  */
		private var _conditionString:String; /*Zero stripping or affix are indicated by zero. 
		Zero condition is indicated by dot. Condition is a simplified, regular expression-like pattern, 
		which must be met before the affix can be applied. (Dot signs an arbitrary character. Characters 
		in braces sign an arbitrary character from the character subset. Dash hasn’t got special meaning, 
		but circumflex (^) next the first brace sets the complementer character set.)  */
		private var _conditionPattern:RegExp;
		private var _permissionToCombine:Boolean; /* Cross product (permission to combine prefixes and suffixes). Possible values: Y (yes) or N (no) */
		private var _type:int; // 0 means prefix, 1 means suffix...
		private var _morphologicalFields:String; //Optional morphological fields separated by spaces or tabulators. 
		private var _contclass:String; //Added for Double affix support
		
		private var _attrMgr:LinguisticRule;		

		
		public function AffixEntry(affixFlag:int, stripString:String, affixValue:String, conditionStr:String, morph:String = "", permission:Boolean = false, affixType:int = 0, contclass:String=null)
		{
			this.flag = affixFlag;
			this.conditionString = conditionStr;
			this.stripValue = stripString;
			this.affixKey = affixValue;
			this.permissionToCombine = permission;
			this.type = affixType;
			this.morphologicalFields = morph;
			this.attributeManager = null;
			this.contclass=contclass;//can be null too
			this._conditionPattern = (affixType == 0) ? new RegExp("^"+conditionStr+".*"+"$"): new RegExp("^"+".*"+conditionStr+"$");
		}
		
		public function set attributeManager( attrMgr:LinguisticRule):void {
			this._attrMgr = attrMgr;
		}
		
		public function get attributeManager( ):LinguisticRule {
			return this._attrMgr;
		}
		
		public function set morphologicalFields(value:String):void {
			this._morphologicalFields = value;
		}
		
		public function get morphologicalFields():String {
			return this._morphologicalFields;
		}
		
		public function set permissionToCombine(value:Boolean) : void {
			this._permissionToCombine = value;
		}
		
		public function get permissionToCombine():Boolean {
			return this._permissionToCombine;
		}
		
		public function get flag():int {
			return this._flag;
		}
		public function set flag(affixFlag:int):void {
			this._flag = affixFlag;
		}
		
		public function get type():int {
			return this._type;
		}
		
		public function set type(affixType:int):void {
			this._type = affixType;
		}
		
		public function set stripValue(value:String):void {
			this._stripValue = value;
		} 
		
		public function get stripValue():String {
			return this._stripValue;
		}
		
		public function set affixKey(value:String):void {
			this._affixValue = value;
		}
		
		public function get affixKey():String {
			return this._affixValue;
		}
		
		public function set contclass(value:String):void {
			this._contclass = value;
		}
		
		public function get contclass():String {
			return this._contclass;
		}
		
		public function get conditionString():String {
			return this._conditionString;
		}
		
		public function set conditionString(value:String):void {
			this._conditionString  = value;
		}
		
		public function get conditionPattern():RegExp {
			return this._conditionPattern;
		}
		public function set conditionPattern(value:RegExp):void {
			this._conditionPattern = value;
		}

	}
}