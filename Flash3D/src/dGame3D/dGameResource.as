//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Math.dColorTransform;
	/**
	 * ...
	 * @author dym
	 */
	public class dGameResource 
	{
		protected var m_pDevice:dDevice;
		protected var m_arrMeshBuffer:Array = new Array();
		protected var m_arrEffectBuffer:Array = new Array();
		protected var m_arrAnimationBuffer:Array = new Array();
		public function dGameResource( pDevice:dDevice ) 
		{
			m_pDevice = pDevice;
		}
		public function LoadMesh( strFileName:String , onLoadOK:Function , bAnimate:Boolean , pColorTransform:dColorTransform ):void
		{
			var strBufferName:String = strFileName;
			if ( pColorTransform ) strBufferName += "/" + pColorTransform.toString();
			var p:dGameResourceData = m_arrMeshBuffer[ strBufferName ] as dGameResourceData;
			if ( p != null )
			{
				if ( p.m_bLoading )
				{
					p.m_vecCallback.push( onLoadOK );
				}
				else
				{
					onLoadOK( p.m_pData );
				}
			}
			else
			{
				m_arrMeshBuffer[ strBufferName ] = new dGameResourceData;
				var pMesh:dMeshFile = new dMeshFile( m_pDevice );
				m_arrMeshBuffer[ strBufferName ].m_pData = pMesh;
				m_arrMeshBuffer[ strBufferName ].m_vecCallback = new Vector.<Function>;
				m_arrMeshBuffer[ strBufferName ].m_vecCallback.push( onLoadOK );
				var pArr:Array = m_arrMeshBuffer;
				pMesh.LoadFromFile( strFileName , function():void
				{
					p = pArr[ strBufferName ] as dGameResourceData;
					if ( p.m_pData )
					{
						for ( var i:int = 0 ; i < p.m_vecCallback.length ; i ++ )
							p.m_vecCallback[i]( p.m_pData );
						p.m_bLoading = false;
						p.m_vecCallback = null;
					}
				} , bAnimate , pColorTransform );
			}
		}
		public function LoadEffect( strFileName:String , onLoadOK:Function ):void
		{
			var p:dGameResourceData = m_arrEffectBuffer[ strFileName ] as dGameResourceData;
			if ( p != null )
			{
				if ( p.m_bLoading )
				{
					p.m_vecCallback.push( onLoadOK );
				}
				else
				{
					onLoadOK( p.m_pData );
				}
			}
			else
			{
				m_arrEffectBuffer[ strFileName ] = new dGameResourceData;
				var pMesh:dEffectFile = new dEffectFile( m_pDevice );
				m_arrEffectBuffer[ strFileName ].m_pData = pMesh;
				m_arrEffectBuffer[ strFileName ].m_vecCallback = new Vector.<Function>;
				m_arrEffectBuffer[ strFileName ].m_vecCallback.push( onLoadOK );
				var pArr:Array = m_arrEffectBuffer;
				pMesh.LoadFromFile( strFileName , function():void
				{
					p = pArr[ strFileName ] as dGameResourceData;
					if ( p.m_pData )
					{
						for ( var i:int = 0 ; i < p.m_vecCallback.length ; i ++ )
							p.m_vecCallback[i]( p.m_pData );
						p.m_bLoading = false;
						p.m_vecCallback = null;
					}
				} );
			}
		}
		public function LoadAnimation( strFileName:String , onLoadOK:Function ):void
		{
			var p:dGameResourceData = m_arrAnimationBuffer[ strFileName ] as dGameResourceData;
			if ( p != null )
			{
				if ( p.m_bLoading )
				{
					p.m_vecCallback.push( onLoadOK );
				}
				else
				{
					onLoadOK( p.m_pData );
				}
			}
			else
			{
				m_arrAnimationBuffer[ strFileName ] = new dGameResourceData;
				var pMesh:dMeshFileAnimation = new dMeshFileAnimation( m_pDevice );
				m_arrAnimationBuffer[ strFileName ].m_pData = pMesh;
				m_arrAnimationBuffer[ strFileName ].m_vecCallback = new Vector.<Function>;
				m_arrAnimationBuffer[ strFileName ].m_vecCallback.push( onLoadOK );
				var pArr:Array = m_arrAnimationBuffer;
				pMesh.LoadFromFile( strFileName , function():void
				{
					var p:dGameResourceData = pArr[ strFileName ] as dGameResourceData;
					if ( p.m_pData )
					{
						for ( var i:int = 0 ; i < p.m_vecCallback.length ; i ++ )
							p.m_vecCallback[i]( p.m_pData );
						p.m_bLoading = false;
						p.m_vecCallback = null;
					}
				} );
			}
		}
		public function ClearResourceBuffer( vecNoDeleteList:Vector.<String> = null ):void
		{
			var arrNoDeleteList:Array = new Array();
			if ( vecNoDeleteList )
			{
				for ( var i:int = 0 ; i < vecNoDeleteList.length ; i ++ )
					arrNoDeleteList[ vecNoDeleteList[i] ] = 1;
			}
			var arrNewMeshBuffer:Array = new Array();
			for ( var str:String in m_arrMeshBuffer )
			{
				if ( arrNoDeleteList[str] != null )
					arrNewMeshBuffer[str] = m_arrMeshBuffer[str];
				else
					( m_arrMeshBuffer[str].m_pData as dMeshFile ).Release();
			}
			m_arrMeshBuffer = arrNewMeshBuffer;
			
			var arrNewEffectBuffer:Array = new Array();
			for ( str in m_arrEffectBuffer )
			{
				if ( arrNoDeleteList[str] != null )
					arrNewEffectBuffer[str] = m_arrEffectBuffer[str];
				else
					( m_arrEffectBuffer[str].m_pData as dEffectFile ).Release();
			}
			m_arrEffectBuffer = arrNewEffectBuffer;
			
			var arrNewAnimationBuffer:Array = new Array();
			for ( str in m_arrAnimationBuffer )
			{
				if ( arrNoDeleteList[str] != null )
					arrNewAnimationBuffer[str] = m_arrAnimationBuffer[str];
				else
					( m_arrAnimationBuffer[str].m_pData as dMeshFileAnimation ).Release();
			}
			m_arrAnimationBuffer = arrNewAnimationBuffer;
		}
	}

}