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
	public class MathUtils
	{
		/**
		 *  Return next prime; assume N >= 10 
		 */
		public static function nextPrime( N:int ):int
		{
			var i:int;
			var continueFlag:Boolean;
			if( N % 2 == 0 )
				N++;
			for( ; ; N += 2 )
			{
				continueFlag = false;
				for( i = 3; i * i <= N; i += 2 )
					if( N % i == 0 ) {
						continueFlag = true;    //Sorry about this!
						break;
					}
				if ( continueFlag ) continue;
				return N;
			}
			return -1; // failure branch... it should never happen.
		}

		/**
		 * Rounds a number to a specific number of decimal places.
		 */
		public static function roundPrecision(number:Number, precision:int=0):Number
		{
			var places:Number = Math.pow(10, precision);
			return Math.round(places * number) / places;
		}

		/**
		 * Generates a random number between two number values.
		 */
		public static function randomBetween(min:Number=0, max:Number=99999999, precision:int=0):Number
		{
			return roundPrecision(Math.random() * (max - min) + min, precision);
		}

	}
}