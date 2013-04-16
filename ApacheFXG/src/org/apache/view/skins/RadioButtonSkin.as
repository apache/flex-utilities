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
	
	public class RadioButtonSkin extends Border
	{
		public function RadioButtonSkin()
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
			return 14;
		}
		override public function get measuredHeight():Number{
			return 14;
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
			var fillColors:Array = [ _fillColor1, _fillColor2 ];
			if(name == "overSkin"){
				fillColors[0] = ColorUtils.lighten(_fillColor1,20);
				fillColors[1] = ColorUtils.lighten(_fillColor2,20);
			}
			var upFillAlphas:Array;
			var overFillColors:Array;
			var overFillAlphas:Array;
			var disFillColors:Array;
			var disFillAlphas:Array;
			var r:Number = width / 2;
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
					upFillAlphas = [1,1];
					// box fill
					g.beginGradientFill(
						GradientType.LINEAR,
						fillColors, [1,1], [ 0, 0xFF ],
						verticalGradientMatrix(0, 0, w, h));
					g.drawCircle(r, r, (r - 1));
					g.endFill();
					// border
					g.beginGradientFill(
						GradientType.LINEAR, 
						[ _borderColor1, _borderColor1 ], [ 1, 1 ], [ 0, 0xFF ],
						verticalGradientMatrix(0, 0, w, h));
					g.drawCircle(r, r, r);
					g.drawCircle(r, r, r - 1);
					g.endFill();
					// top highlight
					//drawRoundRect(1, 1, w - 2, 2 / 2, 2,[ _innerShadowColor, _innerShadowColor ], highlightAlphas,verticalGradientMatrix(1, 1, w - 3, 1));
					break;
				
				case "downIcon":
				case "selectedDownIcon":
					overFillColors = [
						ColorUtils.darken(_fillColor1,40),
						ColorUtils.darken(_fillColor2,40)
					];
					overFillAlphas = [1,1];
					
					// box fill
					g.beginGradientFill(
						GradientType.LINEAR,
						overFillColors, [1,1], [ 0, 0xFF ],
						verticalGradientMatrix(0, 0, w, h));
					g.drawCircle(r, r, (r - 1));
					g.endFill();
					// border
					g.beginGradientFill(
						GradientType.LINEAR, 
						[ themeColor, themeColorDrk1 ], [ 1, 1 ], [ 0, 0xFF ],
						verticalGradientMatrix(0, 0, w, h));
					g.drawCircle(r, r, r);
					g.drawCircle(r, r, r - 1);
					g.endFill();
					// top highlight
					//drawRoundRect(1, 1, w - 2, 2 / 2, 2,[ _innerShadowColor, _innerShadowColor ], highlightAlphas,verticalGradientMatrix(1, 1, w - 3, 1));
					break;
			}
			// radio symbol
			if(bDrawCheck){
				g.beginFill(_iconColor);
				g.drawCircle(r, r, 2);
				g.endFill();
			}

		}
	}
	
}