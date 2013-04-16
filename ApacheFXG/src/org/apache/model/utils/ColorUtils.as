package org.apache.model.utils
{
	public class ColorUtils
	{
		public function ColorUtils()
		{
		}
		public static function lighten(color:uint,factor:Number):uint{
			var r:uint = color>>>16;
			var g:uint = (color>>>8) & 0xFF;
			var b:uint = color & 0xFF;
			r = r + factor > 0xFF ? 0xFF : r + factor;
			g = g + factor > 0xFF ? 0xFF : g + factor;
			b = b + factor > 0xFF ? 0xFF : b + factor;
			var retVal:uint =  (r << 16) | (g << 8) | b;
			return retVal;
		}
		public static function darken(color:uint,factor:Number):uint{
			var r:uint = color>>>16;
			var g:uint = (color>>>8) & 0xFF;
			var b:uint = color & 0xFF;
			r = r - factor < 0 ? 0 : r - factor;
			g = g - factor < 0 ? 0 : g - factor;
			b = b - factor < 0 ? 0 : b - factor;
			var retVal:uint =  (r << 16) | (g << 8) | b;//r <<  g <<  b;
			return retVal;
		}
	}
}