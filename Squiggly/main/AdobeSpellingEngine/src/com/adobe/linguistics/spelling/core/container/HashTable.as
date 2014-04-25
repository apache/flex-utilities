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


package com.adobe.linguistics.spelling.core.container
{
	import flash.utils.Dictionary;
	
	/**
	 * A hash table
	 */
	public class HashTable implements Collection
	{
		protected var _map:Dictionary;
		protected var _elementNum:int;
		
		/**
		 * Initializes a new hash table.
		 * 
		 * @param size The size of the hash table.
		 * @param hash A hashing function.
		 */
		public function HashTable(useWeakReferences:Boolean = true)
		{
			_map = new Dictionary( useWeakReferences );
			_elementNum = 0;
		}

		public function put(key:*, value:*) : void
		{
			_map[key] = value;
			++_elementNum;
		}

		public function remove(key:*) : void
		{
			delete _map[key];
			--_elementNum;
		}

		public function containsKey(key:*) : Boolean
		{
			return _map.hasOwnProperty( key );
		}
		
		public function containsValue(value:*) : Boolean
		{
			for ( var key:* in _map )
			{
				if ( _map[key] == value )
				{
					return true;
				}
			}
			return false;
		}

		public function contains(value:*):Boolean {
			return containsValue(value);
		}

		public function getElement(key:* ):* {
			return _map[key];
		}
				
		/**
		 * @inheritDoc
		 */
		public function clear() : void
		{
			for ( var key:* in _map )
			{
				remove( key );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getIterator():Iterator
		{
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get size():int
		{
			return _elementNum;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isEmpty():Boolean
		{
			return _elementNum == 0;
		}

		public function get keys() : Array
		{
			var _keys:Array = [];

			for (var key:* in _map)
			{
				_keys.push( key );
			}
			return _keys;
		}
		
		public function get elements() : Array
		{
			var _values:Array = [];

 			for each ( var value:* in _map ) {
				_values.push( value );
			}
			return _values;
		}

		/**
		 * @inheritDoc
		 */
		public function toArray():Array
		{
			return keys;
		}
		
		/**
		 * Prints out a string representing the current object.
		 * 
		 * @return A string representing the current object.
		 */
		public function toString():String
		{
			return "[HashTable, size=" + size + "]";
		}
		
		public function get hashMap():Dictionary {
			return this._map;
		}
		
		/**
		 * Need refine... Possible solution is that we can use two function paramter to control the input and output. 
		 * 
		 *
		 */
		public function watchEntries(func:Function=null):Array {
			if ( func == null )
				return null;
			var res:Array = new Array();
			for (var curKey:* in _map)
			{
				if ( func( curKey, _map[curKey] ) ) {
					res.push( curKey );
				}
			}
			return (res.length == 0)? null: res;
		}
		
	}
}
