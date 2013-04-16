package org.apache.view.skins
{
	import org.apache.model.utils.ColorUtils;
	import org.apache.view.utils.SkinUtils;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	
	import mx.core.IButton;
	import mx.core.UIComponent;
	import mx.skins.Border;
	import mx.styles.StyleManager;
	import mx.utils.ColorUtil;
	
	/**
	 *  The skin for all the states of a Button.
	 */
	public class ComboBoxSkin extends Border
	{
		public function ComboBoxSkin()
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

		override public function get measuredWidth():Number{
			return UIComponent.DEFAULT_MEASURED_MIN_WIDTH;
		}
		override public function get measuredHeight():Number{
			return UIComponent.DEFAULT_MEASURED_MIN_HEIGHT;
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void{
			super.updateDisplayList(w, h);
			var highlightAlphas:Array = [1,1];//getStyle("highlightAlphas");
			var themeColor:uint = getStyle("themeColor");
			var emph:Boolean = false;
			if (parent is IButton)
				emph = IButton(parent).emphasized;
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
				case "upSkin":
				case "selectedUpSkin":
				case "overSkin":
				case "selectedOverSkin":
				case "disabledSkin":
				case "selectedDisabledSkin":
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
				
				case "downSkin":
				case "selectedDownSkin":
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
					break;
			}
			// Draw the triangle.
			g.beginFill(_iconColor);
			g.moveTo(w - 9, h / 2 + 2);
			g.lineTo(w - 12, h / 2 - 2);
			g.lineTo(w - 6, h / 2 - 2);
			g.lineTo(w - 9, h / 2 + 2);
			g.endFill();

		}
	}
	
}