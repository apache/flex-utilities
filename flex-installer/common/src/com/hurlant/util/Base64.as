/**
 Licensed to the Apache Software Foundation (ASF) under one or more
 contributor license agreements.  See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 The ASF licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License.  You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 */
/*
 * This is a Flex-based replacement of a subset of the original, which was
 *    Copyright (C) 2012 Jean-Philippe Auclair
 *    Licensed under the MIT license.
 */
package com.hurlant.util {

	import flash.utils.ByteArray;
    import mx.utils.Base64Encoder;

	public class Base64 {

		public static function encode(data:String):String {
			var encoder:Base64Encoder = new Base64Encoder();
            encoder.encode(data);
			return encoder.toString();
		}
	}

}
