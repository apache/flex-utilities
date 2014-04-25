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




package com.adobe.linguistics.utils
{
	/**
	 * A Token is an occurrence of a word in a block of text. It consists of the start and end offset of the word in the block of text.
	 * The start and end offsets permit applications to re-associate a token with its source text, e.g., to display highlighted misspelled word in 
	 * a block of text.
	 * @playerversion Flash 10
	 * @langversion 3.0
	 */
	public class Token
	{
		private var _first:uint;
		private var _last:uint;
		
		/**
		 * The Token class.
		 * Constructs a Token with first and last offsets. . 
		 * @param first A <code>int</code> type input to point start offset in the source text.
		 * @param last A <code>int</code> type input to point end offset in the source text.
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function Token(inFirst:int, inLast:int)
		{
			_first = inFirst;
			_last = inLast;

		}
		
		/**
		 * Set the start offset in the source text. 
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function set first(value:int):void {
			_first=value;
		}
		
		/**
		 * Return the start offset in the source text. 
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function get first():int
		{
			return _first;
		}
		
		/**
		 * Set the end offset in the source text. 
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function set last(value:int):void {
			_last = value;
		}
		
		/**
		 * Return the end offset in the source text. 
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function get last():int
		{
			return _last;
		}
	}
}