//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Math.dMatrix;
	import dGame3D.Math.dVector3;
	import dGame3D.Shader.dShaderBase;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author dym
	 */
	public class dTerrainTile extends dRenderObj
	{
		protected var m_pTerrain:dTerrain;
		protected var m_pVB:dVertexBuffer;
		public var m_pNeighborLeft:dTerrainTile;
		public var m_pNeighborTop:dTerrainTile;
		public var m_pNeighborRight:dTerrainTile;
		public var m_pNeighborBottom:dTerrainTile;
		public var m_nLod:int;
		protected var m_bVBEasy:Boolean = false;
		protected var m_pGrass:dGrass;
		protected var m_bNeedInitGrass:Boolean;
		public function dTerrainTile( pDevice:dDevice , pTerrain:dTerrain , x:Number , y:Number ) 
		{
			super( pDevice , dGame3DSystem.RENDEROBJ_TYPE_TILE );
			m_pTerrain = pTerrain;
			SetPos( new dVector3( x , 0.0 , y ) );
			m_pGrass = new dGrass( pDevice , pTerrain , x , y );
		}
		override public function Release():void
		{
			if ( m_pVB ) m_pVB.Release();
			if ( m_pGrass ) m_pGrass.Release();
		}
		override public function Render( shader:dShaderBase ):int
		{
			if ( m_pVB )
			{
				m_pVB.SetToDevice( 2 );
				shader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_WORLD , GetWorldMatrix() );
			}
			else
			{
				Update( true );
			}
			return int( !m_bVBEasy );
		}
		protected function CreateVB( bEasy:Boolean ):void
		{
			if ( !m_pVB || m_bVBEasy != bEasy )
			{
				if ( m_pVB ) m_pVB.Release();
				m_bVBEasy = bEasy;
				if ( bEasy )
					m_pVB = new dVertexBuffer( 4 , "1,FLOAT1,POSITION\n1,FLOAT3,NORMAL" , m_pDevice );
				else
					m_pVB = new dVertexBuffer( (dTerrain.TILE_SIZE + 1) * (dTerrain.TILE_SIZE + 1) , "1,FLOAT1,POSITION\n1,FLOAT3,NORMAL" , m_pDevice );
			}
		}
		protected function UpdateBoundingBox():void
		{
			var minY:Number = m_pTerrain.GetHeight( m_matWorld._41 , m_matWorld._43 );
			var maxY:Number = minY;
			var data:Vector.<Number> = new Vector.<Number>;
			for ( var j:int = 0 ; j < dTerrain.TILE_SIZE + 1 ; j ++ )
			{
				for ( var i:int = 0 ; i < dTerrain.TILE_SIZE + 1 ; i ++ )
				{
					var h:Number = m_pTerrain.GetHeight( m_matWorld._41 + i , m_matWorld._43 + j );
					if ( minY > h ) minY = h;
					if ( maxY < h ) maxY = h;
					data.push( h );
					var normal:dVector3 = m_pTerrain.GetNormal( m_matWorld._41 + i , m_matWorld._43 + j );
					data.push( normal.x );// normal
					data.push( normal.y );
					data.push( normal.z );
				}
			}
			m_vBoundingBox.y1 = minY;
			m_vBoundingBox.y2 = maxY;
			m_vBoundingBox.x2 = dTerrain.TILE_SIZE;
			m_vBoundingBox.z2 = dTerrain.TILE_SIZE;
			SetBoundingBox( m_vBoundingBox );
		}
		public function UpdateGrass():void
		{
			m_bNeedInitGrass = true;
		}
		public function Update( bCreate:Boolean = false ):void
		{
			if ( !m_pVB && !bCreate )
			{
				UpdateBoundingBox();
				return;
			}
			m_bNeedInitGrass = true;
			var minY:Number = m_pTerrain.GetHeight( m_matWorld._41 , m_matWorld._43 );
			var maxY:Number = minY;
			var data:Vector.<Number> = new Vector.<Number>;
			for ( var j:int = 0 ; j < dTerrain.TILE_SIZE + 1 ; j ++ )
			{
				for ( var i:int = 0 ; i < dTerrain.TILE_SIZE + 1 ; i ++ )
				{
					var h:Number = m_pTerrain.GetHeight( m_matWorld._41 + i , m_matWorld._43 + j );
					if ( minY > h ) minY = h;
					if ( maxY < h ) maxY = h;
					data.push( h );
					var normal:dVector3 = m_pTerrain.GetNormal( m_matWorld._41 + i , m_matWorld._43 + j );
					data.push( normal.x );// normal
					data.push( normal.y );
					data.push( normal.z );
				}
			}
			CreateVB( minY == maxY );
			if ( m_bVBEasy )
			{
				data = new Vector.<Number>;
				for ( j = 0 ; j < dTerrain.TILE_SIZE + 1 ; j += dTerrain.TILE_SIZE )
				{
					for ( i = 0 ; i < dTerrain.TILE_SIZE + 1 ; i += dTerrain.TILE_SIZE )
					{
						h = m_pTerrain.GetHeight( m_matWorld._41 + i , m_matWorld._43 + j );
						data.push( h );
						normal = m_pTerrain.GetNormal( m_matWorld._41 + i , m_matWorld._43 + j );
						data.push( normal.x );// normal
						data.push( normal.y );
						data.push( normal.z );
					}
				}
			}
			m_pVB.UploadVertexBufferFromVector( data );
			m_vBoundingBox.y1 = minY;
			m_vBoundingBox.y2 = maxY;
			m_vBoundingBox.x2 = dTerrain.TILE_SIZE;
			m_vBoundingBox.z2 = dTerrain.TILE_SIZE;
			SetBoundingBox( m_vBoundingBox );
		}
		override public function CheckCollectionRay( vPos:dVector3 , vDir:dVector3 , vPosOut:dVector3 ):Boolean
		{
			if ( super.CheckCollectionRay( vPos , vDir , vPosOut ) && m_pVB )
			{
				if ( m_bVBEasy )
					return CheckCollectionMeshIntersect( m_pTerrain.GetVertexBufferEasy() , m_pVB , m_pTerrain.GetVertexBufferEasy() ,
						m_pTerrain.GetIndexBufferEasy().GetIndexData() , vPos , vDir , vPosOut , GetWorldMatrix() );
				else
					return CheckCollectionMeshIntersect( m_pTerrain.GetVertexBuffer() , m_pVB , m_pTerrain.GetVertexBuffer() ,
						m_pTerrain.GetIndexBuffer().GetIndexData() , vPos , vDir , vPosOut , GetWorldMatrix() );
			}
			return false;
		}
		public function InitGrass():void
		{
			if ( m_bNeedInitGrass )
			{
				m_bNeedInitGrass = false;
				m_pGrass.Init();
			}
		}
		public function GetGrass():dGrass
		{
			return m_pGrass;
		}
	}

}