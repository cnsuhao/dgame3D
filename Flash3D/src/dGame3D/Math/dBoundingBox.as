//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D.Math 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dBoundingBox 
	{
		public var x1:Number;
		public var y1:Number;
		public var z1:Number;
		public var x2:Number;
		public var y2:Number;
		public var z2:Number;
		protected var m_vCenter:dVector3 = new dVector3();
		private static var s_vecCollectCameraTemp:Vector.<dVector4>;
		public function dBoundingBox( _x1:Number = 0.0 , _y1:Number = 0.0 , _z1:Number = 0.0 , _x2:Number = 0.0 , _y2:Number = 0.0 , _z2:Number = 0.0 ) 
		{
			x1 = _x1;
			y1 = _y1;
			z1 = _z1;
			x2 = _x2;
			y2 = _y2;
			z2 = _z2;
			
			if ( s_vecCollectCameraTemp == null )
			{
				s_vecCollectCameraTemp = new Vector.<dVector4>;
				s_vecCollectCameraTemp.length = 8;
				for ( var i:int = 0 ; i < 8 ; i ++ )
					s_vecCollectCameraTemp[i] = new dVector4();
			}
		}
		public function Copy( v:dBoundingBox ):void
		{
			x1 = v.x1;
			y1 = v.y1;
			z1 = v.z1;
			x2 = v.x2;
			y2 = v.y2;
			z2 = v.z2;
		}
		public function Merge( p:dBoundingBox ):void
		{
			if ( x1 > p.x1 ) x1 = p.x1;
			if ( y1 > p.y1 ) y1 = p.y1;
			if ( z1 > p.z1 ) z1 = p.z1;
			if ( x2 < p.x2 ) x2 = p.x2;
			if ( y2 < p.y2 ) y2 = p.y2;
			if ( z2 < p.z2 ) z2 = p.z2;
		}
		public function GetCenter():dVector3
		{
			m_vCenter.x = (x1 + x2) / 2.0;
			m_vCenter.y = (y1 + y2) / 2.0;
			m_vCenter.z = (z1 + z2) / 2.0;
			return m_vCenter;
		}
		public function isCollectionRay( vPos:dVector3 , vDir:dVector3 ):Boolean
		{
			var vCenter:dVector3 = GetCenter();
			var vExtends:dVector3 = new dVector3( x2 - vCenter.x , y2 - vCenter.y , z2 - vCenter.z );
			var mFDir:dVector3 = new dVector3( Math.abs( vDir.x ) , Math.abs( vDir.y ) , Math.abs( vDir.z ) );
			var Dx:Number = vPos.x - vCenter.x ;    if ( Math.abs( Dx ) > vExtends.x && Dx * vDir.x >= 0.0 ) return false;
			var Dy:Number = vPos.y - vCenter.y ;    if ( Math.abs( Dy ) > vExtends.y && Dy * vDir.y >= 0.0 ) return false;
			var Dz:Number = vPos.z - vCenter.z ;    if ( Math.abs( Dz ) > vExtends.z && Dz * vDir.z >= 0.0 ) return false;
			var f:Number;
			f = vDir.y * Dz - vDir.z * Dy;          if ( Math.abs( f ) > vExtends.y * mFDir.z + vExtends.z * mFDir.y ) return false;
			f = vDir.z * Dx - vDir.x * Dz;          if ( Math.abs( f ) > vExtends.x * mFDir.z + vExtends.z * mFDir.x ) return false;
			f = vDir.x * Dy - vDir.y * Dx;          if ( Math.abs( f ) > vExtends.x * mFDir.y + vExtends.y * mFDir.x ) return false;
			return true;
		}
		public function isCollectionFustumPlane( vecFustumPlane:Vector.<dVector4> ):Boolean
		{
			s_vecCollectCameraTemp[0].Set( x1 , y2 , z2 , 1.0 );
			s_vecCollectCameraTemp[1].Set( x2 , y2 , z2 , 1.0 );
			s_vecCollectCameraTemp[2].Set( x2 , y2 , z1 , 1.0 );
			s_vecCollectCameraTemp[3].Set( x1 , y2 , z1 , 1.0 );
			s_vecCollectCameraTemp[4].Set( x1 , y1 , z2 , 1.0 );
			s_vecCollectCameraTemp[5].Set( x2 , y1 , z2 , 1.0 );
			s_vecCollectCameraTemp[6].Set( x2 , y1 , z1 , 1.0 );
			s_vecCollectCameraTemp[7].Set( x1 , y1 , z1 , 1.0 );
			
			for( var i:int=0; i < 6 ; ++i )
			{
				var iInCount:int = 8;
				
				for( var j:int = 0; j < 8; ++j )
				{
					if( vecFustumPlane[i].Dot( s_vecCollectCameraTemp[j] ) < 0 )
					{
						// 点在面外
						--iInCount;
					}
				}
				
				// 如果八个点都在同一个面外
				if(iInCount == 0)
					return false;
			}
			return true;
		}
	}

}