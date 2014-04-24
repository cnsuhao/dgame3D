//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dcom.dByteArray;
	import dcom.dInterface;
	import dcom.dStringUtils;
	import dcom.dTimer;
	import dGame3D.Math.dBoundingBox;
	import dGame3D.Math.dColorTransform;
	import dGame3D.Math.dMatrix;
	import dGame3D.Shader.dShaderBase;
	import dUI._dInterface;
	import flash.events.Event;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author dym
	 */
	public class dMeshFile 
	{
		protected var m_pDevice:dDevice;
		protected var m_vecSubMesh:Vector.<dMeshFileObj> = new Vector.<dMeshFileObj>;
		protected var m_vecTexture:Vector.<dTexture> = new Vector.<dTexture>;
		protected var m_vecSkeleton:Vector.<dMeshFileSkeleton>;
		protected var m_vBoundingBox:dBoundingBox = new dBoundingBox();
		protected var m_pVertexBuffer:dVertexBuffer;
		public function dMeshFile( pDevice:dDevice ) 
		{
			m_pDevice = pDevice;
		}
		public function Release():void
		{
			for ( var i:int = 0 ; i < m_vecSubMesh.length ; i ++ )
				m_vecSubMesh[i].Release();
			for ( i = 0 ; i < m_vecTexture.length ; i ++ )
				m_vecTexture[i].Release();
			if ( m_pVertexBuffer ) m_pVertexBuffer.Release();
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
		public function LoadFromFile( strFileName:String , onLoadComplate:Function = null , bAnimate:Boolean = false , pColorTransform:dColorTransform = null ):void
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
				LoadFromBin( _dInterface.iBridge_TransByteArray( data ) , strPath , bAnimate , pColorTransform , onLoadComplate );
			} , null );
		}
		public function LoadFromBin( data:dByteArray , strTexturePath:String , bAnimate:Boolean = false , pColorTransform:dColorTransform = null , onLoadComplete:Function = null ):void
		{
			var chunk:int = data.ReadInt();
			var version:int = data.ReadInt();
			var endian:int = dByteArray.LITTLE_ENDIAN;
			if ( chunk == dStringUtils.FourCC( "D" , "G" , "3" , "D" , endian ) && version >= 200 )
			{
				while ( data.AvailableSize() )
				{
					if ( data.AvailableSize() == 0 )
					{
						if ( onLoadComplete != null ) onLoadComplete();
					}
					else
					{
						chunk = data.ReadInt();
						if ( chunk == dStringUtils.FourCC( "E" , "N" , "D" , "0" , endian ) )
						{
							if ( onLoadComplete != null ) onLoadComplete();
						}
						else
						{
							var size:int = data.ReadInt();
							if ( chunk == dStringUtils.FourCC( "H" , "E" , "A" , "D" , endian ) )
							{
								var nCompressType:int = data.ReadInt();
								var nUncompressSize:int = data.ReadInt();
								var nMeshNum:int = data.ReadInt();
								var nUnknown1:int = data.ReadInt();
								var nUnknown2:int = data.ReadInt();
								if ( nCompressType == 1 )
								{
									var pUncomData:dByteArray = data.ReadBinEx( data.AvailableSize() );
									pUncomData.Uncompress();
									data = pUncomData;
								}
							}
							else if ( chunk == dStringUtils.FourCC( "B" , "B" , "O" , "X" , endian ) )
							{
								m_vBoundingBox.x1 = data.ReadFloat();
								m_vBoundingBox.y1 = data.ReadFloat();
								m_vBoundingBox.z1 = data.ReadFloat();
								m_vBoundingBox.x2 = data.ReadFloat();
								m_vBoundingBox.y2 = data.ReadFloat();
								m_vBoundingBox.z2 = data.ReadFloat();
							}
							else if ( chunk == dStringUtils.FourCC( "V" , "B" , "0" , "1" , endian ) )
							{
								var nCount:int = data.ReadShort();
								var nSlot:int = data.ReadShort();
								var stride:int = data.ReadShort();
								var nVertexNum:int = data.ReadInt();
								var x_range:Number = data.ReadFloat();
								var y_range:Number = data.ReadFloat();
								var z_range:Number = data.ReadFloat();
								var uRange:Number = data.ReadFloat();
								var vRange:Number = data.ReadFloat();
								if ( bAnimate )
									m_pVertexBuffer = new dVertexBuffer( nVertexNum , "0,FLOAT3,POSITION \n0,FLOAT3,NORMAL \n0,FLOAT2,TEXCOORD \n0,UBYTE4,BLENDINDICES \n0,FLOAT4,BLENDWEIGHT" , m_pDevice );
								else
									m_pVertexBuffer = new dVertexBuffer( nVertexNum , "0,FLOAT3,POSITION \n0,FLOAT3,NORMAL \n0,FLOAT2,TEXCOORD" , m_pDevice );
								var pVertexData:dByteArray = new dByteArray();
								pVertexData.SetEndian( data.GetEndian() );
								var nWeightIndex:int = 0;
								var fWeight1:Number = 1.0;
								var fWeight2:Number = 0.0;
								var fWeight3:Number = 0.0;
								var fWeight4:Number = 0.0;
								for ( var i:int = 0 ; i < nVertexNum ; i ++ )
								{
									pVertexData.WriteFloat( Number( data.ReadShort() ) / x_range );
									pVertexData.WriteFloat( Number( data.ReadShort() ) / y_range );
									pVertexData.WriteFloat( Number( data.ReadShort() ) / z_range );
									pVertexData.WriteFloat( Number( data.ReadShort() ) / 32767.0 );
									pVertexData.WriteFloat( Number( data.ReadShort() ) / 32767.0 );
									pVertexData.WriteFloat( Number( data.ReadShort() ) / 32767.0 );
									if ( stride == 13 )
									{
										nWeightIndex = data.ReadInt();
										fWeight1 = Number( data.ReadShort() ) / 32767.0;
										fWeight2 = Number( data.ReadShort() ) / 32767.0;
										fWeight3 = Number( data.ReadShort() ) / 32767.0;
										fWeight4 = Number( data.ReadShort() ) / 32767.0;
									}
									pVertexData.WriteFloat( Number( data.ReadShort() ) / uRange );
									pVertexData.WriteFloat( Number( data.ReadShort() ) / vRange );
									if ( bAnimate )
									{
										pVertexData.WriteInt( nWeightIndex );
										pVertexData.WriteFloat( fWeight1 );
										pVertexData.WriteFloat( fWeight2 );
										pVertexData.WriteFloat( fWeight3 );
										pVertexData.WriteFloat( fWeight4 );
									}
								}
								m_pVertexBuffer.UploadVertexBufferFromByteArray( _dInterface.iBridge_OldByteArray( pVertexData ) );
							}
							else if ( chunk == dStringUtils.FourCC( "T" , "E" , "X" , "0" , endian ) )
							{
								m_vecTexture.length = data.ReadShort();
								for ( i = 0 ; i < m_vecTexture.length ; i ++ )
								{
									var strFileName:String = data.ReadString();
									var nTexSize:int = data.ReadInt();
									var pos:int = data.GetPosition();
									m_vecTexture[i] = new dTexture( m_pDevice );
									var data2:dByteArray = new dByteArray();
									data2 = data.ReadBinEx( nTexSize );
									m_vecTexture[i].LoadFromBin( data2 , null , strTexturePath + "/" + strFileName , 0 , pColorTransform );
								}
							}
							else if ( chunk == dStringUtils.FourCC( "I" , "B" , "0" , "1" , endian ) )
							{
								m_vecSubMesh.length = data.ReadShort();
								for ( i = 0 ; i < m_vecSubMesh.length ; i ++ )
								{
									m_vecSubMesh[i] = new dMeshFileObj( m_pDevice );
									m_vecSubMesh[i].nTexture = data.ReadShort();
									var vecIndexData:Vector.<uint> = new Vector.<uint>;
									vecIndexData.length = data.ReadUnsignedShort();
									for ( var j:int = 0 ; j < vecIndexData.length ; j ++ )
										vecIndexData[j] = data.ReadUnsignedShort();
									m_vecSubMesh[i].m_pIndexBuffer = new dIndexBuffer( vecIndexData.length / 3 , m_pDevice );
									m_vecSubMesh[i].m_pIndexBuffer.UploadIndexBufferFromVector( vecIndexData );
								}
							}
							else if ( chunk == dStringUtils.FourCC( "B" , "O" , "N" , "E" , endian ) )
							{
								m_vecSkeleton = new Vector.<dMeshFileSkeleton>;
								m_vecSkeleton.length = data.ReadShort();
								for ( i = 0 ; i < m_vecSkeleton.length ; i ++ )
									m_vecSkeleton[i] = new dMeshFileSkeleton();
								for ( i = 0 ; i < m_vecSkeleton.length ; i ++ )
								{
									m_vecSkeleton[i].name = data.ReadString();
									m_vecSkeleton[i].matInverse = new dMatrix();
									m_vecSkeleton[i].matInverse._11 = data.ReadFloat();
									m_vecSkeleton[i].matInverse._12 = data.ReadFloat();
									m_vecSkeleton[i].matInverse._13 = data.ReadFloat();
									m_vecSkeleton[i].matInverse._14 = data.ReadFloat();
									m_vecSkeleton[i].matInverse._21 = data.ReadFloat();
									m_vecSkeleton[i].matInverse._22 = data.ReadFloat();
									m_vecSkeleton[i].matInverse._23 = data.ReadFloat();
									m_vecSkeleton[i].matInverse._24 = data.ReadFloat();
									m_vecSkeleton[i].matInverse._31 = data.ReadFloat();
									m_vecSkeleton[i].matInverse._32 = data.ReadFloat();
									m_vecSkeleton[i].matInverse._33 = data.ReadFloat();
									m_vecSkeleton[i].matInverse._34 = data.ReadFloat();
									m_vecSkeleton[i].matInverse._41 = data.ReadFloat();
									m_vecSkeleton[i].matInverse._42 = data.ReadFloat();
									m_vecSkeleton[i].matInverse._43 = data.ReadFloat();
									m_vecSkeleton[i].matInverse._44 = data.ReadFloat();
									m_vecSkeleton[i].m_vecChildId.length = data.ReadShort();
									for ( j = 0 ; j < m_vecSkeleton[i].m_vecChildId.length ; j ++ )
									{
										m_vecSkeleton[i].m_vecChildId[j] = data.ReadShort();
										m_vecSkeleton[ m_vecSkeleton[i].m_vecChildId[j] ].m_nParentId = i;
									}
								}
								for ( i = 0 ; i < m_vecSubMesh.length ; i ++ )
								{
									m_vecSubMesh[i].bone_id_num = data.ReadByte();
									m_vecSubMesh[i].bone_id = new Vector.<int>;
									for ( j = 0 ; j < m_vecSubMesh[i].bone_id_num ; j ++ )
										m_vecSubMesh[i].bone_id[j] = data.ReadByte();
								}
							}
							else data.SetPosition( data.GetPosition() + size );
						}
					}
				}
			}
		}
		public function SetTextureFromFile( strFileName:String , idx:int = 0 ):void
		{
			if ( idx >= 0 && idx < m_vecTexture.length )
				m_vecTexture[idx].LoadFromFile( strFileName );
		}
		private function readMatrix( data:dByteArray ):dMatrix
		{
			var m:dMatrix = new dMatrix();
			m._11 = data.ReadFloat();
			m._12 = data.ReadFloat();
			m._13 = data.ReadFloat();
			m._14 = data.ReadFloat();
			m._21 = data.ReadFloat();
			m._22 = data.ReadFloat();
			m._23 = data.ReadFloat();
			m._24 = data.ReadFloat();
			m._31 = data.ReadFloat();
			m._32 = data.ReadFloat();
			m._33 = data.ReadFloat();
			m._34 = data.ReadFloat();
			m._41 = data.ReadFloat();
			m._42 = data.ReadFloat();
			m._43 = data.ReadFloat();
			m._44 = data.ReadFloat();
			return m;
		}
		public function Render( vecSkeletonMatrixResult:Vector.<dMatrix> = null , shader:dShaderBase = null ):int
		{
			if ( !m_pVertexBuffer ) return 0;
			var ret:int;
			m_pVertexBuffer.SetToDevice();
			for ( var i:int = 0 ; i < m_vecSubMesh.length ; i ++ )
			{
				ret += m_vecSubMesh[i].Render( m_vecTexture , vecSkeletonMatrixResult , shader );
			}
			return ret;
		}
		public function GetBoundingBox():dBoundingBox
		{
			return m_vBoundingBox;
		}
		public function GetSubMeshNum():int
		{
			return m_vecSubMesh.length;
		}
		public function GetVertexBuffer():dVertexBuffer
		{
			return m_pVertexBuffer;
		}
		public function GetSubMeshIndexBuffer( idx:int ):dIndexBuffer
		{
			return m_vecSubMesh[idx].GetIndexBuffer();
		}
	}

}
