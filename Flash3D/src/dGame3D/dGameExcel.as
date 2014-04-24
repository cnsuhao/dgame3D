//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author dym
	 */
	public class dGameExcel 
	{
		protected var m_pDevice:dDevice;
		protected var m_vecData:Vector.< Vector.<String> > = new Vector.< Vector.<String> >;
		protected var m_mapID:Array = new Array();
		protected var m_mapTitle:Array = new Array();
		public function dGameExcel( pDevice:dDevice ) 
		{
			m_pDevice = pDevice;
		}
		public function LoadFromFile( strFileName:String , onLoadOK:Function = null ):void
		{
			m_pDevice.LoadBinFromFile( strFileName , function( data:ByteArray ):void
			{
				try
				{
					LoadFromBin( data );
				}
				catch( e:Error )
				{
					throw new Error( strFileName + " " + e.message );
				}
				if ( onLoadOK != null ) onLoadOK();
			} );
		}
		public function LoadFromBin( data:ByteArray ):void
		{
			var strData:String = String(data);
			var arrLine:Array = strData.split( "\r\n" );
			m_vecData.length = arrLine.length;
			for ( var i:int = 0 ; i < arrLine.length ; i ++ )
			{
				m_vecData[i] = new Vector.<String>;
				var arrWord:Array = arrLine[i].split( "\t" );
				for ( var j:int = 0 ; j < arrWord.length ; j ++ )
				{
					m_vecData[i][j] = arrWord[j];
				}
			}
			
			for ( i = 0 ; i < m_vecData.length ; i ++ )
			{
				var line:Vector.<String> = m_vecData[i];
				if ( i == 0 ) // gen title
				{
					for ( j = 0 ; j < line.length ; j ++ )
						m_mapTitle[ line[j] ] = j;
				}
				else
				{
					if ( line.length && line[0] )
					{
						if ( int(line[0]) && m_mapID[ int(line[0]) ] != undefined )
							throw new Error( "ID重复" + int(line[0]) );
						m_mapID[ int(line[0]) ] = i;
					}
				}
			}
		}
		public function ReadWithID( strTabName:String , id:int , nDefaultReturn:Object ):Object
		{
			if ( id == 0 ) return nDefaultReturn;
			if ( m_mapTitle[ strTabName ] == null ) return nDefaultReturn;
			if ( m_mapID[ id ] == null ) return nDefaultReturn;
			return m_vecData[ m_mapID[ id ] ][ m_mapTitle[ strTabName ] ];
		}
		public function GetIDList():Vector.<int>
		{
			var ret:Vector.<int> = new Vector.<int>;
			for ( var id:String in m_mapID )
				ret.push( id );
			return ret;
		}
		public function isHaveID( id:int ):Boolean
		{
			return m_mapID[ id ] != null;
		}
	}

}