//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dcom.dBitmapData;
	import dcom.dByteArray;
	import dcom.dInterface;
	import dcom.dRect;
	import dcom.dTimer;
	import dcom.dVector;
	import dGame3D.Math.dColorTransform;
	import dUI._dInterface;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author dym
	 */
	public class dTexture 
	{
		protected var m_pDevice:dDevice;
		protected var m_pTexture:Texture;
		protected var m_strLoadFromFile:String;
		protected var m_nWidth:int;
		protected var m_nHeight:int;
		protected var m_vecDeclareRect:Vector.<dTextureRect>;
		public function dTexture( pDevice:dDevice ) 
		{
			m_pDevice = pDevice;
		}
		public function Release():void
		{
			if ( m_pTexture )
			{
				m_pTexture.dispose();
				m_pTexture = null;
			}
		}
		public function LoadFromFile( strFileName:String , pColorTransform:dColorTransform = null ):void
		{
			/*m_pDevice.LoadBitmapFromFile( strFileName , function( bmpData:BitmapData ):void
			{
				m_pTexture = m_pDevice.GetDevice().createTexture( bmpData.width , bmpData.height , Context3DTextureFormat.BGRA , false );
				LoadFromBitmap( bmpData );
			} );*/
			m_pDevice.LoadBinFromFile( strFileName , function( data:ByteArray ):void
			{
				LoadFromBin( _dInterface.iBridge_TransByteArray( data ) , null , null , 0 , pColorTransform );
			} , null );
		}
		public function LoadFromBin( data:dByteArray , onLoadOK:Function = null , strLoadFromFile:String = null , dataStartOffset:int = 0 , pColorTransform:dColorTransform = null ):void
		{
			m_strLoadFromFile = strLoadFromFile;
			data.SetPosition( dataStartOffset );
			var magic1:int = data.ReadByte();
			var magic2:int = data.ReadByte();
			var magic3:int = data.ReadByte();
			var magic4:int = data.ReadByte();
			if ( magic1 == "D".charCodeAt( 0 ) &&
				 magic2 == "D".charCodeAt( 0 ) &&
				 magic3 == "S".charCodeAt( 0 ) )
			{
				var t:int = 0;
			}
			else
			{
				data.SetPosition( dataStartOffset );
				if ( magic1 == 0xFF && magic2 == 0xD8 && magic3 == 0xFF && magic4 == 0xE0 )
				{
					// 读取JPEG通道
					var alphamagic1:int;
					while ( data.AvailableSize() >= 2 )
					{
						var alphamagic2:int = data.ReadByte();
						if ( alphamagic1 == 0xFF && alphamagic2 == 0xD9 )
						{
							if ( data.AvailableSize() > 4 )
							{
								var alphaDataSize:int = data.ReadInt();
								if ( alphaDataSize == data.AvailableSize() )
								{
									var w:int = data.ReadShort();
									var h:int = data.ReadShort();
									if ( data.AvailableSize() >= alphaDataSize - 4 )
									{
										var pAlphaData:dByteArray = data.ReadBinEx( alphaDataSize - 4 );
										pAlphaData.Uncompress();
									}
								}
								else break;
							}
						}
						alphamagic1 = alphamagic2;
					}
				}
				data.SetPosition( dataStartOffset );
				var bmpData:dBitmapData = new dBitmapData();
				bmpData.LoadFromBin( data , function( p:dBitmapData ):void
				{
					//var bmpData:BitmapData = event.target.content["bitmapData"];
					SetAlphaChannel( bmpData , pAlphaData , function():void
					{
						if ( bmpData.GetWidth() != bmpData.GetHeight() )
						{
							var size:int = bmpData.GetWidth();
							if ( size < bmpData.GetHeight() ) size = bmpData.GetHeight();
							var newBmpData:dBitmapData = new dBitmapData();
							newBmpData.Create( size , size , 0 );
							newBmpData.Draw( bmpData , 0 , 0 , size , size , 0 , 0 , bmpData.GetWidth() , bmpData.GetHeight() );
							
							m_nWidth = newBmpData.GetWidth();
							m_nHeight = newBmpData.GetHeight();
							m_pTexture = m_pDevice.GetDevice().createTexture( newBmpData.GetWidth() , newBmpData.GetHeight() , Context3DTextureFormat.BGRA , false );
							LoadFromBitmap( newBmpData , onLoadOK , true , pColorTransform );
						}
						else
						{
							m_nWidth = bmpData.GetWidth();
							m_nHeight = bmpData.GetHeight();
							m_pTexture = m_pDevice.GetDevice().createTexture( bmpData.GetWidth() , bmpData.GetHeight() , Context3DTextureFormat.BGRA , false );
							LoadFromBitmap( bmpData , onLoadOK , true , pColorTransform );
						}
						if ( m_strLoadFromFile )
						{
							LoadFromFile( m_strLoadFromFile , pColorTransform );
							m_strLoadFromFile = null;
						}
					} );
				} , null );
			}
		}
		protected function SetAlphaChannel( pBitmapData:dBitmapData , alpha:dByteArray , onComplete:Function ):void
		{
			if ( !alpha )
			{
				onComplete();
				return;
			}
			/*// Create Bmp Header
			var bmp:dByteArray = new dByteArray();
			bmp.SetEndian( dByteArray.LITTLE_ENDIAN );
			bmp.WriteByte( 0x42 );// B
			bmp.WriteByte( 0x4D );// M
			bmp.WriteInt( alpha.Size() + 0x438 );// file size
			bmp.WriteInt( 0 );// Reserved
			bmp.WriteInt( 0x436 );// bmp data start offset
			bmp.WriteInt( 0x28 );// header size
			bmp.WriteInt( pBitmapData.GetWidth() );
			bmp.WriteInt( pBitmapData.GetHeight() );
			bmp.WriteShort( 1 );// planes always 1
			bmp.WriteShort( 8 );// bit
			bmp.WriteInt( 0 );// compress type
			bmp.WriteInt( alpha.Size() + 2 );
			bmp.WriteInt( 72 );// HResolution
			bmp.WriteInt( 72 );// VResolution
			bmp.WriteInt( 256 );// color num
			bmp.WriteInt( 0 );// 重要颜色数
			for ( var i:int = 0 ; i < 256 ; i ++ )
				bmp.WriteInt( ( i << 24 ) | ( i << 16 ) | ( i << 8 ) );
			bmp.WriteBin( alpha );
			bmp.SetPosition( 0 );
			//var file:FileReference = new FileReference();
			//file.save( _dInterface.iBridge_OldByteArray( bmp ) , "1.bmp" );
			var pAlphaBmp:dBitmapData = new dBitmapData();
			pAlphaBmp.LoadFromBin( bmp , function( p:dBitmapData ):void
			{
				pBitmapData.DrawChannel( pAlphaBmp , dBitmapData.CHANNEL_A , dBitmapData.CHANNEL_R );
			} , null );*/
			alpha.SetPosition( 0 );
			var pColor:dVector = pBitmapData.GetPixels();
			/*for ( var i:int = 0 ; i < pColor.Size() ; i ++ )
			{
				var c:uint = pColor.get_Item( i ) as uint;
				pColor.set_Item( i , uint( (c&0x00FFFFFF) | alpha.ReadByte() << 24 ) );
			}
			pBitmapData.SetPixels( pColor );*/
			var pThread:dTimer = new dTimer();
			pThread.IntervalFor( 0 , pColor.Size() , 1 , function( p:dTimer , i:int ):void
			{
				var c:int = pColor.get_Item( i );
				pColor.set_Item( i , int( (c & 0x00FFFFFF) | alpha.ReadByte() << 24 ) );
			} , function( p:dTimer , i:int ):void
			{
				pBitmapData.SetPixels( pColor );
				onComplete();
			});
		}
		public function LoadFromBitmap( data:dBitmapData , onLoadOK:Function = null , bAutoScale:Boolean = true , pColorTransform:dColorTransform = null ):void
		{
			if ( pColorTransform )
			{
				/*var pColorMatrix:dColorMatrix = new dColorMatrix();
				pColorMatrix.adjustColor( Number( pColorTransform.nColorBrightness ) , Number( pColorTransform.nColorContrast ) ,
					Number( pColorTransform.nColorSaturation ) , Number( pColorTransform.nColorHue ) );
				data.applyFilter( data , new Rectangle( 0 , 0 , data.width , data.height ) , new Point( 0 , 0 ) ,
					new ColorMatrixFilter( pColorMatrix ) );*/
				data.ApplyColorTransform( pColorTransform.nColorBrightness , pColorTransform.nColorContrast , pColorTransform.nColorSaturation , pColorTransform.nColorHue );
			}
			m_pTexture.uploadFromBitmapData( data.m_pBaseObject.m_pBitmapData );
			var width:int = m_nWidth;
			var height:int = m_nHeight;
			for ( var i:int = 1 ; i < 100 ; i ++ )
			{
				width /= 2;
				height /= 2;
				if ( width < 1 ) width = 1;
				if ( height < 1 ) height = 1;
				var p:dBitmapData = new dBitmapData();
				p.Create( width , height , 0 );
				p.Draw( data , 0 , 0 , width , height , 0 , 0 , data.GetWidth() , data.GetHeight() );
				m_pTexture.uploadFromBitmapData( p.m_pBaseObject.m_pBitmapData , i );
				//p.dispose();
				if ( width == 1 || height == 1 ) break;
			}
			if ( onLoadOK != null ) onLoadOK();
		}
		public function CreateTexture( width:int , height:int , fillColor:uint = 0 ):void
		{
			if ( m_pDevice.isDisposed() ) return;
			m_pTexture = m_pDevice.GetDevice().createTexture( width , height , Context3DTextureFormat.BGRA , false );
			m_nWidth = width;
			m_nHeight = height;
			var bmpData:dBitmapData = new dBitmapData()
			bmpData.Create( width , height , fillColor );
			LoadFromBitmap( bmpData );
		}
		public function SetToDevice( index:int ):void
		{
			m_pDevice.GetDevice().setTextureAt( index , m_pTexture );
		}
		public function GetWidth():int
		{
			return m_nWidth;
		}
		public function GetHeight():int
		{
			return m_nHeight;
		}
		public function AddDeclRect( rc:dTextureRect ):void
		{
			if ( m_vecDeclareRect == null ) m_vecDeclareRect = new Vector.<dTextureRect>;
			m_vecDeclareRect.push( rc );
		}
		public function GetDeclRect( idx:int ):dTextureRect
		{
			if ( m_vecDeclareRect && idx >= 0 && idx < m_vecDeclareRect.length )
				return m_vecDeclareRect[idx];
			return new dTextureRect();
		}
	}

}