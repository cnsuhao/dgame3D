//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIColorTransform 
	{
		public var nColorBrightness:int;
		public var nColorContrast:int;
		public var nColorSaturation:int;
		public var nColorHue:int
		public function dUIColorTransform( _colorBrightness:int , _colorContrast:int , _colorSaturation:int , _colorHue:int ):void
		{
			if ( _colorBrightness < -100 ) _colorBrightness = -100;
			else if ( _colorBrightness > 100 ) _colorBrightness = 100;
			if ( _colorContrast < -100 ) _colorContrast = -100;
			else if ( _colorContrast > 100 ) _colorContrast = 100;
			if ( _colorSaturation < -100 ) _colorSaturation = -100;
			else if ( _colorBrightness > 100 ) _colorBrightness = 100;
			if ( _colorHue < -180 ) _colorHue = -180;
			else if ( _colorHue > 180 ) _colorHue = 180;
			nColorBrightness = _colorBrightness;
			nColorContrast = _colorContrast;
			nColorSaturation = _colorSaturation;
			nColorHue = _colorHue;
		}
		public function fromString( str:String ):void
		{
			var arr:Array = str.split( str , "/" );
			nColorBrightness = arr[0];
			nColorContrast = arr[1];
			nColorSaturation = arr[2];
			nColorHue = arr[3];
		}
		public function toString():String
		{
			return nColorBrightness + "/" + nColorContrast + "/" + nColorSaturation + "/" + nColorHue;
		}
		public function isZero():Boolean
		{
			return nColorBrightness == 0 && nColorContrast == 0 && nColorSaturation == 0 && nColorHue == 0;
		}
	}

}