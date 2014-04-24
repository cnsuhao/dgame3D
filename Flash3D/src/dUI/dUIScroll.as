//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIScroll extends dUIImage
	{
		protected var m_pClient:dUIImage;
		//protected var m_pClientMouseWheel:dUIImageBox;
		protected var m_pView:dUIImage;
		protected var m_pArrowUp:dUIImageButton;
		protected var m_pArrowDown:dUIImageButton;
		protected var m_pBackV:dUIButtonV3;
		protected var m_pButtonV:dUIButtonV3;
		protected var m_pArrowLeft:dUIImageButton;
		protected var m_pArrowRight:dUIImageButton;
		protected var m_pBackH:dUIButtonH3;
		protected var m_pButtonH:dUIButtonH3;
		protected var m_pButtonHFather:dUIImage;
		protected var m_pButtonVFather:dUIImage;
		protected var m_nButtonHOffsetY:int = 0;
		protected var m_nButtonVOffsetX:int = 0;
		public function dUIScroll( pFather:dUIImage ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_SCROLL;
			m_pView = new dUIImage( this , true );
			//m_pClientMouseWheel = new dUIImageBox( m_pView );
			//m_pClientMouseWheel.SetObjType( dUISystem.GUIOBJ_TYPE_SCROLL );
			//m_pClientMouseWheel.SetHandleMouse( true );
			m_pClient = new dUIScrollClient( m_pView , this );
			m_pArrowUp = new dUIImageButton( this );
			m_pArrowDown = new dUIImageButton( this );
			m_pArrowLeft = new dUIImageButton( this );
			m_pArrowRight = new dUIImageButton( this );
			m_pBackV = new dUIButtonV3( this );
			m_pButtonVFather = new dUIImage( this );
			m_pButtonV = new dUIButtonV3( m_pButtonVFather );
			m_pBackH = new dUIButtonH3( this );
			m_pButtonHFather = new dUIImage( this );
			m_pButtonH = new dUIButtonH3( m_pButtonHFather );
			m_pButtonV.SetUIEventFunction( _OnButtonDragV );
			m_pButtonH.SetUIEventFunction( _OnButtonDragH );
			m_pBackV.SetUIEventFunction( _OnButtonEvent );
			m_pBackH.SetUIEventFunction( _OnButtonEvent );
			m_pArrowLeft.SetUIEventFunction( _OnButtonEvent );
			m_pArrowRight.SetUIEventFunction( _OnButtonEvent );
			m_pArrowUp.SetUIEventFunction( _OnButtonEvent );
			m_pArrowDown.SetUIEventFunction( _OnButtonEvent );
			LoadFromImageSet( "" );
			var pImageSet:dUIImageSet = GetImageRoot().GetImageSet();
			var rc:dUIImageRect = pImageSet.GetImageRect( "滚动条按钮偏移" );
			m_nButtonVOffsetX = rc.left;
			m_nButtonHOffsetY = rc.top;
			//RegMouseLowEvent( true );
			//SetHandleMouse( true );
			
			SetStyleData( "ShowHScroll" , true );
			SetStyleData( "ShowVScroll" , true );
			SetStyleData( "CanMouseWheel" , true );
		}
		override public function GetDefaultSkin():String
		{
			return "竖滚动条箭头正常上,竖滚动条箭头发亮上,竖滚动条箭头按下上,竖滚动条箭头无效上,\
竖滚动条箭头正常下,竖滚动条箭头发亮下,竖滚动条箭头按下下,竖滚动条箭头无效下,\
横滚动条箭头正常上,横滚动条箭头发亮上,横滚动条箭头按下上,横滚动条箭头无效上,\
横滚动条箭头正常下,横滚动条箭头发亮下,横滚动条箭头按下下,横滚动条箭头无效下,\
竖滚动条正常上,竖滚动条发亮上,竖滚动条按下上,竖滚动条无效上,\
竖滚动条正常中,竖滚动条发亮中,竖滚动条按下中,竖滚动条无效中,\
竖滚动条正常下, 竖滚动条发亮下, 竖滚动条按下下, 竖滚动条无效下,\
竖滚动条按钮正常上,竖滚动条按钮发亮上,竖滚动条按钮按下上,竖滚动条按钮无效上,\
竖滚动条按钮正常中,竖滚动条按钮发亮中,竖滚动条按钮按下中,竖滚动条按钮无效中,\
竖滚动条按钮正常下, 竖滚动条按钮发亮下, 竖滚动条按钮按下下, 竖滚动条按钮无效下,\
横滚动条正常上,横滚动条发亮上,横滚动条按下上,横滚动条无效上,\
横滚动条正常中,横滚动条发亮中,横滚动条按下中,横滚动条无效中,\
横滚动条正常下, 横滚动条发亮下, 横滚动条按下下, 横滚动条无效下,\
横滚动条按钮正常上,横滚动条按钮发亮上,横滚动条按钮按下上,横滚动条按钮无效上,\
横滚动条按钮正常中,横滚动条按钮发亮中,横滚动条按钮按下中,横滚动条按钮无效中,\
横滚动条按钮正常下, 横滚动条按钮发亮下, 横滚动条按钮按下下, 横滚动条按钮无效下";
		}
		override public function _LoadFromImageSet( str:String ):void
		{
			var arr:Vector.<String> = SplitName( str , 64 , false );
			m_pArrowUp.LoadFromImageSet( arr[0] + "," + arr[1] + "," + arr[2] + "," + arr[3] );
			m_pArrowDown.LoadFromImageSet( arr[4] + "," + arr[5] + "," + arr[6] + "," + arr[7] );
			m_pArrowLeft.LoadFromImageSet( arr[8] + "," + arr[9] + "," + arr[10] + "," + arr[11] );
			m_pArrowRight.LoadFromImageSet( arr[12] + "," + arr[13] + "," + arr[14] + "," + arr[15] );
			m_pBackV.LoadFromImageSet( arr[16] + "," + arr[17] + "," + arr[18] + "," + arr[19] + "," +
									   arr[20] + "," + arr[21] + "," + arr[22] + "," + arr[23] + "," +
									   arr[24] + "," + arr[25] + "," + arr[26] + "," + arr[27] );
			m_pButtonV.LoadFromImageSet( arr[28] + "," + arr[29] + "," + arr[30] + "," + arr[31] + "," +
										 arr[32] + "," + arr[33] + "," + arr[34] + "," + arr[35] + "," +
										 arr[36] + "," + arr[37] + "," + arr[38] + "," + arr[39] );
			m_pBackH.LoadFromImageSet( arr[40] + "," + arr[41] + "," + arr[42] + "," + arr[43] + "," +
									   arr[44] + "," + arr[45] + "," + arr[46] + "," + arr[47] + "," +
									   arr[48] + "," + arr[49] + "," + arr[50] + "," + arr[51] );
			m_pButtonH.LoadFromImageSet( arr[52] + "," + arr[53] + "," + arr[54] + "," + arr[55] + "," +
										 arr[56] + "," + arr[57] + "," + arr[58] + "," + arr[59] + "," +
										 arr[60] + "," + arr[61] + "," + arr[62] + "," + arr[63] );
		}
		private function _OnButtonDragV( event:dUIEvent ):void
		{
			if ( m_pBackV.isShow() )
			{
				var y:int = m_pButtonV.GetPosY() + event.nParam2;
				if ( y < 0 ) y = 0;
				else if ( y > m_pBackV.GetHeight() - m_pButtonV.GetHeight() ) y = m_pBackV.GetHeight() - m_pButtonV.GetHeight();
				m_pButtonV.SetPos( m_pButtonV.GetPosX() , y );
				var t:int = m_pBackV.GetHeight() - m_pButtonV.GetHeight();
				m_pClient.SetPos( m_pClient.GetPosX() , -y * (m_pClient.GetHeight() - m_pView.GetHeight()) / t );
				if( event.nParam2 != 0 )
					FireEvent( dUISystem.GUIEVENT_TYPE_SCROLL_DRAG , 0 , event.nParam1 );
			}
			else m_pClient.SetPos( m_pClient.GetPosX() , 0 );
		}
		private function _OnButtonDragH( event:dUIEvent ):void
		{
			if ( m_pBackH.isShow() )
			{
				var x:int = m_pButtonH.GetPosX() + event.nParam1;
				if ( x < 0 ) x = 0;
				else if ( x > m_pBackH.GetWidth() - m_pButtonH.GetWidth() ) x = m_pBackH.GetWidth() - m_pButtonH.GetWidth();
				m_pButtonH.SetPos( x , m_pButtonH.GetPosY() );
				var t:int = m_pBackH.GetWidth() - m_pButtonH.GetWidth();
				m_pClient.SetPos( -x * (m_pClient.GetWidth() - m_pView.GetWidth()) / t , m_pClient.GetPosY() );
				if( event.nParam1 != 0 )
					FireEvent( dUISystem.GUIEVENT_TYPE_SCROLL_DRAG , event.nParam1 , 0 );
			}
			else m_pClient.SetPos( 0 , m_pClient.GetPosY() );
		}
		public function CheckButtonPos():void
		{
			CheckClientPos();
		}
		private function CheckButtonPosV():void
		{
			if ( m_pBackV.isShow() )
			{
				var y:int = m_pButtonV.GetPosY();
				if ( y > m_pBackV.GetHeight() - m_pButtonV.GetHeight() )
				{
					y = m_pBackV.GetHeight() - m_pButtonV.GetHeight();
					m_pButtonV.SetPos( m_pButtonV.GetPosX() , y );
					t = m_pBackV.GetHeight() - m_pButtonV.GetHeight();
					m_pClient.SetPos( m_pClient.GetPosX() , -y * (m_pClient.GetHeight() - m_pView.GetHeight()) / t );
				}
				if ( y < 0 )
				{
					y = 0;
					m_pButtonV.SetPos( m_pButtonV.GetPosX() , y );
					var t:int = m_pBackV.GetHeight() - m_pButtonV.GetHeight();
					m_pClient.SetPos( m_pClient.GetPosX() , -y * (m_pClient.GetHeight() - m_pView.GetHeight()) / t );
				}
			}
			else m_pClient.SetPos( m_pClient.GetPosX() , 0 );
		}
		private function CheckButtonPosH():void
		{
			if ( m_pBackH.isShow() )
			{
				var x:int = m_pButtonH.GetPosX();
				if ( x > m_pBackH.GetWidth() - m_pButtonH.GetWidth() )
				{
					x = m_pBackH.GetWidth() - m_pButtonH.GetWidth();
					m_pButtonH.SetPos( x , m_pButtonH.GetPosY() );
					t = m_pBackH.GetWidth() - m_pButtonH.GetWidth();
					m_pClient.SetPos( -x * (m_pClient.GetWidth() - m_pView.GetWidth()) / t , m_pClient.GetPosY() );
				}
				if ( x < 0 )
				{
					x = 0;
					m_pButtonH.SetPos( x , m_pButtonH.GetPosY() );
					var t:int = m_pBackH.GetWidth() - m_pButtonH.GetWidth();
					m_pClient.SetPos( -x * (m_pClient.GetWidth() - m_pView.GetWidth()) / t , m_pClient.GetPosY() );
				}
			}
			else m_pClient.SetPos( 0 , m_pClient.GetPosY() );
		}
		private function _OnButtonEvent( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_BUTTON_DOWN )
			{
				var x:int = 0;
				var y:int = 0;
				if ( event.pObj == m_pArrowUp )
					y = 20;
				else if ( event.pObj == m_pArrowDown )
					y = -20;
				else if ( event.pObj == m_pArrowLeft )
					x = 20;
				else if ( event.pObj == m_pArrowRight )
					x = -20;
				if ( x || y )
				{
					SetClientPos( GetClient().GetPosX() + x , GetClient().GetPosY() + y );
					FireEvent( dUISystem.GUIEVENT_TYPE_SCROLL_DRAG , x , y );
				}
			}
			else if ( event.type == dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED )
				ComputeButtonSize();
		}
		override public function SetStyleData( name:String , bSet:Boolean ):void
		{
			if( name == "ShowHScroll" ||
				name == "ShowVScroll" ||
				name == "AlwaysShowHScroll" ||
				name == "AlwaysShowVScroll" ||
				name == "HScrollMirror" ||
				name == "VScrollMirror" ||
				name == "CanMouseWheel" )
			{
				super.SetStyleData( name , bSet );
				if( name == "ShowHScroll" || name == "ShowVScroll" || name == "AlwaysShowHScroll" || name == "AlwaysShowVScroll" || name == "HScrollMirror" || name == "VScrollMirror" )
					ComputeButtonSize();
			}
		}
		public function SetToBottom():void
		{
			_OnButtonDragV( new dUIEvent( 0 , dUISystem.GUIEVENT_TYPE_BUTTON_DRAG , 0 , 0x40000000 ) );
		}
		public function SetToTop():void
		{
			_OnButtonDragV( new dUIEvent( 0 , dUISystem.GUIEVENT_TYPE_BUTTON_DRAG , 0 , -0x40000000 ) );
		}
		override public function SetAutoSizeAsChild( bSet:Boolean ):void
		{
			m_pClient.SetAutoSizeAsChild( bSet );
		}
		override public function SetSize( w:int , h:int ):void
		{
			if ( w != GetWidth() || h != GetHeight() )
			{
				super.SetSize( w , h );
				ComputeButtonSize();
				CheckButtonPosV();
				CheckButtonPosH();
				SetClientPos( GetClient().GetPosX() , GetClient().GetPosY() );
			}
		}
		public function SetClientSize( w:int , h:int ):void
		{
			if ( m_pClient.GetWidth() != w || m_pClient.GetHeight() != h )
			{
				m_pClient.SetSize( w , h );
			}
		}
		public function _SetClientSize( w:int , h:int ):void
		{
			ComputeButtonSize();
			CheckButtonPosV();
			CheckButtonPosH();
		}
		public function SetClientPosPersent( x:Number , y:Number ):void
		{
			SetClientPos( x * (GetClient().GetWidth() - GetView().GetWidth()) , -y * (GetClient().GetHeight() - GetView().GetHeight() ) );
		}
		public function SetClientPos( x:int , y:int ):void
		{
			var bShowHScroll:Boolean = m_pBackH.isShow();// isStyleData( "ShowHScroll" );
			var bShowVScroll:Boolean = m_pBackV.isShow();// isStyleData( "ShowVScroll" );
			var nBlockWidth:int = bShowVScroll?m_pArrowUp.GetWidth():0;
			var nBlockHeight:int = bShowHScroll?m_pArrowLeft.GetHeight():0;
			if( y < -(m_pClient.GetHeight()-GetHeight()+nBlockHeight) ) y = -(m_pClient.GetHeight()-GetHeight()+nBlockHeight);
			if( y > 0 ) y = 0;
			var h:int = GetHeight()-m_pArrowUp.GetHeight()-m_pArrowDown.GetHeight()-m_pButtonV.GetHeight();
			var v:int = 0;
			if( m_pClient.GetHeight() - (GetHeight() - nBlockHeight*2) )
				v = - y * h / ( m_pClient.GetHeight() - (GetHeight() - nBlockHeight*2) );
			if ( x < -(m_pClient.GetWidth() - (GetWidth() - nBlockWidth)) ) x = -(m_pClient.GetWidth() - (GetWidth() - nBlockWidth));
			if ( x > 0 ) x = 0;
			var w:int = GetWidth() - m_pArrowLeft.GetWidth() - m_pArrowRight.GetWidth() - m_pButtonH.GetWidth();
			var u:int = 0;
			if ( m_pClient.GetWidth() - (GetWidth() - nBlockWidth*2) )
				u = - x * w / (m_pClient.GetWidth() - (GetWidth() - nBlockWidth*2) );
			m_pClient.SetPos( x , y );
			m_pButtonV.SetPos( m_pButtonV.GetPosX() , v );
			m_pButtonH.SetPos( u , m_pButtonH.GetPosY() );
			if ( m_pButtonH.GetPosX() > m_pBackH.GetWidth() - m_pButtonH.GetWidth() )
				m_pButtonH.SetPos( m_pBackH.GetWidth() - m_pButtonH.GetWidth() , m_pButtonH.GetPosY() );
			if ( m_pButtonH.GetPosX() < 0 )
				m_pButtonH.SetPos( 0 , m_pButtonH.GetPosY() );
			if ( m_pButtonV.GetPosY() > m_pBackV.GetHeight() - m_pButtonV.GetHeight() )
				m_pButtonV.SetPos( m_pButtonV.GetPosX() , m_pBackV.GetHeight() - m_pButtonV.GetHeight() );
			if ( m_pButtonV.GetPosY() < 0 )
				m_pButtonV.SetPos( m_pButtonV.GetPosX() , 0 );
		}
		public function CheckClientPos():void
		{
			var x:int = m_pClient.GetPosX();
			var y:int = m_pClient.GetPosY();
			var bSet:Boolean = false;
			var bShowHScroll:Boolean = m_pBackH.isShow();// isStyleData( "ShowHScroll" );
			var bShowVScroll:Boolean = m_pBackV.isShow();// isStyleData( "ShowVScroll" );
			var nBlockWidth:int = bShowVScroll?m_pArrowUp.GetWidth():0;
			var nBlockHeight:int = bShowHScroll?m_pArrowLeft.GetHeight():0;
			if ( y < -(m_pClient.GetHeight() - GetHeight() + nBlockHeight) )
			{
				y = -(m_pClient.GetHeight() - GetHeight() + nBlockHeight);
				bSet = true;
			}
			if ( y > 0 )
			{
				y = 0;
				bSet = true;
			}
			var h:int = GetHeight()-m_pArrowUp.GetHeight()-m_pArrowDown.GetHeight()-m_pButtonV.GetHeight();
			var v:int = 0;
			if( m_pClient.GetHeight() - (GetHeight() - nBlockHeight*2) )
				v = - y * h / ( m_pClient.GetHeight() - (GetHeight() - nBlockHeight*2) );
			if ( x < -(m_pClient.GetWidth() - (GetWidth() - nBlockWidth)) )
			{
				x = -(m_pClient.GetWidth() - (GetWidth() - nBlockWidth));
				bSet = true;
			}
			if ( x > 0 )
			{
				x = 0;
				bSet = true;
			}			
			if ( bSet )
			{
				var w:int = GetWidth() - m_pArrowLeft.GetWidth() - m_pArrowRight.GetWidth() - m_pButtonH.GetWidth();
				var u:int = 0;
				if ( m_pClient.GetWidth() - (GetWidth() - nBlockWidth*2) )
					u = - x * w / (m_pClient.GetWidth() - (GetWidth() - nBlockWidth * 2) );
				m_pClient.SetPos( x , y );
				m_pButtonV.SetPos( m_pButtonV.GetPosX() , v );
				m_pButtonH.SetPos( u , m_pButtonH.GetPosY() );
				if ( m_pButtonH.GetPosX() > m_pBackH.GetWidth() - m_pButtonH.GetWidth() )
					m_pButtonH.SetPos( m_pBackH.GetWidth() - m_pButtonH.GetWidth() , m_pButtonH.GetPosY() );
				if ( m_pButtonH.GetPosX() < 0 )
					m_pButtonH.SetPos( 0 , m_pButtonH.GetPosY() );
				if ( m_pButtonV.GetPosY() > m_pBackV.GetHeight() - m_pButtonV.GetHeight() )
					m_pButtonV.SetPos( m_pButtonV.GetPosX() , m_pBackV.GetHeight() - m_pButtonV.GetHeight() );
				if ( m_pButtonV.GetPosY() < 0 )
					m_pButtonV.SetPos( m_pButtonV.GetPosX() , 0 );
			}
		}
		public function SetInView( x:int , y:int , h:int ):void
		{
			var viewW:int = GetView().GetWidth();
			var viewH:int = GetView().GetHeight();
			var clientX:int = GetClient().GetPosX();
			var clientY:int = GetClient().GetPosY();
			var bInView:Boolean;
			if ( /*x + clientX >= 0 && x + clientX < viewW && */y + clientY >= 0 && y + clientY < viewH )
				bInView = true;
			if ( !bInView )
				SetClientPos( GetClient().GetPosX() , -y + (viewH - h) / 2 );
		}
		public function GetClientWidth():int
		{
			return m_pClient.GetWidth();
		}
		public function GetClientHeight():int
		{
			return m_pClient.GetHeight();
		}
		public function SetScrollButtonPos( hor:int , ver:int , nClientChildWidth:int , nClientChlidHeight:int ):void
		{
			hor = hor * (m_pBackH.GetWidth() - m_pButtonH.GetWidth()) / (m_pClient.GetWidth() - nClientChildWidth);
			ver = ver * (m_pBackV.GetHeight() - m_pButtonV.GetHeight()) / (m_pClient.GetHeight() - nClientChlidHeight );
			m_pButtonH.SetPos( hor , m_pButtonH.GetPosY() );
			m_pButtonV.SetPos( m_pButtonV.GetPosX() , ver );
			if ( m_pButtonH.GetPosX() > m_pBackH.GetWidth() - m_pButtonH.GetWidth() )
				m_pButtonH.SetPos( m_pBackH.GetWidth() - m_pButtonH.GetWidth() , m_pButtonH.GetPosY() );
			if ( m_pButtonH.GetPosX() < 0 )
				m_pButtonH.SetPos( 0 , m_pButtonH.GetPosY() );
			if ( m_pButtonV.GetPosY() > m_pBackV.GetHeight() - m_pButtonV.GetHeight() )
				m_pButtonV.SetPos( m_pButtonV.GetPosX() , m_pBackV.GetHeight() - m_pButtonV.GetHeight() );
			if ( m_pButtonV.GetPosY() < 0 )
				m_pButtonV.SetPos( m_pButtonV.GetPosX() , 0 );
			CheckButtonPosV();
			CheckButtonPosH();
		}
		override public function GetClient():dUIImage
		{
			return m_pClient;
		}
		public function GetView():dUIImage
		{
			return m_pView;
		}
		public function GetVButtonWidth():int
		{
			return m_pButtonV.GetWidth();
		}
		override public function OnMouseWheel( v:int ):void
		{
			FireEvent( dUISystem.GUIEVENT_TYPE_MOUSE_WHEEL , v );
			if ( isStyleData( "CanMouseWheel" ) )
			{
				SetClientPos( GetClient().GetPosX() , GetClient().GetPosY() - v * 15 );
				FireEvent( dUISystem.GUIEVENT_TYPE_SCROLL_DRAG , 0 , v );
			}
			//super.OnMouseWheel( v );
		}
		private function ComputeButtonSize( bForceHideVScroll:Boolean = false , bForceHideHScroll:Boolean = false ):void
		{
			var bRecall:Boolean = false;
			var w:int = GetWidth();
			var h:int = GetHeight();
			var bShowHScroll:Boolean = isStyleData( "ShowHScroll" );
			var bShowVScroll:Boolean = isStyleData( "ShowVScroll" );
			var bForceShowVScroll:Boolean = isStyleData( "AlwaysShowVScroll" );
			var bForceShowHScroll:Boolean = isStyleData( "AlwaysShowHScroll" );
			if ( bForceShowVScroll )
			{
				bForceHideVScroll = false;
				bShowVScroll = true;
			}
			if ( bForceShowHScroll )
			{
				bForceHideHScroll = false;
				bShowHScroll = true;
			}
			if ( bForceHideHScroll ) bShowHScroll = false;
			if ( bForceHideVScroll ) bShowVScroll = false;
			var nBlockWidth:int = bShowVScroll?m_pArrowUp.GetWidth():0;
			var nBlockHeight:int = bShowHScroll?m_pArrowLeft.GetHeight():0;
			
			m_pView.SetSize( w - nBlockWidth , h - nBlockHeight );
			nBlockWidth = 0;
			nBlockHeight = 0;
			var nBlockWidthMirror:int = 0;
			var nBlockHeightMirror:int = 0;
			if ( bShowHScroll && bShowVScroll )
			{
				nBlockWidth = m_pArrowUp.GetWidth();
				nBlockHeight = m_pArrowLeft.GetHeight();
				if ( isStyleData( "HScrollMirror" ) ) nBlockHeightMirror = nBlockHeight;
				if ( isStyleData( "VScrollMirror" ) ) nBlockWidthMirror = nBlockWidth;
			}
			
			m_pArrowUp.SetShow( bShowVScroll );
			m_pArrowDown.SetShow( bShowVScroll );
			m_pBackV.SetShow( bShowVScroll );
			m_pButtonVFather.SetShow( bShowVScroll );
			if ( bShowVScroll )
			{
				if ( !isStyleData( "VScrollMirror" ) )
				{
					m_pArrowUp.SetPos( GetWidth() - m_pArrowUp.GetWidth() , nBlockHeightMirror );
					m_pArrowDown.SetPos( GetWidth() - m_pArrowDown.GetWidth() , GetHeight() - m_pArrowDown.GetHeight() - nBlockHeight + nBlockHeightMirror );
					m_pBackV.SetPos( GetWidth() - m_pBackV.GetWidth() , m_pArrowUp.GetHeight() + nBlockHeightMirror );
				}
				else
				{
					m_pArrowUp.SetPos( 0 , nBlockHeightMirror );
					m_pArrowDown.SetPos( 0 , GetHeight() - m_pArrowDown.GetHeight() - nBlockHeight + nBlockHeightMirror );
					m_pBackV.SetPos( 0 , m_pArrowUp.GetHeight() + nBlockHeightMirror );
				}
				if ( m_pArrowDown.GetPosY() < m_pArrowUp.GetPosY() + m_pArrowUp.GetHeight() )
					m_pArrowDown.SetPos( m_pArrowDown.GetPosX() , m_pArrowUp.GetPosY() + m_pArrowUp.GetHeight() );
				MiddleH( [m_pArrowUp , m_pArrowDown , m_pBackV] );
				m_pBackV.SetSize( m_pBackV.GetWidth() , h - m_pArrowUp.GetHeight() - m_pArrowDown.GetHeight() - nBlockHeight );
				m_pButtonVFather.SetPos( m_nButtonVOffsetX + ( m_pArrowUp.GetWidth() - m_pButtonV.GetWidth() ) / 2 + m_pArrowUp.GetPosX() , m_pBackV.GetPosY() );
				m_pButtonVFather.SetSize( m_pButtonV.GetWidth() , m_pBackV.GetHeight() );
			}
			m_pArrowLeft.SetShow( bShowHScroll );
			m_pArrowRight.SetShow( bShowHScroll );
			m_pBackH.SetShow( bShowHScroll );
			m_pButtonHFather.SetShow( bShowHScroll );
			if ( bShowHScroll )
			{
				if ( !isStyleData( "HScrollMirror" ) )
				{
					m_pArrowLeft.SetPos( nBlockWidthMirror , GetHeight() - m_pArrowLeft.GetHeight() );
					m_pArrowRight.SetPos( nBlockWidthMirror + GetWidth() - m_pArrowRight.GetWidth() - nBlockWidth , GetHeight() - m_pArrowRight.GetHeight() );
					m_pBackH.SetPos( nBlockWidthMirror + m_pArrowLeft.GetWidth() , GetHeight() - m_pBackH.GetHeight() );
				}
				else
				{
					m_pArrowLeft.SetPos( nBlockWidthMirror , 0 );
					m_pArrowRight.SetPos( nBlockWidthMirror + GetWidth() - m_pArrowRight.GetWidth() - nBlockWidth , 0 );
					m_pBackH.SetPos( nBlockWidthMirror + m_pArrowLeft.GetWidth() , 0 );
				}
				if ( m_pArrowRight.GetPosX() < m_pArrowLeft.GetPosX() + m_pArrowLeft.GetWidth() )
					m_pArrowRight.SetPos( m_pArrowLeft.GetPosX() + m_pArrowLeft.GetWidth() , m_pArrowRight.GetPosY() );
				MiddleV( [m_pArrowLeft , m_pArrowRight , m_pBackH] );
				m_pBackH.SetSize( w - m_pArrowLeft.GetWidth() - m_pArrowRight.GetWidth() - nBlockWidth , m_pBackH.GetHeight() );
				m_pButtonHFather.SetPos( m_pBackH.GetPosX() , m_nButtonHOffsetY + ( m_pArrowLeft.GetHeight() - m_pButtonH.GetHeight() ) / 2 + m_pArrowLeft.GetPosY() );
				m_pButtonHFather.SetSize( m_pBackH.GetWidth() , m_pButtonH.GetHeight() );
			}
			
			var nClientWidth:int = m_pClient.GetWidth() - m_pArrowLeft.GetWidth() - m_pArrowRight.GetWidth();
			var nClientHeight:int = m_pClient.GetHeight() - m_pArrowUp.GetHeight() - m_pArrowDown.GetHeight();
			var nBackWidth:int = m_pBackH.GetWidth();
			var nBackHeight:int = m_pBackV.GetHeight();
			var nButtonWidth:int = 0;
			var nButtonHeight:int = 0;
			if ( nClientWidth < nBackWidth ) nClientWidth = nBackWidth;
			if ( nClientHeight < nBackHeight ) nClientHeight = nBackHeight;
			if ( nClientWidth )
				nButtonWidth = nBackWidth * nBackWidth / nClientWidth;
			if ( nButtonWidth < 15 ) nButtonWidth = 15;
			if ( nClientHeight )
				nButtonHeight = nBackHeight * nBackHeight / nClientHeight;
			if ( nButtonHeight < 15 ) nButtonHeight = 15;
			if ( bShowHScroll )
			{
				m_pButtonH.SetSize( nButtonWidth , m_pButtonH.GetHeight() );
				if ( m_pButtonH.GetPosX() > m_pBackH.GetWidth() - m_pButtonH.GetWidth() )
					m_pButtonH.SetPos( m_pBackH.GetWidth() - m_pButtonH.GetWidth() , m_pButtonH.GetPosY() );
				if ( m_pButtonH.GetPosX() < 0 )
					m_pButtonH.SetPos( 0 , m_pButtonH.GetPosY() );
				if ( m_pButtonH.GetWidth() >= nClientWidth && !bForceShowHScroll )
				{
					m_pBackH.SetShow( false );
					m_pButtonHFather.SetShow( false );
					m_pArrowLeft.SetShow( false );
					m_pArrowRight.SetShow( false );
					if ( bForceHideHScroll == false )
					{
						bForceHideHScroll = true;
						bRecall = true;
					}
				}
				else
				{
					m_pBackH.SetShow( true );
					m_pButtonHFather.SetShow( true );
					m_pArrowLeft.SetShow( true );
					m_pArrowRight.SetShow( true );
				}
			}
			else
				m_pClient.SetPos( 0 , m_pClient.GetPosY() );
			if ( bShowVScroll )
			{
				m_pButtonV.SetSize( m_pButtonV.GetWidth() , nButtonHeight );
				if ( m_pButtonV.GetPosY() > m_pBackV.GetHeight() - m_pButtonV.GetHeight() )
					m_pButtonV.SetPos( m_pButtonV.GetPosX() , m_pBackV.GetHeight() - m_pButtonV.GetHeight() );
				if ( m_pButtonV.GetPosY() < 0 )
					m_pButtonV.SetPos( m_pButtonV.GetPosX() , 0 );
				if ( m_pButtonV.GetHeight() >= nClientHeight && !bForceShowVScroll )
				{
					m_pBackV.SetShow( false );
					m_pButtonVFather.SetShow( false );
					m_pArrowUp.SetShow( false );
					m_pArrowDown.SetShow( false );
					if ( bForceHideVScroll == false )
					{
						bForceHideVScroll = true;
						bRecall = true;
					}
				}
				else
				{
					m_pBackV.SetShow( true );
					m_pButtonVFather.SetShow( true );
					m_pArrowUp.SetShow( true );
					m_pArrowDown.SetShow( true );
				}
			}
			else
				m_pClient.SetPos( m_pClient.GetPosX() , 0 );
			if ( bRecall )
				ComputeButtonSize( bForceHideVScroll , bForceHideHScroll );
			if ( isStyleData( "VScrollMirror" ) && m_pBackV.isShow() ) m_pView.SetPos( m_pButtonVFather.GetWidth() , m_pView.GetPosY() );
			else m_pView.SetPos( 0 , m_pView.GetPosY() );
			if ( isStyleData( "HScrollMirror" ) && m_pBackH.isShow() ) m_pView.SetPos( m_pView.GetPosX() , m_pButtonHFather.GetHeight() );
			else m_pView.SetPos( m_pView.GetPosX() , 0 );
			SetHandleMouseWheel( m_pBackV.isShow() );
		}
		protected function MiddleH( arr:Array ):void
		{
			var nMaxWidthIdx:int;
			var nMaxWidth:int;
			for ( var i:int = 0 ; i < arr.length ; i ++ )
			{
				var w:int = arr[i].GetWidth();
				if ( i == 0 || w > nMaxWidth )
				{
					nMaxWidthIdx = i;
					nMaxWidth = w;
				}
			}
			for ( i = 0 ; i < arr.length ; i ++ )
			{
				if ( i == nMaxWidthIdx ) continue;
				arr[i].SetPos( arr[nMaxWidthIdx].GetPosX() + (arr[nMaxWidthIdx].GetWidth() - arr[i].GetWidth()) / 2 , arr[i].GetPosY() );
			}
		}
		protected function MiddleV( arr:Array ):void
		{
			var nMaxHeightIdx:int;
			var nMaxHeight:int;
			for ( var i:int = 0 ; i < arr.length ; i ++ )
			{
				var h:int = arr[i].GetHeight();
				if ( i == 0 || h > nMaxHeight )
				{
					nMaxHeightIdx = i;
					nMaxHeight = h;
				}
			}
			for ( i = 0 ; i < arr.length ; i ++ )
			{
				if ( i == nMaxHeightIdx ) continue;
				arr[i].SetPos( arr[i].GetPosX() , arr[nMaxHeightIdx].GetPosY() + (arr[nMaxHeightIdx].GetHeight() - arr[i].GetHeight()) / 2 );
			}
		}
		override public function SetMouseStyle( nType:int ):void
		{
			if ( m_nMouseStyle != nType )
			{
				m_nMouseStyle = nType;
				m_pArrowDown.SetMouseStyle( nType );
				m_pArrowLeft.SetMouseStyle( nType );
				m_pArrowRight.SetMouseStyle( nType );
				m_pArrowUp.SetMouseStyle( nType );
				m_pButtonH.SetMouseStyle( nType );
				m_pButtonV.SetMouseStyle( nType );
			}
		}
	}

}