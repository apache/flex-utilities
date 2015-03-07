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
package com.adobe.radon.core.skin
{

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;

	import mx.core.EdgeMetrics;
	import mx.graphics.RectangularDropShadow;
	import mx.skins.RectangularBorder;

	/**
	 *  The skin for a ToolTip.
	 */
	public class ErrorToolTipSkin extends RectangularBorder
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 */
		public function ErrorToolTipSkin() 
		{
			super(); 
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		private var dropShadow:RectangularDropShadow;

		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  borderMetrics
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the borderMetrics property.
		 */
		private var _borderMetrics:EdgeMetrics;

		/**
		 *  @private
		 */
		override public function get borderMetrics():EdgeMetrics
		{     
			if (_borderMetrics)
				return _borderMetrics;

			var borderStyle:String = getStyle("borderStyle");
			switch (borderStyle)
			{
				case "errorTipRight":
				{
					_borderMetrics = new EdgeMetrics(15, 1, 3, 3);
					break;
				}

				case "errorTipAbove":
				{
					_borderMetrics = new EdgeMetrics(3, 1, 3, 15);
					break;
				}

				case "errorTipBelow":
				{
					_borderMetrics = new EdgeMetrics(3, 13, 3, 3);
					break;
				}

				default: // "toolTip"
				{
					_borderMetrics = new EdgeMetrics(3, 1, 3, 3);
					break;
				}
			}

			return _borderMetrics;
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  If borderStyle may have changed, clear the cached border metrics.
		 */
		override public function styleChanged(styleProp:String):void
		{
			if (styleProp == "borderStyle" ||
				styleProp == "styleName" ||
				styleProp == null)
			{
				_borderMetrics = null;
			}

			invalidateDisplayList();
		}

		/**
		 *  @private
		 *  Draw the background and border.
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{  
			super.updateDisplayList(w, h);

			var borderStyle:String = getStyle("borderStyle");
			var backgroundColor:uint = getStyle("backgroundColor");
			var backgroundAlpha:Number= getStyle("backgroundAlpha");
			var borderColor:uint = getStyle("borderColor");
			var cornerRadius:Number = getStyle("cornerRadius");
			var shadowColor:uint = getStyle("shadowColor");
			var shadowAlpha:Number = 0.1;

			var graphics:Graphics = graphics;
			graphics.clear();

			filters = [];

			var type:String = GradientType.LINEAR;
			var colors:Array = [0xff8300, 0xff4200];
			var alphas:Array = [1, 1];
			var ratios:Array = [0, 125 ];
			var spreadMethod:String = SpreadMethod.PAD;
			var interp:String = InterpolationMethod.RGB;
			var focalPtRatio:Number = 0;

			var matrix:Matrix = new Matrix();
			var boxRotation:Number = Math.PI/2; // 90Ëš
			var txx:Number = 0;
			var tyy:Number = 0;

			switch (borderStyle)
			{
				case "toolTip":
				{
					// face
					drawRoundRect(
						3, 1, w - 6, h - 4, cornerRadius,
						backgroundColor, backgroundAlpha) 

					if (!dropShadow)
						dropShadow = new RectangularDropShadow();

					dropShadow.distance = 3;
					dropShadow.angle = 90;
					dropShadow.color = 0;
					dropShadow.alpha = 0.4;

					dropShadow.tlRadius = cornerRadius + 2;
					dropShadow.trRadius = cornerRadius + 2;
					dropShadow.blRadius = cornerRadius + 2;
					dropShadow.brRadius = cornerRadius + 2;

					dropShadow.drawShadow(graphics, 3, 0, w - 6, h - 4);

					break;
				}

				case "errorTipRight":
				{
					// border 
					matrix.createGradientBox(w - 11, h - 2, boxRotation, tx, ty);
					graphics.beginGradientFill(
						type, 
						colors,
						alphas,
						ratios, 
						matrix, 
						spreadMethod, 
						interp, 
						focalPtRatio);

					drawRoundRect(
						11, 0, w - 11, h - 2, 0 );

					// left pointer 
					graphics.beginGradientFill(
						type, 
						colors,
						alphas,
						ratios, 
						matrix, 
						spreadMethod, 
						interp, 
						focalPtRatio);

					graphics.moveTo(11, 7);
					graphics.lineTo(0, 13);
					graphics.lineTo(11, 19);
					graphics.moveTo(11, 7);
					graphics.endFill();

					filters = [ new DropShadowFilter(2, 90, 0, 0.4) ];
					break;
				}

				case "errorTipAbove":
				{
					// border 
					matrix.createGradientBox(w, h - 13, boxRotation, tx, ty);
					graphics.beginGradientFill(
						type, 
						colors,
						alphas,
						ratios, 
						matrix, 
						spreadMethod, 
						interp, 
						focalPtRatio);

					drawRoundRect(
						0, 0, w, h - 13, 0 ); 

					// bottom pointer 
					graphics.beginGradientFill(
						type, 
						colors,
						alphas,
						ratios, 
						matrix, 
						spreadMethod, 
						interp, 
						focalPtRatio);

					graphics.moveTo(9, h - 13);
					graphics.lineTo(15, h - 2);
					graphics.lineTo(21, h - 13);
					graphics.moveTo(9, h - 13);
					graphics.endFill();

					filters = [ new DropShadowFilter(2, 90, 0, 0.4) ];
					break;
				}

				case "errorTipBelow":
				{
					// border 
					matrix.createGradientBox(w, h - 13, boxRotation, tx, ty);
					graphics.beginGradientFill(
						type, 
						colors,
						alphas,
						ratios, 
						matrix, 
						spreadMethod, 
						interp, 
						focalPtRatio);

					drawRoundRect(
						0, 11, w, h - 13, 0 );

					// top pointer 
					graphics.beginGradientFill(
						type, 
						colors,
						alphas,
						ratios, 
						matrix, 
						spreadMethod, 
						interp, 
						focalPtRatio);

					graphics.moveTo(9, 11);
					graphics.lineTo(15, 0);
					graphics.lineTo(21, 11);
					graphics.moveTo(10, 11);
					graphics.endFill();

					filters = [ new DropShadowFilter(2, 90, 0, 0.4) ];
					break;
				}
			}
		}
	}
}
