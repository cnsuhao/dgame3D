//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIListBoxTitle extends dUIButton
	{
		protected var m_pSortIcon:dUIImage;
		protected var m_nShowSortIcon:int;
		protected var m_nAlignVertical:int = 0;
		public function dUIListBoxTitle( pFather:dUIImage ) 
		{
			super( pFather )
		}
		public function SetShowSortIcon( nArrow:int ):void
		{
			if ( m_nShowSortIcon != nArrow )
			{
				m_nShowSortIcon = nArrow;
				if ( nArrow == 0 )
				{
					if ( m_pSortIcon ) m_pSortIcon.SetShow( false );
				}
				else
				{
					if ( !m_pSortIcon )
					{
						m_pSortIcon = new dUIImageBox( this );
						SetSortIconAlpha( 128 );
					}
					if ( nArrow == 1 )
						m_pSortIcon.LoadFromImageSet( "列表排序上正常" );
					else if ( nArrow == 2 )
						m_pSortIcon.LoadFromImageSet( "列表排序下正常" );
					UpdatePos();
				}
			}
		}
		public function GetShowSortIcon():int
		{
			return m_nShowSortIcon;
		}
		override public function _SetText( str:String ):void
		{
			super._SetText( str );
			UpdatePos();
		}
		protected function UpdatePos():void
		{
			if ( m_pSortIcon )
				m_pSortIcon.SetPos( GetWidth() - m_pSortIcon.GetWidth() - 2 , m_pText.GetPosY() + ( m_pText.GetHeight() - m_pSortIcon.GetHeight() ) / 2 );
		}
		public function SetSortIconAlpha( nAlpha:int ):void
		{
			if ( m_pSortIcon ) m_pSortIcon.SetAlpha( nAlpha );
		}
		public function GetAlignVertical():int
		{
			return m_nAlignVertical;
		}
		public function SetAlignVertical( nAlign:int ):void
		{
			m_nAlignVertical = nAlign;
		}
	}

}