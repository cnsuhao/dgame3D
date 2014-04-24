//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIScrollClient extends dUIImage
	{
		protected var m_pScroll:dUIScroll;
		public function dUIScrollClient( pFather:dUIImage , pScroll:dUIScroll ) 
		{
			super( pFather );
			m_pScroll = pScroll;
		}
		override public function SetSize( w:int , h:int ):void
		{
			super.SetSize( w , h );
			m_pScroll._SetClientSize( w , h );
		}
	}

}