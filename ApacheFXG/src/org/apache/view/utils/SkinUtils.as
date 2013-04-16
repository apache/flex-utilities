package org.apache.view.utils
{
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;

	public class SkinUtils
	{
		public function SkinUtils()
		{
		}

		[Bindable]public static var backgroundColor:uint;
		[Bindable]public static var darkTheme:Boolean;
		public static function setStyleDeclarations():void{
			var buttonStyle:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".button");
			var checkboxStyle:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".checkbox");
			var comboStyle:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".combobox");
			var radioStyle:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".radiobutton");
			
			if(darkTheme){
				buttonStyle.setStyle("color",0xf3f3f3);
				buttonStyle.setStyle("textSelectedColor",0xf3f3f3);
				buttonStyle.setStyle("textRollOverColor",0xf3f3f3);
				checkboxStyle.setStyle("color",0xf3f3f3);
				checkboxStyle.setStyle("textSelectedColor",0xf3f3f3);
				checkboxStyle.setStyle("textRollOverColor",0xf3f3f3);
				comboStyle.setStyle("color",0xf3f3f3);
				comboStyle.setStyle("textSelectedColor",0xf3f3f3);
				comboStyle.setStyle("textRollOverColor",0xf3f3f3);
				radioStyle.setStyle("color",0xf3f3f3);
				radioStyle.setStyle("textSelectedColor",0xf3f3f3);
				radioStyle.setStyle("textRollOverColor",0xf3f3f3);
			} else {
				buttonStyle.setStyle("color",0);
				buttonStyle.setStyle("textSelectedColor",0);
				buttonStyle.setStyle("textRollOverColor",0);
				checkboxStyle.setStyle("color",0);
				checkboxStyle.setStyle("textSelectedColor",0);
				checkboxStyle.setStyle("textRollOverColor",0);
				comboStyle.setStyle("color",0);
				comboStyle.setStyle("textSelectedColor",0);
				comboStyle.setStyle("textRollOverColor",0);
				radioStyle.setStyle("color",0);
				radioStyle.setStyle("textSelectedColor",0);
				radioStyle.setStyle("textRollOverColor",0);
			}
		}
	}
}