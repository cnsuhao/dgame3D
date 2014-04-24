//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dcom
{
	public class dStringUtils
	{
		public static const CODE_PAGE_UTF8:int = 0;
        public static const CODE_PAGE_UNICODE:int = 1;
        public static const CODE_PAGE_GBK:int = 2;
		public static function CharAt( str:String , at:int ):String
		{
			return dInterface.ptr.StringCharAt( str , at );
		}
		public static function CharCodeAt( str:String , at:int , nCodePage:int = dStringUtils.CODE_PAGE_UNICODE ):int
		{
			return dInterface.ptr.StringCharCodeAt( str , at , nCodePage );
		}
		public static function FourCC( a:String, b:String, c:String, d:String, nEndian:int = dByteArray.BIG_ENDIAN ):int
		{
			var c1:int = a.charCodeAt( 0 );
			var c2:int = b.charCodeAt( 0 );
			var c3:int = c.charCodeAt( 0 );
			var c4:int = d.charCodeAt( 0 );
			if( nEndian == dByteArray.BIG_ENDIAN ) return ( c1 << 24 | c2 << 16 | c3 << 8 | c4 );
			else return ( c4 << 24 | c3 << 16 | c2 << 8 | c1 );
			return 0;
		}
	}
}