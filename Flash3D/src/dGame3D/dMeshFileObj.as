//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Math.dMatrix;
	import dGame3D.Math.dVector3;
	import dGame3D.Math.dVector4;
	import dGame3D.Shader.dShaderBase;
	import dGame3D.Shader.dShader_Animate;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author dym
	 */
	public class dMeshFileObj 
	{
		public var index_num:int;
		public var nTexture:int;
		public var bone_id_num:int;
		public var bone_id:Vector.<int>;
		public var m_vecIndexBuffer:Vector.<uint>;
		public var m_pIndexBuffer:dIndexBuffer;
		public function dMeshFileObj( pDevice:dDevice ) 
		{
		}
		public function Release():void
		{
			if( m_pIndexBuffer ) m_pIndexBuffer.Release();
		}
		static private var s_vecMatrixTemp:Vector.<dMatrix>;
		public function Render( vecTexture:Vector.<dTexture> , vecSkeletonMatrixResult:Vector.<dMatrix> , shader:dShaderBase ):int
		{
			if ( vecSkeletonMatrixResult )
			{
				if ( s_vecMatrixTemp == null )
				{
					s_vecMatrixTemp = new Vector.<dMatrix>;
					s_vecMatrixTemp.push( dMatrix.IDENTITY() );
				}
				s_vecMatrixTemp.length = bone_id_num + 1;
				for ( var i:int = 0 ; i < bone_id_num ; i ++ )
					s_vecMatrixTemp[i + 1] = vecSkeletonMatrixResult[ bone_id[i] ];
				shader.SetShaderConstantsMatrixArray( dGame3DSystem.SHADER_SKELETON , s_vecMatrixTemp );
			}
			if( nTexture >= 0 )
				vecTexture[ nTexture ].SetToDevice( 0 );
			m_pIndexBuffer.Render();
			return m_pIndexBuffer.GetFaceNum();
		}
		public function GetIndexBuffer():dIndexBuffer
		{
			return m_pIndexBuffer;
		}
	}

}