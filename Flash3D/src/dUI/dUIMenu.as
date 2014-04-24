//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIMenu extends dUIImage
	{
		protected var m_pBk:dUIImage;
		protected var m_vecButton:Vector.<dUIButton> = new Vector.<dUIButton>;
		protected var m_vecMenuText:Vector.<String> = new Vector.<String>;
		protected var m_pView:dUIImage;
		protected var m_pComboListBoxBoard:dUIImage;
		protected var m_pComboListBox:dUIMenuComboBox;
		protected var m_nMaxButtonHeight:int;
		public function dUIMenu( pFather:dUIImage )
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_MENU;
			m_pBk = new dUITileImageT9( this );
			m_pBk.LoadFromImageSet( "列表框1,列表框2,列表框3,列表框4,列表框5,列表框6,列表框7,列表框8,列表框9" );
			m_pView = new dUIImage( this , true );
			m_pComboListBoxBoard = new dUIImageBox( this );
			m_pComboListBoxBoard.SetHandleMouse( true );
			m_pComboListBoxBoard.RegMouseLowEvent( true );
			m_pComboListBoxBoard.SetUIEventFunction( _OnComboListBoxBoardButtonDown );
			m_pComboListBoxBoard.SetShow( false );
			m_pView.RegBringTopWhenClickWindow( true );
			// 设置默认
			SetAutoSizeAsFather( true );
			m_pView.RegAutoPosPanel( true );
			SetSize( pFather.GetClient().GetWidth() , pFather.GetClient().GetHeight() );
		}
		private function _GetButtonIndex( pButton:dUIImage ):int
		{
			for ( var i:int = 0 ; i < m_vecButton.length ; i ++ )
			{
				if ( m_vecButton[i] == pButton ) 
					return i;
			}
			return -1;
		}
		private function _OnButtonEvent( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_BUTTON_DOWN || event.type == dUISystem.GUIEVENT_TYPE_MOUSE_IN &&
				m_pComboListBoxBoard.isShow() )
			{
				m_pComboListBoxBoard.SetShow( true );
				if ( m_pComboListBox ) m_pComboListBox.Release();
				m_pComboListBox = new dUIMenuComboBox( m_pComboListBoxBoard.GetClient() );
				m_pComboListBox.SetUIEventFunction( _OnComboListBoxSelected );
				m_pComboListBox.AddString( m_vecMenuText[ _GetButtonIndex( event.pObj ) ] );
				m_pComboListBox.SetShow( true );
				m_pComboListBox.SetPos( event.pObj.GetPosX() , event.pObj.GetPosY() );
				//dUIImage.m_pGlobalLButtonDownFunction = _OnComboListBoxBoardButtonDown;
			}
		}
		private function _OnComboListBoxBoardButtonDown( event:dUIEvent ):void
		{
			if ( !event || event.type == dUISystem.GUIEVENT_TYPE_LBUTTON_DOWN )
			{
				m_pComboListBoxBoard.SetShow( false );
				if( m_pComboListBox )m_pComboListBox.Release();
				m_pComboListBox = null;
				event.pObj.ContinueLButtonDown();
			}
		}
		private function _OnComboListBoxSelected( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_RIGHT_CLICK_WINDOW_SELECTED )
			{
				m_pComboListBoxBoard.SetShow( false );
				if( m_pComboListBox )m_pComboListBox.Release();
				m_pComboListBox = null;
				FireEvent( dUISystem.GUIEVENT_TYPE_MENU_SELECT , event.nParam1 , event.nParam2 , event.sParam , event.oParam );
			}
		}
		private function FindButton( strName:String ):int
		{
			for ( var i:int = 0 ; i < m_vecButton.length ; i ++ )
				if ( m_vecButton[i].GetText() == strName )
					return i;
			return -1;
		}
		protected function Update():void
		{
			m_nMaxButtonHeight = 0;
			var x:int = 0;
			for ( var i:int = 0 ; i < m_vecButton.length ; i ++ )
			{
				m_vecButton[i].SetPos( x , 0 );
				if ( m_nMaxButtonHeight < m_vecButton[i].GetHeight() )
					m_nMaxButtonHeight = m_vecButton[i].GetHeight();
				x += m_vecButton[i].GetWidth();
			}
			SetSize( GetWidth() , GetHeight() );
		}
		override public function SetSize( w:int , h:int ):void
		{
			super.SetSize( w , h );
			m_pBk.SetSize( w , m_nMaxButtonHeight );
			m_pView.SetSize( w , h - m_nMaxButtonHeight );
			m_pView.SetPos( 0 , m_nMaxButtonHeight );
			m_pComboListBoxBoard.SetSize( m_pView.GetWidth() , m_pView.GetHeight() );
			m_pComboListBoxBoard.SetPos( m_pView.GetPosX() , m_pView.GetPosY() );
		}
		public function AddMenu( strText:String ):void
		{
			var vec:Vector.<String> = SplitString( strText , -1 , "," );
			if ( vec.length > 2 )
			{
				for ( var i:int = 2 ; i < vec.length ; i ++ )
					vec[1] += "," + vec[i];
				vec.length = 2;
			}
			else if ( vec.length == 1 ) vec.push( "" );
			var nButton:int = FindButton( vec[0] );
			if ( nButton != -1 )
			{
				m_vecButton[ nButton ].SetText( vec[0] );
				m_vecMenuText[ nButton ] = vec[1];
			}
			else
			{
				var p:dUIButton = new dUIButton( this );
				p.SetUIEventFunction( _OnButtonEvent );
				p.RegMouseLowEvent( true );
				p.SetStyleData( "AutoSetSize" , true );
				p.SetText( vec[0] );
				m_vecButton.push( p );
				m_vecMenuText.push( vec[1] );
			}
			Update();
		}
		public function ReplaceMenu( strText:String ):void
		{
		}
		public function DelMenu( strText:String ):void
		{
		}
		override public function GetClient():dUIImage
		{
			return m_pView;
		}
	}

}