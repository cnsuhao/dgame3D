//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIImageRect 
	{
		public var left:int;
		public var top:int;
		public var right:int;
		public var bottom:int;
		public function dUIImageRect( _left:int = 0 , _top:int = 0 , _right:int = 0 , _bottom:int = 0 ) 
		{
			left = _left;
			top = _top;
			right = _right;
			bottom = _bottom;
		}
		public function Width():int
		{
			return right - left;
		}
		public function Height():int
		{
			return bottom - top;
		}
		public function clear():void
		{
			left = 0;
			top = 0;
			right = 0;
			bottom = 0;
		}
		public function Set( _left:int = 0 , _top:int = 0 , _right:int = 0 , _bottom:int = 0 ):void
		{
			left = _left;
			top = _top;
			right = _right;
			bottom = _bottom;
		}
		public function Copy( p:dUIImageRect ):void
		{
			left = p.left;
			top = p.top;
			right = p.right;
			bottom = p.bottom;
		}
		public function Same( p:dUIImageRect ):Boolean
		{
			return left == p.left && top == p.top && right == p.right && bottom == p.bottom;
		}
	}

}