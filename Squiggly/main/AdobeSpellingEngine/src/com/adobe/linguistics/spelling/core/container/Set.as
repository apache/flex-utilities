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
	 * A collection that contains no duplicate elements. More formally, sets 
	 * contain no pair of elements e1 and e2 such that e1.equals(e2), and at 
	 * most one null element. As implied by its name, this interface models 
	 * the mathematical set abstraction.
	 */
	public final class Set implements Collection
	{
		private var __size:int;
		private var __set:Dictionary = new Dictionary(true);
		
		/**
		 * Creates a empty set.
		 */
		public function Set()
		{
			__set = new Dictionary();			
		}
		

		public function contains(obj:*):Boolean
		{
			return __set[obj] != undefined;
		}
		
		public function clear():void
		{
			__set = new Dictionary();
			__size = 0;
		}
		
		public function get data():Dictionary {
			return this.__set;
		}
		
		public function getIterator():Iterator
		{
			return new SetIterator(this);
		}
		
		public function get size():int
		{
			return __size;
		}
		
		public function isEmpty():Boolean
		{
			return __size == 0;
		}

		/**
		 * Reads an item from the set.
		 * 
		 * @param obj The item to retrieve.
		 * @return The item matching the obj parameter or null.
		 */
		public function lookup(obj:*):*
		{
			var val:* = __set[obj];
			return val != undefined ? val : null;
		}

		/**
		 * Adds the specified element to this set if it is not already present (optional operation).
		 * 
		 * @param obj The item to be added.
		 */
		public function insert(obj:*):void
		{
			if (obj == null) return;
			if (obj == undefined) return;
			if (__set[obj]) return;
			
			__set[obj] = obj;
			__size++;
		}
		
		/**
		 * Removes the specified element from this set if it is present (optional operation).
		 * 
		 * @param  obj The item to be removed
		 * @return The removed item or null.
		 */
		public function remove(obj:*):Boolean
		{
			if (__set[obj] != undefined)
			{
				delete __set[obj];
				__size--;
				return true;
			}
			return false;
		}
		
		public function toArray():Array
		{
			var a:Array = new Array(__size);
			var j:int;
			for (var i:* in __set) a[j++] = i;
			return a;
		}
		
		/**
		 * Return a string representing the current object.
		 */
		public function toString():String
		{
			return "[Set, size=" + size + "]";
		}
		
		/**
		 * Prints out all elements (debug use only).
		 */
		public function dump():String
		{
			var s:String = "Set:\n";
			for each (var i:* in __set)
				s += "[val: " + i + "]\n";
			return s;
		}
	}

}


import com.adobe.linguistics.spelling.core.container.Iterator
import com.adobe.linguistics.spelling.core.container.Set;

internal class SetIterator implements Iterator
{
	private var __cursor:int;
	private var __size:int;
	private var __s:Set;
	private var __a:Array;

	public function start():void
	{
		__cursor = 0;
	}

	public function get data():*
	{
		return __a[__cursor];
	}
	
	public function set data(obj:*):void
	{
		__s.remove(__a[__cursor]);
		__s.insert(obj);
	}	
	
	public function SetIterator(s:Set)
	{
		__cursor = 0;
		__size = s.size;
		__s = s;
		__a = s.toArray();
	}
	
	public function next():*
	{
		return __a[__cursor++];
	}
	
	public function hasNext():Boolean
	{
		return __cursor < __size;
	}
}
