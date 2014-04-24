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
	public class dMeshFileObjOld 
	{
		public var lod_num:int;
		public var index_num:int;
		public var normalvertex_num:int;
		public var use32bitindex:int;
		public var nTexType:int;
		public var nTexture:int;
		public var nSpecTexture:int;
		public var cull_mode:int;
		public var render_type:int;
		public var mesh_name:String;
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
		public var bone_id_num:int;
		public var bone_id:Vector.<int>;
		public var vertexMask:int;
		public var f_pos_x:Number;
		public var f_pos_y:Number;
		public var f_pos_z:Number;
		private var m_vecVertexBufferPos:Vector.<dVector3>;
		private var m_vecVertexBufferNormal:Vector.<dVector3>;
		private var m_vecVertexBufferWeight:Vector.<dVector4>;
		private var m_vecVertexBufferBoneIndex:Vector.<uint>;
		private var m_vecIndexBuffer:Vector.<uint>;
		private var m_pVertexBuffer:dVertexBuffer;
		private var m_pIndexBuffer:dIndexBuffer;
		public function dMeshFileObj( data:ByteArray , pDevice:dDevice , bAnimate:Boolean = false ) 
		{
			lod_num = data.readInt();
			var vecIndexNum:Vector.<int> = new Vector.<int>;
			var vecNormalVertexNum:Vector.<int> = new Vector.<int>;
			for ( var i:int = 0 ; i < 16 ; i ++ )
				vecIndexNum.push( data.readInt() );
			index_num = vecIndexNum[0];
			for ( i = 0 ; i < 16 ; i ++ )
				vecNormalVertexNum.push( data.readInt() );
			normalvertex_num = vecNormalVertexNum[0];
			
			use32bitindex = data.readByte();
			nTexType = data.readByte();
			data.readByte();
			data.readByte();
			for ( i = 0 ; i < 8 ; i ++ )
			{
				if( i == 0 )
					nTexture = data.readInt();
				else
					data.readInt();
			}
			for ( i = 0 ; i < 8 ; i ++ )
			{
				if( i == 0 )
					nSpecTexture = data.readInt();
				else
					data.readInt();
			}
			cull_mode = data.readInt();
			render_type = data.readInt();
			mesh_name = data.readMultiByte( 256 * 2 , "unicode" );
			center_x = data.readFloat();
			center_y = data.readFloat();
			center_z = data.readFloat();
			aabb_x1 = data.readFloat();
			aabb_y1 = data.readFloat();
			aabb_z1 = data.readFloat();
			aabb_x2 = data.readFloat();
			aabb_y2 = data.readFloat();
			aabb_z2 = data.readFloat();
			boundingbox_x1 = data.readFloat();
			boundingbox_y1 = data.readFloat();
			boundingbox_z1 = data.readFloat();
			boundingbox_x2 = data.readFloat();
			boundingbox_y2 = data.readFloat();
			boundingbox_z2 = data.readFloat();
			radio = data.readFloat();
			bone_id_num = data.readInt();
			bone_id = new Vector.<int>;
			for( i = 0 ; i < 128 ; i ++ )
				bone_id[i] = data.readInt();
			vertexMask = data.readInt();
			for( i = 0 ; i < 31 ; i ++ )
				data.readInt();
			f_pos_x = data.readFloat();
			f_pos_y = data.readFloat();
			f_pos_z = data.readFloat();
			data.position = data.position + 125 * 4;// unknow
			for( var nLodLevel:int = 0 ; nLodLevel < lod_num ; nLodLevel++ )
			{
				if( nLodLevel == 0 )
				{
					var nVertexNum:int = normalvertex_num;
					if ( bAnimate )
						m_pVertexBuffer = new dVertexBuffer( nVertexNum , "0,FLOAT3,POSITION \n0,FLOAT3,NORMAL \n0,FLOAT2,TEXCOORD \n0,UBYTE4,BLENDINDICES \n0,FLOAT4,BLENDWEIGHT" , pDevice );
					else
						m_pVertexBuffer = new dVertexBuffer( nVertexNum , "0,FLOAT3,POSITION \n0,FLOAT3,NORMAL \n0,FLOAT2,TEXCOORD" , pDevice );
					
					var vecVertex:ByteArray = new ByteArray();
					vecVertex.endian = "littleEndian";
					for( i = 0 ; i < nVertexNum ; i ++ )
					{
						var x:Number = 0.0;
						var y:Number = 0.0;
						var z:Number = 0.0;
						var nx:Number = 0.0;
						var ny:Number = 0.0;
						var nz:Number = 0.0;
						var u:Number = 0.0;
						var v:Number = 0.0;
						var blendIndex:int;
						var weight1:Number = 0.0;
						var weight2:Number = 0.0;
						var weight3:Number = 0.0;
						var weight4:Number = 0.0;
						if ( vertexMask == 0 )
						{
							x = data.readFloat();
							y = data.readFloat();
							z = data.readFloat();
							nx = data.readFloat();
							ny = data.readFloat();
							nz = data.readFloat();
							data.readInt();// color
							weight1 = data.readFloat();
							weight2 = data.readFloat();
							weight3 = data.readFloat();
							weight4 = data.readFloat();
							var a:int = data.readInt();
							var b:int = data.readInt();
							var c:int = data.readInt();
							var d:int = data.readInt();
							if ( a >= dShader_Animate.MAX_BONE_MATRIX ) a = -1;
							if ( b >= dShader_Animate.MAX_BONE_MATRIX ) b = -1;
							if ( c >= dShader_Animate.MAX_BONE_MATRIX ) c = -1;
							if ( d >= dShader_Animate.MAX_BONE_MATRIX ) d = -1;
							if ( a == -1 ) weight1 = 0.0;
							if ( b == -1 ) weight2 = 0.0;
							if ( c == -1 ) weight3 = 0.0;
							if ( d == -1 ) weight4 = 0.0;
							if( a != -1 )
								weight1 = 1.0 - weight2 - weight3 - weight4;
							else if ( b != -1 )
								weight2 = 1.0 - weight1 - weight3 - weight4;
							else if ( c != -1 )
								weight3 = 1.0 - weight1 - weight2 - weight4;
							else if ( d != -1 )
								weight4 = 1.0 - weight1 - weight2 - weight3;
							else
								weight1 = 1.0 - weight2 - weight3 - weight4;
							a++; b++; c++; d++;
							blendIndex = a&0xFF;
							blendIndex |= (b&0xFF) << 8;
							blendIndex |= (c&0xFF) << 16;
							blendIndex |= (d & 0xFF) << 24;
							u = data.readFloat();
							data.position = data.position + 7 * 4;
							v = data.readFloat();
							data.position = data.position + 7 * 4;
						}
						else
						{
							a = b = c = d = -1;
							if( vertexMask & (1<<0) )
								x = data.readFloat();
							if( vertexMask & (1<<1) )
								y = data.readFloat();
							if( vertexMask & (1<<2) )
								z = data.readFloat();
							if( vertexMask & (1<<3) )
								nx = data.readFloat();
							if( vertexMask & (1<<4) )
								ny = data.readFloat();
							if( vertexMask & (1<<5) )
								nz = data.readFloat();
							if( vertexMask & (1<<6) )
								data.readInt();// color
							if( vertexMask & (1<<7) )
								weight1 = data.readFloat();// blendweigth
							if( vertexMask & (1<<8) )
								weight2 = data.readFloat();// blendweigth
							if( vertexMask & (1<<9) )
								weight3 = data.readFloat();// blendweigth
							if( vertexMask & (1<<10) )
								weight4 = data.readFloat();// blendweigth
							if( vertexMask & (1<<11) )
								a = data.readInt();// weight index
							if ( vertexMask & (1 << 12) )
								b = data.readInt();
							if ( vertexMask & (1 << 13) )
								c = data.readInt();
							if ( vertexMask & (1 << 14) )
								d = data.readInt();
							if ( a >= dShader_Animate.MAX_BONE_MATRIX ) a = -1;
							if ( b >= dShader_Animate.MAX_BONE_MATRIX ) b = -1;
							if ( c >= dShader_Animate.MAX_BONE_MATRIX ) c = -1;
							if ( d >= dShader_Animate.MAX_BONE_MATRIX ) d = -1;
							if ( a == -1 ) weight1 = 0.0;
							if ( b == -1 ) weight2 = 0.0;
							if ( c == -1 ) weight3 = 0.0;
							if ( d == -1 ) weight4 = 0.0;
							if( a != -1 )
								weight1 = 1.0 - weight2 - weight3 - weight4;
							else if ( b != -1 )
								weight2 = 1.0 - weight1 - weight3 - weight4;
							else if ( c != -1 )
								weight3 = 1.0 - weight1 - weight2 - weight4;
							else if ( d != -1 )
								weight4 = 1.0 - weight1 - weight2 - weight3;
							else
								weight1 = 1.0 - weight2 - weight3 - weight4;
							a++; b++; c++; d++;
							blendIndex = a&0xFF;
							blendIndex |= (b&0xFF) << 8;
							blendIndex |= (c&0xFF) << 16;
							blendIndex |= (d & 0xFF) << 24;
							for ( var j:int = 0 ; j < 8 ; j ++ )
							{
								if ( vertexMask & (1 << (15 + j)) )
								{
									if ( j == 0 ) u = data.readFloat();
									else data.readFloat();
								}
							}
							for ( j = 0 ; j < 8 ; j ++ )
							{
								if ( vertexMask & (1 << (23 + j)) )
								{
									if ( j == 0 ) v = data.readFloat();
									else data.readFloat();
								}
							}
						}
						vecVertex.writeFloat( x );
						vecVertex.writeFloat( y );
						vecVertex.writeFloat( z );
						vecVertex.writeFloat( nx );
						vecVertex.writeFloat( ny );
						vecVertex.writeFloat( nz );
						vecVertex.writeFloat( u );
						vecVertex.writeFloat( v );
						if ( bAnimate )
						{
							vecVertex.writeUnsignedInt( blendIndex );
							vecVertex.writeFloat( weight1 );
							vecVertex.writeFloat( weight2 );
							vecVertex.writeFloat( weight3 );
							vecVertex.writeFloat( weight4 );
						}
					}
					m_pVertexBuffer.UploadVertexBufferFromByteArray( vecVertex );
					var nIndexNum:int = index_num;
					m_pIndexBuffer = new dIndexBuffer( nIndexNum / 3 , pDevice );
					var vecIndex:Vector.<uint> = new Vector.<uint>;
					vecIndex.length = nIndexNum;
					if (use32bitindex == 0)
					{
						for( i = 0 ; i < nIndexNum ; i ++ )
							vecIndex[i] = data.readUnsignedShort();
					}
					else
					{
						for( i = 0 ; i < nIndexNum ; i ++ )
							vecIndex[i] = data.readInt();
					}
					m_pIndexBuffer.UploadIndexBufferFromVector( vecIndex );
				}
				else
				{
					nVertexNum = vecNormalVertexNum[nLodLevel];
					data.position += (31*4)*nVertexNum;
					nIndexNum = vecIndexNum[nLodLevel];
					if (use32bitindex == 0)
						data.position += 2*nIndexNum;
					else
						data.position += 4*nIndexNum;
				}
			}
		}
		public function Release():void
		{
			m_pVertexBuffer.Release();
			m_pIndexBuffer.Release();
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
			m_pVertexBuffer.SetToDevice();
			m_pIndexBuffer.Render();
			return m_pIndexBuffer.GetFaceNum();
		}
		public function GetVertexBuffer():dVertexBuffer
		{
			return m_pVertexBuffer;
		}
		public function GetIndexBuffer():dIndexBuffer
		{
			return m_pIndexBuffer;
		}
	}

}