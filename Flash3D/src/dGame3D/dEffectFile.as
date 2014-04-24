//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Math.dBoundingBox;
	import dGame3D.Math.dVector4;
	import dGame3D.Shader.dShaderBase;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import dGame3D.PNGEncoder;
	/**
	 * ...
	 * @author dym
	 */
	public class dEffectFile 
	{
		protected var m_pDevice:dDevice;
		protected var m_vecVB:Vector.<dVertexBuffer>;
		protected var m_vecIB:Vector.<dIndexBuffer>;
		protected var m_vecVBBlendAdd:Vector.<dVertexBuffer>;
		protected var m_vecIBBlendAdd:Vector.<dIndexBuffer>;
		protected var m_pTexture:dTexture;
		protected var m_nFrameNum:int;
		protected var m_nTickPerFrame:int = 100;
		protected var m_pBoundingBox:dBoundingBox = new dBoundingBox();
		protected var m_fURange:Number;
		protected var m_fVRange:Number;
		protected var m_fXRange:Number;
		protected var m_fYRange:Number;
		protected var m_fZRange:Number;
		protected var m_pIBCommon:dIndexBuffer;
		protected var m_pIBCommonBlendAdd:dIndexBuffer;
		public function dEffectFile( pDevice:dDevice ) 
		{
			m_pDevice = pDevice;
		}
		public function Release():void
		{
			if ( m_vecVB )
			{
				for ( var i:int = 0 ; i < m_vecVB.length ; i ++ )
					if ( m_vecVB[i] ) m_vecVB[i].Release();
				m_vecVB = null;
			}
			if ( m_vecIB )
			{
				for ( i = 0 ; i < m_vecIB.length ; i ++ )
					m_vecIB[i].Release();
				m_vecIB = null;
			}
			if ( m_vecVBBlendAdd )
			{
				for ( i = 0 ; i < m_vecVBBlendAdd.length ; i ++ )
					if ( m_vecVBBlendAdd[i] ) m_vecVBBlendAdd[i].Release();
				m_vecVBBlendAdd = null;
			}
			if ( m_vecIBBlendAdd )
			{
				for ( i = 0 ; i < m_vecIBBlendAdd.length ; i ++ )
					m_vecIBBlendAdd[i].Release();
				m_vecIBBlendAdd = null;
			}
			if ( m_pTexture )
			{
				m_pTexture.Release();
				m_pTexture = null;
			}
			if ( m_pIBCommon )
			{
				m_pIBCommon.Release();
				m_pIBCommon = null;
			}
			if ( m_pIBCommonBlendAdd )
			{
				m_pIBCommonBlendAdd.Release();
				m_pIBCommonBlendAdd = null;
			}
		}
		public function LoadFromFile( strFileName:String , onLoadComplate:Function = null ):void
		{
			var strPath:String = new String( strFileName );
			for( var i:int = strPath.length-1 ; i >= 0 ; i -- )
			{
				if( strPath.charAt( i ) == "." )
				{
					strPath = strPath.substring( 0 , i );
					break;
				}
			}
			m_pDevice.LoadBinFromFile( strFileName , function( data:ByteArray ):void
			{
				if ( data )
				{
					data.endian = "littleEndian";
					data.position = 0;
					LoadFromBin( data , strPath + ".jpg" );
					if ( onLoadComplate != null ) onLoadComplate();
				}
			} );
		}
		protected function LoadVertex( data:ByteArray , pVB:dVertexBuffer , vertexNum:int ):void
		{
			var pData:ByteArray = new ByteArray();
			pData.endian = "littleEndian";
			for ( var i:int = 0 ; i < vertexNum ; i ++ )
			{
				pData.writeFloat( data.readShort() / m_fXRange );// x
				pData.writeFloat( data.readShort() / m_fYRange );// y
				pData.writeFloat( data.readShort() / m_fZRange );// z
				if ( data.readByte() )// canBlend
					pData.writeFloat( 1.0 );
				else
					pData.writeFloat( 0.0 );
				pData.writeUnsignedInt( data.readUnsignedInt() );// color
				pData.writeFloat( data.readShort() / m_fXRange );// billboardDirX
				pData.writeFloat( data.readShort() / m_fYRange );// billboardDirY
				pData.writeFloat( data.readShort() / m_fZRange );// billboardDirZ
				pData.writeFloat( data.readShort() / m_fURange );// u
				pData.writeFloat( data.readShort() / m_fVRange );// v
			}
			pVB.UploadVertexBufferFromByteArray( pData );
		}
		public function LoadFromBin( data:ByteArray , strTextureName:String ):void
		{
			m_vecVB = new Vector.<dVertexBuffer>;
			m_vecVBBlendAdd = new Vector.<dVertexBuffer>;
			m_pTexture = new dTexture( m_pDevice );
			if ( strTextureName.length ) m_pTexture.LoadFromFile( strTextureName );
			m_nFrameNum = 0;
			data.position = 0;
			var i:int;
			var pData:ByteArray;
			while ( 1 )
			{
				var chunk:int = data.readInt();
				if ( data.endian == "littleEndian" )
					chunk = (chunk & 0xFF000000) >> 24 | (chunk & 0x00FF0000) >> 8 | (chunk & 0x0000FF00) << 8 | (chunk & 0x000000FF) << 24;
				if ( chunk == PNGEncoder.MakeChunk( "E" , "N" , "D" , "0" ) )
					break;
				var size:int = data.readInt();
				if ( chunk == PNGEncoder.MakeChunk( "D" , "G" , "3" , "E" ) )
				{
					var ver:int = data.readInt();
					var compressType:int = data.readInt();
					var compressOldSize:int = data.readInt();
					m_fURange = data.readFloat();
					m_fVRange = data.readFloat();
					m_fXRange = data.readFloat();
					m_fYRange = data.readFloat();
					m_fZRange = data.readFloat();
					if ( compressType == 1 )
					{
						var pUncomData:ByteArray = new ByteArray();
						pUncomData.endian = data.endian;
						data.readBytes( pUncomData , 0 , data.length - data.position );
						pUncomData.uncompress();
						data = pUncomData;
					}
				}
				else if ( chunk == PNGEncoder.MakeChunk( "B" , "B" , "O" , "X" ) )
				{
					m_pBoundingBox.x1 = data.readFloat();
					m_pBoundingBox.y1 = data.readFloat();
					m_pBoundingBox.z1 = data.readFloat();
					m_pBoundingBox.x2 = data.readFloat();
					m_pBoundingBox.y2 = data.readFloat();
					m_pBoundingBox.z2 = data.readFloat();
				}
				/*else if ( chunk == PNGEncoder.MakeChunk( "T" , "E" , "X" , "1" ) )
				{
					var strFileName:String = data.readUTFBytes( size );
					m_pTexture.LoadFromFile( strTexturePath + "/" + strFileName );
				}*/
				else if ( chunk == PNGEncoder.MakeChunk( "F" , "R" , "A" , "M" ) )
				{
					m_nFrameNum = data.readInt();
					m_nTickPerFrame = data.readInt();
					m_vecVB.length = m_nFrameNum;
					m_vecVBBlendAdd.length = m_nFrameNum;
				}
				else if ( chunk == PNGEncoder.MakeChunk( "V" , "T" , "X" , "1" ) )
				{
					for ( i = 0 ; i < m_nFrameNum ; i ++ )
					{
						var nSize:int = data.readInt();
						if ( nSize )
						{
							m_vecVB[i] = new dVertexBuffer( nSize , "0,FLOAT4,POSITION\n0,UBYTE4,COLOR\n0,FLOAT3,NORMAL\n0,FLOAT2,TEXCOORD" , m_pDevice );
							LoadVertex( data , m_vecVB[i] , nSize );
						}
					}
				}
				else if ( chunk == PNGEncoder.MakeChunk( "V" , "T" , "X" , "2" ) )
				{
					for ( i = 0 ; i < m_nFrameNum ; i ++ )
					{
						nSize = data.readInt();
						if ( nSize )
						{
							m_vecVBBlendAdd[i] = new dVertexBuffer( nSize , "0,FLOAT4,POSITION\n0,UBYTE4,COLOR\n0,FLOAT3,NORMAL\n0,FLOAT2,TEXCOORD" , m_pDevice );
							LoadVertex( data , m_vecVBBlendAdd[i] , nSize );
						}
					}
				}
				else if ( chunk == PNGEncoder.MakeChunk( "I" , "D" , "X" , "1" ) )
				{
					if( !m_vecIB ) m_vecIB = new Vector.<dIndexBuffer>;
					for ( i = 0 ; i < m_nFrameNum ; i ++ )
					{
						nSize = data.readInt();
						if ( nSize )
						{
							pData = new ByteArray();
							pData.endian = data.endian;
							data.readBytes( pData , 0 , nSize * 2 );
							pData.position = 0;
							var pIB:dIndexBuffer = new dIndexBuffer( nSize / 3 , m_pDevice );
							var vecIBData:Vector.<uint> = new Vector.<uint>;
							for ( var j:int = 0 ; j < nSize ; j ++ )
								vecIBData.push( pData.readUnsignedShort() );
							pIB.UploadIndexBufferFromVector( vecIBData );
							m_vecIB.push( pIB );
						}
					}
				}
				else if ( chunk == PNGEncoder.MakeChunk( "I" , "D" , "X" , "2" ) )
				{
					if( !m_vecIBBlendAdd ) m_vecIBBlendAdd = new Vector.<dIndexBuffer>;
					for ( i = 0 ; i < m_nFrameNum ; i ++ )
					{
						nSize = data.readInt();
						if ( nSize )
						{
							pData = new ByteArray();
							pData.endian = data.endian;
							data.readBytes( pData , 0 , nSize * 2 );
							pData.position = 0;
							pIB = new dIndexBuffer( nSize / 3 , m_pDevice );
							vecIBData = new Vector.<uint>;
							for ( j = 0 ; j < nSize ; j ++ )
								vecIBData.push( pData.readUnsignedShort() );
							pIB.UploadIndexBufferFromVector( vecIBData );
							m_vecIBBlendAdd.push( pIB );
						}
					}
				}
				else data.position += size;
			}
			if ( m_vecIB == null && m_vecVB[0] )
			{
				m_pIBCommon = new dIndexBuffer( m_vecVB[0].GetVertexNum() / 3 , m_pDevice );
				vecIBData = new Vector.<uint>;
				for ( i = 0 ; i < m_pIBCommon.GetFaceNum() * 3 ; i ++ )
					vecIBData.push( i );
				m_pIBCommon.UploadIndexBufferFromVector( vecIBData );
			}
			if ( m_vecIBBlendAdd == null && m_vecVBBlendAdd[0] )
			{
				m_pIBCommonBlendAdd = new dIndexBuffer( m_vecVBBlendAdd[0].GetVertexNum() / 3 , m_pDevice );
				vecIBData = new Vector.<uint>;
				for ( i = 0 ; i < m_pIBCommonBlendAdd.GetFaceNum() * 3 ; i ++ )
					vecIBData.push( i );
				m_pIBCommonBlendAdd.UploadIndexBufferFromVector( vecIBData );
			}
		}
		public function Render( time:int , shader:dShaderBase ):int
		{
			if ( m_nFrameNum == 0 || m_nTickPerFrame == 0 ) return 0;
			var fFrame:Number = (time % GetKeyMaxTime()) / m_nTickPerFrame;
			var nFrame:int = int( fFrame );
			var fLerp:Number = fFrame - Number(nFrame);
			var nFrameNext:int = nFrame + 1;
			if ( nFrameNext >= m_nFrameNum - 1 ) nFrameNext = m_nFrameNum - 1;
			shader.SetShaderConstantsFloat4( dGame3DSystem.SHADER_LERP , new dVector4( 1.5 , fLerp , 1.0 , 1 ) );
			var r:int = 0;
			m_pTexture.SetToDevice( 0 );
			m_pDevice.SetBlendFactor( 0 );
			var bEnableFog:Boolean = m_pDevice.isEnableFog();
			if ( m_vecVB[ nFrame ] )
			{
				m_vecVB[ nFrame ].SetToDevice();
				if ( m_vecVB[ nFrame ].GetVertexNum() != m_vecVB[ nFrameNext ].GetVertexNum() )
					nFrameNext = nFrame;
				m_vecVB[ nFrameNext ].SetToDevice( 4 );
				if ( m_pIBCommon ) r += m_pIBCommon.Render();
				else r += m_vecIB[ nFrame ].Render();
			}
			m_pDevice.SetBlendFactor( 1 );
			shader.SetShaderConstantsFloat4( dGame3DSystem.SHADER_LERP , new dVector4( 1.5 , fLerp , 1.0 , 0 ) );
			if ( m_vecVBBlendAdd[ nFrame ] )
			{
				m_vecVBBlendAdd[ nFrame ].SetToDevice();
				if( m_vecVBBlendAdd[ nFrame ].GetVertexNum() != m_vecVBBlendAdd[ nFrameNext ].GetVertexNum() )
					nFrameNext = nFrame;
				m_vecVBBlendAdd[ nFrameNext ].SetToDevice( 4 );
				if ( m_pIBCommonBlendAdd ) r += m_pIBCommonBlendAdd.Render();
				else r += m_vecIBBlendAdd[ nFrame ].Render();
			}
			return r;
		}
		public function GetBoundingBox():dBoundingBox
		{
			return m_pBoundingBox;
		}
		public function GetKeyMaxTime():int
		{
			return m_nFrameNum * m_nTickPerFrame;
		}
	}

}
