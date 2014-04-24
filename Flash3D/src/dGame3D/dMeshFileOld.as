//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Math.dBoundingBox;
	import dGame3D.Math.dMatrix;
	import dGame3D.Shader.dShaderBase;
	import flash.events.Event;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author dym
	 */
	public class dMeshFileOld 
	{
		protected var m_pDevice:dDevice;
		protected var m_scene_data:DG3DMESH_SCENE_DATA = new DG3DMESH_SCENE_DATA;
		protected var m_subMesh:Vector.<dMeshFileObj> = new Vector.<dMeshFileObj>;
		protected var m_vecTexture:Vector.<dTexture> = new Vector.<dTexture>;
		protected var m_vecSkeleton:Vector.<dMeshFileSkeleton>;
		public function dMeshFile( pDevice:dDevice ) 
		{
			m_pDevice = pDevice;
		}
		public function Release():void
		{
			for ( var i:int = 0 ; i < m_subMesh.length ; i ++ )
				m_subMesh[i].Release();
			for ( i = 0 ; i < m_vecTexture.length ; i ++ )
				m_vecTexture[i].Release();
		}
		public function GetSkeleton():Vector.<dMeshFileSkeleton>
		{
			return m_vecSkeleton;
		}
		public function GetSkeletonInverseMatrixByName( strBoneName:String ):dMatrix
		{
			if ( m_vecSkeleton == null ) return dMatrix.IDENTITY();
			for ( var i:int = 0 ; i < m_vecSkeleton.length ; i ++ )
			{
				if ( m_vecSkeleton[i].name == strBoneName )
					return m_vecSkeleton[i].matInverse;
			}
			return dMatrix.IDENTITY();
		}
		public function LoadFromFile( strFileName:String , onLoadComplate:Function = null , bAnimate:Boolean = false ):void
		{
			var strPath:String = new String( strFileName );
			for( var i:int = strPath.length-1 ; i >= 0 ; i -- )
			{
				if( strPath.charAt( i ) == "/" || strPath.charAt( i ) == "\\" )
				{
					strPath = strPath.substring( 0 , i );
					break;
				}
			}
			m_pDevice.LoadBinFromFile( strFileName , function( data:ByteArray ):void
			{
				data.endian = "littleEndian";
				data.position = 0;
				LoadFromBin( data , strPath , bAnimate );
				if ( onLoadComplate != null ) onLoadComplate();
			} );
		}
		public function LoadFromBin( data:ByteArray , strTexturePath:String , bAnimate:Boolean = false ):void
		{
			var magic1:int = data.readByte();
			var magic2:int = data.readByte();
			var magic3:int = data.readByte();
			var magic4:int = data.readByte();
			m_scene_data.version = data.readInt();
			m_scene_data.nMeshNum = data.readInt();
			m_scene_data.nTexNum = data.readInt();
			m_scene_data.nLodLevel = data.readInt();
			m_scene_data.nTextureDataAddress = data.readInt();
			m_scene_data.center_x = data.readFloat();
			m_scene_data.center_y = data.readFloat();
			m_scene_data.center_z = data.readFloat();
			m_scene_data.aabb_x1 = data.readFloat();
			m_scene_data.aabb_y1 = data.readFloat();
			m_scene_data.aabb_z1 = data.readFloat();
			m_scene_data.aabb_x2 = data.readFloat();
			m_scene_data.aabb_y2 = data.readFloat();
			m_scene_data.aabb_z2 = data.readFloat();
			m_scene_data.boundingbox_x1 = data.readFloat();
			m_scene_data.boundingbox_y1 = data.readFloat();
			m_scene_data.boundingbox_z1 = data.readFloat();
			m_scene_data.boundingbox_x2 = data.readFloat();
			m_scene_data.boundingbox_y2 = data.readFloat();
			m_scene_data.boundingbox_z2 = data.readFloat();
			m_scene_data.radio = data.readFloat();
			for( var i:int = 0 ; i < 16 ; i ++ )
				m_scene_data.face_num[i] = data.readInt();
			for( i = 0 ; i < 16 ; i ++ )
				m_scene_data.vertex_num_normal[i] = data.readInt();
			
			m_scene_data.b_have_bone = data.readByte();
			m_scene_data.b_swap_yz = data.readByte();
			m_scene_data.b_unknow1 = data.readByte();
			m_scene_data.b_unknow2 = data.readByte();
			for( i = 0 ; i < 127 ; i ++ )
				data.readInt();
			m_scene_data.f_global_scaling_x = data.readFloat();
			m_scene_data.f_global_scaling_y = data.readFloat();
			m_scene_data.f_global_scaling_z = data.readFloat();
			for( i = 0 ; i < 125 ; i ++ )
				data.readInt();
			m_subMesh.length = m_scene_data.nMeshNum;
			for( i = 0 ; i < m_scene_data.nMeshNum ; i ++ )
			{
				m_subMesh[i] = new dMeshFileObj( data , m_pDevice , bAnimate );
			}
			if (m_scene_data.b_have_bone == 1)
			{
				var nSkeletonHeaderVer:int = 0;
				var nSkeletonNum:int = 0;
				var nSize:int = 0;
				nSkeletonHeaderVer = data.readInt();
				nSkeletonNum = data.readInt();
				nSize = data.readInt();
				if ( nSkeletonNum > 0 )
				{
					m_vecSkeleton = new Vector.<dMeshFileSkeleton>;
					m_vecSkeleton.length = nSkeletonNum;
					for ( i = 0 ; i < nSkeletonNum ; i ++ )
						m_vecSkeleton[i] = new dMeshFileSkeleton();
					for ( i = 0 ; i < nSkeletonNum ; i ++ )
					{
						m_vecSkeleton[i].name = data.readMultiByte( 256 * 2 , "unicode" );
						m_vecSkeleton[i].matWorldZeroTime = readMatrix( data );
						m_vecSkeleton[i].matLocalZeroTime = readMatrix( data );
						m_vecSkeleton[i].matInverse = new dMatrix( m_vecSkeleton[i].matWorldZeroTime );
						m_vecSkeleton[i].matInverse.Inverse();
						var nNodeID:int = data.readInt();
						m_vecSkeleton[i].m_nParentId = data.readInt();
						var nChildNum:int = data.readInt();
						m_vecSkeleton[i].m_vecChildId.length = nChildNum;
						for ( var j:int = 0 ; j < nChildNum ; j ++ )
						{
							var t_childno:int = data.readInt();
							m_vecSkeleton[i].m_vecChildId[j] = t_childno;
							m_vecSkeleton[t_childno].m_nParentId = i;
						}
					}
				}
			}
			m_vecTexture.length = m_scene_data.nTexNum;
			for( i = 0 ; i < m_scene_data.nTexNum ; i ++ )
			{
				var strTextureFileName:String = data.readMultiByte( 256 * 2 , "unicode" );
				var nTextureSize:int = data.readInt();
				var bReadTextureFromFile:int = data.readByte();
				data.position = data.position + (31 * 4 + 3);
				if ( nTextureSize > 0 )
				{
					var data2:ByteArray = new ByteArray();
					data.readBytes( data2 , 0, nTextureSize );
					m_vecTexture[i] = new dTexture( m_pDevice );
					
					if (bReadTextureFromFile == 1)
						m_vecTexture[i].LoadFromBin( data2 , null , strTexturePath + "/" + strTextureFileName );
					else
						m_vecTexture[i].LoadFromBin( data2 );
				}
			}
		}
		private function readMatrix( data:ByteArray ):dMatrix
		{
			var m:dMatrix = new dMatrix();
			m._11 = data.readFloat();
			m._12 = data.readFloat();
			m._13 = data.readFloat();
			m._14 = data.readFloat();
			m._21 = data.readFloat();
			m._22 = data.readFloat();
			m._23 = data.readFloat();
			m._24 = data.readFloat();
			m._31 = data.readFloat();
			m._32 = data.readFloat();
			m._33 = data.readFloat();
			m._34 = data.readFloat();
			m._41 = data.readFloat();
			m._42 = data.readFloat();
			m._43 = data.readFloat();
			m._44 = data.readFloat();
			return m;
		}
		public function Render( vecSkeletonMatrixResult:Vector.<dMatrix> = null , shader:dShaderBase = null ):int
		{
			var ret:int;
			for ( var i:int = 0 ; i < m_subMesh.length ; i ++ )
			{
				ret += m_subMesh[i].Render( m_vecTexture , vecSkeletonMatrixResult , shader );
			}
			return ret;
		}
		public function GetBoundingBox():dBoundingBox
		{
			return new dBoundingBox( m_scene_data.boundingbox_x1 , m_scene_data.boundingbox_y1 , m_scene_data.boundingbox_z1 ,
				m_scene_data.boundingbox_x2 , m_scene_data.boundingbox_y2 , m_scene_data.boundingbox_z2 );
		}
		public function GetSubMeshNum():int
		{
			return m_subMesh.length;
		}
		public function GetSubMeshVertexBuffer( idx:int ):dVertexBuffer
		{
			return m_subMesh[idx].GetVertexBuffer();
		}
		public function GetSubMeshIndexBuffer( idx:int ):dIndexBuffer
		{
			return m_subMesh[idx].GetIndexBuffer();
		}
	}

}
class DG3DMESH_SCENE_DATA
{
	public var version:int;
	public var nMeshNum:int;
	public var nTexNum:int;
	public var nLodLevel:int;
	public var nTextureDataAddress:int;
	public var center_x:Number;
	public var center_y:Number;
	public var center_z:Number;
	public var aabb_x1:Number;
	public var aabb_y1:Number;
	public var aabb_z1:Number;
	public var aabb_x2:Number;
	public var aabb_y2:Number;
	public var aabb_z2:Number;
	public var boundingbox_x1:Number;
	public var boundingbox_y1:Number;
	public var boundingbox_z1:Number;
	public var boundingbox_x2:Number;
	public var boundingbox_y2:Number;
	public var boundingbox_z2:Number;
	public var radio:Number;
	public var face_num:Array;
	public var vertex_num_normal:Array;
	public var b_have_bone:int;
	public var b_swap_yz:int;
	public var b_unknow1:int;
	public var b_unknow2:int;
	public var f_global_scaling_x:Number;
	public var f_global_scaling_y:Number;
	public var f_global_scaling_z:Number;

	public function DG3DMESH_SCENE_DATA()
	{
		this.face_num = new Array(16);
		this.vertex_num_normal = new Array(16);
		return;
	}// end function

}