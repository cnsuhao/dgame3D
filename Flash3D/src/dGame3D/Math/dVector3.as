//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D.Math 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dVector3 
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public function dVector3( _x:Number = 0.0 , _y:Number = 0.0 , _z:Number = 0.0 ) 
		{
			x = _x;
			y = _y;
			z = _z;
		}
		public function Set( _x:Number = 0.0 , _y:Number = 0.0 , _z:Number = 0.0 ):void
		{
			x = _x;
			y = _y;
			z = _z;
		}
		public function Copy( p:dVector3 ):dVector3
		{
			x = p.x;
			y = p.y;
			z = p.z;
			return this;
		}
		public function Length():Number
		{
			return Math.sqrt( x * x + y * y + z * z );
		}
		public function LengthOther( pOther:dVector3 ):Number
		{
			return Math.sqrt( (x - pOther.x) * (x - pOther.x) + (y - pOther.y) * (y - pOther.y) + (z - pOther.z) * (z - pOther.z) );
		}
		public function Normalize():void
		{
			var l:Number = Length();
			if ( l != 0.0 )
			{
				x /= l;
				y /= l;
				z /= l;
			}
		}
		
		public function Add( p:dVector3 ):dVector3
		{
			return new dVector3( x + p.x , y + p.y , z + p.z );
		}
		static public function Vec3Add( out:dVector3 , t:dVector3 , p:dVector3 ):void
		{
			out.x = t.x + p.x;
			out.y = t.y + p.y;
			out.z = t.z + p.z;
		}
		public function Sub( p:dVector3 ):dVector3
		{
			return new dVector3( x - p.x , y - p.y , z - p.z );
		}
		static public function Vec3Sub( out:dVector3 , t:dVector3 , p:dVector3 ):void
		{
			out.x = t.x - p.x;
			out.y = t.y - p.y;
			out.z = t.z - p.z;
		}
		public function Mul( f:Number ):dVector3
		{
			return new dVector3( x * f , y * f , z * f );
		}
		static public function Vec3Mul( out:dVector3 , t:dVector3 , f:Number ):void
		{
			out.x = t.x * f;
			out.y = t.y * f;
			out.z = t.z * f;
		}
		public function Div( f:Number ):dVector3
		{
			if ( f == 0.0 ) return new dVector3();
			return new dVector3( x / f , y / f , z / f );
		}
		static public function Vec3Div( out:dVector3 , t:dVector3 , f:Number ):void
		{
			if ( f != 0.0 )
			{
				out.x = t.x / f;
				out.y = t.y / f;
				out.z = t.z / f;
			}
			else
			{
				out.x = 0.0;
				out.y = 0.0;
				out.z = 0.0;
			}
		}
		public function AddAppend( p:dVector3 ):dVector3
		{
			x += p.x;
			y += p.y;
			z += p.z;
			return this;
		}
		public function SubAppend( p:dVector3 ):dVector3
		{
			x -= p.x;
			y -= p.y;
			z -= p.z;
			return this;
		}
		public function MulAppend( f:Number ):dVector3
		{
			x *= f;
			y *= f;
			z *= f;
			return this;
		}
		public function DivAppend( f:Number ):dVector3
		{
			if ( f == 0.0 )
			{
				x = 0.0;
				y = 0.0;
				z = 0.0;
			}
			else
			{
				x /= f;
				y /= f;
				z /= f;
			}
			return this;
		}
		public function Dot( p:dVector3 ):Number
		{
			return x * p.x + y * p.y + z * p.z;
		}
		public function Cross( p:dVector3 ):dVector3
		{
			return new dVector3( y * p.z - p.y * z , z * p.x - p.z * x , x * p.y - p.x * y );
		}
		static public function Vec3Cross( out:dVector3 , t:dVector3 , p:dVector3 ):void
		{
			out.x = t.y * p.z - p.y * t.z;
			out.y = t.z * p.x - p.z * t.x;
			out.z = t.x * p.y - p.x * t.y;
		}
		public function Transform( mat:dMatrix ):void
		{
			var _x:Number = x * mat._11 + y * mat._21 + z * mat._31 + mat._41;
			var _y:Number = x * mat._12 + y * mat._22 + z * mat._32 + mat._42;
			var _z:Number = x * mat._13 + y * mat._23 + z * mat._33 + mat._43;
			var _w:Number = x * mat._14 + y * mat._24 + z * mat._34 + mat._44;
			if ( _w != 0.0 )
			{
				x = _x / _w;
				y = _y / _w;
				z = _z / _w;
			}
			else
			{
				x = _x;
				y = _y;
				z = _z;
			}
		}
	}

}