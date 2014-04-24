//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIGroup extends dUITileImageT9
	{
		
		public function dUIGroup( pFather:dUIImage ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_GROUP;
			LoadFromImageSet( "" );
			// 设置默认
			SetSize( 200 , 200 );
		}
		override public function GetDefaultSkin():String
		{
			return "组框1,组框2,组框3,组框4,组框5,组框6,组框7,组框8,组框9";
		}
		override public function SetHandleMouse( bSet:Boolean ):void
		{
			super.SetHandleMouse( bSet );
			RegMouseLowEvent( bSet );
		}
		override public function SetStyleData( name:String , bSet:Boolean ):void
		{
			if ( name == "ShowCloseButton" || name == "CanDrag" )
			{
				if ( isStyleData( name ) == bSet ) return;
				super.SetStyleData( name , bSet );
			}
		}
	}

}