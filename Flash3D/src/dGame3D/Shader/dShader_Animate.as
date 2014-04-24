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
	public class dShader_Animate extends dShaderBase
	{
		protected var m_vecConstValue:Vector.<Number> = new Vector.<Number>;
		public static const MAX_BONE_MATRIX:int = 37;
		public function dShader_Animate( pDevice:dDevice ) 
		{
			super( pDevice );

			var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX, 
			// va3=blend index  va4=blend weight float4  
			// 常量 vc114(1,bright,0.5,768)
			// vc115 light dir( x y z 1 )
			// vc116 vc117 vc118 world
			// vc119 fog( 0, near , far , 0 )
			// vc120 vc121 vc122 vc123 view
			// vc124 vc125 vc126 vc127 proj
			"mul vt2 va3 vc114.wwww\n" +// vt2 = blend index * 768
			"mov vt1.w , vc114.x\n" +	// vt1.w = 1
			"mov vt0.w , vc114.x\n" +	// vt0.w = 1
			"m34 vt1.xyz va0 vc[vt2.x]\n" +
			"mul vt0.xyz vt1.xyz va4.x\n" +// weight1
			"m34 vt1.xyz va0 vc[vt2.y]\n" +
			"mul vt1.xyz vt1.xyz va4.y\n" +
			"add vt0.xyz vt0.xyz vt1.xyz\n" +// weight2
			"m34 vt1.xyz va0 vc[vt2.z]\n" +
			"mul vt1.xyz vt1.xyz va4.z\n" +
			"add vt0.xyz vt0.xyz vt1.xyz\n" +// weight3
			"m34 vt1.xyz va0 vc[vt2.w]\n" +
			"mul vt1.xyz vt1.xyz va4.w\n" +
			"add vt0.xyz vt0.xyz vt1.xyz\n" +// weight4
			
			"m34 vt0.xyz vt0 vc116\n" + // pos * world
			"m44 vt0 vt0 vc120\n" + // pos * view
			"m44 vt0 vt0 vc124\n" + // pos * proj
			"mov op vt0\n" +
			"m33 vt2.xyz, va1.xyz vc[vt2.x]\n" +// normal *= skeleton matrix[idx0]
			"m33 vt2.xyz, vt2.xyz vc116\n" +	// normal *= world
			"nrm vt2.xyz vt2.xyz\n" +
			"mov vt2.w vc114.x\n" +// diffuse.w = 1
			"dp4 vt2 vt2 vc115\n" + // diffuse = normal dot light
			"max vt2 vt2 vc114.zzzz\n" +
			"add vt2, vt2 vc114.y\n" +// diffuse *= bright
			"mov v1 vt2\n" +// diffuse
			"mov v2 va2\n" +// uv
			
			"sub vt2.z, vc119.y vt0.w\n"+ // Convert fog to 0-1 range
			"div vt2.w, vt2.z vc119.z\n"+ // "                      "
			"sat v3, vt2.w\n"            // and output the fog factor
			);
			
			var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
			// fc0 常量 ( alphatest 1 ? ? )
			// fc1 Fog color
			"tex ft1, v2, fs0 <2d,repeat,miplinear,linear>\n" +
			"mul ft1.xyz, ft1.xyz , v1.xyz\n" +
			
			"mul ft0.xyz, ft1.xyz, v3\n"+ // Multiply by fog factor
			"sub ft1.x, fc0.y, v3\n"+     // Subtract fog factor from 1 (Stored in fc0.x)
			"mul ft2, fc1, ft1.x\n"+      // And multiply the result by the fog color (stored in fc1)
			"add ft0.xyz, ft0.xyz, ft2.xyz\n"+ //Add the values together (Blending fog in)
			"mov ft0.w, ft1.w\n" + //And set the alpha value
			
			"sub ft1.w ft0.w fc0.x\n" + // temp = alpha - alphatest
			"kil ft1.w\n" +
			"mov oc, ft0\n" );
			m_pShader.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
			
			m_vecConstValue.push( 1 , 0 , 0.5 , 768 );
		}
		override public function SetShaderConstantsMatrix( strName:int , mat:dMatrix ):void
		{
			if( strName == dGame3DSystem.SHADER_WORLD )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 116 , ConvMatrix( mat ) , 3 );
			else if( strName == dGame3DSystem.SHADER_VIEW )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 120 , ConvMatrix( mat ) );
			else if( strName == dGame3DSystem.SHADER_PROJ )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 124 , ConvMatrix( mat ) );
		}
		static private var s_vecSkeletonData:Vector.<Number> = new Vector.<Number>;
		override public function SetShaderConstantsMatrixArray( strName:int , data:Vector.<dMatrix> ):void
		{
			if ( strName == dGame3DSystem.SHADER_SKELETON )
			{
				var p:int = 0;
				for ( var i:int = 0 ; i < data.length ; i ++ )
				{
					if ( i >= MAX_BONE_MATRIX )
						break;
					var mat:dMatrix = data[i];
					s_vecSkeletonData[p++] = mat._11;
					s_vecSkeletonData[p++] = mat._21;
					s_vecSkeletonData[p++] = mat._31;
					s_vecSkeletonData[p++] = mat._41;
					s_vecSkeletonData[p++] = mat._12;
					s_vecSkeletonData[p++] = mat._22;
					s_vecSkeletonData[p++] = mat._32;
					s_vecSkeletonData[p++] = mat._42;
					s_vecSkeletonData[p++] = mat._13;
					s_vecSkeletonData[p++] = mat._23;
					s_vecSkeletonData[p++] = mat._33;
					s_vecSkeletonData[p++] = mat._43;
				}
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 0 , s_vecSkeletonData , 3 * i );
			}
			//m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 114 , m_vecConstValue );
		}
		override public function SetShaderConstantsFloat4( strName:int , data:dVector4 ):void
		{
			if ( strName == dGame3DSystem.SHADER_LIGHT )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 115 , ConvVector4( data ) , 1 );
		}
		override public function SetShaderConstantsFloat( strName:int , data:Number ):void
		{
			if ( strName == dGame3DSystem.SHADER_BRIGHT )
			{
				m_vecConstValue[1] = data;
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 114 , m_vecConstValue );
			}
		}
		override public function SetToDevice( index:int = 0 ):void
		{
			super.SetToDevice( index );
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.FRAGMENT , 0 , ConvVector4( new dVector4( 0.5 , 1 , 0 , 0 ) ) , 1 );// 常量
			if( m_pDevice.isEnableFog() )
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 119 , ConvVector4( new dVector4( 0 , m_pDevice.GetFogFar() , m_pDevice.GetFogFar() - m_pDevice.GetFogNear() , 0 ) ) , 1 );
			else
				m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.VERTEX , 119 , ConvVector4( new dVector4( 0 , m_pDevice.GetCamera().GetFarPlane() , m_pDevice.GetCamera().GetFarPlane() , 0 ) ) , 1 );
			m_pDevice.GetDevice().setProgramConstantsFromVector( Context3DProgramType.FRAGMENT , 1 , ConvVector4( m_pDevice.GetFogColor() ) , 1 );
		}
	}

}