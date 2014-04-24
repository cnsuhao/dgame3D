//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dTextureRect 
	{
		public var left:Number;
		public var top:Number;
		public var right:Number;
		public var bottom:Number;
		public function dTextureRect( _left:Number = 0.0 , _top:Number = 0.0 , _right:Number = 0.0 , _bottom:Number = 0.0 ):void
		{
			left = _left;
			top = _top;
			right = _right;
			bottom = _bottom;
		}
		public function GetWidth():Number
		{
			return right - left;
		}
		public function GetHeight():Number
		{
			return bottom - top;
		}
	}

}