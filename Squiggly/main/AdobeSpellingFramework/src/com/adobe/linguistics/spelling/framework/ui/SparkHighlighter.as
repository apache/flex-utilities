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
	import com.adobe.linguistics.utils.Token;
	import com.adobe.linguistics.utils.TextTokenizer;
	import flash.geom.Point;
	
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.text.engine.TextLine;
	
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.tlf_internal;
	
	import spark.components.RichEditableText;
	use namespace tlf_internal;	
	
	/**
	 * <p>This class facilitates drawing of squiggly lines below words for RichEditableText class. RichEditableText is a low-level UIComponent for displaying, 
	 * scrolling, selecting, and editing richly-formatted text. This class is used in the skins of the Spark versions of TextInput and TextArea. 
	 * SparkHighlighter could therefore be used for drawing squiggly lines in these Spark components.</p>
	 * 	
	 * @playerversion Flash 10
	 * @langversion 3.0
	 */
	public class SparkHighlighter implements IHighlighter
	{
		
		private var mTextField:RichEditableText;
		private var mHighlighter:Shape;
		/*
		* offset point:
		*/
		private var _offsetPoint:Point;

		/**
		 * The constructor for SparkHighlighter.
		 * @param richEditableText <code>RichEditableText</code> in which to enable highlighting.		 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function SparkHighlighter( richEditableText:RichEditableText )
		{
			if (richEditableText == null ) throw new Error("illegal argument."); 
			mTextField = richEditableText;
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
		 * Clear all squiggly lines in the component.		
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function clearSquiggles():void
		{
			if (mHighlighter) {
				mTextField.removeChild(mHighlighter);
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

		

		// TODO: refactor this code to share with halo components, and support words that cross lines
		private function squiggleWord(token:Token):void {
					
			var ta:RichEditableText = mTextField;
			if (!ta) return;		
			
			if (!mHighlighter) {
				mHighlighter= new Shape();
				mHighlighter.graphics.clear();
				mTextField.addChild(mHighlighter);	
			}
					
		        drawSquigglyLineForRange(token.first, token.last);
			
			// Just adjust the left padding, top padding is not an issue 
			//var pleft:uint = mTextField.getStyle("paddingLeft");
			//mHighlighter.x += pleft;		
		}
		
		// Draw squiggly line
		private function drawSquigglyLineForRange(start:Number, end:Number):void
		{
			// draw squiggly line
			var tf:TextFlow = mTextField.textFlow;
			var tflFirst:TextFlowLine = tf.flowComposer.findLineAtPosition(start);
			var tflLast:TextFlowLine = tf.flowComposer.findLineAtPosition(end);
			var tflIndexFirst:int = tf.flowComposer.findLineIndexAtPosition(start);
			var tflIndexLast:int = tf.flowComposer.findLineIndexAtPosition(end);
			
			// Pointer
			var tflIndex:int = tflIndexFirst;
			var tfl:TextFlowLine = tflFirst;
			
			if (tflIndexFirst == tflIndexLast) {
				// Draw one line
				drawSquigglyLineAtIndex(tflIndexFirst, start - tflFirst.absoluteStart, end - tflFirst.absoluteStart);
			} else {
				// Multiple lines (very long word)
				drawSquigglyLineAtIndex(tflIndexFirst, start - tflFirst.absoluteStart);
				
				tflIndex++;
				while (tflIndex != tflIndexLast) {
					drawSquigglyLineAtIndex(tflIndex);
					tflIndex++;
				}
				
				drawSquigglyLineAtIndex(tflIndexLast, 0, end - tflLast.absoluteStart);
			}
		}
		
		// Draw a squiggly line at specific line for specific index range
		private function drawSquigglyLineAtIndex(lineIndex:Number, startIndex:Number=0, endIndex:Number=0x7FFFFFFF):void
		{
			var tf:TextFlow = mTextField.textFlow;
			var tfl:TextFlowLine = tf.flowComposer.getLineAt(lineIndex);
			var rectLine:Rectangle = tfl.getBounds();
			if (endIndex == 0x7FFFFFFF) {
				drawSquigglyLineAtPoint(rectLine.left, rectLine.bottom, rectLine.right - rectLine.left);
			}
			else {
				// Force to have a valid TextLine
				var tl:TextLine = tfl.getTextLine(true);
				
				// TODO: atom index and char index is not matching for some chars, use try/catch to avoid crash
				try {
					var rectFirst:Rectangle = tl.getAtomBounds(startIndex);
					var rectLast:Rectangle = tl.getAtomBounds(endIndex);
					drawSquigglyLineAtPoint(rectFirst.left + tfl.x, rectLine.bottom, rectLast.right - rectFirst.left);
				} catch (err:Error)
				{
					//TODO: report error
				}
			}
				
		}
		// Draw a squiggly from point x,y with given width, the line is drew in mHighlighter 
		private function drawSquigglyLineAtPoint(x:Number, y:Number, width:Number):void
		{
			mHighlighter.graphics.lineStyle(1, 0xfa0707, .65);
			mHighlighter.graphics.moveTo(x, y);
			var upDirection:Boolean = false;
			var offset:uint = 0;
			var stepLength:uint = 2;
			for ( var i:uint = 1; offset <= width; i++) {
				offset = offset + stepLength;
				if ( upDirection )
					mHighlighter.graphics.lineTo(x+offset,y);
				else
					mHighlighter.graphics.lineTo(x+offset,y+stepLength);
				upDirection = !upDirection;
			}	
		}
		
		private function getValidFirstWordIndex():int{
			var index:int = SelectionManager.computeSelectionIndex(mTextField.textFlow, mTextField, mTextField, 0 + mTextField.horizontalScrollPosition, 0 + mTextField.verticalScrollPosition);
			return index;

			
		}
		
		private function getValidLastWordIndex():int{
			var index:int = SelectionManager.computeSelectionIndex(mTextField.textFlow, mTextField, mTextField, mTextField.width+mTextField.horizontalScrollPosition, mTextField.height+mTextField.verticalScrollPosition);
			return index;

		}

	}
}
