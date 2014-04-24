//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIRadioBox extends dUICheckBox
	{
		public function dUIRadioBox( pFather:dUIImage ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_RADIOBOX;
			// 设置默认
			LoadFromImageSet( "" );
			SetText( "RadioBox" );
		}
		override public function GetDefaultSkin():String
		{
			return "多选框正常未选,多选框正常已选,多选框鼠标移入未选,多选框鼠标移入已选,多选框无效未选,多选框无效已选";
		}
	}

}