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


package com.adobe.linguistics.spelling.core.error
{
	/*
	 *@private
	 * Deprecated class for now...
	 * History: 
	 *          In the beginning, I would like to have our own error class for critical exception. 
	 *          After sharing this with Xie, I was convinced to drop this idea by discussing with Xie. 
	 * ToDo: Need a revisit after we have compound word support.
	 */
	public class ErrorTable
	{
		
		static public const CONTENTPARSINGERROR_ID:int=11235;
		static public const CONTENTPARSINGERROR_MSG:String="null cannot be parsed to a squiggly dictionary";
		public function ErrorTable()
		{
		}

	}
}