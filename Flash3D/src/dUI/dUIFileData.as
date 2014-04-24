//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIFileData 
	{
		protected var m_nLoadLocate:int;
		protected var m_arrPropty:Array = new Array();
		protected var m_arrLanguage:Array = new Array();
		public function dUIFileData() 
		{
			
		}
		protected var m_bLineEnd:Boolean;
		private function _ReadString( strSource:String , length:int = -1 ):String
		{
			m_bLineEnd = false;
			var ret:String = new String();
			for ( var i:int = m_nLoadLocate , n:int = strSource.length ; i < n ; i ++ )
			{
				var s:String = strSource.charAt( i );
				if ( ( s == "," || s == "\n" ) && length == -1 || length == 0 )
				{
					if ( s == "\n" )
						m_bLineEnd = true;
					m_nLoadLocate = i+1;
					return ret;
				}
				else if ( length > 0 ) length --;
				if( length != -1 || s != "\t" && s != " " )
					ret += s;
			}
			m_nLoadLocate = i+1;
			return ret;
		}
		protected function ReadLine( str:String ):Array
		{
			var ret:Array = new Array();
			while ( m_nLoadLocate < str.length )
			{
				var s:String = _ReadString( str );
				var s2:Array = s.split( "=" );
				if ( s2.length == 2 && s2[0].length )
				{
					if ( ( s2[0] as String ).charAt( 0 ) == "$" )
					{
						s2[1] = _ReadString( str , int( s2[1] ) );
					}
					ret[ s2[0] ] = s2[1];
				}
				if ( m_bLineEnd ) break;
			}
			return ret;
		}
		public function LoadFromString( str:String ):void
		{
			m_nLoadLocate = 0;
			if ( _ReadString( str , 4 ) == "DGUI" )
			{
				var header:Array = ReadLine( str );
				var nControlNum:int = int(header["controlNum"]);
				for ( var i:int = 0 ; i < nControlNum ; i ++ )
				{
					var arr:Array = ReadLine( str );
					for ( var k:* in arr )
						SetPropty( i , String( k ) , arr[k] );
				}
			}
		}
		public function SaveToString():String
		{
			var ret:String = "DGUI,version=1,controlNum=" + GetControlNum() + "\n";
			for ( var k:* in m_arrPropty )
			{
				for ( var k2:* in m_arrPropty[k] )
				{
					if ( String( k2 ).charAt() == "$" )
						ret += String( k2 ) + "=" + m_arrPropty[k][k2].length + "," + m_arrPropty[k][k2];
					else
						ret += String( k2 ) + "=" + m_arrPropty[k][k2];
					ret += ",";
				}
				ret += "controlEnd\n";
			}
			return ret;
		}
		public function SetPropty( idx:int , strKey:String , data:String ):void
		{
			if ( !m_arrPropty[idx] ) m_arrPropty[idx] = new Array();
			m_arrPropty[idx][strKey] = data;
		}
		public function GetPropty( idx:int , strKey:String ):String
		{
			if ( !m_arrPropty[idx] || !m_arrPropty[idx][strKey] ) return "";
			return m_arrPropty[idx][strKey];
		}
		public function GetControlNum():int
		{
			var ret:int = 0
			for ( var k:* in m_arrPropty ) ret++;
			return ret;
		}
		public function GetControlIDList():Vector.<int>
		{
			var ret:Vector.<int> = new Vector.<int>();
			for ( var k:* in m_arrPropty )
				ret.push( int( k ) );
			return ret;
		}
		public function SetLanguageName( strLang:String , id:int , name:String ):void
		{
			if ( !m_arrLanguage[strLang] ) m_arrLanguage[strLang] = new Array();
			m_arrLanguage[strLang][id] = name;
		}
		public function GetLanguageList():Vector.<String>
		{
			var ret:Vector.<String> = new Vector.<String>();
			for ( var k:* in m_arrLanguage )
				ret.push( String( k ) );
			return ret;
		}
		public function GetLanguageIDList( strLang:String ):Vector.<int>
		{
			var ret:Vector.<int> = new Vector.<int>();
			if ( !m_arrLanguage[strLang] ) return ret;
			for ( var k:* in m_arrLanguage[strLang] )
				ret.push( int( k ) );
			return ret;
		}
		public function GetLanguageName( strLang:String , id:int ):String
		{
			if ( !m_arrLanguage[strLang] || !m_arrLanguage[strLang][id] ) return null;
			return m_arrLanguage[strLang][id];
		}
	}

}