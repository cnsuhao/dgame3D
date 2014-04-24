//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author dym
	 */
	public class dTexture_ReadDDS 
	{
		
		public function dTexture_ReadDDS() 
		{
			
		}
		static public function DDSRead( data:ByteArray ):BitmapData
		{
			var header_magic:int = data.readInt();// DDS_
			var header_dwSize:int = data.readInt();
			var header_dwFlags:int = data.readInt();
			var header_dwHeight:int = data.readInt();
			var header_dwWidth:int = data.readInt();
			var header_dwPitchOrLinearSize:int = data.readInt();
			var header_dwDepth:int = data.readInt();
			var header_dwMipMapCount:int = data.readInt();
			data.position += 4 * 11;// reserved
			var header_pix_format_dwSize:int = data.readInt();
			var header_pix_format_dwFlags:int = data.readInt();
			var header_pix_format_dwFourCC:int = data.readInt();
			var header_pix_format_dwRGBBitCount:int = data.readInt();
			var header_pix_format_dwRBitMask:int = data.readInt();
			var header_pix_format_dwGBitMask:int = data.readInt();
			var header_pix_format_dwBBitMask:int = data.readInt();
			var header_pix_format_dwAlphaBitMask:int = data.readInt();
			var header_caps_dwCaps1:int = data.readInt();
			var header_caps_dwCaps2:int = data.readInt();
			var header_caps_Reserved1:int = data.readInt();
			var header_caps_Reserved2:int = data.readInt();
			var header_dwReserved1:int = data.readInt();
			var header_dwReserved2:int = data.readInt();
			return null;
		}
	}

}