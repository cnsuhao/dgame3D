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
	public class dShader_Effect extends dShaderBase
	{
		public function dShader_Effect( pDevice:dDevice ) 
		{
			super( pDevice );

			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX, 
			// va0=pos va1=color va2=normal va3=uv 
			// vc13 常量 (1.5 , lerp , 1.0 , enableFog )
			//"mov vt0 va0\n" +
			"mul vt4.y vc13.y va4.w\n" +
			"add vt4.x vc13.y va4.w\n" +
			"min v4 vt4.x vc13.z\n" +
			lerp( "vt0" , "va0" , "va4" , "vt4.y" ) +
			"mov vt0.w vc13.z\n" +
			"m44 vt0 vt0 vc0\n" + // pos * world
			"m44 vt0 vt0 vc4\n" + // pos * view
			"m44 vt0 vt0 vc8\n" + // pos * proj
			//"mov vt1 va2\n" + // vt1 = billborad dir (normal channel)
			lerp( "vt1" , "va2" , "va6" , "vt4.y" ) +
			"m44 vt1 vt1 vc8\n" +// vt1 *= proj
			"mul vt2 vt1 vt0.w\n" +// (dir*=w 忽略近大远小)
			lerp( "vt3" , "vt1" , "vt2" , "va2.z" ) +
			// get scale x
			"mov vt5 vc0\n" +
			//"mov vt5.w vc13.z\n" +// vt4.w = 1.0
			length( "vt2" , "vt5" ) +
			"mul vt3.x vt3.x vt2.x\n" +
			// get scale y
			"mov vt5 vc1\n" +
			//"mov vt5.w vc13.z\n" +// vt4.w = 1.0
			length( "vt2" , "vt5" ) +
			"mul vt3.y vt3.y vt2.y\n" +
			
			"add vt0.xy, vt0.xy vt3.xy\n" +
			"mov op vt0\n" +
			//"mov v1 va1.zyxw\n" +// color
			lerp( "vt1" , "va1" , "va5" , "vt4.y" ) +
			"mov v1 vt1.zyxw\n" +
			//"mov v2 va3\n" +// uv
			lerp( "vt1" , "va3" , "va7" , "vt4.y" ) +
			"mov v2 vt1\n" +
			// fog
			"sub vt2.z, vc14.y vt0.w\n"+ // Convert fog to 0-1 range
			"div vt2.w, vt2.z vc14.z\n"+ // "                      "
			"sat v3, vt2.w\n" +          // and output the fog factor
			"mov v5, vc13.w\n"
			);
			
			var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
			// fc0 常量( alphatest 1 ? ? )
			// fc1 FogColor( r , g , b , 1 )
			"tex ft1, v2, fs0 <2d,repeat,miplinear,linear>\n" +
			"mul ft1, ft1 , v1\n" +
			//"mov oc, ft1\n" 
			"mul ft0.xyz, ft1.xyz, v3\n"+ // Multiply by fog factor
			"sub ft1.x, fc0.y, v3\n"+     // Subtract fog factor from 1 (Stored in fc0.x)
			"mul ft2, fc1, ft1.x\n" +      // And multiply the result by the fog color (stored in fc1)
			"mul ft2.xyz ft2.xyz v5.xxx\n" +
			"add ft0.xyz, ft0.xyz, ft2.xyz\n"+ //Add the values together (Blending fog in)
			"mul ft0.w, ft1.w v3.x\n" + //And set the alpha value
			//"mov ft0.w ft1.w\n" +
			//"sub ft1.w ft0.w fc0.x\n" + // temp = alpha - alphatest
			//"kil ft1.w\n"+
			"mul ft0.w ft0.w v4.x\n" +
			"mov oc, ft0\n" // and move the result into the output */
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
			else if( strName == dGame3DSystem.SHADER_LERP )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 13 , ConvVector4( data ) , 1 );// 常量
		}
		override public function SetToDevice( index:int = 0 ):void
		{
			super.SetToDevice( index );
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.FRAGMENT , 0 , ConvVector4( new dVector4( 0.5 , 1 , 0 , 0 ) ) , 1 );// 常量
			if( m_pDevice.isEnableFog() )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 14 , ConvVector4( new dVector4( 0 , m_pDevice.GetFogFar() , m_pDevice.GetFogFar() - m_pDevice.GetFogNear() , 0 ) ) , 1 );
			else
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 14 , ConvVector4( new dVector4( 0 , m_pDevice.GetCamera().GetFarPlane() , 0 , 0 ) ) , 1 );
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.FRAGMENT , 1 , ConvVector4( m_pDevice.GetFogColor() ) , 1 );
		}
		override public function SetShaderConstantsFloat( strName:int , data:Number ):void
		{
			if( strName == dGame3DSystem.SHADER_LERP )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 13 , ConvVector4( new dVector4( 1.5 , data , 1.0 , 1 ) ) , 1 );// 常量
		}
	}

}