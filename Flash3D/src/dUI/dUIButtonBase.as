//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIButtonBase extends dUIImage
	{
		protected var m_pNormalImage:dUIImage;
		protected var m_pLightImage:dUIImage;
		protected var m_pDownImage:dUIImage;
		protected var m_pInvalidImage:dUIImage;
		protected var m_pSelectImage:dUIImage;
		protected var m_pText:dUISuperText;
		protected var m_bLButtonDown:Boolean;
		protected var m_nNeedDown:int;
		public function dUIButtonBase( pFather:dUIImage ) 
		{
			super( pFather , true );
			CreateButtonImage();
			m_pNormalImage.SetUIEventFunction( OnImageEvent );
			m_pLightImage.SetUIEventFunction( OnImageEvent );
			m_pDownImage.SetUIEventFunction( OnImageEvent );
			m_pInvalidImage.SetUIEventFunction( OnImageEvent );
			m_pLightImage.SetShow( false );
			FlashLightImage( false );
			m_pDownImage.SetShow( false );
			m_pInvalidImage.SetShow( false );
			m_pText = new dUISuperText( this );
			var pImageSet:dUIImageSet = GetImageRoot().GetImageSet();
			var nTextOffsetX:int = pImageSet.GetImageRect( "按钮上的文字坐标和按下后的偏移" ).left;
			var nTextOffsetY:int = pImageSet.GetImageRect( "按钮上的文字坐标和按下后的偏移" ).top;
			SetEdgeRect( nTextOffsetX + 5 , nTextOffsetY , nTextOffsetX + 5 , nTextOffsetY );
			// 设置默认
			SetHandleMouse( true );
			SetSize( 50 , 20 );
			//m_bCanFlashWindow = true;
		}
		protected function OnImageEvent( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED )
			{
				m_nNeedDown --;
				if ( m_nNeedDown == 0 )
					FireEvent( dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED , GetWidth() , GetHeight() , GetImageSetName() );
			}
		}
		override public function LoadFromImageSet( strName:String ):void
		{
			m_strImageSetName = strName;
			m_nNeedDown = 4;
		}
		private function ShowLightButton( bShow:Boolean ):void
		{
			m_pLightImage.SetShow( bShow );
			if ( m_pLightImage.isHaveImg() || !bShow )
			{
				if ( isWindowEnable() && !isStyleData( "AnimateLight" ) )
					m_pNormalImage.SetShow( !bShow && !m_pDownImage.isShow() || m_pLightImage.GetAlpha() != 255 );
			}
		}
		override protected function OnFlashWindow( fLight:Number ):void
		{
			ShowLightButton( fLight > 0.0 );
			m_pLightImage.SetAlpha( fLight * 255 );
		}
		override public function SetAlignType( nType:int , nIndex:int = 0 ):void
		{
			super.SetAlignType( nType , nIndex );
			m_pText.SetAlignType( nType , nIndex );
		}
		override public function SetShow( bShow:Boolean ):void
		{
			super.SetShow( bShow );
			if ( !bShow )
			{
				m_pLightImage.SetShow( false );
				FlashLightImage( false );
				m_pDownImage.SetShow( false );
				ShowLightButton( false );
				m_pNormalImage.SetShow( true );
			}
		}
		override public function SetStyleData( name:String , bSet:Boolean ):void
		{
			if ( name == "AlwaysPushDown" ||
				name == "AutoSetSize" ||
				name == "AnimateLight" )
			{
				super.SetStyleData( name , bSet );
				if ( name == "AutoSetSize" )
				{
					m_pText.SetStyleData( "AutoSetSize" , bSet );
					if ( bSet && GetObjType() != dUISystem.GUIOBJ_TYPE_IMAGEBUTTON )
						SetSizeAsText();
				}
				else if ( name == "AnimateLight" )
				{
					FlashLightImage( bSet );
				}
			}
		}
		protected function FlashLightImage( bFlash:Boolean ):void
		{
			if ( bFlash ) m_pLightImage.FlashWindow( -1 , 500 , 0 , 0 );
			else m_pLightImage.FlashWindowDisable( 0 , 0 );
		}
		protected function CreateButtonImage():void
		{
		}
		public function SetPushDown( bDown:Boolean ):void
		{
			m_pDownImage.SetShow( bDown );
			m_pNormalImage.SetShow( !m_pDownImage.isShow() );
		}
		public function SetTextAlpha( alpha:int ):void
		{
			m_pText.SetAlpha( alpha );
		}
		public function GetPushDown():Boolean
		{
			return m_pDownImage.isShow();
		}
		override public function SetSize( w:int , h:int ):void
		{
			m_pNormalImage.SetSize( w , h );
			m_pLightImage.SetSize( w , h );
			m_pDownImage.SetSize( w , h );
			m_pInvalidImage.SetSize( w , h );
			m_pText.SetSize( w - GetEdgeWidth() , h - GetEdgeHeight() );
			m_pText.SetPos( GetEdgeLeft() , GetEdgeTop() );
			super.SetSize( w , h );
		}
		override public function _SetText( str:String ):void
		{
			m_pText._SetText( str );
			super._SetText( str );
			if ( isStyleData( "AutoSetSize" ) )
			{
				SetSizeAsText();
			}
			else
			{
				m_pText.SetPos( GetEdgeLeft() , GetEdgeTop() );
			}
		}
		public function SetSizeAsText():void
		{
			m_pText.SetSizeAsText();
			SetSize( m_pText.GetWidth() + GetEdgeWidth() , m_pText.GetHeight() + GetEdgeHeight() );
		}
		override public function OnMouseIn( x:int , y:int ):void
		{
			if ( isWindowEnable() && !m_bLButtonDown )
			{
				ShowLightButton( true );
				FlashLightImage( isStyleData( "AnimateLight" ) && !isFlashingWindow() );
			}
			super.OnMouseIn( x , y );
		}
		override public function OnMouseOut( x:int , y:int ):void
		{
			if ( isWindowEnable() )
			{
				ShowLightButton( false );
				FlashLightImage( false );
			}
			super.OnMouseOut( x , y );
		}
		override public function SetHandleMouse( bSet:Boolean ):void
		{
			super.SetHandleMouse( bSet );
			if ( !bSet ) ShowLightButton( false );
		}
		override public function OnLButtonDown( x:int , y:int ):void
		{
			m_bLButtonDown = true;
			if ( isWindowEnable() )
			{
				if ( isStyleData( "AlwaysPushDown" ) )
					m_pDownImage.SetShow( !m_pDownImage.isShow() );
				else
					m_pDownImage.SetShow( true );
				m_pNormalImage.SetShow( !m_pDownImage.isShow() );
				ShowLightButton( false );
				FireEvent( dUISystem.GUIEVENT_TYPE_BUTTON_DOWN , 0 , 0 , GetText() );
			}
		}
		override public function OnLButtonUp( x:int , y:int ):void
		{
			m_bLButtonDown = false;
			if( isMouseIn() )
				ShowLightButton( true );
			if ( !isStyleData( "AlwaysPushDown" ) )
			{
				m_pDownImage.SetShow( false );
				m_pNormalImage.SetShow( !m_pDownImage.isShow() );
			}
			if ( isWindowEnable() )
			{
				if( isMouseIn() )
					FireEvent( dUISystem.GUIEVENT_TYPE_BUTTON_UP , 0 , 0 , GetText() );
				else
					FireEvent( dUISystem.GUIEVENT_TYPE_BUTTON_UP_OUT , 0 , 0 , GetText() );
			}
		}
		override public function EnableWindow( bEnable:Boolean ):void
		{
			if ( m_pInvalidImage )
			{
				m_pInvalidImage.SetShow( !bEnable );
				m_pNormalImage.SetShow( bEnable );
			}
			if ( bEnable )
				ShowLightButton( isMouseIn() );
			else
				m_pLightImage.SetShow( bEnable );
			m_pText.SetAlpha( bEnable?255:128 );
			super.EnableWindow( bEnable );
		}
		override public function OnLButtonDrag( x:int , y:int ):void
		{
			FireEvent( dUISystem.GUIEVENT_TYPE_BUTTON_DRAG , x , y );
		}
		override public function SetEdgeRect( left:int , top:int , right:int , bottom:int ):void
		{
			super.SetEdgeRect( left , top , right , bottom );
			_SetText( GetText() );
		}
	}

}