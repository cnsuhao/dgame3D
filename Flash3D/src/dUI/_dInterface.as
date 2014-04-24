//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI
{
	import dcom.dBitmapData;
	import dcom.dByteArray;
	import dcom.dMap;
	import dcom.dRect;
	import dcom.dStringUtils;
	import dcom.dTextFormat;
	import dcom.dVector;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import dcom.dInterface;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.Socket;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextLineMetrics;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	//import flash.net.URLRequest;
	/**
	 * ...
	 * @author dym
	 */
	public class _dInterface extends dInterface
	{
		public var m_pRoot:Sprite;
		public var m_pStage:Stage;
		static private var s_bInit:Boolean = false;
		public var m_pLoadBitmapFun:Function;
		public var m_pLoadBinFun:Function;
		public static function Init( pRoot:Sprite , pStage:Stage , pLoadBitmapFun:Function = null , pLoadBinFun:Function = null ):void
		{
			if ( !s_bInit )
			{
				var p:_dInterface = new _dInterface();
				p.m_pRoot = pRoot;
				p.m_pStage = pStage;
				p.m_pLoadBitmapFun = pLoadBitmapFun;
				p.m_pLoadBinFun = pLoadBinFun;
				ptr = p;
				s_bInit = true;
			}
		}
		static public function iBridge_TransBitmap( p:BitmapData ):dBitmapData
		{
			var ret:dBitmapData = new dBitmapData();
			var _d:_dBitmapData = new _dBitmapData();
			_d.m_pBitmapData = p;
			ret.m_pBaseObject = _d;
			return ret;
		}
		static public function iBridge_TransByteArray( p:ByteArray ):dByteArray
		{
			var ret:dByteArray = new dByteArray();
			ret.m_pBaseObject = new _dByteArray();
			(ret.m_pBaseObject as _dByteArray).m_pByteArray = p;
			return ret;
		}
		static public function iBridge_OldBitmap( p:dBitmapData ):BitmapData
		{
			return (p.m_pBaseObject as _dBitmapData).m_pBitmapData;
		}
		static public function iBridge_OldByteArray( p:dByteArray ):ByteArray
		{
			return (p.m_pBaseObject as _dByteArray).m_pByteArray;
		}
		override public function CreateSprite():Object
		{
			return new _dSprite( m_pStage );
		}
		override public function SpriteSetFather( p:Object , pFather:Object , at:int ):void
		{
			if ( at != -1 )
			var t:int = 0;
			( p as _dSprite ).SetFather( pFather ? pFather as Sprite : m_pRoot , at );
		}
		override public function SpriteRemoveFather( p:Object ):void
		{
			( p as _dSprite ).RemoveFather();
		}
		override public function SpriteSetPos( p:Object , x:int , y:int ):void
		{
			( p as _dSprite ).SetPos( x , y );
		}
		override public function SpriteSetSize( p:Object , w:int , h:int ):void
		{
			( p as _dSprite ).SetSize( w , h );
		}
		override public function SpriteSetShow( p:Object , bShow:Boolean ):void
		{
			( p as _dSprite ).visible = bShow;
		}
		override public function SpriteSetBitmapData( p:Object , bmp:Object ):void
		{
			( p as _dSprite ).SetBitmapData( bmp as _dBitmapData );
		}
		override public function SpriteSetMouseEventFun( p:Object , fun:Function ):void
		{
			( p as _dSprite ).SetMouseEventFun( fun );
		}
		override public function SpriteSetMouseMoveFun( p:Object , fun:Function ):void
		{
			( p as _dSprite ).SetMouseMoveFun( fun );
		}
		override public function SpriteSetKeyEventFun( p:Object , fun:Function ):void
		{
			( p as _dSprite ).SetKeyEventFun( fun );
		}
		override public function SpriteSetFrameEventFun( p:Object , fun:Function ):void
		{
			( p as _dSprite ).SetFrameEventFun( fun );
		}
		override public function SpriteSetCapture( p:Object , bSet:Boolean ):Boolean
		{
			return ( p as _dSprite ).SetCapture( bSet );
		}
		override public function SpriteGetMouseX( p:Object ):int
		{
			return ( p as _dSprite ).mouseX;
		}
		override public function SpriteGetMouseY( p:Object ):int
		{
			return ( p as _dSprite ).mouseY;
		}
		override public function SpriteSetMouseStyle( p:Object , nStyle:int ):void
		{
			( p as _dSprite ).SetMouseStyle( nStyle );
		}
		override public function SpriteSetAlpha( p:Object , nAlpha:int ):void
		{
			( p as _dSprite ).SetAlpha( nAlpha );
		}
		override public function SpriteSetColorTransform( p:Object , nBrightness:int , nContrast:int , nSaturation:int , nHue:int ):void
		{
			( p as _dSprite ).SetColorTransform( nBrightness , nContrast , nSaturation , nHue );
		}
		override public function SpriteIsKeyDown( p:Object , nKey:int ):Boolean
		{
			return _dSprite.m_mapKey[nKey] as Boolean;
		}
		override public function SpriteDrawMaskCircal( p:Object ):void
		{
			( p as _dSprite ).DrawMaskCircal();
		}
		override public function SpriteCreateBitmapData( p:Object , w:int , h:int ):void
		{
			( p as _dSprite ).CreateBitmapData( w , h );
		}
		override public function SpriteDrawBitmapData( p:Object , src:Object , dest_left:int , dest_top:int , dest_right:int , dest_bottom:int , src_left:int , src_top:int , src_right:int , src_bottom:int , pClip:dRect = null ):void
		{
			( p as _dSprite ).DrawBitmapData( src as _dBitmapData , dest_left , dest_top , dest_right , dest_bottom , src_left , src_top , src_right , src_bottom , pClip );
		}
		override public function SpriteDrawToBitmapData( p:Object , dest:Object , dest_left:int , dest_top:int , dest_right:int , dest_bottom:int , src_left:int , src_top:int , src_right:int , src_bottom:int , pClip:dRect = null ):void
		{
			var dest_width:int = dest_right - dest_left;
			var dest_height:int = dest_bottom - dest_top;
			var src_width:int = src_right - src_left;
			var src_height:int = src_bottom - src_top;
			var m:Matrix = new Matrix();
			m.scale( dest_width / src_width , dest_height / src_height );
			m.translate( dest_left , dest_top );
			var child:Array = new Array();
			var pp:_dSprite = p as _dSprite;
			/*if ( ( p as _dSprite ).m_pBitmapData && ( p as _dSprite ).m_pBitmapData.m_pBitmapData )
				( dest as _dBitmapData ).m_pBitmapData.draw( ( p as _dSprite ).m_pBitmapData.m_pBitmapData , m , null , null , pClip?new Rectangle( pClip.left , pClip.top , pClip.Width() , pClip.Height() ):null );
			else*/
			{
				for ( var i:int = 0 ; i < pp.numChildren ; )
				{
					/*if ( pp.getChildAt( i ) is Bitmap )
						i++;
					else*/
					{
						child.push( pp.getChildAt( i ) );
						pp.removeChildAt( i );
					}
				}
				( dest as _dBitmapData ).m_pBitmapData.draw( ( p as _dSprite ) , m , null , null , pClip?new Rectangle( pClip.left , pClip.top , pClip.Width() , pClip.Height() ):null );
				for ( i = 0 ; i < child.length ; i ++ )
					pp.addChild( child[i] );
			}
		}
		override public function SpriteGetBitmapData( p:Object ):dBitmapData
		{
			return ( p as _dSprite ).GetBitmapData();
		}
		override public function SpriteCreateInputBox( p:Object , nAlign:int , text:String , dest_width:int , bGetCharBound:Boolean , onComplete:Function , vecFormat:Vector.<dTextFormat> , nFormatArgNum:int , nFlag:int ):void
		{
			( p as _dSprite ).CreateInputBox( nAlign , text , dest_width , bGetCharBound , onComplete , vecFormat , nFormatArgNum , nFlag );
		}
		override public function SpriteReleaseInputBox( p:Object ):void
		{
			( p as _dSprite ).ReleaseInputBox();
		}
		override public function SpriteSetInputBoxSelection( p:Object , nBegin:int , nEnd:int ):void
		{
			( p as _dSprite ).SetInputBoxSelection( nBegin , nEnd );
		}
		override public function SpriteGetInputBoxSelectionBegin( p:Object ):int
		{
			return ( p as _dSprite ).GetInputBoxSelectionBegin();
		}
		override public function SpriteGetInputBoxSelectionEnd( p:Object ):int
		{
			return ( p as _dSprite ).GetInputBoxSelectionEnd();
		}
		override public function SpriteSetInputBoxFocus( p:Object , bSet:Boolean ):void
		{
			( p as _dSprite ).SetInputBoxFocus( bSet );
		}
		// map
		override public function CreateMap():Object
		{
			return new Array();
		}
		override public function SetMap( m:Object , key:Object , value:Object ):void
		{
			( m as Array )[ key ] = value;
		}
		override public function GetMap( m:Object , key:Object , pDefault:Object ):Object
		{
			if ( ( m as Array )[key] == undefined ) return pDefault;
			return ( m as Array )[key];
		}
		override public function MapBegin( m:Object ):Object
		{
			var ret:Array = new Array();
			for ( var s:* in m )
				ret.push( s );
			if ( ret.length == 0 ) return null;
			return ret;
		}
		override public function MapNext( m:Object , iterator:Object ):Object
		{
			var ite:Array = iterator as Array;
			ite.shift();
			if ( ite.length == 0 ) return null;
			return ite;
		}
		override public function MapRemoveIterator( m:Object , iterator:Object ):Object
		{
			var key:Object = MapFirst( m , iterator );
			delete (m as Array)[key];			
			( iterator as Array ).shift();
			if ( (iterator as Array).length == 0 ) return null;
			return iterator;
		}
		override public function MapRemoveKey( m:Object , key:Object ):void
		{
			delete (m as Array)[key];
		}
		override public function MapFirst( m:Object , iterator:Object ):Object
		{
			return iterator[0];
		}
		override public function MapSecond( m:Object , iterator:Object ):Object
		{
			return m[ iterator[0] ];
		}
		override public function MapSize( m:Object ):int
		{
			var r:int = 0;
			for each ( var p:* in ( m as Array ) ) r ++;
			return r;
		}
		override public function MapClear( m:Object ):void
		{
			var key:Array = new Array();
			for each ( var p:* in ( m as Array ) ) key.push(p);
			for ( var i:int = 0 ; i < key.length ; i ++ )
				delete ( m as Array )[key[i]];
		}
		// bitmapData
		override public function CreateBitmapData( p:Object , w:int , h:int , color:uint ):Object
		{
			if ( !p ) p = new _dBitmapData();
			( p as _dBitmapData ).Resize( w , h , color );
			return p;
		}
		override public function BitmapDataFillColor( p:Object , color:uint ):void
		{
			( p as _dBitmapData ).m_pBitmapData.fillRect( new Rectangle( 0 , 0 , p.GetWidth() , p.GetHeight() ) , color );
		}
		override public function BitmapDataLoadFromFile( p:Object , url:String , onComplete:Function , onProgress:Function , onFailed:Function ):void
		{
			if ( m_pLoadBitmapFun != null )
			{
				m_pLoadBitmapFun( p , url , onComplete , onProgress , onFailed );
				return;
			}
			Interface_LoadBitmapData( p , url , onComplete , onProgress , onFailed );
		}
		static public function Interface_LoadBitmapData( p:Object , url:String , onComplete:Function , onProgress:Function , onFailed:Function ):void
		{
			new _dFileLoader( url , true , function( bmp:BitmapData ):void
			{
				( p as _dBitmapData ).m_pBitmapData = bmp;
				onComplete( p );
			} , onProgress , onFailed );
		}
		override public function BitmapDataLoadFromBin( p:Object , baseByteArray:Object , onComplete:Function , onFailed:Function ):void
		{
			var loader:Loader = new Loader();
			loader.loadBytes( (baseByteArray as _dByteArray).m_pByteArray );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, function( event:Event ):void
			{
				var bmpData:BitmapData = event.target.content["bitmapData"];
				( p as _dBitmapData ).m_pBitmapData = bmpData;
				onComplete( p );
			} );
		}
		private static var _formatCalculator:TextField = new TextField();
		private function calcPlaceholderFormat(width:Number, height:Number, format:TextFormat ):void
		{
			//var _formatCalculator:TextField = new TextField();
			_formatCalculator.text = String.fromCharCode(12288);
			var _placeholderMarginH:int = 1;
			var _placeholderMarginV:int = 0;
			format.size = height + 2 * _placeholderMarginV;
			//calculate placeholder text metrics with certain size to get actual letterSpacing
			_formatCalculator.setTextFormat(format);
			var metrics:TextLineMetrics = _formatCalculator.getLineMetrics(0);
			//letterSpacing is the key value for placeholder
			format.letterSpacing = width - metrics.width + 2 * _placeholderMarginH;
		}
		public function CreateTextField( pText:TextField , nAlign:int , text:String , dest_width:int , vecFormat:Vector.<dTextFormat> , nFormatArgNum:int ):TextField
		{
			if ( !pText ) pText = new TextField();
			pText.width = dest_width != -1 ? dest_width : 0x7FFFFFFF;
			pText.height = 0x7FFFFFFF;
			var nSel1:int = pText.selectionBeginIndex;
			var nSel2:int = pText.selectionEndIndex;
			pText.text = " ";
			pText.setTextFormat( new TextFormat(null,0) , 0 , 1);
			pText.text = text;
			pText.setSelection( nSel1 , nSel2 );
			pText.multiline = true;
			pText.wordWrap = false;
			if ( nFormatArgNum )
			{
				var format:TextFormat = new TextFormat();
				format.leading = 4;
				if ( nAlign & dUISystem.GUI_ALIGN_LEFT )
					format.align = TextFormatAlign.LEFT;
				else if ( nAlign & dUISystem.GUI_ALIGN_RIGHT )
					format.align = TextFormatAlign.RIGHT;
				else
					format.align = TextFormatAlign.CENTER;
				//if ( ( vecFormat[0] as dTextFormat ).dwEdgeColor && ( vecFormat[0] as dTextFormat ).nEdgeSize )
				var filters:Array = [new GlowFilter( vecFormat[i].dwEdgeColor & 0x00FFFFFF ,
					Number( ( (vecFormat[i].dwEdgeColor & 0xFF000000 ) >> 24 ) & 0xFF ) / 255.0 ,
					vecFormat[i].nEdgeSize + 1, vecFormat[i].nEdgeSize + 1, 10)];
				if ( (vecFormat[0] as dTextFormat).nShadowLength )
					filters.push( new DropShadowFilter( (vecFormat[0] as dTextFormat).nShadowLength ) );
				pText.filters = filters;
				for ( var i:int = 0 ; i < nFormatArgNum ; i ++ )
				{
					format.letterSpacing = 0;
					format.font = vecFormat[i].strFontFace;
					if ( vecFormat[i].nImageWidth || vecFormat[i].nImageHeight )
						calcPlaceholderFormat( vecFormat[i].nImageWidth , vecFormat[i].nImageHeight , format );
					else
						format.size = vecFormat[i].nFontSize;
					format.color = vecFormat[i].dwFontColor;
					format.underline = vecFormat[i].bUnderLine;
					format.bold = vecFormat[i].bBold;
					format.italic = vecFormat[i].bItaric;
					if ( vecFormat[i].nBeginIndex == 0 && pText.text.length == 0 )
						pText.defaultTextFormat = format;
					else
						pText.setTextFormat( format , vecFormat[i].nBeginIndex , vecFormat[i].nEndIndex );
					if ( pText.type == TextFieldType.INPUT )
						pText.textColor = uint( format.color );
				}
			}
			//pText.wordWrap = (dest_width != -1 && pText.textWidth + 4 > dest_width);
			//if ( dest_width != -1 && pText.type == TextFieldType.INPUT )
			//	pText.wordWrap = true;
			pText.wordWrap = (dest_width != -1);
			pText.appendText( "" );
			if ( dest_width == -1 )
				pText.width = pText.textWidth + 4;
			pText.height = pText.textHeight + 4;
			/*if ( pText.length )
			{
				var start:int = pText.getLineOffset( pText.numLines - 1 );
				for ( var j:int = start ; j < pText.length ; j ++ )
				{
					var p:TextFormat = pText.getTextFormat( j , j + 1 );
					p.leading = 0;
					pText.setTextFormat( p , j , j + 1 );
				}
			}*/
			if ( pText.length && pText.numLines == 1 )
			{
				var p:TextFormat = pText.getTextFormat( 0 , pText.length );
				p.leading = 0;
				pText.setTextFormat( p , 0 , pText.length );
				pText.appendText( "" );
			}
			pText.height = pText.textHeight + 4;
			return pText;
		}
		private function BlendColor( c1:uint , c2:uint , b:Number ):uint
		{
			if ( b < 0.0 ) b = 0.0;
			else if ( b > 1.0 ) b = 1.0;
			var a1:uint = (( c1 & 0xFF000000 ) >> 24) & 0xFF;
			var a2:uint = (( c2 & 0xFF000000 ) >> 24) & 0xFF;
			b *= Number( a2 ) / 255.0;
			var r1:uint = (( c1 & 0x00FF0000 ) >> 16) & 0xFF;
			var g1:uint = (( c1 & 0x0000FF00 ) >> 8) & 0xFF;
			var b1:uint = ( c1 & 0x000000FF );
			var r2:uint = (( c2 & 0x00FF0000 ) >> 16) & 0xFF;
			var g2:uint = (( c2 & 0x0000FF00 ) >> 8) & 0xFF;
			var b2:uint = ( c2 & 0x000000FF );
			return int( r1 * ( 1.0 - b ) + r2 * b ) << 16 | int( g1 * ( 1.0 - b ) + g2 * b ) << 8 | int ( b1 * ( 1.0 - b ) + b2 * b ) | ( a1 ) << 24;
		}
		private static var s_pTextForLoadBitmapData:TextField = new TextField();
		override public function BitmapDataLoadFromText( p:Object , nAlign:int , text:String , dest_width:int , bGetCharBound:Boolean , onComplete:Function , vecFormat:Vector.<dTextFormat> , nFormatArgNum:int ):void
		{
			if ( text == "" )
			{
				( p as _dBitmapData ).Resize( 0 , 0 );
				onComplete( p , null , 0 );
			}
			else
			{
				/*var pText:RichTextField = new RichTextField( strFontFace , nFontSize , nFontColor );
				pText.html = true;
				pText.setSize( dest_width != -1 ? dest_width : 0x7FFFFFFF , 0x7FFFFFFF );
				pText.SetText( nAlign , text , strFontFace , nFontSize , nFontColor , nEdgeColor , nEdgeSize );
				pText.setSize( pText.textWidth + 4 , pText.textHeight + 4 );
				if ( nEdgeColor && nEdgeSize )
					pText.textfield.filters = [new GlowFilter( nEdgeColor , 1, nEdgeSize+1, nEdgeSize+1, 10)];//0x10414F
				var pBitmapData:_dBitmapData = p as _dBitmapData;
				var bmpData:BitmapData = p as BitmapData;
				if ( pText.textWidth && pText.textHeight )
				{
					pBitmapData.Resize( pText.width , pText.height , 0 );
					pText.Draw( pBitmapData.m_pBitmapData );
				}
				else pBitmapData.Resize( 0 , 0 );
				onComplete( pBitmapData , null , 0 );*/
				var pText:TextField = CreateTextField( s_pTextForLoadBitmapData , nAlign , text , dest_width , vecFormat , nFormatArgNum );
				if ( dest_width != -1 && pText.textWidth + 4 < dest_width && pText.type != TextFieldType.INPUT && pText.numLines == 1 )
				{
					pText.wordWrap = false;
					pText.width = pText.textWidth + 4;
				}
				if ( pText.textWidth && pText.textHeight && pText.width && pText.height )
				{
					( p as _dBitmapData ).Resize( pText.width , pText.height , 0 );
					var bHasGradientColor:Boolean = false;
					for ( var i:int = 0 ; i < vecFormat.length ; i ++ )
					{
						if ( vecFormat[i].dwFontGradientColor != 0 )
						{
							bHasGradientColor = true;
							break;
						}
					}
					if ( bHasGradientColor )
					{
						var sp:Sprite = new Sprite();
						for ( i = 0 ; i < pText.numLines ; i ++ )
						{
							var nMaxEdgeSize:int = 0;
							for ( var k:int = 0 ; k < vecFormat.length ; k ++ )
							{
								if ( (vecFormat[k] as dTextFormat).dwEdgeColor != 0 && nMaxEdgeSize < (vecFormat[k] as dTextFormat).nEdgeSize )
									 nMaxEdgeSize = (vecFormat[k] as dTextFormat).nEdgeSize;
							}
							var line:TextLineMetrics = pText.getLineMetrics( i );
							if ( !line || !pText.getCharBoundaries( pText.getLineOffset( i ) ) )
								continue;
							var nY:int = pText.getCharBoundaries( pText.getLineOffset( i ) ).bottom - line.height;
							//var nY:int = pText.getLineMetrics( i ).descent - nMaxEdgeSize;
							if ( nY < 0 ) nY = 0;
							var nHeightPerLine:int = pText.getLineMetrics( i ).height;
							for ( var j:int = 0 ; j < nHeightPerLine + nMaxEdgeSize ; j ++ )
							{
								for ( k = 0 ; k < vecFormat.length ; k ++ )
								{
									var format:dTextFormat = vecFormat[k];
									if ( format.dwFontGradientColor != 0 )
										pText.setTextFormat( new TextFormat( null , null , BlendColor( format.dwFontColor , format.dwFontGradientColor , Number( ( j - 2 ) / nHeightPerLine ) ) ) ,
											format.nBeginIndex , format.nEndIndex );
								}
								if ( ( p as _dBitmapData ).m_pBitmapData )
									( p as _dBitmapData ).m_pBitmapData.draw( pText , null , null , null , new Rectangle( 0 , j + nY , pText.width , 1 ) );
							}
						}
					}
					else
					{
						if ( ( p as _dBitmapData ).m_pBitmapData )
							( p as _dBitmapData ).m_pBitmapData.draw( pText );
					}
				}
				else ( p as _dBitmapData ).Resize( 0 , 0 );
				if ( bGetCharBound )
				{
					var vecBound:Vector.<dRect> = new Vector.<dRect>();
					for ( i = 0 ; i < text.length ; i ++ )
					{
						var rc:Rectangle = pText.getCharBoundaries( i );
						//var lineMetrics:TextLineMetrics = pText.getLineMetrics(pText.getLineIndexOfChar(i));
						//rc.bottom = lineMetrics.ascent;
						if ( rc )
							vecBound.push( new dRect( rc.left , rc.top , rc.right , rc.bottom ) );
						else
							vecBound.push( null );
					}
					onComplete( p , vecBound , vecBound.length );
				}
				else
					onComplete( p , null , 0 );
			}
		}
		override public function BitmapDataDraw( dest2:Object , src2:Object , dest_left:int , dest_top:int , dest_right:int , dest_bottom:int , src_left:int , src_top:int , src_right:int , src_bottom:int , pClip:dRect ):void
		{
			var dest:BitmapData = ( dest2 as _dBitmapData ).m_pBitmapData;
			var src:BitmapData = ( src2 as _dBitmapData ).m_pBitmapData;
			var dest_width:int = dest_right - dest_left;
			var dest_height:int = dest_bottom - dest_top;
			var src_width:int = src_right - src_left;
			var src_height:int = src_bottom - src_top;
			if ( dest_width > 0 && dest_height > 0 && src_width > 0 && src_height > 0 && src )
			{
				/*if ( dest_width == src_width && dest_height == src_height )
					dest.copyPixels( src , new Rectangle( src_left , src_top , src_width , src_height ) , new Point( dest_left , dest_top ) );
				else*/
				{
					var m:Matrix = new Matrix();
					var sx:Number = dest_width / src_width;
					var sy:Number = dest_height / src_height;
					m.scale( sx , sy );
					
					if ( src_left == 0 && src_top == 0 && src_width == src.width && src_height == src.height )
						p = src;
					else
					{
						var p:BitmapData = new BitmapData( src_width , src_height );
						p.copyPixels( src , new Rectangle( src_left , src_top , src_width , src_height ) , new Point( 0 , 0 ) );
					}
					m.translate( dest_left , dest_top );
					dest.draw( p , m , null , null , pClip?new Rectangle( pClip.left , pClip.top , pClip.Width() , pClip.Height() ):null );
				}
			}
		}
		override public function BitmapDataDrawRotation( dest:Object , src:Object , fAngle:Number , bMirrorX:Boolean , bMirrorY:Boolean ):void
		{
			var pDest:BitmapData = (dest as _dBitmapData).m_pBitmapData;
			var pSrc:BitmapData = (src as _dBitmapData).m_pBitmapData;
			if ( !pDest || !pSrc ) return;
			var m:Matrix = new Matrix();
			m.translate( -pSrc.width / 2 , -pSrc.height / 2 );
			m.scale( bMirrorX? -1:1 , bMirrorY? -1:1 );
			m.rotate( fAngle );
			m.translate( pDest.width / 2 , pDest.height / 2 );
			pDest.draw( pSrc , m , null , null , null , true );
		}
		override public function BitmapDataDrawChannel( dest:Object , src:Object , src_channel:int , dest_channel:int ):void
		{
			
		}
		override public function BitmapDataGetWidth( p:Object ):int
		{
			return ( p as _dBitmapData ).GetWidth();
		}
		override public function BitmapDataGetHeight( p:Object ):int
		{
			return ( p as _dBitmapData ).GetHeight();
		}
		override public function BitmapDataGetColorBound( p:Object ):dRect
		{
			if ( !( p as _dBitmapData ).m_pBitmapData ) return new dRect( 0 , 0 , 0 , 0 );
			var rc:Rectangle = ( p as _dBitmapData ).m_pBitmapData.getColorBoundsRect( 0xFF000000 , 0 , false );
			return new dRect( rc.left , rc.top , rc.right , rc.bottom );
		}
		override public function BitmapDataGetPixels( p:Object , left:int , top:int , right:int , bottom:int ):dVector
		{
			var ret:dVector = new dVector();
			var data:Vector.<uint>;
			var pBmp:BitmapData = (p as _dBitmapData).m_pBitmapData;
			if ( !pBmp ) return ret;
			var w:int = pBmp.width;
			var h:int = pBmp.height;
			if ( left == 0 && top == 0 && right == 0 && bottom == 0 )
				data = pBmp.getVector( new Rectangle( 0 , 0 , w , h ) );
			else
			{
				data = pBmp.getVector( new Rectangle( left , top , right - left , bottom - top ) );
				w = right - left;
				h = bottom - top;
			}
			ret.Resize( w * h );
			for ( var j:int = 0 ; j < h ; j ++ )
			{
				for ( var i:int = 0 ; i < w ; i ++ )
				{
					if ( i < w && j < h )
						ret.set_Item( j * w + i , int(data[j * w + i]) );
					else
						ret.set_Item( j * w + i , 0 );
				}
			}
			return ret;
		}
		override public function BitmapDataSetPixels( p:Object , vecData:dVector , left:int , top:int , right:int , bottom:int ):void
		{
			var data:Vector.<uint> = new Vector.<uint>();
			var pBmp:BitmapData = (p as _dBitmapData).m_pBitmapData;
			if ( left == 0 && top == 0 && right == 0 && bottom == 0 )
			{
				right = pBmp.width;
				bottom = pBmp.height;
			}
			var w:int = right - left;
			var h:int = bottom - top;
			data.length = w * h;
			for ( var i:int = 0 ; i < w * h ; i ++ )
				data[i] = vecData.get_Item( i );
			pBmp.setVector( new Rectangle( left , top , w , h ) , data );
		}
		override public function BitmapDataApplyColorTransform( p:Object , nBrightness:int , nContrast:int , nSaturation:int , nHue:int ):void
		{
			if ( !p || !(p as _dBitmapData).m_pBitmapData ) return;
			var pColorMatrix:_dColorMatrix = new _dColorMatrix();
			pColorMatrix.adjustColor( Number( nBrightness ) , Number( nContrast ) , Number( nSaturation ) , Number( nHue ) );
			(p as _dBitmapData).m_pBitmapData.applyFilter( (p as _dBitmapData).m_pBitmapData ,
				new Rectangle( 0 , 0 , (p as _dBitmapData).m_pBitmapData.width , (p as _dBitmapData).m_pBitmapData.height ) , new Point( 0 , 0 ) ,
				new ColorMatrixFilter( pColorMatrix ) );
		}
		// byteArray
		override public function ByteArrayLoadFromFile( p:Object , url:String , onComplete:Function , onProgress:Function , onFailed:Function ):void
		{
			if ( m_pLoadBinFun != null )
			{
				m_pLoadBinFun( p , url , onComplete , onProgress , onFailed );
				return;
			}
			Interface_LoadBin( p , url , onComplete , onProgress , onFailed );
		}
		static public function Interface_LoadBin( p:Object , url:String , onComplete:Function , onProgress:Function , onFailed:Function ):void
		{
			new _dFileLoader( url , false , function( bin:ByteArray ):void
			{
				( p as _dByteArray ).m_pByteArray = bin;
				onComplete( p );
			} , onProgress , onFailed );
		}
		override public function CreateByteArray():Object
		{
			var ret:_dByteArray = new _dByteArray();
			ret.m_pByteArray = new ByteArray();
			return ret;
		}
		override public function ByteArrayReadChar( p:Object ):int
		{
			if ( ( p as _dByteArray ).m_pByteArray.bytesAvailable < 1 )
			{
				( p as _dByteArray ).m_pByteArray.position = ( p as _dByteArray ).m_pByteArray.length;
				return 0;
			}
			return ( p as _dByteArray ).m_pByteArray.readByte();
		}
		override public function ByteArrayReadByte( p:Object ):int
		{
			if ( ( p as _dByteArray ).m_pByteArray.bytesAvailable < 1 )
			{
				( p as _dByteArray ).m_pByteArray.position = ( p as _dByteArray ).m_pByteArray.length;
				return 0;
			}
			return ( p as _dByteArray ).m_pByteArray.readUnsignedByte();
		}
		override public function ByteArrayReadShort( p:Object ):int
		{
			if ( ( p as _dByteArray ).m_pByteArray.bytesAvailable < 2 )
			{
				( p as _dByteArray ).m_pByteArray.position = ( p as _dByteArray ).m_pByteArray.length;
				return 0;
			}
			return ( p as _dByteArray ).m_pByteArray.readShort();
		}
		override public function ByteArrayReadUnsignedShort( p:Object ):int
		{
			if ( ( p as _dByteArray ).m_pByteArray.bytesAvailable < 2 )
			{
				( p as _dByteArray ).m_pByteArray.position = ( p as _dByteArray ).m_pByteArray.length;
				return 0;
			}
			return ( p as _dByteArray ).m_pByteArray.readUnsignedShort();
		}
		override public function ByteArrayReadInt( p:Object ):int
		{
			if ( ( p as _dByteArray ).m_pByteArray.bytesAvailable < 4 )
			{
				( p as _dByteArray ).m_pByteArray.position = ( p as _dByteArray ).m_pByteArray.length;
				return 0;
			}
			return ( p as _dByteArray ).m_pByteArray.readInt();
		}
		override public function ByteArrayReadFloat( p:Object ):Number
		{
			if ( ( p as _dByteArray ).m_pByteArray.bytesAvailable < 4 )
			{
				( p as _dByteArray ).m_pByteArray.position = ( p as _dByteArray ).m_pByteArray.length;
				return 0.0;
			}
			return ( p as _dByteArray ).m_pByteArray.readFloat();
		}
		override public function ByteArrayReadDouble( p:Object ):Number
		{
			if ( ( p as _dByteArray ).m_pByteArray.bytesAvailable < 8 )
			{
				( p as _dByteArray ).m_pByteArray.position = ( p as _dByteArray ).m_pByteArray.length;
				return 0.0;
			}
			return ( p as _dByteArray ).m_pByteArray.readDouble();
		}
		override public function ByteArrayReadString( p:Object , size:int , charset:int ):String
		{
			if ( ( p as _dByteArray ).m_pByteArray.bytesAvailable < 1 )
			{
				( p as _dByteArray ).m_pByteArray.position = ( p as _dByteArray ).m_pByteArray.length;
				return "";
			}
			if ( charset == 0 )
			{
				if ( size <= 0 )
					return ( p as _dByteArray ).m_pByteArray.readUTF();
				else
					return ( p as _dByteArray ).m_pByteArray.readUTFBytes( size );
			}
			else if ( charset == 1 )
			{
				return ( p as _dByteArray ).m_pByteArray.readMultiByte( size , "unicode" );
			}
			return "";
		}
		override public function ByteArrayToString( p:Object ):String
		{
			return String( ( p as _dByteArray ).m_pByteArray );
		}
		override public function ByteArrayReadBin( p:Object , size:int ):Object
		{
			var ret:_dByteArray = new _dByteArray();
			ret.m_pByteArray = new ByteArray;
			ret.m_pByteArray.endian = ( p as _dByteArray ).m_pByteArray.endian;
			if ( size > ( p as _dByteArray ).m_pByteArray.bytesAvailable )
				 size = ( p as _dByteArray ).m_pByteArray.bytesAvailable;
			( p as _dByteArray ).m_pByteArray.readBytes( ret.m_pByteArray , 0 , size );
			ret.m_pByteArray.position = 0;
			return ret;
		}
		override public function ByteArrayWriteByte( p:Object , data:int ):void
		{
			( p as _dByteArray ).m_pByteArray.writeByte( data );
		}
		override public function ByteArrayWriteShort( p:Object , data:int ):void
		{
			( p as _dByteArray ).m_pByteArray.writeShort( data );
		}
		override public function ByteArrayWriteInt( p:Object , data:int ):void
		{
			( p as _dByteArray ).m_pByteArray.writeInt( data );
		}
		override public function ByteArrayWriteFloat( p:Object , data:Number ):void
		{
			( p as _dByteArray ).m_pByteArray.writeFloat( data );
		}
		override public function ByteArrayWriteDouble( p:Object , data:Number ):void
		{
			( p as _dByteArray ).m_pByteArray.writeDouble( data );
		}
		override public function ByteArrayWriteString( p:Object , data:String , size:int , charset:int ):void
		{
			if ( size <= 0 )
				( p as _dByteArray ).m_pByteArray.writeUTF( data );
			else if ( size == data.length )
				( p as _dByteArray ).m_pByteArray.writeUTFBytes( data );
		}
		override public function ByteArrayWriteBin( p:Object , data:Object , size:int ):void
		{
			( p as _dByteArray ).m_pByteArray.writeBytes( ( data as _dByteArray ).m_pByteArray ,
				( data as _dByteArray ).m_pByteArray.position , size );
		}
		override public function ByteArraySize( p:Object ):int
		{
			return ( p as _dByteArray ).m_pByteArray.length;
		}
		override public function ByteArrayAvailableSize( p:Object ):int
		{
			return ( p as _dByteArray ).m_pByteArray.bytesAvailable;
		}
		override public function ByteArraySetPos( p:Object , nPos:int ):void
		{
			( p as _dByteArray ).m_pByteArray.position = nPos;
		}
		override public function ByteArrayGetPos( p:Object ):int
		{
			return ( p as _dByteArray ).m_pByteArray.position;
		}
		override public function ByteArraySetEndian( p:Object , type:int ):void
		{
			if ( type == dByteArray.BIG_ENDIAN )
				( p as _dByteArray ).m_pByteArray.endian = Endian.BIG_ENDIAN;
			else if ( type == dByteArray.LITTLE_ENDIAN )
				( p as _dByteArray ).m_pByteArray.endian = Endian.LITTLE_ENDIAN;
		}
		override public function ByteArrayGetEndian( p:Object ):int
		{
			if ( (p as _dByteArray).m_pByteArray.endian == Endian.BIG_ENDIAN )
				return dByteArray.BIG_ENDIAN;
			if ( (p as _dByteArray).m_pByteArray.endian == Endian.LITTLE_ENDIAN )
				return dByteArray.LITTLE_ENDIAN;
			return 0;
		}
		override public function ByteArrayCompress( p:Object ):void
		{
			( p as _dByteArray ).m_pByteArray.compress();
		}
		override public function ByteArrayUncompress( p:Object ):void
		{
			( p as _dByteArray ).m_pByteArray.uncompress();
		}
		// timer
		override public function CreateTimer( delay:int , repeatCount:int , onTimer:Function ):Object
		{
			var pTimer:_dTimer = new _dTimer();
			pTimer.Create( m_pRoot , delay , repeatCount , onTimer );
			return pTimer;
		}
		override public function TimerStop( p:Object ):void
		{
			( p as _dTimer ).Stop();
		}
		override public function GetTickCount():int
		{
			return getTimer();
		}
		override public function TimerIntervalFor( nStart:int , nLess:int , nStep:int , onLoop:Function , onComplete:Function ):Object
		{
			var pTimer:_dTimer = new _dTimer();
			pTimer.IntervalFor( nStart , nLess , nStep , onLoop , onComplete );
			return pTimer;
		}
		override public function TimerIntervalForBreak( p:Object ):void
		{
			( p as _dTimer ).IntervalBreak();
		}
		override public function TimerIntervalForPause( p:Object , bPause:Boolean ):void
		{
			( p as _dTimer ).IntervalPause( bPause );
		}
		override public function TimerThreadWork( strClassName:Object , strFunctionName:String , pData:dByteArray , onReturn:Function ):void
		{
		}
		override public function TimerThreadReturn( p:Object , pRetData:dByteArray ):void
		{
			( p as _dTimer ).m_pThread.ThreadReturn( pRetData );
		}
		// socket
		override public function CreateSocket():Object
		{
			return new _dSocket();
		}
		override public function SocketConnect( p:Object , ip:String , nPort:int ):void
		{
			( p as _dSocket ).m_pSocket.connect( ip , nPort );
		}
		override public function SocketSetEventFunction( p:Object , onConnectEvent:Function , onReceive:Function ):void
		{
			( p as _dSocket ).SetEventFunction( onConnectEvent , onReceive );
		}
		override public function SocketSend( p:Object , client_id:int , pByteArrayBase:Object ):void
		{
			if ( ( p as _dSocket ).m_pSocket.connected )
			{
				( p as _dSocket ).m_pSocket.writeBytes( ( pByteArrayBase as _dByteArray ).m_pByteArray );
				( p as _dSocket ).m_pSocket.flush();
			}
		}
		// string
		override public function StringFind( str:String , find:String , nStart:int ):int
		{
			return str.indexOf( find , nStart );
		}
		override public function StringCharCodeAt( str:String , at:int , nCodePage:int ):int
		{
			if ( nCodePage == dStringUtils.CODE_PAGE_UNICODE || nCodePage == dStringUtils.CODE_PAGE_UTF8 )
				return str.charCodeAt( at );
			var byte:ByteArray = new ByteArray();
			if ( nCodePage == dStringUtils.CODE_PAGE_GBK )
				byte.writeMultiByte( str.charAt(at) , "gb2312" );
			var ca1:int = byte[0];
			var ca2:int = byte[1];
			return (ca1 << 8) | ca2;
		}
		override public function StringFromCharCode( code:int , nCodePage:int ):String
		{
			return String.fromCharCode( code );
		}
		override public function StringCharAt( str:String , at:int ):String
		{
			return str.charAt( at );
		}
		override public function StringLength( str:String ):int
		{
			return str.length;
		}
		override public function StringToInt( str:String ):int
		{
			return int( str );
		}
		override public function StringToFloat( str:String ):Number
		{
			var r:Number = Number( str );
			if ( isNaN( r ) )
				return 0.0;
			return r;
		}
		override public function IntToString( i:int ):String
		{
			return String( i );
		}
		override public function FloatToString( f:Number ):String
		{
			return String( f );
		}
		// math
		override public function MathRandom():Number
		{
			return Math.random();
		}
		override public function MathSin( r:Number ):Number
		{
			return Math.sin( r );
		}
		override public function MathCos( r:Number ):Number
		{
			return Math.cos( r );
		}
		override public function MathTan( r:Number ):Number
		{
			return Math.tan( r );
		}
		override public function MathAsin( r:Number ):Number
		{
			return Math.asin( r );
		}
		override public function MathAcos( r:Number ):Number
		{
			return Math.acos( r );
		}
		override public function MathAtan( r:Number ):Number
		{
			return Math.atan( r );
		}
		override public function MathSqrt( r:Number ):Number
		{
			return Math.sqrt( r );
		}
		override public function MathPow( r:Number , x:Number ):Number
		{
			return Math.pow( r , x );
		}
	}
}
import dcom.dBitmapData;
import dcom.dByteArray;
import dcom.dTextFormat;
import dcom.dTimer;
import dUI._dInterface;
import dcom.dInterface;
import dcom.dRect;
import dcom.dSocket;
import dcom.dSprite;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.EventDispatcher;
import flash.events.FocusEvent;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.KeyboardEvent;
import flash.events.ProgressEvent;
import flash.events.TextEvent;
import flash.filters.ColorMatrixFilter;
import flash.filters.GlowFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.Socket;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.utils.ByteArray;
import flash.utils.getDefinitionByName;
import flash.utils.Timer;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.display.Sprite;
import flash.display.Bitmap;
import flash.events.MouseEvent;
import flash.display.Stage;
class _dSprite extends Sprite
{
	private static const MouseEvent_RIGHT_MOUSE_DOWN:String = "rightMouseDown";
	private static const MouseEvent_RIGHT_MOUSE_UP:String = "rightMouseUp";
	protected var m_pMouseEventFun:Function;
	protected var m_pKeyEventFun:Function;
	protected var m_pMouseMoveFun:Function;
	protected var m_pFrameEventFun:Function;
	protected var m_pStage:Stage;
	public var m_pBitmap:Bitmap;
	public var m_pBitmapData:_dBitmapData;
	protected var m_mask:Sprite;
	static protected var s_pCapture:_dSprite;
	static public var m_mapKey:Array = new Array();
	protected var m_nWidth:int;
	protected var m_nHeight:int;
	protected var m_rcMask:Rectangle = new Rectangle();
	protected var m_pTextField:TextField;
	/*static private var s_pMaskBitmapData:BitmapData = new BitmapData( 1 , 1 , false , 0 );
	static private var s_pHandleMouseMaskBitmapData:BitmapData = new BitmapData( 1 , 1 , true , 0 );
	protected var m_pHandleMouseMask:Bitmap = new Bitmap();
	protected var m_bAddHandleMouseMask:Boolean;*/
	public function _dSprite( pStage:Stage )
	{
		m_pStage = pStage;
		//m_mask = new Sprite;
		//m_mask.addChild( new Bitmap( s_pMaskBitmapData ) );
		//addChild( m_mask );
		//mask = m_mask;
		//m_pHandleMouseMask.bitmapData = s_pHandleMouseMaskBitmapData;
		
		mouseEnabled = false;
		useHandCursor = false;
		buttonMode = false;
	}
	public function SetPos( _x:int , _y:int ):void
	{
		x = _x;
		y = _y;
	}
	public function SetSize( w:int , h:int ):void
	{
		m_nWidth = w;
		m_nHeight = h;
		if ( m_mask )
		{
			m_mask.graphics.clear();
			m_mask.graphics.beginFill( 0 );
			m_mask.graphics.drawRect( 0 , 0 , w , h );
			m_mask.graphics.endFill();
			//m_mask.getChildAt( 0 ).width = w;
			//m_mask.getChildAt( 0 ).height = h;
		}
		else
		{
			if ( numChildren )
			{
				m_rcMask.width = w;
				m_rcMask.height = h;
				scrollRect = m_rcMask;
			}
			else
				scrollRect = null;
		}
		/*if ( m_pHandleMouseMask )
		{
			m_pHandleMouseMask.width = w;
			m_pHandleMouseMask.height = h;
		}*/
		if ( m_pBitmap )
		{
			m_pBitmap.width = w;
			m_pBitmap.height = h;
		}
		else if ( !cacheAsBitmap )
		{
			//if ( m_pMouseEventFun != null )
			{
				graphics.clear();
				graphics.beginFill( 0 , 0 );
				graphics.drawRect( 0 , 0 , m_nWidth , m_nHeight );
				graphics.endFill();
			}
			//else graphics.clear();
			/*if ( m_pMouseEventFun != null )
			{
				if ( !m_bAddHandleMouseMask )
				{
					addChildAt( m_pHandleMouseMask , 0 );
					m_bAddHandleMouseMask = true;
				}
			}
			else
			{
				if ( m_bAddHandleMouseMask )
				{
					removeChild( m_pHandleMouseMask );
					m_bAddHandleMouseMask = false;
				}
			}*/
		}
		if ( m_pTextField )
		{
			m_pTextField.width = m_nWidth;
			m_pTextField.height = m_nHeight;
		}
	}
	public function DrawMaskCircal():void
	{
		if ( !m_mask )
		{
			m_mask = new Sprite;
			addChild( m_mask );
			mask = m_mask;
		}
		if ( m_mask )
		{
			m_mask.graphics.clear();
			m_mask.graphics.beginFill( 0 );
			m_mask.graphics.drawEllipse( 0 , 0 , m_nWidth , m_nHeight );
			m_mask.graphics.endFill();
		}
	}
	public function CreateBitmapData( w:int , h:int ):void
	{
		cacheAsBitmap = false;
		SetBitmapData( null );
		graphics.clear();
		/*if ( w == 0 || h == 0 ) SetBitmapData( null );
		else
		{
			var p:_dBitmapData = new _dBitmapData();
			p.m_pBitmapData = new BitmapData( w , h , true , 0 );
			SetBitmapData( p );
		}*/
	}
	public function DrawBitmapData( src:_dBitmapData , dest_left:int , dest_top:int , dest_right:int , dest_bottom:int , src_left:int , src_top:int , src_right:int , src_bottom:int , pClip:dRect ):void
	{
		if ( src.m_pBitmapData )
		{
			cacheAsBitmap = true;
			var matr:Matrix = new Matrix();
			var sx:Number = (dest_right - dest_left) / (src_right - src_left);
			var sy:Number = (dest_bottom - dest_top) / (src_bottom - src_top);
			if ( sx <= 0.0 || sy <= 0.0 ) return;
			matr.scale(sx, sy);
			matr.translate( dest_left - src_left , dest_top - src_top );
			graphics.beginBitmapFill(src.m_pBitmapData, matr);
			graphics.drawRect(dest_left, dest_top, dest_right - dest_left, dest_bottom - dest_top);
			graphics.endFill();
			//dInterface.ptr.BitmapDataDraw( m_pBitmapData , src , dest_left , dest_top , dest_right , dest_bottom , src_left , src_top , src_right , src_bottom );
		}
	}
	public function GetBitmapData():dBitmapData
	{
		if ( m_pBitmapData )
			return _dInterface.iBridge_TransBitmap( m_pBitmapData.m_pBitmapData );
		if ( width <= 0 || height <= 0 ) return null;
		var bmp:BitmapData = new BitmapData( width , height , true , 0 );
		bmp.draw( this );
		return _dInterface.iBridge_TransBitmap( bmp );
	}
	public function SetMouseStyle( nType:int ):void
	{
		if ( nType == dSprite.MOUSE_STYLE_ARROW )
		{
			useHandCursor = false;
			buttonMode = false;
			tabEnabled = false;
		}
		else if ( nType == dSprite.MOUSE_STYLE_HAND )
		{
			useHandCursor = true;
			buttonMode = true;
			tabEnabled = false;
		}
	}
	public function SetFather( pFather:Sprite , at:int ):void
	{
		if ( at != -1 )
		{
			if ( pFather is _dSprite )
			{
				if ( (pFather as _dSprite).m_pBitmap ) at ++;
				if ( (pFather as _dSprite).m_mask ) at ++;
				if ( (pFather as _dSprite).m_pTextField ) at++;
				//if ( (pFather as _dSprite).m_bAddHandleMouseMask ) at ++;
			}
			pFather.addChildAt( this , at );
		}
		else
			pFather.addChild( this );
		if ( m_pMouseEventFun != null ) _SetMouseEventFun( m_pMouseEventFun );
		if ( m_pMouseMoveFun != null ) _SetMouseMoveFun( m_pMouseMoveFun );
		if ( m_pKeyEventFun != null ) _SetKeyEventFun( m_pKeyEventFun );
		if ( m_pFrameEventFun != null ) _SetFrameEventFun( m_pFrameEventFun );
		if ( !m_mask && pFather is _dSprite )
		{
			if ( pFather.numChildren )
			{
				(pFather as _dSprite).m_rcMask.width = (pFather as _dSprite).m_nWidth;
				(pFather as _dSprite).m_rcMask.height = (pFather as _dSprite).m_nHeight;
				(pFather as _dSprite).scrollRect = (pFather as _dSprite).m_rcMask;
			}
			else
				(pFather as _dSprite).scrollRect = null;
		}
	}
	public function RemoveFather():void
	{
		if ( s_pMouseInObj == this && s_pLastMouseInObj == this && m_pMouseEventFun != null )
		{
			m_pMouseEventFun( dcom.dSprite.MOUSE_OUT , mouseX , mouseY );
			s_pLastMouseInObj = null;
		}
		if ( parent )
			parent.removeChild( this );
		_SetMouseEventFun( null );
		_SetKeyEventFun( null );
		_SetMouseMoveFun( null );
		_SetFrameEventFun( null );
		SetCapture( false );
	}
	public function SetMouseEventFun( fun:Function ):void
	{
		mouseEnabled = fun != null;
		m_pMouseEventFun = fun;
		_SetMouseEventFun( fun );
		
		if ( m_pBitmap == null && !cacheAsBitmap )
		{
			if ( m_pMouseEventFun != null )
			{
				graphics.clear();
				graphics.beginFill( 0 , 0 );
				graphics.drawRect( 0 , 0 , m_nWidth , m_nHeight );
				graphics.endFill();
			}
			else graphics.clear();
		}
	}
	private function _SetMouseEventFun( fun:Function ):void
	{
		if ( fun != null )
		{
			addEventListener( MouseEvent.MOUSE_DOWN , OnMouseLButtonDown );
			addEventListener( MouseEvent.MOUSE_UP , OnMouseLButtonUp );
			addEventListener( MouseEvent_RIGHT_MOUSE_DOWN , OnMouseRButtonDown );
			addEventListener( MouseEvent_RIGHT_MOUSE_UP , OnMouseRButtonUp );
			addEventListener( MouseEvent.MOUSE_OVER , OnMouseIn );
			addEventListener( MouseEvent.MOUSE_OUT , OnMouseOut );
			addEventListener( MouseEvent.MOUSE_WHEEL , OnMouseWheel );
		}
		else
		{
			removeEventListener( MouseEvent.MOUSE_DOWN , OnMouseLButtonDown );
			removeEventListener( MouseEvent.MOUSE_UP , OnMouseLButtonUp );
			removeEventListener( MouseEvent_RIGHT_MOUSE_DOWN , OnMouseRButtonDown );
			removeEventListener( MouseEvent_RIGHT_MOUSE_UP , OnMouseRButtonUp );
			removeEventListener( MouseEvent.MOUSE_OVER , OnMouseIn );
			removeEventListener( MouseEvent.MOUSE_OUT , OnMouseOut );
			removeEventListener( MouseEvent.MOUSE_WHEEL , OnMouseWheel );
		}
	}
	public function SetMouseMoveFun( fun:Function ):void
	{
		m_pMouseMoveFun = fun;
		_SetMouseMoveFun( fun );
	}
	private function _SetMouseMoveFun( fun:Function ):void
	{
		if ( fun != null )
		{
			addEventListener( MouseEvent.MOUSE_MOVE , OnMouseMove );
		}
		else
		{
			removeEventListener( MouseEvent.MOUSE_MOVE , OnMouseMove );
		}
	}
	public function SetFrameEventFun( fun:Function ):void
	{
		m_pFrameEventFun = fun;
		_SetFrameEventFun( fun );
	}
	private function _SetFrameEventFun( fun:Function ):void
	{
		if ( fun != null )
		{
			m_pStage.root.addEventListener( MouseEvent.MOUSE_WHEEL , OnGlobalMouseWheel );
		}
		else
		{
			m_pStage.root.removeEventListener( MouseEvent.MOUSE_WHEEL , OnGlobalMouseWheel );
		}
	}
	private function OnGlobalMouseWheel( event:MouseEvent ):void
	{
		m_mapKey[ dSprite.VK_CONTROL ] = event.ctrlKey;
		m_mapKey[ dSprite.VK_SHIFT ] = event.shiftKey;
		m_mapKey[ dSprite.VK_ALT ] = event.altKey;
		if ( m_pFrameEventFun( dcom.dSprite.FRAME_MOUSE_WHEEL , event.delta , 0 , null ) )
			event.stopPropagation();
	}
	public function SetCapture( bSet:Boolean ):Boolean
	{
		if ( bSet )
		{
			if ( s_pCapture != this )
			{
				s_pCapture = this;
				m_pStage.root.addEventListener( MouseEvent.MOUSE_UP , OnMouseLButtonUpCapture );
				m_pStage.root.addEventListener( MouseEvent_RIGHT_MOUSE_UP , OnMouseRButtonUpCapture );
				m_pStage.root.addEventListener( MouseEvent.MOUSE_MOVE , OnMouseMoveCapture );
			}
			return true;
		}
		else if ( s_pCapture == this )
		{
			m_pStage.root.removeEventListener( MouseEvent.MOUSE_UP , OnMouseLButtonUpCapture );
			m_pStage.root.removeEventListener( MouseEvent_RIGHT_MOUSE_UP , OnMouseRButtonUpCapture );
			m_pStage.root.removeEventListener( MouseEvent.MOUSE_MOVE , OnMouseMoveCapture );
			s_pCapture = null;
			if ( s_pMouseInObj && s_pLastMouseInObj != s_pMouseInObj && s_pMouseInObj.m_pMouseEventFun != null )
			{
				s_pMouseInObj.m_pMouseEventFun( dcom.dSprite.MOUSE_IN , s_pMouseInObj.mouseX , s_pMouseInObj.mouseY );
				s_pLastMouseInObj = s_pMouseInObj;
			}
			return true;
		}
		return false;
	}
	public function GetCapture():_dSprite
	{
		return s_pCapture;
	}
	public function SetBitmapData( bmp:_dBitmapData ):void
	{
		m_pBitmapData = bmp;
		if ( bmp )
		{
			if ( !m_pBitmap )
			{
				m_pBitmap = new Bitmap( bmp.m_pBitmapData );
				addChildAt( m_pBitmap , 0 );
			}
			else
			{
				m_pBitmap.bitmapData = bmp.m_pBitmapData;
			}
			m_pBitmap.smoothing = true;
		}
		else
		{
			if ( m_pBitmap )
			{
				m_pBitmap.bitmapData = null;
			}
		}
		if ( m_pBitmap )
		{
			m_pBitmap.width = m_nWidth;
			m_pBitmap.height = m_nHeight;
		}
	}
	public function SetAlpha( nAlpha:int ):void
	{
		//if ( m_pBitmap )
		//	m_pBitmap.alpha = Number( nAlpha ) / 255.0;
		//else
			alpha = Number( nAlpha ) / 255.0;
	}
	public function SetColorTransform( nBrightness:int , nContrast:int , nSaturation:int , nHue:int ):void
	{
		if ( !m_pBitmap )
		{
			m_pBitmap = new Bitmap();
			m_pBitmap.smoothing = true;
			addChildAt( m_pBitmap , 0 );
		}
		if ( nBrightness || nContrast || nSaturation || nHue )
		{
			var matrix:_dColorMatrix = new _dColorMatrix();
			matrix.adjustColor( Number( nBrightness ) , Number( nContrast ) , Number( nSaturation ) , Number( nHue ) );
			m_pBitmap.filters = [ new ColorMatrixFilter( matrix ) ];
		}
		else m_pBitmap.filters = null;
	}
	private function _SetKeyEventFun( fun:Function ):void
	{
		if ( fun != null )
		{
			if ( m_pTextField )
			{
				m_pTextField.addEventListener( Event.CHANGE , OnTextChanged );
				m_pTextField.addEventListener( TextEvent.TEXT_INPUT , OnTextInput );
				m_pTextField.addEventListener( FocusEvent.FOCUS_IN , _OnTextFocusIn );
				m_pTextField.addEventListener( FocusEvent.FOCUS_OUT , _OnTextFocusOut );
				m_pTextField.addEventListener( KeyboardEvent.KEY_DOWN , OnKeyDown );
				m_pTextField.addEventListener( KeyboardEvent.KEY_UP , OnKeyUp );
				m_pStage.removeEventListener( KeyboardEvent.KEY_DOWN , OnKeyDown );
				m_pStage.removeEventListener( KeyboardEvent.KEY_UP , OnKeyUp );
			}
			else
			{
				m_pStage.addEventListener( KeyboardEvent.KEY_DOWN , OnKeyDown );
				m_pStage.addEventListener( KeyboardEvent.KEY_UP , OnKeyUp );
			}
		}
		else
		{
			if ( m_pTextField )
			{
				m_pTextField.removeEventListener( Event.CHANGE , OnTextChanged );
				m_pTextField.removeEventListener( TextEvent.TEXT_INPUT , OnTextInput );
				m_pTextField.removeEventListener( FocusEvent.FOCUS_IN , _OnTextFocusIn );
				m_pTextField.removeEventListener( FocusEvent.FOCUS_OUT , _OnTextFocusOut );
				m_pTextField.removeEventListener( KeyboardEvent.KEY_DOWN , OnKeyDown );
				m_pTextField.removeEventListener( KeyboardEvent.KEY_UP , OnKeyUp );
			}
			else
			{
				m_pStage.removeEventListener( KeyboardEvent.KEY_DOWN , OnKeyDown );
				m_pStage.removeEventListener( KeyboardEvent.KEY_UP , OnKeyUp );
			}
		}
	}
	public function SetKeyEventFun( fun:Function ):void
	{
		m_pKeyEventFun = fun;
		_SetKeyEventFun( fun );
	}
	private function OnMouseLButtonDown( event:MouseEvent ):void
	{
		m_mapKey[ dSprite.VK_CONTROL ] = event.ctrlKey;
		m_mapKey[ dSprite.VK_SHIFT ] = event.shiftKey;
		m_mapKey[ dSprite.VK_ALT ] = event.altKey;
		if ( s_pCapture && s_pCapture != this ) return;
		if ( m_pMouseEventFun( dcom.dSprite.MOUSE_LBUTTONDOWN , mouseX , mouseY ) )
			event.stopPropagation();
	}
	private function OnMouseLButtonUp( event:MouseEvent ):void
	{
		m_mapKey[ dSprite.VK_CONTROL ] = event.ctrlKey;
		m_mapKey[ dSprite.VK_SHIFT ] = event.shiftKey;
		m_mapKey[ dSprite.VK_ALT ] = event.altKey;
		if ( s_pCapture ) return;
		if ( m_pMouseEventFun( dcom.dSprite.MOUSE_LBUTTONUP , mouseX , mouseY ) )
			event.stopPropagation();
	}
	private function OnMouseRButtonDown( event:MouseEvent ):void
	{
		m_mapKey[ dSprite.VK_CONTROL ] = event.ctrlKey;
		m_mapKey[ dSprite.VK_SHIFT ] = event.shiftKey;
		m_mapKey[ dSprite.VK_ALT ] = event.altKey;
		if ( s_pCapture && s_pCapture != this ) return;
		if ( m_pMouseEventFun( dcom.dSprite.MOUSE_RBUTTONDOWN , mouseX , mouseY ) )
			event.stopPropagation();
	}
	private function OnMouseRButtonUp( event:MouseEvent ):void
	{
		m_mapKey[ dSprite.VK_CONTROL ] = event.ctrlKey;
		m_mapKey[ dSprite.VK_SHIFT ] = event.shiftKey;
		m_mapKey[ dSprite.VK_ALT ] = event.altKey;
		if ( s_pCapture && s_pCapture != this ) return;
		if ( m_pMouseEventFun( dcom.dSprite.MOUSE_RBUTTONUP , mouseX , mouseY ) )
			event.stopPropagation();
	}
	protected static var s_pMouseInObj:_dSprite;
	protected static var s_pLastMouseInObj:_dSprite;
	private function OnMouseIn( event:MouseEvent ):void
	{
		s_pMouseInObj = this;
		m_mapKey[ dSprite.VK_CONTROL ] = event.ctrlKey;
		m_mapKey[ dSprite.VK_SHIFT ] = event.shiftKey;
		m_mapKey[ dSprite.VK_ALT ] = event.altKey;
		if ( s_pCapture && s_pCapture != this ) { event.stopPropagation(); return; }
		if ( m_pMouseEventFun( dcom.dSprite.MOUSE_IN , mouseX , mouseY ) )
			event.stopPropagation();
		s_pLastMouseInObj = this;
	}
	private function OnMouseOut( event:MouseEvent ):void
	{
		s_pMouseInObj = null;
		m_mapKey[ dSprite.VK_CONTROL ] = event.ctrlKey;
		m_mapKey[ dSprite.VK_SHIFT ] = event.shiftKey;
		m_mapKey[ dSprite.VK_ALT ] = event.altKey;
		if ( s_pCapture && s_pCapture != this ) { event.stopPropagation(); return; }
		if ( m_pMouseEventFun( dcom.dSprite.MOUSE_OUT , mouseX , mouseY ) )
			event.stopPropagation();
		s_pLastMouseInObj = null;
	}
	private function OnMouseWheel( event:MouseEvent ):void
	{
		m_mapKey[ dSprite.VK_CONTROL ] = event.ctrlKey;
		m_mapKey[ dSprite.VK_SHIFT ] = event.shiftKey;
		m_mapKey[ dSprite.VK_ALT ] = event.altKey;
		if ( s_pCapture && s_pCapture != this ) return;
		if ( m_pMouseEventFun( dcom.dSprite.MOUSE_WHEEL , event.delta , 0 ) )
			event.stopPropagation();
	}
	private function OnKeyDown( event:KeyboardEvent ):void
	{
		if ( m_pKeyEventFun( dcom.dSprite.KEY_DOWN , event.keyCode , String.fromCharCode( event.charCode ) ) )
			event.stopPropagation();
		/*if ( event.keyCode == 8 && m_pTextField )
		{
			var e:TextEvent = new TextEvent( TextEvent.TEXT_INPUT , false , false , "\b" );
			OnTextInput( e );
		}*/
	}
	private function OnKeyUp( event:KeyboardEvent ):void
	{
		if ( m_pKeyEventFun( dcom.dSprite.KEY_UP , event.keyCode , String.fromCharCode( event.charCode ) ) )
			event.stopPropagation();
	}
	private function OnMouseMove( event:MouseEvent ):void
	{
		m_mapKey[ dSprite.VK_CONTROL ] = event.ctrlKey;
		m_mapKey[ dSprite.VK_SHIFT ] = event.shiftKey;
		m_mapKey[ dSprite.VK_ALT ] = event.altKey;
		if ( s_pCapture ) return;
		if ( m_pMouseMoveFun != null && m_pMouseMoveFun( 0 , mouseX , mouseY ) )
			event.stopPropagation();
	}
	private function OnMouseMoveCapture( event:MouseEvent ):void
	{
		m_mapKey[ dSprite.VK_CONTROL ] = event.ctrlKey;
		m_mapKey[ dSprite.VK_SHIFT ] = event.shiftKey;
		m_mapKey[ dSprite.VK_ALT ] = event.altKey;
		if ( m_pMouseMoveFun != null && m_pMouseMoveFun( 0 , mouseX , mouseY ) )
			event.stopPropagation();
	}
	private function OnMouseLButtonUpCapture( event:MouseEvent ):void
	{
		m_mapKey[ dSprite.VK_CONTROL ] = event.ctrlKey;
		m_mapKey[ dSprite.VK_SHIFT ] = event.shiftKey;
		m_mapKey[ dSprite.VK_ALT ] = event.altKey;
		if ( m_pMouseEventFun( dcom.dSprite.MOUSE_LBUTTONUP , mouseX , mouseY ) )
			event.stopPropagation();
	}
	private function OnMouseRButtonUpCapture( event:MouseEvent ):void
	{
		m_mapKey[ dSprite.VK_CONTROL ] = event.ctrlKey;
		m_mapKey[ dSprite.VK_SHIFT ] = event.shiftKey;
		m_mapKey[ dSprite.VK_ALT ] = event.altKey;
		if ( m_pMouseEventFun( dcom.dSprite.MOUSE_RBUTTONUP , mouseX , mouseY ) )
			event.stopPropagation();
	}
	public function CreateInputBox( nAlign:int , text:String , dest_width:int , bGetCharBound:Boolean , onComplete:Function , vecFormat:Vector.<dTextFormat> , nFormatArgNum:int , nFlag:int ):void
	{
		if ( !m_pTextField )
		{
			m_pTextField = new TextField();
			m_pTextField.type = TextFieldType.INPUT;
			var at:int = 0;
			if ( m_mask ) at++;
			if ( m_pBitmap ) at++;
			addChildAt( m_pTextField , at );
			m_pTextField.y = 2;
			_SetKeyEventFun( m_pKeyEventFun );
			//m_pTextField.backgroundColor = 0xFFFFFF;
			
		}
		m_pTextField.displayAsPassword = Boolean( nFlag & 1 );
		(dInterface.ptr as _dInterface).CreateTextField( m_pTextField , nAlign , text , dest_width , vecFormat , nFormatArgNum );
		m_pTextField.width = m_nWidth;
		m_pTextField.height = m_nHeight;
		SelectionColor.setFieldSelectionColor( m_pTextField );
		var nBegin:int = m_pTextField.selectionBeginIndex;
		var nEnd:int = m_pTextField.selectionEndIndex;
		m_pTextField.setSelection( 0 , 0 );
		m_pTextField.setSelection( nBegin , nEnd );
		if ( bGetCharBound )
		{
			var vecBound:Vector.<dRect> = new Vector.<dRect>();
			for ( var i:int = 0 ; i < text.length ; i ++ )
			{
				var rc:Rectangle = m_pTextField.getCharBoundaries( i );
				//var lineMetrics:TextLineMetrics = pText.getLineMetrics(pText.getLineIndexOfChar(i));
				//rc.bottom = lineMetrics.ascent;
				if ( rc )
					vecBound.push( new dRect( rc.left , rc.top , rc.right , rc.bottom ) );
				else
					vecBound.push( null );
			}
			onComplete( this , vecBound , vecBound.length );
		}
		else
			onComplete( this , null , 0 );
	}
	public function ReleaseInputBox():void
	{
		if ( m_pTextField )
		{
			_SetKeyEventFun( null );
			removeChild( m_pTextField );
			_SetKeyEventFun( m_pKeyEventFun );
			m_pTextField = null;
		}
	}
	private function OnTextChanged( event:Event ):void
	{
		if ( m_pKeyEventFun( dcom.dSprite.TEXT_INPUT , 0 , m_pTextField.text.replace(/\r/g, "\n") ) )
			event.stopPropagation();
	}
	private function OnTextInput( event:TextEvent ):void
	{
		/*var txt:String = "";
		for ( var i:int = 0 ; i <= m_pTextField.text.length ; i ++ )
		{
			if ( i == m_pTextField.selectionBeginIndex )
			{
				if ( event.text == "\b" )
				{
					if ( m_pTextField.selectionBeginIndex == m_pTextField.selectionEndIndex )
						txt = txt.substr( 0 , txt.length - 1 );
				}
				else
					txt += event.text;
			}
			if ( i >= m_pTextField.selectionBeginIndex && i < m_pTextField.selectionEndIndex )
			{
			}
			else if ( i < m_pTextField.text.length )
				txt += m_pTextField.text.charAt( i );
		}
		if ( m_pKeyEventFun( dcom.dSprite.TEXT_INPUT , 0 , txt ) )
		{
			event.preventDefault();
			event.stopPropagation();
		}*/
	}
	private function _OnTextFocusIn( event:FocusEvent ):void
	{
		if ( m_pKeyEventFun( dSprite.TEXT_FOCUS_IN , 0 , "" ) )
			event.stopPropagation();
	}
	private function _OnTextFocusOut( event:FocusEvent ):void
	{
		if ( m_pKeyEventFun( dSprite.TEXT_FOCUS_LOST , 0 , "" ) )
			event.stopPropagation();
	}
	public function SetInputBoxSelection( nBegin:int , nEnd:int ):void
	{
		if ( m_pTextField ) m_pTextField.setSelection( nBegin , nEnd );
	}
	public function GetInputBoxSelectionBegin():int
	{
		if ( !m_pTextField ) return 0;
		return m_pTextField.selectionBeginIndex;
	}
	public function GetInputBoxSelectionEnd():int
	{
		if ( !m_pTextField ) return 0;
		return m_pTextField.selectionEndIndex;
	}
	public function SetInputBoxFocus( bSet:Boolean ):void
	{
		if ( bSet )
			m_pStage.focus = m_pTextField;
		else if ( m_pStage.focus == m_pTextField )
			m_pStage.focus = null;
	}
}
class _dBitmapData
{
	public var m_pBitmapData:BitmapData;
	
