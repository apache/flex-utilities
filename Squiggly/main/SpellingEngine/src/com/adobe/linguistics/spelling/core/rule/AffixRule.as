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


package  com.adobe.linguistics.spelling.core.rule
{
	
	public class AffixRule
	{
		private var _name:String;
		private var _type:uint;
		private var _stripValue:String;
		private var _affixValue:String;
		private var _conditionPattern:String;
		private var _permissionToCombine:Boolean;
		
		public function AffixRule(affixName:String, affixType:uint, stripString:String, affixString:String, conditionString:String, permission:Boolean = true)
		{
			this.name = affixName;
			this._conditionPattern = conditionString;
			this.type = affixType;
			this.stripValue = stripString;
			this.affixValue = affixString;
			this.permissionToCombine = permission;
			
		}
		
		public function set permissionToCombine(value:Boolean) : void {
			this._permissionToCombine = value;
		}
		
		public function get permissionToCombine():Boolean {
			return this._permissionToCombine;
		}
		
		public function get name():String {
			return this._name;
		}
		public function set name(affixName:String):void {
			this._name = affixName;
		}
		
		public function get type():uint {
			return this._type;
		}
		
		public function set type(affixType:uint):void {
			this._type = affixType;
		}
		
		public function set stripValue(value:String):void {
			this._stripValue = value;
		} 
		
		public function get stripValue():String {
			return this._stripValue;
		}
		
		public function set affixValue(value:String):void {
			this._affixValue = value;
		}
		
		public function get affixValue():String {
			return this._affixValue;
		}
		
		public function get conditionPattern():String {
			return this._conditionPattern;
		}
		
		public function set conditionPattern(value:String):void {
			this._conditionPattern  = value;
		}

	}
}