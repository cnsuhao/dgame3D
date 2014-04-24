//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUISpliterView extends dUIImage
	{
		protected var m_pSpliter:dUISpliter;
		public function dUISpliterView( pFather:dUIImage , pSpliter:dUISpliter ) 
		{
			super( pFather , true );
			m_pSpliter = pSpliter;
		}
		override protected function AddChild( pImage:dUIImage , at:int = -1 ):void
		{
			super.AddChild( pImage , at );
			if( m_pSpliter.GetStaticScrollType() )
				m_pSpliter.NeedUpdate();
		}
	}

}