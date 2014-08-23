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
﻿package
{
	import flash.display.Sprite;
	
	public class FlexPMD195 extends Sprite {
		public function computeJustifyAdjustment(lineArray:Array, firstLineIndex:int, numLines:int):Number
		{
			adj = 0;
			
			if (numLines == 1)
			{
				return 0; // do nothing
			}
			
			// first line unchanged
			var firstLine:IVerticalJustificationLine = lineArray[firstLineIndex];
			var firstBaseLine:Number = getBaseline(firstLine);
			
			// descent of the last line on the bottom of the frame
			var lastLine:IVerticalJustificationLine = lineArray[firstLineIndex + numLines - 1];
			var frameBottom:Number = _textFrame.compositionHeight - Number(_textFrame.effectivePaddingBottom);
			var allowance:Number = frameBottom - getBottomOfLine(lastLine);
			if (allowance < 0)
			{
				return 0; // Some text scrolled out; don't justify
			}
			var lastBaseLine:Number = getBaseline(lastLine);
			
			adj = allowance/(lastBaseLine - firstBaseLine); // multiplicative factor by which the space between consecutive lines is increased
			return adj;
		} 
	}
}