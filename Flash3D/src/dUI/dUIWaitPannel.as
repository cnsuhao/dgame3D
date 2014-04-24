//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIWaitPannel extends dUIImageBox
	{
		protected var m_pAni:dUIAniImageBox;
		public function dUIWaitPannel( pFather:dUIImage ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_WAITPANNEL;
			
			m_pAni = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_ANIIMAGEBOX , this , true , GetObjType() ) as dUIAniImageBox;
			m_pAni.LoadFromImageSet( "图标等待,12" );
			
			GetImageRoot()._RegEnterFrame( function():void
			{
				FillColor( 0x80000000 );
			} );
			SetHandleMouse( true );
		}
		override public function SetSize( w:int , h:int ):void
		{
			super.SetSize( w , h );
			m_pAni.SetPos( (GetWidth() - m_pAni.GetWidth()) / 2 , (GetHeight() - m_pAni.GetHeight()) / 2 );
		}
		override public function SetShow( bShow:Boolean ):void
		{
			if ( bShow != isShow() )
			{
				super.SetShow( bShow );
				if ( bShow )
					m_pAni.Play();
				else
					m_pAni.Stop();
			}
		}
	}

}