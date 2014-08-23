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

package com.adobe.linguistics.spelling.ui
{
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextLineMetrics;
	
	import mx.core.IUITextField;
	import mx.flash.UIMovieClip;


	public class SpellingHighlighter extends UIMovieClip
	{
		/*
		* offset point:
		*/
		private var _offsetPoint:Point;
		
		/*
		* Target TextField.
		*/
		private var _textField:IUITextField;
		private static var InvalidIndexValue:int = -2;
		public function SpellingHighlighter(textField:IUITextField) {
			super();
			this._textField = textField;
			this._offsetPoint = new Point(0,0);
		}
		
		public function drawSquigglyLine(firstCharIndex:int, lastCharIndex:int ):void {
			var validFirstCharIndex:int = getValidFirstCharIndex(firstCharIndex);
			var validLastCharIndex:int = getValidLastCharIndex(lastCharIndex);
			if ( validFirstCharIndex == InvalidIndexValue || validLastCharIndex == InvalidIndexValue ){
				return;
			}
			/* draw squiggly line here. */
			if ( validFirstCharIndex <= validLastCharIndex ) {
				var firstLine:int = _textField.getLineIndexOfChar(validFirstCharIndex);
				var lastLine:int = _textField.getLineIndexOfChar(validLastCharIndex);
				//only one line case.
				if(lastLine==firstLine)
				{
					drawSingleSquigglyLine(validFirstCharIndex, validLastCharIndex);
					return;
				}
				//more than one line.
				//first line
				drawSingleSquigglyLine(validFirstCharIndex, _textField.getLineOffset(firstLine)+_textField.getLineLength(firstLine)-1);
				//middle....
				for(var i:int=firstLine+1;i<lastLine;i++)
				{
					drawSingleSquigglyLine(_textField.getLineOffset(i), _textField.getLineOffset(i)+_textField.getLineLength(i)-1);
				}
				//last lines.
				drawSingleSquigglyLine(_textField.getLineOffset(lastLine), validLastCharIndex);
			}
		}
		
		public function drawSingleSquigglyLine(firstCharIndex:int, lastCharIndex:int ):void {
			var firstLine:int = _textField.getLineIndexOfChar(firstCharIndex);
			var lastLine:int = _textField.getLineIndexOfChar(lastCharIndex);
			if ( firstLine != lastLine ) {
				return;
			}else {
				var rect1:Rectangle = _textField.getCharBoundaries(firstCharIndex);
				var rect2:Rectangle = _textField.getCharBoundaries(lastCharIndex);
				var x:Number = rect1.x+_offsetPoint.x - _textField.scrollH;
				var y:Number = rect1.y + rect1.height + 2;
				var width:Number = rect2.x+rect2.width-rect1.x;
				
				// Avoid drawing outside the textField
				if (x<0) 
				{
					if (x+width > 0) {
						width += x;
						x = 0;
					} 
					else
						return;
				}
				if (x+width > _textField.width) 
				{
					if (x < _textField.width) {
						width = textField.width - x;
					} 	
					else
						return;
				}
				
				// The rectangle that bound the string you want
				// actual work here.
				var myShape:Shape = new Shape();
				myShape.graphics.clear();
				//myShape.graphics.beginFill(0x0099CC, .35); 
				myShape.graphics.lineStyle(1, 0xfa0707, .65);
				myShape.graphics.moveTo(x, y);
				var upDirection:Boolean = false;
				var offset:uint = 0;
				var stepLength:uint = 2;
				for ( var i:uint = 1; offset <= width; i++) {
					offset = offset + stepLength;
					if ( upDirection )
						myShape.graphics.lineTo(x+offset,y);
					else
						myShape.graphics.lineTo(x+offset,y+stepLength);
					upDirection = !upDirection;
				}
				//myShape.graphics.endFill();
				this.addChild(myShape);	
			}
		}
		
		private function getValidFirstCharIndex(firstCharIndex:int):int{
			if(firstCharIndex<0 || firstCharIndex>_textField.text.length-1) 
			{
				return InvalidIndexValue;
			}
			var firstLine:Number = _textField.getLineIndexOfChar(firstCharIndex);
			
			if(firstLine<_textField.scrollV-1)
			{
				firstLine = _textField.scrollV-1;
				return _textField.getLineOffset(firstLine);
			}
			return firstCharIndex;
		}
		
		private function getValidLastCharIndex(lastCharIndex:int):int{
			if(lastCharIndex<0 || lastCharIndex>_textField.text.length-1) 
			{
				return InvalidIndexValue;
			}
			var lastLine:Number = _textField.getLineIndexOfChar(lastCharIndex);
			if(lastLine>_textField.bottomScrollV-1)
			{
				lastLine = _textField.bottomScrollV-1;
				return _textField.getLineOffset(lastLine)+_textField.getLineLength(lastLine)-1;
			}
			return lastCharIndex;
		}
					
		public function set textField(tf:IUITextField):void{
			_textField = tf;
		}
		
		public function get textField():IUITextField{
			return _textField;
		}
		
		public function set offsetPoint(op:Point):void{
			_offsetPoint = op;
		}
		
		public function get offsetPoint():Point{
			return _offsetPoint;
		}


	}
}