//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIImageSet 
	{
		public var m_arrImageSetFileName:Array = new Array();
		public var m_arrImageSetRect:Array = new Array();
		public function dUIImageSet() 
		{
		}
		public function GetImageFileName( str:String ):String
		{
			if ( m_arrImageSetFileName[ str ] != null )
				return m_arrImageSetFileName[ str ];
			return "";
		}
		public function GetImageRect( str:String , bReturnNull:Boolean = false ):dUIImageRect
		{
			if ( m_arrImageSetRect[ str ] != null )
				return m_arrImageSetRect[ str ];
			if( !bReturnNull )
				return new dUIImageRect();
			return null;
		}
		protected function SplitRect( str:String ):dUIImageRect
		{
			var step:int = 0;
			var rc:dUIImageRect = new dUIImageRect();
			var s2:String = new String;
			for ( var i:int = 0 ; i < str.length ; i ++ )
			{
				var s:String = str.charAt( i );
				if ( s == "," )
				{
					step++;
					if ( step == 1 )
						rc.left = int(s2);
					else if ( step == 2 )
						rc.top = int(s2);
					else if ( step == 3 )
						rc.right = int(s2);
					else
						rc.bottom = int(s2);
					s2 = "";
				}
				else s2 += s;
			}
			return rc;
		}
		public function Load( strData:String ) : void
		{
			strData += "\n";
			var step:int = 0;
			var s1:String = new String;
			var s2:String = new String;
			var s3:String = new String;
			for( var i:int = 0 ; i < strData.length ; i ++ )
			{
				var s:String = strData.charAt( i );
				if ( s == "\r" )
					continue;
				if( s == "\n" )
				{
					step ++;
					if ( step == 3 )
					{
						var rc:dUIImageRect = SplitRect( s3 + "," );
						m_arrImageSetFileName[ s1 ] = s2;
						m_arrImageSetRect[ s1 ] = rc;
						s1 = "";
						s2 = "";
						s3 = "";
						step = 0;
					}
				}
				else if( step == 0 )
					s1 += s;
				else if( step == 1 )
					s2 += s;
				else
					s3 += s;
			}
		}
		public var m_arrBitmapBuffer:Array = new Array();
	}

}