//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIStaticText 
	{
		protected var m_strText:String = "";
		public function dUIStaticText() 
		{
			
		}
		public function SetText( str:String ):void
		{
			m_strText = str;
		}
		public function GetText():String
		{
			return m_strText;
		}
	}

}