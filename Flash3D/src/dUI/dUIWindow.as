//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIWindow extends dUITileImageT9
	{
		protected var m_pCloseButton:dUIImageButton;
		protected var m_pClient:dUIImage;
		protected var m_rcClient:dUIImageRect;
		protected var m_rcCloseButton:dUIImageRect;
		protected var m_pTitle:dUISuperText;
		protected var m_pWaitPannel:dUIWaitPannel;
		
		public function dUIWindow( pFather:dUIImage ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_WINDOW;
			//m_pTitle = new dUISuperText( this );
			//m_pCloseButton = new dUIImageButton( this );
			m_pTitle = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_SUPPERTEXT , this , true , GetObjType() ) as dUISuperText;
			m_pTitle.SetUIEventFunction( _OnTextLoaded );
			m_pCloseButton = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_IMAGEBUTTON , this , true , GetObjType() ) as dUIImageButton;
			LoadFromImageSet( "" );
			m_pCloseButton.SetUIEventFunction( _OnCloseButtonEvent );
			//m_pClient = new dUIImage( this , true );
			m_pClient = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_BASEOBJ , this , true , GetObjType() , true );
			var pImageSet:dUIImageSet = GetImageRoot().GetImageSet();
			m_rcClient = pImageSet.GetImageRect( "窗口内容偏移" );
			m_rcCloseButton = pImageSet.GetImageRect( "窗口标题坐标关闭按钮坐标" );
			SetHandleMouse( true );
			// 设置默认
			SetSize( 400 , 300 );
			super.SetText("未标题窗口");
			m_pTitle.SetText( "未标题窗口" );
			SetStyleData( "ShowCloseButton" , true );
			SetStyleData( "CanDrag" , true );
		}
		override public function Release():void
		{
			m_pClient.ClearChild();
			super.Release();
		}
		private function _OnTextLoaded( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED )
				SetSize( GetWidth() , GetHeight() );
		}
		override public function GetDefaultSkin():String
		{
			return "窗口九宫格1,窗口九宫格2,窗口九宫格3,窗口九宫格4,窗口九宫格5,窗口九宫格6,\
窗口九宫格7,窗口九宫格8,窗口九宫格9,关闭按钮正常,关闭按钮发亮,关闭按钮按下,关闭按钮无效";
		}
		override public function _LoadFromImageSet( str:String ):void
		{
			var vecName:Vector.<String> = SplitName( str , 13 );
			super._LoadFromImageSet( vecName[0] + "," + vecName[1] + "," + vecName[2] + "," + vecName[3] + "," +
				vecName[4] + "," + vecName[5] + "," + vecName[6] + "," + vecName[7] + "," + vecName[8] );
			m_pCloseButton.LoadFromImageSet( vecName[9] + "," + vecName[10] + "," + vecName[11] + "," + vecName[12] );
		}
		override public function SetHandleMouse( bSet:Boolean ):void
		{
			super.SetHandleMouse( bSet );
			m_pCloseButton.SetHandleMouse( bSet );
		}
		protected function _OnCloseButtonEvent( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_BUTTON_UP )
			{
				FireEvent( dUISystem.GUIEVENT_TYPE_LBUTTON_UP );
				FireEvent( dUISystem.GUIEVENT_TYPE_CLOSE_WINDOW );
			}
			else if ( event.type == dUISystem.GUIEVENT_TYPE_BUTTON_UP_OUT )
				FireEvent( dUISystem.GUIEVENT_TYPE_LBUTTON_UP );
			else if ( event.type == dUISystem.GUIEVENT_TYPE_BUTTON_DOWN )
				FireEvent( dUISystem.GUIEVENT_TYPE_LBUTTON_DOWN );
			else if ( event.type == dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED )
				SetSize( GetWidth() , GetHeight() );
		}
		override public function _SetText( strText:String ):void
		{
			super._SetText( strText );
			m_pTitle.SetText( strText );
		}
		override public function GetClient():dUIImage
		{
			return m_pClient;
		}
		override public function SetSize( w:int , h:int ):void
		{
			super.SetSize( w , h );
			m_pClient.SetPos( m_rcClient.left , m_rcClient.top );
			m_pClient.SetSize( w + m_rcClient.right - m_rcClient.left , h + m_rcClient.bottom - m_rcClient.top ); 
			m_pCloseButton.SetPos( GetWidth() - m_pCloseButton.GetWidth() - m_rcCloseButton.right , -m_rcCloseButton.bottom );
			m_pTitle.SetSize( w , m_rcClient.top );
			m_pTitle.SetPos( m_rcCloseButton.left , m_rcCloseButton.top );
			if ( m_pWaitPannel )
			{
				m_pWaitPannel.SetPos( m_pClient.GetPosX() , m_pWaitPannel.GetPosY() );
				m_pWaitPannel.SetSize( m_pClient.GetWidth() , m_pClient.GetHeight() );
			}
		}
		public function SetClientSize( w:int , h:int ):void
		{
			SetSize( w - m_rcClient.right + m_rcClient.left , h - m_rcClient.bottom + m_rcClient.top );
		}
		override public function SetStyleData( name:String , bSet:Boolean ):void
		{
			if ( name == "ShowCloseButton" || name == "CanDrag" )
			{
				if ( isStyleData( name ) == bSet ) return;
				super.SetStyleData( name , bSet );
				if ( name == "ShowCloseButton" )
					m_pCloseButton.SetShow( bSet );
			}
		}
		override public function SetMouseStyle( nType:int ):void
		{
			if ( m_nMouseStyle != nType )
			{
				m_nMouseStyle = nType;
				m_pCloseButton.SetMouseStyle( nType );
			}
		}
		override public function SetShowClient( bShow:Boolean , nTabIndex:int ):void
		{
			super.SetShowClient( bShow , nTabIndex );
			m_pClient.SetShow( bShow );
		}
		override public function SetWait( bWait:Boolean , nTabIndex:int ):void
		{
			super.SetWait( bWait , nTabIndex );
			if ( bWait )
			{
				if ( !m_pWaitPannel ) m_pWaitPannel = new dUIWaitPannel( this );
				m_pWaitPannel.SetPos( m_pClient.GetPosX() , m_pClient.GetPosY() );
				m_pWaitPannel.SetSize( m_pClient.GetWidth() , m_pClient.GetHeight() );
			}
			m_pWaitPannel.SetShow( bWait );
		}
	}

}