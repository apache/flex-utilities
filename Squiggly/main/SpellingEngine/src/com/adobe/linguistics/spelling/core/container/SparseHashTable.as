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
	import com.adobe.linguistics.spelling.core.utils.*;
	public final class SparseHashTable implements Collection
	{
		
		private var _keyTable:Array;
		private var _elementTable:Array;
		private var _hashSize:int;
		private var _tableCapacity:int;
		private var _loadFactor:Number;
		private var _elementNum:int;
		private var _deletedObject:Object = new Object();
		
		/**
		 * A simple function for hashing strings.
		 */
		private function hashString(s:String):int
		{
			var hash:int = 0, i:int, k:int = s.length, ROTATE_LEN:int = 5;
			for ( i =0; i < 4 && !isNaN(s.charCodeAt(i)); ++i ) {
				hash = ( hash << 8 ) | ( s.charCodeAt(i) )
			}
			while ( !isNaN(s.charCodeAt(i)) ) {
				(hash) = ((hash) << (ROTATE_LEN)) | (((hash) >> (32 - ROTATE_LEN)) & ((1 << (ROTATE_LEN))-1));
				hash ^= ( s.charCodeAt(i) );
				++i; 
			}
			return (hash > 0) ? hash : -hash; // or use uint conversion to convert minus number to plus number.... still debate//
		}
//		private function hashString(s:String):int
//		{
//			var hash:int = 0, i:int, k:int = s.length;
//			for (i = 0; i < k; i++) hash += (i + 1) * s.charCodeAt(i);
//			return hash;
//		}
		
		/**
		 * A simple function for hashing integers.
		 */
		private function hashNumber(n:Number):int
		{
			var i:int = int(n);
			return int(i>0? i:-i);
		}
		
		private function hash(key:*):int {
			if (key is Number ) {
				return hashNumber(key);
			}else if (key is String ) {
				return hashString(key);
			}
			
			if (key.hasOwnProperty("hashCode"))
            	return key.hashCode()>0 ? key.hashCode() : -key.hashCode();
        	else
            	return int(key)>0 ? int(key) : -int(key);
		}

		public function SparseHashTable(initialCapacity:int = 128, loadFactor:Number = 0.75)
		{
			initHash(initialCapacity, loadFactor);
		}
		
		private function initHash(initialCapacity:int = 128, loadFactor:Number = 0.75):void {
			if ( !(initialCapacity > 0) ||  !( loadFactor > 0 && loadFactor < 1) )
				return; //input is invalid, should through exception or ...
			_loadFactor = loadFactor;
			_hashSize = initialCapacity;
			_tableCapacity = MathUtils.nextPrime( int(_hashSize/loadFactor) );
			_keyTable = new Array(_tableCapacity);
			_elementTable = new Array(_tableCapacity);
			_elementNum = 0;
			clear();
		}
		
		private function getKeyPosition(key:*):int {
			var hashValue:int = hash(key);
			var pos:int;
			if ( hashValue < 0 ) {
				trace ( "hashValue shouldn't be negative integer" );
				return -1;
			}
			//Quadratic Probing
			for ( var i:int =0; i < _tableCapacity; ++i ) {
				pos = (hashValue+i*i)%_tableCapacity ; //hi=(h(key)+i*i)%m 0≤i≤m-1 
				if ( _keyTable[pos] == null ) 
					break;
				if ( _keyTable[pos] == key ) {
					return pos;
				}
			}
			return -1;						
		}

		private function calculateKeyPostion(key:*):int {
			var hashValue:int = hash(key);
			var pos:int;
			if ( hashValue < 0 ) {
				trace ( "Position shouldn't be negative" );
				return -1;
			}
			//Quadratic Probing
			for ( var i:int =0; i < _tableCapacity; ++i ) {
				pos = (hashValue+i*i)%_tableCapacity ; //hi=(h(key)+i*i)%m 0≤i≤m-1 
				if ( (_keyTable[pos] == null ) || 
				( _keyTable[pos] == _deletedObject ) ) {
					// insert successfully
					return pos;
				}
			}
			return -1; // hash table is full now. it should never happen.
			
		}		
		

		protected function rehash():void {
			if ( _hashSize == _elementNum ) {
				var oldKeyTable:Array = _keyTable;
				var oldElementTable:Array = _elementTable;
				initHash(_hashSize*2, _loadFactor);
				for ( var i:int =0 ; i < oldKeyTable.length; ++i ) {
					if (oldKeyTable[i]==null 
					|| oldKeyTable[i] == _deletedObject) {
						continue;
					}
					put(oldKeyTable[i],oldElementTable[i] );
				}
				oldKeyTable=null;
				oldElementTable=null;
			}
		}
		
		public function put( key:*, value:* ) :Boolean {
			if ( _hashSize == _elementNum ) {
				rehash();
			}

			if ( containsKey(key)  ) {
				trace ( "Contains the same Key in the table" );
				return false;
			}
			
			var pos:int = calculateKeyPostion(key);
			if ( pos < 0 ) {
				trace ( "SparseHash internal error." );
				return false;
			}

			++_elementNum;
			_keyTable[pos] = key;
			_elementTable[pos] = value;
			return true;
		}

		public function remove(key:*):* {
			var pos:int = getKeyPosition(key);
			var res:* = (pos < 0) ? null:_elementTable[pos];
			if ( pos >= 0 ) {
				--_elementNum;
				_keyTable[pos] =_deletedObject;
				_elementTable[pos] = _deletedObject;
			}
			return res;
		}
		
		public function contains(value:*):Boolean {
			return containsValue(value);
		}
		
		/**
		 * Determines if the collection contains the specified element.
		 * 
		 * @ obj: element whose presence in this collection is to be tested.
		 * 
		 * @ Returns true if this collection contains the specified element.
		 */
		public function containsKey(key:*):Boolean {
			var pos:int = getKeyPosition(key);
			return (pos >= 0);	
		}
		
		public function containsValue(value:*):Boolean {
			for ( var i:int =0; i < _tableCapacity; ++i ) {
				if ( (_keyTable[i] == null ) || 
				( _keyTable[i] == _deletedObject ) ) {
					continue;
				}
				if ( _elementTable[i].value == value ) 
					return true;
			}
			return false;
		}
		
		public function getElement(key:* ):* {
			var pos:int = getKeyPosition(key);
			return (pos < 0) ? null:_elementTable[pos];
			
		}

		/**
		 * The number of elements in this collection.
		 * @Returns the number of elements in this collection.
		 */
		public function get size():int {
			return _elementNum;
		}
		
		public function get elements():Enumeration {
			return null;
		}
		
		public function get keys():Enumeration {
			return null;
		}
		
		/**
		 * Tests if the collection is empty.
		 * 
		 * @ Returns true if this collection contains no elements.
		 */
		public function isEmpty():Boolean {
			return (_elementNum==0);
		}
		
		
		/**
		 * Removes all of the elements from this collection (optional operation).
		 */
		public function clear():void {
			var i:int;
			for( i=0;i< _tableCapacity;++i) {
				_keyTable[i] = null;
				_elementTable[i] = null;
			}
		}
		
		/**
		 * Returns an iterator over the elements in this collection. There are 
		 * no guarantees concerning the order in which the elements are returned 
		 * (unless this collection is an instance of some class that provides a guarantee). 
		 *
		 * @an Iterator over the elements in this collection
		 */
		public function getIterator():Iterator {
			return null;
		}
		
		/**
		 * Returns an array containing all of the elements in this collection. 
		 * If the collection makes any guarantees as to what order its elements 
		 * are returned by its iterator, this method must return the elements 
		 * in the same order.
		 * 
		 * @return An array.
		 */
		public function toArray():Array {
			return _keyTable;
		}		
		
	}
}

