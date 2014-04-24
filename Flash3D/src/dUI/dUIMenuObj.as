//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIMenuObj extends dUISuperText
	{
		protected var m_pHaveChild:dUIImage;
		protected var m_pComboBox:dUIMenuComboBox;
		protected var m_nIndex:int;
		public function dUIMenuObj( pFather:dUIImage , pComboBox:dUIMenuComboBox , nIndex:int )
		{
			super( pFather );
			m_pComboBox = pComboBox;
			m_nIndex = nIndex;
		}
		override public function SetSize( w:int , h:int ):void
		{
			super.SetSize( w , h );
			Update();
		}
		/*override public function OnMouseIn( x:int , y:int ):void
		{
			super.OnMouseIn( x , y );
			m_pComboBox.OnMenuChildMouseIn( this , m_nIndex );
		}
		override public function OnMouseOut( x:int , y:int ):void
		{
			super.OnMouseOut( x , y );
		}*/
		public function SetHaveChild( bHave:Boolean ):void
		{
			if ( bHave )
			{
				m_pHaveChild = new dUIImageBox( this );
				m_pHaveChild.LoadFromImageSet( "横滚动条箭头正常下" );
				Update();
			}
			else
			{
				if ( m_pHaveChild ) m_pHaveChild.Release();
				m_pHaveChild = null;
			}
		}
		protected function Update():void
		{
			if ( m_pHaveChild )
				m_pHaveChild.SetPos( GetWidth() - m_pHaveChild.GetWidth() - 10 , ( GetHeight() - m_pHaveChild.GetHeight() ) / 2 );
		}
		public function GetChildButtonWidth():int
		{
			if ( m_pHaveChild ) return m_pHaveChild.GetWidth();
			return 10;
		}
	}

}