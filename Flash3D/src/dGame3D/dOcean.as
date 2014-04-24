//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dcom.dTimer;
	import dGame3D.Math.dBoundingBox;
	import dGame3D.Math.dVector2;
	import dGame3D.Math.dVector3;
	import dGame3D.Math.dVector4;
	import dGame3D.Shader.dShaderBase;
	/**
	 * ...
	 * @author dym
	 */
	public class dOcean extends dRenderObj
	{
		protected var m_pVB:dVertexBuffer;
		protected var m_pIB:dIndexBuffer;
		protected var m_pVBEdge:dVertexBuffer;
		protected var m_pIBEdge:dIndexBuffer;
		protected var m_pTexture:dTexture;
		protected var m_pTextureEdge:dTexture;
		public function dOcean( pDevice:dDevice ) 
		{
			super( pDevice , dGame3DSystem.RENDEROBJ_TYPE_OCEAN );
		}
		override public function Release():void
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
			if ( m_pVBEdge )
			{
				m_pVBEdge.Release();
				m_pVBEdge = null;
			}
			if ( m_pIBEdge )
			{
				m_pIBEdge.Release();
				m_pIBEdge = null;
			}
		}
		private function isQuadAOcean( x:int , z:int , h:Number ):Boolean
		{
			var pScene:dScene = m_pDevice.GetScene();
			if ( pScene.GetHeight( x , z ) > h &&
				 pScene.GetHeight( x + 1 , z ) > h &&
				 pScene.GetHeight( x , z + 1 ) > h &&
				 pScene.GetHeight( x + 1 , z + 1 ) > h )
				 return false;
			return true;
		}
		public function Create( vPos:dVector3 ):void
		{
			m_vPos.Copy( vPos );
			SetYOffset( 0 );
			var pScene:dScene = m_pDevice.GetScene();
			var vecDataGrid:Vector.< Vector.<int> > = new Vector.< Vector.<int> >;
			var nSceneX:int = pScene.GetTerrain().GetSceneSizeX();
			var nSceneY:int = pScene.GetTerrain().GetSceneSizeZ();
			vecDataGrid.length = nSceneX;
			for ( var i:int = 0 ; i < nSceneY ; i ++ )
			{
				vecDataGrid[i] = new Vector.<int>;
				vecDataGrid[i].length = nSceneX;
			}
			var arr:Array = new Array();
			arr.push( new dVector2( int( vPos.x ) , int( vPos.z ) ) );
			vecDataGrid[arr[0].y][arr[0].x] = -1;
			for ( i = 0 ; i < arr.length ; )
			{
				if ( arr[i].x > 0 && vecDataGrid[arr[i].y][arr[i].x - 1] == 0 && isQuadAOcean( arr[i].x - 1 , arr[i].y , vPos.y ) )
				{
					arr.push( new dVector2( arr[i].x - 1 , arr[i].y ) );
					vecDataGrid[arr[i].y][arr[i].x - 1] = -1;
				}
				if ( arr[i].x < nSceneX - 1 && vecDataGrid[arr[i].y][arr[i].x + 1] == 0 && isQuadAOcean( arr[i].x + 1 , arr[i].y , vPos.y ) )
				{
					arr.push( new dVector2( arr[i].x + 1 , arr[i].y ) );
					vecDataGrid[arr[i].y][arr[i].x + 1] = -1;
				}
				if ( arr[i].y > 0 && vecDataGrid[arr[i].y - 1][arr[i].x] == 0 && isQuadAOcean( arr[i].x , arr[i].y - 1 , vPos.y ) )
				{
					arr.push( new dVector2( arr[i].x , arr[i].y - 1 ) );
					vecDataGrid[arr[i].y - 1][arr[i].x] = -1;
				}
				if ( arr[i].y < nSceneY - 1 && vecDataGrid[arr[i].y + 1][arr[i].x] == 0 && isQuadAOcean( arr[i].x , arr[i].y + 1 , vPos.y ) )
				{
					arr.push( new dVector2( arr[i].x , arr[i].y + 1 ) );
					vecDataGrid[arr[i].y + 1][arr[i].x] = -1;
				}
				arr.splice( i , 1 );
			}
			var vecVBData:Vector.<Number> = new Vector.<Number>;
			var vecIBData:Vector.<uint> = new Vector.<uint>;
			var nMinX:int = nSceneX;
			var nMaxX:int = 0;
			var nMinY:int = nSceneY;
			var nMaxY:int = 0;
			var nVBIndex:int = 0;
			var nLastRightUp:int;
			for ( var j:int = 0 ; j < nSceneY ; j ++ )
			{
				for ( i = 0 ; i < nSceneX ; i ++ )
				{
					if ( vecDataGrid[j][i] != 0 )
					{
						for ( var k:int = i + 1; k < nSceneX ; k ++ )
							if ( vecDataGrid[j][k] == 0 )
								break;
						if ( nMinX > i ) nMinX = i;
						if ( nMaxX < k ) nMaxX = k;
						if ( nMinY > j ) nMinY = j;
						if ( nMaxY < j + 1 ) nMaxY = j + 1;
						var nLeftDown:int;
						var nRightUp:int;
						var uvScale:Number = 5.0;
						nVBIndex = vecIBData.length / 3 * 2;
						//if ( i > 0 && vecDataGrid[j][i - 1] > 0 )
						//	vecIBData.push( nLastRightUp );
						//else
						{
							vecVBData.push( i );
							vecVBData.push( vPos.y );
							vecVBData.push( j );
							vecVBData.push( i/uvScale );// u
							vecVBData.push( j/uvScale );// v
							vecVBData.push( 0.5 );// color
							vecIBData.push( nVBIndex );// 左上|^
						}
						
						//if ( j > 0 && vecDataGrid[j - 1][i] > 0 )
						//{
						//	vecIBData.push( vecDataGrid[j - 1][i] - 1 );
						//	nRightUp = vecDataGrid[j - 1][i] - 1;
						//}
						//else
						{
							vecVBData.push( k );
							vecVBData.push( vPos.y );
							vecVBData.push( j );
							vecVBData.push( k/uvScale );// u
							vecVBData.push( j/uvScale );// v
							vecVBData.push( 0.5 );// color
							vecIBData.push( nVBIndex + 1);// 右上 ^|
							nRightUp = nVBIndex + 1;
						}
						
						//if ( i > 0 && vecDataGrid[j][i - 1] > 0 )
						//{
						//	vecIBData.push( vecDataGrid[j][i - 1] - 1 );
						//	nLeftDown = vecDataGrid[j][i - 1] - 1;
						//}
						//else
						{
							vecVBData.push( i );
							vecVBData.push( vPos.y );
							vecVBData.push( j + 1 );
							vecVBData.push( i/uvScale );// u
							vecVBData.push( (j + 1)/uvScale );// v
							vecVBData.push( 0.5 );// color
							vecIBData.push( nVBIndex + 2);// 左下 |_
							nLeftDown = nVBIndex + 2;
						}
						
						vecIBData.push( nLeftDown );// 左下 |_
						vecIBData.push( nRightUp );// 右上 ^|
						
						vecVBData.push( k );
						vecVBData.push( vPos.y );
						vecVBData.push( j + 1 );
						vecVBData.push( k/uvScale );// u
						vecVBData.push( (j + 1)/uvScale );// v
						vecVBData.push( 0.5 );// color
						vecIBData.push( nVBIndex + 3);// 右下 _|
						//vecDataGrid[j][i] = nVBIndex;
						nLastRightUp = nRightUp;
						i = k - 1;
						if ( nVBIndex >= 65530 ) break;
					}
				}
				if ( nVBIndex >= 65530 ) break;
			}
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
			if ( vecVBData.length && vecVBData.length / 3 <= 65535 )
			{
				m_pVB = new dVertexBuffer( vecVBData.length / 6 , "0,FLOAT3,POSITION\n0,FLOAT3,TEXCOORD" , m_pDevice );
				m_pVB.UploadVertexBufferFromVector( vecVBData );
				m_pIB = new dIndexBuffer( vecIBData.length / 3 , m_pDevice );
				m_pIB.UploadIndexBufferFromVector( vecIBData );
				SetBoundingBox( new dBoundingBox( nMinX , vPos.y , nMinY , nMaxX , vPos.y + 0.001 , nMaxY ) );
			}
			// 水边缘
			vecVBData.length = 0;
			vecIBData.length = 0;
			var buf:Array = [0, -1, 0, 1, -1, 0, 1, 0, -1, -1, -1, 1, 1, -1, 1, 1];
			for ( j = 0 ; j < nSceneY ; j ++ )
			{
				for ( i = 0 ; i < nSceneX ; i ++ )
				{
					if ( vecDataGrid[j][i] == -1 )
					{
						if ( isGridEdge( vecDataGrid , i , j , nSceneX , nSceneY ) )
						{
							vecDataGrid[j][i] = 1;
							var list:Vector.<dVector2> = new Vector.<dVector2>;
							var v2:dVector2 = new dVector2( i , j );
							while ( v2 )
							{
								list.push( v2 );
								v2 = Edging( buf , vecDataGrid , v2.x , v2.y , nSceneX , nSceneY );
							}
							GenEdge( list , vecVBData , vecIBData , vPos.y );
						}
					}
				}
			}
			if ( m_pVBEdge )
			{
				m_pVBEdge.Release();
				m_pVBEdge = null;
			}
			if ( m_pIBEdge )
			{
				m_pIBEdge.Release();
				m_pIBEdge = null;
			}
			if ( vecVBData.length && vecVBData.length / 3 <= 65535 )
			{
				m_pVBEdge = new dVertexBuffer( vecVBData.length / 6 , "0,FLOAT3,POSITION\n0,FLOAT3,TEXCOORD" , m_pDevice );
				m_pVBEdge.UploadVertexBufferFromVector( vecVBData );
				m_pIBEdge = new dIndexBuffer( vecIBData.length / 3 , m_pDevice );
				m_pIBEdge.UploadIndexBufferFromVector( vecIBData );
			}
		}
		protected function GenEdge( list:Vector.<dVector2> , vecVBData:Vector.<Number> , vecIBData:Vector.<uint> , fHeight:Number ):void
		{
			var dirs:Vector.<dVector3> = new Vector.<dVector3>;
			dirs.length = list.length;
			var vCrossTmp1:dVector3 = new dVector3( 0.0 , 1.0 , 0.0 );
			var vCrossTmp2:dVector3 = new dVector3( 0.0 , -1.0 , 0.0 );
			for ( var i:int = 1 ; i < list.length - 1; i ++ )
			{
				var v3:dVector3 = new dVector3( list[i - 1].x - list[i + 1].x , 0.0 , list[i - 1].y - list[i + 1].y );
				v3.Normalize();
				dirs[i] = v3.Cross( vCrossTmp1 );
			}
			for ( i = 0 ; i < dirs.length ; i ++ )
			{
				
			}
			var length:Number = 0.0;
			for ( var k:int = 1 ; k < list.length - 1 ; k ++ )
			{
				if ( list[k].x != list[k + 1].x && list[k].y != list[k + 1].y )
					length += 1.414;
				else length += 1.0;
				if ( length >= 3.0 )
				{
					length -= 3.0;
					var cross1:dVector3 = dirs[k].Cross( vCrossTmp1.Mul( 2 ) );
					var cross2:dVector3 = dirs[k].Cross( vCrossTmp2.Mul( 2 ) );
					var nVBIndex:int = vecIBData.length / 3 * 2;
					var vCross1:dVector3 = cross1.Add( dirs[k].Mul( 0.7 ) );
					var vCross2:dVector3 = cross2.Add( dirs[k].Mul( 0.7 ) );
					var vCross3:dVector3 = cross1.Sub( dirs[k].Mul( 2.2 ) );
					var vCross4:dVector3 = cross2.Sub( dirs[k].Mul( 2.2 ) );
					var x:Number = list[k].x;
					var y:Number = list[k].y;

					var rnd:Number = 0.0;// Math.random() * 2.0;
					vecVBData.push( x + vCross1.x );
					vecVBData.push( fHeight );
					vecVBData.push( y + vCross1.z );
					vecVBData.push( 0.0 );// u
					vecVBData.push( -0.5 );// v
					vecVBData.push( rnd );
					vecIBData.push( nVBIndex );// 左上|^
				
					vecVBData.push( x + vCross2.x );
					vecVBData.push( fHeight );
					vecVBData.push( y + vCross2.z );
					vecVBData.push( 1.0 );// u
					vecVBData.push( -0.5 );// v
					vecVBData.push( rnd );
					vecIBData.push( nVBIndex + 1);// 右上 ^|
					var nRightUp:int = nVBIndex + 1;
				
					vecVBData.push( x + vCross3.x );
					vecVBData.push( fHeight );
					vecVBData.push( y + vCross3.z );
					vecVBData.push( 0.0 );// u
					vecVBData.push( 1.5 );// v
					vecVBData.push( rnd );
					vecIBData.push( nVBIndex + 2);// 左下 |_
					var nLeftDown:int = nVBIndex + 2;
					
					vecIBData.push( nLeftDown );// 左下 |_
					vecIBData.push( nRightUp );// 右上 ^|
					
					vecVBData.push( x + vCross4.x );
					vecVBData.push( fHeight );
					vecVBData.push( y + vCross4.z );
					vecVBData.push( 1.0 );// u
					vecVBData.push( 1.5 );// v
					vecVBData.push( rnd );
					vecIBData.push( nVBIndex + 3 );// 右下 _|
				}
			}
		}
		protected function Edging( buf:Array , vecDataGrid:Vector.< Vector.<int> > , x:int , y:int , nSceneX:int , nSceneY:int ):dVector2
		{
			for ( var i:int = 0 ; i < 16 ; i += 2 )
			{
				if ( vecDataGrid[y+buf[i+1]][x+buf[i]] == -1 && isGridEdge( vecDataGrid , x+buf[i] , y +buf[i+1], nSceneX , nSceneY ) )
				{
					vecDataGrid[y+buf[i+1]][x+buf[i]] = 1;
					return new dVector2( x+buf[i] , y+buf[i+1] );
				}
			}
			return null;
		}
		protected function isGridEdge( vecDataGrid:Vector.< Vector.<int> > , x:int , y:int , nSceneX:int , nSceneY:int ):Boolean
		{
			if ( x <= 0 || y <= 0 || x >= nSceneX - 1 || y >= nSceneY - 1 ) return false;
			if ( vecDataGrid[y][x] == 0 ) return false;
			if ( vecDataGrid[y][x - 1] == 0 ) return true;
			if ( vecDataGrid[y][x + 1] == 0 ) return true;
			if ( vecDataGrid[y - 1][x] == 0 ) return true;
			if ( vecDataGrid[y + 1][x] == 0 ) return true;
			return false;
		}
		/*override public function SetPos( vPos:dVector3 ):void
		{
			super.SetPos( vPos );
			Create( new dVector3( m_vPos.x , m_vPos.y + m_fYOffset , m_vPos.z ) );
		}
		override public function SetYOffset( fY:Number ):void
		{
			super.SetYOffset( fY );
			Create( new dVector3( m_vPos.x , m_vPos.y + m_fYOffset , m_vPos.z ) );
		}*/
		public function Update():void
		{
			Create( new dVector3( m_vPos.x , m_vPos.y + m_fYOffset , m_vPos.z ) );
		}
		override public function CheckCollectionRay( vPos:dVector3 , vDir:dVector3 , vPosOut:dVector3 ):Boolean
		{
			if ( !m_bHandleMouse ) return false;
			if ( GetAABB().isCollectionRay( vPos , vDir ) )
			{
				if ( !m_pIB )
				{
					vPosOut.Copy( m_vPos );
					return true;
				}
				if( CheckCollectionMeshIntersect( m_pVB , m_pVB , m_pVB ,
					m_pIB.GetIndexData() , vPos , vDir , vPosOut , GetWorldMatrix() , false ) )
				{
					vPosOut.Copy( m_vPos );
					return true;
				}
				return false;
			}
			return false;
		}
		public function SetTexture( pWater:dTexture , pSpray:dTexture ):void
		{
			m_pTexture = pWater;
			m_pTextureEdge = pSpray;
		}
		override public function Render( shader:dShaderBase ):int
		{
			if ( !m_pVB ) return 0;
			m_pDevice.SetBlendFactor( 0 );
			var fTime:Number = Number( dTimer.GetTickCount() ) / 3000.0;
			var vUVOffset:dVector4 = new dVector4( 0.0 , 0.0 , 1.0 , 2.0 );
			vUVOffset.x = fTime*0.3;
			vUVOffset.y = fTime*0.3;
			shader.SetToDevice( 0 );
			shader.SetShaderConstantsFloat4( dGame3DSystem.SHADER_UVDATA , vUVOffset );
			m_pTexture.SetToDevice( 0 );
			m_pVB.SetToDevice();
			var ret:int = m_pIB.Render();
			if ( m_pVBEdge )
			{
				m_pDevice.SetBlendFactor( 1 );
				m_pTextureEdge.SetToDevice( 0 );
				for ( var i:int = 0 ; i < 2 ; i ++ )
				{
					vUVOffset.x = 0.0;
					vUVOffset.y = (fTime % 2.0) - 1.0;
					if ( vUVOffset.y < 0.0 )
						vUVOffset.z = vUVOffset.y + 1.0;
					else vUVOffset.z = (1.0 - vUVOffset.y) * (1.0 - vUVOffset.y);
					if ( vUVOffset.y > 0.0 ) vUVOffset.y = vUVOffset.y * (1.0 - vUVOffset.y);
					shader.SetToDevice( 1 );
					shader.SetShaderConstantsFloat4( dGame3DSystem.SHADER_UVDATA , vUVOffset );
					m_pVBEdge.SetToDevice();
					ret += m_pIBEdge.Render();
					fTime += 1.0;
				}
			}
			return ret;
		}
	}

}