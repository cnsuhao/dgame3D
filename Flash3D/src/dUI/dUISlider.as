//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUISlider extends dUIImage
	{
		protected var m_pImageV3:dUITileImageV3;
		protected var m_pImageH3:dUITileImageH3;
		protected var m_pButton:dUIImageButton;
		protected var m_nValue:int = 0;
		protected var m_nMaxValue:int = 100;
		protected var m_nMinValue:int = 0;
		protected var m_nButtonPosX:int;
		protected var m_nButtonPosY:int;
		protected var m_pText:dUISuperText;
		public function dUISlider( pFather:dUIImage ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_SLIDER;
			m_pImageV3 = new dUITileImageV3( this );
			m_pImageV3.LoadFromImageSet( "滑杆背景竖1,滑杆背景竖2,滑杆背景竖3" );
			m_pImageH3 = new dUITileImageH3( this );
			m_pImageH3.LoadFromImageSet( "滑杆背景横1,滑杆背景横2,滑杆背景横3" );
			m_pButton = new dUIImageButton( this );
			m_pButton.SetUIEventFunction( OnSliderButtonEvent );
			m_pButton.LoadFromImageSet( "滑杆按钮正常,滑杆按钮发亮,滑杆按钮按下,滑杆按钮无效" );
			m_pText = new dUISuperText( this );
			SetSize( 100 , DYM_GUI_MAX( m_pButton.GetHeight() , m_pImageH3.GetHeight() ) );
		}
		override public function SetSize( w:int , h:int ):void
		{
			if( !isStyleData( "Vertical" ) )// 横向
			{
				m_pImageV3.SetShow( false );
				m_pImageH3.SetShow( true );
				m_pImageH3.SetSize( w , m_pImageH3.GetHeight() );
				m_pImageH3.SetPos( 0 , ( GetHeight()-m_pImageH3.GetHeight() )/2 );
				m_pButton.SetPos( 0 , ( GetHeight()-m_pButton.GetHeight() )/2 );
				super.SetSize( w , DYM_GUI_MAX( m_pButton.GetHeight() , m_pImageH3.GetHeight() ) );
			}
			else
			{
				m_pImageH3.SetShow( false );
				m_pImageV3.SetShow( true );
				m_pImageV3.SetSize( m_pImageV3.GetWidth() , h );
				m_pImageV3.SetPos( ( GetWidth()-m_pImageV3.GetWidth() )/2 , 0 );
				m_pButton.SetPos( ( GetWidth()-m_pButton.GetWidth() )/2 , 0 );
				super.SetSize( DYM_GUI_MAX( m_pButton.GetWidth() , m_pImageV3.GetWidth() ) , h );
			}
			m_pText.SetSize( GetWidth() , GetHeight() );
			Update();
		}
		override public function SetStyleData( name:String , bSet:Boolean ):void
		{
			if ( name == "Vertical" ||
				 name == "AutoTextPersent" ||
				 name == "AutoTextDiv" ||
				 name == "AutoTextCurValue")
			{
				super.SetStyleData( name , bSet );
				if ( name == "Vertical" )
				{
					if( !bSet )
						m_nButtonPosY = 0;
					else
						m_nButtonPosX = 0;
					SetSize( GetHeight() , GetWidth() );
				}
				else if ( (name == "AutoTextPersent" || name == "AutoTextDiv" || name == "AutoTextCurValue" ) && bSet )
				{
					super.SetStyleData( name , bSet );
					UpdateText();
				}
			}
		}
		override public function SetText( str:String ):void
		{
			m_pText.SetText( str );
		}
		override public function GetText():String
		{
			return m_pText.GetText();
		}
		private function OnSliderButtonEvent( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_BUTTON_UP || event.type == dUISystem.GUIEVENT_TYPE_BUTTON_UP_OUT )
			{
				var per_pixel:Number = Number( GetWidth()-m_pButton.GetWidth() )/Number(m_nMaxValue - m_nMinValue);
				if( !isStyleData( "Vertical" ) )
					m_nButtonPosX = int(Number(GetValue()-m_nMinValue)*per_pixel);
				else
					m_nButtonPosY = int(Number(GetValue()-m_nMinValue)*per_pixel);
				FireEvent( dUISystem.GUIEVENT_TYPE_SLIDER_VALUE_CHANGE_DONE , m_nValue , GetMaxValue() );
			}
			else if( event.type == dUISystem.GUIEVENT_TYPE_BUTTON_DRAG )
			{
				if( !isWindowEnable() ) return;
				if( !isStyleData( "Vertical" ) )// 横向
				{
					m_nButtonPosX = m_nButtonPosX+event.nParam1;
					if( m_nButtonPosX < 0 )
						m_nButtonPosX = 0;
					else if( m_nButtonPosX > GetWidth()-m_pButton.GetWidth() )
						m_nButtonPosX = GetWidth()-m_pButton.GetWidth();
					var old_button_pos_x:int = m_nButtonPosX;
					var old_button_pos_y:int = m_nButtonPosY;
					if( m_nMaxValue - m_nMinValue > 0 )
					{
						per_pixel = Number( GetWidth()-m_pButton.GetWidth() )/Number(m_nMaxValue - m_nMinValue);
						var v:int = 0;
						if( GetWidth()-m_pButton.GetWidth() )
							v = (m_nButtonPosX+int(per_pixel/2.0))*(m_nMaxValue-m_nMinValue)/( GetWidth()-m_pButton.GetWidth() );
						SetValue( v + m_nMinValue );
					}
					else 
						SetValue( m_nButtonPosX );
					m_nButtonPosX = old_button_pos_x;
					m_nButtonPosY = old_button_pos_y;
				}
				else
				{
					m_nButtonPosY = m_nButtonPosY+event.nParam2;
					if( m_nButtonPosY < 0 )
						m_nButtonPosY = 0;
					else if( m_nButtonPosY > GetHeight()-m_pButton.GetHeight() )
						m_nButtonPosY = GetHeight()-m_pButton.GetHeight();

					old_button_pos_x = m_nButtonPosX;
					old_button_pos_y = m_nButtonPosY;
					if( m_nMaxValue - m_nMinValue > 0 )
					{
						per_pixel = Number( GetHeight()-m_pButton.GetHeight() )/Number(m_nMaxValue - m_nMinValue);
						v = (m_nButtonPosY+int(per_pixel/2.0))*(m_nMaxValue - m_nMinValue)/( GetHeight()-m_pButton.GetHeight() );
						SetValue( v + m_nMinValue );
					}
					else
						SetValue( m_nButtonPosY );
					m_nButtonPosX = old_button_pos_x;
					m_nButtonPosY = old_button_pos_y;
				}
			}
		}
		public function SetMaxValue( v:int ):void
		{
			m_nMaxValue = v;
			if ( m_nValue < m_nMinValue ) m_nValue = m_nMinValue;
			else if ( m_nValue > m_nMaxValue ) m_nValue = m_nMaxValue;
			Update();
		}
		public function GetMaxValue():int
		{
			return m_nMaxValue;
		}
		public function SetMinValue( v:int ):void
		{
			m_nMinValue = v;
			if ( m_nValue < m_nMinValue ) m_nValue = m_nMinValue;
			else if ( m_nValue > m_nMaxValue ) m_nValue = m_nMaxValue;
			Update();
		}
		public function GetMinValue():int
		{
			return m_nMinValue;
		}
		protected function Update():void
		{
			var v:int = m_nValue;
			var per_pixel:Number = 1;
			if( m_nMaxValue - m_nMinValue )
			{
				if( !isStyleData( "Vertical" ) )
					per_pixel = Number( GetWidth()-m_pButton.GetWidth() )/Number(m_nMaxValue - m_nMinValue);
				else
					per_pixel = Number( GetHeight()-m_pButton.GetHeight() )/Number(m_nMaxValue - m_nMinValue);
			}
			if( !isStyleData( "Vertical" ) )
			{
				m_pButton.SetPos( int(Number(v - m_nMinValue)*per_pixel) , m_nButtonPosY );
				m_nButtonPosX = m_pButton.GetPosX();
			}
			else
			{
				m_pButton.SetPos( m_nButtonPosX , int(Number(v - m_nMinValue)*per_pixel) );
				m_nButtonPosY = m_pButton.GetPosY();
			}
		}
		protected function UpdateText():void
		{
			if ( isStyleData( "AutoTextPersent" ) )
				SetText( int( GetValue() * 100 / GetMaxValue() ) + "%" );
			else if ( isStyleData( "AutoTextDiv" ) )
				SetText( GetValue() + "/" + GetMaxValue() );
			else if ( isStyleData( "AutoTextCurValue" ) )
				SetText( String( GetValue() ) );
		}
		public function SetValue( v:int ):void
		{
			if( v != m_nValue )
			{
				m_nValue = v;
				Update();
				UpdateText();
				FireEvent( dUISystem.GUIEVENT_TYPE_SLIDER_VALUE_CHANGED , m_nValue , GetMaxValue() );
			}
		}
		public function GetValue():int
		{
			return m_nValue;
		}

		override public function EnableWindow( bEnable:Boolean ):void
		{
			m_pImageV3.EnableWindow( bEnable );
			m_pImageH3.EnableWindow( bEnable );
			m_pButton.EnableWindow( bEnable );
			super.EnableWindow( bEnable );
		}
	}

}