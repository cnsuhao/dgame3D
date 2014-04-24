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
	 * ...
	 * @author dym
	 */
	public class dShader_StaticMesh extends dShaderBase
	{
		public function dShader_StaticMesh( pDevice:dDevice ) 
		{
			super( pDevice );

			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX, 
			// vc13 常量 (1.5 , ? , ? , ? )
			"mov vt0 va0\n" +
			"m44 vt0 vt0 vc0\n" + // pos * world
			"m44 vt0 vt0 vc4\n" + // pos * view
			"m44 vt0 vt0 vc8\n" + // pos * proj
			"mov op, vt0\n" +
			"m33 vt2.xyz, va1.xyz vc0\n" +// normal *= world
			"nrm vt2.xyz vt2.xyz\n" +
			"mov vt2.w va1.w\n" +// diffuse.w = 1
			"dp4 vt1, vt2 vc12\n" + // normal
			"mul v1, vt1, vc13.xxxx\n" +
			//"mov v1 vt1\n" +
			"mov v2, va2\n" +// uv
			"sub vt2.z, vc14.y vt0.w\n"+ // Convert fog to 0-1 range
			"div vt2.w, vt2.z vc14.z\n"+ // "                      "
			"sat v3, vt2.w\n"            // and output the fog factor
			);
			
			var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
			// fc0 常量( alphatest 1 ? ? )
			// fc1 FogColor( r , g , b , 1 )
			"tex ft1, v2, fs0 <2d,repeat,miplinear,linear>\n" +
			"mul ft1.xyz, ft1.xyz , v1.xyz\n" +
			//"mov oc, ft0\n" );
			"mul ft0.xyz, ft1.xyz, v3\n"+ // Multiply by fog factor
			"sub ft1.x, fc0.y, v3\n"+     // Subtract fog factor from 1 (Stored in fc0.x)
			"mul ft2, fc1, ft1.x\n"+      // And multiply the result by the fog color (stored in fc1)
			"add ft0.xyz, ft0.xyz, ft2.xyz\n"+ //Add the values together (Blending fog in)
			"mov ft0.w, ft1.w\n" + //And set the alpha value
			"sub ft1.w ft0.w fc0.x\n" + // temp = alpha - alphatest
			"kil ft1.w\n"+
			"mov oc, ft0\n" // and move the result into the output 
			);
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
		override public function SetShaderConstantsFloat4( strName:int , data:dVector4 ):void
		{
			if ( strName == dGame3DSystem.SHADER_LIGHT )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 12 , ConvVector4( data ) , 1 );
		}
		override public function SetShaderConstantsFloat( strName:int , data:Number ):void
		{
			if( strName == dGame3DSystem.SHADER_ALPHATEST )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.FRAGMENT , 0 , ConvVector4( new dVector4( data , 1 , 0 , 0 ) ) , 1 );// 常量
		}
		override public function SetToDevice( index:int = 0 ):void
		{
			super.SetToDevice( index );
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 13 , ConvVector4( new dVector4( 1.5 , 0 , 0 , 0 ) ) , 1 );// 常量
			if( m_pDevice.isEnableFog() )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 14 , ConvVector4( new dVector4( 0 , m_pDevice.GetFogFar() , m_pDevice.GetFogFar() - m_pDevice.GetFogNear() , 0 ) ) , 1 );
			else
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 14 , ConvVector4( new dVector4( 0 , m_pDevice.GetCamera().GetFarPlane() , m_pDevice.GetCamera().GetFarPlane() , 0 ) ) , 1 );
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.FRAGMENT , 1 , ConvVector4( m_pDevice.GetFogColor() ) , 1 );
		}
	}

}