//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Math.dBoundingBox;
	import dGame3D.Math.dColorTransform;
	import dGame3D.Math.dMatrix;
	import dGame3D.Math.dVector2;
	import dGame3D.Math.dVector3;
	import dGame3D.Math.dVector4;
	import dGame3D.Shader.dShaderBase;
	/**
	 * ...
	 * @author dym
	 */
	public class dRenderObj 
	{
		protected var m_pDevice:dDevice;
		protected var m_nObjType:int;
		public var m_vPos:dVector3 = new dVector3();
		protected var m_vSca:dVector3 = new dVector3( 1 , 1 , 1 );
		protected var m_vRot:dVector4 = new dVector4( 0 , 0 , 0 , 1 );
		protected var m_vPosRet:dVector3 = new dVector3();
		protected var m_vScaRet:dVector3 = new dVector3();
		protected var m_vRotRet:dVector4 = new dVector4();
		protected var m_matWorld:dMatrix = new dMatrix();
		protected var m_vBoundingBox:dBoundingBox = new dBoundingBox();
		protected var m_vBoundingBoxOffset:dBoundingBox = new dBoundingBox();
		protected var m_vAABB:dBoundingBox = new dBoundingBox();
		public var id:int = -1;
		protected var m_strFileName:String = new String();
		static private var s_vComputeAABB:Vector.<dVector3>;
		protected var m_fYOffset:Number = 0.0;
		protected var m_bHeroNoDelete:Boolean = false;
		protected var m_bHandleMouse:Boolean = true;
		protected var m_bShow:Boolean = true;
		public var m_pColorTransform:dColorTransform;
		public function dRenderObj( pDevice:dDevice , nType:int ) 
		{
			m_pDevice = pDevice;
			m_nObjType = nType;
			m_matWorld.Identity();
			
			if ( s_vComputeAABB == null )
			{
				s_vComputeAABB = new Vector.<dVector3>;
				s_vComputeAABB.length = 8;
				for ( var i:int = 0 ; i < 8 ; i ++ )
					s_vComputeAABB[i] = new dVector3();
			}
		}
		public function Release():void
		{
			id = -1;
		}
		public function GetFileName():String
		{
			return m_strFileName;
		}
		public function SetPos( vPos:dVector3 ):void
		{
			if ( m_vPos.x != vPos.x || m_vPos.y != vPos.y || m_vPos.z != vPos.z )
			{
				m_vPos.Copy( vPos );
				ComputeWorldMatrix();
			}
		}
		public function GetPos():dVector3
		{
			m_vPosRet.Copy( m_vPos );
			return m_vPosRet;
		}
		public function SetYOffset( fY:Number ):void
		{
			if ( m_fYOffset != fY )
			{
				m_fYOffset = fY;
				ComputeWorldMatrix();
			}
		}
		public function GetYOffset():Number
		{
			return m_fYOffset;
		}
		public function SetNoDelete( bNoDelete:Boolean ):void
		{
			m_bHeroNoDelete = bNoDelete;
		}
		public function GetNoDelete():Boolean
		{
			return m_bHeroNoDelete;
		}
		public function SetSca( vSca:dVector3 ):void
		{
			if ( m_vSca.x != vSca.x || m_vSca.y != vSca.y || m_vSca.z != vSca.z )
			{
				m_vSca.Copy( vSca );
				ComputeWorldMatrix();
			}
		}
		public function GetSca():dVector3
		{
			m_vScaRet.Copy( m_vSca );
			return m_vScaRet;
		}
		public function SetRot( vRot:dVector4 ):void
		{
			if ( m_vRot.x != vRot.x || m_vRot.y != vRot.y || m_vRot.z != vRot.z || m_vRot.w != vRot.w )
			{
				m_fLastSetDir2X = 0.0;
				m_fLastSetDir2Z = 0.0;
				m_vRot.Copy( vRot );
				ComputeWorldMatrix();
			}
		}
		public function GetRot():dVector4
		{
			m_vRotRet.Copy( m_vRot );
			return m_vRotRet;
		}
		public function SetRotY( angle:Number ):void
		{
			var mat:dMatrix = new dMatrix();
			mat.RotationY( angle );
			SetRot( mat.ToQuaternion() );
		}
		public function GetRotY():Number
		{
			var d:dVector2 = GetDir2();
			var f:Number = d.Dot( new dVector2( 0 , -1 ) );
			var ret:Number;
			if ( d.x > 0.0 ) ret = 3.14159265 - Math.acos( f ) + 3.14159265;
			else ret = Math.acos( f );
			return ret;
		}
		protected var m_fLastSetDir2X:Number = 0.0;
		protected var m_fLastSetDir2Z:Number = 0.0;
		public function SetDir2( dirX:Number , dirZ:Number ):void
		{
			if ( (dirX != 0.0 || dirZ != 0.0) && (m_fLastSetDir2X != dirX || m_fLastSetDir2Z != dirZ) )
			{
				var fRotAngle:Number = 0.0;
				var v3:dVector3 = new dVector3( dirX , 0.0 , dirZ );
				v3.Normalize();
				if( Math.abs(v3.x) < 0.001 )
				{
					if( v3.z > 0.0 )
						fRotAngle = 3.14159265;
					else
						fRotAngle = 0.0;
				}
				else
				{
					fRotAngle = Math.acos( v3.Dot( new dVector3( 0 , 0 , -1 ) ) );
					if( dirX < 0 )fRotAngle = -fRotAngle;
				}
				SetRotY( -fRotAngle );
				m_fLastSetDir2X = dirX;
				m_fLastSetDir2Z = dirZ;
			}
		}
		public function GetDir2():dVector2
		{
			var v3:dVector3 = new dVector3( 0 , 0 , -1 );
			var m:dMatrix = new dMatrix();
			m.FromQuaternion( m_vRot );
			v3.Transform( m );
			return new dVector2( v3.x , v3.z );
		}
		public function isInCamera():Boolean
		{
			return GetAABB().isCollectionFustumPlane( m_pDevice.GetCamera().GetFustumPlane() );
		}
		public function SetHandleMouse( bHandle:Boolean ):void
		{
			if ( m_bHandleMouse != bHandle )
			{
				m_bHandleMouse = bHandle;
				UpdateToAS3C();
			}
		}
		public function isHandleMouse():Boolean
		{
			return m_bHandleMouse;
		}
		public function CheckCollectionRay( vPos:dVector3 , vDir:dVector3 , vPosOut:dVector3 ):Boolean
		{
			if ( !m_bHandleMouse ) return false;
			if ( GetAABB().isCollectionRay( vPos , vDir ) )
			{
				if( vPosOut ) vPosOut.Copy( GetAABB().GetCenter() );
				return true;
			}
			return false;
		}
		public function OnFrameMove():void
		{
		}
		public function Render( shader:dShaderBase ):int
		{
			return 0;
		}
		public function LoadFromFile( strFileName:String ):void
		{
			m_strFileName = strFileName;
		}
		public function GetResourceList( push:Vector.<String> ):void
		{
			if( m_strFileName.length )
				push.push( m_strFileName );
		}
		public function GetWorldMatrix():dMatrix
		{
			return m_matWorld;
		}
		protected function ComputeWorldMatrix():void
		{
			var mTrans:dMatrix = new dMatrix();
			var mSca:dMatrix = new dMatrix();
			var mRot:dMatrix = new dMatrix();
			if( GetObjType() != dGame3DSystem.RENDEROBJ_TYPE_OCEAN )
				mTrans.Translation( m_vPos.x , m_vPos.y + m_fYOffset , m_vPos.z );
			else mTrans.Identity();
			mSca.Scaling( m_vSca.x , m_vSca.y , m_vSca.z );
			mRot.FromQuaternion( m_vRot );
			m_matWorld = mSca.Mul( mRot ).Mul( mTrans );
			
			// compute aabb
			s_vComputeAABB[0].Set( m_vBoundingBox.x1 , m_vBoundingBox.y1 , m_vBoundingBox.z1 );
			s_vComputeAABB[1].Set( m_vBoundingBox.x2 , m_vBoundingBox.y1 , m_vBoundingBox.z1 );
			s_vComputeAABB[2].Set( m_vBoundingBox.x1 , m_vBoundingBox.y1 , m_vBoundingBox.z2 );
			s_vComputeAABB[3].Set( m_vBoundingBox.x2 , m_vBoundingBox.y1 , m_vBoundingBox.z2 );
			s_vComputeAABB[4].Set( m_vBoundingBox.x1 , m_vBoundingBox.y2 , m_vBoundingBox.z1 );
			s_vComputeAABB[5].Set( m_vBoundingBox.x2 , m_vBoundingBox.y2 , m_vBoundingBox.z1 );
			s_vComputeAABB[6].Set( m_vBoundingBox.x1 , m_vBoundingBox.y2 , m_vBoundingBox.z2 );
			s_vComputeAABB[7].Set( m_vBoundingBox.x2 , m_vBoundingBox.y2 , m_vBoundingBox.z2 );
			for ( var i:int = 0 ; i < 8 ; i ++ )
				s_vComputeAABB[i].Transform( m_matWorld );
			for ( i = 0 ; i < 8 ; i ++ )
			{
				if ( i == 0 || m_vAABB.x1 > s_vComputeAABB[i].x ) m_vAABB.x1 = s_vComputeAABB[i].x;
				if ( i == 0 || m_vAABB.y1 > s_vComputeAABB[i].y ) m_vAABB.y1 = s_vComputeAABB[i].y;
				if ( i == 0 || m_vAABB.z1 > s_vComputeAABB[i].z ) m_vAABB.z1 = s_vComputeAABB[i].z;
				if ( i == 0 || m_vAABB.x2 < s_vComputeAABB[i].x ) m_vAABB.x2 = s_vComputeAABB[i].x;
				if ( i == 0 || m_vAABB.y2 < s_vComputeAABB[i].y ) m_vAABB.y2 = s_vComputeAABB[i].y;
				if ( i == 0 || m_vAABB.z2 < s_vComputeAABB[i].z ) m_vAABB.z2 = s_vComputeAABB[i].z;
			}
			UpdateToAS3C();
		}
		protected function SetBoundingBox( vBox:dBoundingBox ):void
		{
			m_vBoundingBox = vBox;
			ComputeWorldMatrix();
		}
		public function GetBoundingBox():dBoundingBox
		{
			return m_vBoundingBox;
		}
		public function GetAABB():dBoundingBox
		{
			return m_vAABB;
		}
		public function UpdateToAS3C():void
		{
			//if( id != -1 )m_pDevice.AS3C_CreateObjAABB( id , this );
		}
		public function SetAABB( aabb:dBoundingBox ):void
		{
			m_vAABB = aabb;
			UpdateToAS3C();
		}
		public function isAlpha():Boolean
		{
			return false;
		}
		public function GetObjType():int
		{
			return m_nObjType;
		}
		public function SetShow( bShow:Boolean ):void
		{
			if ( m_bShow != bShow )
			{
				m_bShow = bShow;
				UpdateToAS3C();
			}
		}
		public function isShow():Boolean
		{
			return m_bShow;
		}
		static public function CheckCollectionMeshIntersect( pVBX:dVertexBuffer , pVBY:dVertexBuffer , pVBZ:dVertexBuffer , vecIndex:Vector.<uint> ,
			vPos:dVector3 , vDir:dVector3 , vPosOut:dVector3 , matWorld:dMatrix , bCulling:Boolean = true ):Boolean
		{
			var bHit:Boolean = false;
			var fCurDistance:Number = 0.0;
			var nFaceIndex:int;
			var u:Number;
			var v:Number;
			var fDist:Number;
			var vecPosX:Vector.<Number> = pVBX.GetVertexDataX();
			var vecPosY:Vector.<Number> = pVBY.GetVertexDataY();
			var vecPosZ:Vector.<Number> = pVBZ.GetVertexDataZ();
			var v0:dVector3 = new dVector3();
			var v1:dVector3 = new dVector3();
			var v2:dVector3 = new dVector3();
			var pu:Number;
			var pv:Number;
			var edge1:dVector3 = new dVector3();
			var edge2:dVector3 = new dVector3();
			var tvec:dVector3 = new dVector3();
			var pvec:dVector3 = new dVector3();
			var qvec:dVector3 = new dVector3();
			for ( var i:int = 0 ; i < vecIndex.length / 3 ; i ++ )
			{
				v0.Set( vecPosX[ vecIndex[i * 3 + 0] ] , vecPosY[ vecIndex[i * 3 + 0] ] , vecPosZ[ vecIndex[i * 3 + 0] ] );
				v1.Set( vecPosX[ vecIndex[i * 3 + 1] ] , vecPosY[ vecIndex[i * 3 + 1] ] , vecPosZ[ vecIndex[i * 3 + 1] ] );
				v2.Set( vecPosX[ vecIndex[i * 3 + 2] ] , vecPosY[ vecIndex[i * 3 + 2] ] , vecPosZ[ vecIndex[i * 3 + 2] ] );
				if ( matWorld )
				{
					v0.Transform( matWorld );
					v1.Transform( matWorld );
					v2.Transform( matWorld );
				}
				// Find vectors for two edges sharing vert0
				dVector3.Vec3Sub( edge1 , v1 , v0 );
				dVector3.Vec3Sub( edge2 , v2 , v0 );
				// Begin calculating determinant - also used to calculate U parameter
				dVector3.Vec3Cross( pvec , vDir , edge2 );
				// If determinant is near zero, ray lies in plane of triangle
				var det:Number = edge1.Dot( pvec );
				if ( bCulling )// culling
					tvec = vPos.Sub( v0 );
				else
				{
					if ( det > 0 )
						dVector3.Vec3Sub( tvec , vPos , v0 );
					else
					{
						dVector3.Vec3Sub( tvec , v0 , vPos );
						det = -det;
					}
				}
				if ( det < 0.0001 )
					continue;
				// Calculate U parameter and test bounds
				u = tvec.Dot( pvec );
				if ( u < 0.0 || u > det )
					continue;
				// Prepare to test V parameter
				dVector3.Vec3Cross( qvec , tvec , edge1 );
				// Calculate V parameter and test bounds
				v = vDir.Dot( qvec );
				if ( v < 0.0 || u + v > det )
					continue;
				// Calculate fDist, scale parameters, ray intersects triangle
				fDist = edge2.Dot( qvec );
				if ( fDist < 0.0 )
					continue;
				var fInvDet:Number = 1.0 / det;
				fDist *= fInvDet;
				u *= fInvDet;
				v *= fInvDet;
				if ( bHit == false || fCurDistance > fDist )
				{
					fCurDistance = fDist;
					nFaceIndex = i;
					pu = u;
					pv = v;
					bHit = true;
				}
			}
			if ( bHit && vPosOut )
			{
				i = nFaceIndex;
				v0.Set( vecPosX[ vecIndex[i * 3 + 0] ] , vecPosY[ vecIndex[i * 3 + 0] ] , vecPosZ[ vecIndex[i * 3 + 0] ] );
				v1.Set( vecPosX[ vecIndex[i * 3 + 1] ] , vecPosY[ vecIndex[i * 3 + 1] ] , vecPosZ[ vecIndex[i * 3 + 1] ] );
				v2.Set( vecPosX[ vecIndex[i * 3 + 2] ] , vecPosY[ vecIndex[i * 3 + 2] ] , vecPosZ[ vecIndex[i * 3 + 2] ] );
				if ( matWorld )
				{
					v0.Transform( matWorld );
					v1.Transform( matWorld );
					v2.Transform( matWorld );
				}
				vPosOut.Copy( v0.Add( v1.Sub( v0 ).Mul( pu ) ).Add( v2.Sub( v0 ).Mul( pv ) ) );
			}
			return bHit;
		}
	}

}