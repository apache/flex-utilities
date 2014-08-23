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
package com.commons.context
{
	import flash.events.IEventDispatcher;
	
	/**
	 * Interface IContext.
	 * 
	 * @author  (resp. mv)
	 */
	public interface IContext extends IEventDispatcher
	{
		
		/** 
		 * Get Value for given key.
		 * All contexts are searched for the given key.
		 * 
 		 * @param key the name of the attribute to search.
		 * @result the found value for given key or null.
		 */
		function getValue(key:String) : Object;

		/**
		 * Put a value into the context for a given key.
		 * 
		 * @param key the key to store this object.
		 * @param value the value of the given key.
		 */
		function putValue(key:String, value:Object) : void;
		
		/**
		 * Get the context of given type.
		 * 
		 * @param contextType the type of the context.
		 * @result the context of the given type or null.
		 */
		function getContext(contextType:String) : IContext;
		
		/**
		 * Get the owner of this context.
		 * @return the owner, if there is one, or null.
		 */ 
		 [Deprecated("There is no owner any longer. Do not use this property")]
		function get owner() : IContextOwner;

		/**
	 	 * Parent context. (e.g. for managing "shared" resources).
	 	 * All contextes build a tree. With this getter you get the parent of this context inside the tree.
	 	 */
		function get parentContext() : IContext;
		
		/**
		 * Get the resource for given url.
		 * @param key the url or key of the asset.
		 * @return the object of given url with following type:
		 * MediaType.Text  := String
		 * MediaType.Audio := com.commons.media.ISound
		 * MediaType.Image := DisplayObject
		 * MediaType.FlexModule := DisplayObject
		 * MediaType.Video := NetStream
		 * MediaType.FlashApplication := DisplayObject
		 * MediaType.FlexStyleDeclaration := null
		 */
		function getResource(key:String) : Object;
	}
}