//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	import dcom.dStringUtils;
	/**
	 * ...
	 * @author dym
	 */
	public class dUIEditBox extends dUITileImageT9
	{
		protected var m_pSuperText:dUISuperText;
		protected var m_pSuperTextScroll:dUIScroll;
		protected var m_pComboButton:dUIImageButton;
		protected var m_strComboString:String;
		protected var m_pComboListBox:dUIMenuComboBox;
		protected var m_nComboListBoxLimitHeight:int = 0;
		protected var m_bScrollChanging:Boolean;
		protected var m_nLimitTextLength:int = -1;
		protected var m_nLimitNumber:int = 0x7FFFFFFF;
		protected var m_nLimitNumberMin:int = int(0x80000000);
		public function dUIEditBox( pFather:dUIImage )
		{
			super( pFather , true );
			m_nObjType = dUISystem.GUIOBJ_TYPE_EDITBOX;
			LoadFromImageSet( "" );
			m_pSuperTextScroll = new dUIScroll( this );
			m_pSuperText = new dUISuperText( m_pSuperTextScroll.GetClient() );
			m_pSuperText.SetUIEventFunction( _OnSuperTextOnChar );
			m_pComboButton = new dUIImageButton( this );
			m_pComboButton.LoadFromImageSet( "下拉列表下拉按钮正常,下拉列表下拉按钮发亮,下拉列表下拉按钮按下,下拉列表下拉按钮无效" );
			m_pComboButton.SetShow( false );
			m_pComboButton.SetUIEventFunction( _OnShowComboBoxEvent );
			var pImageSet:dUIImageSet = GetImageRoot().GetImageSet();
			var rc:dUIImageRect = pImageSet.GetImageRect( "编辑框文字偏移" );
			SetEdgeRect( rc.left , rc.top , rc.left , rc.top );
			SetHandleMouse( true );
			// 设置默认
			SetSize( 100 , 20 );
			SetAlignType( 1 );
			SetStyleData( "ShowVScroll" , false );
			SetStyleData( "ShowHScroll" , false );
		}
		override public function Release():void
		{
			if ( s_pLastShowComboBox == this ) s_pLastShowComboBox = null;
			super.Release();
		}
		override public function GetDefaultSkin():String
		{
			return "编辑框1,编辑框2,编辑框3,编辑框4,编辑框5,编辑框6,编辑框7,编辑框8,编辑框9";
		}
		override public function SetHandleMouse( bSet:Boolean ):void
		{
			super.SetHandleMouse( bSet );
		}
		private function CharFilter( str:String ):String
		{
			if ( isStyleData( "NumberOnly" ) )
			{
				var str2:String = "";
				for ( var i:int = 0 ; i < str.length ; i ++ )
				{
					if ( str.charCodeAt( i ) >= "0".charCodeAt() && str.charCodeAt( i ) <= "9".charCodeAt() ||
						 str.charAt( i ) == "-" && i == 0 && m_nLimitNumberMin < 0 )
					{
						if ( str2 == "0" ) str2 = "";
						str2 += str.charAt( i );
					}
				}
				str = str2;
				if ( Number( str ) > Number( m_nLimitNumber ) )
					 str = String( m_nLimitNumber );
				else if ( Number( str ) < Number( m_nLimitNumberMin ) )
					 str = String( m_nLimitNumberMin );
				if ( isStyleData( "NumberAutoSplit" ) )
				{
					str2 = str;
					str = "";
					var k:int = 3 - (str2.length % 3);
					for ( i = 0 ; i < str2.length ; i ++ )
					{
						str += str2.charAt( i );
						k++;
						if ( (k % 3) == 0 && i != str2.length - 1 )
							str += ",";
					}
				}
			}
			if ( !isStyleData( "CanEnterLine" ) && str.indexOf( "\n" ) != -1 )
			{
				str2 = "";
				for ( i = 0 ; i < str.length ; i ++ )
				{
					if ( str.charAt( i ) != "\n" )
						 str2 += str.charAt( i );
				}
				str = str2;
			}
			if ( m_nLimitTextLength != -1 && str.length > m_nLimitTextLength )
			{
				var nEnd:int = m_pSuperText.GetSelectionEnd();
				var nErase:int = str.length - m_nLimitTextLength;
				str2 = "";
				if ( nEnd < nErase ) nEnd = nErase;
				for ( i = 0 ; i < nEnd - nErase ; i ++ )
					str2 += str.charAt( i );
				for ( i = nEnd ; i < str.length ; i ++ )
					str2 += str.charAt( i );
				str = str2;
			}
			return str;
		}
		private function _OnSuperTextOnChar( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_SUPPERTEXT_CHANGED )
			{
				var strOld:String = GetText();
				var str:String = CharFilter( event.sParam );
				//if ( str != event.sParam )
				{
					var nBegin:int = GetSelectionBegin();
					var nEnd:int = GetSelectionEnd();
					_SetText( str );
					SetSelection( nBegin - ( event.sParam.length - str.length ) , nEnd - ( event.sParam.length - str.length ) );
				}
				//else _SetText( str );
				if ( strOld != str )
					FireEvent( event.type , event.nParam1 , event.nParam2 , strOld );
				UpdateClientSize();
			}
			else if ( event.type == dUISystem.GUIEVENT_TYPE_SUPPERTEXT_SCROLL_CHANGED )
			{
			}
			else if ( event.type == dUISystem.GUIEVENT_TYPE_KEYDOWN )
			{
				/*var text:String = GetText();
				var str = CharFilter( GetText() );
				if ( str != text )
				{
					var nBegin = GetSelectionBegin();
					var nEnd = GetSelectionEnd();
					_SetText( str );
					FireEvent( dUISystem.GUIEVENT_TYPE_SUPPERTEXT_CHANGED , event.nParam1 , event.nParam2 , text );
					SetSelection( nBegin - ( text.length - str.length ) , nEnd - ( text.length - str.length ) );
				}
				//else _SetText( str );
				UpdateClientSize();*/
				if ( event.nParam1 == 8 && isStyleData( "NumberOnly" ) && isStyleData( "NumberAutoSplit" ) && GetText().charAt( GetSelectionBegin() - 1 ) == "," )
					SetSelection( GetSelectionBegin() - 1 , GetSelectionEnd() );
				if ( event.nParam1 == 13 )
					FireEvent( dUISystem.GUIEVENT_TYPE_EDITBOX_ON_ENTER , event.nParam1 , event.nParam2 , event.sParam , event.oParam );
				FireEvent( event.type , event.nParam1 , event.nParam2 , event.sParam , event.oParam );
			}
			else
				FireEvent( event.type , event.nParam1 , event.nParam2 , event.sParam , event.oParam );
		}
		override public function SetSize( w:int , h:int ):void
		{
			if ( GetWidth() != w || GetHeight() != h )
			{
				super.SetSize( w , h );
				Update();
				if ( isStyleData( "AutoEnterLine" ) && isStyleData( "AutoSetSize" ) )
				{
					m_pSuperText.SetSize( w - GetEdgeWidth() , h - GetEdgeHeight() );
					super.SetSize( w , m_pSuperText.GetHeight() + GetEdgeHeight() );
					Update();
				}
			}
		}
		protected function Update():void
		{
			var w:int = GetWidth();
			var h:int = GetHeight();
			if ( m_pComboButton.isShow() )
			{
				m_pSuperTextScroll.SetSize( w - m_pComboButton.GetWidth() - GetEdgeWidth() , h - GetEdgeHeight() );
				m_pComboButton.SetPos( w - m_pComboButton.GetWidth() , ( h - m_pComboButton.GetHeight() ) / 2 );
			}
			else
				m_pSuperTextScroll.SetSize( w - GetEdgeWidth() , h - GetEdgeHeight() );
			m_pSuperTextScroll.SetPos( GetEdgeLeft() , GetEdgeTop() );
			UpdateClientSize();
		}
		protected function UpdateClientSize():void
		{
			if ( isStyleData( "CanEdit" ) )
			{
				m_pSuperTextScroll.SetClientSize( m_pSuperTextScroll.GetView().GetWidth() , m_pSuperTextScroll.GetView().GetHeight() );
				m_pSuperText.SetSize( m_pSuperTextScroll.GetClientWidth() , m_pSuperTextScroll.GetClientHeight() );
			}
			else
			{
				for ( var i:int = 0 ; i < 2 ; i ++ )
				{
					var w:int = m_pSuperText.GetTextWidth();
					var h:int = m_pSuperText.GetTextHeight();
					if ( w < m_pSuperTextScroll.GetView().GetWidth() )
						 w = m_pSuperTextScroll.GetView().GetWidth();
					if ( h < m_pSuperTextScroll.GetView().GetHeight() )
						 h = m_pSuperTextScroll.GetView().GetHeight();
					// client与文本同大小
					m_pSuperTextScroll.SetClientSize( w , h );
					if ( isStyleData( "AutoEnterLine" ) )
						m_pSuperText.SetSize( m_pSuperTextScroll.GetView().GetWidth() , m_pSuperTextScroll.GetClientHeight() );
					else
					{
						m_pSuperText.SetSize( m_pSuperTextScroll.GetClientWidth() , m_pSuperTextScroll.GetClientHeight() );
						break;
					}
				}
			}
		}
		override public function isStyleData( name:String ):Boolean
		{
			if ( name == "ShowVScroll" || name == "ShowHScroll" )
				return m_pSuperTextScroll.isStyleData( name );
			return super.isStyleData( name );
		}
		override public function SetStyleData( name:String , bSet:Boolean ):void
		{
			if( name == "ShowVScroll" ||
				name == "ShowHScroll" ||
				name == "AlwaysShowVScroll" ||
				name == "AlwaysShowHScroll" ||
				name == "HScrollMirror" ||
				name == "VScrollMirror" ||
				name == "AutoEnterLine" ||
				name == "CanEdit" ||
				name == "PassWord" ||
				name == "AutoLimitTextLength" ||
				name == "DownListButton" ||
				name == "NumberOnly" ||
				name == "NumberAutoSplit" ||
				name == "CanEnterLine" ||
				name == "CanInputAND" ||
				name == "MultiLine" ||
				name == "AutoSetSize" ||
				name == "NoSign" )
			{
				if ( isStyleData( name ) == bSet ) return;
				super.SetStyleData( name , bSet );
				if ( name == "AutoSetSize" )
				{
					SetStyleData( "ShowVScroll" , false );
					SetStyleData( "ShowHScroll" , false );
					SetStyleData( "AutoEnterLine" , false );
				}
				m_pSuperText.SetStyleData( name , bSet );
				if ( name == "DownListButton" )
				{
					m_pComboButton.SetShow( bSet );
				}
				if ( name == "AutoSetSize" && bSet || name == "AutoEnterLine" )
					SetSize( m_pSuperText.GetWidth() + GetEdgeWidth() , m_pSuperText.GetHeight() + GetEdgeHeight() );
				if ( name == "CanEdit" )
				{
					m_pSuperTextScroll.SetStyleData( "ShowVScroll" , !bSet );
					m_pSuperTextScroll.SetStyleData( "ShowHScroll" , !bSet );
					m_pSuperText.SetCanEdit( bSet );
					SetHandleMouseWheel( bSet );
					_SetText( GetText() );
				}
				if ( name == "ShowVScroll" || name == "ShowHScroll" )
				{
					bSet = Boolean( int( bSet ) & int(!isStyleData( "AutoSetSize" )) & int(!isStyleData( "CanEdit" )));
				}
				m_pSuperTextScroll.SetStyleData( name , bSet );
				Update();
			}
		}
		override public function SetAlignType( type:int , nIndex:int = 0 ):void
		{
			if ( type != GetAlignType() )
			{
				super.SetAlignType( type , nIndex );
				m_pSuperText.SetAlignType( type , nIndex );
				Update();
			}
		}
		override public function _SetText( str:String ):void
		{
			m_pSuperText._SetText( str );
			if ( isStyleData( "AutoSetSize" ) )
				SetSize( m_pSuperText.GetWidth() + GetEdgeWidth() , m_pSuperText.GetHeight() + GetEdgeHeight() );
			UpdateClientSize();
		}
		override public function GetText():String
		{
			return m_pSuperText.GetText();
		}
		public function InsertString( nIndex:int , strText:String ):void
		{
			var str:String = GetText();
			if ( m_nLimitTextLength != -1 && m_pSuperText.GetTextLength( str + strText ) > m_nLimitTextLength ) return;
			var strWithoutSign:String = dUISuperText.ConvTextWithoutSign( str );
			if ( nIndex < 0 ) nIndex = GetSelectionEnd();
			else if ( nIndex > strWithoutSign.length ) nIndex = strWithoutSign.length;
			if ( GetSelectionBegin() < GetSelectionEnd() )
			{
				nIndex -= GetSelectionEnd() - GetSelectionBegin();
				str = m_pSuperText.DelString( str , GetSelectionBegin() , GetSelectionEnd() );
			}
			var arr:Array = m_pSuperText.SubString( str , nIndex );
			SetText( arr[0] + strText + arr[1] );
			var loc:int = ( arr[0] + strText ).length;
			m_pSuperText.SetSelection( loc , loc );
			
			if ( isStyleData( "AutoSetSize" ) )
				SetSize( m_pSuperText.GetWidth() + GetEdgeWidth() , m_pSuperText.GetHeight() + GetEdgeHeight() );
		}
		override public function SetFocus( bSet:Boolean ):void
		{
			//super.SetFocus( bSet );
			m_pSuperText.SetFocus( bSet );
		}
		public function SetLimitTextLength( length:int ):void
		{
			m_nLimitTextLength = length;
		}
		public function GetLimitTextLength():int
		{
			return m_nLimitTextLength;
		}
		public function SetLimitNumber( num:int ):void
		{
			m_nLimitNumber = num;
		}
		public function GetLimitNumber():int
		{
			return m_nLimitNumber;
		}
		public function SetLimitNumberMin( num:int ):void
		{
			m_nLimitNumberMin = num;
		}
		public function GetLimitNumberMin():int
		{
			return m_nLimitNumberMin;
		}
		private function _OnComboListBoxSelected( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_RIGHT_CLICK_WINDOW_SELECTED )
			{
				m_pComboListBox = null;
				if ( event.nParam1 != -1 )
				{
					SetText( event.sParam );
					FireEvent( dUISystem.GUIEVENT_TYPE_COMBO_BOX_SELECTED , event.nParam1 , event.nParam2 , event.sParam );
				}
				else
					FireEvent( dUISystem.GUIEVENT_TYPE_COMBO_BOX_UNSELECTED , event.nParam1 , event.nParam2 , event.sParam );
			}
		}
		override public function OnLButtonDown( x:int , y:int ):void
		{
			super.OnLButtonDown( x , y );
			if ( isStyleData( "DownListButton" ) && isWindowEnable() )
			{
				if ( m_strComboString && m_strComboString.length )
				{
					FireEvent( dUISystem.GUIEVENT_TYPE_COMBO_BOX_ON_SHOW );
					if ( !dUIImage.m_bContinueLButtonDown || dUIImage.m_bContinueLButtonDown && s_pLastShowComboBox != this )
					{
						_OnShowComboBox();
					}
				}
			}
		}
		static public var s_pLastShowComboBox:dUIEditBox;
		private function _OnShowComboBox():void
		{
			s_pLastShowComboBox = this;
			if ( m_strComboString == null ) m_strComboString = "";
			m_pComboListBox = new dUIMenuComboBox( GetImageRoot().GetComboListBoxBoard() );
			m_pComboListBox.SetUIEventFunction( _OnComboListBoxSelected );
			m_pComboListBox.AddString( m_strComboString );
			GetImageRoot().CreateRightMenu( m_pComboListBox );
			var arr:Array = m_strComboString.split( "," );
			var strText:String = GetText();
			for ( var i:int = 0 ; i < arr.length ; i ++ )
			{
				if ( strText == arr[i] )
				{
					m_pComboListBox.SetCurSel( i );
					break;
				}
			}
			m_pComboListBox.SetShow( true );
			m_pComboListBox.SetPos( GetPosX_World() , GetPosY_World() + GetHeight() );
			var bUpList:Boolean = false;
			if ( m_nComboListBoxLimitHeight )
				m_pComboListBox.SetLimitHeight( m_nComboListBoxLimitHeight );
			if ( m_pComboListBox.GetPosY() > GetImageRoot().GetHeight() - m_pComboListBox.GetHeight() &&
				GetPosY_World() > GetImageRoot().GetHeight() / 2 )// 上拉
			{
				m_pComboListBox.SetPos( GetPosX_World() , GetPosY_World() - m_pComboListBox.GetHeight() );
				bUpList = true;
			}
			m_pComboListBox.CheckSize();
			if( m_pComboListBox.GetWidth() < GetWidth() )
				m_pComboListBox.SetSize( GetWidth() , m_pComboListBox.GetHeight() );
			/*if ( bUpList )
			{
				if ( m_pComboListBox.GetHeight() > GetPosY_World() )
				{
					m_pComboListBox.SetSize( m_pComboListBox.GetWidth() , GetPosY_World() );
					m_pComboListBox.SetPos( m_pComboListBox.GetPosX() , 0 );
					m_pComboListBox.SetStyleData( "ShowVScroll" , true );
				}
			}*/
		}
		private function _OnShowComboBoxEvent( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_BUTTON_DOWN )
			{
				FireEvent( dUISystem.GUIEVENT_TYPE_COMBO_BOX_ON_SHOW );
				if ( m_strComboString && m_strComboString.length )
				{
					_OnShowComboBox();
				}
			}
			else if ( event.type == dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED )
				Update();
		}
		public function SetComboBoxLimitHeight( height:int ):void
		{
			m_nComboListBoxLimitHeight = height;
		}
		public function GetComboBoxLimitHeight():int
		{
			return m_nComboListBoxLimitHeight;
		}
		public function SetComboBoxString( str:String ):void
		{
			if ( str == null ) str = "";
			m_strComboString = str;
			if ( isStyleData( "CanEdit" ) == false )
			{
				var arr:Array = m_strComboString.split( "," );
				var strText:String = GetText();
				var bHave:Boolean;
				for ( var i:int = 0 ; i < arr.length ; i ++ )
				{
					if ( arr[i] == strText )
					{
						bHave = true;
						break;
					}
				}
				if ( !bHave )
				{
					if ( arr.length ) SetText( arr[0] );
					else SetText( "" );
				}
			}
		}
		public function GetComboBoxString():String
		{
			return m_strComboString;
		}
		public function isComboBoxShow():Boolean
		{
			return m_pComboListBox != null;
		}
		public function SetComboBoxShow( bShow:Boolean ):void
		{
			if ( bShow ) _OnShowComboBox();
			else
			{
				if ( m_pComboListBox )
				{
					m_pComboListBox.Release();
					m_pComboListBox = null;
					GetImageRoot().CheckComboListBoxBoard();
				}
			}
		}
		override public function EnableWindow( bEnable:Boolean ):void
		{
			m_pComboButton.EnableWindow( bEnable );
			m_pSuperText.EnableWindow( bEnable );
			m_pSuperTextScroll.EnableWindow( bEnable );
			super.EnableWindow( bEnable );
		}
		public function SetToTop():void
		{
			m_pSuperTextScroll.SetToTop();
		}
		public function SetToBottom():void
		{
			m_pSuperTextScroll.SetToBottom();
		}
		public function GetScroll():dUIScroll
		{
			return m_pSuperTextScroll;
		}
		public function GetScrollClientPosX():int
		{
			return m_pSuperTextScroll.GetClient().GetPosX();
		}
		public function GetScrollClientPosY():int
		{
			return m_pSuperTextScroll.GetClient().GetPosY();
		}
		public function GetSelectionBegin():int
		{
			return m_pSuperText.GetSelectionBegin();
		}
		public function GetSelectionEnd():int
		{
			return m_pSuperText.GetSelectionEnd();
		}
		public function SetSelection( begin:int , end:int ):void
		{
			m_pSuperText.SetSelection( begin , end );
		}
		override public function SetMouseStyle( nType:int ):void
		{
			m_pSuperTextScroll.SetMouseStyle( nType );
			m_pComboButton.SetMouseStyle( nType );
		}
		override public function GetMouseStyle():int
		{
			return m_pSuperTextScroll.GetMouseStyle();
		}
		override public function SetTooltip( pData:Object ):void
		{
			m_pSuperText.SetTooltip( pData );
		}
		override public function GetTooltip():Object
		{
			return m_pSuperText.GetTooltip();
		}
	}
}