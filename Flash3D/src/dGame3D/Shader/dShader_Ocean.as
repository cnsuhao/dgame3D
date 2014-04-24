//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D.Shader 
{
	import dGame3D.dDevice;
	import dGame3D.dGame3DSystem;
	import dGame3D.Math.dMatrix;
	import dGame3D.Math.dVector4;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	/**
	 * dym
	 * @author dym
	 */
	public class dShader_Ocean extends dShaderBase
	{
		protected var m_pShader1:Program3D;
		protected var m_pShader2:Program3D;
		
		public function dShader_Ocean( pDevice:dDevice ) 
		{
			super( pDevice );

			m_pShader1 = m_pDevice.GetDevice().createProgram();
			m_pShader2 = m_pDevice.GetDevice().createProgram();
			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX, 
			"mov vt0 va0\n" +
			//"m44 vt0 vt0 vc0\n" + // pos * world
			"m44 vt0 vt0 vc4\n" + // pos * view
			"m44 vt0 vt0 vc8\n" + // pos * proj
			"mov op, vt0\n" +
			"mov v2, va1\n" // uv
			);
			
			var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
			"add ft1 v2 fc0\n" +
			"tex ft0, ft1, fs0 <2d,repeat,miplinear,linear>\n" +
			"mov ft0.w v2.z\n" +
			"mov oc, ft0\n" );
			m_pShader1.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			
			fragmentShaderAssembler = new AGALMiniAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
			"mov ft2 fc0\n" +
			"add ft2.y ft2.y v2.z\n" +
			"add ft1 v2 ft2\n" +
			"tex ft0, ft1, fs0 <2d,clamp,miplinear,linear>\n" +
			"mul ft0 ft0 fc0.z\n" +
			"mov oc, ft0\n" );
			m_pShader2.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
		}
		override public function SetShaderConstantsMatrix( strName:int , mat:dMatrix ):void
		{
			if( strName == dGame3DSystem.SHADER_WORLD )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 0 , ConvMatrix( mat ) );
			else if( strName == dGame3DSystem.SHADER_VIEW )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 4 , ConvMatrix( mat ) );
			else if( strName == dGame3DSystem.SHADER_PROJ )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 8 , ConvMatrix( mat ) );
		}
		override public function SetShaderConstantsFloat4( strName:int , data:dVector4 ):void
		{
			if ( strName == dGame3DSystem.SHADER_UVDATA )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.FRAGMENT , 0 , ConvVector4( data ) );
		}
		override public function SetToDevice( index:int = 0 ):void
		{
			if ( index == 0 )
				m_pDevice.GetDevice().setProgram( m_pShader1 );
			else
				m_pDevice.GetDevice().setProgram( m_pShader2 );
		}
	}

}