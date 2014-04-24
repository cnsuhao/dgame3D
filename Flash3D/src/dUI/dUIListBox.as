//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIListBox extends dUITileImageT9
	{
		protected var m_vecTitle:Vector.<dUIListBoxTitle> = new Vector.<dUIListBoxTitle>();
		protected var m_vecTitleWidthPersent:Vector.<Number> = new Vector.<Number>;
		protected var m_vecTitleDrag:Vector.<dUIImageButton> = new Vector.<dUIImageButton>();
		protected var m_vecObj:Array = new Array();// as ListBoxLineData
		protected var m_nTabHeight:int;
		protected var m_pScrollBar:dUIScroll;
		protected var m_nMaxListNum:int;
		protected var m_nCurSel:int;
		protected var m_nCurSelTab:int;
		protected var m_pSelectOver:dUIImage;
		protected var m_pSelection:dUIImage;
		protected var m_vecAddStringCommand:Array = new Array;
		protected var m_bFrameMove:Boolean;
		protected var m_bCommandAdding_NoUpdate:Boolean;
		protected var m_arrSortFunction:Array;
		protected var m_strButtonSkinName:String;
		protected var m_strButtonBackName1:String;
		protected var m_strButtonBackName2:String;
		protected var m_nForcePerLineHeight:int = 0;// 强制行高度 0为自动高度
		protected var m_nPerLineSpace:int = 0;// 行间距
		public function dUIListBox( pFather:dUIImage ):void
		{
			super( pFather , true );
			m_nObjType = dUISystem.GUIOBJ_TYPE_LISTBOX;
			m_pScrollBar = new dUIScroll( this );
			m_pScrollBar.SetUIEventFunction( _OnScrollDrag );
			m_pSelectOver = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_GROUP , m_pScrollBar.GetClient() , true , GetObjType() );
			//m_pSelectOver.CreateImage( 1 , 1 , 0x500000FF );
			m_pSelectOver.SetShow( false );
			m_pSelection = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_GROUP , m_pScrollBar.GetClient() , true , GetObjType() );
			//m_pSelection.CreateImage( 1 , 1 , 0xE0253830 );
			m_pSelection.SetShow( false );
			m_nCurSel = -1;
			// 设置默认
			LoadFromImageSet( "" );
			m_nTabHeight = 20;
			SetSize( 200 , 200 );
			SetTabCount( 2 );
			SetStyleData( "ShowTitle" , true );
			SetStyleData( "ShowSelection" , true );
			SetStyleData( "ShowBackImage" , true );
			SetStyleData( "CanDrag" , true );
			SetHandleMouse( true );
		}
		override public function GetDefaultSkin():String
		{
			var pSet:dUIImageSet = GetImageRoot().GetImageSet();
			if ( pSet.GetImageRect( "#默认列表" , true ) )
				return pSet.GetImageFileName( "#默认列表" );
			return "按钮正常1,按钮正常2,按钮正常3,按钮正常4,按钮正常5,按钮正常6,按钮正常7,按钮正常8,按钮正常9,\
				按钮发亮1,按钮发亮2,按钮发亮3,按钮发亮4,按钮发亮5,按钮发亮6,按钮发亮7,按钮发亮8,按钮发亮9,\
				按钮按下1,按钮按下2,按钮按下3,按钮按下4,按钮按下5,按钮按下6,按钮按下7,按钮按下8,按钮按下9,\
				按钮无效1,按钮无效2,按钮无效3,按钮无效4,按钮无效5,按钮无效6,按钮无效7,按钮无效8,按钮无效9,\
				列表框1,列表框2,列表框3,列表框4,列表框5,列表框6,列表框7,列表框8,列表框9,,";
		}
		override public function _LoadFromImageSet( str:String ):void
		{
			var arr:Vector.<String> = SplitName( str , 47 + 64 , false );
			m_strButtonSkinName = "";
			for ( var i:int = 0 ; i < 36 ; i ++ )
			{
				if ( i ) m_strButtonSkinName += ",";
				m_strButtonSkinName += arr[i];
			}
			m_strButtonBackName1 = arr[45];
			m_strButtonBackName2 = arr[46];
			for ( i = 0 ; i < m_vecTitle.length ; i ++ )
			{
				m_vecTitle[i].LoadFromImageSet( m_strButtonSkinName );
			}
			super._LoadFromImageSet( arr[36] + "," + arr[37] + "," + arr[38] + "," + arr[39] + "," + arr[40] + "," +
				arr[41] + "," + arr[42] + "," + arr[43] + "," + arr[44] );
			var bScrollSkin:Boolean = false;
			var strScrollSkin:String = "";
			for ( i = 47 ; i < 47 + 64 ; i ++ )
			{
				if ( arr[i] != "" )
					bScrollSkin = true;
				if ( i != 47 ) strScrollSkin += ",";
				strScrollSkin += arr[i];
			}
			if ( bScrollSkin )
				m_pScrollBar.LoadFromImageSet( strScrollSkin );
			else
				m_pScrollBar.LoadFromImageSet( "" );
		}
		private function _OnTitleButtonEvent( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_BUTTON_UP )
			{
				for ( var i:int = 0 ; i < m_vecTitle.length ; i ++ )
				{
					if ( event.pObj == m_vecTitle[i] )
					{
						if ( m_vecTitle[i].GetShowSortIcon() )
						{
							for ( var j:int = 0 ; j < m_vecTitle.length ; j ++ )
								m_vecTitle[j].SetSortIconAlpha( j == i ? 255 : 128 );
							if ( m_vecTitle[i].GetShowSortIcon() == 1 )
							{
								SortTab( i , true );
								m_vecTitle[i].SetShowSortIcon( 2 );
							}
							else
							{
								SortTab( i , false );
								m_vecTitle[i].SetShowSortIcon( 1 );
							}
						}
						_UpdateLineBackImage();
						FireEvent( dUISystem.GUIEVENT_TYPE_LIST_BOX_TITLE_CLICK  , i , 0 , m_vecTitle[i].GetText() );
						break;
					}
				}
			}
		}
		override public function SetAlignType( nType:int , nTab:int = 0 ):void
		{
			if ( GetAlignType( nTab ) != nType )
			{
				if ( nTab == 0 )
				{
					super.SetAlignType( nType )
					for ( i = 0 ; i < m_vecTitle.length ; i ++ )
						m_vecTitle[i].SetAlignVertical( nType );
				}
				else if ( nTab >= 0 && nTab < m_vecTitle.length )
					m_vecTitle[nTab].SetAlignVertical( nType );
					
				for ( var i:int = 0 ; i < m_vecObj.length ; i ++ )
				{
					var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ i ] as ListBoxLineData).vecObj;
					if ( nTab == 0 )
					{
						for ( var j:int = 0 ; j < lineData.length ; j ++ )
						{
							if ( lineData[j].m_pData )
								lineData[j].m_pData.SetAlignType( nType );
						}
					}
					else
					{
						j = nTab - 1;
						if ( j < lineData.length )
						{
							if ( lineData[j].m_pData )
								lineData[j].m_pData.SetAlignType( nType );
						}
					}
				}
			}
		}
		override public function GetAlignType( nTab:int = 0 ):int
		{
			if ( nTab == 0 ) return super.GetAlignType();
			else if ( nTab >= 1 && nTab <= m_vecTitle.length )
				return m_vecTitle[nTab - 1].GetAlignVertical();
			return super.GetAlignType();
		}
		public function OnListBoxObjOver( pObj:dUIListBoxObj , bOver:Boolean ):void
		{
			if ( bOver )
			{
				m_pSelectOver.SetShow( true );
				if ( isStyleData( "SelectPerTab" ) )
				{
					if ( pObj.m_pData )
					{
						m_pSelectOver.SetPos( pObj.GetPosX() , pObj.GetPosY() );
						SelectionSetSize( m_pSelectOver , pObj.GetWidth() , pObj.GetHeight() );
					}
					else m_pSelectOver.SetShow( false );
				}
				else
				{
					m_pSelectOver.SetPos( 0 , pObj.GetPosY() );
					if ( isStyleData( "ShowHScroll" ) )
						SelectionSetSize( m_pSelectOver , GetClient().GetWidth() , pObj.GetHeight() );
					else
						SelectionSetSize( m_pSelectOver ,
						DYM_GUI_MIN( m_pScrollBar.GetView().GetWidth() , GetClient().GetWidth() ) , pObj.GetHeight() );
				}
				for ( var i:int = 0 ; i < m_vecObj.length ; i ++ )
				{
					var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ i ] as ListBoxLineData).vecObj;
					for ( var j:int = 0 ; j < lineData.length ; j ++ )
					{
						if ( lineData[j] == pObj )
						{
							FireEvent( dUISystem.GUIEVENT_TYPE_LIST_BOX_SELECTION , i , j );
							if ( lineData[j].GetTooltip() )
								FireEvent( dUISystem.GUIEVENT_TYPE_ON_SHOW_TOOLTIP , i , j , bOver?"show":"hide" , lineData[j].GetTooltip() );
							break;
						}
					}
				}
				
			}
			else
			{
				m_pSelectOver.SetShow( false );
				for ( i = 0 ; i < m_vecObj.length ; i ++ )
				{
					lineData = (m_vecObj[ i ] as ListBoxLineData).vecObj;
					for ( j = 0 ; j < lineData.length ; j ++ )
					{
						if ( lineData[j] == pObj )
						{
							if ( lineData[j].GetTooltip() )
								FireEvent( dUISystem.GUIEVENT_TYPE_ON_SHOW_TOOLTIP , i , j , bOver?"show":"hide" , lineData[j].GetTooltip() );
							break;
						}
					}
				}
			}
		}
		public function OnListBoxObjLButton( pObj:dUIListBoxObj , bDown:Boolean ):void
		{
			if ( bDown )
				OnListBoxObjSelected( pObj , 1 );
			else
			{
				if( pObj.isMouseIn() )
					OnListBoxObjSelected( pObj , 2 );
			}
		}
		public function OnListBoxObjLButtonDrag( pObj:dUIListBoxObj , x:int , y:int ):void
		{
			if ( isStyleData( "CanDrag" ) )
			{
				if ( !isStyleData( "ShowVScroll" ) ) y = 0;
				if ( !isStyleData( "ShowHScroll" ) ) x = 0;
				m_pScrollBar.SetClientPos( m_pScrollBar.GetClient().GetPosX() + x , m_pScrollBar.GetClient().GetPosY() + y );
			}
		}
		override public function OnLButtonDrag( x:int , y:int ):void
		{
		}
		public function OnListBoxObjLButtonDblClk( pObj:dUIListBoxObj , x:int , y:int ):void
		{
			for ( var i:int = 0 ; i < m_vecObj.length ; i ++ )
			{
				var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ i ] as ListBoxLineData).vecObj;
				for ( var j:int = 0 ; j < lineData.length ; j ++ )
				{
					if ( lineData[j] == pObj )
					{
						if( m_nCurSel == i )
							FireEvent( dUISystem.GUIEVENT_TYPE_LIST_BOX_DBL_CLK , m_nCurSel , j , pObj.GetText() );
						break;
					}
				}
			}
		}
		private function OnListBoxObjSelected( pObj:dUIListBoxObj , bFireType:int ):void
		{
			if ( isStyleData( "SelectPerTab" ) && pObj.m_pData == null ) return;
			if ( bFireType == 2 )
			{
				for ( var i:int = 0 ; i < m_vecObj.length ; i ++ )
				{
					var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ i ] as ListBoxLineData).vecObj;
					for ( var j:int = 0 ; j < lineData.length ; j ++ )
					{
						if ( lineData[j] == pObj )
						{
							if( m_nCurSel == i )
								FireEvent( dUISystem.GUIEVENT_TYPE_LIST_BOX_LBUTTONUP , m_nCurSel , j , pObj.GetText() );
							break;
						}
					}
				}
			}
			else
			{
				m_pSelection.SetShow( isStyleData( "ShowSelection" ) );
				if ( isStyleData( "SelectPerTab" ) )
				{
					if ( pObj.m_pData )
					{
						m_pSelection.SetPos( pObj.GetPosX() , pObj.GetPosY() );
						SelectionSetSize( m_pSelection , pObj.GetWidth() , pObj.GetHeight() );
					}
					else m_pSelection.SetShow( false );
				}
				else
				{
					m_pSelection.SetPos( 0 , pObj.GetPosY() );
					if ( isStyleData( "ShowHScroll" ) )
						SelectionSetSize( m_pSelection , GetClient().GetWidth() , pObj.GetHeight() );
					else
						SelectionSetSize( m_pSelection ,
						DYM_GUI_MIN( m_pScrollBar.GetView().GetWidth() , GetClient().GetWidth() ) , pObj.GetHeight() );
				}
				var nTab:int = 0;
				for ( i = 0 ; i < m_vecObj.length ; i ++ )
				{
					lineData = (m_vecObj[ i ] as ListBoxLineData).vecObj;
					for ( j = 0 ; j < lineData.length ; j ++ )
					{
						if ( lineData[j] == pObj )
						{
							m_nCurSel = i;
							nTab = j;
							m_nCurSelTab = j;
							break;
						}
					}
				}
				if( bFireType == 1 )
					FireEvent( dUISystem.GUIEVENT_TYPE_LIST_BOX_SELECTED , m_nCurSel , nTab , pObj.GetText() );
			}
		}
		private function UpdateTitlePos():void
		{
			var x:int = m_pScrollBar.GetClient().GetPosX() + m_pScrollBar.GetView().GetPosX() + GetEdgeLeft() ;
			for ( var i:int = 0 ; i < m_vecTitle.length ; i ++ )
			{
				m_vecTitle[i].SetPos( x , GetEdgeTop() );
				x += m_vecTitle[i].GetWidth();
			}
			for ( i = 0 ; i < m_vecTitleDrag.length ; i ++ )
				m_vecTitleDrag[i].SetPos( m_vecTitle[i].GetPosX() + m_vecTitle[i].GetWidth() - 5 , GetEdgeTop() );
		}
		private function _OnScrollDrag( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_SCROLL_DRAG )
			{
				UpdateTitlePos();
			}
			FireEvent( event.type , event.nParam1 , event.nParam2 , event.sParam , event.oParam );
		}
		private function _OnTitleButtonDrag( event:dUIEvent ):void
		{
			if ( event.nParam1 && isStyleData( "TitleCanDrag" ) )
			{
				for ( var i:int = 0 ; i < m_vecTitleDrag.length ; i ++ )
				{
					if ( event.pObj == m_vecTitleDrag[i] )
					{
						var w:int = GetTabWidth( i ) + event.nParam1;
						if ( w < 5 ) w = 5;
						SetTabWidth( i , w );
						_Update();
						UpdateTitlePos();
						break;
					}
				}
			}
		}
		public function SetTabCount( count:int ):void
		{
			if ( count < 1 ) count = 1;
			if ( m_vecTitle.length > count )
			{
				for ( var i:int = count ; i < m_vecTitle.length ; i ++ )
				{
					m_vecTitle[i].Release();
					m_vecTitleDrag[i].Release();
					for ( var j:int = 0 ; j < m_vecObj.length ; j ++ )
					{
						var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ j ] as ListBoxLineData).vecObj;
						OnListRelease( j , i );
						lineData[i].Release();
					}
				}
				for ( j = 0 ; j < m_vecObj.length ; j ++ )
				{
					lineData = (m_vecObj[ j ] as ListBoxLineData).vecObj;
					lineData.length = count;
				}
			}
			m_vecTitle.length = count;
			m_vecTitleDrag.length = count;
			m_vecTitleWidthPersent.length = count;
			var x:int = 0;
			for ( i = 0 ; i < m_vecTitle.length ; i ++ )
			{
				if ( m_vecTitle[i] == null )
				{
					m_vecTitle[i] = new dUIListBoxTitle( this );
					m_vecTitle[i].SetUIEventFunction( _OnTitleButtonEvent );
					m_vecTitle[i].SetAlignVertical( GetAlignType( 0 ) );
					//m_vecTitle[i].SetText( "列" + (i + 1) );
					//var pTitleData:TitleData = new TitleData();
					//m_vecTitle[i].SetUserData( pTitleData );
					//m_vecTitle[i].SetSize( 30 , m_nTabHeight );
					m_vecTitle[i].SetShow( isStyleData( "ShowTitle" ) );
					m_vecTitle[i].LoadFromImageSet( m_strButtonSkinName );
					
					for ( j = 0 ; j < m_vecObj.length ; j ++ )
					{
						lineData = (m_vecObj[ j ] as ListBoxLineData).vecObj;
						lineData[i] = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_LISTBOXOBJ , GetClient() , true , GetObjType() ) as dUIListBoxObj;
						lineData[i].SetListBox( this );
					}
				}
			}
			for ( i = 0 ; i < m_vecTitleDrag.length ; i ++ )
			{
				if ( m_vecTitleDrag[i] == null )
				{
					m_vecTitleDrag[i] = new dUIImageButton( this );
					m_vecTitleDrag[i].SetSize( 10 , m_nTabHeight );
					m_vecTitleDrag[i].SetShow( isStyleData( "ShowTitle" ) );
				}
				m_vecTitleDrag[i].SetUIEventFunction( _OnTitleButtonDrag );
			}
			ComputeWidthPersent();
			for ( i = 0 ; i < m_vecTitle.length ; i ++ )
				m_vecTitleWidthPersent[i] = 1.0 / Number( m_vecTitle.length );
			for ( i = 0 ; i < m_vecObj.length ; i ++ )
			{
				(m_vecObj[i] as ListBoxLineData).vecObj.length = m_vecTitle.length;
			}
			UpdateTitlePos();
			_Update();
			_UpdateLineBackImage();
		}
		public function GetTabCount():int
		{
			return m_vecTitle.length;
		}
		public function SetTabName( tabIndex:int , strName:String ):void
		{
			if ( tabIndex >= 0 && tabIndex < m_vecTitle.length )
				m_vecTitle[tabIndex].SetText( strName );
		}
		public function GetTabName( tabIndex:int ):String
		{
			if ( tabIndex >= 0 && tabIndex < m_vecTitle.length )
				return m_vecTitle[tabIndex].GetText();
			return "";
		}
		public function SetTabCanSort( tabIndex:int , bCanSort:Boolean ):void
		{
			if ( tabIndex >= 0 && tabIndex < m_vecTitle.length )
				m_vecTitle[tabIndex].SetShowSortIcon( bCanSort? 2 : 0 );
		}
		public function GetTabCanSort( tabIndex:int ):Boolean
		{
			if ( tabIndex >= 0 && tabIndex < m_vecTitle.length )
				return m_vecTitle[tabIndex].GetShowSortIcon() != 0;
			return false;
		}
		public function SetTabShowSortIcon( tabIndex:int , bShow:Boolean ):void
		{
			//if ( tabIndex >= 0 && tabIndex < m_vecTitle.length )
			//	(m_vecTitle[tabIndex].GetUserData() as TitleData).bShowSortIcon = bShow;
		}
		public function GetTabShowSortIcon( tabIndex:int ):Boolean
		{
			//if ( tabIndex >= 0 && tabIndex < m_vecTitle.length )
			//	return (m_vecTitle[tabIndex].GetUserData() as TitleData).bShowSortIcon;
			return false;
		}
		public function SetToBottom():void
		{
			if ( m_bNeedUpdate ) Update();
			m_pScrollBar.SetToBottom();
		}
		public function SetToTop():void
		{
			if ( m_bNeedUpdate ) Update();
			m_pScrollBar.SetToTop();
		}
		public function SetSortMethodFunction( nTab:int , pSortFunction:Function ):void
		{
			if ( !m_arrSortFunction ) m_arrSortFunction = new Array;
			m_arrSortFunction[ nTab ] = pSortFunction;
		}
		protected function GetLineID( lineData:Vector.<dUIListBoxObj> ):int
		{
			for ( var i:int = 0 ; i < m_vecObj.length ; i ++ )
			{
				if ( lineData == (m_vecObj[i] as ListBoxLineData).vecObj )
					return i;
			}
			return -1;
		}
		public function SortTab( tabIndex:int , bSmallToBig:Boolean ):void
		{
			var nSmallToBig:int = 1;
			if ( bSmallToBig ) nSmallToBig = -1;
			m_vecObj = m_vecObj.sort( function( a:ListBoxLineData , b:ListBoxLineData ):int
			{
				if ( m_arrSortFunction && m_arrSortFunction[tabIndex] )
					return m_arrSortFunction[tabIndex] ( GetLineID( a.vecObj ) , GetLineID( b.vecObj ) ) * nSmallToBig;
				if( a.vecObj[tabIndex].m_pData )
					var s1:String = a.vecObj[tabIndex].m_pData.GetText();
				if( b.vecObj[tabIndex].m_pData )
					var s2:String = b.vecObj[tabIndex].m_pData.GetText();
				if ( !isNaN(Number(s1)) && !isNaN(Number(s2)) )
				{
					if ( int(s1) == int(s2) )
						return 0;
					return ((int(s1) < int(s2))? -1:1) * nSmallToBig;
				}
				return dUISuperText.compareString( s1 , s2 ) * nSmallToBig;
			} );
			_Update();
		}
		public function SetMaxListNum( maxNum:int ):void
		{
			m_nMaxListNum = maxNum;
		}
		public function GetMaxListNum():int
		{
			return m_nMaxListNum;
		}
		public function GetCurSel():int
		{
			return m_nCurSel;
		}
		public function GetCurSelTab():int
		{
			return m_nCurSelTab;
		}
		public function SetCurSel( nSel:int , nTab:int ):void
		{
			if ( m_bNeedUpdate ) Update();
			if ( nSel <= -1 )
			{
				m_pSelection.SetShow( false );
				m_nCurSel = -1;
				m_nCurSelTab = 0;
			}
			else
			{
				if ( nSel > m_vecObj.length - 1) nSel = m_vecObj.length - 1;
				if ( nTab < 0 ) nTab = 0;
			}
			if ( nSel != m_nCurSel && nSel >= 0 && nSel < m_vecObj.length )
			{
				m_nCurSel = nSel;
				m_nCurSelTab = nTab;
				var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ nSel ] as ListBoxLineData).vecObj;
				if ( nTab > lineData.length - 1 )
					nTab = lineData.length - 1;
				if ( lineData[nTab] )
				{
					OnListBoxObjSelected( lineData[nTab] , 0 );
					var x:int = lineData[nTab].GetPosX();
					var y:int = lineData[nTab].GetPosY();
					var h:int = lineData[nTab].GetHeight();
					m_pScrollBar.SetInView( x , y , h );
				}
			}
		}
		private function UpdateSelection():void
		{
			if ( m_nCurSel >= 0 )
			{
				var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ m_nCurSel ] as ListBoxLineData).vecObj;
				if ( lineData[m_nCurSelTab] )
				{
					OnListBoxObjSelected( lineData[m_nCurSelTab] , 0 );
				}
			}
		}
		private function ComputeWidthPersent():void
		{
			if ( m_bNeedUpdate ) Update();
			var viewWidth:int = m_pScrollBar.GetView().GetWidth();
			if ( viewWidth )
			{
				for ( var i:int = 0 ; i < m_vecTitle.length ; i ++ )
					m_vecTitleWidthPersent[i] = Number(m_vecTitle[i].GetWidth()) / Number(viewWidth);
			}
		}
		public function SetTabWidth( tabIndex:int , width:int ):void
		{
			if ( m_bNeedUpdate ) Update();
			if ( m_vecTitle.length == 1 ) width = m_pScrollBar.GetView().GetWidth();
			if ( tabIndex >= 0 && tabIndex < m_vecTitle.length )
			{
				m_vecTitle[tabIndex].SetSize( width , m_nTabHeight );
				ComputeWidthPersent();
				UpdateTitlePos();
				_Update();
			}
		}
		public function GetTabWidth( tabIndex:int ):int
		{
			if ( m_bNeedUpdate ) Update();
			if ( tabIndex >= 0 && tabIndex < m_vecTitle.length )
				return m_vecTitle[tabIndex].GetWidth();
			return 0;
		}
		public function SetTabHeight( height:int ):void
		{
			m_nTabHeight = height;
			_Update();
		}
		protected function CreateListBoxObj( line:int = -1 ):void
		{
			if ( line == -1 )
			{
				for ( var i:int = 0 ; i < m_vecObj.length ; i ++ )
				{
					var lineData:Vector.<dUIListBoxObj> = (m_vecObj[i] as ListBoxLineData).vecObj;
					for ( var j:int = 0 ; j < lineData.length ; j ++ )
					{
						if ( lineData[j] == null )
						{
							lineData[j] = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_LISTBOXOBJ , GetClient() , true , GetObjType() ) as dUIListBoxObj;
							lineData[j].SetListBox( this );
							lineData[j].SetTooltip( GetTooltip() );
						}
					}
				}
			}
			else
			{
				lineData = (m_vecObj[line] as ListBoxLineData).vecObj;
				for ( j = 0 ; j < lineData.length ; j ++ )
				{
					if ( lineData[j] == null )
					{
						lineData[j] = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_LISTBOXOBJ , GetClient() , true , GetObjType() ) as dUIListBoxObj;
						lineData[j].SetListBox( this );
						lineData[j].SetTooltip( GetTooltip() );
					}
				}
			}
		}
		private var m_bNeedUpdate:Boolean = false;
		public function AddList( obj:dUIImage , tabIndex:int , line:int , bSetToBottom:Boolean = false ):int
		{
			if ( line > m_vecObj.length ) line = m_vecObj.length;
			//obj.SetFather( m_pScrollBar.GetClient() );
			//obj.SetSize( m_vecTitle[tabIndex].GetWidth() , obj.GetHeight() );
			//obj.SetUIEventFunction( _OnListBoxObjEvent );
			//obj.SetHandleMouse( isHandleMouse() );
			if ( line == -1 ) line = m_vecObj.length;
			var lineData:ListBoxLineData = m_vecObj[ line ] as ListBoxLineData;
			if ( !lineData )
			{
				lineData = new ListBoxLineData();
				lineData.vecObj = new Vector.<dUIListBoxObj>;
				lineData.vecObj.length = m_vecTitle.length;
				m_vecObj[ line ] = lineData;
				CreateListBoxObj( line );
				UpdateLineBackImage( line );
			}
			lineData.vecObj.length = m_vecTitle.length;
			if ( tabIndex >= 0 && tabIndex < lineData.vecObj.length )
			{
				var pOldTooltip:Object;
				var pOldUserData:Object;
				if ( lineData.vecObj[ tabIndex ] )
				{
					pOldTooltip = lineData.vecObj[ tabIndex ].GetTooltip();
					pOldUserData = lineData.vecObj[ tabIndex ].GetUserData();
					if( lineData.vecObj[ tabIndex ].m_pData && lineData.vecObj[ tabIndex ].m_pData != obj )
						lineData.vecObj[ tabIndex ].ReleaseData();
				}
				if ( obj.GetTooltip() == null ) obj.SetTooltip( pOldTooltip );
				if ( obj.GetUserData() == null ) obj.SetUserData( pOldUserData );
				lineData.vecObj[ tabIndex ].m_pData = obj;
				obj.SetFather( lineData.vecObj[ tabIndex ] );
			}
			_Update( function():void
			{
				if ( bSetToBottom ) SetToBottom();
			});
			return line;
		}
		public function RemoveList( tabIndex:int , line:int ):int
		{
			if ( line >= 0 && line < m_vecObj.length )
			{
				var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ line ] as ListBoxLineData).vecObj;
				if ( tabIndex >= 0 && tabIndex < lineData.length && lineData[ tabIndex ] && lineData[ tabIndex ].m_pData )
				{
					lineData[tabIndex].ReleaseData();
					return 1;
				}
			}
			return 0;
		}
		public function InsertList( obj:dUIImage , tabIndex:int , line:int , bSetToBottom:Boolean = false ):void
		{
			if ( tabIndex < 0 || tabIndex >= m_vecTitle.length ) return;
			obj.SetFather( m_pScrollBar.GetClient() );
			obj.SetSize( m_vecTitle[tabIndex].GetWidth() , obj.GetHeight() );
			if ( line > m_vecObj.length )
				line = m_vecObj.length;
			for ( var i:int = m_vecObj.length - 1; i >= line ; i -- )
			{
				m_vecObj[i + 1] = m_vecObj[i];
			}
			m_vecObj[ line ] = null;
			AddList( obj , tabIndex , line , bSetToBottom );
			_UpdateLineBackImage();
		}
		private function GetData( tabIndex:int , line:int ):dUIImage
		{
			if ( line >= 0 && line < m_vecObj.length )
			{
				var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ line ] as ListBoxLineData).vecObj;
				if ( tabIndex >= 0 && tabIndex < lineData.length && lineData[ tabIndex ] && lineData[ tabIndex ].m_pData )
					return lineData[ tabIndex ].m_pData;
			}
			return null;
		}
		public function AddString( str:String , tabIndex:int , line:int , bSetToBottom:Boolean = true ):int
		{
			if ( line != -1 )
			{
				if ( str != "" && GetString( tabIndex , line ) == str )
				{
					if( bSetToBottom ) m_pScrollBar.SetToBottom();
					return line;
				}
				var pObj:dUIImage = GetData( tabIndex , line );
				if ( pObj && pObj.GetObjType() == dUISystem.GUIOBJ_TYPE_SUPPERTEXT )
				{
					pObj.SetText( str );
					if ( isStyleData( "AutoEnterLine" ) )
						pObj.SetStyleData( "AutoSetSize" , true );
					else
						(pObj as dUISuperText).SetSizeAsText();
					_Update( function():void
					{
						if ( bSetToBottom ) m_pScrollBar.SetToBottom();
					});
					return line;
				}
			}
			var p:dUISuperText = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_SUPPERTEXT , m_pScrollBar.GetClient() , true , GetObjType() ) as dUISuperText;
			p.SetAlignType( GetAlignType( tabIndex ) );
			p.SetText( str );
			p.SetStyleData( "AutoEnterLine" , isStyleData( "AutoEnterLine" ) );
			if ( isStyleData( "AutoEnterLine" ) )
				p.SetStyleData( "AutoSetSize" , true );
			else
				p.SetSizeAsText();
			p.SetPos( 0 , 0 );
			var ret:int = AddList( p , tabIndex , line , bSetToBottom );
			return ret;
		}
		public function AddStringCommand( str:String , tabIndex:int , line:int , bSetToBottom:Boolean = true ):int
		{
			if ( line == -1 ) line = m_vecObj.length;
			var lineData:ListBoxLineData = m_vecObj[ line ] as ListBoxLineData;
			if ( !lineData )
			{
				lineData = new ListBoxLineData();
				lineData.vecObj = new Vector.<dUIListBoxObj>;
				lineData.vecObj.length = m_vecTitle.length;
				m_vecObj[ line ] = lineData;
				CreateListBoxObj( line );
			}
			lineData.vecObj.length = m_vecTitle.length;
			var p:AddStringCmd = new AddStringCmd();
			p.str = str;
			p.tabIndex = tabIndex;
			p.line = line;
			p.bSetToBottom = bSetToBottom;
			m_vecAddStringCommand.push( p );
			if ( !m_bFrameMove )
			{
				m_bFrameMove = true;
				GetImageRoot()._RegEnterFrameLoop( _OnFrameMove , this );
			}
			return line;
		}
		private var m_nFrameMoveUpdateTimeAdd:int;
		private function _OnFrameMove():void
		{
			var num:int = m_vecTitle.length;
			//if ( num > 5 ) num = 5;
			m_bCommandAdding_NoUpdate = true;
			for ( var i:int = 0 ; i < num ; i ++ )
			{
				if ( m_vecAddStringCommand.length )
				{
					AddString( m_vecAddStringCommand[0].str , m_vecAddStringCommand[0].tabIndex , m_vecAddStringCommand[0].line ,
						m_vecAddStringCommand[0].bSetToBottom );
					m_vecAddStringCommand.splice( 0 , 1 );
					if ( m_vecAddStringCommand.length == 0 )
					{
						GetImageRoot()._UnregEnterFrameLoop( _OnFrameMove );
						m_bFrameMove = false;
						m_bCommandAdding_NoUpdate = false;
						_Update();
						break;
					}
				}
			}
			m_bCommandAdding_NoUpdate = false;
			if ( m_vecAddStringCommand.length > 100 * num )
			{
				m_nFrameMoveUpdateTimeAdd += GetImageRoot().GetTimeSinceLastFrame();
				if ( m_nFrameMoveUpdateTimeAdd > 1000 )
				{
					_Update();
					m_nFrameMoveUpdateTimeAdd = 0;
				}
			}
			else _Update();
		}
		public function InsertString( str:String , tabIndex:int , line:int ):void
		{
			var p:dUISuperText = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_SUPPERTEXT , m_pScrollBar.GetClient() , true , GetObjType() ) as dUISuperText;
			p.SetStyleData( "AutoEnterLine" , isStyleData( "AutoEnterLine" ) );
			p.SetAlignType( GetAlignType( tabIndex ) );
			p.SetText( str );
			p.SetPos( 0 , 0 );
			p.SetSizeAsText();
			InsertList( p , tabIndex , line );
		}
		override public function GetClient():dUIImage
		{
			return m_pScrollBar.GetClient();
		}
		public function GetString( tabIndex:int , line:int ):String
		{
			if ( line >= 0 && line < m_vecObj.length )
			{
				var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ line ] as ListBoxLineData).vecObj;
				if ( tabIndex >= 0 && tabIndex < lineData.length && lineData[ tabIndex ] && lineData[ tabIndex ].m_pData )
					return lineData[ tabIndex ].m_pData.GetText();
			}
			return "";
		}
		public function GetList( tabIndex:int , line:int ):dUIListBoxObj
		{
			if ( line >= 0 && line < m_vecObj.length )
			{
				var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ line ] as ListBoxLineData).vecObj;
				if ( tabIndex >= 0 && tabIndex < lineData.length && lineData[ tabIndex ] )
					return lineData[ tabIndex ];
			}
			return null;
		}
		public function GetListID( tabIndex:int , line:int ):int
		{
			if ( line >= 0 && line < m_vecObj.length )
			{
				var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ line ] as ListBoxLineData).vecObj;
				if ( tabIndex >= 0 && tabIndex < lineData.length && lineData[ tabIndex ] )
					return lineData[ tabIndex ].m_pData.GetID();
			}
			return 0;
		}
		private function OnListRelease( nLine:int , nTab:int ):void
		{
			var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ nLine ] as ListBoxLineData).vecObj;
			if ( s_pCurrentTooltip && lineData[nTab].m_pData == s_pCurrentTooltip )
			{
				if( lineData[nTab].m_pData.GetTooltip() )
					FireEvent( dUISystem.GUIEVENT_TYPE_ON_SHOW_TOOLTIP , 0 , 0 , "hide" , lineData[nTab].m_pData.GetTooltip() );
				s_pCurrentTooltip = null;
			}
		}
		public function ClearString( bDeleteData:Boolean = true ):void
		{
			m_vecAddStringCommand.length = 0;
			for ( var i:int = 0 ; i < m_vecObj.length ; i ++ )
			{
				var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ i ] as ListBoxLineData).vecObj;
				for ( var j:int = 0 ; j < lineData.length ; j ++ )
				{
					if ( lineData[j] )
					{
						if ( !bDeleteData ) lineData[j].m_pData = null;
						OnListRelease( i , j );
						lineData[j].Release();
					}
				}
				if( (m_vecObj[i] as ListBoxLineData).pBack )
					(m_vecObj[i] as ListBoxLineData).pBack.Release();
			}
			m_vecObj.length = 0;
			m_nCurSel = -1;
			m_pSelection.SetShow( false );
			m_pSelectOver.SetShow( false );
			m_pScrollBar.SetClientPos( 0 , 0 );
			Update();
		}
		override public function SetHandleMouse( bSet:Boolean ):void
		{
			super.SetHandleMouse( bSet );
			for ( var i:int = 0 ; i < m_vecObj.length ; i ++ )
			{
				var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ i ] as ListBoxLineData).vecObj;
				for ( var j:int = 0 ; j < lineData.length ; j ++ )
					lineData[j].SetHandleMouse( bSet );
			}
		}
		public function GetListCount():int
		{
			return m_vecObj.length;
		}
		public function SetListCount( nLineCount:int ):void
		{
			if ( nLineCount < 0 ) nLineCount = 0;
			while( m_vecObj.length > nLineCount )
			{
				DelList( m_vecObj.length - 1 );
			}
			for ( var i:int = m_vecObj.length ; i < nLineCount ; i ++ )
			{
				AddString( "" , 0 , i , false );
			}
		}
		public function DelList( line:int ):void
		{
			if ( line >= 0 && line < m_vecObj.length )
			{
				var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ line ] as ListBoxLineData).vecObj;
				for ( var j:int = 0 ; j < lineData.length ; j ++ )
				{
					if ( lineData[j] )
					{
						OnListRelease( line , j );
						lineData[j].Release();
					}
				}
				if ( (m_vecObj[line] as ListBoxLineData).pBack )
					(m_vecObj[line] as ListBoxLineData).pBack.Release();
				m_vecObj[ line ] = null;
				m_vecObj.splice( line , 1 );
				_UpdateLineBackImage();
			}
			if ( line == m_nCurSel || m_nCurSel >= m_vecObj.length )
			{
				m_nCurSel = -1;
				m_pSelection.SetShow( false );
			}
			_Update();
		}
		public function DelListObj( pDel:dUIImage , bRelease:Boolean = true ):void
		{
			for ( var i:int = 0 ; i < m_vecObj.length ; i ++ )
			{
				var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ i ] as ListBoxLineData).vecObj;
				for ( var j:int = 0 ; j < lineData.length ; j ++ )
				{
					if ( lineData[j].m_pData == pDel )
					{
						if ( bRelease ) lineData[j].ReleaseData();
						//lineData[j].m_pData.Release();
						lineData[j].m_pData = null;
						var bEmpty:Boolean = true;
						for ( j = 0 ; j < lineData.length ; j ++ )
						{
							if ( lineData[j].m_pData )
							{
								bEmpty = false;
								break;
							}
						}
						if ( bEmpty )
							DelList( i );
						return;
					}
				}
			}
		}
		override public function SetSize( w:int , h:int ):void
		{
			if ( GetWidth() != w || GetHeight() != h )
			{
				super.SetSize( w , h );
				UpdateTitlePos();
				m_bNeedUpdate = true;
				Update();
				_UpdateLineBackImage();
				if ( GetWidth() )
				{
					super.SetSize( w , h );
					var viewWidth:int = m_pScrollBar.GetView().GetWidth();
					for ( var i:int = 0 ; i < m_vecTitle.length ; i ++ )
					{
						m_vecTitle[i].SetSize( int(m_vecTitleWidthPersent[i]*Number(viewWidth)) , m_nTabHeight );
					}
					m_bNeedUpdate = true;
					Update();
				}
			}
		}
		public function GetScrollBarVButtonWidth():int
		{
			if ( m_bNeedUpdate ) Update();
			return m_pScrollBar.GetVButtonWidth();
		}
		public function GetScroll():dUIScroll
		{
			if ( m_bNeedUpdate ) Update();
			return m_pScrollBar;
		}
		override public function GetWidth():int
		{
			if ( m_bNeedUpdate ) Update();
			return super.GetWidth();
		}
		override public function GetHeight():int
		{
			if ( m_bNeedUpdate ) Update();
			return super.GetHeight();
		}
		protected function CheckSize():void
		{
			if ( isStyleData( "AutoSetSize" ) )
			{
				var h:int = m_pScrollBar.GetClient().GetHeight();
				super.SetSize( GetWidth() , h + GetEdgeHeight() );
				//Update();
				//_UpdateLineBackImage();
			}
		}
		override public function isStyleData( name:String ):Boolean
		{
			if ( name == "ShowVScroll" || name == "ShowHScroll" )
				return m_pScrollBar.isStyleData( name );
			return super.isStyleData( name );
		}
		override public function SetStyleData( name:String , bSet:Boolean ):void
		{
			if( name == "ShowVScroll" ||
				name == "ShowHScroll" ||
				name == "AlwaysShowVScroll" ||
				name == "AlwaysShowHScroll" ||
				name == "VScrollMirror" ||
				name == "HScrollMirror" ||
				name == "AutoEnterLine"	||
				name == "ShowTitle" ||
				name == "AutoSetSize" ||
				name == "ShowSelection" ||
				name == "SelectPerTab" ||
				name == "ShowBackImage" ||
				name == "TitleCanDrag" ||
				name == "CanDrag" )
			{
				if ( isStyleData( name ) == bSet ) return;
				super.SetStyleData( name , bSet );
				if ( name == "ShowTitle" )
				{
					_Update();
					var bShow:Boolean = isStyleData( "ShowTitle" );
					for ( var i:int = 0 ; i < m_vecTitle.length ; i ++ )
					{
						m_vecTitle[i].SetShow( bShow );
						m_vecTitleDrag[i].SetShow( bShow );
					}
				}
				else if ( name == "AutoEnterLine" )
				{
					for ( i = 0 ; i < m_vecObj.length ; i ++ )
					{
						var lineData:Vector.<dUIListBoxObj> = (m_vecObj[ i ] as ListBoxLineData).vecObj;				
						for ( var j:int = 0 ; j < lineData.length ; j ++ )
						{
							if ( lineData[j].m_pData )
							{
								lineData[j].m_pData.SetStyleData( "AutoEnterLine" , bSet );
							}
						}
					}
					_Update();
				}
				else if ( name == "ShowHScroll" || name == "ShowVScroll" || name == "AlwaysShowHScroll" || name == "AlwaysShowVScroll" ||
						  name == "VScrollMirror" || name == "HScrollMirror" )
				{
					if ( m_vecTitle.length == 1 )
						SetTabWidth( 0 , 0 );
					m_pScrollBar.SetStyleData( name , bSet );
					UpdateTitlePos();
					_Update();
					_UpdateLineBackImage();
				}
				else if ( name == "ShowSelection" )
				{
					m_pSelection.SetShow( GetCurSel() != -1 );
				}
				else if ( name == "ShowBackImage" )
					_UpdateLineBackImage();
				else if ( name == "AutoSetSize" )
					CheckSize();
			}
		}
		public function _Update( onComplete:Function = null ):void
		{
			if ( !m_bNeedUpdate )
			{
				m_bNeedUpdate = true;
				GetImageRoot()._RegEnterFrame( function():void
				{
					Update();
					if ( onComplete != null ) onComplete();
				});
			}
			//Update();
		}
		public function Update():void
		{
			//if ( !m_bNeedUpdate ) return;
			m_bNeedUpdate = false;
			if ( m_bCommandAdding_NoUpdate ) return;
			var nScrollBarH:int = GetHeight();
			if ( isStyleData( "ShowTitle" ) )
			{
				nScrollBarH -= m_nTabHeight;
				m_pScrollBar.SetPos( GetEdgeLeft() , GetEdgeTop() + m_nTabHeight );
			}
			else
				m_pScrollBar.SetPos( GetEdgeLeft() , GetEdgeTop() );
			m_pScrollBar.SetSize( GetWidth() - GetEdgeWidth() , nScrollBarH - GetEdgeHeight() );
			
			var nScrollViewWidthOld:int = m_pScrollBar.GetView().GetWidth();
			for ( var ii:int = 0 ; ii < 2 ; ii ++ )
			{
				var y:int = 0;
				var x:int = 0;
				var maxHeight:int = 0;
				for ( var i:int = 0 ; i < m_vecObj.length ; i ++ )
				{
					maxHeight = 0;
					var lineData:ListBoxLineData = m_vecObj[ i ] as ListBoxLineData;
					// 先设置m_pData的大小
					for ( var j:int = 0 ; j < lineData.vecObj.length ; j ++ )
					{
						if ( lineData.vecObj[j] )
						{
							if ( lineData.vecObj[j].m_pData )
							{
								lineData.vecObj[j].m_pData.SetSize( m_vecTitle[j].GetWidth() , lineData.vecObj[j].m_pData.GetHeight() );
								//if ( isStyleData( "AutoEnterLine" ) && lineData.vecObj[j].m_pData is dUISuperText )
								//	( lineData.vecObj[j].m_pData as dUISuperText ).SetSizeAsText();
							}
						}
					}
					// 获得每行最大高
					if ( m_nForcePerLineHeight != 0 )
						maxHeight = m_nForcePerLineHeight;
					else
					{
						for ( j = 0 ; j < lineData.vecObj.length ; j ++ )
						{
							if ( lineData.vecObj[j].m_pData )
							{
								if ( maxHeight < lineData.vecObj[j].m_pData.GetHeight() )
									maxHeight = lineData.vecObj[j].m_pData.GetHeight();
							}
						}
					}
					// 设置lineData[j]的大小
					for ( j = 0 ; j < lineData.vecObj.length ; j ++ )
					{
						if ( lineData.vecObj[j] )
						{
							lineData.vecObj[j].SetPos( x , y );
							lineData.vecObj[j].SetSize( m_vecTitle[j].GetWidth() , maxHeight );
							if ( lineData.vecObj[j].m_pData )
								lineData.vecObj[j].m_pData.SetAlignPos( GetAlignType( j ) , lineData.vecObj[j].GetWidth() , lineData.vecObj[j].GetHeight() , 0 , 0 );
						}
						x += m_vecTitle[j].GetWidth();
					}
					if ( lineData.pBack )
						lineData.pBack.SetPos( 0 , y );
					y += maxHeight + m_nPerLineSpace;
					x = 0;
				}
				x = 0;
				for ( i = 0 ; i < m_vecTitle.length ; i ++ )
					x += m_vecTitle[i].GetWidth();
				m_pScrollBar.SetClientSize( x , y );
				
				if ( m_vecTitle.length == 1 )
				{
					var width:int = m_pScrollBar.GetView().GetWidth();
					if ( width != nScrollViewWidthOld )
					{
						m_vecTitle[0].SetSize( width , m_nTabHeight );
						ComputeWidthPersent();
						UpdateTitlePos();
						continue;
					}
				}
				break;
			}
			for ( i = 0 ; i < m_vecObj.length ; i ++ )
			{
				maxHeight = 0;
				lineData = m_vecObj[ i ] as ListBoxLineData;
				// 获得每行最大高
				if ( m_nForcePerLineHeight != 0 ) maxHeight = m_nForcePerLineHeight;
				else
				{
					for ( j = 0 ; j < lineData.vecObj.length ; j ++ )
					{
						if ( lineData.vecObj[j].m_pData )
						{
							if ( maxHeight < lineData.vecObj[j].m_pData.GetHeight() )
								maxHeight = lineData.vecObj[j].m_pData.GetHeight();
						}
					}
				}
				if( lineData.pBack )
					lineData.pBack.SetSize( GetClient().GetWidth() , maxHeight );
			}
			UpdateSelection();
			CheckSize();
			UpdateTitlePos();
		}
		public function _UpdateLineBackImage():void
		{
			GetImageRoot()._RegEnterFrame( UpdateLineBackImage );
		}
		public function UpdateLineBackImage( nLine:int = -1 ):void
		{
			if ( m_strButtonBackName1 && m_strButtonBackName1.length )
			{
				if ( nLine == -1 )
				{
					for ( var i:int = 0 ; i < m_vecObj.length ; i ++ )
					{
						UpdateLineBackImage( i );
					}
				}
				else
				{
					if ( isStyleData( "ShowBackImage" ) )
					{
						var bTile9:Boolean = GetImageRoot().GetImageSet().GetImageRect( m_strButtonBackName1 + "1" , true ) != null;
						if ( !(m_vecObj[nLine] as ListBoxLineData).pBack )
						{
							if ( bTile9 )
								(m_vecObj[nLine] as ListBoxLineData).pBack = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_GROUP , GetClient() , true , GetObjType() ) as dUIGroup;
							else
								(m_vecObj[nLine] as ListBoxLineData).pBack = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_IMAGEBOX , GetClient() , true , GetObjType() ) as dUIImageBox;
							(m_vecObj[nLine] as ListBoxLineData).pBack.MoveBottom();
						}
						var pBack:dUIImage = (m_vecObj[nLine] as ListBoxLineData).pBack;
						if ( (nLine % 2) == 0 )
						{
							if ( bTile9 )
								pBack.LoadFromImageSet( m_strButtonBackName1 + "1," + m_strButtonBackName1 + "2," + m_strButtonBackName1 + "3," + 
									m_strButtonBackName1 + "4," + m_strButtonBackName1 + "5," + m_strButtonBackName1 + "6," +
									m_strButtonBackName1 + "7," + m_strButtonBackName1 + "8," + m_strButtonBackName1 + "9" );
							else
								pBack.LoadFromImageSet( m_strButtonBackName1 );
						}
						else
						{
							if ( bTile9 )
								pBack.LoadFromImageSet( m_strButtonBackName2 + "1," + m_strButtonBackName2 + "2," + m_strButtonBackName2 + "3," + 
									m_strButtonBackName2 + "4," + m_strButtonBackName2 + "5," + m_strButtonBackName2 + "6," +
									m_strButtonBackName2 + "7," + m_strButtonBackName2 + "8," + m_strButtonBackName2 + "9" );
							else
								pBack.LoadFromImageSet( m_strButtonBackName2 );
						}
						pBack.SetShow( true );
					}
					else
					{
						pBack = (m_vecObj[nLine] as ListBoxLineData).pBack;
						if ( pBack ) pBack.SetShow( false );
					}
					if ( pBack )
						pBack.SetSize( GetClient().GetWidth() , pBack.GetHeight() );
				}
			}
		}
		public function SelectionSetSize( pObj:dUIImage , w:int , h:int ):void
		{
			if ( pObj.GetWidth() != w || pObj.GetHeight() != h )
			{
				/*var color:uint;
				if ( pObj == m_pSelection ) color = 0xff72c8c7;
				else if ( pObj == m_pSelectOver ) color = 0xff4e6e65;
				var pSprite:Sprite = new Sprite();
				for ( var k:int = 0 ; k < 3 ; k ++ )
				{
					pSprite.graphics.lineStyle( 1 , color & 0x00ffffff , (k+1) / 3 );
					pSprite.graphics.drawRect( k , k , w - k * 2 - 1 , h - k * 2 - 1 );
				}
				if ( w && h )
				{
					var pBitmapData:BitmapData = new BitmapData( w , h , true , 0 );
					pBitmapData.draw( pSprite );
				}*/
				if ( pObj == m_pSelection )
					pObj.LoadFromImageSet( "列表选中1,列表选中2,列表选中3,列表选中4,列表选中5,列表选中6,列表选中7,列表选中8,列表选中9" );
				else if ( pObj == m_pSelectOver )
					pObj.LoadFromImageSet( "列表移入1,列表移入2,列表移入3,列表移入4,列表移入5,列表移入6,列表移入7,列表移入8,列表移入9" );
				pObj.SetSize( w , h );
			}
		}
		override public function SetMouseStyle( nType:int ):void
		{
			m_pScrollBar.SetMouseStyle( nType );
		}
		override public function GetMouseStyle():int
		{
			return m_pScrollBar.GetMouseStyle();
		}
		public function SetClientPos( x:int , y:int ):void
		{
			if ( m_bNeedUpdate ) Update();
			m_pScrollBar.SetClientPos( x , y );
		}
		public function SetPerLineSpace( nHeight:int ):void
		{
			m_nPerLineSpace = nHeight;
			_Update();
		}
		public function GetPerLineSpace():int
		{
			return m_nPerLineSpace;
		}
		public function SetForcePerLineHeight( nHeight:int ):void
		{
			m_nForcePerLineHeight = nHeight;
			_Update();
		}
		public function GetForcePerLineHeight():int
		{
			return m_nForcePerLineHeight;
		}
		override public function _SetText( str:String ):void
		{
			super._SetText( str );
			var vecName:Vector.<String> = SplitString( str , GetTabCount() , "," );
			for ( var i:int = 0 ; i < vecName.length ; i ++ )
				m_vecTitle[i].SetText( vecName[i] );
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
		public function GetClientHeight():int
		{
			if ( m_bNeedUpdate ) Update();
			return m_pScrollBar.GetClient().GetHeight();
		}
	}

}
import dUI.dUIListBoxObj;
import dUI.dUIImage;
class AddStringCmd
{
	public var str:String;
	public var tabIndex:int;
	public var line:int;
	public var bSetToBottom:Boolean;
}
class TitleData
{
	public var bCanSort:Boolean = false;
	public var bShowSortIcon:Boolean = false;
	public var bSmallToBig:Boolean = false;
}
class ListBoxLineData
{
	public var vecObj:Vector.<dUIListBoxObj>;
	public var pBack:dUIImage;
}