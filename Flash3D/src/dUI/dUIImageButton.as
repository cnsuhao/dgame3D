//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIImageButton extends dUIButtonBase
	{
		public function dUIImageButton( pFather:dUIImage ) 
		{
			super( pFather );
			SetSize( 0 , 0 );
			m_nObjType = dUISystem.GUIOBJ_TYPE_IMAGEBUTTON;
		}
		override protected function CreateButtonImage():void
		{
			m_pNormalImage = new dUIImageBox( this );
			m_pLightImage = new dUIImageBox( this );
			m_pDownImage = new dUIImageBox( this );
			m_pInvalidImage = new dUIImageBox( this );
		}
		override protected function OnImageEvent( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED )
			{
				m_nNeedDown --;
				if ( m_nNeedDown == 0 )
				{
					if ( GetWidth() == 0 && GetHeight() == 0 )
						SetSize( m_pNormalImage.GetWidth() , m_pNormalImage.GetHeight() );
					FireEvent( dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED , GetWidth() , GetHeight() , GetImageSetName() );
				}
			}
		}
		override public function LoadFromImageSet( strName:String ):void
		{
			strName = ConvImageSetName( strName );
			if ( strName == "" ) strName = GetDefaultSkin();
			super.LoadFromImageSet( strName );
			var s:Vector.<String> = SplitName( strName , 4 );
			m_pNormalImage.LoadFromImageSet( s[0] );
			m_pLightImage.LoadFromImageSet( s[1] );
			m_pDownImage.LoadFromImageSet( s[2] );
			m_pInvalidImage.LoadFromImageSet( s[3] );
			if( GetWidth() == 0 && GetHeight() == 0 )
				SetSize( m_pNormalImage.GetWidth() , m_pNormalImage.GetHeight() );
		}
		public function GetImageSetName_Normal():String
		{
			return m_pNormalImage.GetImageSetName();
		}
		public function GetImageSetName_Light():String
		{
			return m_pLightImage.GetImageSetName();
		}
		public function GetImageSetName_Down():String
		{
			return m_pDownImage.GetImageSetName();
		}
		public function GetImageSetName_Invalid():String
		{
			return m_pInvalidImage.GetImageSetName();
		}
		override public function SetRotation( nAngle:int , bMirrorX:Boolean = false , bMirrorY:Boolean = false ):void
		{
			super.SetRotation( nAngle , bMirrorX , bMirrorY );
			m_pNormalImage.SetRotation( nAngle , bMirrorX , bMirrorY );
			m_pLightImage.SetRotation( nAngle , bMirrorX , bMirrorY );
			m_pDownImage.SetRotation( nAngle , bMirrorX , bMirrorY );
			m_pInvalidImage.SetRotation( nAngle , bMirrorX , bMirrorY );
		}
	}

}