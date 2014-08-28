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
	import __AS3__.vec.Vector;
	
	import com.adobe.linguistics.utils.Token;
	
	import flash.geom.Point;
	import flash.text.TextField;
	
	import mx.core.IUITextField;


	public class HaloHighlighter implements IHighlighter
	{
		private var mTextField:TextField;
		private var mHighlighter:SpellingHighlighter;
		/*
		* offset point:
		*/
		private var _offsetPoint:Point;

		public function HaloHighlighter( textField:TextField )
		{
			if (textField == null ) throw new Error("illegal argument."); 
			mTextField = textField;
			mHighlighter = null;
			this._offsetPoint = new Point(0,0);
		}
		/*************************Public function************************************/
		public function drawSquiggles(tokens:Vector.<Token>):void
		{
			spellCheckRange(tokens);
		}
		
		public function clearSquiggles():void
		{
			if (mHighlighter) {
				mTextField.parent.removeChild(mHighlighter);
				mHighlighter=null;
			}
			
		}

		public function set offsetPoint(op:Point):void{
			_offsetPoint = op;
		}
		
		public function get offsetPoint():Point{
			return _offsetPoint;
		}


		private function spellCheckRange(tokens:Vector.<Token>):void {
			
			mHighlighter= new SpellingHighlighter( mTextField as IUITextField);
			
			
			for ( var i:int = 0; i< tokens.length; ++i ) {
				var _token:Token = tokens[i];
				mHighlighter.drawSquigglyLine(_token.first, _token.last);
			}
			
			mTextField.parent.addChild(mHighlighter);	
			mHighlighter.move(_offsetPoint.x, _offsetPoint.y);
		}

	}
}