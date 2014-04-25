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


package com.adobe.linguistics.spelling.core.logging.targets
{
	public class ArrayTarget extends CollectionTarget
	{
		public var items:Array;
		public function ArrayTarget(arr:Array, usingLevelMaskMode:Boolean = false)
		{
			this.items = arr;
			super(usingLevelMaskMode);
		}
		public override function internalLog(msg:String,lvl:int):void {
			items.push( {date:this.date, time:this.time, category:this.category, levelString:this.levelString, message:msg, level:lvl } );
		}
	}
}