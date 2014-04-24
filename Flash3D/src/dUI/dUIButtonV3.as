//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIButtonV3 extends dUIButtonBase
	{
		public function dUIButtonV3( pFather:dUIImage ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_BUTTON;
		}
		override protected function CreateButtonImage():void
		{
			m_pNormalImage = new dUITileImageV3( this );
			m_pLightImage = new dUITileImageV3( this );
			m_pDownImage = new dUITileImageV3( this );
			m_pInvalidImage = new dUITileImageV3( this );
		}
		override public function LoadFromImageSet( strName:String ):void
		{
			strName = ConvImageSetName( strName );
			if ( strName == "" ) strName = GetDefaultSkin();
			super.LoadFromImageSet( strName );
			var s:Vector.<String> = SplitName( strName , 12 );
			m_pNormalImage.LoadFromImageSet( s[0] + "," + s[4] + "," + s[8] );
			m_pLightImage.LoadFromImageSet( s[1] + "," + s[5] + "," + s[9] );
			m_pDownImage.LoadFromImageSet( s[2] + "," + s[6] + "," + s[10] );
			m_pInvalidImage.LoadFromImageSet( s[3] + "," + s[7] + "," + s[11] );
			SetSize( m_pNormalImage.GetWidth() , m_pNormalImage.GetHeight() );
		}
		
	}

}