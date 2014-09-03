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
	 * public interface Collection The root interface in the collection 
	 * hierarchy. A collection represents a group of objects, known as 
	 * its elements. Some collections allow duplicate elements and others 
	 * do not. Some are ordered and others unordered. The SDK does not 
	 * provide any direct implementations of this interface: it provides 
	 * implementations of more specific subinterfaces like Set and List. 
	 */
	 
	 /**
	  * ToDo: add hashCode() function
	  * 	add remove()/add() function
	  */
	 
	public interface Collection
	{

		/**
		 * The number of elements in this collection.
		 * @Returns the number of elements in this collection.
		 */
		function get size():int;
		
		/**
		 * Tests if the collection is empty.
		 * 
		 * @ Returns true if this collection contains no elements.
		 */
		function isEmpty():Boolean
		
		/**
		 * Determines if the collection contains the specified element.
		 * 
		 * @ obj: element whose presence in this collection is to be tested.
		 * 
		 * @ Returns true if this collection contains the specified element.
		 */
		function contains( obj:* ) : Boolean
		
		/**
		 * Removes all of the elements from this collection (optional operation).
		 */
		function clear():void
		
		/**
		 * Returns an iterator over the elements in this collection. There are 
		 * no guarantees concerning the order in which the elements are returned 
		 * (unless this collection is an instance of some class that provides a guarantee). 
		 *
		 * @an Iterator over the elements in this collection
		 */
		function getIterator():Iterator
		
		/**
		 * Returns an array containing all of the elements in this collection. 
		 * If the collection makes any guarantees as to what order its elements 
		 * are returned by its iterator, this method must return the elements 
		 * in the same order.
		 * 
		 * @return An array.
		 */
		function toArray():Array
		
	}
}