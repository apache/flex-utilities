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
	import com.adobe.linguistics.utils.TextTokenizer;
	import com.adobe.linguistics.utils.Token;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.engine.TextLine;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.tlf_internal;


	use namespace tlf_internal;	

	/**
	 * <p>This class facilitates drawing of squiggly lines below words for TLF TextFlow class.</p>
	 * <p>The TextFlow class is responsible for managing all 
	 * the text content of a story. In TextLayout, text is stored in a hierarchical tree of elements. TextFlow is the root object of the element tree. 
	 * All elements on the tree derive from the base class, FlowElement. </p> 
	 * TLFHighlighter could be used for drawing squiggly lines in any of the custom visual components(probably based on <code>Sprite</code>) which make use 
	 * of TextFlow to display text.
	 * 	
	 * @playerversion Flash 10
	 * @langversion 3.0
	 */
	public class TLFHighlighter implements IHighlighter
	{
		
		private var mTextFlow:TextFlow;
		private var mHighlighter:Dictionary;
	
		//private var mHighlighter:Shape;
		private var ccindex:int;
		private var cc:ContainerController;
		/*
		* offset point:
		*/
		private var _offsetPoint:Point;

		/**
		 * The constructor for TLFHighlighter.
		 * @param textFlow <code>TextFlow</code> in which to enable highlighting.		 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function TLFHighlighter( textFlow:TextFlow )
		{
			if (textFlow == null ) throw new Error("illegal argument."); 
			mTextFlow = textFlow;
			//mHighlighter = null;
			mHighlighter = new Dictionary(true);
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
			
			for (var idx:int = 0; idx < mTextFlow.flowComposer.numControllers; idx++)
			{	
				var cctmp:ContainerController = mTextFlow.flowComposer.getControllerAt(idx);
				if (mHighlighter[cctmp.container] != null) {
					
					//ToDO: This assumes single container for whole of mTextFlow. Need to implement for multiple container case.
					cctmp.container.removeChild((mHighlighter[cctmp.container] as Shape));
					
					mHighlighter[cctmp.container] = null;
				}	
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
			var ta:TextFlow = mTextFlow;
			
			if (!ta) return;		
			ccindex = ta.flowComposer.findControllerIndexAtPosition(token.first);
			
			cc = ta.flowComposer.getControllerAt(ccindex);
			
			if (mHighlighter[cc.container] == null ) {
				mHighlighter[cc.container]= new Shape();
				(mHighlighter[cc.container] as Shape).graphics.clear();
				//ccindex = ta.flowComposer.findControllerIndexAtPosition(token.first);
				
				//var cc:ContainerController = ta.flowComposer.getControllerAt(ccindex);
				//ToDO: This assumes single container for whole of mTextFlow. Need to implement for multiple container case.
				cc.container.addChild((mHighlighter[cc.container] as Shape));				
			}
					
		    drawSquigglyLineForRange(token.first, token.last);
			
			// Just adjust the left padding, top padding is not an issue 
			//var pleft:uint = mTextFlow.getStyle("paddingLeft");
			//mHighlighter.x += pleft;		
		}
		
		// Draw squiggly line
		private function drawSquigglyLineForRange(start:Number, end:Number):void
		{
			// draw squiggly line
			var tf:TextFlow = mTextFlow;
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
			var tf:TextFlow = mTextFlow;
			var tfl:TextFlowLine = tf.flowComposer.getLineAt(lineIndex);
			var rectLine:Rectangle = tfl.getBounds(); 
			if (endIndex == 0x7FFFFFFF) {
				drawSquigglyLineAtPoint(rectLine.left, rectLine.bottom, rectLine.right - rectLine.left, lineIndex);
			}
			else {
				// Force to have a valid TextLine
				var tl:TextLine = tfl.getTextLine(true);
				
				// TODO: atom index and char index is not matching for some chars, use try/catch to avoid crash
				try {
					var rectFirst:Rectangle = tl.getAtomBounds(startIndex);
					var rectLast:Rectangle = tl.getAtomBounds(endIndex);
					drawSquigglyLineAtPoint(rectFirst.left + tfl.x, rectLine.bottom, rectLast.right - rectFirst.left, lineIndex);
				} catch (err:Error)
				{
					//TODO: report error
				}
			}
				
		}
		// Draw a squiggly from point x,y with given width, the line is drawn in mHighlighter 
		private function drawSquigglyLineAtPoint(x:Number, y:Number, width:Number, lineIndex:Number):void
		{
			var tf:TextFlow = mTextFlow;
			var tfl:TextFlowLine = tf.flowComposer.getLineAt(lineIndex);
			var tl:TextLine = tfl.getTextLine(true);
						
			(mHighlighter[cc.container] as Shape).graphics.lineStyle(1, 0xfa0707, .65);
			(mHighlighter[cc.container] as Shape).graphics.moveTo(x, y);
			var upDirection:Boolean = false;
			var offset:uint = 0;
			var stepLength:uint = 2;
			for ( var i:uint = 1; offset <= width; i++) {
				offset = offset + stepLength;
				if ( upDirection )
					(mHighlighter[cc.container] as Shape).graphics.lineTo(x+offset,y);
				else
					(mHighlighter[cc.container] as Shape).graphics.lineTo(x+offset,y+stepLength);
				upDirection = !upDirection;
			}
			
			//tl.addChild(mHighlighter);
						
			//tf.flowComposer.updateToController(ccindex);

		}
		

	}
	
}

