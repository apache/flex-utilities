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
	/*
	 * A simple number parsing class...
	 */
	public class SimpleNumberParser
	{
		private var numberPattern:RegExp = /^((\d+,?)*\d+)?\.?\d*$|^[-+]?\d+\.?\d*[eE]{1}[-+]?\d+$/;
		private var negativePattern:RegExp = /^-[ ]?([0-9\.,]+)$|^([0-9\.,]+)[ ]?-$|^\([ ]?([0-9\.,]+)[ ]?\)$/;
		private var _decimalSymbol:String, _grouppingSymbol:String;
		
		public function SimpleNumberParser(decimalSymbol:String=".", grouppingSymbol:String=",")
		{
			this._decimalSymbol = decimalSymbol; this._grouppingSymbol = grouppingSymbol;
		}
		
		public function parse(inputString:String):Number {
			var neg:int = 1;
			inputString= inputString.split(_decimalSymbol).join("."); 
			inputString= inputString.split(_grouppingSymbol).join(",");
			inputString= StringUtils.trim(inputString);
			if ( negativePattern.test(inputString) ) {
				var result:Array = inputString.match( negativePattern );
				for ( var i:int = 1; i < result.length; i++ )
					if ( result[i]!= undefined ) break;
				inputString= result[i];
				neg=-1;
			}
			if ( !numberPattern.test( inputString ) ) return NaN;
			inputString= inputString.split(_grouppingSymbol).join(""); 
			return (new Number(inputString))*neg;
		}
	}
}
