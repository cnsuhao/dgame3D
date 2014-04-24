//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	import dcom.*;
	/**
	 * ...
	 * @author dym
	 */
	public class dUIImageRoot extends dUIImage
	{
		protected var m_pPage:dUIImage;
		protected var m_pPageTop:dUIImage;
		protected var m_pIcon:dUIDragIcon;
		protected var m_pTooltipBox:dUIEditBox;
		protected var m_pDarkScreen:dUIImage;
		protected var m_pComboListBoxBoard:dUIImage;
		protected var m_vecComboListBox:Vector.<dUIMenuComboBox> = new Vector.<dUIMenuComboBox>;
		protected var m_nLastTime:int;
		protected var m_nTimeSinceLastFrame:int;
		protected var m_LoadImageFunction:Function;
		protected var m_arrImgBuffer:Array = new Array();  //缓存图片实例
		protected var m_uiSystem:dUISystem;
		protected var m_vecIconCoolTime:Vector.<IconCoolTime> = new Vector.<IconCoolTime>;
		protected var m_pShowTooltipFun:Function;
		protected var m_pShowTooltipStart:int;
		protected var m_nCurTickCount:int;
		public var m_bLoadingPage:int;
		public var m_arrIconLoadFileNameList:Array = new Array;
		protected var m_pConfig:dUIConfig = new dUIConfig;
		protected var m_nMouseX:int;
		protected var m_nMouseY:int;
		public function dUIImageRoot( uiSystem:dUISystem , pLoadImageFunction:Function = null )
		{
			if ( pLoadImageFunction != null ) SetCustomLoadImageFunction( pLoadImageFunction );
			super( null );
			m_nObjType = dUISystem.GUIOBJ_TYPE_UIROOT;
			SetID( 0x7FFFFFFF );
			m_uiSystem = uiSystem;
			m_pPage = new dUIImage( this );
			m_pPage.RegBringTopWhenClickWindow( true );
			m_pPage.RegAutoPosPanel( true );
			m_pPage.SetAutoSizeAsFather( true );
			m_pDarkScreen = new dUIImage( this );
			m_pDarkScreen.RegBringTopWhenClickWindow( true );
			m_pDarkScreen.RegAutoPosPanel( true );
			m_pDarkScreen.CreateImage( 1 , 1 , 0x60000000 );
			m_pDarkScreen.SetHandleMouse( true );
			m_pDarkScreen.SetShow( false );
			m_pDarkScreen.SetAutoSizeAsFather( true );
			m_pPageTop = new dUIImage( this );
			m_pPageTop.RegAutoPosPanel( true );
			m_pPageTop.SetAutoSizeAsFather( true );
			m_pIcon = new dUIDragIcon( m_pPageTop );
			m_pIcon.SetHandleMouse( false );
			m_pTooltipBox = new dUIEditBox( m_pPageTop );
			m_pTooltipBox.SetStyleData( "AutoSetSize" , true );
			m_pTooltipBox.SetShow( false );
			m_pComboListBoxBoard = new dUIImageBox( this );
			m_pComboListBoxBoard.SetAutoSizeAsFather( true );
			m_pComboListBoxBoard.RegAutoPosPanel( true );
			m_pComboListBoxBoard.SetHandleMouse( true );
			m_pComboListBoxBoard.SetShow( false );
			m_pComboListBoxBoard.RegMouseLowEvent( true );
			m_pComboListBoxBoard.SetUIEventFunction( _OnComboListBoxBoardButtonDown );
			m_pIcon.SetShow( false );
			m_pIcon.SetStyleData( "CanDrag" , false );
			m_nLastTime = dTimer.GetTickCount();
			var pTimer:dTimer = new dTimer();
			pTimer.Create( 0 , 0 , _OnFrameMove );
			RegMouseMoveEvent( true );
			dSpriteSetFrameEventFun( OnFrameEvent );
		}
		public function isLoadingPage():Boolean
		{
			return m_bLoadingPage > 0;
		}
		public function _ReleaseComboBox( pComboBox:dUIMenuComboBox = null ):void
		{
			if ( pComboBox == null )
			{
				for ( var i:int = 0 ; i < m_vecComboListBox.length ; i ++ )
				{
					m_vecComboListBox[i].FireEvent( dUISystem.GUIEVENT_TYPE_RIGHT_CLICK_WINDOW_SELECTED , -1 );
				}
				for ( i = 0 ; i < m_vecComboListBox.length ; i ++ )
				{
					m_vecComboListBox[i].Release();
				}
				m_vecComboListBox.length = 0;
			}
			else
			{
				for ( i = 0 ; i < m_vecComboListBox.length ; i ++ )
				{
					if ( m_vecComboListBox[i] == pComboBox )
					{
						m_vecComboListBox[i].FireEvent( dUISystem.GUIEVENT_TYPE_RIGHT_CLICK_WINDOW_SELECTED , -1 );
						break;
					}
				}
			}
			CheckComboListBoxBoard();
		}
		private function _OnComboListBoxBoardButtonDown( event:dUIEvent ):void
		{
			if ( !event || event.type == dUISystem.GUIEVENT_TYPE_LBUTTON_DOWN ||
				 event.type == dUISystem.GUIEVENT_TYPE_RBUTTON_DOWN )
			{
				_ReleaseComboBox();
				if( event.type == dUISystem.GUIEVENT_TYPE_LBUTTON_DOWN )
					event.pObj.ContinueLButtonDown();
			}
		}
		private function _OnComboListBoxSelected( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_RIGHT_CLICK_WINDOW_SELECTED )
			{
				event.pObj.SetUIEventFunction( (event.pObj as dUIMenuComboBox).m_pDefaultUIEventCallback );
				event.pObj.FireEvent( dUISystem.GUIEVENT_TYPE_RIGHT_CLICK_WINDOW_SELECTED , event.nParam1 , event.nParam2 , event.sParam );
				event.pObj.Release();
				CheckComboListBoxBoard();
			}
		}
		public var _DeleteWindow:Function;
		public function DeleteWindow( pObj:dUIImage ):void
		{
			for ( var i:int = 0 ; i < m_vecRegEnterFrameLoop.length ; i ++ )
			{
				if ( m_vecRegEnterFrameLoop[i].pObj == pObj )
				{
					m_vecRegEnterFrameLoop.splice( i , 1 );
					i--;
				}
			}
			_DeleteWindow( pObj );
		}
		public function GetImageSet():dUIImageSet
		{
			return m_uiSystem.GetImageSet();
		}
		public function CreateRightMenu( pMenu:dUIMenuComboBox ):int
		{
			m_vecComboListBox.push( pMenu );
			pMenu.m_pDefaultUIEventCallback = pMenu.GetUIEventFunction();
			pMenu.SetUIEventFunction( _OnComboListBoxSelected );
			CheckComboListBoxBoard();
			return pMenu.GetID();
		}
		public function DeleteRightMenu( pMenu:dUIMenuComboBox ):void
		{
			for ( var i:int = 0 , n:int = m_vecComboListBox.length ; i < n ; i ++ )
			{
				if ( m_vecComboListBox[i] == pMenu )
				{
					m_vecComboListBox.splice( i , 1 );
					break;
				}
			}
		}
		public function CheckComboListBoxBoard():void
		{
			var bHaveChild:Boolean = false;
			var vecChild:Vector.<dUIImage> = m_pComboListBoxBoard.GetChild();
			for ( var i:int = 0 , n:int = vecChild.length ; i < n ; i ++ )
			{
				if( vecChild[i].isShow() && !vecChild[i].isRelease() )
				{
					bHaveChild = true;
					break;
				}
			}
			m_pComboListBoxBoard.SetShow( bHaveChild );
		}
		public function GetComboListBoxBoard():dUIImage
		{
			return m_pComboListBoxBoard;
		}
		public function GetGlobalDragIcon():dUIDragIcon
		{
			return m_pIcon;
		}
		public function GetTimeSinceLastFrame():int
		{
			return m_nTimeSinceLastFrame;
		}
		private var m_vecRegEnterFrame:Vector.<Function> = new Vector.<Function>;
		private var m_vecRegExitFrame:Vector.<Function> = new Vector.<Function>;
		private var m_vecRegEnterFrameQueue:Vector.<Function> = new Vector.<Function>;
		private var m_vecRegEnterFrameLoop:Array = new Array();
		public function _RegEnterFrame( fun:Function ):void
		{
			for ( var i:int = 0 , n:int = m_vecRegEnterFrame.length ; i < n ; i ++ )
			{
				if ( m_vecRegEnterFrame[i] == fun )
				{
					m_vecRegEnterFrame.splice( i , 1 );
					break;
				}
			}
			m_vecRegEnterFrame.push( fun );
		}
		public function _RegExitFrame( fun:Function ):void
		{
			for ( var i:int = 0 , n:int = m_vecRegExitFrame.length ; i < n ; i ++ )
			{
				if ( m_vecRegExitFrame[i] == fun )
				{
					m_vecRegExitFrame.splice( i , 1 );
					break;
				}
			}
			m_vecRegExitFrame.push( fun );
		}
		public function _RegEnterFrameLoop( fun:Function , pObj:dUIImage ):void
		{
			_UnregEnterFrameLoop( fun );
			m_vecRegEnterFrameLoop.push( new FrameMoveObj( pObj , fun ) );
		}
		public function _UnregEnterFrameLoop( fun:Function ):void
		{
			for ( var i:int = 0 , n:int = m_vecRegEnterFrameLoop.length ; i < n ; i ++ )
			{
				if ( m_vecRegEnterFrameLoop[i].fun == fun )
				{
					m_vecRegEnterFrameLoop.splice( i , 1 );
					break;
				}
			}
		}
		public function _RegEnterFrameQueue( fun:Function ):void
		{
			m_vecRegEnterFrameQueue.push( fun );
		}
		private function OnFrameEvent( type:int , param1:int , param2:int , pParam:Object ):int
		{
			if ( type == dSprite.FRAME_MOUSE_WHEEL )
			{
				OnMouseWheel( param1 );
			}
			return 0;
		}
		private function _OnFrameMove( pTimer:dTimer , nRepeat:int ):void
		{
			m_nCurTickCount = timeGetTime();
			var startTime:int = m_nCurTickCount;
			for ( var i:int = 0 ; i < m_vecRegEnterFrame.length ; i ++ )
			{
				m_vecRegEnterFrame[i]();
				if ( timeGetTime() > startTime + 30 )
				{
					i++;
					break;
				}
			}
			m_vecRegEnterFrame.splice( 0 , i );
			if ( m_vecRegEnterFrameQueue.length )
			{
				m_vecRegEnterFrameQueue[0]();
				m_vecRegEnterFrameQueue.splice( 0 , 1 );
			}
			if ( m_vecRegEnterFrameLoop.length )
			{
				for ( i = 0 ; i < m_vecRegEnterFrameLoop.length ; i ++ )
					m_vecRegEnterFrameLoop[i].fun();
			}
			var curTime:int = dTimer.GetTickCount();
			m_nTimeSinceLastFrame = curTime - m_nLastTime;
			m_nLastTime = curTime;
			//var p:dUIImage = GetObjByPos( mouseX , mouseY );
			//if ( p ) trace( p.GetID() );
			for ( i = 0 ; i < m_vecFading.length ; i ++ )
			{
				if ( m_vecFading[i].bHasBeenIn && m_vecFading[i].image.GetAlpha() < 255 )
					m_vecFading[i].image.SetAlpha( m_vecFading[i].image.GetAlpha() + GetTimeSinceLastFrame() / 2 , false );
				else if ( !m_vecFading[i].bHasBeenIn && m_vecFading[i].image.GetAlpha() > 0 )
					m_vecFading[i].image.SetAlpha( m_vecFading[i].image.GetAlpha() - GetTimeSinceLastFrame() / 2 , false );
			}
			for ( i = 0 ; i < m_vecIconCoolTime.length ; i ++ )
			{
				m_vecIconCoolTime[i].time -= m_nTimeSinceLastFrame;
				if ( m_vecIconCoolTime[i].time <= 0 )
				{
					m_vecIconCoolTime.splice( i , 1 );
					i--;
				}
			}
			if ( m_pShowTooltipFun != null )
			{
				m_pShowTooltipStart ++;
				if ( m_pShowTooltipStart > 5 )
				{
					m_pShowTooltipFun();
					m_pShowTooltipFun = null;
				}
			}
			_OnExitFrame();
			m_uiSystem._OnFrameMove();
		}
		private function _OnExitFrame():void
		{
			m_nCurTickCount = timeGetTime();
			var startTime:int = m_nCurTickCount;
			for ( var i:int = 0 ; i < m_vecRegExitFrame.length ; i ++ )
			{
				m_vecRegExitFrame[i]();
				if ( timeGetTime() > startTime + 30 )
				{
					i++;
					break;
				}
			}
			m_vecRegExitFrame.splice( 0 , i );
		}
		public function _OnRootMouseWheel2( value:int , x:int , y:int ):void
		{
			var p:dUIImage = _GetObjByPos( x , y , 0 , 0 , 0 , 0 , GetWidth() , GetHeight() , this , 3 );
			if ( p ) p._OnMouseWheel( value );
		}
		override public function OnMouseWheel( value:int ):void
		{
			super.OnMouseWheel( value );
			_OnRootMouseWheel2( value , GetMouseX() , GetMouseY() );
		}
		static public function timeGetTime():int
		{
			return dTimer.GetTickCount();
		}
		public function GetTickCount():int
		{
			return m_nCurTickCount;
		}
		private function _GetObjByPos( x:int , y:int , objx:int , objy:int , clip_left:int , clip_top:int , clip_right:int , clip_bottom:int , pObj:dUIImage , type:int , pTest:dUIImage = null ):dUIImage
		{
			if ( clip_left >= clip_right || clip_top >= clip_bottom ) return null;
			var vecChild:Vector.<dUIImage> = pObj.GetChild();
			for ( var i:int = vecChild.length - 1 ; i >= 0 ; i -- )
			{
				var img:dUIImage = vecChild[i];
				if ( img.isShow() )
				{
					var ox:int = img.GetPosX() + objx;
					var oy:int = img.GetPosY() + objy;
					var clip_left2:int = ox;
					var clip_top2:int = oy;
					var clip_right2:int = img.GetWidth() + clip_left2;
					var clip_bottom2:int = img.GetHeight() + clip_top2;
					if ( clip_left2 < clip_left ) clip_left2 = clip_left;
					if ( clip_top2 < clip_top ) clip_top2 = clip_top;
					if ( clip_right2 > clip_right ) clip_right2 = clip_right;
					if ( clip_bottom2 > clip_bottom ) clip_bottom2 = clip_bottom;
					var ret:dUIImage = _GetObjByPos( x , y , ox , oy , clip_left2 , clip_top2 , clip_right2 , clip_bottom2 , img , type , pTest );
					if ( ret ) return ret;
				}
			}
			if ( x >= clip_left && x < clip_right && y >= clip_top && y < clip_bottom )
			{
				if ( type == 0 )// mouse pass
				{
					if ( pObj.GetID() )
						return pObj;
				}
				else if ( type == 1 )// icon drag
				{
					if ( pObj.isHandleMouse() )
						return pObj;
				}
				else if ( type == 2 )
				{
					return pObj;
				}
				else if ( type == 3 )// mouse wheel
				{
					if ( (pObj.GetObjType() == dUISystem.GUIOBJ_TYPE_SCROLL && (pObj as dUIScroll).isStyleData( "ShowVScroll" )) || pObj.isHandleMouseWheel() )
						return pObj;
				}
				else if ( type == 4 )// is obj mouse in
				{
					if ( pObj == pTest )
						return pObj;
				}
			}
			return null;
		}
		public function GetObjByPos( x:int , y:int , type:int = 0 ):dUIImage
		{
			var p:dUIImage = _GetObjByPos( x , y , 0 , 0 , 0 , 0 , GetWidth() , GetHeight() , m_pPage , type );
			//while ( p && p.GetID() <= 0 )
			//	p = p.GetFather();
			return p;
		}
		public function isObjMouseIn( pTest:dUIImage ):Boolean
		{
			return _GetObjByPos( GetMouseX() , GetMouseY() , 0 , 0 , 0 , 0 , GetWidth() , GetHeight() , this , 4 , pTest ) != null;
		}
		public function GetTopWindow():dUIImage
		{
			return m_pDarkScreen;
		}
		public function CheckTopWindow():void
		{
			_RegEnterFrame( function():void
			{
				var bHaveChild:Boolean = false;
				var vecChild:Vector.<dUIImage> = m_pDarkScreen.GetChild();
				for ( var i:int = 0 , n:int = vecChild.length ; i < n ; i ++ )
				{
					if ( vecChild[i].isShow() && !vecChild[i].isRelease() )
					{
						bHaveChild = true;
						break;
					}
				}
				m_pDarkScreen.SetShow( bHaveChild );
			} );
		}
		public function GetObjByCurrentMouse():dUIImage
		{
			return GetObjByPos( GetMouseX() , GetMouseY() );
		}
		override public function SetSize( w:int , h:int ):void
		{
			super.SetSize( w , h );
			m_pPage.SetSize( w , h );
			m_pPageTop.SetSize( w , h );
			m_pDarkScreen.SetSize( w , h );
			m_pComboListBoxBoard.SetSize( w , h );
		}
		override public function GetClient():dUIImage
		{
			return m_pPage;
		}
		public function GetPageTop():dUIImage
		{
			return m_pPageTop;
		}
		public function GetPageDark():dUIImage
		{
			return m_pDarkScreen;
		}
		public function SetCustomLoadImageFunction( pFunction:Function ):void
		{
			m_LoadImageFunction = pFunction;
		}
		public function GetCustomLoadImageFunction():Function
		{
			return m_LoadImageFunction;
		}
		public function GetFocus():dUIImage
		{
			/*if ( stage.focus )
			{
				if ( stage.focus.parent is dUIImage )
					return (stage.focus.parent as dUIImage );
			}*/
			return null;
		}
		public function FireUIEvent( id:int , type:int , nParam1:int , nParam2:int , sParam:String , oParam:Object ):void
		{
			if ( m_funUIEvent != null )
				m_funUIEvent( new dUIEvent( id , type , nParam1 , nParam2 , sParam , null , oParam ) );
		}
		public function ShowDefaultTooltip( x:int , y:int , str:String , bShow:Boolean ):void
		{
			m_pTooltipBox.SetShow( bShow );
			if ( bShow )
			{
				m_pTooltipBox.SetText( str );
				if ( x > GetWidth() - m_pTooltipBox.GetWidth() )
					x = GetWidth() - m_pTooltipBox.GetWidth();
				if ( y > GetHeight() - m_pTooltipBox.GetHeight() )
					y = GetHeight() - m_pTooltipBox.GetHeight();
				m_pTooltipBox.SetPos( x , y );
			}
		}
		protected var m_vecFading:Vector.<FadingRect> = new Vector.<FadingRect>;
		public function UpdateMyFadeInRect( image:dUIImage ):void
		{
			if ( image.isRegMouseFadeIn() )
			{
				for ( var i:int = 0 ; i < m_vecFading.length ; i ++ )
				{
					if ( m_vecFading[i].image == image )
					{
						m_vecFading[i].bHasBeenIn = false;
						break;
					}
				}
				if ( i == m_vecFading.length )
				{
					m_vecFading[i] = new FadingRect();
					m_vecFading[i].image = image;
					m_vecFading[i].bHasBeenIn = false;
					/*m_vecFading[i].rc.left = image.GetPosX_World();
					m_vecFading[i].rc.top = image.GetPosY_World();
					m_vecFading[i].rc.right = m_vecFading[i].rc.left + image.GetWidth();
					m_vecFading[i].rc.bottom = m_vecFading[i].rc.top + image.GetHeight();*/
				}
			}
			else
			{
				for ( i = 0 ; i < m_vecFading.length ; i ++ )
				{
					if ( m_vecFading[i].image == image )
					{
						m_vecFading.splice( i , 1 );
						break;
					}
				}
			}
		}
		override public function OnMouseMove( x:int , y:int ):void
		{
			super.OnMouseMove( x , y );
			m_nMouseX = x;
			m_nMouseY = y;
			for ( var i:int = 0 ; i < m_vecFading.length ; i ++ )
			{
				m_vecFading[i].rc.left = m_vecFading[i].image.GetPosX_World();
				m_vecFading[i].rc.top = m_vecFading[i].image.GetPosY_World();
				m_vecFading[i].rc.right = m_vecFading[i].rc.left + m_vecFading[i].image.GetWidth();
				m_vecFading[i].rc.bottom = m_vecFading[i].rc.top + m_vecFading[i].image.GetHeight();
				m_vecFading[i].bHasBeenIn = false;
				if ( x >= m_vecFading[i].rc.left &&
					 x < m_vecFading[i].rc.right &&
					 y >= m_vecFading[i].rc.top &&
					 y < m_vecFading[i].rc.bottom )
				{
					m_vecFading[i].bHasBeenIn = true;
				}
			}
		}
		/*public function OnMouseLeave( event:Event ):void
		{
			if ( m_pCapture ) m_pCapture._GlobalMouseLeave();
		}*/
		public function SetIconCoolTime( nItemID:int , time:int ):int
		{
			for ( var i:int = 0 ; i < m_vecIconCoolTime.length ; i ++ )
			{
				if ( m_vecIconCoolTime[i].nItemID == nItemID )
				{
					 m_vecIconCoolTime[i].time = time;
					 return 1;
				}
			}
			m_vecIconCoolTime.push( new IconCoolTime( nItemID , time ) );
			return 1;
		}
		public function GetIconCoolTime( nItemID:int ):int
		{
			for ( var i:int = 0 ; i < m_vecIconCoolTime.length ; i ++ )
			{
				if ( m_vecIconCoolTime[i].nItemID == nItemID )
					return m_vecIconCoolTime[i].time;
			}
			return 0;
		}
		public function RequireShowTooltip( pFun:Function ):void
		{
			m_pShowTooltipFun = pFun;
			m_pShowTooltipStart = 0;
		}
		private var m_arrNewObjPool:Array = new Array();
		static private var s_arrInitType:Array;
		private function InitPool():void
		{
			if ( !s_arrInitType )
			{
				s_arrInitType = [ dUISystem.GUIOBJ_TYPE_DRAGICON , dUISystem.GUIOBJ_TYPE_IMAGEBOX ,
					dUISystem.GUIOBJ_TYPE_SUPPERTEXT , dUISystem.GUIOBJ_TYPE_EDITBOX ];
			}
			for ( var i:int = 0 ; i < s_arrInitType.length ; i ++ )
			{
				var nObjType:int = s_arrInitType[i];
				var vecPool:Vector.<dUIImage> = m_arrNewObjPool[nObjType] as Vector.<dUIImage>;
				if ( !vecPool ) m_arrNewObjPool[nObjType] = new Vector.<dUIImage>;
				vecPool = m_arrNewObjPool[nObjType] as Vector.<dUIImage>;
				if ( vecPool.length < 200 )
				{
					var p:dUIImage = NewObj( nObjType , GetClient() , false );
					vecPool.push( p );
					p.SetShow( false );
					break;
				}
			}
		}
		private function _ReleaseObjEvent( event:dUIEvent ):void
		{
		}
		public function ReleaseObj( pObj:dUIImage ):void
		{
			var nObjType:int = pObj.GetObjType();
			var arr:Array = m_arrNewObjPool[ pObj.m_nUsePoolFatherObjType ];
			if ( !arr ) m_arrNewObjPool[ pObj.m_nUsePoolFatherObjType ] = new Array();
			arr = m_arrNewObjPool[ pObj.m_nUsePoolFatherObjType ];
			var vecPool:Vector.<dUIImage> = arr[nObjType] as Vector.<dUIImage>;
			if ( !vecPool ) arr[nObjType] = new Vector.<dUIImage>;
			vecPool = arr[nObjType] as Vector.<dUIImage>;
			vecPool.push( pObj );
			pObj.SetText( "" );
			pObj.SetUIEventFunction( null );
			pObj.SetFather( GetClient() );
			pObj.SetAlignType( 0 );
			pObj.SetAlpha( 255 );
			pObj.SetShow( false );
			pObj.SetGray( false );
			pObj.SetSize( 0 , 0 );
			pObj.SetPos( 0 , 0 );
			pObj.SetUserData( null );
			pObj.ReleaseImg();
			pObj.SetRelease( true );

			if ( pObj.GetAlpha() != 255 ) pObj.SetAlpha( 255 );
		}
		public function NewObj( nObjType:int , pFather:dUIImage , bUsingPool:Boolean = true , nUsingPoolFatherType:int = 0 , bUsingMask:Boolean = false ):dUIImage
		{
			if ( bUsingPool )
			{
				var arr:Array = m_arrNewObjPool[nUsingPoolFatherType] as Array;
				if ( arr )
				{
					var vecPool:Vector.<dUIImage> = arr[nObjType] as Vector.<dUIImage>;
					if ( vecPool && vecPool.length )
					{
						var p:dUIImage = vecPool.pop();
						p.SetFather( pFather );
						p.SetShow( true );
						p.SetRelease( false );
						return p;
					}
				}
			}
			switch( nObjType )
			{
			case dUISystem.GUIOBJ_TYPE_BASEOBJ: p = new dUIImage( pFather , bUsingMask ); break;
			case dUISystem.GUIOBJ_TYPE_WINDOW: p = new dUIWindow( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_BUTTON: p = new dUIButton( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_IMAGEBOX: p = new dUIImageBox( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_EDITBOX: p = new dUIEditBox( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_DRAGICON:p = new dUIDragIcon( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_GROUP: p = new dUIGroup( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_CHECKBOX: p = new dUICheckBox( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_RADIOBOX: p = new dUIRadioBox( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_TREE: p = new dUITree( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_SLIDER: p = new dUISlider( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_SUPPERTEXT: p = new dUISuperText( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_SCROLL: p = new dUIScroll( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_ANIIMAGEBOX: p = new dUIAniImageBox( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_LISTBOX: p = new dUIListBox( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_LISTBOXOBJ: p = new dUIListBoxObj( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_SUPERTEXTLINEOBJ: p = new dUISuperTextUnderLineObj( pFather ); break;
			case dUISystem.GUIOBJ_TYPE_IMAGEBUTTON:
				p = new dUIImageButton( pFather );
				break;
			case dUISystem.GUIOBJ_TYPE_TABCONTROL:
				p = new dUITabControl( pFather );
				break;
			case dUISystem.GUIOBJ_TYPE_PROGRESS:
				p = new dUIProgress( pFather );
				break;
			}
			p.m_bFromPool = bUsingPool;
			p.m_nUsePoolFatherObjType = nUsingPoolFatherType;
			return p;
		}
		public function CheckComboBox( pObj:dUIImage ):void
		{
			if ( pObj.GetObjType() == dUISystem.GUIOBJ_TYPE_EDITBOX )
			{
				if ( ( pObj as dUIEditBox ).isComboBoxShow() )
					( pObj as dUIEditBox ).SetComboBoxShow( false );
			}
			for ( var i:int = 0 , n:int = pObj.GetChild().length ; i < n ; i ++ )
			{
				CheckComboBox( pObj.GetChild()[i] );
			}
			for ( i = 0 ; i < m_vecComboListBox.length ; i ++ )
			{
				if ( m_vecComboListBox[i].m_pAttachFather == pObj )
				{
					_ReleaseComboBox( m_vecComboListBox[i] );
					i--;
				}
			}
		}
		public function SetConfig( pConfig:dUIConfig ):void
		{
			m_pConfig = pConfig;
		}
		public function GetConfig():dUIConfig
		{
			return m_pConfig;
		}
		private function _GetUsingResourceName( p:dUIImage , ret:Array ):void
		{
			p.GetUsingResourceName( ret );
			var list:Vector.<dUIImage> = p.GetChild();
			for ( var i:int = 0 , n:int = list.length ; i < n ; i ++ )
				_GetUsingResourceName( list[i] , ret );
		}
		public function RootGetUsingResourceName():Array
		{
			var ret:Array = new Array();
			_GetUsingResourceName( this , ret );
			return ret;
		}
	}

}
import dUI.dUIImage;
import dUI.dUIImageRect;
class FadingRect
{
	public var image:dUIImage;
	public var rc:dUIImageRect = new dUIImageRect();
	public var bHasBeenIn:Boolean;
}
class IconCoolTime
{
	public var nItemID:int;
	public var time:int;
	public function IconCoolTime( itemID:int , _time:int ):void
	{
		nItemID = itemID;
		time = _time;
	}
}
class FrameMoveObj
{
	public var fun:Function;
	public var pObj:dUIImage;
	public function FrameMoveObj( _pObj:dUIImage , _fun:Function ):void
	{
		fun = _fun;
		pObj = _pObj;
	}
}