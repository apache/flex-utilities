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
	 * public interface Iterator
	 * An iterator over a collection. Iterator takes the place of Enumeration 
	 * in the AS collections framework. Iterators differ from enumerations in 
	 * two ways:
	 * Iterators allow the caller to remove elements from the underlying 
	 * collection during the iteration with well-defined semantics.
	 * Method names have been improved. 
	 */
	public interface Iterator
	{

		/**
		 * Grants access to the current item being referenced by the iterator.
		 * This provides a quick way to read or write the current data.
		 * Dirty interface, will remove in next version.
		 */
		function get data():*
		function set data(obj:*):void	

		/**
		 * Seek the iterator to the first item in the collection.
		 */
		function start():void

		/**
		 * Returns the next element in the iteration.
		 * 
		 */
		function next():*
		
		/**
		 * Returns true if the iteration has more elements.
		 * 
		 * @Returns true if the iteration has more elements.
		 */
		function hasNext():Boolean
		
		}
}