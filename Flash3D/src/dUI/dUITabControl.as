//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUITabControl extends dUIImage
	{
		protected var m_vecButton:Vector.<dUITabButton> = new Vector.<dUITabButton>;
		protected var m_vecView:Vector.<dUIImage> = new Vector.<dUIImage>;
		protected var m_vecViewWait:Vector.<dUIWaitPannel> = new Vector.<dUIWaitPannel>;
		protected var m_nCurSel:int;
		protected var m_pBack:dUIImage;
		public function dUITabControl( pFather:dUIImage ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_TABCONTROL;
			m_pBack = new dUITileImageT9( this );
			// 设置默认
			SetTabCount( 3 );
			SetSelectTab( 0 , false );
			_LoadFromImageSet( "" );
		}
		private function _OnTabButtonDown( event:dUIEvent ):void
		{
			if( event.type == dUISystem.GUIEVENT_TYPE_BUTTON_DOWN )
				SetSelectTab( (event.pObj as dUITabButton).GetTabID() , true );
			else if ( event.type == dUISystem.GUIEVENT_TYPE_MOUSE_IN && GetImageRoot().GetGlobalDragIcon().isShow() )
				SetSelectTab( (event.pObj as dUITabButton).GetTabID() , true );
		}
		override public function FlashWindow( nTimes:int , nSpeed:int , nTab:int , nLine:int ):void
		{
			if ( nTab >= 0 && nTab < m_vecButton.length )
				m_vecButton[ nTab ].FlashWindow( nTimes , nSpeed , nTab , nLine );
		}
		override public function FlashWindowDisable( nTab:int , nLine:int ):void
		{
			if ( nTab >= 0 && nTab < m_vecButton.length )
				m_vecButton[ nTab ].FlashWindowDisable( nTab , nLine );
		}
		override public function SetSize( w:int , h:int ):void
		{
			super.SetSize( w , h );
			Update();
		}
		public function SetTabCount( count:int ):void
		{
			var oldCount:int = m_vecButton.length;
			if ( count < m_vecButton.length )
			{
				for ( var i:int = count ; i < m_vecButton.length ; i ++ )
				{
					m_vecButton[i].Release();
					m_vecView[i].Release();
				}
			}
			m_vecButton.length = count;
			m_vecView.length = count;
			m_vecViewWait.length = count;
			Update();
			if ( m_nCurSel >= count )
				SetSelectTab( count - 1 , true );
			else
				SetSelectTab( m_nCurSel , true );
		}
		public function GetTabCount():int
		{
			return m_vecButton.length;
		}
		public function GetTabBoundRect( nIndex:int ):dUIImageRect
		{
			if ( nIndex >= 0 && nIndex < m_vecButton.length )
			{
				return new dUIImageRect( m_vecButton[nIndex].GetPosX() , m_vecButton[nIndex].GetPosY() , 
					m_vecButton[nIndex].GetPosX() + m_vecButton[nIndex].GetWidth() , m_vecButton[nIndex].GetPosY() + m_vecButton[nIndex].GetHeight() );
			}
			return null;
		}
		public function SetTabName( strName:String , nIndex:int ):void
		{
			if ( nIndex >= 0 && nIndex < m_vecButton.length )
			{
				m_vecButton[nIndex].SetText( strName );
				Update();
			}
		}
		public function GetTabName( nIndex:int ):String
		{
			if ( nIndex >= 0 && nIndex < m_vecButton.length )
				return m_vecButton[nIndex].GetText();
			return "";
		}
		public function GetTabButton( nIndex:int ):dUIImage
		{
			if ( nIndex >= 0 && nIndex < m_vecButton.length )
				return m_vecButton[nIndex];
			return null;
		}
		public function SetSelectTab( nSel:int , bFireEvent:Boolean ):void
		{
			if ( nSel >= 0 && nSel < m_vecButton.length )
			{
				for ( var i:int = 0 ; i < m_vecButton.length ; i ++ )
				{
					m_vecButton[ i ].SetPushDown( i == nSel );
					m_vecView[ i ].SetShow( i == nSel && m_vecView[i].isShowClient(0) );
					if ( m_vecViewWait[i] )
						m_vecViewWait[ i ].SetShow( i == nSel && m_vecViewWait[i].isShowClient( 0 ) );
					m_vecView[ i ].MoveTop();
					if ( m_vecViewWait[i] ) m_vecViewWait[ i ].MoveTop();
				}
				m_pBack.MoveTop();
				m_vecButton[ nSel ].MoveTop();
				var bFire:Boolean = m_nCurSel != nSel;
				var nOld:int = m_nCurSel;
				if ( bFire && bFireEvent )
					FireEvent( dUISystem.GUIEVENT_TYPE_TAB_SELECTED , nSel , 0 , m_vecButton[nSel].GetText() );
				m_nCurSel = nSel;
				if( bFire && bFireEvent )
					FireEvent( dUISystem.GUIEVENT_TYPE_TAB_SELECTED_SHOW_VIEW , nSel , nOld , m_vecButton[nSel].GetText() );
			}
		}
		public function GetSelectTab():int
		{
			return m_nCurSel;
		}
		public function SetShowTab( nTabIndex:int , bShow:Boolean ):void
		{
			if ( nTabIndex >= 0 && nTabIndex < m_vecButton.length )
			{
				m_vecButton[nTabIndex].SetShow( bShow );
				Update();
			}
		}
		public function GetShowTab( nTabIndex:int ):Boolean
		{
			if ( nTabIndex >= 0 && nTabIndex < m_vecButton.length )
				return m_vecButton[nTabIndex].isShow();
			return false;
		}
		public function EnableTab( nTabIndex:int , bEnable:Boolean ):void
		{
			if ( nTabIndex >= 0 && nTabIndex < m_vecButton.length )
			{
				m_vecButton[nTabIndex].EnableWindow( bEnable );
			}
		}
		public function isTabEnable( nTabIndex:int ):Boolean
		{
			if ( nTabIndex >= 0 && nTabIndex < m_vecButton.length )
				return m_vecButton[nTabIndex].isWindowEnable();
			return false;
		}
		public function GetView( nIndex:int ):dUIImage
		{
			if ( nIndex >= 0 && nIndex < m_vecView.length )
				return m_vecView[ nIndex ];
			return null;
		}
		override public function GetDefaultSkin():String
		{
			return "选项卡按钮横正常,选项卡按钮横发亮,选项卡按钮横按下,选项卡按钮横无效,\
				选项卡按钮正常,选项卡按钮发亮,选项卡按钮按下,选项卡按钮无效,\
				选项卡框1,选项卡框2,选项卡框3,选项卡框4,选项卡框5,选项卡框6,选项卡框7,选项卡框8,选项卡框9";
		}
		protected var m_strSkinName:String = "";
		override public function _LoadFromImageSet( str:String ):void
		{
			m_strSkinName = str;
			UpdateSkin();
			Update();
		}
		protected function UpdateSkin():void
		{
			if ( m_strSkinName == "" ) m_strSkinName = GetDefaultSkin();
			var vecSkin:Vector.<String> = SplitName( m_strSkinName , 17 );
			for ( var i:int = 0 ; i < m_vecButton.length ; i ++ )
			{
				if ( isStyleData( "Vertical" ) )
				{
					m_vecButton[i].ButtonLoadFromImageSet( vecSkin[4] + "," + vecSkin[5] + "," + vecSkin[6] + "," + vecSkin[7] , isStyleData( "Vertical" ) , isStyleData( "MirrorButton" ) );
				}
				else
				{
					m_vecButton[i].ButtonLoadFromImageSet( vecSkin[0] + "," + vecSkin[1] + "," + vecSkin[2] + "," + vecSkin[3] , isStyleData( "Vertical" ) , isStyleData( "MirrorButton" ) );
				}
				m_vecButton[i].SetStyleData( "AutoSetSize" , true );
				m_vecButton[i].SetStyleData( "AlwaysPushDown" , true );
				m_vecButton[i].SetTabID( i );
				m_vecButton[i].SetUIEventFunction( _OnTabButtonDown );
				//m_vecView[i].LoadFromImageSet( vecSkin[8] + "," + vecSkin[9] + "," + vecSkin[10] + "," + vecSkin[11] + "," +
				//	vecSkin[12] + "," + vecSkin[13] + "," + vecSkin[14] + "," + vecSkin[15] + "," + vecSkin[16] );
			}
			m_pBack.LoadFromImageSet( vecSkin[8] + "," + vecSkin[9] + "," + vecSkin[10] + "," + vecSkin[11] + "," +
				vecSkin[12] + "," + vecSkin[13] + "," + vecSkin[14] + "," + vecSkin[15] + "," + vecSkin[16] );
		}
		protected function Update():void
		{
			var strImageSetName:String = m_strSkinName;
			if ( !strImageSetName || strImageSetName == "" ) strImageSetName = GetDefaultSkin();
			var vecSkin:Vector.<String> = SplitName( strImageSetName , 17 );
			for ( var i:int = 0 ; i < m_vecButton.length ; i ++ )
			{
				if ( m_vecButton[i] == null )
				{
					m_vecButton[i] = new dUITabButton( this );
					m_vecButton[i].SetMouseStyle( GetMouseStyle() );
					if ( isStyleData( "Vertical" ) )
					{
						m_vecButton[i].ButtonLoadFromImageSet( vecSkin[4] + "," + vecSkin[5] + "," + vecSkin[6] + "," + vecSkin[7] , isStyleData( "Vertical" ) , isStyleData( "MirrorButton" ) );
					}
					else
					{
						m_vecButton[i].ButtonLoadFromImageSet( vecSkin[0] + "," + vecSkin[1] + "," + vecSkin[2] + "," + vecSkin[3] , isStyleData( "Vertical" ) , isStyleData( "MirrorButton" ) );
					}
					m_vecButton[i].SetStyleData( "AutoSetSize" , true );
					m_vecButton[i].SetStyleData( "AlwaysPushDown" , true );
					m_vecButton[i].SetTabID( i );
					m_vecButton[i].SetUIEventFunction( _OnTabButtonDown );
				}
				if ( m_vecView[i] == null )
				{
					m_vecView[i] = new dUIImage( m_pBack , true );
					//m_vecView[i] = new dUITileImageT9( this , true );
					//m_vecView[i].LoadFromImageSet( vecSkin[8] + "," + vecSkin[9] + "," + vecSkin[10] + "," + vecSkin[11] + "," +
					//	vecSkin[12] + "," + vecSkin[13] + "," + vecSkin[14] + "," + vecSkin[15] + "," + vecSkin[16] );
					m_vecView[i].SetShow( false );
				}
				m_vecButton[i].SetText( m_vecButton[i].GetText() );
			}
			if ( isStyleData( "Vertical" ) )
			{
				var maxWidth:int = 0;
				for ( i = 0 ; i < m_vecButton.length ; i ++ )
				{
					if ( !m_vecButton[i].isShow() ) continue;
					if ( maxWidth < m_vecButton[i].GetWidth() )
						maxWidth = m_vecButton[i].GetWidth();
				}
				m_pBack.SetSize( GetWidth() - maxWidth , GetHeight() );
				if( isStyleData( "MirrorButton" ) )
					m_pBack.SetPos( maxWidth , 0 );
				else
					m_pBack.SetPos( 0 , 0 );
				for ( i = 0 ; i < m_vecView.length ; i ++ )
				{
					m_vecView[i].SetSize( m_pBack.GetWidth() , m_pBack.GetHeight() );
					if ( m_vecViewWait[i] ) m_vecViewWait[i].SetSize( m_pBack.GetWidth() , m_pBack.GetHeight() );
				}
				if( m_vecButton.length > 0 )
				{
					var yy:int = 0;
					if( m_vecButton[ m_vecButton.length-1 ].GetPosY () + m_vecButton[ m_vecButton.length-1 ].GetHeight() > GetHeight() )
					{
						var t:int = m_vecButton[ m_vecButton.length - 1 ].GetPosY () + m_vecButton[ m_vecButton.length - 1 ].GetHeight() - GetHeight();
						yy = 0;
						for( i = 0 ; i < m_vecButton.length ; i ++ )
						{
							m_vecButton[ i ].SetSize( m_vecButton[i].GetWidth() , m_vecButton[i].GetHeight() - t / m_vecButton.length );
							if( isStyleData( "MirrorButton" ) )
								m_vecButton[ i ].SetPos( 0 + 2 , yy );
							else
								m_vecButton[ i ].SetPos( m_vecView[i].GetWidth() - 2 , yy );
							yy += m_vecButton[i].GetHeight() + 2;
						}
					}
					else
					{
						for( i = 0 ; i < m_vecButton.length ; i ++ )
							m_vecButton[ i ].SetSizeAsText();
					}
					yy = 0;
					for( i = 0 ; i < m_vecButton.length ; i ++ )
					{
						if ( !m_vecButton[i].isShow() ) continue;
						if( isStyleData( "MirrorButton" ) )
							m_vecButton[ i ].SetPos( 0 + 2 , yy );
						else
							m_vecButton[ i ].SetPos( m_vecView[i].GetWidth() - 2 , yy );
						yy += m_vecButton[i].GetHeight() + 2;
					}
				}
			}
			else
			{
				var maxHeight:int = 0;
				for ( i = 0 ; i < m_vecButton.length ; i ++ )
				{
					if ( !m_vecButton[i].isShow() ) continue;
					if ( maxHeight < m_vecButton[i].GetHeight() )
						maxHeight = m_vecButton[i].GetHeight();
				}
				m_pBack.SetSize( GetWidth() , GetHeight() - maxHeight );
				if( isStyleData( "MirrorButton" ) )
					m_pBack.SetPos( 0 , 0 );
				else
					m_pBack.SetPos( 0 , maxHeight );
				for( i = 0 ; i < m_vecView.length ; i ++ )
				{
					m_vecView[i].SetSize( m_pBack.GetWidth() , m_pBack.GetHeight() );
					if ( m_vecViewWait[i] ) m_vecViewWait[i].SetSize( m_pBack.GetWidth() , m_pBack.GetHeight() );
				}
				if( m_vecButton.length > 0 )
				{
					var xx:int = 0;
					if( m_vecButton[ m_vecButton.length-1 ].GetPosX () + m_vecButton[ m_vecButton.length-1 ].GetWidth() > GetWidth() )
					{
						t = m_vecButton[ m_vecButton.length - 1 ].GetPosX () + m_vecButton[ m_vecButton.length - 1 ].GetWidth() - GetWidth();
						xx = 0;
						for( i = 0 ; i < m_vecButton.length ; i ++ )
						{
							m_vecButton[ i ].SetSize( m_vecButton[ i ].GetWidth() - t / m_vecButton.length , m_vecButton[i].GetHeight() );
							if( isStyleData( "MirrorButton" ) )
								m_vecButton[ i ].SetPos( 10 + xx , m_vecView[i].GetHeight() - 2 );
							else
								m_vecButton[ i ].SetPos( 10 + xx , 0 + 2 );
							xx += m_vecButton[i].GetWidth() + 2;
						}
					}
					else
					{
						for( i = 0 ; i < m_vecButton.length ; i ++ )
							m_vecButton[ i ].SetSizeAsText();
					}
					xx = 0;
					for( i = 0 ; i < m_vecButton.length ; i ++ )
					{
						if ( !m_vecButton[i].isShow() ) continue;
						if( isStyleData( "MirrorButton" ) )
							m_vecButton[ i ].SetPos( 10 + xx , m_vecView[i].GetHeight() - 2 );
						else
							m_vecButton[ i ].SetPos( 10 + xx , 0 + 2 );
						xx += m_vecButton[i].GetWidth() + 2;
					}
				}
			}
		}
		override public function SetStyleData( name:String , bSet:Boolean ):void
		{
			if( name == "Vertical" ||
				name == "MirrorButton" )
			{
				super.SetStyleData( name , bSet );
				Update();
				UpdateSkin();
				for ( var i:int = 0 ; i < m_vecButton.length ; i ++ )
					m_vecButton[i].UpdatePos( isStyleData( "Vertical" ) , isStyleData( "MirrorButton" ) );
			}
		}
		override public function SetMouseStyle( nType:int ):void
		{
			if ( m_nMouseStyle != nType )
			{
				m_nMouseStyle = nType;
				for ( var i:int = 0 ; i < m_vecButton.length ; i ++ )
					m_vecButton[i].SetMouseStyle( nType );
			}
		}
		override public function SetShowClient( bShow:Boolean , nTabIndex:int ):void
		{
			if ( nTabIndex >= 0 && nTabIndex < m_vecView.length )
			{
				m_vecView[nTabIndex].SetShowClient( bShow , 0 );
				SetSelectTab( m_nCurSel , true );
			}
		}
		override public function isShowClient( nTabIndex:int ):Boolean
		{
			if ( nTabIndex >= 0 && nTabIndex < m_vecView.length )
				return m_vecView[nTabIndex].isShowClient( 0 );
			return false;
		}
		override public function SetWait( bWait:Boolean , nTabIndex:int ):void
		{
			if ( nTabIndex >= 0 && nTabIndex < m_vecView.length )
			{
				if ( bWait )
				{
					if ( !m_vecViewWait[nTabIndex] ) m_vecViewWait[nTabIndex] = new dUIWaitPannel( m_pBack );
					m_vecViewWait[nTabIndex].SetPos( m_vecView[nTabIndex].GetPosX() , m_vecView[nTabIndex].GetPosY() );
					m_vecViewWait[nTabIndex].SetSize( m_vecView[nTabIndex].GetWidth() , m_vecView[nTabIndex].GetHeight() );
				}
				m_vecViewWait[nTabIndex].SetShow( bWait );
				m_vecViewWait[nTabIndex].SetShowClient( bWait , 0 );
			}
		}
		override public function _SetText( str:String ):void
		{
			super._SetText( str );
			var vecName:Vector.<String> = SplitString( str , GetTabCount() , "," );
			//SetTabCount( vecName.length );
			for ( var i:int = 0 ; i < vecName.length ; i ++ )
				m_vecButton[i].SetText( vecName[i] );
			Update();
		}
		override public function GetText():String
		{
			var ret:String = "";
			for ( var i:int = 0 ; i < GetTabCount() ; i ++ )
			{
				if ( i != 0 ) ret += ",";
				ret += GetTabName( i );
			}
			return ret;
		}
	}

}