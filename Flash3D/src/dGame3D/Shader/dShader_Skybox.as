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
	public class dShader_Skybox extends dShaderBase
	{
		public function dShader_Skybox( pDevice:dDevice ) 
		{
			super( pDevice );

			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX, 
			"mov vt0 va0\n" +
			"m44 vt0 vt0 vc0\n" + // pos * world
			"m44 vt0 vt0 vc4\n" + // pos * view
			"m44 vt0 vt0 vc8\n" + // pos * proj
			"mov op, vt0\n" +
			"mov v1, va1\n" + // normal
			"mov v2, va2\n" // uv
			);
			
			var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
			"tex ft0, v2, fs0 <2d,repeat,miplinear,linear>\n" +
			"mov oc, ft0\n" );
			m_pShader.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
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
	}

}