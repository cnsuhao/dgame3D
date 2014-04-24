//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import flash.display3D.Context3DVertexBufferFormat;
	/**
	 * ...
	 * @author dym
	 */
	public class dVertexBufferDecl 
	{
		public static const DECL_USAGE_POSITION:int = 6;
		public static const DECL_USAGE_COLOR:int = 7;
		public static const DECL_USAGE_BLENDWEIGHT:int = 8;
		public static const DECL_USAGE_BLENDINDICES:int = 9;
		public static const DECL_USAGE_NORMAL:int = 10;
		public static const DECL_USAGE_TEXCOORD:int = 11;
		public static const DECL_USAGE_PSIZE:int = 12;
		public static const DECL_USAGE_UNKNOWN:int = 100;
		
		public var stream:Vector.<int> = new Vector.<int>;
		public var startPos:Vector.<int> = new Vector.<int>;
		public var type:Vector.<String> = new Vector.<String>;
		public var usage:Vector.<int> = new Vector.<int>;
		protected var m_nStride:int;
		
		public function dVertexBufferDecl( strData:String = null ) 
		{
			if ( strData ) FromString( strData );
		}
		public function FromString( str:String ):void
		{
			var p:dVertexBufferDecl = this;
			var startPos:int = 0;
			var stream:String = "";
			var type:String = "";
			var usage:String = "";
			var step:int = 0;
			str += "\n";
			for ( var i:int = 0 ; i < str.length ; i ++ )
			{
				if ( str.charAt(i) == "," )
					step++;
				else if ( str.charAt(i) == "\n" )
				{
					var lastStartPos:int = startPos;
					if ( type == "FLOAT1" ) { p.type.push( Context3DVertexBufferFormat.FLOAT_1 ); startPos += 1; }
					else if ( type == "FLOAT2" ) { p.type.push( Context3DVertexBufferFormat.FLOAT_2 ); startPos += 2; }
					else if ( type == "FLOAT3" ) { p.type.push( Context3DVertexBufferFormat.FLOAT_3 ); startPos += 3; }
					else if ( type == "FLOAT4" ) { p.type.push( Context3DVertexBufferFormat.FLOAT_4 ); startPos += 4; }
					else if ( type == "UBYTE4" ) { p.type.push( Context3DVertexBufferFormat.BYTES_4 ); startPos += 1; }
					else continue;
					if ( usage == "POSITION" ) p.usage.push( dVertexBufferDecl.DECL_USAGE_POSITION );
					else if ( usage == "COLOR" ) p.usage.push( dVertexBufferDecl.DECL_USAGE_COLOR );
					else if ( usage == "BLENDWEIGHT" ) p.usage.push( dVertexBufferDecl.DECL_USAGE_BLENDWEIGHT );
					else if ( usage == "BLENDINDICES" ) p.usage.push( dVertexBufferDecl.DECL_USAGE_BLENDINDICES );
					else if ( usage == "NORMAL" ) p.usage.push( dVertexBufferDecl.DECL_USAGE_NORMAL );
					else if ( usage == "TEXCOORD" ) p.usage.push( dVertexBufferDecl.DECL_USAGE_TEXCOORD );
					else if ( usage == "PSIZE" ) p.usage.push( dVertexBufferDecl.DECL_USAGE_PSIZE );
					else p.usage.push( dVertexBufferDecl.DECL_USAGE_UNKNOWN );
					p.startPos.push( lastStartPos );
					p.stream.push( int(stream) );
					type = "";
					usage = "";
					step = 0;
					stream = "";
				}
				else if ( str.charAt(i) != " " )
				{
					if ( step == 0 ) stream += str.charAt(i);
					else if ( step == 1 ) type += str.charAt(i);
					else if ( step == 2 ) usage += str.charAt(i);
				}
			}
			m_nStride = startPos;
		}
		public function GetStride():int
		{
			return m_nStride;
		}
	}

}