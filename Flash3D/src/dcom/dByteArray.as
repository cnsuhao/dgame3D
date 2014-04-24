//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dcom
{
	public class dByteArray
	{
		public static const BIG_ENDIAN:int = 0;
		public static const LITTLE_ENDIAN:int = 1;
		public var m_pBaseObject:Object;
		public static var s_strCurrentFilePath:String = "";
		public function dByteArray():void
		{
			m_pBaseObject = dInterface.ptr.CreateByteArray();
		}
		public function ReadChar():int
		{
			return dInterface.ptr.ByteArrayReadChar( m_pBaseObject );
		}
		public function ReadByte():int
		{
			return dInterface.ptr.ByteArrayReadByte( m_pBaseObject );
		}
		public function GetByte(pos:int):int
		{
			SetPosition( pos );
			return ReadByte();
		}
		public function ReadShort():int
		{
			return dInterface.ptr.ByteArrayReadShort( m_pBaseObject );
		}
		public function ReadUnsignedShort():int
		{
			return dInterface.ptr.ByteArrayReadUnsignedShort( m_pBaseObject );
		}
		public function ReadInt():int
		{
			return dInterface.ptr.ByteArrayReadInt( m_pBaseObject );
		}
		public function ReadFloat():Number
		{
			return dInterface.ptr.ByteArrayReadFloat( m_pBaseObject );
		}
		public function ReadString():String
		{
			return ReadStringEx( 0 , dStringUtils.CODE_PAGE_UTF8 );
		}
		public function ReadStringEx(nSizeInBits:int, nCodePage:int):String
		{
			return dInterface.ptr.ByteArrayReadString( m_pBaseObject , nSizeInBits , nCodePage );
		}
		public function ToStringBuffer():String
		{
			return dInterface.ptr.ByteArrayToString( m_pBaseObject );
		}
		public function ReadBin():dByteArray
		{
			return ReadBinEx( AvailableSize() );
		}
		public function ReadBinEx(size:int):dByteArray
		{
			var ret:dByteArray = new dByteArray();
			ret.SetEndian( GetEndian() );
			ret.m_pBaseObject = dInterface.ptr.ByteArrayReadBin( m_pBaseObject , size );
			return ret;
		}
		public function WriteByte(data:int):void
		{
			dInterface.ptr.ByteArrayWriteByte( m_pBaseObject , data );
		}
		public function WriteShort(data:int):void
		{
			dInterface.ptr.ByteArrayWriteShort( m_pBaseObject , data );
		}
		public function WriteInt(data:int):void
		{
			dInterface.ptr.ByteArrayWriteInt( m_pBaseObject , data );
		}
		public function WriteFloat(data:Number):void
		{
			dInterface.ptr.ByteArrayWriteFloat( m_pBaseObject , data );
		}
		public function WriteString(data:String):void
		{
			WriteStringEx( data , 0 , dStringUtils.CODE_PAGE_UTF8 );
		}
		public function WriteStringEx(data:String, nstringLength:int, charset:int):void
		{
			dInterface.ptr.ByteArrayWriteString( m_pBaseObject , data , nstringLength , charset );
		}
		public function WriteBin(data:dByteArray):void
		{
			WriteBinEx( data , data.AvailableSize() );
		}
		public function WriteBinEx(data:dByteArray, size:int):void
		{
			dInterface.ptr.ByteArrayWriteBin( m_pBaseObject , data.m_pBaseObject , size );
		}
		public function Size():int
		{
			return dInterface.ptr.ByteArraySize( m_pBaseObject );
		}
		public function AvailableSize():int
		{
			return dInterface.ptr.ByteArrayAvailableSize( m_pBaseObject );
		}
		public function GetPosition():int
		{
			return dInterface.ptr.ByteArrayGetPos( m_pBaseObject );
		}
		public function SetPosition(pos:int):void
		{
			dInterface.ptr.ByteArraySetPos( m_pBaseObject , pos );
		}
		public function GetEndian():int
		{
			return dInterface.ptr.ByteArrayGetEndian( m_pBaseObject );
		}
		public function SetEndian(endian:int):void
		{
			dInterface.ptr.ByteArraySetEndian( m_pBaseObject , endian );
		}
		public function LoadFromFile( strFileName:String , onComplete:Function , onProgress:Function , onFailed:Function ):void
		{
			var fileName:String = strFileName;
			if (dStringUtils.CharAt( strFileName , 1 ) != ":" ) 
                fileName = dByteArray.s_strCurrentFilePath + strFileName;
			var pThis:* = this;
			dInterface.ptr.ByteArrayLoadFromFile( m_pBaseObject , fileName , function(p:Object):void
			{
				m_pBaseObject = p;
				if ( onComplete != null ) onComplete( pThis );
			}, onProgress , onFailed );
		}
		public function Compress():void
		{
			dInterface.ptr.ByteArrayCompress( m_pBaseObject );
		}
		public function Uncompress():void
		{
			dInterface.ptr.ByteArrayUncompress( m_pBaseObject );
		}
		public static function GetCurrentFilePath():String
        {
            return dByteArray.s_strCurrentFilePath;
        }

        public static function SetCurrentPath(arg1:String):void
        {
            dByteArray.s_strCurrentFilePath = arg1;
            if (dStringUtils.CharAt(s_strCurrentFilePath , s_strCurrentFilePath.length - 1) != "/") 
                dByteArray.s_strCurrentFilePath += "/";
            return;
        }
	}
}