//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import flash.display3D.IndexBuffer3D;
	/**
	 * ...
	 * @author dym
	 */
	public class dIndexBuffer 
	{
		protected var m_nFaceNum:int;
		protected var m_pIB:IndexBuffer3D;
		protected var m_pDevice:dDevice;
		protected var m_vecIndexData:Vector.<uint>;
		public function dIndexBuffer( numFaces:int , pDevice:dDevice ) 
		{
			m_pDevice = pDevice;
			m_nFaceNum = numFaces;
			m_pIB = m_pDevice.GetDevice().createIndexBuffer( numFaces * 3 );
		}
		public function Release():void
		{
			m_pIB.dispose();
			m_pIB = null;
		}
		public function UploadIndexBufferFromVector( data:Vector.< uint > ):void
		{
			m_pIB.uploadFromVector( data , 0 , data.length );
			m_vecIndexData = new Vector.<uint>;
			m_vecIndexData.length = data.length;
			for ( var i:int = 0 ; i < data.length ; i ++ )
				m_vecIndexData[i] = data[i];
		}
		public function GetFaceNum():int
		{
			return m_nFaceNum;
		}
		public function Render( numFace:int = -1 ):int
		{
			if ( numFace == -1 ) numFace = m_nFaceNum;
			m_pDevice.GetDevice().drawTriangles( m_pIB , 0 , numFace );
			return numFace;
		}
		public function GetIndexData():Vector.<uint>
		{
			return m_vecIndexData;
		}
	}

}