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
package foo.bar {
	public function baz(): void { }
	public class A
	{
		public static const XYZ:String = XYZ; // meant to be "xyz" 
		public static var a:String = a; // meant to be "a" 
		public static const XYZA:String = "XYZA";
		public const XYZ:String = XYZ; // meant to be "xyz" 
		public var a:String = a; // meant to be "a" 
		public const XYZA:String = "XYZA";
	}
} 