//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	import dcom.*;
	/**
	 * 图像处理类
	 * @author dym
	 */
	public class dUIImage extends dSprite
	{
		public var name:String;
		protected var m_img:dUIImageBitmapData;
		protected var m_strImageSetName:String = null;
		protected var m_pFather:dUIImage;
		protected var m_nRotation:int;
		protected var m_bRotationMirrorX:Boolean;
		protected var m_bRotationMirrorY:Boolean;
		protected var m_bEnable:Boolean = true;
		protected var m_bHandleMouse:Boolean;
		protected var m_strText:String = new String();
		static public var s_pMouseInControl:dUIImage;
		static public var s_pCapture:dUIImage;
		static protected var s_pCurrentTooltip:dUIImage;
		protected var m_bMouseIn:Boolean;
		protected var m_bDragging:Boolean;
		private var m_bDraged:Boolean;
		private var m_nDraggingStartX:int;
		private var m_nDraggingStartY:int;
		protected var m_bRDragging:Boolean;
		private var m_bRDraged:Boolean;
		private var m_nRDraggingStartX:int;
		private var m_nRDraggingStartY:int;
		protected var m_nObjType:int;
		protected var m_funUIEvent:Function;
		private var m_arrStyleData:Array = new Array();// as Boolean
		protected var m_nID:int;
		protected var m_nAlign:int;// 居中方式，0居中 1居左 2居右
		protected var m_pTooltip:Object;
		protected var m_pUserData:Object;
		protected var m_bFireEventToUser:Boolean = false;
		protected var m_bRegMouseLowEvent:Boolean;
		protected var m_bRegBringTopWhenClickWindow:Boolean;
		protected var m_bAutoSizeAsFather:Boolean;
		protected var m_bAutoSizeAsChild:Boolean;
		protected var m_nAutoPosX:int;
		protected var m_nAutoPosY:int;
		protected var m_nAlpha:int = 255;
		protected var m_bRegAutoPosPanel:Boolean;
		protected var m_bRegMouseMoveEvent:Boolean;
		//protected var m_bCanFlashWindow:Boolean;
		protected var m_pFlashWindowTimer:dTimer;
		protected var m_nFlashWindowTimes:int;
		protected var m_nFlashWindowSpeed:int;
		protected var m_nFlashWindowValue:int;
		protected var m_strControlName:String;
		protected var m_bRegDoubleClick:Boolean;
		protected var m_bRelease:Boolean = false;
		protected var m_bHandleMouseWheel:Boolean = false;
		protected var m_bGray:Boolean = false;
		protected var m_bHightLight:Boolean = false;
		protected var m_bRegMouseFadeIn:Boolean = false;
		protected var m_bRegOnSetShowEvent:Boolean = false;
		//protected var m_strSkinName:String = null;
		public var m_bLoading:Boolean;
		protected var m_pColorTransform:dUIColorTransform;
		public var m_bFromPool:Boolean;
		public var m_nUsePoolFatherObjType:int;
		protected var m_nEdgeLeft:int;
		protected var m_nEdgeTop:int;
		protected var m_nEdgeRight:int;
		protected var m_nEdgeBottom:int;
		protected var m_bShowClient:Boolean = true;
		protected var m_bWait:Boolean;
		static public var m_bContinueLButtonDown:Boolean;
		private var m_nDblClickFirstTime:int = 0;
		private var m_nDblClickStartX:int;
		private var m_nDblClickStartY:int;
		protected var m_bLButtonDownBase:Boolean;
		protected var m_bRButtonDownBase:Boolean;
		public function dUIImage( pFather:dUIImage , bUsingMask:Boolean = false )
		{
			m_pFather = pFather;
			/*if ( bUsingMask )
			{
				m_mask = new Sprite();
				mask = m_mask;
				addChild( m_mask );
			}
			mouseEnabled = false;
			useHandCursor = false;
			buttonMode = false;*/
			//addEventListener( MouseEvent.MOUSE_DOWN, _OnLButtonDown );
			if ( pFather ) pFather.AddChild( this );
		}
		protected var m_vecChildImage:Vector.<dUIImage> = new Vector.<dUIImage>;
		public function GetChild():Vector.<dUIImage>
		{
			return m_vecChildImage;
		}
		protected function AddChild( pChild:dUIImage , at:int = -1 ):void
		{
			for ( var i:int = 0 ; i < m_vecChildImage.length ; i ++ )
			{
				if ( m_vecChildImage[i] == pChild )
				{
					m_vecChildImage.splice( i , 1 );
					break;
				}
			}
			if ( at == -1 )
			{
				//addChild( pChild );
				pChild.dSpriteSetFather( this , -1 );
				m_vecChildImage.push( pChild );
			}
			else
			{
				//addChildAt( pChild , at );
				pChild.dSpriteSetFather( this , at );
				if ( at >= 0 && at < m_vecChildImage.length )
					m_vecChildImage.splice( at , 0 , pChild );
				else
					m_vecChildImage.push( pChild );
			}
		}
		protected function isHaveChild( pChild:dUIImage ):Boolean
		{
			for ( var i:int = 0 ; i < m_vecChildImage.length ; i ++ )
			{
				if ( m_vecChildImage[i] == pChild ) return true;
			}
			return false;
		}
		protected function AddChildAt( pChild:dUIImage , pAt:dUIImage ):void
		{
			if ( !isHaveChild( pAt ) ) return;
			for ( var i:int = 0 ; i < m_vecChildImage.length ; i ++ )
			{
				if ( m_vecChildImage[i] == pChild )
				{
					m_vecChildImage.splice( i , 1 );
					break;
				}
			}
			for ( i = 0 ; i < m_vecChildImage.length ; i ++ )
			{
				if ( m_vecChildImage[i] == pAt )
				{
					m_vecChildImage.splice( i + 1 , 0 , pChild );
					ChildInScene( pChild , true );
					break;
				}
			}
		}
		protected function RemoveChild( pChild:dUIImage ):void
		{
			for ( var i:int = 0 ; i < m_vecChildImage.length ; i ++ )
			{
				if ( m_vecChildImage[i] == pChild )
				{
					m_vecChildImage.splice( i , 1 );
					break;
				}
			}
			pChild.dSpriteRemoveFather();
		}
		protected function ChildInScene( pChild:dUIImage , bUpdateAll:Boolean = false ):void
		{
			var idx:int = 0;
			for ( var i:int = 0 , n:int = m_vecChildImage.length ; i < n ; ++i )
			{
				if ( m_vecChildImage[i].isShow() )
				{
					if ( pChild == m_vecChildImage[i] || bUpdateAll )
					{
						m_vecChildImage[i].dSpriteSetFather( this , idx );
						if ( !bUpdateAll )
							break;
					}
					++idx;
				}
			}
		}
		protected function ChildSetShow( bShow:Boolean , pChild:dUIImage ):void
		{
			if ( bShow ) ChildInScene( pChild );
			else pChild.dSpriteRemoveFather();
		}
		public function SetFather( pFather:dUIImage ):void
		{
			if ( m_pFather != pFather )
			{
				var b:Boolean = m_bAutoSizeAsFather;
				SetAutoSizeAsFather( false );
				if ( m_pFather ) m_pFather.RemoveChild( this );
				m_pFather = pFather;
				if ( pFather ) pFather.AddChild( this );
				SetAutoSizeAsFather( b );
			}
		}
		public function Release():void
		{
			if ( !m_bRelease )
			{
				m_bLButtonDowned = false;
				if ( m_bFromPool && GetImageRoot() )
				{
					if ( s_pCurrentTooltip == this )
					{
						if( m_pTooltip )
							FireEvent( dUISystem.GUIEVENT_TYPE_ON_SHOW_TOOLTIP , 0 , 0 , "hide" , m_pTooltip );
						s_pCurrentTooltip = null;
					}
					m_bDragging = false;
					dSpriteSetCapture( false );
					GetImageRoot().ReleaseObj( this );
					GetImageRoot().DeleteWindow( this );
					m_nID = 0;
				}
				else
				{
					if ( s_pCurrentTooltip == this )
					{
						if( m_pTooltip )
							FireEvent( dUISystem.GUIEVENT_TYPE_ON_SHOW_TOOLTIP , 0 , 0 , "hide" , m_pTooltip );
						s_pCurrentTooltip = null;
					}
					SetRelease( true );
					GetImageRoot().DeleteWindow( this );
					m_nID = 0;
					while ( m_vecChildImage.length )
					{
						m_vecChildImage[0].Release();
					}
					if ( m_pFather )
						m_pFather.RemoveChild( this );
					m_pFather = null;
					m_bDragging = false;
					dSpriteSetCapture( false );
					ReleaseImg();
				}
			}
		}
		public function ClearChild():void
		{
			while ( m_vecChildImage.length )
			{
				m_vecChildImage[0].Release();
			}
		}
		public function isRelease():Boolean
		{
			return m_bRelease;
		}
		public function SetRelease( bRelease:Boolean ):void
		{
			m_bRelease = bRelease;
			if ( bRelease )
			{
				m_strImageSetName = null;
			}
			//for ( var i:int = 0 , n:int = m_vecChildImage.length ; i < n ; i ++ )
			//	m_vecChildImage[i].SetRelease( bRelease );
		}
		public function ReleaseImg():void
		{
			dSpriteSetBitmapData( null );
			//m_strImageSetName = null;
			if ( m_img )
				m_img = null;
		}
		public function RegCanDoubleClick( bCan:Boolean ):void
		{
			//doubleClickEnabled = bCan;
			m_bRegDoubleClick = bCan;
		}
		public function RegMouseFadeIn( bReg:Boolean ):void
		{
			m_bRegMouseFadeIn = bReg;
			if ( bReg )
			{
				if( isMouseIn() )
					SetAlpha( 255 , false );
				else
					SetAlpha( 0 , false );
			}
			GetImageRoot().UpdateMyFadeInRect( this );
		}
		public function isRegMouseFadeIn():Boolean
		{
			return m_bRegMouseFadeIn;
		}
		public function RegOnSetShowEvent( bReg:Boolean ):void
		{
			m_bRegOnSetShowEvent = bReg;			
			if ( bReg )
			{
				m_bChildRegOnSetShow = true;
				if ( m_pFather )
				{
					m_pFather.m_bChildRegOnSetShow = true;
					m_pFather.RegOnSetShowEvent( true );
				}
			}
		}
		public function isRegOnSetShowEvent():Boolean
		{
			return m_bRegOnSetShowEvent;
		}
		public function SetAutoSizeAsFather( bSet:Boolean ):void
		{
			if ( m_pFather )
			{
				m_bAutoSizeAsFather = bSet;
				if( bSet ) m_bAutoSizeAsChild = false;
				if ( bSet )
				{
					SetSize( m_pFather.GetWidth() , m_pFather.GetHeight() );
				}
			}
		}
		public function isAutoSizeAsFather():Boolean
		{
			return m_bAutoSizeAsFather;
		}
		public function SetAutoSizeAsChild( bSet:Boolean ):void
		{
			m_bAutoSizeAsChild = bSet;
			if ( bSet ) m_bAutoSizeAsFather = false;
		}
		public function isAutoSizeAsChild():Boolean
		{
			return m_bAutoSizeAsChild;
		}
		public function GetFather():dUIImage
		{
			return m_pFather;
		}
		public function SetFireEventToUser( bSet:Boolean ):void
		{
			m_bFireEventToUser = bSet;
		}
		public function GetImageSetName():String
		{
			if ( m_strImageSetName == null )
				return "";
			return m_strImageSetName;
		}
		public function ConvImageSetName( strImageSetName:String ):String
		{
			if ( strImageSetName.charAt( 0 ) == "#" )
			{
				var str:String = GetImageRoot().GetImageSet().GetImageFileName( strImageSetName );
				if ( str.length ) return str;
			}
			return strImageSetName;
		}
		public function LoadFromImageSet( str:String ):void
		{
			if ( m_bRelease || str == null ) return;
			if ( str.indexOf( "\n" ) != -1 || str.indexOf( "\t" ) != -1 || str.indexOf( "\r" ) != -1 )
			{
				var s2:String = "";
				for ( var i:int = 0 ; i < str.length ; i ++ )
				{
					if( str.charAt( i ) != "\n" && str.charAt( i ) != "\t" && str.charAt( i ) != "\r" )
						s2 += str.charAt( i );
				}
				str = s2;
			}
			if ( m_strImageSetName != str )
			{
				m_strImageSetName = str;
				str = ConvImageSetName( str );
				if ( str == "" ) str = GetDefaultSkin();
				m_bLoading = true;
				_LoadFromImageSet( str );
			}
			else if ( str.length && m_bLoading == false && GetImageList() )
			{
				OnLoadImageComplate( m_strImageSetName , GetImageList() );
			}
		}
		public function _LoadFromImageSet( strImageSetName:String ):void
		{
			return _LoadFromImageSetBase( strImageSetName );
		}
		private function SplitRect( str:String , pRect:dUIImageRect ):String
		{
			if ( str.indexOf( "^" ) == -1 ) return str;
			var nStep:int = 0;
			var ret:String;
			var s:String = "";
			for ( var i:int = 0 , n:int = str.length ; i <= n ; i ++ )
			{
				if ( i == n || str.charAt( i ) == "^" )
				{
					nStep++;
					if ( nStep == 1 )
						ret = s;
					else if ( nStep == 2 )
						pRect.left = int( s );
					else if ( nStep == 3 )
						pRect.top = int( s );
					else if ( nStep == 4 )
						pRect.right = int( s );
					else if ( nStep == 5 )
						pRect.bottom = int( s );
					s = "";
				}
				else s += str.charAt( i );
			}
			return ret;
		}
		public function _LoadFromImageSetBase( strImageSetName:String ):void
		{
			var vecNeedLoad:Vector.<String> = SplitString( strImageSetName , -1 , "," , true );
			var ret:Array = new Array();
			var nNeedDown:int = vecNeedLoad.length;
			var strCurImageSetName:String = m_strImageSetName;
			for ( var i:int = 0 ; i < vecNeedLoad.length ; i ++ )
			{
				var rc:dUIImageRect = new dUIImageRect();
				var strName:String = SplitRect( vecNeedLoad[i] , rc );
				var img:dUIImageBitmapData = new dUIImageBitmapData();
				var strFromImageSet:String = GetImageRoot().GetImageSet().GetImageFileName( strName );
				img.m_bFromImageSet = false;
				if ( strFromImageSet.length )
				{
					if ( vecNeedLoad[i].indexOf( "^" ) == -1 )
						rc = GetImageRoot().GetImageSet().GetImageRect( strName );
					img.m_bFromImageSet = true;
					img.m_strImageSetName = vecNeedLoad[i];
					img.m_strBitmapFileName = strFromImageSet;
					strName = strFromImageSet;
				}
				else img.m_strBitmapFileName = strName;
				img.m_rcImageFrom = rc;
				ret[i] = img;
				if ( strName == "color" )
				{
					img.Create( 1 , 1 , rc.left );
					nNeedDown --;
					if ( nNeedDown == 0 ) OnLoadImageComplate( strCurImageSetName , ret );
				}
				else if ( strName == "" || strName.indexOf( "." ) == -1 )
				{
					nNeedDown --;
					if ( nNeedDown == 0 ) OnLoadImageComplate( strCurImageSetName , ret );
				}
				else
				{
					if ( img.m_bFromImageSet && GetImageRoot().GetImageSet().m_arrBitmapBuffer[ img.m_strImageSetName ] != undefined )
					{
						ret[i] = GetImageRoot().GetImageSet().m_arrBitmapBuffer[ img.m_strImageSetName ];
						nNeedDown --;
						if ( nNeedDown == 0 ) OnLoadImageComplate( strCurImageSetName , ret );
					}
					else
					{
						img.ImageLoadFromFile( GetImageRoot().GetCustomLoadImageFunction() , strName , function( bmp:dBitmapData ):void
						{
							var img:dUIImageBitmapData = bmp as dUIImageBitmapData;
							if ( img.m_bFromImageSet )
								GetImageRoot().GetImageSet().m_arrBitmapBuffer[img.m_strImageSetName] = bmp;
							var rc:dUIImageRect = img.m_rcImageFrom;
							nNeedDown --;
							if ( rc.left == -1 )
							{
								var perX:int = img.GetWidth() / rc.top;
								var perY:int = img.GetHeight() / rc.right;
								var frameX:int = rc.bottom % rc.top;
								var frameY:int = rc.bottom / rc.top;
								img.SetRect( new dUIImageRect( frameX * perX , frameY * perY , frameX * perX + perX , frameY * perY + perY ) );
							}
							else if ( rc.Width() && rc.Height() )
							{
								img.SetRect( rc );
							}
							if ( nNeedDown == 0 )
								OnLoadImageComplate( strCurImageSetName , ret );
						} , null , function():void
						{
							img.Create( 1 , 1 , 0 );
							nNeedDown --;
							if ( nNeedDown == 0 )
								OnLoadImageComplate( strCurImageSetName , ret );
						});
					}
				}
			}
		}
		public function GetDefaultSkin():String
		{
			return "";
		}
		public function CreateImage( w:int , h:int , color:uint ):void
		{
			super.SetSize( w , h );
			m_img = new dUIImageBitmapData();
			m_img.Create( w , h , color );
			dSpriteSetBitmapData( m_img );
		}
		public function DrawTo( pDest:dBitmapData , dest_left:int , dest_top:int , dest_right:int , dest_bottom:int , src_left:int , src_top:int , src_right:int , src_bottom:int , pClip:dRect = null ):void
		{
			if ( GetSelfImage() && GetSelfImageWidth() && GetSelfImageHeight() )
			{
				if ( GetColorTransform() )
				{
					var pNewBitmapData:dBitmapData = new dBitmapData();
					//pNewBitmapData.Copy( m_img );
					pNewBitmapData.Create( GetSelfImageWidth() , GetSelfImageHeight() , 0 );
					pNewBitmapData.Draw( GetSelfImage() , 0 , 0 , GetSelfImageWidth() , GetSelfImageHeight() , 0 , 0 , GetSelfImageWidth() , GetSelfImageHeight() );
					pNewBitmapData.ApplyColorTransform( GetColorTransform().nColorBrightness , GetColorTransform().nColorContrast ,
						GetColorTransform().nColorSaturation , GetColorTransform().nColorHue );
					pDest.Draw( pNewBitmapData , dest_left , dest_top , dest_right , dest_bottom , src_left , src_top , src_right , src_bottom , pClip );
				}
				else
					pDest.Draw( GetSelfImage() , dest_left , dest_top , dest_right , dest_bottom , src_left , src_top , src_right , src_bottom , pClip );
			}
		}
		/*public function DrawTo( pDest:dBitmapData , dest_left:int , dest_top:int , dest_right:int , dest_bottom:int , src_left:int , src_top:int , src_right:int , src_bottom:int , pClip:dRect = null ):void
		{
			dSpriteDrawToBitmapData( pDest , dest_left , dest_top , dest_right , dest_bottom , src_left , src_top , src_right , src_bottom , pClip );
		}*/
		public function GetImageColorBound( idx:int ):dUIImageRect
		{
			if ( !m_img ) return new dUIImageRect();
			var rc:dRect = m_img.GetColorBound();
			return new dUIImageRect( rc.left , rc.top , rc.right , rc.bottom );
		}
		public function SplitName( strName:String , nNum:int , bFillLast:Boolean = true ):Vector.<String>
		{
			var ret:Vector.<String> = new Vector.<String>;
			ret.length = nNum;
			for ( var i:int = 0 ; i < ret.length ; i ++ )
				ret[i] = new String();
			var step:int = 0;
			var t:String = new String();
			strName += ",";
			for ( i = 0 ; i < strName.length ; i ++ )
			{
				if ( strName.charAt( i ) == "," )
				{
					if ( step < nNum )
					{
						ret[step] = t;
						t = "";
					}
					step++;
				}
				else if( strName.charAt( i ) != " " && strName.charAt( i ) != "\t" && strName.charAt( i ) != "\n" && strName.charAt( i ) != "\r" )
					t += strName.charAt( i );
			}
			if ( step > 0 && bFillLast )
			{
				for ( i = step ; i < nNum ; i ++ )
					ret[i] = ret[step - 1];
			}
			return ret;
		}
		public function SplitString( strName:String , nNum:int = -1 , sSplit:String = "|" , bWithoutSpace:Boolean = false ):Vector.<String>
		{
			if ( strName == null ) strName = new String();
			var ret:Vector.<String> = new Vector.<String>;
			var step:int = 0;
			var t:String = new String();
			for ( var i:int = 0 ; i <= strName.length ; i ++ )
			{
				if ( i == strName.length || strName.charAt( i ) == sSplit && ( nNum == -1 || step < nNum ) )
				{
					ret.push( t );
					t = "";
					step++;
				}
				else if( (bWithoutSpace && strName.charAt( i ) != " " && strName.charAt( i ) != "\t") || !bWithoutSpace )
					t += strName.charAt( i );
			}
			if ( nNum != -1 )
			{
				if ( ret.length < nNum )
				{
					for ( i = ret.length ; i < nNum ; i ++ )
						ret.push( new String() );
				}
				else if ( ret.length > nNum ) ret.length = nNum;
			}
			return ret;
		}
		public function LoadFromText( bCanEdit:Boolean , str:String , dest_width:int , onComplete:Function , vecFormat:Vector.<dTextFormat> , nFormatArgCount:int , bGetCharBound:Boolean , nFlag:int ):void
		{
			if ( bCanEdit )
			{
				m_img = null;
				dSpriteSetBitmapData( null );
				dSpriteCreateInputBox( GetAlignType() , str , dest_width , bGetCharBound , function( bmp:dSprite , vecBoundRect:Vector.<dRect> , nBoundArgNum:int ):void
				{
					//dSpriteSetBitmapData( m_img );
					onComplete( vecBoundRect , nBoundArgNum );
				} , vecFormat , nFormatArgCount , nFlag );
			}
			else
			{
				dSpriteReleaseInputBox();
				if ( !m_img )
					m_img = new dUIImageBitmapData();
				m_img.LoadFromText( GetAlignType() , str , dest_width , bGetCharBound , function( bmp:dBitmapData , vecBoundRect:Vector.<dRect> , nBoundArgNum:int ):void
				{
					SetSize( m_img.GetWidth() , m_img.GetHeight() );
					dSpriteSetBitmapData( m_img );
					onComplete( vecBoundRect , nBoundArgNum );
				} , vecFormat , nFormatArgCount );
			}
		}
		public function LoadFromFile( strFileName:String ):void
		{
			return LoadFromImageSet( strFileName );
		}
		public function LoadFromBin( data:dByteArray ):void
		{
			if ( !m_img )
			{
				m_img = new dUIImageBitmapData();
				m_strImageSetName = null;
				dSpriteSetBitmapData( m_img );
			}
			m_img.LoadFromBin( data , function( bmp:dBitmapData ):void
			{
				OnLoadImageComplate( null , GetImageList() );
			}, null );
		}
		public function GetImage( idx:int ):dUIImageBitmapData
		{
			return m_img;
		}
		public function GetSelfImage():dUIImageBitmapData
		{
			if ( m_img != null && m_img.m_pRotationNew ) return m_img.m_pRotationNew;
			return m_img;
		}
		public function GetSelfImageWidth():int
		{
			if ( m_img ) return m_img.GetWidth();
			return 0;
		}
		public function GetSelfImageHeight():int
		{
			if ( m_img ) return m_img.GetHeight();
			return 0;
		}
		public function GetImageList():Array
		{
			return [ m_img ];
		}
		public function LoadFromBitmapData( bmpData:dBitmapData ):void
		{
			if ( !m_img )
			{
				m_img = new dUIImageBitmapData();
				m_strImageSetName = null;
			}
			m_img.LoadFromBitmapData( bmpData , function( bmp:dBitmapData ):void
			{
				dSpriteSetBitmapData( m_img );
				OnLoadImageComplate( null , GetImageList() );
			} , null );
			/*if ( bmpData )
			{
				if ( m_img == null )
				{
					m_img = new dUIImageBitmap();
					addChildAt( m_img , 0 );
				}
				GetImageRoot().GetLoader().LoadFromBitmap( m_img , bmpData );
				//if ( GetWidth() == 0 || GetHeight() == 0 )
				SetSize( GetImageSrcRect().Width() , GetImageSrcRect().Height() );
			}*/
		}
		protected var m_pImgRoot:dUIImageRoot;
		public function GetImageRoot():dUIImageRoot
		{
			if ( !m_pImgRoot )
			{
				var p:dUIImage = m_pFather;
				while ( p )
				{
					if ( p.GetObjType() == dUISystem.GUIOBJ_TYPE_UIROOT )
					{
						m_pImgRoot = p as dUIImageRoot;
						return p as dUIImageRoot;
					}
					p = p.GetFather();
				}
				return null;
			}
			return m_pImgRoot;
		}
		public function GetMouseX():int
		{
			return dSpriteGetMouseX();
		}
		public function GetMouseY():int
		{
			return dSpriteGetMouseY();
		}
		protected var m_arrLangText:Array;
		protected var m_strCurLang:String;
		public function SetLanguageText( strLang:String , strText:String ):void
		{
			if ( !m_arrLangText ) m_arrLangText = new Array();
			m_arrLangText[strLang] = strText;
		}
		public function GetLanguageText( strLang:String ):String
		{
			if ( !m_arrLangText || !m_arrLangText[strLang] ) return "";
			return m_arrLangText[strLang];
		}
		public function ShowLanguageText( strLang:String ):void
		{
			m_strCurLang = strLang;
			SetText( GetLanguageText( strLang ) );
		}
		public function GetCurrentLanguage():String
		{
			if ( !m_strCurLang ) return "";
			return m_strCurLang;
		}
		public function SetText( str:String ):void
		{
			if ( str == null ) str = "";
			if ( str != GetText() )
				_SetText( str );
		}
		public function _SetText( str:String ):void
		{
			if ( str == null ) str = "";
			m_strText = str;
		}
		public function SetControlName( str:String ):void
		{
			m_strControlName = str;
		}
		public function GetControlName():String
		{
			if ( m_strControlName == null ) return "";
			return m_strControlName;
		}
		public function FlashWindow( nTimes:int , nSpeed:int , nTab:int , nLine:int ):void
		{
			//if ( m_bCanFlashWindow )
			{
				if ( nTimes < 0 ) nTimes = int.MAX_VALUE / 2;
				if ( nTimes == 0 ) nTimes = 4;
				if ( nSpeed == 0 ) nSpeed = 500;
				if ( nTimes > int.MAX_VALUE / 2 )
					 nTimes = int.MAX_VALUE / 2;
				if ( nTimes < 1 ) nTimes = 1;
				m_nFlashWindowTimes = nTimes;
				m_nFlashWindowSpeed = nSpeed;
				m_nFlashWindowValue = nSpeed;
				//if ( isShowInScene() )
					FlashWindow_Work();
			}
		}
		private function FlashWindow_Work():void
		{
			OnFlashWindow( 1.0 );
			if ( !m_pFlashWindowTimer )
			{
				m_pFlashWindowTimer = new dTimer();
				m_pFlashWindowTimer.Create( 0 , 0 , _OnFlashWindowTimer );
			}
		}
		private function FlashWindow_NoWork():void
		{
			if ( m_pFlashWindowTimer )
			{
				m_pFlashWindowTimer.Stop();
				m_pFlashWindowTimer = null;
			}
		}
		public function FlashWindowDisable( nTab:int , nLine:int ):void
		{
			if ( m_pFlashWindowTimer )
			{
				FlashWindow_NoWork();
				m_nFlashWindowValue = 0;
				m_nFlashWindowTimes = 0;
				m_nFlashWindowSpeed = 0;
				OnFlashWindow( 0.0 );
			}
		}
		public function isFlashingWindow():Boolean
		{
			return m_pFlashWindowTimer != null;
		}
		private function _OnFlashWindowTimer( pTimer:dTimer , nRepeat:int ):void
		{
			m_nFlashWindowValue += GetImageRoot().GetTimeSinceLastFrame();
			while( m_nFlashWindowValue > m_nFlashWindowSpeed * 2 )
			{
				m_nFlashWindowValue -= m_nFlashWindowSpeed * 2;
				m_nFlashWindowTimes--;
				if ( m_nFlashWindowTimes <= 0 )
				{
					FlashWindowDisable( 0 , 0 );
					return;
				}
			}
			if ( m_nFlashWindowValue <= m_nFlashWindowSpeed )
				OnFlashWindow( m_nFlashWindowValue / m_nFlashWindowSpeed );
			else
				OnFlashWindow( (m_nFlashWindowSpeed * 2 - m_nFlashWindowValue) / m_nFlashWindowSpeed );
		}
		protected function OnFlashWindow( fLight:Number ):void
		{
			SetAlpha( fLight * 255 );
		}
		public function GetObjType():int
		{
			return m_nObjType;
		}
		public function SetObjType( type:int ):void
		{
			m_nObjType = type;
		}
		public function GetText():String
		{
			return m_strText;
		}
		public function isHaveImg():Boolean
		{
			return m_img != null;
		}
		override public function SetShow( bShow:Boolean ):void
		{
			if ( isShow() != bShow )
			{
				super.SetShow( bShow );
				if ( !bShow && GetImageRoot() && GetImageRoot().GetComboListBoxBoard() &&
					 GetImageRoot().GetComboListBoxBoard().isShow() )
				{
					GetImageRoot().CheckComboBox( this );
				}
				dSpriteSetCapture( false );
				if ( m_pFather && m_pFather.GetObjType() != dUISystem.GUIOBJ_TYPE_ANIIMAGEBOX ) m_pFather.ChildSetShow( bShow , this );
				m_bLButtonDownBase = false;
				m_bRButtonDownBase = false;
				m_bDragging = false;
				_OnSetShow( this , bShow );
				if ( m_nFlashWindowTimes > 0 )
				{
					if ( isShowInScene() )
						FlashWindow_Work();
					else
						FlashWindow_NoWork();
				}
			}
		}
		public function isShowInScene():Boolean
		{
			var pImage:dUIImage = this;
			while ( pImage )
			{
				if ( !pImage.isShow() ) return false;
				pImage = pImage.GetFather();
			}
			return true;
		}
		override public function dSpriteSetCapture( bSet:Boolean ):Boolean
		{
			var ret:Boolean = super.dSpriteSetCapture( bSet );
			if ( bSet ) s_pCapture = this;
			else if ( ret ) s_pCapture = null;
			return ret;
		}
		private var m_bChildRegOnSetShow:Boolean = false;
		private function _OnSetShow( pImage:dUIImage , bShow:Boolean ):void
		{
			if ( pImage.m_bChildRegOnSetShow )
			{
				//pImage.OnSetShow( bShow );
				pImage.__OnSetShow( bShow );
				for ( var i:int = 0 ; i < pImage.m_vecChildImage.length ; i ++ )
				{
					if ( bShow && !pImage.isShow() || pImage.isRelease() ) continue;
					_OnSetShow( pImage.m_vecChildImage[i] , bShow );
				}
			}
		}
		private function __OnSetShow( bShow:Boolean ):void
		{
			if ( m_bRegOnSetShowEvent )
				FireEvent( dUISystem.GUIEVENT_TYPE_ON_SETSHOW , int( isShow() ) );
			//if ( !bShow && m_bMouseIn )
			//	_OnMouseOut( 0 , 0 );
		}
		public function OnSetShow( bShow:Boolean ):void
		{
		}
		public function SetAlignPos( align:int , w:int , h:int , off_x:int , off_y:int ):void
		{
			var x:int;
			if ( align & dUISystem.GUI_ALIGN_LEFT ) x = 0;
			else if ( align & dUISystem.GUI_ALIGN_RIGHT ) x = w - GetWidth();
			else x = ( w - GetWidth() ) / 2;
			var y:int;
			if ( align & dUISystem.GUI_ALIGN_TOP ) y = 0;
			else if ( align & dUISystem.GUI_ALIGN_BOTTOM ) y = h - GetHeight();
			else y = ( h - GetHeight() ) / 2;
			SetPos( x + off_x , y + off_y );
		}
		public function SetShowClient( bShow:Boolean , nTabIndex:int ):void
		{
			m_bShowClient = bShow;
		}
		public function isShowClient( nTabIndex:int ):Boolean
		{
			return m_bShowClient;
		}
		public function SetWait( bWait:Boolean , nTabIndex:int ):void
		{
			m_bWait = bWait;
		}
		public function isWait( nTabIndex:int ):Boolean
		{
			return m_bWait;
		}
		protected var m_fAutoPosAddX:Number = 0.0;
		protected var m_fAutoPosAddY:Number = 0.0;
		override public function SetSize( w:int , h:int ):void
		{
			if ( w < 0 ) w = 0;
			if ( h < 0 ) h = 0;
			var nWidth:int = GetWidth();
			var nHeight:int = GetHeight();
			if ( nWidth != w || nHeight != h )
			{
				var nOldWidth:int = nWidth;
				var nOldHeight:int = nHeight;
				super.SetSize( w , h );
				m_fAutoPosAddX += (w - nOldWidth) / 2;
				m_fAutoPosAddY += (h - nOldHeight) / 2;
				for ( var i:int = 0 ; i < m_vecChildImage.length ; i ++ )
				{
					var img:dUIImage = m_vecChildImage[i];
					if ( img.isRelease() ) continue;
					if( img.isAutoSizeAsFather() )
						img.SetSize( w , h );
					else if ( m_bRegAutoPosPanel )
					{
						var x:int = img.GetPosX();
						var y:int = img.GetPosY();
						if ( img.GetAutoPosX() == dUISystem.GUI_AUTOPOS_CENTER )
							x += int( m_fAutoPosAddX );
						else if ( img.GetAutoPosX() == dUISystem.GUI_AUTOPOS_RIGHT_BOTTOM )
							x += w - nOldWidth;
						if ( img.GetAutoPosY() == dUISystem.GUI_AUTOPOS_CENTER )
							y += int( m_fAutoPosAddY );
						else if ( img.GetAutoPosY() == dUISystem.GUI_AUTOPOS_RIGHT_BOTTOM )
							y += h - nOldHeight;
						img.SetPos( x , y );
					}
				}
				m_fAutoPosAddX -= int( m_fAutoPosAddX );
				m_fAutoPosAddY -= int( m_fAutoPosAddY );
				if ( m_pFather && m_pFather.isAutoSizeAsChild() )
					m_pFather.SetSizeAsChild();
				if ( m_nID )
					FireEvent( dUISystem.GUIEVENT_TYPE_ON_RESIZE , w , h );
				//if ( m_bRegMouseFadeIn )
				//	GetImageRoot().UpdateMyFadeInRect( this );
			}
		}
		public function SetSizeAsChild():void
		{
			var maxWidth:int = 0;
			var maxHeight:int = 0;
			for ( var i:int = 0 ; i < m_vecChildImage.length ; i ++ )
			{
				var img:dUIImage = m_vecChildImage[i];
				if ( img.isRelease() ) continue;
				var maxW:int = img.GetPosX() + img.GetWidth();
				var maxH:int = img.GetPosY() + img.GetHeight();
				if ( maxWidth < maxW ) maxWidth = maxW;
				if ( maxHeight < maxH ) maxHeight = maxH;
			}
			if( GetWidth() != maxWidth || GetHeight() != maxHeight )
				SetSize( maxWidth , maxHeight );
		}
		public function GetClient():dUIImage
		{
			return this;
		}
		public function SetMargin( edge:int , value:int ):void
		{
			if ( edge == 0 )// left
				SetPos( value , GetPosY() );
			else if ( edge == 1 )// top
				SetPos( GetPosX() , value );
			else if ( edge == 2 )// right
				SetPos( m_pFather.GetWidth() - GetWidth() - value , GetPosY() );
			else if ( edge == 3 )// bottom
				SetPos( GetPosX() , m_pFather.GetHeight() - GetHeight() - value );
		}
		override public function SetPos( _x:int , _y:int ):void
		{
			if ( GetPosX() != _x || GetPosY() != _y )
			{
				super.SetPos( _x , _y );
				if ( m_pFather && m_pFather.isAutoSizeAsChild() )
					m_pFather.SetSizeAsChild();
			}
		}
		public function SetRotation( nAngle:int , bMirrorX:Boolean = false , bMirrorY:Boolean = false ):void
		{
			while ( nAngle < 0 ) nAngle += 360;
			nAngle %= 360;
			if ( m_nRotation != nAngle || m_bRotationMirrorX != bMirrorX || m_bRotationMirrorY != bMirrorY )
			{
				m_nRotation = nAngle;
				m_bRotationMirrorX = bMirrorX;
				m_bRotationMirrorY = bMirrorY;
				if ( m_img )
				{
					if ( !m_img.m_pRotationNew )
					{
						var imgOld:dUIImageBitmapData = m_img;
						m_img = new dUIImageBitmapData();
						m_img.Create( imgOld.GetWidth() , imgOld.GetHeight() , 0 );
						m_img.Draw( imgOld , 0 , 0 , imgOld.GetWidth() , imgOld.GetHeight() , 0 , 0 , imgOld.GetWidth() , imgOld.GetHeight() );
						m_img.m_pRotationNew = new dUIImageBitmapData();
						m_img.m_pRotationNew.Create( m_img.GetWidth() , m_img.GetHeight() , 0 );
					}
					else m_img.m_pRotationNew.FillColor( 0 );
					m_img.m_pRotationNew.DrawRotation( m_img , Number( m_nRotation ) * 3.14159265 / 180.0 , bMirrorX , bMirrorY );
					dSpriteSetBitmapData( m_img.m_pRotationNew );
				}
				/*if ( m_img && m_img.bitmapData && m_imgData )
				{
					var m:Matrix = new Matrix();
					var w:int = m_img.bitmapData.width;
					var h:int = m_img.bitmapData.height;
					m.translate( -w / 2 , -h / 2 );
					m.rotate( nAngle * 3.1415926 / 180.0 );
					m.translate( w / 2 , h / 2 );
					m_img.bitmapData.copyPixels( m_imgData.pBitmapData ,
						new Rectangle( m_srcRect.left , m_srcRect.top , m_srcRect.Width() , m_srcRect.Height() ) ,
						new Point( 0 , 0 ) );
					var bmp:BitmapData = new BitmapData( m_img.bitmapData.width , m_img.bitmapData.height , true , 0 );
					bmp.draw( m_img.bitmapData , m , null , null , null , true );
					m_img.bitmapData.dispose();
					m_img.bitmapData = bmp;
				}*/
				//GetImageRoot().GetLoader().Rotation( m_img , m_nRotation );
			}
		}
		public function GetRotation():int
		{
			return m_nRotation;
		}
		public function isRotationMirrorX():Boolean
		{
			return m_bRotationMirrorX;
		}
		public function isRotationMirrorY():Boolean
		{
			return m_bRotationMirrorY;
		}
		override public function GetPosX_World():int
		{
			/*var p:Point = new Point( x , y );
			localToGlobal( p );
			return p.x;*/
			var ret:int = 0;
			var p:dUIImage = this;
			while ( p && p.GetObjType() != dUISystem.GUIOBJ_TYPE_UIROOT )
			{
				ret += p.GetPosX();
				p = p.GetFather();
			}
			return ret;
		}
		override public function GetPosY_World():int
		{
			/*var p:Point = new Point( x , y );
			localToGlobal( p );
			return p.y;*/
			var ret:int = 0;
			var p:dUIImage = this;
			while ( p && p.GetObjType() != dUISystem.GUIOBJ_TYPE_UIROOT )
			{
				ret += p.GetPosY();
				p = p.GetFather();
			}
			return ret;
		}
		public function SetAutoPos( xType:int , yType:int ):void
		{
			m_nAutoPosX = xType;
			m_nAutoPosY = yType;
		}
		public function GetAutoPosX():int
		{
			return m_nAutoPosX;
		}
		public function GetAutoPosY():int
		{
			return m_nAutoPosY;
		}
		public function SetAlpha( nAlpha255:int , bSetToChild:Boolean = true ):void
		{
			if ( nAlpha255 < 0 ) nAlpha255 = 0;
			else if ( nAlpha255 > 255 ) nAlpha255 = 255;
			if ( m_nAlpha != nAlpha255 )
			{
				m_nAlpha = nAlpha255;
				dSpriteSetAlpha( m_nAlpha );
				/*if ( bSetToChild )
				{
					for ( var i:int = 0 ; i < m_vecChildImage.length ; i ++ )
					{
						if ( !m_vecChildImage[i].isRelease() )
							m_vecChildImage[i].SetAlpha( nAlpha255 );
					}
				}*/
			}
		}
		public function GetAlpha():int
		{
			return m_nAlpha;
		}
		public function MoveTop( pAt:dUIImage = null ):void
		{
			if ( m_pFather )
			{
				if ( pAt )
					m_pFather.AddChildAt( this , pAt );
				else
					m_pFather.AddChild( this );
			}
			FireEvent( dUISystem.GUIEVENT_TYPE_WINDOW_BRING_ON_TOP );
		}
		public function MoveBottom():void
		{
			if ( m_pFather )
				m_pFather.AddChild( this , 0 );
			FireEvent( dUISystem.GUIEVENT_TYPE_WINDOW_BRING_ON_BOTTOM );
		}
		public function EnableWindow( bEnable:Boolean ):void
		{
			m_bEnable = bEnable;
		}
		public function isWindowEnable():Boolean
		{
			return m_bEnable;
		}
		private function OnMouseEventFun( type:int , x:int , y:int ):int
		{
			if ( type == dSprite.MOUSE_LBUTTONDOWN )
			{
				m_bLButtonDownBase = true;
				dSpriteSetCapture( true );
				if ( !m_bRegMouseMoveEvent )
					dSpriteSetMouseMoveFun( _OnMouseMove );
				return _OnLButtonDown( x , y );
			}
			else if ( type == dSprite.MOUSE_LBUTTONUP )
			{
				m_bLButtonDownBase = false;
				if ( !m_bLButtonDownBase && !m_bRButtonDownBase )
				{
					dSpriteSetCapture( false );
					if ( !m_bRegMouseMoveEvent )
						dSpriteSetMouseMoveFun( null );
				}
				return _OnLButtonUp( x , y );
			}
			else if ( type == dSprite.MOUSE_RBUTTONDOWN )
			{
				m_bRButtonDownBase = true;
				dSpriteSetCapture( true );
				if ( !m_bRegMouseMoveEvent )
					dSpriteSetMouseMoveFun( _OnMouseMove );
				return _OnRButtonDown( x , y );
			}
			else if ( type == dSprite.MOUSE_RBUTTONUP )
			{
				m_bRButtonDownBase = false;
				if ( !m_bLButtonDownBase && !m_bRButtonDownBase )
				{
					dSpriteSetCapture( false );
					if ( !m_bRegMouseMoveEvent )
						dSpriteSetMouseMoveFun( null );
				}
				return _OnRButtonUp( x , y );
			}
			else if ( type == dSprite.MOUSE_IN )
				return _OnMouseIn( x , y );
			else if ( type == dSprite.MOUSE_OUT )
				return _OnMouseOut( x , y );
			//else if ( type == dSprite.MOUSE_WHEEL )
			//	return _OnMouseWheel( x );
			return 0;
		}
		public function SetHandleMouse( bSet:Boolean ):void
		{
			m_bHandleMouse = bSet;
			//mouseEnabled = bSet;
			if ( bSet )
			{
				dSpriteSetMouseEventFun( OnMouseEventFun );
			}
			else
			{
				dSpriteSetCapture( false );
				dSpriteSetMouseEventFun( null );
				if ( m_bMouseIn )
				{
					_OnMouseOut( 0 , 0 );
				}
			}
		}
		protected var m_nEventReturn:int;
		public function SetEventReturn( n:int ):void
		{
			m_nEventReturn = n;
		}
		private function _OnKeyEvent( type:int , keycode:int , keychar:String ):int
		{
			if ( type == dSprite.KEY_DOWN )
			{
				FireEvent( dUISystem.GUIEVENT_TYPE_KEYDOWN , keycode , 0 , keychar );
				return 1;
			}
			else if ( type == dSprite.KEY_UP )
			{
				FireEvent( dUISystem.GUIEVENT_TYPE_KEYUP , keycode , 0 , keychar );
				return 1;
			}
			else if ( type == dSprite.TEXT_INPUT )
			{
				m_nEventReturn = 0;
				FireEvent( dUISystem.GUIEVENT_TYPE_SUPPERTEXT_CHANGED , 0 , 0 , keychar );
				return m_nEventReturn;
			}
			else if ( type == dSprite.TEXT_FOCUS_IN )
				FireEvent( dUISystem.GUIEVENT_TYPE_ON_FOCUS );
			else if ( type == dSprite.TEXT_FOCUS_LOST )
				FireEvent( dUISystem.GUIEVENT_TYPE_ON_FOCUS_LOST );
			return 0;
		}
		public function SetHandleKey( bSet:Boolean ):void
		{
			if ( bSet ) dSpriteSetKeyEventFun( _OnKeyEvent );
			else dSpriteSetKeyEventFun( null );
		}
		public function isHandleMouse():Boolean
		{
			return m_bHandleMouse;
		}
		public function SetHandleMouseWheel( bHandle:Boolean ):void
		{
			m_bHandleMouseWheel = bHandle;
		}
		public function isHandleMouseWheel():Boolean
		{
			return m_bHandleMouseWheel;
		}
		public function SetTooltip( pData:Object ):void
		{
			if ( m_pTooltip && pData == null && s_pCurrentTooltip == this )
			{
				FireEvent( dUISystem.GUIEVENT_TYPE_ON_SHOW_TOOLTIP , 0 , 0 , "hide" , m_pTooltip );
				s_pCurrentTooltip = null;
			}
			m_pTooltip = pData;
		}
		public function GetTooltip():Object
		{
			return m_pTooltip;
		}
		public function ResetStyle():void
		{
		}
		public function SetStyleData( name:String , bSet:Boolean ):void
		{
			m_arrStyleData[ name ] = bSet;
		}
		public function isStyleData( name:String ):Boolean
		{
			return m_arrStyleData[ name ] as Boolean;
		}
		public function SetUserData( pUserData:Object ):void
		{
			m_pUserData = pUserData;
		}
		public function GetUserData():Object
		{
			return m_pUserData;
		}
		public function isMouseIn():Boolean
		{
			return GetImageRoot().isObjMouseIn( this );
			/*//if( isHandleMouse() ) return m_bMouseIn;
			if ( isHandleMouse() ) return s_pMouseInControl == this;
			//return dUISystem.GetImageRoot().isObjMouseIn( this );
			var w:int = GetWidth();
			var h:int = GetHeight();
			var mx:int = dSpriteGetMouseX();
			var my:int = dSpriteGetMouseY();
			if ( mx >= 0 && my >= 0 && mx < w && my < h )
				return true;
			return false;*/
		}
		private function _OnMouseIn( x:int , y:int ):int
		{
			s_pMouseInControl = this;

			if( m_bEnable )
				OnMouseIn( x , y );
			m_bMouseIn = true;
			
			if ( m_pTooltip && m_nObjType != dUISystem.GUIOBJ_TYPE_LISTBOX && m_nObjType != dUISystem.GUIOBJ_TYPE_LISTBOXOBJ )
			{
				//FireEvent( dUISystem.GUIEVENT_TYPE_ON_SHOW_TOOLTIP , GetPosX_World() + GetWidth() , GetPosY_World() + GetHeight() , "show" , m_pTooltip );
				var pThis:dUIImage = this;
				GetImageRoot().RequireShowTooltip( function():void
				{
					if ( !m_bRelease && m_pTooltip && m_bMouseIn )
					{
						FireEvent( dUISystem.GUIEVENT_TYPE_ON_SHOW_TOOLTIP , 0 , GetObjType() , "show" , m_pTooltip );
						s_pCurrentTooltip = pThis;
					}
				} );
			}
			return 1;
		}
		private function _OnMouseOut( x:int , y:int ):int
		{
			//if ( s_pMouseInControl == this )
			{
				if ( m_bMouseIn )
				{
					OnMouseOut( x , y );
					m_bMouseIn = false;
				}
				s_pMouseInControl = null;
				return 1;
			}
			return 1;
		}
		public function OnMouseMove( x:int , y:int ):void
		{
		}
		private function _OnMouseMove( type:int , x:int , y:int ):int
		{
			m_nDblClickFirstTime = 0;
			var vxL:int = x - m_nDraggingStartX;
			var vyL:int = y - m_nDraggingStartY;
			var vxR:int = x - m_nRDraggingStartX;
			var vyR:int = y - m_nRDraggingStartY;
			var ox:int = GetPosX_World();
			var oy:int = GetPosY_World();
			if ( m_bDragging && m_bEnable )
			{
				OnLButtonDrag( vxL , vyL );
				m_bDraged = true;
			}
			if ( m_bRDragging && m_bEnable )
			{
				OnRButtonDrag( vxR , vyR );
				m_bRDraged = true;
			}
			OnMouseMove( x , y );
			m_nDraggingStartX = x - (GetPosX_World() - ox);
			m_nDraggingStartY = y - (GetPosY_World() - oy);
			m_nRDraggingStartX = x - (GetPosX_World() - ox);
			m_nRDraggingStartY = y - (GetPosY_World() - oy);
			return 0;
		}
		public function _OnMouseWheel( value:int ):int
		{
			if ( isHandleMouseWheel() )
			{
				OnMouseWheel( -value );
				return 1;
			}
			else if ( m_pFather ) return m_pFather._OnMouseWheel( value );
			return 0;
		}
		private function _OnLButtonDown( x:int , y:int ):int
		{
			if ( m_bEnable )
			{
				var p:dUIImage = this;
				while ( p.m_pFather )
				{
					if ( p.m_pFather.isRegBringTopWhenClickWindow() && p.isHandleMouse() )
					{
						p.MoveTop();
						break;
					}
					p = p.m_pFather;
				}
				
				var bDlbClicked:Boolean = false;
				if ( m_bRegDoubleClick )
				{
					if( m_nDblClickFirstTime == 0 )
						m_nDblClickFirstTime = dUIImageRoot.timeGetTime();
					else
					{
						var tCurTime:int = dUIImageRoot.timeGetTime();
						if ( tCurTime - m_nDblClickFirstTime < 400 && x == m_nDblClickStartX && y == m_nDblClickStartY )
						{
							OnLButtonDblClick( x , y );
							m_nDblClickFirstTime = 0;
							bDlbClicked = true;
						}
						else
							m_nDblClickFirstTime = dUIImageRoot.timeGetTime();
					}
				}
				if( !bDlbClicked )
					OnLButtonDown( x , y );
				if ( !m_bRelease )
				{
					m_bDragging = true;
					m_nDraggingStartX = x;
					m_nDraggingStartY = y;
					
					m_nDblClickStartX = x;
					m_nDblClickStartY = y;
				}
			}
			return 1;
		}
		private function _OnRButtonDown( x:int , y:int ):int
		{
			if ( m_bEnable )
			{
				OnRButtonDown( x , y );
				if ( !m_bRelease )
				{
					m_bRDragging = true;
					m_nRDraggingStartX = x;
					m_nRDraggingStartY = y;
				}
			}
			return 1;
		}
		public function ContinueLButtonDown():void
		{
			/*m_bContinueLButtonDown = true;
			if ( m_bRootRegMouseMove )
			{
				GetImageRoot().GetStage().removeEventListener( MouseEvent.MOUSE_MOVE , _OnMouseMove );
				m_bRootRegMouseMove = false;
			}
			if ( m_bRootRegLButtonUp )
			{
				GetImageRoot().GetStage().removeEventListener( MouseEvent.MOUSE_UP , _OnLButtonUp );
				m_bRootRegLButtonUp = false;
			}
			m_pCapture = null;
			var pRoot:dUIImageRoot = GetImageRoot();
			var p:dUIImage = pRoot.GetObjByPos( pRoot.GetMouseX() , pRoot.GetMouseY() );
			if ( p ) p._OnLButtonDown( m_pLButtonDownEvent );
			m_bContinueLButtonDown = false;*/
		}
		private function _OnLButtonUp( x:int , y:int ):int
		{
			OnLButtonUp( x , y );
			m_bDragging = false;
			m_bDraged = false;
			return 0;
		}
		private function _OnRButtonUp( x:int , y:int ):int
		{
			m_bRDragging = false;
			m_bRDraged = false;
			OnRButtonUp( x , y );
			return 0;
		}
		public function RegMouseLowEvent( bReg:Boolean ):void
		{
			m_bRegMouseLowEvent = bReg;
		}
		public function isRegMouseLowEvent():Boolean
		{
			return m_bRegMouseLowEvent;
		}
		public function RegBringTopWhenClickWindow( bReg:Boolean ):void
		{
			m_bRegBringTopWhenClickWindow = bReg;
		}
		public function isRegBringTopWhenClickWindow():Boolean
		{
			return m_bRegBringTopWhenClickWindow;
		}
		public function RegAutoPosPanel( bReg:Boolean ):void
		{
			m_bRegAutoPosPanel = bReg;
		}
		public function isRegAutoPosPanel():Boolean
		{
			return m_bRegAutoPosPanel;
		}
		public function RegMouseMoveEvent( bReg:Boolean ):void
		{
			m_bRegMouseMoveEvent = bReg;
			dSpriteSetMouseMoveFun( bReg ? _OnMouseMove : null );
		}
		public function isRegMouseMoveEvent():Boolean
		{
			return m_bRegMouseMoveEvent;
		}
		public function OnMouseIn( x:int , y:int ):void
		{
			if ( m_bRegMouseLowEvent )
				FireEvent( dUISystem.GUIEVENT_TYPE_MOUSE_IN );
		}
		public function OnMouseOut( x:int , y:int ):void
		{
			if ( m_bRegMouseLowEvent )
				FireEvent( dUISystem.GUIEVENT_TYPE_MOUSE_OUT );
			if ( m_pTooltip )
			{
				if ( s_pCurrentTooltip == this )
				{
					FireEvent( dUISystem.GUIEVENT_TYPE_ON_SHOW_TOOLTIP , 0 , 0 , "hide" , m_pTooltip );
					s_pCurrentTooltip = null;
				}
			}
		}
		protected var m_bLButtonDowned:Boolean;
		public function OnLButtonDown( x:int , y:int ):void
		{
			m_bLButtonDowned = true;
			//if( m_bRegMouseLowEvent )
				FireEvent( dUISystem.GUIEVENT_TYPE_LBUTTON_DOWN , x , y );
		}
		public function OnLButtonDblClick( x:int , y:int ):void
		{
			//if ( m_bRegMouseLowEvent )
				FireEvent( dUISystem.GUIEVENT_TYPE_LBUTTON_DBL_CLICK , x , y );
		}
		public function OnLButtonUp( x:int , y:int ):void
		{
			//if ( m_bRegMouseLowEvent )
			{
				FireEvent( dUISystem.GUIEVENT_TYPE_LBUTTON_UP , x , y );
				if ( !m_bDraged && m_bLButtonDowned )
					FireEvent( dUISystem.GUIEVENT_TYPE_LBUTTON_CLICK , x , y );
				m_bLButtonDowned = false;
			}
		}
		public function OnRButtonDown( x:int , y:int ):void
		{
			//if ( m_bRegMouseLowEvent )
				FireEvent( dUISystem.GUIEVENT_TYPE_RBUTTON_DOWN , x , y );
		}
		public function OnRButtonUp( x:int , y:int ):void
		{
			//if ( m_bRegMouseLowEvent )
			{
				FireEvent( dUISystem.GUIEVENT_TYPE_RBUTTON_UP , x , y );
				if ( !m_bRDraged )
					FireEvent( dUISystem.GUIEVENT_TYPE_RBUTTON_CLICK , x , y );
			}
		}
		public function OnMouseWheel( v:int ):void
		{
			if ( m_bRegMouseLowEvent )
				FireEvent( dUISystem.GUIEVENT_TYPE_MOUSE_WHEEL , v );
		}
		public function OnLButtonDrag( x:int , y:int ):void
		{
			if ( m_bRegMouseLowEvent )
				FireEvent( dUISystem.GUIEVENT_TYPE_LBUTTON_DRAG , x , y );
		}
		public function OnRButtonDrag( x:int , y:int ):void
		{
			if ( m_bRegMouseLowEvent )
				FireEvent( dUISystem.GUIEVENT_TYPE_RBUTTON_DRAG , x , y );
		}
		public function OnLoadImageComplate( strImageFileName:String , arr:Array ):void
		{
			if ( !m_bRelease && strImageFileName == m_strImageSetName )
			{
				m_bLoading = false;
				m_img = arr[0];
				if ( m_nAlpha != 255 )
					SetAlpha( m_nAlpha , false );
				if ( m_bGray ) SetGray( m_bGray );
				if ( m_bHightLight ) SetHightLight( m_bHightLight );
				if ( m_pColorTransform ) SetColorTransform( m_pColorTransform );
				dSpriteSetBitmapData( arr[0] );
				if ( GetRotation() || isRotationMirrorX() || isRotationMirrorY() )
				{
					var nRotation:int = m_nRotation;
					var bRotationMirrorX:Boolean = m_bRotationMirrorX;
					var bRotationMirrorY:Boolean = m_bRotationMirrorY;
					m_nRotation = 0;
					m_bRotationMirrorX = m_bRotationMirrorY = false;
					SetRotation( nRotation , bRotationMirrorX , bRotationMirrorY );
				}
			}
		}
		public function SetGray( bGray:Boolean ):void
		{
			if ( m_bGray != bGray )
			{
				m_bGray = bGray;
				/*if ( bGray )
				{
					var matrix:Array = [0.3086, 0.6094, 0.0820, 0, 0,
								0.3086, 0.6094, 0.0820, 0, 0,
								0.3086, 0.6094, 0.0820, 0, 0,
								0     , 0     , 0     , 1, 0];
					m_img.filters = [ new ColorMatrixFilter( matrix ) ];
				}
				else m_img.filters = null;*/
				if ( m_bGray )
				{
					SetHightLight(false);
					SetColorTransform( new dUIColorTransform( 0 , 0 , -100 , 0 ) );
				}
				else
					SetColorTransform( null );
			}
		}
		public function isGray():Boolean
		{
			return m_bGray;
		}
		public function SetHightLight( bGray:Boolean ):void
		{
			if ( m_bHightLight != bGray )
			{
				m_bHightLight = bGray;
				/*if ( bGray )
				{
					var matrix:Array = [0.3086, 0.6094, 0.0820, 0, 0,
								0.3086, 0.6094, 0.0820, 0, 0,
								0.3086, 0.6094, 0.0820, 0, 0,
								0     , 0     , 0     , 1, 0];
					m_img.filters = [ new ColorMatrixFilter( matrix ) ];
				}
				else m_img.filters = null;*/
				if ( m_bHightLight )
				{
					SetGray( false );
					SetColorTransform( new dUIColorTransform( 70 , 0 , 0 , 0 ) );
				}
				else
					SetColorTransform( null );
			}
		}
		public function isHightLight():Boolean
		{
			return m_bHightLight;
		}
		/// 设置控件颜色变换( 亮度-100至100 , 对比度-100至100 , 饱和度-100至100 , 色相-180至180 )
		public function SetColorTransform( pColorTransform:dUIColorTransform ):void
		{
			m_pColorTransform = pColorTransform;
			if ( m_pColorTransform )
				dSpriteSetColorTransform( pColorTransform.nColorBrightness , pColorTransform.nColorContrast , pColorTransform.nColorSaturation , m_pColorTransform.nColorHue );
			else
				dSpriteSetColorTransform( 0 , 0 , 0 , 0 );
		}
		public function GetColorTransform():dUIColorTransform
		{
			return m_pColorTransform;
		}
		protected var m_nMouseStyle:int = 0;
		public function SetMouseStyle( nType:int ):void
		{
			if ( m_nMouseStyle != nType )
			{
				m_nMouseStyle = nType;
				dSpriteSetMouseStyle( nType );
			}
		}
		public function GetMouseStyle():int
		{
			return m_nMouseStyle;
		}
		protected function DYM_GUI_MIN( a:int , b:int ):int
		{
			return a < b?a:b;
		}
		protected function DYM_GUI_MAX( a:int , b:int ):int
		{
			return a > b?a:b;
		}
		public function SetID( id:int ):void
		{
			m_nID = id;
		}
		public function GetID():int
		{
			return m_nID;
		}
		public function SetAlignType( nType:int , nIndex:int = 0 ):void
		{
			m_nAlign = nType;
		}
		public function GetAlignType( nIndex:int = 0 ):int
		{
			return m_nAlign;
		}
		public function SetEdgeRect( left:int , top:int , right:int , bottom:int ):void
		{
			m_nEdgeLeft = left;
			m_nEdgeTop = top;
			m_nEdgeRight = right;
			m_nEdgeBottom = bottom;
		}
		public function GetEdgeWidth():int
		{
			return m_nEdgeRight + m_nEdgeLeft;
		}
		public function GetEdgeHeight():int
		{
			return m_nEdgeBottom + m_nEdgeTop;
		}
		public function GetEdgeLeft():int
		{
			return m_nEdgeLeft;
		}
		public function GetEdgeTop():int
		{
			return m_nEdgeTop;
		}
		public function SetFocus( bSet:Boolean ):void
		{
		}
		public function SetUIEventFunction( fun:Function ):void
		{
			m_funUIEvent = fun;
		}
		public function GetUIEventFunction():Function
		{
			return m_funUIEvent;
		}
		public function _GetID():int
		{
			if ( GetID() ) return GetID();
			var p:dUIImage = m_pFather;
			while ( p )
			{
				if ( p.GetID() ) return p.GetID();
				p = p.GetFather();
			}
			return 0;
		}
		public function GetUsingResourceName( ret:Array ):void
		{
			if ( m_img )
			{
				if ( !ret[ m_img.m_strBitmapFileName ] )
					 ret[ m_img.m_strBitmapFileName ] = 0;
				ret[ m_img.m_strBitmapFileName ]++;
			}
		}
		public function FireEvent( type:int , nParam1:int = 0 , nParam2:int = 0 , sParam:String = "" , oParam:Object = null ):void
		{
			if ( m_nObjType != dUISystem.GUIOBJ_TYPE_UIROOT )
			{
				var imageRoot:dUIImageRoot = GetImageRoot();
				var id:int = _GetID();
				if ( m_funUIEvent != null /*&& type != dUISystem.GUIEVENT_TYPE_ON_SHOW_TOOLTIP*/ )
					m_funUIEvent( new dUIEvent( id , type , nParam1 , nParam2 , sParam , this , oParam ) );
				else
				{
					if( imageRoot && id != imageRoot.GetID() )
						imageRoot.FireUIEvent( id , type , nParam1 , nParam2 , sParam , oParam );
				}
			}
		}
	}

}