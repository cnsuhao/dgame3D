//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUICheckBox extends dUIImage
	{
		protected var m_pImageNormal:dUIImageBox;
		protected var m_pImageNormalCheck:dUIImageBox;
		protected var m_pImageLight:dUIImageBox;
		protected var m_pImageLightCheck:dUIImageBox;
		protected var m_pImageInvalid:dUIImageBox;
		protected var m_pImageInvalidCheck:dUIImageBox;
		protected var m_pText:dUISuperText;
		protected var m_bCheck:Boolean;
		protected var m_nTextOffsetX:int = 0;
		protected var m_nTextOffsetY:int = 0;
		public function dUICheckBox( pFather:dUIImage ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_CHECKBOX;
			m_pImageNormal = new dUIImageBox( this );
			m_pImageNormal.SetUIEventFunction( OnImageEvent );
			m_pImageNormalCheck = new dUIImageBox( this );
			m_pImageLight = new dUIImageBox( this );
			//m_pImageLight.FlashWindow( -1 , 500 , 0 , 0 );
			m_pImageLightCheck = new dUIImageBox( this );
			//m_pImageLightCheck.FlashWindow( -1 , 500 , 0 , 0 );
			m_pImageInvalid = new dUIImageBox( this );
			m_pImageInvalidCheck = new dUIImageBox( this );
			m_pText = new dUISuperText( this );
			var pImageSet:dUIImageSet = GetImageRoot().GetImageSet();
			var rc:dUIImageRect = pImageSet.GetImageRect( "单选框文字偏移" );
			m_nTextOffsetX = rc.left;
			m_nTextOffsetY = rc.top;
			Update();
			// 设置默认
			SetHandleMouse( true );
			m_pText.SetStyleData( "AutoSetSize" , true );
			m_pText.SetStyleData( "MultiLine" , true );
			LoadFromImageSet( "" );
			SetText( "CheckBox" );
		}
		override public function GetDefaultSkin():String
		{
			return "单选框正常未选,单选框正常已选,单选框鼠标移入未选,单选框鼠标移入已选,单选框无效未选,单选框无效已选";
		}
		override public function _LoadFromImageSet( name:String ):void
		{
			var str:Vector.<String> = SplitName( name , 6 );
			m_pImageNormal.SetSize( 0 , 0 );
			m_pImageNormalCheck.SetSize( 0 , 0 );
			m_pImageLight.SetSize( 0 , 0 );
			m_pImageLightCheck.SetSize( 0 , 0 );
			m_pImageInvalid.SetSize( 0 , 0 );
			m_pImageInvalidCheck.SetSize( 0 , 0 );
			m_pImageNormal.LoadFromImageSet( str[0] );
			m_pImageNormalCheck.LoadFromImageSet( str[1] );
			m_pImageLight.LoadFromImageSet( str[2] );
			m_pImageLightCheck.LoadFromImageSet( str[3] );
			m_pImageInvalid.LoadFromImageSet( str[4] );
			m_pImageInvalidCheck.LoadFromImageSet( str[5] );
		}
		protected function Update():void
		{
			m_pImageNormal.SetShow( !m_bCheck );
			m_pImageNormalCheck.SetShow( m_bCheck );
			if ( !isWindowEnable() )
			{
				m_pImageInvalid.SetShow( !m_bCheck );
				m_pImageInvalidCheck.SetShow( m_bCheck );
			}
			else
			{
				m_pImageInvalid.SetShow( false );
				m_pImageInvalidCheck.SetShow( false );
				if ( isMouseIn() )
				{
					m_pImageLight.SetShow( !m_bCheck );
					m_pImageLightCheck.SetShow( m_bCheck );
				}
				else
				{
					m_pImageLight.SetShow( false );
					m_pImageLightCheck.SetShow( false );
				}
			}
		}
		override public function EnableWindow( bEnable:Boolean ):void
		{
			super.EnableWindow( bEnable );
			Update();
		}
		override public function OnLButtonUp( x:int , y:int ):void
		{
			if( isMouseIn() && isWindowEnable() )
			{
				m_bCheck = !m_bCheck;
				Update();
				FireEvent( dUISystem.GUIEVENT_TYPE_CHECK , int(m_bCheck) );
			}
			super.OnLButtonUp( x , y );
		}
		override public function OnMouseIn( x:int , y:int ):void
		{
			super.OnMouseIn( x , y );
			if ( isWindowEnable() )
			{
				m_pImageLight.SetShow( !m_bCheck );
				m_pImageLightCheck.SetShow( m_bCheck );
			}
		}
		override public function OnMouseOut( x:int , y:int ):void
		{
			super.OnMouseOut( x , y );
			m_pImageLight.SetShow( false );
			m_pImageLightCheck.SetShow( false );
		}
		public function SetCheck( bCheck:Boolean ):void
		{
			if ( m_bCheck != bCheck )
			{
				m_bCheck = bCheck;
				Update();
			}
		}
		private function OnImageEvent( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED )
				_SetText( GetText() );
		}
		public function GetCheck():Boolean
		{
			return m_bCheck;
		}
		override public function _SetText( str:String ):void
		{
			super._SetText( str );
			m_pText._SetText( str );
			SetSize( m_pImageNormal.GetWidth() + 2 + m_pText.GetWidth() , DYM_GUI_MAX( m_pImageNormal.GetHeight() , m_pText.GetTextHeight() ) );
			if ( m_pText.GetTextHeight() < m_pImageNormal.GetHeight() )
			{
				m_pText.SetPos( m_pImageNormal.GetWidth() + 2 + m_nTextOffsetX , ( m_pImageNormal.GetHeight() - m_pText.GetTextHeight() ) / 2 + m_nTextOffsetY );
				m_pImageNormal.SetPos( 0 , 0 );
				m_pImageNormalCheck.SetPos( 0 , 0 );
				m_pImageLight.SetPos( 0 , 0 );
				m_pImageLightCheck.SetPos( 0 , 0 );
				m_pImageInvalid.SetPos( 0 , 0 );
				m_pImageInvalidCheck.SetPos( 0 , 0 );
			}
			else
			{
				m_pText.SetPos( m_pImageNormal.GetWidth() + 2 + m_nTextOffsetX , m_nTextOffsetY );
				var y:int = ( m_pText.GetTextHeight() - m_pImageNormal.GetHeight() ) / 1;
				m_pImageNormal.SetPos( 0 , y );
				m_pImageNormalCheck.SetPos( 0 , y );
				m_pImageLight.SetPos( 0 , y );
				m_pImageLightCheck.SetPos( 0 , y );
				m_pImageInvalid.SetPos( 0 , y );
				m_pImageInvalidCheck.SetPos( 0 , y );
			}
		}
		override public function SetStyleData( name:String , bSet:Boolean ):void
		{
			if ( name == "AnimateLight" )
			{
				super.SetStyleData( name , bSet );
				if ( name == "AnimateLight" )
				{
					if ( bSet )
					{
						m_pImageLight.FlashWindow( -1 , 500 , 0 , 0 );
						m_pImageLightCheck.FlashWindow( -1 , 500 , 0 , 0 );
					}
					else
					{
						m_pImageLight.FlashWindowDisable( 0 , 0 );
						m_pImageLightCheck.FlashWindowDisable( 0 , 0 );
					}
				}
			}
		}
	}

}