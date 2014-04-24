//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D.Math 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dVector2 
	{
		public var x:Number;
		public var y:Number;
		public function dVector2( _x:Number = 0.0 , _y:Number = 0.0 ) 
		{
			x = _x;
			y = _y;
		}
		public function Length():Number
		{
			return Math.sqrt( x * x + y * y );
		}
		public function Set( _x:Number = 0.0 , _y:Number = 0.0 ):void
		{
			x = _x;
			y = _y;
		}
		public function Copy( p:dVector2 ):void
		{
			x = p.x;
			y = p.y;
		}
		public function ToVector3():dVector3
		{
			return new dVector3( x , 0.0 , y );
		}
		public function Normalize():void
		{
			var l:Number = Length();
			if ( l != 0.0 )
			{
				x /= l;
				y /= l;
			}
		}
		public function Dot( p:dVector2 ):Number
		{
			return x * p.x + y * p.y;
		}
	}

}