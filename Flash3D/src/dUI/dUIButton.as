//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIButton extends dUIButtonBase
	{
		public function dUIButton( pFather:dUIImage ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_BUTTON;
			SetText( "按钮" );
		}
		override protected function CreateButtonImage():void
		{
			m_pNormalImage = new dUITileImageT9( this );
			m_pLightImage = new dUITileImageT9( this );
			m_pDownImage = new dUITileImageT9( this );
			m_pInvalidImage = new dUITileImageT9( this );
			LoadFromImageSet( "" );
		}
		override public function GetDefaultSkin():String
		{
			var pSet:dUIImageSet = GetImageRoot().GetImageSet();
			if ( pSet.GetImageRect( "#默认按钮" , true ) )
				return pSet.GetImageFileName( "#默认按钮" );
			return "按钮正常1,按钮正常2,按钮正常3,按钮正常4,按钮正常5,按钮正常6,按钮正常7,按钮正常8,按钮正常9,\
				按钮发亮1,按钮发亮2,按钮发亮3,按钮发亮4,按钮发亮5,按钮发亮6,按钮发亮7,按钮发亮8,按钮发亮9,\
				按钮按下1,按钮按下2,按钮按下3,按钮按下4,按钮按下5,按钮按下6,按钮按下7,按钮按下8,按钮按下9,\
				按钮无效1,按钮无效2,按钮无效3,按钮无效4,按钮无效5,按钮无效6,按钮无效7,按钮无效8,按钮无效9";
		}
		override public function LoadFromImageSet( strName:String ):void
		{
			super.LoadFromImageSet( strName );
			strName = ConvImageSetName( strName );
			if ( strName == "" ) strName = GetDefaultSkin();
			var s:Vector.<String> = SplitName( strName , 36 );
			m_pNormalImage.LoadFromImageSet( s[0] + "," + s[1] + "," + s[2] + "," + s[3] + "," + s[4] + "," + s[5] + "," + s[6] + "," + s[7] + "," + s[8] );
			m_pLightImage.LoadFromImageSet( s[9] + "," + s[10] + "," + s[11] + "," + s[12] + "," + s[13] + "," + s[14] + "," + s[15] + "," + s[16] + "," + s[17] );
			m_pDownImage.LoadFromImageSet( s[18] + "," + s[19] + "," + s[20] + "," + s[21] + "," + s[22] + "," + s[23] + "," + s[24] + "," + s[25] + "," + s[26] );
			m_pInvalidImage.LoadFromImageSet( s[27] + "," + s[28] + "," + s[29] + "," + s[30] + "," + s[31] + "," + s[32] + "," + s[33] + "," + s[34] + "," + s[35] );
		}
	}

}