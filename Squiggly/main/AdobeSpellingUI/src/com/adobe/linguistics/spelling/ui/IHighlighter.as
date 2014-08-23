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

package com.adobe.linguistics.spelling.ui
{
	import com.adobe.linguistics.utils.Token;
	import __AS3__.vec.Vector;
	import flash.geom.Point;
	
	/**
	 * The <code>IHighlighter</code> Interface.
	 * This interface defines default methods which will be used for highlighting text in UI components.
	 *
	 * @playerversion Flash 10
	 * @langversion 3.0
	 */
	
	public interface IHighlighter
	{
		/**
		 * Draw squiggly lines below a given token.
		 * @param token <code>Token</code> information of the word to be highlighted.		 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		function drawSquiggleAt(token:Token):void;
		/**
		 * Clear all squiggly lines in the UI.		
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		function clearSquiggles():void;
		/**
		 * Set offset point information for scrollable controls. This is used by the highlighter to move 
		 * the squiggly lines as the text scrolls inside the control.	
		 * @param op offset information as a <code>Point</code> instance.		 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		function set offsetPoint(op:Point):void;
		/**
		 * Get offset point information for scrollable controls. This is used by the highlighter to move 
		 * the squiggly lines as the text scrolls inside the control.	
		 * @param op offset information as a <code>Point</code> instance.		 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		function get offsetPoint():Point;
		
	}
}