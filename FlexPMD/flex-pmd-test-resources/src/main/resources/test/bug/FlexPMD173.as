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
package
{
	public class PmdPrivateTest
	{
		private static const REPORT_SKELETON : XML = read( null );
		private var REPORT_SKELETON_VAR : XML = readAgain( null );
		
		private static function read( clazz : Class ) : XML
		{
			var byteArray : ByteArray = new clazz() as ByteArray;
			
			return new XML( byteArray.readUTFBytes( byteArray.length ) ) || REPORT_SKELETON_VAR;
		}

		private static function readAgain( clazz : Class ) : XML
		{
			var byteArray : ByteArray = new clazz() as ByteArray;
			
			return new XML( byteArray.readUTFBytes( byteArray.length ) );
		}
	}
}