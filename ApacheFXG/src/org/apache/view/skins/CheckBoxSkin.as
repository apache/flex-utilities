package org.apache.view.skins
{
	import org.apache.model.utils.ColorUtils;
	import org.apache.view.utils.SkinUtils;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	
	import mx.skins.Border;
	import mx.styles.StyleManager;
	import mx.utils.ColorUtil;
	
	/**
	 *  The skin for all the states of the icon in a CheckBox.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class CheckBoxSkin extends Border
	{

//		private static var cache:Object = {};
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 *  Several colors used for drawing are calculated from the base colors
		 *  of the component (themeColor, borderColor and fillColors).
		 *  Since these calculations can be a bit expensive,
		 *  we calculate once per color set and cache the results.
		 */
		/*
		private static function calcDerivedStyles(themeColor:uint,
												  borderColor:uint,
												  fillColor0:uint,
												  fillColor1:uint):Object
		{
			var key:String = HaloColors.getCacheKey(themeColor, borderColor,
				fillColor0, fillColor1);
			if (!cache[key])
			{
				var o:Object = cache[key] = {};
				// Cross-component styles.
				HaloColors.addHaloColors(o, themeColor, fillColor0, fillColor1);
				// CheckBox-specific styles.
				o.borderColorDrk1 = ColorUtil.adjustBrightness2(borderColor, -50);
			}
			return cache[key];
		}
		*/
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function CheckBoxSkin()
		{
			super();
			var baseColor:uint = SkinUtils.backgroundColor;
			
			if(SkinUtils.darkTheme){
				_iconColor = 0xbababa;
				
				_borderColor1 = ColorUtils.darken(baseColor, 30);
				_borderColor1 = ColorUtils.darken(baseColor, 35);
				_fillColor1 = ColorUtils.lighten(baseColor, 25);
				_fillColor2 = ColorUtils.lighten(baseColor, 10);
				_innerShadowColor = ColorUtils.lighten(baseColor, 52);
				_dropShadowColor = 0xFFFFFF;
			} else {
				_iconColor = 0x353535;
				
				_borderColor1 = 0x878787;//ColorUtils.darken(baseColor, 90);
				_borderColor1 = 0x7d7d7d;//ColorUtils.darken(baseColor, 80);
				_fillColor1 = ColorUtils.lighten(baseColor, 40);
				_fillColor2 = ColorUtils.lighten(baseColor, 20);
				_innerShadowColor = ColorUtils.lighten(baseColor, 40);
				_dropShadowColor = 0;
			}
		}
		
		private var _borderColor1:uint;
		private var _borderColor2:uint;
		private var _fillColor1:uint;
		private var _fillColor2:uint;
		private var _iconColor:uint;
		private var _innerShadowColor:uint;
		private var _dropShadowColor:uint;
		
		override public function get measuredWidth():Number
		{
			return 15;
		}
		//----------------------------------
		//  measuredHeight
		//----------------------------------
		/**
		 *  @private
		 */        
		override public function get measuredHeight():Number
		{
			return 15;
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			// User-defined styles
			//var borderColor:uint = getStyle("borderColor");
			//var checkColor:uint = getStyle("iconColor");
			//var fillAlphas:Array = getStyle("fillAlphas");
			//var fillColors:Array = getStyle("fillColors");
			//styleManager.getColorNames(fillColors);
			var highlightAlphas:Array = [1,1];//getStyle("highlightAlphas");
			var themeColor:uint = getStyle("themeColor");
			// Derived styles
			//var derStyles:Object = calcDerivedStyles(themeColor, borderColor, 
			//	fillColors[0], fillColors[1]);
			var borderColorDrk1:Number =
				ColorUtil.adjustBrightness2(_borderColor1, -50);
			var themeColorDrk1:Number =
				ColorUtil.adjustBrightness2(themeColor, -25);
			var bDrawCheck:Boolean = false;
			var upFillColors:Array;
			var upFillAlphas:Array;
			var overFillColors:Array;
			var overFillAlphas:Array;
			var disFillColors:Array;
			var disFillAlphas:Array;
			var g:Graphics = graphics;
			g.clear();
			switch (name){
				case "selectedUpIcon":
				case "selectedOverIcon":
				case "selectedDisabledIcon":
					bDrawCheck = true;
					break;
			}
			switch (name){
				case "upIcon":
				case "selectedUpIcon":
				case "overIcon":
				case "selectedOverIcon":
				case "disabledIcon":
				case "selectedDisabledIcon":
					upFillColors = [ _fillColor1, _fillColor2 ];
					upFillAlphas = [1,1];
					// box fill
					drawRoundRect(
						0, 0, w - 1, h - 1, 2,
						upFillColors, upFillAlphas,
						verticalGradientMatrix(0, 0, w - 1, h - 1)); 
					// border
					drawRoundRect(
						0, 0, w-1, h-1, 2,
						[ _borderColor1, _borderColor1 ], 1,
						verticalGradientMatrix(0, 0, w-1, h-1 ),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 3, h: h - 3, r: 2 });
					// top highlight
					drawRoundRect(
						1, 1, w - 2, 2 / 2, 2,
						[ _innerShadowColor, _innerShadowColor ], highlightAlphas,
						verticalGradientMatrix(1, 1, w - 3, 1));
					break;
				
				case "downIcon":
				case "selectedDownIcon":
					overFillColors = [
						ColorUtils.darken(_fillColor1,40),
						ColorUtils.darken(_fillColor2,40)
					];
					overFillAlphas = [1,1];
					
					// box fill
					drawRoundRect(
						0, 0, w - 1, h - 1, 2,
						overFillColors, overFillAlphas,
						verticalGradientMatrix(0, 0, w - 1, h - 1)); 
					// border
					drawRoundRect(
						0, 0, w-1, h-1, 2,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, 0, w-1, h-1 ),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 3, h: h - 3, r: 2 });
					// top highlight
					drawRoundRect(
						1, 1, w - 2, 2 / 2, 2,
						[ _innerShadowColor, _innerShadowColor ], highlightAlphas,
						verticalGradientMatrix(1, 1, w - 3, 1)); 

					// border
/*					drawRoundRect(
						0, 0, w, h, 0,
						[ themeColor, themeColorDrk1 ], 1,
						verticalGradientMatrix(0, 0, w-1, h-1),
						GradientType.LINEAR, null, 
						{ x: 1, y: 1, w: w - 2, h: h - 2, r: 0 }); 
*/
					// box fill
/*					drawRoundRect(
						1, 1, w - 2, h - 2, 0,
						overFillColors, overFillAlphas,
						verticalGradientMatrix(1, 1, w - 2, h - 2));
					// top highlight
					drawRoundRect(
						1, 1, w - 2, (h - 2) / 2, 0,
						[ 0xFFFFFF, 0xFFFFFF ], highlightAlphas,
						verticalGradientMatrix(1, 1, w - 2, (h - 2) / 2)); 
					*/
					break;
			}
			// Draw the checkmark symbol.
			if (bDrawCheck)
			{
				g.beginFill(_iconColor);
				g.moveTo(3, 5);
				g.lineTo(7, 10);
				g.lineTo(15, 0);
				g.lineTo(13, 0);
				g.lineTo(7, 8);
				g.lineTo(5, 5);
				g.lineTo(3, 5);
				g.endFill();
			}
		}
	}
}