//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Math.dMatrix;
	import dGame3D.Math.dVector3;
	import dGame3D.Shader.dShaderBase;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author dym
	 */
	public class dGrass 
	{
		protected var m_pTerrain:dTerrain;
		protected var m_pDevice:dDevice;
		protected var m_pVB:dVertexBuffer;
		protected var m_vPos:dVector3;
		protected var m_pIB:dIndexBuffer;
		protected static const g_vecGrassVertices:Array = [
		// |--|
		// | \|
		// |--|
		// | \|
		// |--|
		// x    y     z    tu1  tv1    
		-0.3, 0.0,   0.0, 1.0,  1.0 ,
		 0.3, 0.0,   0.0, 0.01, 1.0 ,
		-0.3, 0.25,  0.0, 1.0,  0.5 ,
		 0.3, 0.25,  0.0, 0.01, 0.5 ,
		-0.3, 0.5,   0.0, 1.0,  0.01,
		 0.3, 0.5,   0.0, 0.01, 0.01,
		];
		public function dGrass( pDevice:dDevice , pTerrain:dTerrain , x:Number , y:Number ) 
		{
			m_pTerrain = pTerrain;
			m_pDevice = pDevice;
			m_vPos = new dVector3( x , 0.0 , y );
		}
		public function Release():void
		{
			if ( m_pVB )
			{
				m_pVB.Release();
				m_pVB = null;
			}
			if ( m_pIB )
			{
				m_pIB.Release();
				m_pIB = null;
			}
		}
		public function Init():void
		{
			Release();
			var vecData:Vector.<dGrassData> = m_pTerrain.GetGrassData( m_vPos.x , m_vPos.z );
			if ( vecData.length > 5460 )
				vecData.length = 5460;
			if ( vecData.length == 0 ) return;
			m_pVB = new dVertexBuffer( vecData.length * 12 , "0,FLOAT3,POSITION \n0,UBYTE4,COLOR \n0,FLOAT4,TEXCOORD" , m_pDevice );
			//var vec:Vector.<Number> = new Vector.<Number>;
			//vec.length = vecData.length * 12 * 5;
			var vec:ByteArray = new ByteArray();
			vec.endian = "littleEndian";
			//var k:int = 0;
			var mat:dMatrix = new dMatrix();
			var mat2:dMatrix = new dMatrix();
			var v:dVector3 = new dVector3();
			var uv:Array = [
				0.0 , 0.0 , 0.5 , 0.5 ,
				0.5 , 0.0 , 1.0 , 0.5 ,
				0.0 , 0.5 , 1.0 , 1.0 ];
			for ( var j:int = 0 ; j < vecData.length ; j ++ )
			{
				mat.RotationY( vecData[j].fRotation );
				mat2.Translation( vecData[j].x , vecData[j].y , vecData[j].z );
				mat = mat.Mul( mat2 );
				var width:Number = 1.5;
				var height:Number = 1.5;
				var rnd:Number = Math.random() * 10;
				var color:uint = vecData[j].nColor;
				for ( var i:int = 0 ; i < 6 ; i ++ )
				{
					v.Set( g_vecGrassVertices[i * 5 + 0] * width , g_vecGrassVertices[i * 5 + 1] * height , g_vecGrassVertices[i * 5 + 2] );
					v.Transform( mat );
					vec.writeFloat( v.x );
					vec.writeFloat( v.y );
					vec.writeFloat( v.z );
					vec.writeUnsignedInt( color );
					vec.writeFloat( g_vecGrassVertices[i * 5 + 3] * ( uv[ vecData[j].nTexID * 4 + 2 ] - uv[ vecData[j].nTexID * 4 + 0 ] ) + uv[ vecData[j].nTexID * 4 + 0 ] );
					vec.writeFloat( g_vecGrassVertices[i * 5 + 4] * ( uv[ vecData[j].nTexID * 4 + 3 ] - uv[ vecData[j].nTexID * 4 + 1 ] ) + uv[ vecData[j].nTexID * 4 + 1 ] );
					vec.writeFloat( rnd );
					vec.writeFloat( g_vecGrassVertices[i * 5 + 4] );
				}
				for ( i = 0 ; i < 6 ; i ++ )
				{
					v.Set( g_vecGrassVertices[i * 5 + 2] * width , g_vecGrassVertices[i * 5 + 1] *height , g_vecGrassVertices[i * 5 + 0] );
					v.Transform( mat );
					vec.writeFloat( v.x );
					vec.writeFloat( v.y );
					vec.writeFloat( v.z );
					vec.writeUnsignedInt( color );
					vec.writeFloat( g_vecGrassVertices[i * 5 + 3] * ( uv[ vecData[j].nTexID * 4 + 2 ] - uv[ vecData[j].nTexID * 4 + 0 ] ) + uv[ vecData[j].nTexID * 4 + 0 ] );
					vec.writeFloat( g_vecGrassVertices[i * 5 + 4] * ( uv[ vecData[j].nTexID * 4 + 3 ] - uv[ vecData[j].nTexID * 4 + 1 ] ) + uv[ vecData[j].nTexID * 4 + 1 ] );
					vec.writeFloat( rnd );
					vec.writeFloat( g_vecGrassVertices[i * 5 + 4] );
				}
			}
			m_pVB.UploadVertexBufferFromByteArray( vec , 0 , false );
			
			var faceNum:int = m_pVB.GetVertexNum() / 6 * 4;
			m_pIB = new dIndexBuffer( faceNum , m_pDevice );
			var data:Vector.<uint> = new Vector.<uint>;
			for ( j = 0 ; j < faceNum / 4 ; j ++ )
				data.push( 0+j*6, 1+j*6, 2+j*6, 1+j*6, 2+j*6, 3+j*6, 2+j*6, 3+j*6, 4+j*6, 3+j*6, 4+j*6, 5+j*6 );
			m_pIB.UploadIndexBufferFromVector( data );
		}
		public function Render( shader:dShaderBase ):int
		{
			if ( !m_pVB ) return 0;
			m_pVB.SetToDevice();
			return m_pIB.Render();
		}
		public function GetPos():dVector3
		{
			return m_vPos;
		}
	}

}