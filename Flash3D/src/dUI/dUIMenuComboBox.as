//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIMenuComboBox extends dUIImage
	{
		protected var m_pComboListBox:dUIListBox;
		protected var m_vecText:Vector.<String> = new Vector.<String>;
		protected var m_vecChild:Vector.<dUIMenuComboBox> = new Vector.<dUIMenuComboBox>;
		protected var m_pComboBoxFather:dUIMenuComboBox;
		protected var m_nCurSel:int;
		protected var m_nCurSeled:int = -1;
		protected var m_nComboListBoxHeight:int;
		public var m_pAttachFather:dUIImage;
		public var m_pDefaultUIEventCallback:Function;
		public function dUIMenuComboBox( pFather:dUIImage , pComboBoxFather:dUIMenuComboBox = null ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_MENUCOMBOBOX;
			m_pComboBoxFather = pComboBoxFather;
		}
		private function _OnComboListBoxSelected( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_LIST_BOX_LBUTTONUP )
			{
				m_nCurSel = event.nParam1;
				if( !m_vecChild[ m_nCurSel ] )
					FireEvent( dUISystem.GUIEVENT_TYPE_RIGHT_CLICK_WINDOW_SELECTED , m_nCurSel , 0 , m_vecText[m_nCurSel] );
				else m_vecChild[ m_nCurSel ].SetShow( !m_vecChild[ m_nCurSel ].isShow() );
			}
			else if( event.type == dUISystem.GUIEVENT_TYPE_RIGHT_CLICK_WINDOW_SELECTED )
				FireEvent( dUISystem.GUIEVENT_TYPE_RIGHT_CLICK_WINDOW_SELECTED , m_nCurSel , 0 , 
					m_pComboListBox.GetString( 1 , m_nCurSel ) + "|" + event.sParam );
			else if ( event.type == dUISystem.GUIEVENT_TYPE_LIST_BOX_SELECTION )
				OnMenuChildMouseIn( event.nParam1 );
		}
		override public function Release():void
		{
			for ( var i:int = 0 ; i < m_vecChild.length ; i ++ )
			{
				if ( m_vecChild[i] ) m_vecChild[i].Release();
			}
			if( m_pComboListBox )m_pComboListBox.Release();
			super.Release();
		}
		override public function SetSize( w:int , h:int ):void
		{
			m_pComboListBox.SetSize( w , h );
			m_pComboListBox.SetTabWidth( 0 , 10 );
			m_pComboListBox.SetTabWidth( 1 , w - 10 );
			m_pComboListBox.Update();
		}
		public function SetLimitHeight( height:int ):void
		{
			if ( m_pComboListBox.GetHeight() > height )
			{
				m_pComboListBox.SetStyleData( "AutoSetSize" , false );
				m_pComboListBox.SetSize( m_pComboListBox.GetWidth() + m_pComboListBox.GetScrollBarVButtonWidth() , height );
				m_pComboListBox.SetTabWidth( 0 , 10 );
				m_nComboListBoxHeight = height;
			}
		}
		override public function GetWidth():int
		{
			if ( !m_pComboListBox ) return 0;
			return m_pComboListBox.GetWidth();
		}
		override public function GetHeight():int
		{
			if ( !m_pComboListBox ) return 0;
			return m_pComboListBox.GetHeight();
		}
		private function FindVecText( str:String ):int
		{
			for ( var i:int = 0 ; i < m_vecText.length ; i ++ )
			{
				if ( m_vecText[i] == str )
					return i;
			}
			return -1;
		}
		public function AddString( str:String , cSplitNext:String = "," , cSplitChild:String = "|" ):void
		{
			var vec:Vector.<String> = SplitString( str , -1 , cSplitNext );
			for ( var i:int = 0 ; i < vec.length ; i ++ )
			{
				var vec2:Vector.<String> = SplitString( vec[i] , -1 , cSplitChild );
				if ( vec2.length > 2 )
				{
					for ( var j:int = 2 ; j < vec2.length ; j ++ )
						vec2[1] += cSplitChild + vec2[j];
					vec2.length = 2;
				}
				if ( vec2.length >= 2 )
				{
					var nFind:int = FindVecText( vec2[0] );
					if ( nFind == -1 )
					{
						m_vecText.push( vec2[0] );
						if ( vec2[1].length )
						{
							var p:dUIMenuComboBox = new dUIMenuComboBox( m_pFather , this );
							p.SetUIEventFunction( _OnComboListBoxSelected );
							m_vecChild.push( p );
							p.AddString( vec2[1] , cSplitNext , cSplitChild );
						}
						else m_vecChild.push( null );
					}
					else m_vecChild[ nFind ].AddString( vec2[1] , cSplitNext , cSplitChild );
				}
				else
				{
					m_vecText.push( vec2[0] );
					m_vecChild.push( null );
				}
			}
		}
		public function SetCurSel( nLine:int ):void
		{
			m_nCurSeled = nLine;
		}
		override public function SetPos( x:int , y:int ):void
		{
			super.SetPos( x , y );
			if ( m_pComboListBox )
			{
				m_pComboListBox.SetPos( x , y );
			}
		}
		public function OnMenuChildMouseIn( nIndex:int ):void
		{
			var pObj:dUIImage = m_pComboListBox.GetList( 1 , nIndex );
			for ( var i:int = 0 ; i < m_vecChild.length ; i ++ )
			{
				if( m_vecChild[i] )
					m_vecChild[i].SetShow( false );
			}
			if ( m_vecChild[nIndex] )
			{
				m_vecChild[nIndex].SetShow( true );
				var xx:int = GetPosX() + pObj.GetWidth();
				var yy:int = GetPosY() + pObj.GetPosY() + m_pComboListBox.GetClient().GetPosY();
				if ( xx + m_vecChild[nIndex].GetWidth() > GetImageRoot().GetWidth() )
					xx = GetPosX() - m_vecChild[nIndex].GetWidth();
				if ( yy + m_vecChild[nIndex].GetHeight() > GetImageRoot().GetHeight() )
					yy = GetImageRoot().GetHeight() - m_vecChild[nIndex].GetHeight();
				m_vecChild[nIndex].SetPos( xx , yy );
			}
			m_nCurSel = nIndex;
		}
		public function CheckSize():void
		{
			if ( m_pComboListBox.GetPosY() < 0 )
			{
				m_pComboListBox.SetSize( m_pComboListBox.GetWidth() , m_nComboListBoxHeight + m_pComboListBox.GetPosY() );
				m_pComboListBox.SetTabWidth( 0 , 10 );
				m_pComboListBox.SetPos( m_pComboListBox.GetPosX() , 0 );
				m_pComboListBox.SetStyleData( "ShowVScroll" , true );
			}
			else
				m_pComboListBox.SetSize( m_pComboListBox.GetWidth() , m_nComboListBoxHeight );
			if ( m_pComboListBox.GetHeight() > GetImageRoot().GetHeight() - m_pComboListBox.GetPosY() )
			{
				m_pComboListBox.SetStyleData( "ShowVScroll" , true );
				m_pComboListBox.SetSize( m_pComboListBox.GetWidth() , GetImageRoot().GetHeight() - GetPosY() );
			}
		}
		override public function SetShow( bShow:Boolean ):void
		{
			super.SetShow( bShow );
			if ( bShow )
			{
				if ( !m_pComboListBox )
				{
					m_pComboListBox = new dUIListBox( m_pFather );
					m_pComboListBox.SetEdgeRect( 0 , 2 , 0 , 2 );
					m_pComboListBox.LoadFromImageSet( ",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,下拉列表1,下拉列表2,下拉列表3,下拉列表4,下拉列表5,下拉列表6,下拉列表7,下拉列表8,下拉列表9" );
					m_pComboListBox.SetTabCount( 2 );
					m_pComboListBox.SetStyleData( "ShowTitle" , false );
					m_pComboListBox.SetStyleData( "AutoSetSize" , true );
					m_pComboListBox.SetStyleData( "ShowSelection" , false );
					m_pComboListBox.SetHandleMouse( true );
					m_pComboListBox.SetUIEventFunction( _OnComboListBoxSelected );
					m_pComboListBox.SetSize( 100 , 100 );
					m_pComboListBox.SetStyleData( "ShowHScroll" , false );
					m_pComboListBox.SetStyleData( "ShowVScroll" , true );
					//m_pComboListBox.SetTabWidth( 1 , 100 - 10 );
					var maxWidth:int = 0;
					var bHaveChild:Boolean;
					var nChildButtonWidth:int;
					for ( var i:int = 0 ; i < m_vecText.length ; i ++ )
					{
						var p:dUIMenuObj = new dUIMenuObj( m_pComboListBox.GetClient() , this , i );
						p.SetText( m_vecText[i] );
						p.SetAlignType( 1 );
						p.SetSizeAsText();
						if ( maxWidth < p.GetWidth() )
							maxWidth = p.GetWidth();
						if ( m_vecChild[i] )
						{
							p.SetHaveChild( true );
							bHaveChild = true;
							nChildButtonWidth = p.GetChildButtonWidth();
						}
						m_pComboListBox.AddList( p , 1 , -1 );
					}
					if ( bHaveChild ) maxWidth += nChildButtonWidth;
					m_pComboListBox.SetSize( maxWidth + 20 , m_pComboListBox.GetHeight() );
					var add:int = maxWidth + 20 - m_pComboListBox.GetScroll().GetView().GetWidth() - m_pComboListBox.GetEdgeWidth();
					if ( add > 0 )
						m_pComboListBox.SetSize( maxWidth + 20 + add , m_pComboListBox.GetHeight() );
					m_pComboListBox.SetTabWidth( 0 , 10 );
					m_pComboListBox.SetTabWidth( 1 , maxWidth + 10 );
					m_nComboListBoxHeight = m_pComboListBox.GetHeight();
					m_pComboListBox.SetCurSel( m_nCurSeled , 0 );
				}
				m_pComboListBox.SetShow( true );
			}
			else
			{
				if ( m_pComboListBox ) m_pComboListBox.SetShow( false );
				for ( i = 0 ; i < m_vecChild.length ; i ++ )
				{
					if ( m_vecChild[i] ) m_vecChild[i].SetShow( false );
				}
			}
		}
	}
}