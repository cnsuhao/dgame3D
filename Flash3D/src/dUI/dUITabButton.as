//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUITabButton extends dUIImage
	{
		protected var m_nTabID:int;
		protected var m_pButton:dUIButtonBase;
		protected var m_nButtonType:int;
		protected var m_nTabWidthAdd:int;
		protected var m_nTabHeightAdd:int;
		public function dUITabButton( pFather:dUIImage )
		{
			super( pFather );
			SetObjType( dUISystem.GUIOBJ_TYPE_TABCONTROL_BUTTON );
			SetHandleMouse( true );
			RegMouseLowEvent( true );
			var pImageSet:dUIImageSet = GetImageRoot().GetImageSet();
			var rc:dUIImageRect = pImageSet.GetImageRect( "选项卡标签宽高偏移" );
			m_nTabWidthAdd = rc.left;
			m_nTabHeightAdd = rc.top;
		}
		public function GetTabID():int
		{
			return m_nTabID;
		}
		public function SetTabID( id:int ):void
		{
			m_nTabID = id;
		}
		override public function SetText( str:String ):void
		{
			m_pButton.SetText( str );
			super.SetSize( m_pButton.GetWidth() , m_pButton.GetHeight() );
		}
		override public function GetText():String
		{
			return m_pButton.GetText();
		}
		override public function SetSize( w:int , h:int ):void
		{
			m_pButton.SetSize( w , h );
			super.SetSize( w , h );
		}
		override public function FlashWindow( nTimes:int , nSpeed:int , nTab:int , nLine:int ):void
		{
			m_pButton.FlashWindow( nTimes , nSpeed , nTab , nLine );
		}
		override public function FlashWindowDisable( nTab:int , nLine:int ):void
		{
			m_pButton.FlashWindowDisable( nTab , nLine );
		}
		public function ButtonLoadFromImageSet( strName:String , bVertical:Boolean , bMirror:Boolean ):void
		{
			var s:Vector.<String> = SplitName( strName , 4 );
			if ( GetImageRoot().GetImageSet().GetImageRect( s[0] + "1" ).Width() )
			{
				if ( bVertical )
				{
					if ( !m_pButton || m_nButtonType != 1 )
					{
						if ( m_pButton ) m_pButton.Release();
						m_pButton = new dUIButtonV3( this );
						m_pButton.SetUIEventFunction( _OnTabButtonDown );
						var ex:int = m_pButton.GetEdgeLeft() + m_nTabWidthAdd;
						var ey:int = m_pButton.GetEdgeTop() + m_nTabHeightAdd;
						m_pButton.SetEdgeRect( ex , ey , ex , ey );
						m_nButtonType = 1;
					}
				}
				else
				{
					if ( !m_pButton || m_nButtonType != 2 )
					{
						if ( m_pButton ) m_pButton.Release();
						m_pButton = new dUIButtonH3( this );
						m_pButton.SetUIEventFunction( _OnTabButtonDown );
						ex = m_pButton.GetEdgeLeft() + m_nTabWidthAdd;
						ey = m_pButton.GetEdgeTop() + m_nTabHeightAdd;
						m_pButton.SetEdgeRect( ex , ey , ex , ey );
						m_nButtonType = 2;
					}
				}
				m_pButton.LoadFromImageSet( s[0] + "1," + s[1] + "1," + s[2] + "1," + s[3] + "1," + s[0] + "2," +
					s[1] + "2," + s[2] + "2," + s[3] + "2," + s[0] + "3," + s[1] + "3," + s[2] + "3," + s[3] + "3" );
			}
			else
			{
				if ( !m_pButton || m_nButtonType != 0 )
				{
					if ( m_pButton ) m_pButton.Release();
					m_pButton = new dUIImageButton( this );
					m_pButton.SetUIEventFunction( _OnTabButtonDown );
					ex = m_pButton.GetEdgeLeft() + m_nTabWidthAdd;
					ey = m_pButton.GetEdgeTop() + m_nTabHeightAdd;
					m_pButton.SetEdgeRect( ex , ey , ex , ey );
				}
				m_nButtonType = 0;
				m_pButton.LoadFromImageSet( strName );
			}
			m_pButton.SetMouseStyle( GetMouseStyle() );
			UpdatePos( bVertical , bMirror );
		}
		public function UpdatePos( bVertical:Boolean , bMirror:Boolean ):void
		{
			/*if ( bVertical )
				m_pButton.SetPos( bMirror? -3:3 , 0 );
			else
				m_pButton.SetPos( 0 , bMirror? -3:3 );*/
		}
		public function SetPushDown( bPush:Boolean ):void
		{
			m_pButton.SetTextAlpha( bPush?255:180 );
			m_pButton.SetPushDown( bPush );
		}
		override public function SetStyleData( str:String , bSet:Boolean ):void
		{
			m_pButton.SetStyleData( str , bSet );
		}
		private function _OnTabButtonDown( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED )
				SetSize( m_pButton.GetWidth() , m_pButton.GetHeight() );
			FireEvent( event.type , event.nParam1 , event.nParam2 , event.sParam , event.pObj );
		}
		override public function SetMouseStyle( nType:int ):void
		{
			super.SetMouseStyle( nType );
			if ( m_pButton ) m_pButton.SetMouseStyle( nType );
		}
		public function SetSizeAsText():void
		{
			m_pButton.SetSizeAsText();
			super.SetSize( m_pButton.GetWidth() , m_pButton.GetHeight() );
		}
	}
}