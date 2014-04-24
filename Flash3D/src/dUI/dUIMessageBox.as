//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIMessageBox extends dUIWindow
	{
		protected var m_pText:dUISuperText;
		protected var m_vecButton:Vector.<dUIButton> = new Vector.<dUIButton>;
		public function dUIMessageBox( pFather:dUIImage , timeRemain:int , strData:String )
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_MESSAGEBOX;
			//m_pText = new dUISuperText( GetClient() );
			m_pText = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_SUPPERTEXT , GetClient() , true , GetObjType() ) as dUISuperText;
			m_pText.SetAlignType( 1 );
			m_pText.SetStyleData( "AutoSetSize" , true );
			m_pText.SetText( super.GetText() );
			SetText( strData );
		}
		override protected function _OnCloseButtonEvent( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_BUTTON_UP )
			{
				var i:int = m_vecButton.length - 1;
				FireEvent( dUISystem.GUIEVENT_TYPE_MESSAGE_BOX_SELECTED , i , 0 , m_vecButton[i].GetText() );
				Release();
			}
		}
		private function _OnButtonClick( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_BUTTON_UP )
			{
				for ( var i:int = 0 ; i < m_vecButton.length ; i ++ )
				{
					if ( event.pObj == m_vecButton[i] )
					{
						FireEvent( dUISystem.GUIEVENT_TYPE_MESSAGE_BOX_SELECTED , i , 0 , m_vecButton[i].GetText() );
						Release();
						break;
					}
				}
			}
			else if ( event.type == dUISystem.GUIEVENT_TYPE_CLOSE_WINDOW && m_vecButton.length )
			{
				i = m_vecButton.length - 1;
				FireEvent( dUISystem.GUIEVENT_TYPE_MESSAGE_BOX_SELECTED , i , 0 , m_vecButton[i].GetText() );
				Release();
			}
		}
		override public function SetText( strData:String ):void
		{
			for ( var i:int = 0 ; i < m_vecButton.length ; i ++ )
			{
				m_vecButton[i].Release();
				m_vecButton[i] = null;
			}
			var vecStr:Vector.<String> = new Vector.<String>;
			var s:String = new String();
			for ( i = 0 ; i < strData.length ; i ++ )
			{
				if ( strData.charAt( i ) == "|" )
				{
					vecStr.push( s );
					s = "";
				}
				else s += strData.charAt( i );
			}
			if ( s.length ) vecStr.push( s );
			m_pText.SetPos( 15 , 5 );
			if ( vecStr.length > 0 ) super.SetText( vecStr[0] );
			if ( vecStr.length > 1 ) m_pText.SetText( vecStr[1] );
			var nButtonWidthTotal:int = 0;
			for ( i = 2 ; i < vecStr.length ; i ++ )
			{
				//var p:dUIButton = new dUIButton( GetClient() );
				var p:dUIButton = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_BUTTON , GetClient() , true , GetObjType() ) as dUIButton;
				p.SetUIEventFunction( _OnButtonClick );
				p.SetStyleData( "AutoSetSize" , true );
				p.SetText( vecStr[i] );
				p.SetEdgeRect( 8 , 3 , 8 , 3 );
				m_vecButton.push( p );
				nButtonWidthTotal += p.GetWidth();
			}
			var nWidth:int = m_pText.GetWidth() + m_pText.GetPosX() * 2;
			var nHeight:int = m_pText.GetHeight() + m_pText.GetPosY() * 2;
			if ( nWidth < 120 ) nWidth = 120;
			if ( nHeight < 50 ) nHeight = 50;
			if ( m_vecButton.length )
			{
				var nPerStep:int = (nWidth - nButtonWidthTotal) / (m_vecButton.length + 1);
				if ( nPerStep < 5 ) nPerStep = 5;
				var xPos:int = nPerStep;
				var maxButtonHeight:int = 0;
				for ( i = 0 ; i < m_vecButton.length ; i ++ )
				{
					m_vecButton[i].SetPos( xPos , nHeight );
					xPos += nPerStep + m_vecButton[i].GetWidth();
					if ( maxButtonHeight < m_vecButton[i].GetHeight() )
						maxButtonHeight = m_vecButton[i].GetHeight();
				}
				if ( nWidth < xPos )
					nWidth = xPos;
				nHeight += maxButtonHeight + 5;
			}
			if ( vecStr.length <= 2 )
				SetStyleData( "ShowCloseButton" , false );
			SetClientSize( nWidth , nHeight );
		}
		override public function GetText():String
		{
			if ( !m_pText ) return "";
			return m_pText.GetText();
		}
		override public function SetMouseStyle( nType:int ):void
		{
			super.SetMouseStyle( nType );
			for ( var i:int = 0 ; i < m_vecButton.length ; i ++ )
				m_vecButton[i].SetMouseStyle( nType );
		}
	}
}