	public function Resize( w:int , h:int , color:uint = 0 ):void
	{
		if ( w == 0 || h == 0 || w > 4000 || h > 4000 )
		{
			if ( m_pBitmapData )
			{
				//m_pBitmapData.dispose();
				m_pBitmapData = null;
			}
		}
		else
		{
			if ( !m_pBitmapData || m_pBitmapData.width != w || m_pBitmapData.height != h )
			{
				//if ( m_pBitmapData ) m_pBitmapData.dispose();
				m_pBitmapData = new BitmapData( w , h , true , color );
			}
			else if ( m_pBitmapData ) m_pBitmapData.fillRect( new Rectangle( 0 , 0 , w , h ) , color );
		}
	}
	public function GetWidth():int
	{
		if ( m_pBitmapData ) return m_pBitmapData.width;
		return 0;
	}
	public function GetHeight():int
	{
		if ( m_pBitmapData ) return m_pBitmapData.height;
		return 0;
	}
}
class _dByteArray
{
	public var m_pByteArray:ByteArray;
}
class _dSocket
{
	public var m_pSocket:Socket;
	protected var m_pOnConnectEvent:Function;
	protected var m_pReceive:Function;
	protected var m_bConnected:Boolean;
	
	public function _dSocket():void
	{
		m_pSocket = new Socket();
		m_pSocket.addEventListener( Event.CONNECT , OnSocketConnect );
		m_pSocket.addEventListener( ProgressEvent.SOCKET_DATA , OnSocketRecv );
		m_pSocket.addEventListener( IOErrorEvent.IO_ERROR , OnSocketError );
	}
	private function OnSocketConnect( event:Event ):void
	{
		m_bConnected = true;
		if ( m_pOnConnectEvent != null ) m_pOnConnectEvent( null , 0 , dSocket.CONNECT_OK );
	}
	private function OnSocketError( event:IOErrorEvent ):void
	{
		if ( m_bConnected )
		{
			m_bConnected = false;
			if ( m_pOnConnectEvent != null ) m_pOnConnectEvent( null , 0 , dSocket.CONNECT_LOST );
		}
		else
		{
			if ( m_pOnConnectEvent != null ) m_pOnConnectEvent( null , 0 , dSocket.CONNECT_FAILED );
		}
	}
	private function OnSocketRecv( event:ProgressEvent ):void
	{
		var byteArray:ByteArray = new ByteArray();
		m_pSocket.readBytes( byteArray );
		if ( m_pReceive != null ) m_pReceive( null , 0 , _dInterface.iBridge_TransByteArray( byteArray ) );
	}
	public function SetEventFunction( onConnect:Function , onReceive:Function ):void
	{
		m_pOnConnectEvent = onConnect;
		m_pReceive = onReceive;
	}
}
class _dTimer
{
	protected var m_pFun:Function;
	protected var m_pTimer:Timer;
	protected var m_nType:int;
	protected var m_pRoot:Sprite;
	protected var m_pRepeatCount:int;
	public var m_pThread:_dThread;
	public function Create( pRoot:Sprite , delay:int , repeatCount:int , onTimer:Function ):void
	{
		m_pRoot = pRoot;
		m_pFun = onTimer;
		if ( repeatCount < 0 ) repeatCount = 0;
		m_pRepeatCount = repeatCount;
		if ( delay == 0 )
		{
			m_nType = 1;
			m_pRoot.addEventListener( Event.ENTER_FRAME , OnTimerEvent );
		}
		else
		{
			m_nType = 0;
			if ( !m_pTimer )
				m_pTimer = new Timer( delay , repeatCount );
			else
			{
				m_pTimer.delay = delay;
				m_pTimer.repeatCount = repeatCount;
			}
			m_pTimer.addEventListener( TimerEvent.TIMER , OnTimerEvent );
			m_pTimer.addEventListener( TimerEvent.TIMER_COMPLETE , OnTimerComplelte );
			m_pTimer.start();
		}
	}
	public function OnTimerEvent( e:Event ):void
	{
		if ( m_pFun != null ) m_pFun( null , m_pRepeatCount );
		if ( m_nType == 1 && m_pRepeatCount > 0 )
		{
			m_pRepeatCount --;
			if ( m_pRepeatCount == 0 )
				Stop();
		}
	}
	public function OnTimerComplelte( e:Event ):void
	{
		m_pTimer.removeEventListener( TimerEvent.TIMER , OnTimerEvent );
		m_pTimer.removeEventListener( TimerEvent.TIMER_COMPLETE , OnTimerComplelte );
		m_pFun = null;
	}
	public function Stop():void
	{
		if ( m_nType == 0 )
		{
			m_pTimer.stop();
			m_pTimer.removeEventListener( TimerEvent.TIMER , OnTimerEvent );
			m_pTimer.removeEventListener( TimerEvent.TIMER_COMPLETE , OnTimerComplelte );
		}
		else if ( m_nType == 1 )
		{
			m_pRoot.removeEventListener( Event.ENTER_FRAME , OnTimerEvent );
		}
		m_pFun = null;
	}
	public function IntervalFor( nStart:int , nLess:int , nStep:int , onLoop:Function , onComplete:Function ):void
	{
		_dTimerIntervalMng.Ptr().IntervalFor( this , nStart , nLess , nStep , onLoop , onComplete );
	}
	public function IntervalBreak():void
	{
		_dTimerIntervalMng.Ptr().IntervalBreak( this );
	}
	public function IntervalPause( bPause:Boolean ):void
	{
		_dTimerIntervalMng.Ptr().IntervalPause( this , bPause );
	}
}
class _dTimerIntervalObj
{
	public var pTimer:_dTimer;
	public var nCount:int;
	public var nLess:int;
	public var nStep:int;
	public var onLoop:Function;
	public var onComplete:Function;
	public var bPause:Boolean;
}
class _dTimerIntervalMng
{
	private static var m_ptr:_dTimerIntervalMng;
	private static var m_pTimer:dTimer = new dTimer();
	private var m_vecIntervalObj:Vector.<_dTimerIntervalObj> = new Vector.<_dTimerIntervalObj>();
	static public function Ptr():_dTimerIntervalMng
	{
		if ( !m_ptr )
		{
			m_ptr = new _dTimerIntervalMng();
			m_pTimer.Create( 0 , 0 , m_ptr.OnFrameMove );
		}
		return m_ptr;
	}
	protected var m_pCurActiveInterval:_dTimerIntervalObj;
	public function OnFrameMove( pTimer:dTimer , nCount:int ):void
	{
		if ( m_vecIntervalObj.length )
		{
			m_pCurActiveInterval = null;
			var nStartTime:int = dTimer.GetTickCount();
			for ( var i:int = 0 ; i < m_vecIntervalObj.length ; i ++ )
			{
				if ( m_vecIntervalObj[i].bPause ) continue;
				m_pCurActiveInterval = m_vecIntervalObj[i];
				break;
			}
			if ( m_pCurActiveInterval == null ) return;
			while ( m_pCurActiveInterval.nCount < m_pCurActiveInterval.nLess )
			{
				m_pCurActiveInterval.onLoop( null , m_pCurActiveInterval.nCount );
				m_pCurActiveInterval.nCount += m_pCurActiveInterval.nStep;
				if ( m_pCurActiveInterval == null || m_pCurActiveInterval.bPause ) return;
				if ( dTimer.GetTickCount() > nStartTime + 100 ) return;
			}
			if ( m_pCurActiveInterval.onComplete != null ) m_pCurActiveInterval.onComplete( null , m_pCurActiveInterval.nCount );
			m_pCurActiveInterval = null;
			m_vecIntervalObj.splice( 0 , 1 );
		}
	}
	public function IntervalFor( p:_dTimer , nStart:int , nLess:int , nStep:int , onLoop:Function , onComplete:Function ):void
	{
		var obj:_dTimerIntervalObj = new _dTimerIntervalObj();
		obj.pTimer = p;
		obj.nCount = nStart;
		obj.nLess = nLess;
		obj.nStep = nStep;
		obj.onLoop = onLoop;
		obj.onComplete = onComplete;
		m_vecIntervalObj.push( obj );
	}
	public function IntervalBreak( p:_dTimer ):void
	{
		for ( var i:int = 0 , n:int = m_vecIntervalObj.length ; i < n ; i ++ )
		{
			if ( m_vecIntervalObj[i].pTimer == p )
			{
				if ( m_pCurActiveInterval == m_vecIntervalObj[i] ) m_pCurActiveInterval = null;
				m_vecIntervalObj.splice( i , 1 );
				break;
			}
		}
	}
	public function IntervalPause( p:_dTimer , bPause:Boolean ):void
	{
		if ( m_pCurActiveInterval && m_pCurActiveInterval.pTimer == p )
			m_pCurActiveInterval.bPause = bPause;
		else
		{
			for ( var i:int = 0 , n:int = m_vecIntervalObj.length ; i < n ; i ++ )
			{
				if ( m_vecIntervalObj[i].pTimer == p )
				{
					m_vecIntervalObj[i].bPause = bPause;
					break;
				}
			}
		}
	}
}
dynamic class _dColorMatrix extends Array
{
	// constant for contrast calculations:
	private static const DELTA_INDEX:Array = [
		0,    0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1,  0.11,
		0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24,
		0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42,
		0.44, 0.46, 0.48, 0.5,  0.53, 0.56, 0.59, 0.62, 0.65, 0.68, 
		0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98,
		1.0,  1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54,
		1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0,  2.12, 2.25, 
		2.37, 2.50, 2.62, 2.75, 2.87, 3.0,  3.2,  3.4,  3.6,  3.8,
		4.0,  4.3,  4.7,  4.9,  5.0,  5.5,  6.0,  6.5,  6.8,  7.0,
		7.3,  7.5,  7.8,  8.0,  8.4,  8.7,  9.0,  9.4,  9.6,  9.8, 
		10.0
	];

	// identity matrix constant:
	private static const IDENTITY_MATRIX:Array = [
		1,0,0,0,0,
		0,1,0,0,0,
		0,0,1,0,0,
		0,0,0,1,0,
		0,0,0,0,1
	];
	private static const LENGTH:Number = IDENTITY_MATRIX.length;


	// initialization:
	public function _dColorMatrix(p_matrix:Array=null) {
		p_matrix = fixMatrix(p_matrix);
		copyMatrix(((p_matrix.length == LENGTH) ? p_matrix : IDENTITY_MATRIX));
	}
	
	
	// public methods:
	public function reset():void {
		for (var i:uint=0; i<LENGTH; i++) {
			this[i] = IDENTITY_MATRIX[i];
		}
	}

	public function adjustColor(p_brightness:Number,p_contrast:Number,p_saturation:Number,p_hue:Number):void {
		adjustHue(p_hue);
		adjustContrast(p_contrast);
		adjustBrightness(p_brightness);
		adjustSaturation(p_saturation);
	}

	public function adjustBrightness(p_val:Number):void {
		p_val = cleanValue(p_val,100);
		if (p_val == 0 || isNaN(p_val)) { return; }
		multiplyMatrix([
			1,0,0,0,p_val,
			0,1,0,0,p_val,
			0,0,1,0,p_val,
			0,0,0,1,0,
			0,0,0,0,1
		]);
	}

	public function adjustContrast(p_val:Number):void {
		p_val = cleanValue(p_val,100);
		if (p_val == 0 || isNaN(p_val)) { return; }
		var x:Number;
		if (p_val<0) {
			x = 127+p_val/100*127
		} else {
			x = p_val%1;
			if (x == 0) {
				x = DELTA_INDEX[p_val];
			} else {
				//x = DELTA_INDEX[(p_val<<0)]; // this is how the IDE does it.
				x = DELTA_INDEX[(p_val<<0)]*(1-x)+DELTA_INDEX[(p_val<<0)+1]*x; // use linear interpolation for more granularity.
			}
			x = x*127+127;
		}
		multiplyMatrix([
			x/127,0,0,0,0.5*(127-x),
			0,x/127,0,0,0.5*(127-x),
			0,0,x/127,0,0.5*(127-x),
			0,0,0,1,0,
			0,0,0,0,1
		]);
	}

	public function adjustSaturation(p_val:Number):void {
		p_val = cleanValue(p_val,100);
		if (p_val == 0 || isNaN(p_val)) { return; }
		var x:Number = 1+((p_val > 0) ? 3*p_val/100 : p_val/100);
		var lumR:Number = 0.3086;
		var lumG:Number = 0.6094;
		var lumB:Number = 0.0820;
		multiplyMatrix([
			lumR*(1-x)+x,lumG*(1-x),lumB*(1-x),0,0,
			lumR*(1-x),lumG*(1-x)+x,lumB*(1-x),0,0,
			lumR*(1-x),lumG*(1-x),lumB*(1-x)+x,0,0,
			0,0,0,1,0,
			0,0,0,0,1
		]);
	}

	public function adjustHue(p_val:Number):void {
		p_val = cleanValue(p_val,180)/180*Math.PI;
		if (p_val == 0 || isNaN(p_val)) { return; }
		var cosVal:Number = Math.cos(p_val);
		var sinVal:Number = Math.sin(p_val);
		var lumR:Number = 0.213;
		var lumG:Number = 0.715;
		var lumB:Number = 0.072;
		multiplyMatrix([
			lumR+cosVal*(1-lumR)+sinVal*(-lumR),lumG+cosVal*(-lumG)+sinVal*(-lumG),lumB+cosVal*(-lumB)+sinVal*(1-lumB),0,0,
			lumR+cosVal*(-lumR)+sinVal*(0.143),lumG+cosVal*(1-lumG)+sinVal*(0.140),lumB+cosVal*(-lumB)+sinVal*(-0.283),0,0,
			lumR+cosVal*(-lumR)+sinVal*(-(1-lumR)),lumG+cosVal*(-lumG)+sinVal*(lumG),lumB+cosVal*(1-lumB)+sinVal*(lumB),0,0,
			0,0,0,1,0,
			0,0,0,0,1
		]);
	}

	public function concat(p_matrix:Array):void {
		p_matrix = fixMatrix(p_matrix);
		if (p_matrix.length != LENGTH) { return; }
		multiplyMatrix(p_matrix);
	}
	
	public function clone():_dColorMatrix {
		return new _dColorMatrix(this);
	}

	public function toString():String {
		return "_dColorMatrix [ "+this.join(" , ")+" ]";
	}
	
	// return a length 20 array (5x4):
	public function toArray():Array {
		return slice(0,20);
	}

	// private methods:
	// copy the specified matrix's values to this matrix:
	protected function copyMatrix(p_matrix:Array):void {
		var l:Number = LENGTH;
		for (var i:uint=0;i<l;i++) {
			this[i] = p_matrix[i];
		}
	}

	// multiplies one matrix against another:
	protected function multiplyMatrix(p_matrix:Array):void {
		var col:Array = [];
		
		for (var i:uint=0;i<5;i++) {
			for (var j:uint=0;j<5;j++) {
				col[j] = this[j+i*5];
			}
			for (j=0;j<5;j++) {
				var val:Number=0;
				for (var k:Number=0;k<5;k++) {
					val += p_matrix[j+k*5]*col[k];
				}
				this[j+i*5] = val;
			}
		}
	}
	
	// make sure values are within the specified range, hue has a limit of 180, others are 100:
	protected function cleanValue(p_val:Number,p_limit:Number):Number {
		return Math.min(p_limit,Math.max(-p_limit,p_val));
	}

	// makes sure matrixes are 5x5 (25 long):
	protected function fixMatrix(p_matrix:Array=null):Array {
		if (p_matrix == null) { return IDENTITY_MATRIX; }
		if (p_matrix is _dColorMatrix) { p_matrix = p_matrix.slice(0); }
		if (p_matrix.length < LENGTH) {
			p_matrix = p_matrix.slice(0,p_matrix.length).concat(IDENTITY_MATRIX.slice(p_matrix.length,LENGTH));
		} else if (p_matrix.length > LENGTH) {
			p_matrix = p_matrix.slice(0,LENGTH);
		}
		return p_matrix;
	}
}
class SelectionColor
{
	private static const byteToPerc:Number = 1 / 0xff;
	public static function setFieldSelectionColor( field:TextField ):void
	{
		if ( isHaveFilter( field ) ) return;
		var colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter();
		var textColor:uint = field.textColor;
		field.textColor = 0xFF0000;
		var o:Array = splitRGB( textColor );// selectionColor
		var r:Array = splitRGB( textColor );// textColor
		var g:Array = splitRGB( 0x000000 );// selectedColor
		var ro:int = o[0];
		var go:int = o[1];
		var bo:int = o[2];
		var rr:Number = ((r[0] - 0xff) - o[0]) * byteToPerc + 1;
		var rg:Number = ((r[1] - 0xff) - o[1]) * byteToPerc + 1;
		var rb:Number = ((r[2] - 0xff) - o[2]) * byteToPerc + 1;
		var gr:Number = ((g[0] - 0xff) - o[0]) * byteToPerc + 1 - rr;
		var gg:Number = ((g[1] - 0xff) - o[1]) * byteToPerc + 1 - rg;
		var gb:Number = ((g[2] - 0xff) - o[2]) * byteToPerc + 1 - rb;
		colorMatrixFilter.matrix = [ rr , gr , 0 , 0 , ro , rg , gg , 0 , 0 , go , rb , gb , 0 , 0 , bo , 0 ,  0 , 0 , 2 , 0 ];
		var arr:Array = field.filters;
		arr.splice( 0 , 0 , colorMatrixFilter );
		field.filters = arr;
		//field.transform.colorTransform = new ColorTransform( 2 , 2 , 2 );
	}
	private static function isHaveFilter( field:TextField ):Boolean
	{
		for each( var p:* in field.filters )
		{
			if ( p is ColorMatrixFilter )
				return true;
		}
		return false;
	}
	private static function splitRGB( color:uint ):Array
	{
		return [ color >> 16 & 0xff , color >> 8 & 0xff , color & 0xff ];
	}
	/*public static function setFieldSelectionColor( field:TextField , color:uint ):void
	{
		field.backgroundColor = invert( field.backgroundColor );
		field.borderColor = invert( field.borderColor );
		//field.textColor = invert( field.textColor );
		
		var colorTrans:ColorTransform = new ColorTransform();
		colorTrans.color = color;
		colorTrans.redMultiplier = -1;
		colorTrans.greenMultiplier = -1;
		colorTrans.blueMultiplier = -1;
		field.transform.colorTransform = colorTrans;
	}
	protected static function invert( color:uint ):uint
	{
		var colorTrans:ColorTransform = new ColorTransform();
		colorTrans.color = color;
		return invertColorTransform( colorTrans ).color;
	}
	protected static function invertColorTransform( colorTrans:ColorTransform ):ColorTransform
	{
		colorTrans.redMultiplier = -colorTrans.redMultiplier;
		colorTrans.greenMultiplier = -colorTrans.greenMultiplier;
		colorTrans.blueMultiplier = -colorTrans.blueMultiplier;
		colorTrans.redOffset = 255 - colorTrans.redOffset;
		colorTrans.greenOffset = 255 - colorTrans.greenOffset;
		colorTrans.blueOffset = 255 - colorTrans.blueOffset;
		return colorTrans;
	}*/
}
class _dFileLoader
{
	static protected var m_arrResource:Array = new Array();
	public function _dFileLoader( strFileName:String , bBitmapData:Boolean , OnComplateFunction:Function , OnProgressFunction:Function = null , OnFaildFunction:Function = null )
	{
		var pRes:Resource = m_arrResource[ strFileName ];
		if ( pRes )
		{
			if ( pRes.vecComplateFunction == null )
			{
				OnComplateFunction( ( m_arrResource[ strFileName ] as Resource ).pData );
			}
			else
			{
				pRes.vecComplateFunction.push( OnComplateFunction );
			}
		}
		else
		{
			pRes = new Resource();
			pRes.vecComplateFunction = new Vector.<Function>;
			pRes.vecComplateFunction.push( OnComplateFunction );
			pRes.vecProgressFunction = new Vector.<Function>;
			pRes.vecFaildFunction = new Vector.<Function>;
			if( OnProgressFunction != null )
				pRes.vecProgressFunction.push( OnProgressFunction );
			if ( OnFaildFunction != null )
				pRes.vecFaildFunction.push( OnFaildFunction );
			m_arrResource[ strFileName ] = pRes;
			if ( bBitmapData )
			{
				var loader:_dURLLoader = new _dURLLoader();
				loader.load( strFileName );
				loader.addEventListener( Event.COMPLETE, function( event:Event ):void
				{
					var bmpLoader:Loader = new Loader();
					bmpLoader.loadBytes( event.target.data );
					bmpLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, function( event:Event ):void
					{
						pRes.pData = event.target.content[ "bitmapData" ];
						for ( var i:int = 0 ; i < pRes.vecComplateFunction.length ; i ++ )
						{
							pRes.vecComplateFunction[i]( pRes.pData );
						}
						pRes.vecComplateFunction = null;
						pRes.vecProgressFunction = null;
						pRes.vecFaildFunction = null;
					} );
				});
				loader.addEventListener( IOErrorEvent.IO_ERROR , function( event:IOErrorEvent ):void
				{
					if ( event.currentTarget.m_nStatus != 404 &&
						 event.currentTarget.m_nStatus != 405 )
					{
						//loader.load( strFileName );
						//trace( "正在重新下载:" + strFileName );
					}
					else
					{
						for ( var i:int = 0 ; i < pRes.vecFaildFunction.length ; i ++ )
						{
							pRes.vecFaildFunction[i]( event.currentTarget.m_nStatus );
						}
						pRes.vecComplateFunction = null;
						pRes.vecProgressFunction = null;
						pRes.vecFaildFunction = null;
					}
				} );
				loader.addEventListener( ProgressEvent.PROGRESS , function( event:ProgressEvent ):void
				{
					for ( var i:int = 0 ; i < pRes.vecProgressFunction.length ; i ++ )
						pRes.vecProgressFunction[i]( event.target.bytesLoaded * 100 / event.target.bytesTotal );
				} );
			}
			else
			{
				var loader2:_dURLLoader = new _dURLLoader();
				loader2.load( strFileName );
				var funComplete:Function = function( event:Event ):void
				{
					pRes.pData = event.target.data;
					for ( var i:int = 0 ; i < pRes.vecComplateFunction.length ; i ++ )
					{
						pRes.vecComplateFunction[i]( pRes.pData );
					}
					pRes.vecComplateFunction = null;
					pRes.vecProgressFunction = null;
					pRes.vecFaildFunction = null;
					loader2.removeEventListener( Event.COMPLETE , funComplete );
					loader2.removeEventListener( IOErrorEvent.IO_ERROR , funError );
					loader2.removeEventListener( ProgressEvent.PROGRESS , funProgress );
					loader2.Release();
				}
				var funError:Function = function( event:IOErrorEvent ):void
				{
					if ( loader2.m_nStatus != 404 && loader2.m_nStatus != 403 && loader2.m_nStatus != 500 )
					{
						//loader2.load( strFileName );
						//trace( "正在重新下载:" + strFileName );
					}
					else
					{
						loader2.removeEventListener( Event.COMPLETE , funComplete );
						loader2.removeEventListener( IOErrorEvent.IO_ERROR , funError );
						loader2.removeEventListener( ProgressEvent.PROGRESS , funProgress );
						loader2.Release();
					}
				}
				var funProgress:Function = function( event:ProgressEvent ):void
				{
					for ( var i:int = 0 ; i < pRes.vecProgressFunction.length ; i ++ )
						pRes.vecProgressFunction[i]( event.target.bytesLoaded * 100 / event.target.bytesTotal );
				}
				loader2.addEventListener( Event.COMPLETE , funComplete );
				loader2.addEventListener( IOErrorEvent.IO_ERROR , funError );
				loader2.addEventListener( ProgressEvent.PROGRESS , funProgress );
			}
		}
	}
}
class Resource
{
	public var pData:Object;
	public var vecComplateFunction:Vector.<Function>;
	public var vecProgressFunction:Vector.<Function>;
	public var vecFaildFunction:Vector.<Function>;
}
class _dURLLoader extends EventDispatcher
{
	protected var m_pData:ByteArray = new ByteArray();
	protected var m_nBytesLoaded:int;
	protected var m_nBytesTotal:int;
	protected var m_strURL:String;
	public var m_nStatus:int;
	protected var m_pLoader:URLLoader;
	public function _dURLLoader() 
	{
		
	}
	public function load( strURL:String ):void
	{
		m_nBytesLoaded = 0;
		m_nBytesTotal = 0;
		m_strURL = strURL;
		m_pData.length = 0;
		m_pLoader = new URLLoader();
		m_pLoader.dataFormat = URLLoaderDataFormat.BINARY;
		m_pLoader.load( new URLRequest(strURL) );
		m_pLoader.addEventListener( Event.COMPLETE , _OnLoadComplete );
		m_pLoader.addEventListener( IOErrorEvent.IO_ERROR , _OnLoadError );
		m_pLoader.addEventListener( ProgressEvent.PROGRESS , _OnLoadProgress );
		m_pLoader.addEventListener( HTTPStatusEvent.HTTP_STATUS , _OnStatus );
	}
	public function Release():void
	{
		m_pLoader.removeEventListener( Event.COMPLETE , _OnLoadComplete );
		m_pLoader.removeEventListener( IOErrorEvent.IO_ERROR , _OnLoadError );
		m_pLoader.removeEventListener( ProgressEvent.PROGRESS , _OnLoadProgress );
		m_pLoader.removeEventListener( HTTPStatusEvent.HTTP_STATUS , _OnStatus );
	}
	protected function _OnStatus( event:HTTPStatusEvent ):void
	{
		m_nStatus = event.status;
	}
	protected function _OnLoadError( event:IOErrorEvent ):void
	{
		m_nBytesLoaded = event.target.bytesLoaded;
		m_nBytesTotal = event.target.bytesTotal;
		dispatchEvent( event );
	}
	protected function _OnLoadProgress( event:ProgressEvent ):void
	{
		m_nBytesLoaded = event.target.bytesLoaded;
		m_nBytesTotal = event.target.bytesTotal;
		dispatchEvent( event );
	}
	protected function IntToString2( i:int ):String
	{
		if ( i < 10 ) return "0" + String( i );
		return String( i%100 );
	}
	protected function GenVersion():String
	{
		var date:Date = new Date();
		return IntToString2( date.getFullYear() ) + IntToString2( date.getMonth() + 1 ) + IntToString2( date.getDate() ) + IntToString2( date.getHours() ) + IntToString2( date.getMinutes() ) + IntToString2( date.getSeconds() );
	}
	protected function _OnLoadComplete( event:Event ):void
	{
		m_nBytesLoaded = event.target.bytesLoaded;
		m_nBytesTotal = event.target.bytesTotal;
		if ( event.target.bytesLoaded != event.target.bytesTotal )
		{
			var pURL:URLRequest = new URLRequest( m_strURL + "?v2=" + GenVersion() );
			//var headerItem:URLRequestHeader = new URLRequestHeader( "Range" , "bytes=" + event.target.bytesLoaded + "-" + event.target.bytesTotal );
			//pURL.requestHeaders.push( headerItem );
			event.target.load( pURL );
			/*var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load( pURL );
			loader.addEventListener( Event.COMPLETE , _OnLoadComplete );
			loader.addEventListener( IOErrorEvent.IO_ERROR , _OnLoadError );
			loader.addEventListener( ProgressEvent.PROGRESS , _OnLoadProgress );*/
		}
		else
		{
			m_pData = event.target.data;
			var p:Event = new Event( Event.COMPLETE );
			dispatchEvent( p );
		}
	}
	public function get data():ByteArray
	{
		return m_pData;
	}
	public function get bytesLoaded():int
	{
		return m_nBytesLoaded;
	}
	public function get bytesTotal():int
	{
		return m_nBytesTotal;
	}
}
class _dThread
{
	protected var m_onReturn:Function;
	public function _dThread():void
	{
		
	}
	public function Init( pTimer:_dTimer , strClassName:String , strFunctionName:String , pData:dByteArray , onReturn:Function ):void
	{
		m_onReturn = onReturn;
		var o : Object = getDefinitionByName( strClassName );
		if ( o )
		{
			var p:dTimer = new dTimer();
			p.m_pBaseObject = pTimer;
			o[strFunctionName]( p , pData );
		}
	}
	public function ThreadReturn( pRetData:dByteArray ):void
	{
		m_onReturn( pRetData );
	}
}