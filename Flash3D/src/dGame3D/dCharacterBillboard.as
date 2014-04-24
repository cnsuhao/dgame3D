//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Math.dMatrix;
	import dGame3D.Math.dVector3;
	import dGame3D.Shader.dShaderBase;
	import dUI._dInterface;
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author dym
	 */
	public class dCharacterBillboard 
	{
		protected var m_pDevice:dDevice;
		protected var m_pTexture:dTexture;
		protected var m_pVB:dVertexBuffer;
		protected var m_pIB:dIndexBuffer;
		protected var m_vPos:dVector3 = new dVector3();
		protected var m_vDir:dVector3 = new dVector3();
		protected var m_nPlayType:int = 0;
		protected var m_fJumpYAdd:Number;
		protected var m_bTextureNeedRelease:Boolean;
		protected var m_nWidth:int;
		protected var m_nHeight:int;
		
		public function dCharacterBillboard( pDevice:dDevice ) 
		{
			m_pDevice = pDevice;
		}
		public function Release():void
		{
			if ( m_pVB ) m_pVB.Release();
			if ( m_pIB ) m_pIB.Release();
			if ( m_pTexture && m_bTextureNeedRelease )
				m_pTexture.Release();
		}
		static protected function isStringASign( strSource:String , iStart:int , outData:Vector.<uint> ):int
		{
			if ( strSource.length - iStart >= 10 )
			{
				if ( strSource.charAt( iStart ) == "&" )
				{
					var strType:String = strSource.charAt( iStart + 1 );
					if ( strType == "C" || strType == "D" || strType == "I" || strType == "S" )
					{
						var sSign:String = "";
						for ( var i:int = 0 ; i < 8 ; i ++ )
						{
							var s:String = strSource.charAt( i + 2 + iStart );
							if ( s != "0" && s != "1" && s != "2" && s != "3" && s != "4" &&
								 s != "5" && s != "6" && s != "7" && s != "8" && s != "9" &&
								 s != "a" && s != "b" && s != "c" && s != "d" && s != "e" &&
								 s != "f" && s != "A" && s != "B" && s != "C" && s != "D" &&
								 s != "E" && s != "F" )
								 return 0;
							sSign += s;
						}
						outData[0] = uint( "0x"+sSign );
						if ( strType == "C" ) return 1;
						if ( strType == "D" ) return 2;
						if ( strType == "I" ) return 3;
						if ( strType == "S" ) return 4;
					}
				}
			}
			return 0;
		}
		static private function GetUnderLineString( strSource:String , iStart:int , outData:Vector.<uint> ):String
		{
			if ( strSource.charAt( iStart ) == "'" )
			{
				var ret:String = new String();
				for ( var i:int = iStart + 1 ; i < strSource.length ; i ++ )
				{
					if ( strSource.charAt( i ) == "'" )
					{
						outData[0] = ret.length+2;
						return ret;
					}
					ret += strSource.charAt( i );
				}
				ret = "";
			}
			for ( i = iStart ; i < strSource.length ; i ++ )
			{
				var signType:int = isStringASign( strSource , i , outData );
				if ( signType == 2 )
				{
					ret = new String();
					for ( var j:int = iStart ; j < i ; j ++ )
					{
						if ( isStringASign( strSource , j , outData ) )
							j += 9;
						else if( strSource.charAt( j ) != "\n" )
							ret += strSource.charAt( j );
					}
					outData[0] = 0;
					return ret;
				}
			}
			outData[0] = 0;
			return "";
		}
		static public function ConvertToHTML( strAlign:String , strSource:String ):String
		{
			var outData:Vector.<uint> = new Vector.<uint>;
			var nCurColor:uint = 0xFFFFFFFF;
			var nCurSize:int = 12;
			var str:String = "<P ALIGN='" + strAlign + "'><font color='#" + nCurColor.toString(16) + "' size='" + nCurSize + "'>";
			var bUnderLine:Boolean = false;
			for ( var i:int = 0 ; i < strSource.length ; i ++ )
			{
				var signType:int = isStringASign( strSource , i , outData );
				if ( signType )
				{
					var nSignData:uint = outData[0];
					i += 10 - 1;
					if ( signType == 1 )
					{
						nCurColor = nSignData;
						if ( nCurColor == 0 ) nCurColor = 0xFFFFFFFF;
						str += "</font><font color='#" + nCurColor.toString(16) + "' size='" + nCurSize + "'>";
					}
					else if ( signType == 4 )
					{
						nCurSize = nSignData;
						str += "</font><font color='#" + nCurColor.toString(16) + "' size='" + nCurSize + "'>";
					}
					else if ( signType == 2 )
					{
						outData[0] = 0;
						if ( !bUnderLine ) str += "<a href='event:" + GetUnderLineString( strSource , i + 1 , outData ) + "'><U>";
						else str += "</U></a>";
						bUnderLine = !bUnderLine;
						i += outData[0];
					}
				}
				else str += strSource.charAt( i );
			}
			//if ( bUnderLine ) str += "</U></a>";
			//str += "</font></p>";
			return str;
		}
		public function CreateByString( str:String ):void
		{
			m_bTextureNeedRelease = true;
			var text:TextField = new TextField();
			/*var tFormat:TextFormat = new TextFormat;
			tFormat.align = "center";
			tFormat.color = 0xFFFFFF;
			text.defaultTextFormat = tFormat;
			text.text = str;*/
			text.filters = [new GlowFilter(0x10414F, 1, 2, 2, 10)];
			text.htmlText = ConvertToHTML( "center" , str );
			m_pTexture = new dTexture( m_pDevice );
			var textWidth:int = text.textWidth + 4;
			var textHeight:int = text.textHeight + 4;
			text.width = textWidth;
			text.height = textHeight;
			var w:int = textWidth;
			var h:int = textHeight;
			var vec:Vector.<int> = new Vector.<int>;
			vec.push( 16 , 32 , 64 , 128 , 256 );
			var bSize:Boolean = false;
			for ( var i:int = 0 ; i < vec.length ; i ++ )
			{
				if ( w <= vec[i] )
				{
					w = vec[i];
					bSize = true;
					break;
				}
			}
			if ( !bSize ) w = vec[ vec.length - 1 ];
			bSize = false;
			for ( i = 0 ; i < vec.length ; i ++ )
			{
				if ( h <= vec[i] )
				{
					h = vec[i];
					bSize = true;
					break;
				}
			}
			if ( !bSize ) h = vec[ vec.length - 1 ];
			if ( w < h )
				m_pTexture.CreateTexture( h , h );
			else
				m_pTexture.CreateTexture( w , w );
			var bitmap:BitmapData = new BitmapData( textWidth , textHeight , true , 0 );
			bitmap.draw( text );
			var pRect:Rectangle = bitmap.getColorBoundsRect( 0xFF000000 , 0 , false );
			m_pTexture.LoadFromBitmap( _dInterface.iBridge_TransBitmap( bitmap ) , null , false );
			var u:Number = textWidth/ m_pTexture.GetWidth();
			var v:Number = textHeight / m_pTexture.GetHeight();
			m_nWidth = textWidth;
			m_nHeight = textHeight;
			var s:Number = 1.0;// m_pTexture.GetWidth() / m_pDevice.GetScreenWidth() / 1.75;
			m_pVB = new dVertexBuffer( 4 , "0,FLOAT4,POSITION\n0,UBYTE4,COLOR\n0,FLOAT3,NORMAL\n0,FLOAT2,TEXCOORD" , m_pDevice );
			var pVBData:ByteArray = new ByteArray();
			pVBData.endian = "littleEndian";
			// 顶点顺序：
			// B1   2 4C
			//   |---|
			//   |---|
			// A0 3   5D
			var tx:Number = 1.0;// Math.tan( 3.14159 / 8.0 ) * (m_pDevice.GetScreenWidth() / m_pDevice.GetScreenHeight());
			var ty:Number = 1.0;// Math.tan( 3.14159 / 8.0 );
			// A
			pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 1.0 ); pVBData.writeUnsignedInt( 0xFFFFFFFF );
			pVBData.writeFloat( -tx );
			pVBData.writeFloat( 0 );
			pVBData.writeFloat( 1 );
			pVBData.writeFloat( 0.0 );// u
			pVBData.writeFloat( v );// v
			// B
			pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 1.0 ); pVBData.writeUnsignedInt( 0xFFFFFFFF );
			pVBData.writeFloat( -tx );
			pVBData.writeFloat( ty*2 );
			pVBData.writeFloat( 1 );
			pVBData.writeFloat( 0.0 );// u
			pVBData.writeFloat( 0.0 );// v
			// C
			pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 1.0 ); pVBData.writeUnsignedInt( 0xFFFFFFFF );
			pVBData.writeFloat( tx );
			pVBData.writeFloat( ty*2 );
			pVBData.writeFloat( 1 );
			pVBData.writeFloat( u );// u
			pVBData.writeFloat( 0.0 );// v
			// D
			pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 1.0 ); pVBData.writeUnsignedInt( 0xFFFFFFFF );
			pVBData.writeFloat( tx );
			pVBData.writeFloat( 0 );
			pVBData.writeFloat( 1 );
			pVBData.writeFloat( u );// u
			pVBData.writeFloat( v );// v
			m_pVB.UploadVertexBufferFromByteArray( pVBData );
			
			if ( m_pIB == null || m_pIB.GetFaceNum() != 2 )
			{
				m_pIB = new dIndexBuffer( 2 , m_pDevice );
				var pIBData:Vector.<uint> = new Vector.<uint>;
				pIBData.push( 0 , 1 , 2 , 0 , 2 , 3 );
				m_pIB.UploadIndexBufferFromVector( pIBData );
			}
		}
		public function CreateByTexture( list:Vector.<int> , pTexture:dTexture ):void
		{
			m_bTextureNeedRelease = false;
			if ( pTexture == null )
				pTexture = m_pDevice.GetScene().GetDefaultNumberTexture();
			m_pTexture = pTexture;
			var s:Number = m_pTexture.GetWidth();
			if ( s == 0 ) s = 512;
			m_pVB = new dVertexBuffer( list.length * 4 , "0,FLOAT4,POSITION\n0,UBYTE4,COLOR\n0,FLOAT3,NORMAL\n0,FLOAT2,TEXCOORD" , m_pDevice );
			var pVBData:ByteArray = new ByteArray();
			pVBData.endian = "littleEndian";
			var maxWidth:Number = 0.0;
			var maxHeight:Number = 0.0;
			for ( var i:int = 0 ; i < list.length ; i ++ )
			{
				maxWidth += m_pTexture.GetDeclRect( list[i] ).GetWidth() * s;
				if ( maxHeight < m_pTexture.GetDeclRect( list[i] ).GetHeight() * s )
					 maxHeight = m_pTexture.GetDeclRect( list[i] ).GetHeight() * s;
			}
			var x:Number = -maxWidth/2.0;
			m_nWidth = maxWidth;
			m_nHeight = maxHeight;
			for ( i = 0 ; i < list.length ; i ++ )
			{
				// 顶点顺序：
				// B1   2 4C
				//   |---|
				//   |---|
				// A0 3   5D
				var uv:dTextureRect = m_pTexture.GetDeclRect( list[i] );
				var w:Number = m_pTexture.GetDeclRect( list[i] ).GetWidth() * s;
				var h:Number = m_pTexture.GetDeclRect( list[i] ).GetHeight() * s;
				// A
				pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 1.0 ); pVBData.writeUnsignedInt( 0xFFFFFFFF );
				pVBData.writeFloat( x/maxWidth );
				pVBData.writeFloat( 0 );
				pVBData.writeFloat( 1 );
				pVBData.writeFloat( uv.left );// u
				pVBData.writeFloat( uv.bottom );// v
				// B
				pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 1.0 ); pVBData.writeUnsignedInt( 0xFFFFFFFF );
				pVBData.writeFloat( x/maxWidth );
				pVBData.writeFloat( h/maxHeight );
				pVBData.writeFloat( 1 );
				pVBData.writeFloat( uv.left );// u
				pVBData.writeFloat( uv.top );// v
				// C
				pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 1.0 );pVBData.writeUnsignedInt( 0xFFFFFFFF );
				pVBData.writeFloat( (w + x)/maxWidth );
				pVBData.writeFloat( h/maxHeight );
				pVBData.writeFloat( 1 );
				pVBData.writeFloat( uv.right );// u
				pVBData.writeFloat( uv.top );// v
				// D
				pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 0.0 ); pVBData.writeFloat( 1.0 );pVBData.writeUnsignedInt( 0xFFFFFFFF );
				pVBData.writeFloat( (w + x)/maxWidth );
				pVBData.writeFloat( 0 );
				pVBData.writeFloat( 1 );
				pVBData.writeFloat( uv.right );// u
				pVBData.writeFloat( uv.bottom );// v
				
				x += w;
			}
			m_pVB.UploadVertexBufferFromByteArray( pVBData );
			if ( m_pIB == null || m_pIB.GetFaceNum() != list.length * 2 )
			{
				m_pIB = new dIndexBuffer( list.length * 2 , m_pDevice );
				var pIBData:Vector.<uint> = new Vector.<uint>;
				for ( i = 0 ; i < list.length ; i ++ )
					pIBData.push( 0+i*4 , 1+i*4 , 2+i*4 , 0+i*4 , 2+i*4 , 3+i*4 );
				m_pIB.UploadIndexBufferFromVector( pIBData );
			}
		}
		public function Play( type:int ):void
		{
			m_nPlayType = type;
			m_vPos.Set( 0 , 0 , 0 );
			var r:Number = Math.random() * 3.14159;
			m_vDir.Set( Math.random()-0.5 , 0.0 , Math.random()-0.5 );
			m_fJumpYAdd = 10.0;
		}
		public function OnFrameMove():int
		{
			if ( m_nPlayType == dGame3DSystem.BNUNBER_PLAY_JUMP )
			{
				m_fJumpYAdd -= m_pDevice.GetTick() / 30.0 ;
				m_vDir.y += m_fJumpYAdd * m_pDevice.GetTick() / 500.0;
				m_vPos.AddAppend( m_vDir.Mul( m_pDevice.GetTick() / 1000.0 ) );
				if ( m_vPos.y < -1.0 ) return 1;
			}
			return 0;
		}
		public function Render( matWorld:dMatrix , shader:dShaderBase ):void
		{
			if ( m_pTexture )
			{
				var tan:Number = Math.tan( 3.14159 / 8.0 );
				var tx:Number = tan*(m_pDevice.GetScreenWidth()/m_pDevice.GetScreenHeight());
				var ty:Number = tan;
				var _11:Number = matWorld._11;
				var _22:Number = matWorld._22;
				matWorld._11 *= tx * ( m_nWidth / m_pDevice.GetScreenWidth() );
				matWorld._22 *= ty * ( m_nHeight / m_pDevice.GetScreenHeight() );
				matWorld._41 += m_vPos.x;
				matWorld._42 += m_vPos.y;
				matWorld._43 += m_vPos.z;
				shader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_WORLD , matWorld );
				shader.SetShaderConstantsFloat( dGame3DSystem.SHADER_LERP , 1.0 );
				matWorld._41 -= m_vPos.x;
				matWorld._42 -= m_vPos.y;
				matWorld._43 -= m_vPos.z;
				matWorld._11 = _11;
				matWorld._22 = _22;
				m_pTexture.SetToDevice( 0 );
				m_pVB.SetToDevice();
				m_pVB.SetToDevice( 4 );
				m_pIB.Render();
			}
		}
	}

}