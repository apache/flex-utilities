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
	import com.adobe.linguistics.spelling.core.container.HashTable;
	public class DictionaryManager
	{
		private var _table:Array;
		public function DictionaryManager()
		{
			_table = new Array();
		}
		
		public function addDictionary(dict:SquigglyDictionary):Boolean {
			if ( dict == null ) return false;
			for ( var i:int = 0; i< _table.length; ++i ) {
				if ( dict == _table[i] )
					return false;
			}
			_table.push(dict);
			return true;
		}
		
		public function removeDictionary(dict:SquigglyDictionary):Boolean {
			if ( dict == null) return false;
			for ( var i:int = 0; i< _table.length; ++i ) {
				if ( dict == _table[i] ) {
					_table = _table.slice(i,1); // remove dictionary from the table.
				}
			}
			return true;
			
		}
		
		public function get dictonaryList():Array {
			return this._table;
		}
		
		public function isEmpty():Boolean {
			return (this._table == null ) ? true : false;
		}
		
		public function get size():int {
			return this._table.length;
		}
		
		public function lookup( word:String ) :HashEntry {
			for ( var i:int = 0; i < _table.length; ++i ) {
				if ( _table[i].containsKey(word) )
					return _table[i].getElement(word);
			}
			return null;
		}
	}
}