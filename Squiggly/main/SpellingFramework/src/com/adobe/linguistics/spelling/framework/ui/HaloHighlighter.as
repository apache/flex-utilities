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

package com.adobe.linguistics.spelling.framework.ui
{
	import __AS3__.vec.Vector;
	
	import com.adobe.linguistics.utils.Token;
	
	import flash.geom.Point;
	import flash.text.TextField;
	
	import mx.core.IUITextField;

	/**
	 * <p>This class facilitates drawing of squiggly lines below words for TextField class. TextField class is used to create display objects for text display 
	 * and input for Halo TextArea and TextInput components. HaloHighlighter could therefore be used for drawing squiggly lines in these Halo components.</p>
	 * 	
	 * @playerversion Flash 9.x
	 * @langversion 3.0
	 */

	public class HaloHighlighter implements IHighlighter
	{
		private var mTextField:TextField;
		private var mHighlighter:SpellingHighlighter;
		/*
		* offset point:
		*/
		private var _offsetPoint:Point;

		/**
		 * The constructor for HaloHighlighter.
		 * @param textField <code>TextField</code> in which to enable highlighting.		 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function HaloHighlighter( textField:TextField )
		{
			if (textField == null ) throw new Error("illegal argument."); 
			mTextField = textField;
			mHighlighter = null;
			this._offsetPoint = new Point(0,0);
		}
		/**
		 * Draw squiggly lines below a given token.
		 * @param token <code>Token</code> information of the word to be highlighted.		 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function drawSquiggleAt(token:Token):void
		{
			squiggleWord(token);
		}
		
		/**
		 * Clear all squiggly lines in the TextField.		
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function clearSquiggles():void
		{
			if (mHighlighter) {
				mTextField.parent.removeChild(mHighlighter);
				mHighlighter=null;
			}
			
		}
		
		/**
		 * Set offset point information for scrollable controls. This is used by the highlighter to move 
		 * the squiggly lines as the text scrolls inside the control.	
		 * @param op offset information as a <code>Point</code> instance.		 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function set offsetPoint(op:Point):void{
			_offsetPoint = op;
		}
		
		/**
		 * Get offset point information for scrollable controls. This is used by the highlighter to move 
		 * the squiggly lines as the text scrolls inside the control.	
		 * @param op offset information as a <code>Point</code> instance.		 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function get offsetPoint():Point{
			return _offsetPoint;
		}
		

		private function squiggleWord(token:Token):void {
						
			if (!mHighlighter) {
				mHighlighter= new SpellingHighlighter( mTextField as IUITextField);
				mTextField.parent.addChild(mHighlighter);				
			}
						
			mHighlighter.drawSquigglyLine(token.first, token.last);
		
		
			//mTextField.parent.addChild(mHighlighter);	
			mHighlighter.move(_offsetPoint.x, _offsetPoint.y);
		}

	}
}