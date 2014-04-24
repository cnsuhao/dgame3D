//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUISpliter extends dUIImage
	{
		protected var m_pButtonH:dUIButton;
		protected var m_pButtonV:dUIButton;
		protected var m_pView1:dUISpliterView;
		protected var m_pView2:dUISpliterView;
		protected var m_pView3:dUISpliterView;
		protected var m_pView4:dUISpliterView;
		protected var m_nStaticScrollType:int;
		public function dUISpliter( pFather:dUIImage )
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_SPLITER;
			m_pView1 = new dUISpliterView( this , this );
			m_pView2 = new dUISpliterView( this , this );
			m_pView3 = new dUISpliterView( this , this );
			m_pView4 = new dUISpliterView( this , this );
			m_pButtonH = new dUIButton( this );
			m_pButtonV = new dUIButton( this );
			m_pButtonH.SetUIEventFunction( _OnButtonDrag );
			m_pButtonV.SetUIEventFunction( _OnButtonDrag );
			m_pButtonH.SetAutoPos( dUISystem.GUI_AUTOPOS_LEFT_TOP , dUISystem.GUI_AUTOPOS_CENTER );
			m_pButtonV.SetAutoPos( dUISystem.GUI_AUTOPOS_CENTER , dUISystem.GUI_AUTOPOS_LEFT_TOP );
			// 设置默认
			SetAutoSizeAsFather( true );
			RegAutoPosPanel( true );
			m_pView1.RegAutoPosPanel( true );
			m_pView2.RegAutoPosPanel( true );
			m_pView3.RegAutoPosPanel( true );
			m_pView4.RegAutoPosPanel( true );
			m_pView1.RegBringTopWhenClickWindow( true );
			m_pView2.RegBringTopWhenClickWindow( true );
			m_pView3.RegBringTopWhenClickWindow( true );
			m_pView4.RegBringTopWhenClickWindow( true );
			m_pButtonH.SetText( "" );
			m_pButtonV.SetText( "" );
			m_pButtonH.SetSize( 0 , 5 );
			m_pButtonV.SetSize( 5 , 0 );
			SetStyleData( "ShowHScroll" , true );
			SetStyleData( "ShowVScroll" , true );
			SetSize( pFather.GetClient().GetWidth() , pFather.GetClient().GetHeight() );
			m_pButtonH.SetPos( 0 , ( pFather.GetHeight() - m_pButtonH.GetHeight() ) / 2 );
			m_pButtonV.SetPos( ( pFather.GetWidth() - m_pButtonV.GetWidth() ) / 2 , 0 );
			Update();
		}
		private function _OnButtonDrag( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_BUTTON_DRAG )
			{
				if ( event.pObj == m_pButtonH )
				{
					var y:int = m_pButtonH.GetPosY() + event.nParam2;
					if ( y < 0 ) y = 0;
					else if ( y > GetHeight() - m_pButtonH.GetHeight() )
						y = GetHeight() - m_pButtonH.GetHeight();
					m_pButtonH.SetPos( m_pButtonH.GetPosX() , y );
				}
				else if ( event.pObj == m_pButtonV )
				{
					var x:int = m_pButtonV.GetPosX() + event.nParam1;
					if ( x < 0 ) x = 0;
					else if ( x > GetWidth() - m_pButtonV.GetWidth() )
						x = GetWidth() - m_pButtonV.GetWidth();
					m_pButtonV.SetPos( x , m_pButtonV.GetPosY() );
				}
				Update();
			}
		}
		override public function SetSize( w:int , h:int ):void
		{
			super.SetSize( w , h );
			Update();
		}
		protected function GetViewChildSize( pView1:dUIImage , pView2:dUIImage ):Vector.<int>
		{
			var ret:Vector.<int> = new Vector.<int>;
			ret.length = 2;
			var vecList:Vector.<dUIImage> = pView1.GetChild();
			for ( var i:int = 0 ; i < vecList.length ; i ++ )
			{
				var p:dUIImage = vecList[i];
				if ( ret[0] < p.GetPosX() + p.GetWidth() )
					ret[0] = p.GetPosX() + p.GetWidth();
				if ( ret[1] < p.GetPosY() + p.GetHeight() )
					ret[1] = p.GetPosY() + p.GetHeight();
			}
			vecList = pView2.GetChild();
			for ( i = 0 ; i < vecList.length ; i ++ )
			{
				p = vecList[i];
				if ( ret[0] < p.GetPosX() + p.GetWidth() )
					ret[0] = p.GetPosX() + p.GetWidth();
				if ( ret[1] < p.GetPosY() + p.GetHeight() )
					ret[1] = p.GetPosY() + p.GetHeight();
			}
			return ret;
		}
		public function NeedUpdate():void
		{
			GetImageRoot()._RegEnterFrame( Update );
		}
		public function Update():void
		{
			var w:int = GetWidth();
			var h:int = GetHeight();
			m_pButtonH.SetSize( w , m_pButtonH.GetHeight() );
			m_pButtonV.SetSize( m_pButtonV.GetWidth() , h );
			var nButtonWidth:int = m_pButtonV.GetWidth();
			var nButtonHeight:int = m_pButtonH.GetHeight();
			if ( !m_pButtonV.isShow() ) nButtonWidth = 0;
			if ( !m_pButtonH.isShow() ) nButtonHeight = 0;
			if ( m_nStaticScrollType == 1 )
			{
				var v:Vector.<int> = GetViewChildSize( m_pView1 , m_pView4 );
				m_pButtonV.SetPos( v[0] , 0 );
			}
			else if ( m_nStaticScrollType == 2 )
			{
				v = GetViewChildSize( m_pView1 , m_pView2 );
				m_pButtonV.SetPos( GetWidth() - v[0] , 0 );
			}
			else if ( m_nStaticScrollType == 3 )
			{
				v = GetViewChildSize( m_pView2 , m_pView4 );
				m_pButtonH.SetPos( 0 , v[1] );
			}
			else if ( m_nStaticScrollType == 4 )
			{
				v = GetViewChildSize( m_pView3 , m_pView4 );
				m_pButtonH.SetPos( 0 , GetHeight() - v[1] );
			}
			m_pView1.SetPos( 0 , 0 );
			m_pView2.SetPos( m_pButtonV.GetPosX() + nButtonWidth , 0 );
			m_pView3.SetPos( 0 , m_pButtonH.GetPosY() + nButtonHeight );
			m_pView4.SetPos( m_pButtonV.GetPosX() + nButtonWidth , m_pButtonH.GetPosY() + nButtonHeight );
			if ( isStyleData( "ShowHScroll" ) && isStyleData( "ShowVScroll" ) )
			{
				m_pView1.SetSize( m_pButtonV.GetPosX() , m_pButtonH.GetPosY() );
				m_pView2.SetSize( w - nButtonWidth - m_pButtonV.GetPosX() , m_pButtonH.GetPosY() );
				m_pView3.SetSize( m_pButtonV.GetPosX() , h - nButtonHeight - m_pButtonH.GetPosY() );
				m_pView4.SetSize( w - nButtonWidth - m_pButtonV.GetPosX() , h - nButtonHeight - m_pButtonH.GetPosY() );
			}
			else if ( isStyleData( "ShowHScroll" ) )
			{
				m_pView1.SetSize( w , m_pButtonH.GetPosY() );
				m_pView3.SetSize( w , h - nButtonHeight - m_pButtonH.GetPosY() );
			}
			else if ( isStyleData( "ShowVScroll" ) )
			{
				m_pView1.SetSize( m_pButtonV.GetPosX() , h );
				m_pView2.SetSize( w - nButtonWidth - m_pButtonV.GetPosX() , h );
			}
			else m_pView1.SetSize( w , h );
		}
		public function GetView( index:int ):dUIImage
		{
			if ( index == 0 ) return m_pView1;
			else if ( index == 1 ) return m_pView2;
			else if ( index == 2 ) return m_pView3;
			else if ( index == 3 ) return m_pView4;
			return m_pView1;
		}
		override public function SetStyleData( name:String , bSet:Boolean ):void
		{
			if ( name == "ShowHScroll" || name == "ShowVScroll" )
			{
				super.SetStyleData( name , bSet );
				if ( name == "ShowHScroll" )
				{
					m_pButtonH.SetShow( bSet );
					m_pView3.SetShow( bSet );
					m_pView4.SetShow( bSet );
					Update();
				}
				else if ( name == "ShowVScroll" )
				{
					m_pButtonV.SetShow( bSet );
					m_pView2.SetShow( bSet );
					m_pView4.SetShow( bSet );
					Update();
				}
			}
		}
		override public function SetAutoPos( xType:int , yType:int ):void
		{
			m_pButtonH.SetAutoPos( dUISystem.GUI_AUTOPOS_LEFT_TOP , yType );
			m_pButtonV.SetAutoPos( xType , dUISystem.GUI_AUTOPOS_LEFT_TOP );
		}
		override public function GetAutoPosX():int
		{
			return m_pButtonV.GetAutoPosX();
		}
		override public function GetAutoPosY():int
		{
			return m_pButtonH.GetAutoPosY();
		}
		public function SetValueH( nPersent:int ):void
		{
			m_pButtonH.SetPos( m_pButtonH.GetPosX() , nPersent * ( GetHeight() - m_pButtonH.GetHeight() ) / 100 );
			//m_pButtonH.SetPos( m_pButtonH.GetPosX() , nPersent );
			Update();
		}
		public function SetValueV( nPersent:int ):void
		{
			m_pButtonV.SetPos( nPersent * ( GetWidth() - m_pButtonV.GetWidth() ) / 100 , m_pButtonV.GetPosY() );
			//m_pButtonV.SetPos( nPersent , m_pButtonV.GetPosY() );
			Update();
		}
		public function SetStaticScrollType( type:int ):void
		{
			if ( type == 1 || type == 3 ) m_pButtonV.SetShow( false );
			else m_pButtonV.SetShow( isStyleData( "ShowVScroll" ) );
			if ( type == 2 || type == 4 ) m_pButtonH.SetShow( false );
			else m_pButtonH.SetShow( isStyleData( "ShowHScroll" ) );
			m_nStaticScrollType = type;
			Update();
		}
		public function GetStaticScrollType():int
		{
			return m_nStaticScrollType;
		}
	}

}