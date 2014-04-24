//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D.Shader 
{
	import dcom.dTimer;
	import dGame3D.dDevice;
	import dGame3D.dGame3DSystem;
	import dGame3D.dTerrain;
	import dGame3D.Math.dMatrix;
	import dGame3D.Math.dVector3;
	import dGame3D.Math.dVector4;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	/**
	 * dym
	 * @author dym
	 */
	public class dShader_Grass extends dShaderBase
	{
		public function dShader_Grass( pDevice:dDevice ) 
		{
			super( pDevice );

			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX, 
			//vertex shader for grass..
			//sinusoidal vertex motion for waving grass
			//pos + sumOverI(wavedirI * texcoordy * sin( xdirI * (xpos+time)) + ydirI * (ypos+time)))
			// va0   - Vertex Position
			// va1   - Vertex Texture Data u,v 
			// c0  - commonConst ( 0.0, 0.5, 1.0, 2.0);
			// c1  - appConst( time, 0.0, 0.0, 0.0);
			// c4  - Composite World-View-Projection Matrix
			// c8  - sin9 ( -1/3!, 1/5!, -1/7!, 1/9! )
			// c10 - frcFixup ( 1.07, 0.0, 0.0, 0.0)
			// c11 - waveDistortx ( 3.0, 0.4, 0.0, 0.3)
			// c12 - waveDistorty ( 3.0, 0.4, 0.0, 0.3)
			// c13 - waveDistortz ( -1.0, -0.133, -0.333, -0.10)
			// c14 - waveDirx ( -0.006, -0.012, 0.024, 0.048)
			// c15 - waveDiry ( -0.003, -0.006, -0.012, -0.048)
			// c16 - waveSpeed ( 0.3, 0.6, 0.7, 1.4)
			// c17 - piVector (4.0, pi/2, pi, pi*2)
			// c18 - lightingWaveScale ( 0.35, 0.10, 0.10, 0.03);
			// c19 - lightingScaleBias ( 0.6, 0.7, 0.2, 0.0);
			"mul vt0, vc14, va0.x\n"+     // use vertex pos x as inputs to sinusoidal warp 
			"mul vt7, vc15, va0.y\n" + // use vertex pos y as inputs to sinusoidal warp 
			"add vt0, vt0, vt7\n"+

			"add vt1, vc1.x, va2.z\n"+          // get current time
			"mul vt7, vt1, vc16\n" +   // add scaled time to move bumps according to speed
			"add vt0, vt0, vt7\n"+
			"frc vt0.xy, vt0\n"+         // take frac of all 4 components
			"frc vt1.xy, vt0.zwzw\n"+    //
			"mov vt0.zw, vt1.xyxy\n"+    //
			   
			"mul vt0, vt0, vc10.x\n"+     // multiply by fixup factor (due to inaccuracy of taylor series)
			"sub vt0, vt0, vc0.y\n"+      // subtract 0.5
			"mul vt1, vt0, vc17.w\n"+     // *=2pi coords range from(-pi to pi)
			   
			"mul vt2, vt1, vt1\n"+        // (wave vec)^2
			"mul vt3, vt2, vt1\n"+        // (wave vec)^3 
			"mul vt4, vt3, vt2\n"+        // (wave vec)^5
			"mul vt5, vt4, vt2\n"+        // (wave vec)^7 
			"mul vt6, vt5, vt2\n"+        // (wave vec)^9
			   
			"mul vt7, vt3, vc8.x\n" +  //(wave vec) - ((wave vec)^3)/3! 
			"add vt0, vt1, vt7\n"+
			"mul vt7, vt4, vc8.y\n" +  //  + ((wave vec)^5)/5! 
			"add vt0, vt0, vt7\n"+
			"mul vt7, vt5, vc8.z\n" +  //  - ((wave vec)^7)/7! 
			"add vt0, vt0, vt7\n"+
			"mul vt7, vt6, vc8.w\n" +  //  - ((wave vec)^9)/9! 
			"add vt0, vt0, vt7\n"+
			   
			"dp4 vt3.x, vt0, vc11\n"+
			"dp4 vt3.y, vt0, vc12\n"+
			"dp4 vt3.zw, vt0, vc13\n"+

			"sub vt4, vc0.z, va2.w\n"+
			"mul vt4, vt4, vt4\n"+       
			"mul vt3, vt3, vt4\n"+        // attenuate sinusoidal warping by (1-tex0.y)^2  

			"mov vt2.w, va0.w\n" +
			"mul vt3, vt3, vc1.y\n" +// vt3 *= wind power
			"add vt2.xyz, vt3, va0\n"+   // add sinusoidal warping to grass position

			"m44 vt3, vt2, vc4\n" +
			"m44 op, vt3, vc20\n" +
			"dp4 vt1.x, vt0, vc18\n"+    //scale and add sin waves together
			//"mad v1, vc19.xzxz, -vt1.x, vc19.y\n"+ //scale and bias color values (green is scaled more // than red and blue)
			"mov v1, va2\n"+// uv
			"sub vt2.z, vc24.y vt0.w\n"+ // Convert fog to 0-1 range
			"div vt2.w, vt2.z vc24.z\n"+ // "                      "
			"sat v3, vt2.w\n" +            // and output the fog factor
			// vc25 eye.x eye.y eye.z maxLength
			"mov vt1 vc25\n" +
			"mov vt2 va0\n" +
			"sub vt1 vt2 vt1\n" +
			length( "vt2" , "vt1" ) +
			"sub vt2.x vc25.w vt2.x\n"+
			"div vt2.x vt2.x vc25.w\n" + // v2 = diffuse
			"mul vt2.x vt2.x vc11.x\n" +
			"sat vt2.x vt2.x\n" +
			"mul v2 vc17.yyyy va1\n" +// mul light power
			"mov v2.w vt2.x\n"
			/*"mov vt0 va0\n" +
			"m44 vt0 vt0 vc4\n" + // pos * view
			"m44 vt0 vt0 vc20\n" + // pos * proj
			"mov op, vt0\n" +
			"mov v2, va1\n" + // diffuse
			"mov v1, va2\n" // uv*/
			);
			
			var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
			// fc0 常量( alphatest 1 lightPower ? )
			// fc1 FogColor( r , g , b , 1 )
			"tex ft1, v1, fs0 <2d,repeat,miplinear,linear>\n" +
			"mul ft0.xyz, ft1.xyz, v3\n"+ // Multiply by fog factor
			"sub ft1.x, fc0.y, v3\n"+     // Subtract fog factor from 1 (Stored in fc0.x)
			"mul ft2, fc1, ft1.x\n"+      // And multiply the result by the fog color (stored in fc1)
			"add ft0.xyz, ft0.xyz, ft2.xyz\n"+ //Add the values together (Blending fog in)
			"mov ft0.w, ft1.w\n" + //And set the alpha value
			"sub ft1.w ft0.w fc0.x\n" + // temp = alpha - alphatest
			"kil ft1.w\n" +
			"mul ft0 ft0 v2\n" +
			"mul oc, ft0 fc0.zzzy\n" // and move the result into the output 
			);
			m_pShader.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
		}
		override public function SetShaderConstantsMatrix( strName:int , mat:dMatrix ):void
		{
			if ( strName == dGame3DSystem.SHADER_WORLD )
			{
				//m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 0 , ConvMatrix( mat ) );
				// c1  - appConst( time, wind power , 0.0, 0.0);
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 1 , ConvVector4( new dVector4( Number( dTimer.GetTickCount() ) / 1000.0 , 0.05 ) ) );
			}
			else if( strName == dGame3DSystem.SHADER_VIEW )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 4 , ConvMatrix( mat ) );
			else if( strName == dGame3DSystem.SHADER_PROJ )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 20 , ConvMatrix( mat ) );
		}
		override public function SetToDevice( index:int = 0 ):void
		{
			super.SetToDevice( index );
			// c0  - commonConst ( 0.0, 0.5, 1.0, 2.0);
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 0 , ConvVector4( new dVector4( 0.0 , 0.5 , 1.0 , 2.0 ) ) );
			// c8  - sin9 ( -1/3!, 1/5!, -1/7!, 1/9! )
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 8 , ConvVector4( new dVector4( -0.16161616 , 0.0083333 , -0.00019841 , 0.000002755731 ) ) );
			// c10 - frcFixup ( 1.07, 0.0, 0.0, 0.0)
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 10 , ConvVector4( new dVector4( 1.07 ) ) );
			// c11 - waveDistortx ( 3.0, 0.4, 0.0, 0.3)
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 11 , ConvVector4( new dVector4( 3.0 , 0.4 , 0.0 , 0.3 ) ) );
			// c12 - waveDistorty ( 3.0, 0.4, 0.0, 0.3)
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 12 , ConvVector4( new dVector4( 3.0 , 0.4 , 0.0 , 0.3 ) ) );
			// c13 - waveDistortz ( -1.0, -0.133, -0.333, -0.10)
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 13 , ConvVector4( new dVector4( -1.0 , -0.133 , -0.333 , -0.1 ) ) );
			// c14 - waveDirx ( -0.006, -0.012, 0.024, 0.048)
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 14 , ConvVector4( new dVector4( -0.006, -0.012, 0.024, 0.048 ) ) );
			// c15 - waveDiry ( -0.003, -0.006, -0.012, -0.048)
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 15 , ConvVector4( new dVector4( -0.003, -0.006, -0.012, -0.048 ) ) );
			// c16 - waveSpeed ( 0.3, 0.6, 0.7, 1.4)
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 16 , ConvVector4( new dVector4( 0.3, 0.6, 0.7, 1.4 ) ) );
			// c17 - piVector (4.0, pi/2, pi, pi*2)
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 17 , ConvVector4( new dVector4( 4.0 , 1.570796325 , 3.14159265 , 6.28318530 ) ) );
			// c18 - lightingWaveScale ( 0.35, 0.10, 0.10, 0.03);
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 18 , ConvVector4( new dVector4( 0.35, 0.10, 0.10, 0.03 ) ) );
			// c19 - lightingScaleBias ( 0.6, 0.7, 0.2, 0.0);
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 19 , ConvVector4( new dVector4( 0.6, 0.7, 0.2, 0.0 ) ) );
			
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.FRAGMENT , 0 , ConvVector4( new dVector4( 0.1, 1, 1.5, 0.0 ) ) );
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.FRAGMENT , 1 , ConvVector4( m_pDevice.GetFogColor() ) );
			if( m_pDevice.isEnableFog() )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 24 , ConvVector4( new dVector4( 0 , m_pDevice.GetFogFar() , m_pDevice.GetFogFar() - m_pDevice.GetFogNear() , 0 ) ) , 1 );
			else
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 24 , ConvVector4( new dVector4( 0 , m_pDevice.GetCamera().GetFarPlane() , m_pDevice.GetCamera().GetFarPlane() , 0 ) ) , 1 );
			var vEye:dVector3 = m_pDevice.GetCamera().GetEye();
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 25 , ConvVector4( new dVector4( vEye.x , vEye.y , vEye.z , dTerrain.TILE_SIZE/1.5 ) ) );
		}
	}

}