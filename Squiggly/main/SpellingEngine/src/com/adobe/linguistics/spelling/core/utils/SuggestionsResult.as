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



package com.adobe.linguistics.spelling.core.utils
{
	public class SuggestionsResult
	{
		private var _myHeap:Array;
		private var _count:uint=0;
		private var _size:uint=1;
		private var __compare:Function;
		public function SuggestionsResult(buffersize:uint=100, compare:Function = null)
		{
			_size=buffersize;
			_myHeap= new Array(_size+1);
			_count=0;
			if (compare == null)
				__compare = function(a:int, b:int):int { return a - b; };
			else
				__compare = compare;
		}
		public function insert(obj:*):Boolean {
			_myHeap[++_count]=obj;
			return true;
		}
		public function find(obj:*):Boolean {
			for (var i:int = 1; i <= _count; i++)
			{
				if (_myHeap[i] === obj)
					return true;
			}
			return false;
		}

		public function get front():*
		{
			return this._myHeap[1];
		}

		public function get maxSize():int
		{
			return this._size;
		}

		public function isEmpty():Boolean
		{
			if (_count==0) {
				return true;
			}else {
				return false;
			}
			
		}
		
		public function clear():void
		{
			_myHeap = new Array(_size);
			_count = 0;
		}
		
		public function get size():uint {
			return this._count;
		}
		
		public function dump():String {
			var s:String = "Suggestions Result\n{\n";
			var k:int = _count + 1;
			for (var i:int = 1; i < k; i++)
				s += "\t" + _myHeap[i] + "\n";
			s += "\n}";
			return s;
		}
		
		public function toArray():Array {
			return _myHeap.slice(1,_count+1);
		}
		
		
		public function get data():Array {
			return this._myHeap;
		}
		
		public function buildheap():void {
			if(this.size<2) {
				return;
			}
			for ( var i:int=this.size/2;i>0;i--) {
				minheapify(i);
			}
		}
		
		public function updateFront():void {
			minheapify(1);
		}
		
		private function minheapify(index:uint):void {
			var i:int = index;
			var child:int = i << 1;
			var tmp:* = _myHeap[i];
			var v:*;
			
			while (child <= _count)
			{
				if (child < _count - 1)
				{
					if (__compare(_myHeap[child], _myHeap[int(child + 1)]) > 0)
						child++;
				}
				v = _myHeap[child];
				if (__compare(tmp, v) > 0)
				{
					_myHeap[i] = v;
					i = child;
					child <<= 1;
				}
				else break;
			}
			_myHeap[i] = tmp;

		}	
		
	}

}