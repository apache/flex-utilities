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
package org.granite.util 
{	
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.utils.getQualifiedClassName;
	
	public class Enum implements IExternalizable
	{
		private var _name:String;
		
		public function Enum(name:String, restrictor:Restrictor) {
			_name = (restrictor is Restrictor ? name : constantOf(name).name);
		}
		
		public function get name():String {
			return _name;
		}
		
		protected function getConstants():Array {
			throw new Error("Should be overriden");
		}
		
		protected function constantOf(name:String):Enum {
			for each (var o:* in getConstants()) {
				var enum:Enum = Enum(o);
				if (enum.name == name)
					return enum;
			}
			throw new ArgumentError("Invalid " + getQualifiedClassName(this) + " value: " + name);
		}
		
		public function readExternal(input:IDataInput):void {
			_name = constantOf(input.readObject() as String).name;
		}
		
		public function writeExternal(output:IDataOutput):void {
			output.writeObject(_name);
		}
		
		public static function normalize(enum:Enum):Enum {
			return (enum == null ? null : enum.constantOf(enum.name));
		}
		
		public static function readEnum(input:IDataInput):Enum {
			return normalize(input.readObject() as Enum);
		}
		
		public function toString():String {
			return name;
		}
		
		public function equals(other:Enum):Boolean {
			return other === this || (
				other != null &&
				getQualifiedClassName(this) == getQualifiedClassName(other) &&
				other.name == this.name
			);
		}
		
		protected static function get _():Restrictor { // NO PMD ProtectedStaticMethod
			return new Restrictor();
		}
	}
}
class Restrictor {}
