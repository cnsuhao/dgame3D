//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Shader.dShaderBase;
	/**
	 * ...
	 * @author dym
	 */
	public class dEffect extends dRenderObj
	{
		protected var m_pEffect:dEffectFile;
		protected var m_nKeyTime:int = 0;
		public var m_bPlayEndAutoDelete:Boolean = false;
		public function dEffect( pDevice:dDevice ) 
		{
			super( pDevice , dGame3DSystem.RENDEROBJ_TYPE_EFFECT );
		}
		override public function Release():void
		{
			super.Release();
			// m_pEffect在Resource里自动回收
		}
		override public function LoadFromFile( strFileName:String ):void
		{
			super.LoadFromFile( strFileName );
			m_pDevice.GetResource().LoadEffect( strFileName , function( p:dEffectFile ):void
			{
				m_pEffect = p;
				SetBoundingBox( m_pEffect.GetBoundingBox() );
			} );
		}
		override public function Render( shader:dShaderBase ):int
		{
			if ( m_pEffect )
			{
				shader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_WORLD , GetWorldMatrix() );
				var r:int = m_pEffect.Render( m_nKeyTime , shader );
				m_nKeyTime += m_pDevice.GetTick();
				if ( m_bPlayEndAutoDelete && m_nKeyTime >= m_pEffect.GetKeyMaxTime() )
					return -1;
				return r;
			}
			return 0;
		}
	}

}