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
package qs.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import mx.core.IFlexDisplayObject;
	import flash.display.DisplayObject;
	import mx.core.IUIComponent;

	public class UIBitmap extends Bitmap
						 implements IFlexDisplayObject
 	{
		public function UIBitmap(bmd:Object = null,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			super((bmd as BitmapData),pixelSnapping,smoothing);
			if(bmd is IUIComponent)
			{				
				var data:BitmapData = new BitmapData(bmd.width,bmd.height);
				var o:* = bmd;
				data.draw(o);
				bitmapData = data;
			}
		}
		public function get measuredHeight():Number
		{
			return bitmapData.height;
		}
		public function get measuredWidth():Number
		{
			return bitmapData.width;
		}
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	
		/**
		 *  Sets the height and width of this object.
		 */
		public function setActualSize(newWidth:Number, newHeight:Number):void
		{
			width = newWidth;
			height = newHeight;
		}								
	}
}