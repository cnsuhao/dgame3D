//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Math.dVector3;
	import dGame3D.Shader.dShaderBase;
	/**
	 * ...
	 * @author dym
	 */
	public class dMeshObj extends dRenderObj
	{
		protected var m_pMesh:dMeshFile;
		static private var s_arrMeshBuffer:Array = new Array();
		public function dMeshObj( pDevice:dDevice ) 
		{
			super( pDevice , dGame3DSystem.RENDEROBJ_TYPE_MESH );
		}
		override public function Release():void
		{
			super.Release();
			// m_pMesh在Resource里自动回收
		}
		override public function LoadFromFile( strFileName:String ):void
		{
			super.LoadFromFile( strFileName );
			m_pDevice.GetResource().LoadMesh( strFileName , function( p:dMeshFile ):void
			{
				m_pMesh = p;
				SetBoundingBox( m_pMesh.GetBoundingBox() );
			} , false , null );
		}
		override public function CheckCollectionRay( vPos:dVector3 , vDir:dVector3 , vPosOut:dVector3 ):Boolean
		{
			if ( super.CheckCollectionRay( vPos , vDir , vPosOut ) )
			{
				if ( !m_pMesh ) return true;
				var nSubMeshNum:int = m_pMesh.GetSubMeshNum();
				for ( var i:int = 0 ; i < nSubMeshNum ; i ++ )
				{
					var pVB:dVertexBuffer = m_pMesh.GetVertexBuffer();
					var pIB:dIndexBuffer = m_pMesh.GetSubMeshIndexBuffer( i );
					if( CheckCollectionMeshIntersect( pVB , pVB , pVB ,
						pIB.GetIndexData() , vPos , vDir , vPosOut , GetWorldMatrix() ) )
						return true;
				}
			}
			return false;
		}
		override public function Render( shader:dShaderBase ):int
		{
			if ( !m_pMesh ) return 0;
			shader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_WORLD , GetWorldMatrix() );
			return m_pMesh.Render();
		}
	}

}