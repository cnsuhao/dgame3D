//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIAniImageBoxObj extends dUIImageBox
	{
		protected var m_nFrameID:int = -1;
		public function dUIAniImageBoxObj( pFather:dUIImage , bUsingMask:Boolean = false ) 
		{
			super( pFather );
		}
		public function SetFrameID( id:int ):void
		{
			m_nFrameID = id;
		}
		public function GetFrameID():int
		{
			return m_nFrameID;
		}
	}

}