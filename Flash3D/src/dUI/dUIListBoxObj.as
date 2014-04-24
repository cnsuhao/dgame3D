//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIListBoxObj extends dUIImageBox
	{
		public var m_pData:dUIImage;
		protected var m_pListBox:dUIListBox;
		public function dUIListBoxObj( pFather:dUIImage )
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_LISTBOXOBJ;
			RegMouseLowEvent( true );
			RegCanDoubleClick( true );
		}
		public function SetListBox( pListBox:dUIListBox ):void
		{
			m_pListBox = pListBox;
			SetHandleMouse( pListBox.isHandleMouse() );
		}
		override public function Release():void
		{
			ReleaseData();
			super.Release();
		}
		public function ReleaseData():void
		{
			if ( m_pData )
				m_pData.Release();
			m_pData = null;
		}
		override public function GetText():String
		{
			if ( m_pData ) return m_pData.GetText();
			return super.GetText();
		}
		override public function OnMouseIn( x:int , y:int ):void
		{
			//super.OnMouseIn( x , y );
			if ( m_bRegMouseLowEvent )
				FireEvent( dUISystem.GUIEVENT_TYPE_MOUSE_IN );
			m_pListBox.OnListBoxObjOver( this , true );
		}
		override public function OnMouseOut( x:int , y:int ):void
		{
			super.OnMouseOut( x , y );
			m_pListBox.OnListBoxObjOver( this , false );
		}
		override public function OnLButtonDown( x:int , y:int ):void
		{
			super.OnLButtonDown( x , y );
			m_pListBox.OnListBoxObjLButton( this , true );
		}
		override public function OnLButtonUp( x:int , y:int ):void
		{
			super.OnLButtonUp( x , y );
			m_pListBox.OnListBoxObjLButton( this , false );
		}
		override public function OnLButtonDblClick( x:int , y:int ):void
		{
			super.OnLButtonDblClick( x , y );
			m_pListBox.OnListBoxObjLButtonDblClk( this , x , y );
		}
		override public function OnLButtonDrag( x:int , y:int ):void
		{
			super.OnLButtonDrag( x , y );
			m_pListBox.OnListBoxObjLButtonDrag( this , x , y );
		}
	}

}