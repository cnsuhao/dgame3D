//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	import dcom.*;
	/**
	 * ...
	 * @author dym
	 */
	public class dUISuperText extends dUIImage
	{
		protected var m_pTextImage:dUIImage;
		protected var m_vecImageList:Vector.<SpriteData>;
		protected var m_vecUnderLineObj:Vector.<dUISuperTextUnderLineObj>;
		protected var m_nDownImageNum:int;
		protected var m_bNeedGetCharBound:Boolean;
		protected var m_vecBoundRect:Vector.<dRect>;
		protected var m_nBoundRectNum:int;
		protected var m_pConv:ConvertFormatBuffer;
		protected var m_bCanEdit:Boolean;
		public function dUISuperText( pFather:dUIImage ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_SUPPERTEXT;
			m_pTextImage = new dUIImage( this );
			m_pTextImage.SetUIEventFunction( OnTextEvent );
			// 设置默认
			SetSize( 100 , 20 );
		}
		private function OnUnderLineEvent( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_LBUTTON_DOWN )
				FireEvent( dUISystem.GUIEVENT_TYPE_SUPPER_TEXT_CLICK_DOWN_LINE , event.nParam1 , event.nParam2 , event.pObj.GetTooltip() as String );
			else if ( event.type == dUISystem.GUIEVENT_TYPE_LBUTTON_UP )
				FireEvent( dUISystem.GUIEVENT_TYPE_SUPPER_TEXT_CLICK_DOWN_LINE_UP , event.nParam1 , event.nParam2 , event.pObj.GetTooltip() as String );
			else if ( event.type == dUISystem.GUIEVENT_TYPE_MOUSE_IN || event.type == dUISystem.GUIEVENT_TYPE_MOUSE_OUT )
			{
				if ( isHandleMouse() )
					FireEvent( event.type , event.nParam1 , event.nParam2 , event.sParam , event.oParam );
			}
			else FireEvent( event.type , event.nParam1 , event.nParam2 , event.sParam , event.oParam );
		}
		private function OnTextEvent( event:dUIEvent ):void
		{
			/*if ( event.type == dUISystem.GUIEVENT_TYPE_SUPPERTEXT_CHANGED )
			{
				m_pConv = ConvertToFormat( GetAlignType() , event.sParam );
				super._SetText( event.sParam );
			}*/
			FireEvent( event.type , event.nParam1 , event.nParam2 , event.sParam , event.oParam );
		}
		override public function SetFocus( bSet:Boolean ):void
		{
			m_pTextImage.dSpriteSetInputBoxFocus( bSet );
		}
		override public function SetEventReturn( n:int ):void
		{
			m_pTextImage.SetEventReturn( n );
		}
		override public function _SetText( str:String ):void
		{
			if ( m_vecImageList )
			{
				for ( var i:int = 0 ; i < m_vecImageList.length ; i ++ )
					m_vecImageList[i].pSprite.Release();
				m_vecImageList.length = 0;
			}
			if ( isStyleData( "NoSign" ) )
			{
				m_pConv = new ConvertFormatBuffer();
				m_pConv.str = str;
				var pConfig:dUIConfig = GetImageRoot().GetConfig();
				var format:dTextFormat = new dTextFormat();
				format.dwFontColor = pConfig.nDefaultFontColor;
				format.dwEdgeColor = pConfig.nDefaultFontEdgeColor;
				format.nFontSize = pConfig.nDefaultFontSize;
				format.nEdgeSize = 1;
				format.strFontFace = pConfig.strDefaultFontFaceName;
				format.nBeginIndex = 0;
				format.nEndIndex = str.length;
				m_pConv.vecFormat.push( format );
			}
			else
				m_pConv = ConvertToFormat( GetAlignType() , str );
			super._SetText( str );
			if ( m_bCanEdit ) m_pTextImage.SetSize( GetWidth() , GetHeight() );
			m_pTextImage.LoadFromText( m_bCanEdit , m_pConv.str , isStyleData( "AutoEnterLine" ) ? GetWidth() : -1 , function( vecBoundRect:Vector.<dRect> , nBoundArgNum:int ):void
			{
				m_vecBoundRect = vecBoundRect;
				m_nBoundRectNum = nBoundArgNum;
				if ( m_vecImageList )
				{
					for ( var i:int = 0 ; i < m_vecImageList.length ; i ++ )
					{
						if ( m_vecImageList[i].strFileName != null )
							m_vecImageList[i].pSprite.LoadFromImageSet( m_vecImageList[i].strFileName );
					}
				}
				if ( isStyleData( "AutoSetSize" ) )
				{
					if ( isStyleData( "AutoEnterLine" ) )
						SetSizeBase( GetWidth() , GetTextHeight() );
					else
						SetSizeBase( GetTextWidth() , GetTextHeight() );
				}
				ComputeTextPos();
			} , m_pConv.vecFormat , m_pConv.vecFormat.length , m_bNeedGetCharBound , GetFlag() );
		}
		private function UpdateText():void
		{
			if ( !m_pConv ) return;
			if ( m_bCanEdit ) m_pTextImage.SetSize( GetWidth() , GetHeight() );
			m_pTextImage.LoadFromText( m_bCanEdit , m_pConv.str , isStyleData( "AutoEnterLine" ) ? GetWidth() : -1 , function( vecBoundRect:Vector.<dRect> , nBoundArgNum:int ):void
			{
				m_vecBoundRect = vecBoundRect;
				m_nBoundRectNum = nBoundArgNum;
				if ( isStyleData( "AutoSetSize" ) )
				{
					if ( isStyleData( "AutoEnterLine" ) )
						SetSizeBase( GetWidth() , GetTextHeight() );
					else
						SetSizeBase( GetTextWidth() , GetTextHeight() );
				}
				ComputeTextPos();
			} , m_pConv.vecFormat , m_pConv.vecFormat.length , m_bNeedGetCharBound , GetFlag() );
		}
		private function GetFlag():int
		{
			if ( isStyleData( "PassWord" ) )
				return 1;
			return 0;
		}
		override public function SetAlignType( nType:int , nIndex:int = 0 ):void
		{
			super.SetAlignType( nType , nIndex );
			m_pTextImage.SetAlignType( nType , nIndex );
			UpdateText();
		}
		public function SetCanEdit( bCan:Boolean ):void
		{
			m_bCanEdit = bCan;
			m_pTextImage.SetHandleKey( bCan );
			_SetText( GetText() );
			ComputeTextPos();
		}
		public function GetTextWidth():int
		{
			var ret:int = m_pTextImage.GetWidth();
			if ( ret < 4 ) ret = 4;
			return ret;
		}
		public function GetTextHeight():int
		{
			var ret:int = m_pTextImage.GetHeight();
			if ( ret < 4 ) ret = 4;
			return ret;
		}
		public function GetTextPosX():int
		{
			return m_pTextImage.GetPosX();
		}
		public function GetTextPosY():int
		{
			return m_pTextImage.GetPosY();
		}
		public function GetSelectionBegin():int
		{
			return m_pTextImage.dSpriteGetInputBoxSelectionBegin();
		}
		public function GetSelectionEnd():int
		{
			return m_pTextImage.dSpriteGetInputBoxSelectionEnd();
		}
		public function SetSelection( begin:int , end:int ):void
		{
			m_pTextImage.dSpriteSetInputBoxSelection( begin , end );
		}
		private function UpdateSpritePos():void
		{
			if ( !m_vecImageList ) return;
			for ( var i:int = 0 ; i < m_vecImageList.length ; i ++ )
			{
				var idx:int = m_vecImageList[i].nIndexTextPos;
				if ( idx >= 0 && idx < m_vecBoundRect.length && m_vecBoundRect[ idx ] != null )
				{
					m_vecImageList[i].pSprite.SetPos( m_vecBoundRect[ idx ].left + GetTextPosX() ,
						m_vecBoundRect[ idx ].bottom - m_vecImageList[i].pSprite.GetHeight() + GetTextPosY() );
				}
			}
		}
		private function UpdateSpriteSize():void
		{
			if ( m_pConv )
			{
				for ( var i:int = 0 ; i < m_vecImageList.length ; i ++ )
				{
					var idx:int = m_vecImageList[i].nIndexFormat;
					if ( idx >= 0 && idx < m_pConv.vecFormat.length )
					{
						( m_pConv.vecFormat[idx] as dTextFormat ).nImageWidth = m_vecImageList[i].pSprite.GetWidth();
						( m_pConv.vecFormat[idx] as dTextFormat ).nImageHeight = m_vecImageList[i].pSprite.GetHeight();
					}
				}
				UpdateText();
			}
		}
		public function ComputeUnderLine():void
		{
			var nObjNum:int = 0;
			for ( var i:int = 0 ; m_pConv && i < m_pConv.vecFormat.length ; i ++ )
			{
				if ( (m_pConv.vecFormat[i] as dTextFormat).bUnderLine )
				{
					var rcLast:dRect;
					for ( var j:int = ( m_pConv.vecFormat[i] as dTextFormat ).nBeginIndex ; j < ( m_pConv.vecFormat[i] as dTextFormat ).nEndIndex ; j ++ )
					{
						if ( m_vecBoundRect[j] != null )
						{
							var rc:dRect = m_vecBoundRect[j] as dRect;
							if ( rcLast && rc.left == rcLast.right && rc.top == rcLast.top &&
								 rc.bottom == rcLast.bottom )
							{
							}
							else
							{
								if ( !m_vecUnderLineObj ) m_vecUnderLineObj = new Vector.<dUISuperTextUnderLineObj>();
								if ( m_vecUnderLineObj.length <= nObjNum ) m_vecUnderLineObj.push( new dUISuperTextUnderLineObj( this ) );
								m_vecUnderLineObj[ nObjNum ].SetShow( true );
								m_vecUnderLineObj[ nObjNum ].SetUIEventFunction( OnUnderLineEvent );
								m_vecUnderLineObj[ nObjNum ].SetPos( GetTextPosX() + rc.left , GetTextPosY() + rc.top );
								m_vecUnderLineObj[ nObjNum ].SetMouseStyle( dUISystem.GUI_MOUSESTYLE_HAND );
								m_vecUnderLineObj[ nObjNum ].SetTooltip( (m_pConv.vecFormat[i] as dTextFormat).strLinkData );
								nObjNum++;
							}
							m_vecUnderLineObj[ nObjNum - 1 ].SetSize( rc.right - (m_vecUnderLineObj[ nObjNum - 1 ].GetPosX() - GetTextPosX()) , rc.Height() );
							rcLast = rc;
						}
					}
				}
			}
			for ( i = nObjNum ; m_vecUnderLineObj && i < m_vecUnderLineObj.length ; i ++ )
				m_vecUnderLineObj[i].SetShow( false );
		}
		override public function SetSize( w:int , h:int ):void
		{
			if ( GetWidth() != w || GetHeight() != h )
			{
				super.SetSize( w , h );
				if ( isStyleData( "AutoEnterLine" ) || m_bCanEdit )
					UpdateText();
				else
					ComputeTextPos();
			}
		}
		private function SetSizeBase( w:int , h:int ):void
		{
			super.SetSize( w , h );
		}
		protected function ComputeTextPos():void
		{
			if ( m_bCanEdit )
				m_pTextImage.SetPos( GetEdgeLeft() , GetEdgeTop() );
			else
				m_pTextImage.SetAlignPos( GetAlignType() , GetWidth() , GetHeight() , GetEdgeLeft() , GetEdgeTop() );
			UpdateSpritePos();
			ComputeUnderLine();
		}
		override public function LoadFromImageSet( str:String ):void
		{
			// do nothing
		}
		public function GetTextBoundingRect( index:int ):dUIImageRect
		{
			if ( !m_vecBoundRect )
			{
				m_bNeedGetCharBound = true;
				UpdateText();
			}
			if ( !m_vecBoundRect || index < 0 || index >= m_vecBoundRect.length ) return null;
			var rc:dRect = m_vecBoundRect[index];
			return new dUIImageRect( rc.left , rc.top , rc.right , rc.bottom );
		}
		//-------------------------------------------------------------------------------------------------
		// for convert
		static protected const SIGN_TYPE_COLOR:int = 1;
		static protected const SIGN_TYPE_UNDERLINE:int = 2;
		static protected const SIGN_TYPE_IMAGE:int = 3;
		static protected const SIGN_TYPE_SIZE:int = 4;
		static protected const SIGN_TYPE_BOLD:int = 5;
		static protected const SIGN_TYPE_FONTFACE:int = 6;
		static protected const SIGN_TYPE_ITARIC:int = 7;
		static protected const SIGN_TYPE_EDGECOLOR:int = 8;
		static protected const SIGN_TYPE_EDGESIZE:int = 9;
		static protected const SIGN_TYPE_GRADIENTCOLOR:int = 10;
		static protected const SIGN_TYPE_SHADOW_LENGTH:int = 11;
		static protected function isStringASign( strSource:String , iStart:int , outData:Vector.<uint> ):int
		{
			if ( strSource.length - iStart >= 10 )
			{
				if ( strSource.charAt( iStart ) == "&" )
				{
					var strType:String = strSource.charAt( iStart + 1 );
					if ( strType == "C" || strType == "D" || strType == "I" || strType == "S" || strType == "B" || strType == "F" ||
						 strType == "T" || strType == "E" || strType == "G" || strType == "R" || strType == "W" )
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
						if ( strType == "C" ) return SIGN_TYPE_COLOR;
						if ( strType == "D" ) return SIGN_TYPE_UNDERLINE;
						if ( strType == "I" ) return SIGN_TYPE_IMAGE;
						if ( strType == "S" ) return SIGN_TYPE_SIZE;
						if ( strType == "B" ) return SIGN_TYPE_BOLD;
						if ( strType == "F" ) return SIGN_TYPE_FONTFACE;
						if ( strType == "T" ) return SIGN_TYPE_ITARIC;
						if ( strType == "E" ) return SIGN_TYPE_EDGECOLOR;
						if ( strType == "G" ) return SIGN_TYPE_EDGESIZE;
						if ( strType == "R" ) return SIGN_TYPE_GRADIENTCOLOR;
						if ( strType == "W" ) return SIGN_TYPE_SHADOW_LENGTH;
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
				if ( signType == SIGN_TYPE_UNDERLINE || // underline
					 signType == SIGN_TYPE_IMAGE || // image
					 signType == SIGN_TYPE_FONTFACE )
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
		public function TransColor( nCurColor:int ):int
		{
			var pRect:dUIImageRect = GetImageRoot().GetImageSet().GetImageRect( "color" + nCurColor.toString( 16 ) , true );
			if ( pRect ) nCurColor = pRect.left;
			return nCurColor;
		}
		private function CopyNewFormat( format:dTextFormat ):dTextFormat
		{
			var ret:dTextFormat = new dTextFormat();
			ret.Copy( format );
			return ret;
		}
		public function ConvertToFormat( nAlignType:int , strSource:String ):ConvertFormatBuffer
		{
			//var strBuffer:String = String( nAlignType ) + strSource;
			//if ( s_strConvertToHTMLBuffer[ strBuffer ] ) return s_strConvertToHTMLBuffer[ strBuffer ];
			m_nDownImageNum = 0;
			var pRet:ConvertFormatBuffer = new ConvertFormatBuffer();
			var pConfig:dUIConfig = GetImageRoot().GetConfig();
			var format:dTextFormat = new dTextFormat();
			format.dwFontColor = pConfig.nDefaultFontColor;
			format.dwEdgeColor = pConfig.nDefaultFontEdgeColor;
			format.nFontSize = pConfig.nDefaultFontSize;
			format.nEdgeSize = pConfig.nDefaultFontEdgeSize;
			format.strFontFace = pConfig.strDefaultFontFaceName;
			var bHasText:Boolean;
			var nLastIndex:int = 0;
			var pTextLength:int;
			var outData:Vector.<uint> = new Vector.<uint>;
			var str:String = "";
			var strUnderLineString:String = null;
			var bUnderLine:Boolean = false;
			for ( var i:int = 0 ; i < strSource.length ; i ++ )
			{
				var signType:int = isStringASign( strSource , i , outData );
				if ( signType )
				{
					if ( bHasText )
					{
						format.nBeginIndex = nLastIndex;
						format.nEndIndex = pTextLength;
						format.bUnderLine = bUnderLine;
						format.strLinkData = strUnderLineString;
						pRet.vecFormat.push( format );
						format = CopyNewFormat( format );
						nLastIndex = pTextLength;
					}
					var nSignData:uint = outData[0];
					i += 10 - 1;
					if ( signType == SIGN_TYPE_COLOR )// color
					{
						var nCurColor:int = nSignData&0x00FFFFFF;
						if ( nSignData == 0 ) nCurColor = pConfig.nDefaultFontColor;
						nCurColor = TransColor( nCurColor );
						nCurColor |= 0xFF000000;
						format.dwFontColor = nCurColor;
					}
					else if ( signType == SIGN_TYPE_EDGECOLOR )
					{
						nCurColor = nSignData;
						if ( nCurColor == 0x00FFFFFF ) nCurColor = pConfig.nDefaultFontColor;
						nCurColor = TransColor( nCurColor );
						format.dwEdgeColor = nCurColor;
					}
					else if ( signType == SIGN_TYPE_GRADIENTCOLOR )
					{
						nCurColor = nSignData;
						nCurColor = TransColor( nCurColor );
						format.dwFontGradientColor = nCurColor;
					}
					else if ( signType == SIGN_TYPE_SHADOW_LENGTH )
					{
						format.nShadowLength = nSignData;
					}
					else if ( signType == SIGN_TYPE_EDGESIZE )
					{
						format.nEdgeSize = nSignData;
					}
					else if ( signType == SIGN_TYPE_SIZE )// size
					{
						format.nFontSize = nSignData;
					}
					else if ( signType == SIGN_TYPE_UNDERLINE )// underline
					{
						m_bNeedGetCharBound = true;
						outData[0] = 0;
						if ( !bUnderLine )
							strUnderLineString = GetUnderLineString( strSource , i + 1 , outData );
						else
							strUnderLineString = null;
						bUnderLine = !bUnderLine;
						i += outData[0];
					}
					else if ( signType == SIGN_TYPE_BOLD )
					{
						format.bBold = !format.bBold;
					}
					else if ( signType == SIGN_TYPE_ITARIC )
					{
						format.bItaric = !format.bItaric;
					}
					else if ( signType == SIGN_TYPE_FONTFACE )
					{
						format.strFontFace = GetUnderLineString( strSource , i + 1 , outData );
						i += outData[0];
					}
					else if ( signType == SIGN_TYPE_IMAGE )// image
					{
						m_bNeedGetCharBound = true;
						var strUnderLineString2:String = GetUnderLineString( strSource , i + 1 , outData );
						i += outData[0];
						
						var arr:Array = strUnderLineString2.split( "|" );
						var opt:Array = new Array();
						for ( var j:int = 0 ; j < arr.length ; j ++ )
						{
							var sub:Array = arr[j].split( "=" );
							if ( sub.length == 2 )
								opt[sub[0]] = sub[1];
							else if ( sub.length == 1 )
								opt["default"] = sub[0];
						}
						var pSpriteData:SpriteData = new SpriteData();
						if ( opt["file"] != undefined )
						{
							//pSprite = FindSprite( opt["file"] , spriteList );
						}
						if ( !pSpriteData.pSprite )
						{
							if ( opt["type"] != undefined )
								pSpriteData.pSprite = GetImageRoot().NewObj( opt["type"] , this , false );
							else
								pSpriteData.pSprite = new dUIAniImageBox( this );
							pSpriteData.pSprite.SetUIEventFunction( OnSpriteEvent );
							if ( opt["file"] != undefined )
							{
								m_nDownImageNum++;
								//pSpriteData.pSprite.LoadFromImageSet( opt["file"] );
								pSpriteData.strFileName = opt["file"];
							}
						}
						pSpriteData.pSprite.SetMouseStyle( GetMouseStyle() );
						if ( opt["width"] != undefined && opt["height"] != undefined )
							pSpriteData.pSprite.SetSize( opt["width"] , opt["height"] );
						if ( opt["tooltip"] != undefined )
						{
							pSpriteData.pSprite.SetTooltip( opt["tooltip"] );
							pSpriteData.pSprite.SetHandleMouse( true );
						}
						if ( opt["text"] != undefined )
							pSpriteData.pSprite.SetText( opt["text"] );
						if ( opt["default"] != undefined )
							pSpriteData.pSprite.SetUserData( opt["default"] );
						if ( opt["speed"] != undefined && pSpriteData.pSprite.GetObjType() == dUISystem.GUIOBJ_TYPE_ANIIMAGEBOX )
							( pSpriteData.pSprite as dUIAniImageBox ).SetPlaySpeed( opt["speed"] );
						if ( !m_vecImageList ) m_vecImageList = new Vector.<SpriteData>();
						pSpriteData.nIndexFormat = pRet.vecFormat.length;
						pSpriteData.nIndexTextPos = pTextLength;
						m_vecImageList.push( pSpriteData );
						
						str += String.fromCharCode(12288);
						pTextLength++;
						var nCurFontSize:int = format.nFontSize;
						format.nFontSize = 0;
						format.nImageWidth = pSpriteData.pSprite.GetWidth();
						format.nImageHeight = pSpriteData.pSprite.GetHeight();
						format.nBeginIndex = nLastIndex;
						format.nEndIndex = pTextLength;
						format.bUnderLine = bUnderLine;
						format.strLinkData = strUnderLineString;
						pRet.vecFormat.push( format );
						format = CopyNewFormat( format );
						format.nFontSize = nCurFontSize;
						format.nImageWidth = 0;
						format.nImageHeight = 0;
						nLastIndex = pTextLength;
					}
					bHasText = false;
				}
				else
				{
					bHasText = true;
					var ss:String = strSource.charAt( i );
					str += ss;
					pTextLength++;
				}
			}
			if ( bHasText || m_bCanEdit && str == "" )
			{
				format.nBeginIndex = nLastIndex;
				format.nEndIndex = pTextLength;
				format.bUnderLine = bUnderLine;
				format.strLinkData = strUnderLineString;
				pRet.vecFormat.push( format );
			}
			pRet.str = str;
			return pRet;
		}
		public function GetTextLength( strSource:String ):int
		{
			var ret:int = 0;
			var outData:Vector.<uint> = new Vector.<uint>;
			for ( var i:int = 0 ; i < strSource.length ; i ++ )
			{
				var signType:int = isStringASign( strSource , i , outData );
				if ( signType )
				{
					i += 10 - 1;
					if ( signType == 2 || // underline
						 signType == 3 ) // image
					{
						outData = new Vector.<uint>;
						outData[0] = 0;
						GetUnderLineString( strSource , i + 1 , outData );
						i += outData[0];
						if ( signType == 3 )// image
							ret ++;
					}
				}
				else ret ++;
			}
			return ret;
		}
		public function SubString( strSource:String , nIndex:int ):Array
		{
			var outData:Vector.<uint> = new Vector.<uint>;
			var j:int = 0;
			for ( var i:int = 0 ; i < strSource.length ; i ++ )
			{
				var signType:int = isStringASign( strSource , i , outData );
				if ( signType )
				{
					i += 10 - 1;
					if ( signType == 2 || // underline
						 signType == 3 ) // image
					{
						outData = new Vector.<uint>;
						outData[0] = 0;
						GetUnderLineString( strSource , i + 1 , outData );
						i += outData[0];
					}
				}
				else
				{
					if ( j >= nIndex )
					{
						var ret:Array = new Array();
						ret[0] = strSource.substr( 0 , i );
						ret[1] = strSource.substr( i );
						return ret;
					}
					j++;
				}
			}
			return [strSource,""];
		}
		public function DelString( strSource:String , nBegin:int , nEnd:int ):String
		{
			var ret:String = "";
			var outData:Vector.<uint> = new Vector.<uint>;
			var j:int = 0;
			for ( var i:int = 0 ; i < strSource.length ; i ++ )
			{
				var signType:int = isStringASign( strSource , i , outData );
				if ( signType )
				{
					var oldi:int = i;
					i += 10 - 1;
					if ( signType == 2 || // underline
						 signType == 3 ) // image
					{
						outData = new Vector.<uint>;
						outData[0] = 0;
						GetUnderLineString( strSource , i + 1 , outData );
						i += outData[0];
					}
					if ( j < nBegin || j >= nEnd )
					{
						for ( var k:int = oldi ; k < i ; k ++ )
							ret += strSource.charAt( k );
					}
				}
				else
				{
					if ( j < nBegin || j >= nEnd )
					{
						ret += strSource.charAt( i );
					}
					j++;
				}
			}
			return ret;
		}
		static public function ConvTextWithoutSign( strSource:String ):String
		{
			var str:String = new String();
			var outData:Vector.<uint> = new Vector.<uint>;
			for ( var i:int = 0 ; i < strSource.length ; i ++ )
			{
				var signType:int = isStringASign( strSource , i , outData );
				if ( signType )
				{
					i += 10 - 1;
					if ( signType == SIGN_TYPE_UNDERLINE || // underline
						 signType == SIGN_TYPE_IMAGE ) // image
					{
						outData = new Vector.<uint>;
						outData[0] = 0;
						GetUnderLineString( strSource , i + 1 , outData );
						i += outData[0];
					}
				}
				else str += strSource.charAt( i );
			}
			return str;
		}
		public function OnSpriteEvent( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED )
			{
				m_nDownImageNum--;
				if ( m_nDownImageNum == 0 )
				{
					UpdateSpriteSize();
					FireEvent( dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED );
				}
			}
			else
			{
				if ( event.type == dUISystem.GUIEVENT_TYPE_ON_SHOW_TOOLTIP )
					FireEvent( event.type , event.nParam1 , event.nParam2 , event.sParam , event.pObj.GetTooltip() );
				else
					FireEvent( event.type , event.nParam1 , event.nParam2 , event.sParam , event.pObj.GetUserData() );
			}
		}
		override public function SetStyleData( name:String , bSet:Boolean ):void
		{
			if ( name == "AutoEnterLine" ||
				name == "CanEdit" ||
				name == "PassWord" ||
				name == "AutoLimitTextLength" ||
				name == "AutoSetSize" ||
				name == "CanInputAND" ||
				name == "MultiLine" ||
				name == "NoSign" )
			{
				if ( isStyleData( name ) == bSet ) return;
				super.SetStyleData( name , bSet );
				if ( name == "AutoSetSize" || name == "AutoEnterLine" )
					_SetText( GetText() );
			}
		}
		public function SetSizeAsText():void
		{
			SetSize( GetTextWidth() , GetTextHeight() );
		}
		public static function compareString(a : String, b : String) : int
		{
			// 判断是否到达字符串长度
			if (a.length == 0 && b.length == 0)
				return 0;
			else if (a.length == 0)
				return -1;
			else if (b.length == 0)
				return 1;
			
			for ( var k:int = 0 ; k < a.length ; k ++ )
			{
				var c1:int = dStringUtils.CharCodeAt( a , k , dStringUtils.CODE_PAGE_UNICODE );
				var c2:int = dStringUtils.CharCodeAt( b , k , dStringUtils.CODE_PAGE_UNICODE );
				if ( c1 < c2 )
					return -1;
				else if ( c1 == c2 )
					continue;
				else if ( c1 > c2 )
					return 1;
			}
			return 0;
		}
	}	
}
import dcom.dTextFormat;
import dUI.dUIImage;
class ConvertFormatBuffer
{
	public var str:String;
	public var vecFormat:Vector.<dTextFormat> = new Vector.<dTextFormat>();
}
class SpriteData
{
	public var pSprite:dUIImage;
	public var strFileName:String;
	public var nIndexFormat:int;
	public var nIndexTextPos:int;
}