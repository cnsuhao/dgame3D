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
	public class dShader_Terrain extends dShaderBase
	{
		public function dShader_Terrain( pDevice:dDevice ) 
		{
			super( pDevice );

			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX, 
			// vc12=LightDir
			// vc14=0.5 FogNear FogFar 0
			"mov vt0 va0.xyyw\n" +
			"mov vt0.y va2.x\n" +
			"m44 vt0 vt0 vc0\n" + // pos * world
			"mov vt3 vt0\n" +
			"m44 vt0 vt0 vc4\n" + // pos * view
			"m44 vt0 vt0 vc8\n" + // pos * proj
			"mov op, vt0\n" +
			"dp4 vt1, va3 vc12\n" + // normal
			//"mul vt1, vt1 vc14.xxxx\n" +
			"mul v2, vt1 vc14.xxxx\n" +
			
			/*"sub vt3.xyz vt3.xyz vc100.xyz\n" +
			"dp3 vt3.w, vt3.xyz, vt3.xyz\n" +
			"sqt vt3.w vt3.w\n" +
			"sub vt3.w vc100.w vt3.w\n" +
			"div vt3.w vt3.w vc100.w\n" +
			"sat vt3.w vt3.w\n" +
			"mul vt3 vc101 vt3.w\n" +
			"add v2, vt1, vt3\n" +*/
			
			
			"add v1, va1, vc13\n" +// uv
			"sub vt2.z, vc14.y vt0.w\n"+ // Convert fog to 0-1 range
			"div vt2.w, vt2.z vc14.z\n"+ // "                      "
			"sat v3, vt2.w\n"            // and output the fog factor
			);
			
			var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
			// fc0 = ( 10 , 1 , blendUVScaX , blendUVScaY )
			// fc1 = fog color
			// fc2 = { uvSacle Layer 0 , 1 , 2 , 3 }
			"mul ft5, v1 fc0.zwzz\n" +
			"tex ft4, ft5, fs4 <2d,repeat,miplinear,linear>\n" +
			"tex ft3, ft5, fs5 <2d,repeat,miplinear,linear>\n" +
			"mul ft5, v1 fc2.xxxx\n" +
			"tex ft0, ft5, fs0 <2d,repeat,miplinear,linear>\n" +
			
			"sub ft4.w fc.y ft4.x\n" +// ft4.a = 1.0 - ft4.r - ft4.g - ft4.b
			"sub ft4.w ft4.w ft4.y\n" +
			"sub ft4.w ft4.w ft4.z\n" +
			
			"mul ft1, ft0, ft4.wwww\n" +
			"mul ft5, v1 fc2.yyyy\n" +
			"tex ft0, ft5, fs1 <2d,repeat,miplinear,linear>\n" +
			"mul ft0, ft0, ft4.xxxx\n" +
			"add ft1, ft1, ft0\n" +
			"mul ft5, v1 fc2.zzzz\n" +
			"tex ft0, ft5, fs2 <2d,repeat,miplinear,linear>\n" +
			"mul ft0, ft0, ft4.yyyy\n" +
			"add ft1, ft1, ft0\n" +
			"mul ft5, v1 fc2.wwww\n" +
			"tex ft0, ft5, fs3 <2d,repeat,miplinear,linear>\n" +
			"mul ft0, ft0, ft4.zzzz\n" +
			"add ft1, ft1, ft0\n" +
			
			//"sub ft1.xyz ft1.xyz ft3.xxx\n" +// sub shadow
			
			"mul ft1.xyz, ft1.xyz , v2.xyz\n" +		// oc *= normal
			"sub ft3.x fc0.y ft3.x\n" + 			// shadow = 1 - shadow
			"mul ft1.xyz, ft1.xyz , ft3.xxx\n" +	// oc *= shadow
			
			"mov ft1.w, fc0.y\n" +
			//"mov oc, ft1\n" );
			"mul ft0.xyz, ft1.xyz, v3\n"+ // Multiply by fog factor
			"sub ft1.x, fc0.y, v3\n"+     // Subtract fog factor from 1 (Stored in fc0.x)
			"mul ft2, fc1, ft1.x\n"+      // And multiply the result by the fog color (stored in fc1)
			"add ft0.xyz, ft0.xyz, ft2.xyz\n"+ //Add the values together (Blending fog in)
			"mov ft0.w, ft1.w\n"+ //And set the alpha value
			"mov oc, ft0\n" // and move the result into the output 
			);
			m_pShader.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
		}
		override public function SetShaderConstantsMatrix( strName:int , mat:dMatrix ):void
		{
			if ( strName == dGame3DSystem.SHADER_WORLD )
			{
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 0 , ConvMatrix( mat ) );
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 13 , ConvVector4( new dVector4( mat._41/50 , mat._43/50 , 0 , 0 ) ) , 1 );
			}
			else if( strName == dGame3DSystem.SHADER_VIEW )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 4 , ConvMatrix( mat ) );
			else if( strName == dGame3DSystem.SHADER_PROJ )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 8 , ConvMatrix( mat ) );
		}
		override public function SetShaderConstantsFloat4( strName:int , data:dVector4 ):void
		{
			if ( strName == dGame3DSystem.SHADER_LIGHT )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 12 , ConvVector4( data ) , 1 );
			else if ( strName == dGame3DSystem.SHADER_UVDATA )
			{
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.FRAGMENT , 0 , ConvVector4( data ) , 1 );
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.FRAGMENT , 2 , ConvVector4( new dVector4( data.x , data.x / 1.2 , data.x / 1.4 , data.x / 1.8 ) ) , 1 );
			}
		}
		override public function SetToDevice( index:int = 0 ):void
		{
			super.SetToDevice( index );
			if( m_pDevice.isEnableFog() )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 14 , ConvVector4( new dVector4( 0.8 , m_pDevice.GetFogFar() , m_pDevice.GetFogFar() - m_pDevice.GetFogNear() , 0 ) ) , 1 );
			else
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 14 , ConvVector4( new dVector4( 0.8 , m_pDevice.GetCamera().GetFarPlane() , m_pDevice.GetCamera().GetFarPlane() , 0 ) ) , 1 );
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.FRAGMENT , 1 , ConvVector4( m_pDevice.GetFogColor() ) , 1 );
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 100 , ConvVector3( m_pDevice.GetPointLightList()[0].vPos , 3.0 ) , 1 );
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 101 , ConvVector3( m_pDevice.GetPointLightList()[0].vColor ) , 1 );
		}
	}

}