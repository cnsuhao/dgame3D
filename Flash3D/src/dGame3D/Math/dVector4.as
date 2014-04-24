//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D.Math 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dVector4 
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var w:Number;
		public function dVector4( _x:Number = 0.0 , _y:Number = 0.0 , _z:Number = 0.0 , _w:Number = 0.0 ) 
		{
			x = _x;
			y = _y;
			z = _z;
			w = _w;
		}
		public function Set( _x:Number = 0.0 , _y:Number = 0.0 , _z:Number = 0.0 , _w:Number = 0.0 ):void
		{
			x = _x;
			y = _y;
			z = _z;
			w = _w;
		}
		public function Copy( p:dVector4 ):void
		{
			x = p.x;
			y = p.y;
			z = p.z;
			w = p.w;
		}
		public function Length():Number
		{
			return Math.sqrt( x * x + y * y + z * z + w * w );
		}
		public function Length3():Number
		{
			return Math.sqrt( x * x + y * y + z * z );
		}
		public function Dot( p:dVector4 ):Number
		{
			return x * p.x + y * p.y + z * p.z + w * p.w;
		}
	}

}