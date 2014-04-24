//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dcom.dCompleteCallback;
	import dcom.dTimer;
	import dGame3D.Math.dMatrix;
	import dGame3D.Math.dVector3;
	import dGame3D.Math.dVector4;
	import dGame3D.Shader.dShaderBase;
	import dUI._dInterface;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.*;
	import dGame3D.PNGEncoder;
	/**
	 * ...
	 * @author dym
	 */
	public class dTerrain 
	{
		protected var m_pDevice:dDevice;
		protected var m_pVB:dVertexBuffer;
		protected var m_pVBEasy:dVertexBuffer;
		public static const TILE_SIZE:int = 50;
		protected var m_vecTile:Vector.<dTerrainTile> = new Vector.<dTerrainTile>;
		protected var m_nSceneWidth:int;
		protected var m_nSceneHeight:int;
		protected var m_nFileSceneWidth:int;
		protected var m_nFileSceneHeight:int;
		protected var m_nSceneWidthTileNum:int;
		protected var m_nSceneHeightTileNum:int;
		protected var m_vecTextureBitmap:Vector.<BitmapData> = new Vector.<BitmapData>;
		protected var m_vecTexture:Vector.<dTexture> = new Vector.<dTexture>;
		protected var m_pTextureBlendBitmap:BitmapData;
		protected var m_pTextureBlend:dTexture;
		protected var m_pHeightMapBitmap:BitmapData;
		protected var m_vecHeightMapForUpdate:Vector.<Number>;
		protected var m_pCanReachBitmap:BitmapData;
		protected var m_vecIB:Vector.<dTerrainLodIndexBuffer> = new Vector.<dTerrainLodIndexBuffer>;
		protected var m_vecRenderBuffer:Vector.<dTerrainTile> = new Vector.<dTerrainTile>;
		protected var m_nBufferIndex:int;
		protected var m_pTextureShadow:dTexture;
		protected var m_pTextureShadowBitmap:BitmapData;
		protected var m_pCanReachTextureBlend:dTexture;
		protected var m_pCanReachTextureR:dTexture;
		protected var m_pCanReachTextureB:dTexture;
		protected var m_pCanReachTextureNull:dTexture;
		protected var m_pIBEasy:dIndexBuffer;
		protected var m_pGrassBitmap:BitmapData;
		protected var m_pGrassTexture:dTexture;
		public function dTerrain( pDevice:dDevice ) 
		{
			m_pDevice = pDevice;
			m_pVB = new dVertexBuffer( (TILE_SIZE+1) * (TILE_SIZE+1) , "0,FLOAT2,POSITION\n0,FLOAT2,TEXCOORD" , m_pDevice );
			var data:Vector.<Number> = new Vector.<Number>;
			for ( var j:int = 0 ; j < TILE_SIZE + 1 ; j ++ )
			{
				for ( var i:int = 0 ; i < TILE_SIZE + 1 ; i ++ )
				{
					data.push( Number( i ) );
					data.push( Number( j ) );
					data.push( Number( i ) / Number( TILE_SIZE ) );
					data.push( Number( j ) / Number( TILE_SIZE ) );
				}
			}
			m_pVB.UploadVertexBufferFromVector( data );
			m_pVBEasy = new dVertexBuffer( 4 , "0,FLOAT2,POSITION\n0,FLOAT2,TEXCOORD" , m_pDevice );
			data = new Vector.<Number>;
			for ( j = 0 ; j < TILE_SIZE + 1 ; j += TILE_SIZE )
			{
				for ( i = 0 ; i < TILE_SIZE + 1 ; i += TILE_SIZE )
				{
					data.push( Number( i ) );
					data.push( Number( j ) );
					data.push( Number( i ) / Number( TILE_SIZE ) );
					data.push( Number( j ) / Number( TILE_SIZE ) );
				}
			}
			m_pVBEasy.UploadVertexBufferFromVector( data );
			if ( m_pDevice.isSoftware() )
			{
				m_vecIB.length = 1;
				m_vecIB[0] = new dTerrainLodIndexBuffer( m_pDevice , TILE_SIZE , 2 );
			}
			else
			{
				m_vecIB.length = 3;
				for ( i = 0 ; i < m_vecIB.length ; i ++ )
					m_vecIB[i] = new dTerrainLodIndexBuffer( m_pDevice , TILE_SIZE , i );
			}
			m_pIBEasy = new dIndexBuffer( 2 , m_pDevice );
			var dataEasy:Vector.<uint> = new Vector.<uint>;
			dataEasy.push( 2 , 1 , 0 , 3 , 1 , 2 );
			m_pIBEasy.UploadIndexBufferFromVector( dataEasy );
		}
		public function Release():void
		{
			//for ( var i:int = 0 ; i < m_vecTile.length ; i ++ )
			//	m_vecTile[i].Release();// tile已经在scene里释放
			for ( var i:int = 0 ; i < m_vecTexture.length ; i ++ )
				m_vecTexture[i].Release();
			for ( i = 0 ; i < m_vecIB.length ; i ++ )
				m_vecIB[i].Release();
			m_pIBEasy.Release();
			if ( m_pTextureBlend ) m_pTextureBlend.Release();
			if ( m_pTextureShadow ) m_pTextureShadow.Release();
			if ( m_pCanReachTextureBlend ) m_pCanReachTextureBlend.Release();
			if ( m_pCanReachTextureR ) m_pCanReachTextureR.Release();
			if ( m_pCanReachTextureB ) m_pCanReachTextureB.Release();
			if ( m_pCanReachTextureNull ) m_pCanReachTextureNull.Release();
			if ( m_pGrassTexture ) m_pGrassTexture.Release();
			
			m_vecTile = new Vector.<dTerrainTile>;
			m_nSceneWidth = 0;
			m_nSceneHeight = 0;
			m_nSceneWidthTileNum = 0;
			m_nSceneHeightTileNum = 0;
			m_vecTextureBitmap = new Vector.<BitmapData>;
			m_vecTexture = new Vector.<dTexture>;
			m_pTextureBlendBitmap = null;
			m_pTextureBlend = null;
			m_pHeightMapBitmap = null;
			m_vecHeightMapForUpdate = null;
			m_pCanReachBitmap = null;
			m_vecIB = new Vector.<dTerrainLodIndexBuffer>;
			m_vecRenderBuffer = new Vector.<dTerrainTile>;
			m_pTextureShadow = null;
			m_pTextureShadowBitmap = null;
			m_pCanReachTextureBlend = null;
			m_pCanReachTextureR = null;
			m_pCanReachTextureB = null;
			m_pCanReachTextureNull = null;
			m_pGrassTexture = null;
			m_pGrassBitmap = null;
		}
		public function CreateTerrain( width:int , height:int ):void
		{
			m_nSceneWidthTileNum = ( width + TILE_SIZE - 1 )/ TILE_SIZE;
			m_nSceneHeightTileNum = ( height + TILE_SIZE - 1 ) / TILE_SIZE;
			m_nSceneWidth = m_nSceneWidthTileNum * TILE_SIZE;
			m_nSceneHeight = m_nSceneHeightTileNum * TILE_SIZE;
			m_pTextureBlend = new dTexture( m_pDevice );
			m_pTextureBlend.CreateTexture( 512 , 512 );
			m_pTextureBlendBitmap = new BitmapData( 512 , 512 , false , 0x00000000 );
			m_pTextureShadow = new dTexture( m_pDevice );
			m_pTextureShadow.CreateTexture( 512 , 512 );
			m_pTextureShadowBitmap = new BitmapData( 512 , 512 , false , 0 );
			m_pGrassTexture = new dTexture( m_pDevice );
			m_pGrassTexture.LoadFromFile( "grass/grassa.png" );
			m_vecTextureBitmap.length = 4;
			for ( i = 0 ; i < m_vecTextureBitmap.length ; i ++ )
				m_vecTextureBitmap[i] = new BitmapData( 256 , 256 , false , 0xFF008000 );
			m_vecTexture.length = 4;
			for ( i = 0 ; i < m_vecTexture.length ; i ++ )
			{
				m_vecTexture[i] = new dTexture( m_pDevice );
				m_vecTexture[i].CreateTexture( 256 , 256 );
			}
			m_pHeightMapBitmap = new BitmapData( m_nSceneWidth , m_nSceneHeight , false , 0xFF000000 );
			m_pCanReachBitmap = new BitmapData( m_nSceneWidth , m_nSceneHeight , false , 0xFF000000 );
			m_pGrassBitmap = new BitmapData( 128 , 128 , false , 0xFF000000 );
			//GenHeightMap();
			m_vecTile.length = m_nSceneWidthTileNum * m_nSceneHeightTileNum;
			for ( var i:int = 0 ; i < m_vecTile.length ; i ++ )
				m_vecTile[i] = new dTerrainTile( m_pDevice , this , (i % m_nSceneWidthTileNum) * TILE_SIZE , int(i / m_nSceneWidthTileNum) * TILE_SIZE );
			ComputeNeighbor();
			Update( dGame3DSystem.SCENE_UPDATE_ALL );
		}
		public function Resize( newWidth:int , newHeight:int ):void
		{
			/*var nOldWidth:int = m_nSceneWidth;
			var nOldHeight:int = m_nSceneHeight;
			m_nSceneWidthTileNum = ( width + TILE_SIZE - 1 )/ TILE_SIZE;
			m_nSceneHeightTileNum = ( height + TILE_SIZE - 1 ) / TILE_SIZE;
			m_nSceneWidth = m_nSceneWidthTileNum * TILE_SIZE;
			m_nSceneHeight = m_nSceneHeightTileNum * TILE_SIZE;
			m_vecTile.length = m_nSceneWidthTileNum * m_nSceneHeightTileNum;
			
			var pOldHeightMapBitmap:BitmapData = m_pHeightMapBitmap;
			var pOldCanReachBitmap:BitmapData = m_pCanReachBitmap;
			m_pHeightMapBitmap = new BitmapData( m_nSceneWidth , m_nSceneHeight , false , 0xFF000000 );
			m_pCanReachBitmap = new BitmapData( m_nSceneWidth , m_nSceneHeight , false , 0xFF000000 );
			var m:Matrix = new Matrix;
			m.scale( m_nSceneWidth / nOldWidth , m_nSceneHeight / nOldHeight );
			m_pHeightMapBitmap.draw( pOldHeightMapBitmap , m , null , null , null , true );
			m_pCanReachBitmap.draw( pOldCanReachBitmap , m );
			
			m_vecTile.length = m_nSceneWidthTileNum * m_nSceneHeightTileNum;
			for ( var i:int = 0 ; i < m_vecTile.length ; i ++ )
				m_vecTile[i] = new dTerrainTile( m_pDevice , this , (i % m_nSceneWidthTileNum) * TILE_SIZE , int(i / m_nSceneWidthTileNum) * TILE_SIZE );
			Update( dGame3DSystem.SCENE_UPDATE_HEIGHTMAP | dGame3DSystem.SCENE_UPDATE_CANREACH );
			pOldCanReachBitmap.dispose();
			pOldHeightMapBitmap.dispose();*/
		}
		public function SetShowCanReach( bShow:Boolean ):void
		{
			if ( bShow )
			{
				if ( !m_pCanReachTextureR )
				{
					m_pCanReachTextureR = new dTexture( m_pDevice );
					m_pCanReachTextureR.CreateTexture( 16 , 16 , 0x80FF0000 );
				}
				if ( !m_pCanReachTextureB )
				{
					m_pCanReachTextureB = new dTexture( m_pDevice );
					m_pCanReachTextureB.CreateTexture( 16 , 16 , 0x800000FF );
				}
				if ( !m_pCanReachTextureNull )
				{
					m_pCanReachTextureNull = new dTexture( m_pDevice );
					m_pCanReachTextureNull.CreateTexture( 16 , 16 , 0 );
				}
				if ( !m_pCanReachTextureBlend )
				{
					m_pCanReachTextureBlend = new dTexture( m_pDevice );
					m_pCanReachTextureBlend.CreateTexture( 512 , 512 );
					UploadCanReachTexture();
				}
			}
		}
		private function UploadCanReachTexture():void
		{
			if ( m_pCanReachBitmap )
			{
				var pBitmapData:BitmapData = new BitmapData( 512 , 512 , false , 0xFF000000 );
				var mat:Matrix = new Matrix();
				mat.scale( 512.0 / m_pCanReachBitmap.width , 512.0 / m_pCanReachBitmap.height );
				pBitmapData.draw( m_pCanReachBitmap , mat , null , null , null , true );
				m_pCanReachTextureBlend.LoadFromBitmap( _dInterface.iBridge_TransBitmap( pBitmapData ) );
			}
		}
		private function GetTile( x:int , y:int ):dTerrainTile
		{
			if ( !m_vecTile ) return null;
			if ( x < 0 ) x = 0;
			else if ( x > m_nSceneWidthTileNum - 1 ) x = m_nSceneWidthTileNum - 1;
			if ( y < 0 ) y = 0;
			else if ( y > m_nSceneHeightTileNum - 1 ) y = m_nSceneHeightTileNum - 1;
			return m_vecTile[ y * m_nSceneWidthTileNum + x ];
		}
		private function ComputeNeighbor():void
		{
			for ( var j:int = 0 ; j < m_nSceneHeightTileNum ; j ++ )
			{
				for ( var i:int = 0 ; i < m_nSceneWidthTileNum ; i ++ )
				{
					m_vecTile[ j * m_nSceneWidthTileNum + i ].m_pNeighborLeft = GetTile( i - 1 , j );
					m_vecTile[ j * m_nSceneWidthTileNum + i ].m_pNeighborTop = GetTile( i , j - 1 );
					m_vecTile[ j * m_nSceneWidthTileNum + i ].m_pNeighborRight = GetTile( i + 1 , j );
					m_vecTile[ j * m_nSceneWidthTileNum + i ].m_pNeighborBottom = GetTile( i , j + 1 );
				}
			}
		}
		public function Render( vecVisableRenderObjList:Vector.<dRenderObj> , bRenderCanReach:Boolean ):int
		{
			if ( !m_pTextureBlend ) return 0;
			var shader:dShaderBase = m_pDevice.GetShader( dDevice.SHADER_TERRAIN );
			shader.SetToDevice();
			//var fFarPlane:Number = m_pDevice.GetCamera().GetFarPlane();
			//m_pDevice.GetCamera().SetFarPlane( fFarPlane + 100 );
			shader.SetShaderConstantsFloat4( dGame3DSystem.SHADER_UVDATA , new dVector4( 10 , 1 , 1 / m_nSceneWidthTileNum , 1 / m_nSceneHeightTileNum ) );
			shader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_VIEW , m_pDevice.GetCamera().GetView() );
			shader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_PROJ , m_pDevice.GetCamera().GetProj() );
			shader.SetShaderConstantsFloat4( dGame3DSystem.SHADER_LIGHT , m_pDevice.GetGlobalLightDir() );
			//m_pDevice.GetCamera().SetFarPlane( fFarPlane );
			
			if ( bRenderCanReach )
			{
				SetShowCanReach( true );
				m_pCanReachTextureB.SetToDevice( 0 );
				m_pCanReachTextureR.SetToDevice( 1 );
				m_pCanReachTextureR.SetToDevice( 2 );
				m_pCanReachTextureR.SetToDevice( 3 );
				m_pCanReachTextureBlend.SetToDevice( 4 );
				m_pCanReachTextureNull.SetToDevice( 5 );
			}
			else
			{
				for ( var i:int = 0 ; i < 4 ; i ++ )
					m_vecTexture[i].SetToDevice( i );
				m_pTextureBlend.SetToDevice( 4 );
				m_pTextureShadow.SetToDevice( 5 );
			}
			m_pVB.SetToDevice();
			var vEyePt:dVector3 = m_pDevice.GetCamera().GetEye();
			var r:int = 0;
			var vecFustumPlane:Vector.<dVector4> = m_pDevice.GetCamera().GetFustumPlane();
			m_nBufferIndex = 0;
			for ( i = 0 ; i < vecVisableRenderObjList.length ; i ++ )
				if ( vecVisableRenderObjList[i].GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_TILE )
					m_vecRenderBuffer[ m_nBufferIndex++ ] = vecVisableRenderObjList[i] as dTerrainTile;
			var defaultLod:int = 2;
			if ( m_pDevice.isSoftware() ) defaultLod = 0;
			for ( i = 0 ; i < m_nBufferIndex ; i ++ )
			{
				var p:dTerrainTile = m_vecRenderBuffer[i];
				p.m_nLod = defaultLod;
				p.m_pNeighborLeft.m_nLod = defaultLod;
				p.m_pNeighborTop.m_nLod = defaultLod;
				p.m_pNeighborRight.m_nLod = defaultLod;
				p.m_pNeighborBottom.m_nLod = defaultLod;
			}
			var nLod:int;
			if ( !m_pDevice.isSoftware() )
			{
				for ( i = 0 ; i < m_nBufferIndex ; i ++ )
				{
					p = m_vecRenderBuffer[i];
					var vCenter:dVector3 = p.GetAABB().GetCenter();
					var fLen:Number = (vCenter.x - vEyePt.x) * (vCenter.x - vEyePt.x ) + (vCenter.z - vEyePt.z) * (vCenter.z - vEyePt.z);
					nLod = 0;
					if ( fLen > 50 * 50 )
						nLod = 1;
					if ( fLen > 100 * 100 )
						nLod = 2;
					p.m_nLod = nLod;
				}
			}
			for ( i = 0 ; i < m_nBufferIndex ; i ++ )
			{
				p = m_vecRenderBuffer[i];
				nLod = p.m_nLod;
				if ( p.Render( shader ) )
				{
					r += m_vecIB[ nLod ].GetIndexBuffer( p.m_pNeighborLeft.m_nLod < nLod , p.m_pNeighborBottom.m_nLod < nLod ,
						p.m_pNeighborRight.m_nLod < nLod , p.m_pNeighborTop.m_nLod < nLod ).Render();
				}
				else
				{
					m_pVBEasy.SetToDevice();
					r += m_pIBEasy.Render();
					m_pVB.SetToDevice();
				}
			}
			return r;
		}
		public function RenderGrass():int
		{
			m_pDevice.ClearState();
			var nOldCulling:int = m_pDevice.GetCulling();
			m_pDevice.SetCulling( 0 );
			var shader:dShaderBase = m_pDevice.GetShader( dDevice.SHADER_GRASS );
			shader.SetToDevice();
			var world:dMatrix = new dMatrix();
			world.Identity();
			shader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_WORLD , world );
			shader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_VIEW , m_pDevice.GetCamera().GetView() );
			shader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_PROJ , m_pDevice.GetCamera().GetProj() );
			m_pGrassTexture.SetToDevice( 0 );
			var vEye:dVector3 = m_pDevice.GetCamera().GetEye();
			var ret:int = 0;
			for ( var i:int = 0 ; i < m_nBufferIndex ; i ++ )
			{
				var pGrass:dGrass = m_vecRenderBuffer[i].GetGrass();
				if ( pGrass && Math.abs( pGrass.GetPos().x + TILE_SIZE / 2 - vEye.x ) <= TILE_SIZE &&
					 Math.abs( pGrass.GetPos().z + TILE_SIZE / 2 - vEye.z ) <= TILE_SIZE )
				{
					m_vecRenderBuffer[i].InitGrass();
					ret += pGrass.Render( shader );
				}
			}
			m_pDevice.SetCulling( nOldCulling );
			return ret;
		}
		public function GetTileObjs():Vector.<dTerrainTile>
		{
			return m_vecTile;
		}
		public function GetTextureBitmap( index:int ):BitmapData
		{
			if ( index == dGame3DSystem.TERRAIN_BITMAP_TEX1 )
				return m_vecTextureBitmap[ 0 ];
			else if ( index == dGame3DSystem.TERRAIN_BITMAP_TEX2 )
				return m_vecTextureBitmap[ 1 ];
			else if ( index == dGame3DSystem.TERRAIN_BITMAP_TEX3 )
				return m_vecTextureBitmap[ 2 ];
			else if ( index == dGame3DSystem.TERRAIN_BITMAP_TEX4 )
				return m_vecTextureBitmap[ 3 ];
			else if ( index == dGame3DSystem.TERRAIN_BITMAP_BLEND )
				return m_pTextureBlendBitmap;
			else if ( index == dGame3DSystem.TERRAIN_BITMAP_HEIGHTMAP )
				return m_pHeightMapBitmap;
			else if ( index == dGame3DSystem.TERRAIN_BITMAP_CANREACH )
				return m_pCanReachBitmap;
			else if ( index == dGame3DSystem.TERRAIN_BITMAP_SHADOW )
				return m_pTextureShadowBitmap;
			else if ( index == dGame3DSystem.TERRAIN_BITMAP_GRASS )
				return m_pGrassBitmap;
			return null;
		}
		public function GetHeight( x:int , y:int ):Number
		{
			if ( m_vecHeightMapForUpdate == null ) return 0.0;
			if ( x < 0 ) x = 0;
			else if ( x > m_nSceneWidth - 1 ) x = m_nSceneWidth - 1;
			if ( y < 0 ) y = 0;
			else if ( y > m_nSceneHeight - 1 ) y = m_nSceneHeight - 1;
			return m_vecHeightMapForUpdate[ y * m_nSceneWidth + x ];
		}
		public function GetHeightFloat( x:Number , z:Number ):Number
		{
			var kx:int = int( x );
			var ky:int = int( z );
			var l1:Number = x - kx;
			var l2:Number = z - ky;
			var f1:Number = GetHeight( kx , ky );
			var f2:Number = GetHeight( kx + 1 , ky );
			var f3:Number = GetHeight( kx , ky + 1 );
			var f4:Number = GetHeight( kx + 1 , ky + 1 );
			var L1:Number = f1 * (1.0 - l1) + f2 * l1;
			var L2:Number = f3 * (1.0 - l1) + f4 * l1;
			return L1 * (1.0 - l2) + L2 * l2;
		}
		public function GetNormal( x:int , y:int ):dVector3
		{
			if ( x > m_nSceneWidth - 1 ) x = m_nSceneWidth - 1;
			if ( y > m_nSceneHeight - 1 ) y = m_nSceneHeight - 1;
			var vec1:dVector3 = new dVector3( 1 , (GetHeight( x+1 , y ) - GetHeight( x-1 , y )) , 0 );
			var vec2:dVector3 = new dVector3( 0 , (GetHeight( x , y+1 ) - GetHeight( x , y-1 )) , 1 );
			var normal:dVector3 = vec2.Cross( vec1 );
			normal.Normalize();
			return normal;
		}
		public function GetVertexBuffer():dVertexBuffer
		{
			return m_pVB;
		}
		public function GetVertexBufferEasy():dVertexBuffer
		{
			return m_pVBEasy;
		}
		public function GetIndexBuffer( lod:int = 0 ):dIndexBuffer
		{
			return m_vecIB[lod].GetIndexBuffer();
		}
		public function GetIndexBufferEasy():dIndexBuffer
		{
			return m_pIBEasy;
		}
		public function Update( nFlag:int , onComplete:Function = null ):void
		{
			var pComplete:dCompleteCallback = new dCompleteCallback();
			if ( nFlag & dGame3DSystem.SCENE_UPDATE_BLENDTEX )
			{
				for ( var i:int = 0 ; i < m_vecTexture.length ; i ++ )
					m_vecTexture[i].LoadFromBitmap( _dInterface.iBridge_TransBitmap( m_vecTextureBitmap[i] ) );
				m_pTextureBlend.LoadFromBitmap( _dInterface.iBridge_TransBitmap( m_pTextureBlendBitmap ) );
				m_pTextureShadow.LoadFromBitmap( _dInterface.iBridge_TransBitmap( m_pTextureShadowBitmap ) );
			}
			if ( nFlag & dGame3DSystem.SCENE_UPDATE_HEIGHTMAP )
			{
				pComplete.Add();
				GenHeightMap( function():void
				{
					var pThread:dTimer = new dTimer();
					pThread.IntervalFor( 0 , m_vecTile.length , 1 , function( p:dTimer , i:int ):void
					{
						m_vecTile[i].Update();
					} , function( p:dTimer , i:int ):void
					{
						pComplete.DoComplete();
					} );
				});
			}
			if ( nFlag & dGame3DSystem.SCENE_UPDATE_CANREACH )
			{
				if ( m_pCanReachTextureBlend )
				{
					UploadCanReachTexture();
				}
			}
			if ( nFlag & dGame3DSystem.SCENE_UPDATE_GRASS )
			{
				pComplete.Add();
				var pThread2:dTimer = new dTimer();
				pThread2.IntervalFor( 0 , m_vecTile.length , 1 , function( p:dTimer , i:int ):void
				{
					m_vecTile[i].UpdateGrass();
				} , function( p:dTimer , i:int ):void
				{
					pComplete.DoComplete();
				} );
			}
			if ( onComplete != null )
				pComplete.SetCompleteFun( onComplete );
		}
		private function GenHeightMap( onComplete:Function = null ):void
		{
			var vecHeightMap:Vector.<Number> = new Vector.<Number>();
			vecHeightMap.length = m_nSceneWidth * m_nSceneHeight;
			var pThread:dTimer = new dTimer();
			pThread.IntervalFor( 0 , m_nSceneWidth * m_nSceneHeight , 1 , function( p:dTimer , i:int ):void
			{
				var color:uint = m_pHeightMapBitmap.getPixel32( i % m_nSceneWidth , i / m_nSceneWidth );
				vecHeightMap[i] = Number( color & 0x000000FF ) / 255.0 * 100.0;
			} ,
			function( p:dTimer , i:int ):void
			{
				m_vecHeightMapForUpdate = vecHeightMap;
				var pThread2:dTimer = new dTimer();
				pThread2.IntervalFor( 0 , m_nSceneWidth * m_nSceneHeight , 1 , function( p:dTimer , i:int ):void
				{
					var add:Number = 0.0;
					for ( var y:int = -2 ; y <= 2 ; y ++ )
					{
						for ( var x:int = -2 ; x <= 2 ; x ++ )
						{
							add += GetHeight( (i % m_nSceneWidth) + x , (i / m_nSceneWidth) + y );
						}
					}
					vecHeightMap[i] = add / 25.0;
				} ,
				function( p:dTimer , i:int ):void
				{
					if ( onComplete != null ) onComplete();
				} );
			} );
		}
		private var m_nLoadBitmapComplateNum:int;
		protected function LoadBitmap( bmpIndex:int , data:ByteArray , onLoadComplate:Function , nForceWidth:int = -1 , nForceHeight:int = -1 ):void
		{
			m_nLoadBitmapComplateNum++;
			var loader:Loader = new Loader();
			loader.loadBytes( data );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, function( event:Event ):void
			{
				m_nLoadBitmapComplateNum --;
				var bmpData:BitmapData = event.target.content["bitmapData"];
				if ( nForceWidth != -1 && nForceHeight != -1 )
				{
					var p:BitmapData = new BitmapData( nForceWidth , nForceHeight , true , 0 );
					var m:Matrix = new Matrix();
					m.scale( nForceWidth / bmpData.width , nForceHeight / bmpData.height );
					p.draw( bmpData , m );
					bmpData.dispose();
					bmpData = p;
				}
				switch( bmpIndex )
				{
					case dGame3DSystem.TERRAIN_BITMAP_TEX1: m_vecTextureBitmap[0] = bmpData; break;
					case dGame3DSystem.TERRAIN_BITMAP_TEX2: m_vecTextureBitmap[1] = bmpData; break;
					case dGame3DSystem.TERRAIN_BITMAP_TEX3: m_vecTextureBitmap[2] = bmpData; break;
					case dGame3DSystem.TERRAIN_BITMAP_TEX4: m_vecTextureBitmap[3] = bmpData; break;
					case dGame3DSystem.TERRAIN_BITMAP_BLEND: m_pTextureBlendBitmap = bmpData; break;
					case dGame3DSystem.TERRAIN_BITMAP_HEIGHTMAP: m_pHeightMapBitmap = bmpData; break;
					case dGame3DSystem.TERRAIN_BITMAP_CANREACH: m_pCanReachBitmap = bmpData; break;
					case dGame3DSystem.TERRAIN_BITMAP_SHADOW: m_pTextureShadowBitmap = bmpData; break;
					case dGame3DSystem.TERRAIN_BITMAP_GRASS: m_pGrassBitmap = bmpData; break;
				}
				if ( m_nLoadBitmapComplateNum == 0 )
				{
					Update( dGame3DSystem.SCENE_UPDATE_ALL , function():void
					{
						if ( onLoadComplate != null ) onLoadComplate();
					});
				}
			} );
		}
		public function LoadFromBin( data:ByteArray , onLoadComplate:Function , nForceWidth:int = -1 , nForceHeight:int = -1 ):void
		{
			m_pGrassTexture = new dTexture( m_pDevice );
			m_pGrassTexture.LoadFromFile( "grass/grassa.png" );
			
			m_pTextureBlend = new dTexture( m_pDevice );
			m_pTextureBlend.CreateTexture( 512 , 512 );
			m_pTextureShadow = new dTexture( m_pDevice );
			m_pTextureShadow.CreateTexture( 512 , 512 );
			m_vecTextureBitmap.length = 4;
			m_vecTexture.length = 4;
			for ( var i:int = 0 ; i < m_vecTexture.length ; i ++ )
			{
				m_vecTexture[i] = new dTexture( m_pDevice );
				m_vecTexture[i].CreateTexture( 256 , 256 );
			}
			while ( 1 )
			{
				var chunk:int = data.readInt();
				var size:int = data.readInt();
				if ( chunk == PNGEncoder.MakeChunk( "T" , "E" , "N" , "D" ) )
					break;
				else if ( chunk == PNGEncoder.MakeChunk( "T" , "E" , "I" , "F" ) )
				{
					if ( nForceWidth == -1 || nForceHeight == -1 )
					{
						m_nFileSceneWidth = m_nSceneWidth = data.readInt();
						m_nFileSceneHeight = m_nSceneHeight = data.readInt();
						m_nSceneWidthTileNum = m_nSceneWidth / TILE_SIZE;
						m_nSceneHeightTileNum = m_nSceneHeight / TILE_SIZE;
					}
					else
					{
						m_nFileSceneWidth = data.readInt();
						m_nFileSceneHeight = data.readInt();
						m_nSceneWidthTileNum = ( nForceWidth + TILE_SIZE - 1 )/ TILE_SIZE;
						m_nSceneHeightTileNum = ( nForceHeight + TILE_SIZE - 1 ) / TILE_SIZE;
						m_nSceneWidth = m_nSceneWidthTileNum * TILE_SIZE;
						m_nSceneHeight = m_nSceneHeightTileNum * TILE_SIZE;
					}
				}
				else if ( chunk == PNGEncoder.MakeChunk( "T" , "E" , "X" , "1" ) )
				{
					var pBmpData:ByteArray = new ByteArray();
					data.readBytes( pBmpData , 0 , size );
					LoadBitmap( dGame3DSystem.TERRAIN_BITMAP_TEX1 , pBmpData , onLoadComplate );
				}
				else if ( chunk == PNGEncoder.MakeChunk( "T" , "E" , "X" , "2" ) )
				{
					pBmpData = new ByteArray();
					data.readBytes( pBmpData , 0 , size );
					LoadBitmap( dGame3DSystem.TERRAIN_BITMAP_TEX2 , pBmpData , onLoadComplate );
				}
				else if ( chunk == PNGEncoder.MakeChunk( "T" , "E" , "X" , "3" ) )
				{
					pBmpData = new ByteArray();
					data.readBytes( pBmpData , 0 , size );
					LoadBitmap( dGame3DSystem.TERRAIN_BITMAP_TEX3 , pBmpData , onLoadComplate );
				}
				else if ( chunk == PNGEncoder.MakeChunk( "T" , "E" , "X" , "4" ) )
				{
					pBmpData = new ByteArray();
					data.readBytes( pBmpData , 0 , size );
					LoadBitmap( dGame3DSystem.TERRAIN_BITMAP_TEX4 , pBmpData , onLoadComplate );
				}
				else if ( chunk == PNGEncoder.MakeChunk( "B" , "L" , "E" , "D" ) )
				{
					pBmpData = new ByteArray();
					data.readBytes( pBmpData , 0 , size );
					LoadBitmap( dGame3DSystem.TERRAIN_BITMAP_BLEND , pBmpData , onLoadComplate );
				}
				else if ( chunk == PNGEncoder.MakeChunk( "H" , "I" , "M" , "P" ) )
				{
					pBmpData = new ByteArray();
					data.readBytes( pBmpData , 0 , size );
					LoadBitmap( dGame3DSystem.TERRAIN_BITMAP_HEIGHTMAP , pBmpData , onLoadComplate , nForceWidth , nForceHeight );
				}
				else if ( chunk == PNGEncoder.MakeChunk( "R" , "A" , "C" , "H" ) )
				{
					pBmpData = new ByteArray();
					data.readBytes( pBmpData , 0 , size );
					LoadBitmap( dGame3DSystem.TERRAIN_BITMAP_CANREACH , pBmpData , onLoadComplate , nForceWidth , nForceHeight );
				}
				else if ( chunk == PNGEncoder.MakeChunk( "S" , "A" , "D" , "W" ) )
				{
					pBmpData = new ByteArray();
					data.readBytes( pBmpData , 0 , size );
					LoadBitmap( dGame3DSystem.TERRAIN_BITMAP_SHADOW , pBmpData , onLoadComplate , 512 , 512 );
				}
				else if ( chunk == PNGEncoder.MakeChunk( "G" , "R" , "S" , "S" ) )
				{
					pBmpData = new ByteArray();
					data.readBytes( pBmpData , 0 , size );
					LoadBitmap( dGame3DSystem.TERRAIN_BITMAP_GRASS , pBmpData , onLoadComplate );
				}
				else data.position += size;
			}
			if ( !m_pGrassBitmap ) m_pGrassBitmap = new BitmapData( 128 , 128 , false , 0xFF000000 );
			m_vecTile.length = m_nSceneWidthTileNum * m_nSceneHeightTileNum;
			for ( i = 0 ; i < m_vecTile.length ; i ++ )
				m_vecTile[i] = new dTerrainTile( m_pDevice , this , (i % m_nSceneWidthTileNum) * TILE_SIZE , int(i / m_nSceneWidthTileNum) * TILE_SIZE );
			ComputeNeighbor();
			if ( !m_pTextureBlendBitmap ) m_pTextureBlendBitmap = new BitmapData( 512 , 512 , false , 0 );
			if ( !m_pTextureShadowBitmap ) m_pTextureShadowBitmap = new BitmapData( 512 , 512 , false , 0 );
		}
		public function Save():ByteArray
		{
			var data:ByteArray = new ByteArray();
			var tex1:ByteArray = JPGEncoder.encode( m_vecTextureBitmap[0] );
			var tex2:ByteArray = JPGEncoder.encode( m_vecTextureBitmap[1] );
			var tex3:ByteArray = JPGEncoder.encode( m_vecTextureBitmap[2] );
			var tex4:ByteArray = JPGEncoder.encode( m_vecTextureBitmap[3] );
			var pBlend:ByteArray = JPGEncoder.encode( m_pTextureBlendBitmap );
			var pHeightMap:ByteArray = PNGEncoder.encode( m_pHeightMapBitmap );
			var pCanReach:ByteArray = PNGEncoder.encode( m_pCanReachBitmap );
			var pShadow:ByteArray = PNGEncoder.encode( m_pTextureShadowBitmap );
			var pGrass:ByteArray = JPGEncoder.encode( m_pGrassBitmap );
			data.writeInt( PNGEncoder.MakeChunk( "T" , "E" , "I" , "F" ) );// terrain info
			data.writeInt( 4 * 2 );
			data.writeInt( m_nSceneWidth );
			data.writeInt( m_nSceneHeight );
			data.writeInt( PNGEncoder.MakeChunk( "T" , "E" , "X" , "1" ) );
			data.writeInt( tex1.length );
			data.writeBytes( tex1 );
			data.writeInt( PNGEncoder.MakeChunk( "T" , "E" , "X" , "2" ) );
			data.writeInt( tex2.length );
			data.writeBytes( tex2 );
			data.writeInt( PNGEncoder.MakeChunk( "T" , "E" , "X" , "3" ) );
			data.writeInt( tex3.length );
			data.writeBytes( tex3 );
			data.writeInt( PNGEncoder.MakeChunk( "T" , "E" , "X" , "4" ) );
			data.writeInt( tex4.length );
			data.writeBytes( tex4 );
			data.writeInt( PNGEncoder.MakeChunk( "B" , "L" , "E" , "D" ) );
			data.writeInt( pBlend.length );
			data.writeBytes( pBlend );
			data.writeInt( PNGEncoder.MakeChunk( "H" , "I" , "M" , "P" ) );
			data.writeInt( pHeightMap.length );
			data.writeBytes( pHeightMap );
			data.writeInt( PNGEncoder.MakeChunk( "R" , "A" , "C" , "H" ) );
			data.writeInt( pCanReach.length );
			data.writeBytes( pCanReach );
			data.writeInt( PNGEncoder.MakeChunk( "S" , "A" , "D" , "W" ) );
			data.writeInt( pShadow.length );
			data.writeBytes( pShadow );
			data.writeInt( PNGEncoder.MakeChunk( "G" , "R" , "S" , "S" ) );
			data.writeInt( pGrass.length );
			data.writeBytes( pGrass );
			data.writeInt( PNGEncoder.MakeChunk( "T" , "E" , "N" , "D" ) );
			data.writeInt( 0 );
			data.position = 0;
			return data;
		}
		public function GetSceneSizeX():int
		{
			return m_nSceneWidth;
		}
		public function GetSceneSizeZ():int
		{
			return m_nSceneHeight;
		}
		public function GetFileSceneSizeX():int
		{
			return m_nFileSceneWidth;
		}
		public function GetFileSceneSizeZ():int
		{
			return m_nFileSceneHeight;
		}
		public function GetCanReach( x:int , z:int ):int
		{
			if ( m_pCanReachBitmap && x >= 0 && x < m_nSceneWidth && z >= 0 && z < m_nSceneHeight )
			{
				var c:uint = m_pCanReachBitmap.getPixel32( x , z ) & 0x00FFFFFF;
				return int( c != 0 );
			}
			return -1;
		}
		public function GetGrassData( x:int , z:int ):Vector.<dGrassData>
		{
			var ret:Vector.<dGrassData> = new Vector.<dGrassData>;
			if ( !m_pGrassBitmap ) return ret;
			var i:int = 0;
			var pShadow:BitmapData = GetTextureBitmap( dGame3DSystem.TERRAIN_BITMAP_SHADOW );
			for ( var ty:int = z ; ty < z + TILE_SIZE ; ty ++ )
			{
				for ( var tx:int = x ; tx < x + TILE_SIZE ; tx ++ )
				{
					var nColor:int = ( m_pGrassBitmap.getPixel32( tx * m_pGrassBitmap.width / GetSceneSizeX() , ty * m_pGrassBitmap.height / GetSceneSizeZ() ) & 0x00FF0000 ) >> 16;
					if ( nColor >= int( Math.random()*256 ) )
					{
						for ( var j:int = 0 ; j < nColor / 64 ; j ++ )
						{
							ret[i] = new dGrassData();
							ret[i].x = tx + Math.random() - 0.5;
							ret[i].z = ty + Math.random() - 0.5;
							ret[i].y = GetHeightFloat( ret[i].x , ret[i].z );
							ret[i].fRotation = Math.random() * 3.14159;
							ret[i].nTexID = int(Math.random() * 4) % 3;
							ret[i].nColor = 0xFFFFFFFF;
							if ( pShadow.getPixel32( ret[i].x * pShadow.width / GetSceneSizeX() , ret[i].z * pShadow.height / GetSceneSizeZ() ) != 0 )
								ret[i].nColor = 0xFF808080;
							i ++;
						}
					}
				}
			}
			return ret;
		}
	}

}