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
	/**
	 * BinaryHeap implementation of priority queue. The heap is either a 
	 * minimum or maximum heap as determined by parameters passed to constructor. 
	 * 
	 */
	public final class Heap implements Collection
	{
		private var __size:int;
		private var __count:int;
		private var __compare:Function;
		public var __heap:Array;
		
		/**
		 * Create a new heap.
		 * 
		 * @param size The heap's maximum capacity.
		 * @param compare A comparison function for sorting the heap's data.
		 *        If no function is passed, the heap uses default function.
		 */
		public function Heap(size:int=1000, compare:Function = null)
		{
			__count = 0;
			__heap = new Array(__size = size + 1);
			
			if (compare == null)
				__compare = function(a:int, b:int):int { return a - b; };
			else
				__compare = compare;
		}

		/**
		 * The maximum capacity.
		 */
		public function get maxSize():int
		{
			return __size;
		}

		public function isEmpty():Boolean
		{
			return false;
		}
		
		public function toArray():Array
		{
			return __heap.slice(1, __count + 1);
		}
		
		public function toString():String
		{
			return "[Heap, size=" + __size +"]";
		}
		
		public function dump():String
		{
			var k:int = __count + 1;
			var s:String = "Heap\n{\n";
			for (var i:int = 1; i < k; i++)
				s += "\t" + __heap[i] + "\n";
			s += "\n}";
			return s;
		}
		
		/**
		 * The front item.
		 */
		public function get front():*
		{
			return __heap[1];
		}
		
		/**
		 * Enqueues.
		 * @param obj The data to enqueue.
		 * @return False if the queue is full, otherwise true.
		 */
		public function enqueue(obj:*):Boolean
		{
			if (__count + 1 < __size){
				__heap[++__count] = obj;
				
				var i:int = __count;
				var tmp:* = __heap[i];
				var v:*;
				var parent:int = i >> 1;
				
				if (__compare != null)
				{
					while (parent > 0){
						 v = __heap[parent];
						if (__compare(tmp, v) < 0){
							__heap[i] = v;
							i = parent;
							parent >>= 1;
						}
						else break;
					}
				}else{
					while (parent > 0){
						v = __heap[parent];
						if (tmp - v < 0){
							__heap[i] = v;
							i = parent;
							parent >>= 1;
						}
						else break;
					}
				}
				__heap[i] = tmp;
				return true;
			}
			return false;
		}
		
		/**
		 * Dequeues.
		 * @return The heap's front item or null if it is empty.
		 */
		public function dequeue():*
		{
			if (__count >= 1){
				var o:* = __heap[1];
				
				__heap[1] = __heap[__count];
				delete __heap[__count];
				
				var tmp:* = __heap[i];
				var i:int = 1;
				var v:*;
				var child:int = i << 1;
				
				if (__compare != null) {
					while (child < __count) {
						if (child < __count - 1) {
							if (__compare(__heap[child], __heap[int(child + 1)]) > 0)
								child++;
						}
						v = __heap[child];
						if (__compare(tmp, v) > 0){
							__heap[i] = v;
							i = child;
							child <<= 1;
						}
						else break;
					}
				}else{
					while (child < __count){
						if (child < __count - 1){
							if (__heap[child] - __heap[int(child + 1)] > 0)
								child++;
						}
						v = __heap[child];
						if (tmp - v > 0){
							__heap[i] = v;
							i = child;
							child <<= 1;
						}
						else break;
					}
				}
				__count--;
				__heap[i] = tmp;
				return o;
			}
			return null;
		}
		
		/**
		 * Tests if a given item exists.
		 */
		public function contains(obj:*):Boolean
		{
			for (var i:int = 1; i <= __count; i++){
				if (__heap[i] === obj)
					return true;
			}
			return false;
		}
		
		public function clear():void
		{
			__heap = new Array(__size);
			__count = 0;
		}
		
		public function getIterator():Iterator
		{
			return new HeapIterator(this);
		}

		public function get size():int
		{
			return __count;
		}
		
	}
}

import com.adobe.linguistics.spelling.core.container.Heap;
import com.adobe.linguistics.spelling.core.container.Iterator;

internal class HeapIterator implements Iterator
{
	private var __values:Array;
	private var __length:int;
	private var __cursor:int;
	
	public function HeapIterator(heap:Heap)
	{
		__values = heap.toArray();
		__cursor = 0;
		__length = __values.length;
	}
	
	public function get data():*
	{
		return __values[__cursor];
	}
	
	public function set data(obj:*):void
	{
		__values[__cursor] = obj;
	}
	
	public function start():void
	{
		__cursor = 0;
	}
	
	public function hasNext():Boolean
	{
		return __cursor < __length;
	}
	
	public function next():*
	{
		return __values[__cursor++];
	}
}

