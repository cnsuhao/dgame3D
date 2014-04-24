//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import flash.display3D.VertexBuffer3D;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author dym
	 */
	public class dVertexBuffer 
	{
		protected var m_pVB:VertexBuffer3D;
		protected var m_nStride:int;
		protected var m_pVBDecl:dVertexBufferDecl;
		protected var m_nVertexNum:int;
		protected var m_pDevice:dDevice;
		protected var m_vecPositionX:Vector.<Number>;
		protected var m_vecPositionY:Vector.<Number>;
		protected var m_vecPositionZ:Vector.<Number>;
		public function dVertexBuffer( numVertices:int , strDeclaration:String , pDevice:dDevice )
		{
			m_pVBDecl = new dVertexBufferDecl( strDeclaration );
			m_nVertexNum = numVertices;
			m_nStride = m_pVBDecl.GetStride();
			if ( !pDevice.isDisposed() )
				m_pVB = pDevice.GetDevice().createVertexBuffer( numVertices , m_nStride );
			m_pDevice = pDevice;
		}
		public function Release():void
		{
			if ( m_pVB )
			{
				m_pVB.dispose();
				m_pVB = null;
			}
		}
		public function UploadVertexBufferFromByteArray( data:ByteArray , dataoffset:int = 0 , bCollection:Boolean = true ):void
		{
			if ( !m_pVB ) return;
			data.position = dataoffset;
			m_pVB.uploadFromByteArray( data , data.position , 0 , m_nVertexNum );
			
			if ( m_pVBDecl.usage[0] == dVertexBufferDecl.DECL_USAGE_POSITION && bCollection )
			{
				m_vecPositionX = new Vector.<Number>; m_vecPositionX.length = m_nVertexNum;
				m_vecPositionY = new Vector.<Number>; m_vecPositionY.length = m_nVertexNum;
				m_vecPositionZ = new Vector.<Number>; m_vecPositionZ.length = m_nVertexNum;
				for ( var i:int = 0 ; i < m_nVertexNum ; i ++ )
				{
					data.position = i * m_nStride * 4 + dataoffset;
					if ( m_pVBDecl.type[0] == "float1" )
						m_vecPositionX[i] = data.readFloat();
					else if ( m_pVBDecl.type[0] == "float2" )
					{
						m_vecPositionX[i] = data.readFloat();
						m_vecPositionY[i] = data.readFloat();
					}
					else if ( m_pVBDecl.type[0] == "float3" )
					{
						m_vecPositionX[i] = data.readFloat();
						m_vecPositionY[i] = data.readFloat();
						m_vecPositionZ[i] = data.readFloat();
					}
				}
			}
			data.position = dataoffset + m_nVertexNum * m_nStride * 4;
		}
		public function UploadVertexBufferFromVector( data:Vector.<Number> , bCollection:Boolean = true ):void
		{
			if ( !m_pVB ) return;
			m_pVB.uploadFromVector( data , 0 , m_nVertexNum );
			if ( m_pVBDecl.usage[0] == dVertexBufferDecl.DECL_USAGE_POSITION && bCollection )
			{
				m_vecPositionX = new Vector.<Number>; m_vecPositionX.length = m_nVertexNum;
				m_vecPositionY = new Vector.<Number>; m_vecPositionY.length = m_nVertexNum;
				m_vecPositionZ = new Vector.<Number>; m_vecPositionZ.length = m_nVertexNum;
				for ( var i:int = 0 ; i < m_nVertexNum ; i ++ )
				{
					if ( m_pVBDecl.type[0] == "float1" )
						m_vecPositionY[i] = data[i*m_nStride+0];
					else if ( m_pVBDecl.type[0] == "float2" )
					{
						m_vecPositionX[i] = data[i*m_nStride+0];
						m_vecPositionZ[i] = data[i*m_nStride+1];
					}
					else if ( m_pVBDecl.type[0] == "float3" )
					{
						m_vecPositionX[i] = data[i*m_nStride+0];
						m_vecPositionY[i] = data[i*m_nStride+1];
						m_vecPositionZ[i] = data[i*m_nStride+2];
					}
				}
			}
		}
		public function SetToDevice( index:int = 0 ):void
		{
			if ( !m_pVB ) return;
			var length:int = m_pVBDecl.stream.length;
			for ( var i:int = 0 ; i < length ; i ++ )
			{
				m_pDevice.GetDevice().setVertexBufferAt( i + index , m_pVB ,
					m_pVBDecl.startPos[i] , m_pVBDecl.type[i] );
			}
			//m_pDevice.GetDevice().setVertexBufferAt( i + index , null );
		}
		public function GetVertexDataX():Vector.<Number>
		{
			return m_vecPositionX;
		}
		public function GetVertexDataY():Vector.<Number>
		{
			return m_vecPositionY;
		}
		public function GetVertexDataZ():Vector.<Number>
		{
			return m_vecPositionZ;
		}
		public function GetVertexNum():int
		{
			return m_nVertexNum;
		}
	}

}