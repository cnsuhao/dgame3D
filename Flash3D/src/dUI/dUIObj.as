//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIObj 
	{
		protected var m_id:int;
		protected var m_ui:dUISystem;
		public function dUIObj( id:int , ui:dUISystem ) 
		{
			m_id = id;
			m_ui = ui;
		}
		public function get x():int
		{
			return m_ui.GetPosX( m_id );
		}
		public function set x( _x:int ):void
		{
			m_ui.SetPos( m_id , _x , m_ui.GetPosY( m_id ) );
		}
		public function get y():int
		{
			return m_ui.GetPosY( m_id );
		}
		public function set y( _y:int ):void
		{
			m_ui.SetPos( m_id , m_ui.GetPosX( m_id ) , _y );
		}
		public function get width():int
		{
			return m_ui.GetWidth( m_id );
		}
		public function set width( w:int ):void
		{
			m_ui.SetSize( m_id , w , m_ui.GetHeight( m_id ) );
		}
		public function get height():int
		{
			return m_ui.GetHeight( m_id );
		}
		public function set height( h:int ):void
		{
			m_ui.SetSize( m_id , m_ui.GetWidth( m_id ) , h );
		}
		public function get alpha():Number
		{
			return m_ui.GetAlpha( m_id ) / 255;
		}
		public function set alpha( a:Number ):void
		{
			m_ui.SetAlpha( m_id , a * 255 );
		}
		public function get text():String
		{
			return m_ui.GetText( m_id );
		}
		public function set text( str:String ):void
		{
			m_ui.SetText( m_id , str );
		}
		public function get visable():Boolean
		{
			return Boolean( m_ui.isShow( m_id ) );
		}
		public function set visable( bShow:Boolean ):void
		{
			m_ui.SetShow( m_id , int( bShow ) );
		}
		public function get id():int
		{
			return m_id ;
		}
	}

}