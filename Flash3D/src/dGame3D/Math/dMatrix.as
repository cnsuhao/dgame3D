//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D.Math 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dMatrix 
	{
		public var _11:Number;
		public var _12:Number;
		public var _13:Number;
		public var _14:Number;
		public var _21:Number;
		public var _22:Number;
		public var _23:Number;
		public var _24:Number;
		public var _31:Number;
		public var _32:Number;
		public var _33:Number;
		public var _34:Number;
		public var _41:Number;
		public var _42:Number;
		public var _43:Number;
		public var _44:Number;
		public function dMatrix( pMatrixCopy:dMatrix = null ) 
		{
			if ( pMatrixCopy ) Copy( pMatrixCopy );
		}
		static public function IDENTITY():dMatrix
		{
			var mat:dMatrix = new dMatrix();
			mat.Identity();
			return mat;
		}
		public function Identity():void
		{
			_11 = 1.0 ; _12 = 0.0 ; _13 = 0.0 ; _14 = 0.0;
			_21 = 0.0 ; _22 = 1.0 ; _23 = 0.0 ; _24 = 0.0;
			_31 = 0.0 ; _32 = 0.0 ; _33 = 1.0 ; _34 = 0.0;
			_41 = 0.0 ; _42 = 0.0 ; _43 = 0.0 ; _44 = 1.0;
		}
		public function PerspectiveFovLH( fovy:Number , Aspect:Number , zn:Number , zf:Number ):void
		{
			var yScale:Number = 1.0 / Math.tan( fovy/2.0 );
			var xScale:Number = yScale / Aspect;
			_11 = xScale ; _12 = 0.0 ; _13 = 0.0 ; _14 = 0.0;
			_21 = 0.0 ; _22 = yScale ; _23 = 0.0 ; _24 = 0.0;
			_31 = 0.0 ; _32 = 0.0 ; _33 = zf/(zf-zn) ; _34 = 1.0;
			_41 = 0.0 ; _42 = 0.0 ; _43 = -zn*zf/(zf-zn) ; _44 = 0.0;
		}
		public function PerspectiveFovRH( fovy:Number , Aspect:Number , zn:Number , zf:Number ):void
		{
			var yScale:Number = 1.0 / Math.tan( fovy / 2.0 );
			var xScale:Number = yScale / Aspect;
			_11 = xScale ; _12 = 0.0 ; _13 = 0.0 ; _14 = 0.0;
			_21 = 0.0 ; _22 = yScale ; _23 = 0.0 ; _24 = 0.0;
			_31 = 0.0 ; _32 = 0.0 ; _33 = zf/(zn-zf) ; _34 = -1.0;
			_41 = 0.0 ; _42 = 0.0 ; _43 = zn*zf/(zn-zf) ; _44 = 0.0;
		}
		public function OrthoLH( w:Number , h:Number , zn:Number , zf:Number ):void
		{
			_11 = 2.0 / w ; _12 = 0.0 ; _13 = 0.0 ; _14 = 0.0;
			_21 = 0.0 ; _22 = 2.0 / h ; _23 = 0.0 ; _24 = 0.0;
			_31 = 0.0 ; _32 = 0.0 ; _33 = 1.0 / (zf - zn) ; _34 = 0.0;
			_41 = 0.0 ; _42 = 0.0 ; _43 = zn / (zn - zf) ; _44 = 1.0 ;
		}
		public function OrthoRH( w:Number , h:Number , zn:Number , zf:Number ):void
		{
			_11 = 2.0 / w ; _12 = 0.0 ; _13 = 0.0 ; _14 = 0.0;
			_21 = 0.0 ; _22 = 2.0 / h ; _23 = 0.0 ; _24 = 0.0;
			_31 = 0.0 ; _32 = 0.0 ; _33 = 1.0 / (zn - zf) ; _34 = 0.0;
			_41 = 0.0 ; _42 = 0.0 ; _43 = zn / (zn - zf) ; _44 = 1.0 ;
		}
		public function MatrixLookAtLH( vEye:dVector3 , vLookat:dVector3 , vUp:dVector3 ):void
		{
			var zaxis:dVector3 = vLookat.Sub( vEye );
			zaxis.Normalize();
			var xaxis:dVector3 = vUp.Cross( zaxis );
			xaxis.Normalize();
			var yaxis:dVector3 = zaxis.Cross( xaxis );
			_11 = xaxis.x ; _12 = yaxis.x ; _13 = zaxis.x ; _14 = 0.0;
			_21 = xaxis.y ; _22 = yaxis.y ; _23 = zaxis.y ; _24 = 0.0;
			_31 = xaxis.z ; _32 = yaxis.z ; _33 = zaxis.z ; _34 = 0.0;
			_41 = -xaxis.Dot(vEye) ; _42 = -yaxis.Dot(vEye) ; _43 = -zaxis.Dot(vEye) ; _44 = 1.0;
		}
		public function MatrixLookAtRH( vEye:dVector3 , vLookat:dVector3 , vUp:dVector3 ):void
		{
			var zaxis:dVector3 = vEye.Sub( vLookat );
			zaxis.Normalize();
			var xaxis:dVector3 = vUp.Cross( zaxis );
			xaxis.Normalize();
			var yaxis:dVector3 = zaxis.Cross( xaxis );
			_11 = xaxis.x ; _12 = yaxis.x ; _13 = zaxis.x ; _14 = 0.0;
			_21 = xaxis.y ; _22 = yaxis.y ; _23 = zaxis.y ; _24 = 0.0;
			_31 = xaxis.z ; _32 = yaxis.z ; _33 = zaxis.z ; _34 = 0.0;
			_41 = -xaxis.Dot(vEye) ; _42 = -yaxis.Dot(vEye) ; _43 = -zaxis.Dot(vEye) ; _44 = 1.0;
		}
		public function Mul( b:dMatrix ):dMatrix
		{
			var a:dMatrix = this;
			var ret:dMatrix = new dMatrix();
			ret._11 = a._11*b._11 + a._12*b._21 + a._13*b._31 + a._14*b._41;
			ret._12 = a._11*b._12 + a._12*b._22 + a._13*b._32 + a._14*b._42;
			ret._13 = a._11*b._13 + a._12*b._23 + a._13*b._33 + a._14*b._43;
			ret._14 = a._11*b._14 + a._12*b._24 + a._13*b._34 + a._14*b._44;

			ret._21 = a._21*b._11 + a._22*b._21 + a._23*b._31 + a._24*b._41;
			ret._22 = a._21*b._12 + a._22*b._22 + a._23*b._32 + a._24*b._42;
			ret._23 = a._21*b._13 + a._22*b._23 + a._23*b._33 + a._24*b._43;
			ret._24 = a._21*b._14 + a._22*b._24 + a._23*b._34 + a._24*b._44;

			ret._31 = a._31*b._11 + a._32*b._21 + a._33*b._31 + a._34*b._41;
			ret._32 = a._31*b._12 + a._32*b._22 + a._33*b._32 + a._34*b._42;
			ret._33 = a._31*b._13 + a._32*b._23 + a._33*b._33 + a._34*b._43;
			ret._34 = a._31*b._14 + a._32*b._24 + a._33*b._34 + a._34*b._44;

			ret._41 = a._41*b._11 + a._42*b._21 + a._43*b._31 + a._44*b._41;
			ret._42 = a._41*b._12 + a._42*b._22 + a._43*b._32 + a._44*b._42;
			ret._43 = a._41*b._13 + a._42*b._23 + a._43*b._33 + a._44*b._43;
			ret._44 = a._41*b._14 + a._42*b._24 + a._43*b._34 + a._44*b._44;
			return ret;
		}
		public function Translation( x:Number , y:Number , z:Number ):void
		{
			_11 = 1.0 ; _12 = 0.0 ; _13 = 0.0 ; _14 = 0.0;
			_21 = 0.0 ; _22 = 1.0 ; _23 = 0.0 ; _24 = 0.0;
			_31 = 0.0 ; _32 = 0.0 ; _33 = 1.0 ; _34 = 0.0;
			_41 = x   ; _42 = y   ; _43 = z   ; _44 = 1.0;
		}
		public function Scaling( x:Number , y:Number , z:Number ):void
		{
			_11 = x   ; _12 = 0.0 ; _13 = 0.0 ; _14 = 0.0;
			_21 = 0.0 ; _22 = y   ; _23 = 0.0 ; _24 = 0.0;
			_31 = 0.0 ; _32 = 0.0 ; _33 = z   ; _34 = 0.0;
			_41 = 0.0 ; _42 = 0.0 ; _43 = 0.0 ; _44 = 1.0;
		}
		public function RotationX( r:Number ):void
		{
			_11 = 1.0 ; _12 = 0.0           ; _13 = 0.0           ; _14 = 0.0;
			_21 = 0.0 ; _22 = Math.cos( r ) ; _23 = Math.sin( r ) ; _24 = 0.0;
			_31 = 0.0 ; _32 =-Math.sin( r ) ; _33 = Math.cos( r ) ; _34 = 0.0;
			_41 = 0.0 ; _42 = 0.0           ; _43 = 0.0           ; _44 = 1.0;
		}
		public function RotationY( r:Number ):void
		{
			_11 = Math.cos( r ) ; _12 = 0.0 ; _13 = -Math.sin( r ) ; _14 = 0.0;
			_21 = 0.0           ; _22 = 1.0 ; _23 = 0.0            ; _24 = 0.0;
			_31 = Math.sin( r ) ; _32 = 0.0 ; _33 =  Math.cos( r ) ; _34 = 0.0;
			_41 = 0.0           ; _42 = 0.0 ; _43 = 0.0            ; _44 = 1.0;
		}
		public function RotationZ( r:Number ):void
		{
			_11 =  Math.cos( r ) ; _12 = Math.sin( r ) ; _13 = 0.0 ; _14 = 0.0;
			_21 = -Math.sin( r ) ; _22 = Math.cos( r ) ; _23 = 0.0 ; _24 = 0.0;
			_31 = 0.0            ; _32 = 0.0           ; _33 = 1.0 ; _34 = 0.0;
			_41 = 0.0            ; _42 = 0.0           ; _43 = 0.0 ; _44 = 1.0;
		}
		public function RotationAxis( r:Number , _axis:dVector3 ):void
		{
			/*if ( r == 0.0 ) r = 3.14159265;
			// 求单位向量，之后使得len(axis)=sin(r)
			var n:dVector3 = new dVector3( axis.x , axis.y , axis.z );// 拷贝
			n.Normalize();
			var fLength:Number = Math.sin( r );
			n.MulApend( fLength );// 使得N的长度为fLength
			var d:Number = Math.cos( r ); // 点积1*1*cos(r)
			var t:Number = ( 1.0 - d ) / ( fLength * fLength );
			var a:Number = n.x;
			var b:Number = n.y;
			var c:Number = n.z;
			_11 = a * t * a + d ; _12 = b * t * a + c ; _13 = c * t * a - b ; _14 = 0.0;
			_21 = a * t * b - c ; _22 = b * t * b + d ; _23 = c * t * b + a ; _24 = 0.0;
			_31 = a * t * c + b ; _32 = b * t * c - a ; _33 = c * t * c + d ; _34 = 0.0;
			_41 = 0.0           ; _42 = 0.0           ; _43 = 0.0           ; _44 = 1.0;*/
			var axis:dVector3 = new dVector3( _axis.x , _axis.y , _axis.z );
			axis.Normalize();
			var fCos:Number = Math.cos(-r);
			var fSin:Number = Math.sin(-r);
			var fOneMinusCos:Number = 1.0 - fCos;
			var fX2:Number = axis.x * axis.x;
			var fY2:Number = axis.y * axis.y;
			var fZ2:Number = axis.z * axis.z;
			var fXYM:Number = axis.x * axis.y * fOneMinusCos;
			var fXZM:Number = axis.x * axis.z * fOneMinusCos;
			var fYZM:Number = axis.y * axis.z * fOneMinusCos;
			var fXSin:Number = axis.x * fSin;
			var fYSin:Number = axis.y * fSin;
			var fZSin:Number = axis.z * fSin;
            _11 = fX2 * fOneMinusCos + fCos;
			_12 = fXYM - fZSin;
			_13 = fXZM + fYSin;
			_21 = fXYM + fZSin;
			_22 = fY2 * fOneMinusCos + fCos;
			_23 = fYZM - fXSin;
			_31 = fXZM - fYSin;
			_32 = fYZM + fXSin;
			_33 = fZ2 * fOneMinusCos + fCos;
			_14 = 0.0;
			_24 = 0.0;
			_34 = 0.0;
			_41 = 0.0;
			_42 = 0.0;
			_43 = 0.0;
			_44 = 1.0;
		}
		public function Decompose( pTransOut:dVector3 , pScaOut:dVector3 , pRotOut:dVector4 ):void
		{
			pTransOut.x = _41; pTransOut.y = _42; pTransOut.z = _43;
			pScaOut.x = Math.sqrt( _11*_11 + _12*_12 + _13*_13 );
			pScaOut.y = Math.sqrt( _21*_21 + _22*_22 + _23*_23 );
			pScaOut.z = Math.sqrt( _31*_31 + _32*_32 + _33*_33 );
			var mat3x3:dMatrix = new dMatrix();
			mat3x3._11 = _11; mat3x3._12 = _12; mat3x3._13 = _13;
			mat3x3._21 = _21; mat3x3._22 = _22; mat3x3._23 = _23;
			mat3x3._31 = _31; mat3x3._32 = _32; mat3x3._33 = _33;
			if( pScaOut.x != 0.0 )
			{
				mat3x3._11 /= pScaOut.x;
				mat3x3._12 /= pScaOut.x;
				mat3x3._13 /= pScaOut.x;
			}
			if( pScaOut.y != 0.0 )
			{
				mat3x3._21 /= pScaOut.y;
				mat3x3._22 /= pScaOut.y;
				mat3x3._23 /= pScaOut.y;
			}
			if( pScaOut.z != 0.0 )
			{
				mat3x3._31 /= pScaOut.z;
				mat3x3._32 /= pScaOut.z;
				mat3x3._33 /= pScaOut.z;
			}
			var v:dVector4 = mat3x3.ToQuaternion();
			pRotOut.x = v.x;
			pRotOut.y = v.y;
			pRotOut.z = v.z;
			pRotOut.w = v.w;
		}
		public function FromQuaternion( q:dVector4 ):void
		{
			var xx:Number;
			var yy:Number;
			var zz:Number;
			var xy:Number;
			var wz:Number;
			var xz:Number;
			var wy:Number;
			var yz:Number;
			var wx:Number;
			xx = q.x*q.x;
			yy = q.y*q.y;
			zz = q.z*q.z;
			_11 = (1.0 - 2.0*(yy + zz));
			_22 = (1.0 - 2.0*(zz + xx));
			_33 = (1.0 - 2.0*(xx + yy));
			xy = q.x*q.y;
			wz = q.w*q.z;
			_21 = 2.0*(xy - wz);
			_12 = 2.0*(xy + wz);
			xz = q.x*q.z;
			wy = q.w*q.y;
			_31 = 2.0*(xz + wy);
			_13 = 2.0*(xz - wy);
			yz = q.y*q.z;
			wx = q.w*q.x;
			_32 = 2.0*(yz - wx);
			_23 = 2.0*(yz + wx);

			_41 = 0.0;
			_42 = 0.0;
			_43 = 0.0;
			_44 = 1.0;
			_14 = 0.0;
			_24 = 0.0;
			_34 = 0.0;
		}
		public function ToQuaternion():dVector4
		{
			var q:dVector4 = new dVector4();
			var tr:Number;
			var s:Number;
			tr = _11 + _22 + _33;
			if (tr >= 0)
			{
				q.w = (Math.sqrt(tr + 1.0)*0.5);
				s = 0.25/q.w;
				q.x = (_23-_32)*s;
				q.y = (_31-_13)*s;
				q.z = (_12-_21)*s;
				return q;
			}
			else
			{
				if( _11 > _22 && _11 > _33 )
				{
					q.x = (Math.sqrt(_11 - (_22 + _33) + 1.0)*0.5);
					s = 0.25/q.x;
					q.y = (_12 + _21)*s;
					q.z = (_13 + _31)*s;
					q.w = (_32 - _23)*s;
				}
				else if( _22 > _11 && _22 > _33 )
				{
					q.y = (Math.sqrt(_22 - (_33 + _11) + 1.0)*0.5);
					s = 0.25/q.y;
					q.z = (_23 + _32)*s;
					q.x = (_21 + _12)*s;
					q.w = (_13 - _31)*s;
				}
				else
				{
					q.z = (Math.sqrt(_33 - (_11 + _22) + 1.0)*0.5);
					s = 0.25/q.z;
					q.x = (_31 + _13)*s;
					q.y = (_32 + _23)*s;
					q.w = (_21 - _12)*s;
				}
			}
			q.w = -q.w;
			if( q.x < 0.0 && q.y < 0.0 && q.z < 0.0 )
			{
				q.x = -q.x;
				q.y = -q.y;
				q.z = -q.z;
				q.w = -q.w;
			}
			return q;
		}
		public function Determinant():Number
		{
			var a:Number = _22 * (_33 * _44 - _43 * _34) - _23 * (_32 * _44 - _34 * _42) + _24 * (_32 * _43 - _33 * _42);
			var b:Number = _21 * (_33 * _44 - _34 * _43) - _23 * (_31 * _44 - _34 * _41) + _24 * (_31 * _43 - _33 * _41);
			var c:Number = _21 * (_32 * _44 - _34 * _42) - _22 * (_31 * _44 - _34 * _41) + _24 * (_31 * _42 - _32 * _41);
			var d:Number = _21 * (_32 * _43 - _33 * _42) - _22 * (_31 * _43 - _33 * _41) + _23 * (_31 * _42 - _32 * _41);
			return _11 * a - _12 * b + _13 * c - _14 * d;	
		}
		public function Inverse():void
		{
			var d:Number = Determinant();
			if (d == 0.0) d = 1.0;
			d = 1.0 / d;
			var m:dMatrix = new dMatrix();
			m._11 =  (_22 * (_33 * _44 - _43 * _34) - _23 * (_32 * _44 - _34 * _42) + _24 * (_32 * _43 - _33 * _42)) * d;
			m._21 = -(_21 * (_33 * _44 - _34 * _43) - _23 * (_31 * _44 - _34 * _41) + _24 * (_31 * _43 - _33 * _41)) * d;
			m._31 =  (_21 * (_32 * _44 - _34 * _42) - _22 * (_31 * _44 - _34 * _41) + _24 * (_31 * _42 - _32 * _41)) * d;
			m._41 = -(_21 * (_32 * _43 - _33 * _42) - _22 * (_31 * _43 - _33 * _41) + _23 * (_31 * _42 - _32 * _41)) * d;

			m._12 = -(_12 * (_33 * _44 - _43 * _34) - _32 * (_13 * _44 - _43 * _14) + _42 * (_13 * _34 - _33 * _14)) * d;
			m._22 =  (_11 * (_33 * _44 - _43 * _34) - _31 * (_13 * _44 - _43 * _14) + _41 * (_13 * _34 - _33 * _14)) * d;
			m._32 = -(_11 * (_32 * _44 - _42 * _34) - _31 * (_12 * _44 - _42 * _14) + _41 * (_12 * _34 - _32 * _14)) * d;
			m._42 =  (_11 * (_32 * _43 - _42 * _33) - _31 * (_12 * _43 - _42 * _13) + _41 * (_12 * _33 - _32 * _13)) * d;

			m._13 =  (_12 * (_23 * _44 - _43 * _24) - _22 * (_13 * _44 - _43 * _14) + _42 * (_13 * _24 - _23 * _14)) * d;
			m._23 = -(_11 * (_23 * _44 - _43 * _24) - _21 * (_13 * _44 - _43 * _14) + _41 * (_13 * _24 - _23 * _14)) * d;
			m._33 =  (_11 * (_22 * _44 - _42 * _24) - _21 * (_12 * _44 - _42 * _14) + _41 * (_12 * _24 - _22 * _14)) * d;
			m._43 = -(_11 * (_22 * _43 - _42 * _23) - _21 * (_12 * _43 - _42 * _13) + _41 * (_12 * _23 - _22 * _13)) * d;

			m._14 = -(_12 * (_23 * _34 - _33 * _24) - _22 * (_13 * _34 - _33 * _14) + _32 * (_13 * _24 - _23 * _14)) * d;
			m._24 =  (_11 * (_23 * _34 - _33 * _24) - _21 * (_13 * _34 - _33 * _14) + _31 * (_13 * _24 - _23 * _14)) * d;
			m._34 = -(_11 * (_22 * _34 - _32 * _24) - _21 * (_12 * _34 - _32 * _14) + _31 * (_12 * _24 - _22 * _14)) * d;
			m._44 =  (_11 * (_22 * _33 - _32 * _23) - _21 * (_12 * _33 - _32 * _13) + _31 * (_12 * _23 - _22 * _13)) * d;
			Copy( m );
		}
		public function Copy( m:dMatrix ):void
		{
			_11 = m._11 ; _12 = m._12 ; _13 = m._13 ; _14 = m._14;
			_21 = m._21 ; _22 = m._22 ; _23 = m._23 ; _24 = m._24;
			_31 = m._31 ; _32 = m._32 ; _33 = m._33 ; _34 = m._34;
			_41 = m._41 ; _42 = m._42 ; _43 = m._43 ; _44 = m._44;
		}
	}

}