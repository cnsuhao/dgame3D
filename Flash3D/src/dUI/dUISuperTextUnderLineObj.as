//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUISuperTextUnderLineObj extends dUIImageBox
	{
		public var m_nUnderLineID:int = -1;
		//public var m_rcBound:Rectangle;
		public function dUISuperTextUnderLineObj( pFather:dUIImage ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_SUPERTEXTLINEOBJ;
			SetHandleMouse( true );
			//pFather.DrawTo( this , 0 , 0 , GetWidth() , GetHeight() , 0 , 0 , GetWidth() , GetHeight() );
			//FillColor( 0x80FF0000 );
			//FlashWindow( -1 , 500 , 0 , 0 );
			/*useHandCursor = true;
			buttonMode = true;
			tabEnabled = false;*/
		}
		/*public function GetSuperTextFather():dUISuperText
		{
			return GetFather() as dUISuperText;
		}
		override public function OnLButtonDown( x:int , y:int ):void
		{
			if ( root && root.stage ) root.stage.focus = null;
			super.OnLButtonDown( x , y );
			GetSuperTextFather().OnUnderLineObjDown( this );
		}
		override public function OnMouseIn( x:int , y:int ):void
		{
			if ( !isRelease() )
			{
				super.OnMouseIn( x , y );
				GetSuperTextFather().OnUnderLineObjMouseIn( this , x , y );
			}
		}
		override public function OnMouseOut( x:int , y:int ):void
		{
			if ( !isRelease() )
			{
				super.OnMouseOut( x , y );
				GetSuperTextFather().OnUnderLineObjMouseOut( this , x , y );
			}
		}*/
	}

}