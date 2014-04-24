//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D.Shader 
{
	import dGame3D.dDevice;
	import dGame3D.Math.dMatrix;
	import dGame3D.Math.dVector3;
	import dGame3D.Math.dVector4;
	import flash.display3D.Program3D;
	import flash.geom.Matrix3D;
	/**
	 * ...
	 * @author dym
	 */
	public class dShaderBase 
	{
		protected var m_pDevice:dDevice;
		protected var m_pShader:Program3D;
		private var m_vecForSetMatrix:Vector.< Number > = new Vector.< Number >;
		private var m_vecForConv4:Vector.<Number> = new Vector.<Number>;
		public function dShaderBase( pDevice:dDevice ) 
		{
			m_pDevice = pDevice;
			m_pShader = m_pDevice.GetDevice().createProgram();
		}
		public function ConvMatrix( mat:dMatrix ):Vector.<Number>
		{
			m_vecForSetMatrix[0] = mat._11;
			m_vecForSetMatrix[1] = mat._21;
			m_vecForSetMatrix[2] = mat._31;
			m_vecForSetMatrix[3] = mat._41;
			m_vecForSetMatrix[4] = mat._12;
			m_vecForSetMatrix[5] = mat._22;
			m_vecForSetMatrix[6] = mat._32;
			m_vecForSetMatrix[7] = mat._42;
			m_vecForSetMatrix[8] = mat._13;
			m_vecForSetMatrix[9] = mat._23;
			m_vecForSetMatrix[10] = mat._33;
			m_vecForSetMatrix[11] = mat._43;
			m_vecForSetMatrix[12] = mat._14;
			m_vecForSetMatrix[13] = mat._24;
			m_vecForSetMatrix[14] = mat._34;
			m_vecForSetMatrix[15] = mat._44;
			return m_vecForSetMatrix;
		}
		public function ConvVector4( v4:dVector4 ):Vector.<Number>
		{
			m_vecForConv4[0] = v4.x;
			m_vecForConv4[1] = v4.y;
			m_vecForConv4[2] = v4.z;
			m_vecForConv4[3] = v4.w;
			return m_vecForConv4;
		}
		public function ConvVector3( v3:dVector3 , w:Number = 1.0 ):Vector.<Number>
		{
			m_vecForConv4[0] = v3.x;
			m_vecForConv4[1] = v3.y;
			m_vecForConv4[2] = v3.z;
			m_vecForConv4[3] = w;
			return m_vecForConv4;
		}
		public function SetShaderConstantsMatrix( strName:int , mat:dMatrix ):void
		{
		}
		public function SetShaderConstantsFloat4( strName:int , data:dVector4 ):void
		{
		}
		public function SetShaderConstantsFloat( strName:int , data:Number ):void
		{
		}
		public function SetShaderConstantsVector( strName:int , data:Vector.<Number> ):void
		{
		}
		public function SetShaderConstantsMatrixArray( strName:int , data:Vector.<dMatrix> ):void
		{
		}
		public function SetToDevice( index:int = 0 ):void
		{
			m_pDevice.GetDevice().setProgram( m_pShader );
		}
		protected function mod( target:String , a:String , b:String ):String
		{
			var code:String = "";
 			code += "div " + target + " " + a + " " + b + "\n";
 			code += "frc " + target + " " + target + "\n";
 			code += "mul " + target + " " + target + " " + b + "\n";
 			return code;
		}
		public function lerp(target:String, source1:String, source2:String, ratio:String):String
 		{
 			var code:String = "";
 			code += "sub " + target + " " + source2 + " " + source1 + "\n";
 			code += "mul " + target + " " + target + " " + ratio + "\n";
 			code += "add " + target + " " + target + " " + source1 + "\n";
 			return code;
		}
		public function length(target:String, source:String):String
 		{
 			var code:String = "";
 			code += "dp3 " + target + " " + source + " " + source + "\n";
 			code += "sqt " + target + " " + target + "\n";
 			return code;
		}
	}

}