//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Math.dMatrix;
	import dGame3D.Math.dVector3;
	import dGame3D.Math.dVector4;
	/**
	 * ...
	 * @author dym
	 */
	public class dCamera 
	{
		private var m_vEye:dVector3 = new dVector3( 0 , 1 , 10 );
		private var m_vLookat:dVector3 = new dVector3( 0 , 0 , 0 );
		private var m_vUpVec:dVector3 = new dVector3( 0 , 1 , 0 );
		private var m_nPerspectiveType:int;
		private var m_vecFustumPlane:Vector.<dVector4> = new Vector.<dVector4>;
		private var m_matView:dMatrix = new dMatrix;
		private var m_matProj:dMatrix = new dMatrix;
		private var m_fZNearPlane:Number = 0.1;
		private var m_fZFarPlane:Number = 1000.0;
		private var m_fCurAngleH:Number = 0.0;
		private var m_fCurAngleV:Number = 0.0;
		private var m_fRotationRadio:Number = 10.0;
		private var m_fAspect:Number = 4 / 3;
		private var m_fRightHand:Number = -1.0;
		private var m_bViewChanged:Boolean;
		private var m_bFustumPlaneChanged:Boolean;
		private var m_bProjChanged:Boolean;
		private var m_fOrthoWidth:Number = 100.0;
		private var m_fOrthoHeight:Number = 100.0;
		private var m_bCollection:Boolean = false;
		private var m_pDevice:dDevice;
		private var m_fRotationRadioNearLimit:Number = 1.5;
		private var m_fRotationRadioFarLimit:Number = 20;
		public function dCamera( pDevice:dDevice ) 
		{
			m_pDevice = pDevice;
			m_vecFustumPlane.length = 6;
			for ( var i:int = 0 ; i < 6 ; i ++ )
				m_vecFustumPlane[i] = new dVector4();
		}
		public function SetAspect( f:Number ):void
		{
			m_fAspect = f;
			ProjChanged();
		}
		public function SetCameraPerspectiveType( nType:int ):void
		{
			m_nPerspectiveType = nType;
			ProjChanged();
		}
		public function GetCameraPerspectiveType():int
		{
			return m_nPerspectiveType;
		}
		private function ViewChanged():void
		{
			m_bViewChanged = true;
			m_bFustumPlaneChanged = true;
		}
		private function ProjChanged():void
		{
			m_bProjChanged = true;
			m_bFustumPlaneChanged = true;
		}
		public function GetLength():Number
		{
			return Math.sqrt( (m_vLookat.x - m_vEye.x) * (m_vLookat.x - m_vEye.x) + (m_vLookat.y - m_vEye.y) * (m_vLookat.y - m_vEye.y) + (m_vLookat.z - m_vEye.z) * (m_vLookat.z - m_vEye.z) );
		}
		public function SetEye( vEye:dVector3 ):void
		{
			if ( m_vEye.x != vEye.x || m_vEye.y != vEye.y || m_vEye.z != vEye.z )
			{
				m_vEye = vEye;
				ViewChanged();
				if ( m_bCollection )
				{
					var pScene:dScene = m_pDevice.GetScene();
					var vDir:dVector3 = GetDir();
					vDir.MulAppend( 0.1 );
					while ( 1 )
					{
						var h:Number = pScene.GetHeight( m_vEye.x , m_vEye.z ) + 0.1;
						if ( m_vEye.y < h && GetLength() > 1 )
						{
							m_vEye.AddAppend( vDir );
							continue;
						}
						break;
					}
				}
			}
		}
		private var m_vEyeRet:dVector3 = new dVector3();
		public function GetEye():dVector3
		{
			return m_vEyeRet.Copy( m_vEye );
		}
		public function SetLookat( vLookat:dVector3 ):void
		{
			if ( m_vLookat.x != vLookat.x || m_vLookat.y != vLookat.y || m_vLookat.z != vLookat.z )
			{
				m_vLookat = vLookat;
				ComputeRotation();
				ViewChanged();
			}
		}
		private var m_vLookatRet:dVector3 = new dVector3();
		public function GetLookat():dVector3
		{
			return m_vLookatRet.Copy( m_vLookat );
		}
		public function SetUpVec( vUp:dVector3 ):void
		{
			if ( m_vUpVec.x != vUp.x || m_vUpVec.y != vUp.y || m_vUpVec.z != vUp.z )
			{
				m_vUpVec = vUp;
				ViewChanged();
			}
		}
		private var m_vUpVecRet:dVector3 = new dVector3();
		public function GetUpVec():dVector3
		{
			return m_vUpVecRet.Copy( m_vUpVec );
		}
		public function GetDir():dVector3
		{
			return m_vLookat.Sub( m_vEye );
		}
		public function SetNearPlane( f:Number ):void
		{
			if ( m_fZNearPlane != f )
			{
				m_fZNearPlane = f;
				ProjChanged();
			}
		}
		public function GetNearPlane():Number
		{
			return m_fZNearPlane;
		}
		public function SetFarPlane( f:Number ):void
		{
			if ( m_fZFarPlane != f )
			{
				m_fZFarPlane = f;
				ProjChanged();
			}
		}
		public function _SysSetFarPlane( f:Number ):void
		{
			m_fZFarPlane = f;
			m_bProjChanged = true;
		}
		public function GetFarPlane():Number
		{
			return m_fZFarPlane;
		}
		public function GetFustumPlane():Vector.<dVector4>
		{
			if ( m_bFustumPlaneChanged )
			{
				m_bFustumPlaneChanged = false;
				var m:dMatrix = GetViewProj();
				m_vecFustumPlane[0].Set( m._14-m._11 , m._24-m._21 , m._34-m._31 , m._44-m._41 );// right
				m_vecFustumPlane[1].Set( m._14+m._11 , m._24+m._21 , m._34+m._31 , m._44+m._41 );// left
				m_vecFustumPlane[2].Set( m._14+m._12 , m._24+m._22 , m._34+m._32 , m._44+m._42 );// bottom
				m_vecFustumPlane[3].Set( m._14-m._12 , m._24-m._22 , m._34-m._32 , m._44-m._42 );// top
				m_vecFustumPlane[4].Set( m._14-m._13 , m._24-m._23 , m._34-m._33 , m._44-m._43 );// far
				m_vecFustumPlane[5].Set( m._14+m._13 , m._24+m._23 , m._34+m._33 , m._44+m._43 );// near
				
				for( var i:int = 0 ; i < 6 ; i++ )
				{
					var mag:Number = m_vecFustumPlane[i].Length3();
					m_vecFustumPlane[i].x = m_vecFustumPlane[i].x/mag;
					m_vecFustumPlane[i].y = m_vecFustumPlane[i].y/mag;
					m_vecFustumPlane[i].z = m_vecFustumPlane[i].z/mag;
					m_vecFustumPlane[i].w = m_vecFustumPlane[i].w/mag;
				}
			}
			return m_vecFustumPlane;
		}
		public function MousePt2Dir( mouse_x:Number , mouse_y:Number , nWindowWidth:int , nWindowHeight:int , vPickRayOrig:dVector3 , vPickRayDir:dVector3 ):void
		{
			// Get the pick ray from the mouse position
			var matProj:dMatrix = GetProj();
			// Compute the vector of the pick ray in screen space
			var v:dVector3 = new dVector3();
			v.x =  ( ( ( 2.0 * mouse_x ) / nWindowWidth  ) - 1 ) / matProj._11;
			v.y = -( ( ( 2.0 * mouse_y ) / nWindowHeight ) - 1 ) / matProj._22;
			v.z =  1.0;

			// Get the inverse view matrix
			var m:dMatrix = new dMatrix( GetView() );
			m.Inverse();

			// Transform the screen space pick ray into 3D space
			vPickRayDir.x  = v.x*m._11 + v.y*m._21 + v.z*m._31*m_fRightHand;
			vPickRayDir.y  = v.x*m._12 + v.y*m._22 + v.z*m._32*m_fRightHand;
			vPickRayDir.z  = v.x*m._13 + v.y*m._23 + v.z*m._33*m_fRightHand;
			vPickRayOrig.x = m._41;
			vPickRayOrig.y = m._42;
			vPickRayOrig.z = m._43;
		}
		public function GetView():dMatrix
		{
			if ( m_bViewChanged )
			{
				m_bViewChanged = false;
				if( m_fRightHand == -1.0 )
					m_matView.MatrixLookAtRH( m_vEye , m_vLookat , m_vUpVec );
				else
					m_matView.MatrixLookAtLH( m_vEye , m_vLookat , m_vUpVec );
			}
			return m_matView;
		}
		public function SetOrthoSize( width:Number , height:Number ):void
		{
			if ( m_fOrthoWidth != width || m_fOrthoHeight != height )
			{
				m_fOrthoWidth = width;
				m_fOrthoHeight = height;
				ProjChanged();
			}
		}
		public function GetOrthoWidth():Number
		{
			return m_fOrthoWidth;
		}
		public function GetOrthoHeight():Number
		{
			return m_fOrthoHeight;
		}
		public function GetProj():dMatrix
		{
			if ( m_bProjChanged )
			{
				m_bProjChanged = false;
				if ( m_fRightHand == -1.0 )
				{
					if( m_nPerspectiveType == 0 )
						m_matProj.PerspectiveFovRH( 3.14159265 / 4.0 , m_fAspect , m_fZNearPlane , m_fZFarPlane );
					else
						m_matProj.OrthoRH( m_fOrthoWidth , m_fOrthoHeight , m_fZNearPlane , m_fZFarPlane );
				}
				else
				{
					if( m_nPerspectiveType == 0 )
						m_matProj.PerspectiveFovLH( 3.14159265 / 4.0 , m_fAspect , m_fZNearPlane , m_fZFarPlane );
					else
						m_matProj.OrthoLH( m_fOrthoWidth , m_fOrthoHeight , m_fZNearPlane , m_fZFarPlane );
				}
			}
			return m_matProj;
		}
		public function GetViewProj():dMatrix
		{
			return GetView().Mul( GetProj() );
		}
		public function MoveForword( speed:Number ):void
		{
			var dir:dVector3 = m_vEye.Sub( m_vLookat );
			dir.Normalize();
			dir.Mul( speed );
			m_vEye.SubAppend( dir );
			m_vLookat.SubAppend( dir );
			ViewChanged();
		}
		public function MoveBack( speed:Number ):void
		{
			var dir:dVector3 = m_vEye.Sub( m_vLookat );
			dir.Normalize();
			dir.Mul( speed );
			m_vEye.AddAppend( dir );
			m_vLookat.AddAppend( dir );
			ViewChanged();
		}
		public function MoveNear( speed:Number ):void
		{
			var dir:dVector3 = m_vEye.Sub( m_vLookat );
			dir.Normalize();
			dir.Mul( speed );
			m_vEye.AddAppend( dir );
			ViewChanged();
		}
		public function MoveFar( speed:Number ):void
		{
			var dir:dVector3 = m_vEye.Sub( m_vLookat );
			dir.Normalize();
			dir.Mul( speed );
			m_vEye.SubAppend( dir );
			ViewChanged();
		}
		public function MoveLeft( speed:Number ):void
		{
			var dir:dVector3 = m_vEye.Sub( m_vLookat );
			dir.Normalize();
			var cross:dVector3 = dir.Cross( new dVector3( 0 , 1 * m_fRightHand , 0 ) );
			cross.Normalize();
			m_vEye.SubAppend( cross );
			m_vLookat.SubAppend( cross );
			ViewChanged();
		}
		public function MoveRight( speed:Number ):void
		{
			var dir:dVector3 = m_vEye.Sub( m_vLookat );
			dir.Normalize();
			var cross:dVector3 = dir.Cross( new dVector3( 0 , 1 * m_fRightHand , 0 ) );
			cross.Normalize();
			m_vEye.AddAppend( cross );
			m_vLookat.AddAppend( cross );
			ViewChanged();
		}
		public function GetRotationH():Number
		{
			return m_fCurAngleH;
		}
		public function SetRotationH( angle:Number ):void
		{
			m_fCurAngleH = angle;
			ComputeRotation();
		}
		public function GetRotationV():Number
		{
			return m_fCurAngleV;
		}
		public function SetRotationV( angle:Number ):void
		{
			var limit:Number = 3.14159 / 2 - 0.5;
			if ( angle < -limit ) angle = -limit;
			else if ( angle > limit ) angle = limit;
			m_fCurAngleV = angle;
			ComputeRotation();
		}
		public function SetRotationRadio( length:Number ):void
		{
			m_fRotationRadio = length;
			if ( m_fRotationRadio < m_fRotationRadioNearLimit ) m_fRotationRadio = m_fRotationRadioNearLimit;
			else if ( m_fRotationRadio > m_fRotationRadioFarLimit ) m_fRotationRadio = m_fRotationRadioFarLimit;
			ComputeRotation();
		}
		public function SetRotationRadioLimit( fNear:Number , fFar:Number ):void
		{
			m_fRotationRadioNearLimit = fNear;
			m_fRotationRadioFarLimit = fFar;
		}
		public function GetRotationRadio():Number
		{
			return m_fRotationRadio;
		}
		public function SetRotationLookat( angleH:Number , angleV:Number ):void
		{
			angleH *= m_fRightHand;
			var dir:dVector3 = m_vLookat.Sub( m_vEye );
			var cross:dVector3 = m_vEye.Sub( m_vLookat ).Cross( new dVector3( 0 , 1 , 0 ) );
			var m1:dMatrix = new dMatrix();
			m1.RotationY( angleH );
			dir.Transform( m1 );
			m1.RotationAxis( angleV , cross );
			dir.Transform( m1 );
			m_vLookat = dir.Add( m_vEye );
			ViewChanged();
		}
		protected function ComputeRotation():void
		{
			var eye:dVector3 = new dVector3( 0.0 , 0.0 , m_fRotationRadio );
			var m:dMatrix = new dMatrix();
			m.RotationY( m_fCurAngleH );
			var m2:dMatrix = new dMatrix();
			m2.RotationX( m_fCurAngleV );
			/*var dir:dVector3 = m_vEye.Sub( m_vLookat );
			dir.y = 0.0;
			dir.Normalize();
			var cross:dVector3 = dir.Cross( new dVector3( 0 , 1 , 0 ) );
			m2.RotationAxis( m_fCurAngleV , cross );*/
			eye.Transform( m2.Mul( m ) );
			SetEye( eye.Add( m_vLookat ) );
		}
		public function SetCollection( bColl:Boolean ):void
		{
			m_bCollection = bColl;
		}
		public function isCollection():Boolean
		{
			return m_bCollection;
		}
		public function Present():void
		{
		}
	}

}