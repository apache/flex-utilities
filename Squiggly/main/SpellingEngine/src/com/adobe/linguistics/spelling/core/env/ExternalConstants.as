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


package com.adobe.linguistics.spelling.core.env
{
	/*
	 * External-Internal public Constant properties...
	 * In the future, we might want to merge this class with InternalConstant class...
	 */
	
	public class ExternalConstants
	{

		// casing
		static public const NOCAP:int =					0;
		static public const INITCAP:int =				1;
		
		
		static public const SPELL_COMPOUND:int=			(1 << 0);
		static public const SPELL_FORBIDDEN:int=		(1 << 1);
		static public const SPELL_ALLCAP:int=			(1 << 2);
		static public const SPELL_NOCAP:int=			(1 << 3);
		static public const SPELL_INITCAP:int=			(1 << 4);

		public function ExternalConstants()
		{
		}

	}
}