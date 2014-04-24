//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	import dcom.*;
	/**
	 * ...
	 * @author dym
	 */
	public class dUIProgress extends dUIImage
	{
		protected var m_pBk:dUIImage;
		protected var m_pImage:dUIImage;
		protected var m_pText:dUISuperText;
		protected var m_nValue:int;
		protected var m_nValueMax:int = 100;
		protected var m_nImageOffsetLeft:int;
		protected var m_nImageOffsetRight:int;
		protected var m_pImageFather:dUIImage;
		public function dUIProgress( pFather:dUIImage ) 
		{
			super( pFather , false );
			m_nObjType = dUISystem.GUIOBJ_TYPE_PROGRESS;
			// 设置默认
			//LoadFromImageSet( "默认进度条空左,默认进度条空中,默认进度条空右,默认进度条满左,默认进度条满中,默认进度条满右" );
			SetStyleData( "ImageProgress" , true );
		}
		override public function _LoadFromImageSet( name:String ):void
		{
			if ( isStyleData( "ImageProgress" ) )
			{
				var str:Vector.<String> = SplitName( name , 2 );
				m_pBk.LoadFromImageSet( str[0] );
				m_pImage.LoadFromImageSet( str[1] );
			}
			else
			{
				str = SplitName( name , 6 );
				m_pBk.LoadFromImageSet( str[0] + "," + str[1] + "," + str[2] );
				m_pImage.LoadFromImageSet( str[3] + "," + str[4] + "," + str[5] );
			}
			//SetSize( DYM_GUI_MAX( m_pBk.GetWidth() , m_pImage.GetWidth() ) , DYM_GUI_MAX( m_pBk.GetHeight() , m_pImage.GetHeight() ) );
			_SetText( GetText() );
		}
		private function _OnImageLoadOK( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED )
			{
				//m_pImage.SetImageSrcRect( new dUIImageRect( 0 , 0 , event.nParam1 , event.nParam2 ) );
				if ( isStyleData( "ImageProgress" ) )
				{
					var rc:dUIImageRect = m_pImage.GetImageColorBound( 0 );
					m_nImageOffsetLeft = rc.left;
					m_nImageOffsetRight = event.nParam1 - rc.right;
				}
				else
				{
					rc = m_pImage.GetImageColorBound( 0 );
					m_nImageOffsetLeft = rc.left;
					rc = m_pImage.GetImageColorBound( 2 );
					m_nImageOffsetRight = ( m_pImage as dUITileImageT9 ).GetImage( 2 ).GetWidth() - rc.right;
				}
				Update();
			}
		}
		public function GetProgressImageSetName( index:int ):String
		{
			if ( isStyleData( "ImageProgress" ) )
			{
				if ( index == 0 ) return m_pBk.GetImageSetName();
				if ( index == 1 ) return m_pImage.GetImageSetName();
			}
			else
			{
				var vecName1:Vector.<String> = SplitName( m_pBk.GetImageSetName() , 3 );
				var vecName2:Vector.<String> = SplitName( m_pImage.GetImageSetName() , 3 );
				if ( index == 0 ) return vecName1[0];
				if ( index == 1 ) return vecName1[1];
				if ( index == 2 ) return vecName1[2];
				if ( index == 3 ) return vecName2[0];
				if ( index == 4 ) return vecName2[1];
				if ( index == 5 ) return vecName2[2];
			}
			return "";
		}
		override public function SetSize( w:int , h:int ):void
		{
			if ( m_pBk && m_pImage && m_pText )
			{
				if ( w != GetWidth() || h != GetHeight() )
					_SetSize( w , h );
			}
			super.SetSize( w , h );
		}
		protected function _SetSize( w:int , h:int ):void
		{
			m_pBk.SetSize( w , h );
			m_pImage.SetSize( w , h );
			var textH:int = h;
			var textH2:int = m_pText.GetTextHeight() + 2;
			if ( textH < textH2 )
			{
				m_pText.SetPos( 0 , (textH - textH2)/2 );
				textH = textH2;
			}
			else m_pText.SetPos( 0 , 0 );
			m_pText.SetSize( w , textH );
			if ( isStyleData( "Vertical" ) )
			{
				if( m_pImage.GetWidth() < m_pBk.GetWidth() )
					m_pImage.SetPos( ( m_pBk.GetWidth() - m_pImage.GetWidth() ) / 2 , 0 );
				else
					m_pBk.SetPos( ( m_pImage.GetWidth() - m_pBk.GetWidth() ) / 2 , 0 );
			}
			else
			{
				if ( m_pImage.GetHeight() < m_pBk.GetHeight() )
					m_pImage.SetPos( 0 , ( m_pBk.GetHeight() - m_pImage.GetHeight() ) / 2 );
				else
					m_pBk.SetPos( 0 , ( m_pImage.GetHeight() - m_pBk.GetHeight() ) / 2 );
			}
			Update();
		}
		public function SetValue( v:int ):void
		{
			if ( v < 0 ) v = 0;
			if ( m_nValue != v )
			{
				m_nValue = v;
				Update();
				UpdateText();
			}
		}
		protected function UpdateText():void
		{
			if ( isStyleData( "AutoTextPersent" ) )
				SetText( int( GetValue() * 100 / GetMaxValue() ) + "%" );
			else if ( isStyleData( "AutoTextDiv" ) )
				SetText( GetValue() + "/" + GetMaxValue() );
			else if ( isStyleData( "AutoTextCurValue" ) )
				SetText( String( GetValue() ) );
		}
		public function GetValue():int
		{
			return m_nValue;
		}
		public function SetMaxValue( v:int ):void
		{
			if ( m_nValueMax != v )
			{
				m_nValueMax = v;
				Update();
			}
		}
		public function GetMaxValue():int
		{
			return m_nValueMax;
		}
		override public function SetAlignType( nType:int , nIndex:int = 0 ):void
		{
			super.SetAlignType( nType , nIndex );
			m_pText.SetAlignType( nType , nIndex );
		}
		protected function Update():void
		{
			var max:int = m_nValueMax;
			var v:int = m_nValue;
			if ( max < 1 ) max = 1;
			if ( v > max ) v = max;
			var scale:Number = 1.0;
			if ( isStyleData( "Vertical" ) )
			{
				if ( isStyleData( "ImageProgress" ) )
				{
					if ( m_pImage.GetHeight() && m_pImage.GetImage( 0 ) )
						scale = m_pImage.GetHeight() / m_pImage.GetImage( 0 ).GetHeight();
					if ( isStyleData( "Mirror" ) )
					{
						m_pImageFather.SetPos( 0 , 0 );
						m_pImageFather.SetSize( m_pImage.GetWidth() , v * m_pBk.GetHeight() / max );
						m_pImage.SetPos( 0 , 0 );
					}
					else
					{
						var vv:int = v * m_pBk.GetHeight() / max;
						var y:int = m_pBk.GetHeight() - vv;
						m_pImageFather.SetSize( m_pImage.GetWidth() , v * m_pBk.GetHeight() / max );
						m_pImageFather.SetPos( m_pImage.GetPosX() , y );
						m_pImage.SetPos( m_pImage.GetPosX() , -y );
					}
				}
				else
				{
					if ( isStyleData( "Mirror" ) )
					{
						vv = v * m_pBk.GetHeight() / max;
						y = m_pBk.GetHeight() - vv;
						m_pImage.SetPos( m_pImage.GetPosX() , y );
						m_pImage.SetSize( m_pImage.GetWidth() , v * m_pBk.GetHeight() / max );
					}
					else
					{
						m_pImage.SetPos( 0 , 0 );
						m_pImage.SetSize( m_pImage.GetWidth() , v * m_pBk.GetHeight() / max );
					}
				}
			}
			else
			{
				if ( isStyleData( "ImageProgress" ) )
				{
					if ( m_pImage.GetWidth() && m_pImage.GetImage( 0 ) )
						scale = m_pImage.GetWidth() / m_pImage.GetImage( 0 ).GetWidth();
					if ( isStyleData( "Mirror" ) )
					{
						vv = v * m_pBk.GetWidth() / max;
						var x:int = m_pBk.GetWidth() - vv;
						m_pImageFather.SetSize( v * (m_pImage.GetWidth() - m_nImageOffsetRight * scale - m_nImageOffsetLeft * scale ) / max + m_nImageOffsetLeft * scale , m_pImage.GetHeight() );
						m_pImageFather.SetPos( x , m_pImage.GetPosY() );
						m_pImage.SetPos( -x , m_pImage.GetPosY() );
					}
					else
					{
						m_pImage.SetPos( 0 , 0 );
						m_pImageFather.SetPos( 0 , 0 );
						m_pImageFather.SetSize( v * (m_pImage.GetWidth() - m_nImageOffsetRight * scale - m_nImageOffsetLeft * scale ) / max + m_nImageOffsetLeft * scale , m_pImage.GetHeight() );
					}
				}
				else
				{
					if ( isStyleData( "Mirror" ) )
					{
						vv = v * m_pBk.GetWidth() / max;
						x = m_pBk.GetWidth() - vv;
						m_pImage.SetPos( x , 0 );
						m_pImage.SetSize( v * (m_pBk.GetWidth() - m_nImageOffsetLeft * scale - m_nImageOffsetRight * scale ) / max + m_nImageOffsetLeft * scale + m_nImageOffsetRight * scale , m_pImage.GetHeight() );
					}
					else
					{
						m_pImage.SetPos( 0 , 0 );
						m_pImage.SetSize( v * (m_pBk.GetWidth() - m_nImageOffsetLeft * scale - m_nImageOffsetRight * scale ) / max + m_nImageOffsetLeft * scale + m_nImageOffsetRight * scale , m_pImage.GetHeight() );
					}
				}
			}
		}
		override public function SetStyleData( name:String , bSet:Boolean ):void
		{
			if ( name == "ImageProgress" || name == "Vertical" ||
				 name == "AutoTextPersent" || name == "AutoTextDiv" ||
				 name == "AutoTextCurValue" || name == "Mirror" )
			{
				if ( isStyleData( name ) == bSet ) return;
				if ( name == "ImageProgress" && isStyleData( name ) != bSet )
				{
					if ( m_pBk ) m_pBk.Release();
					if ( m_pImage ) m_pImage.Release();
					if ( m_pText ) m_pText.Release();
					if ( m_pImageFather )
					{
						m_pImageFather.Release();
						m_pImageFather = null;
					}
					if ( bSet )
					{
						m_pBk = new dUIImageBox( this );
						m_pImageFather = new dUIImage( this , true );
						m_pImage = new dUIImageBox( m_pImageFather );
						m_pImage.SetUIEventFunction( _OnImageLoadOK );
					}
					else
					{
						if ( isStyleData( "Vertical" ) )
						{
							m_pBk = new dUITileImageV3( this );
							m_pImage = new dUITileImageV3( this );
							m_pImage.SetUIEventFunction( _OnImageLoadOK );
						}
						else
						{
							m_pBk = new dUITileImageH3( this );
							m_pImage = new dUITileImageH3( this );
							m_pImage.SetUIEventFunction( _OnImageLoadOK );
						}
					}
					m_pText = new dUISuperText( this );
					super.SetStyleData( name , bSet );
					SetText( "" );
					LoadFromImageSet( "" );
				}
				else if ( (name == "AutoTextPersent" || name == "AutoTextDiv" ||name == "AutoTextCurValue" ) && bSet )
				{
					super.SetStyleData( name , bSet );
					UpdateText();
				}
				else if ( name == "Mirror" || name == "Vertical" )
				{
					super.SetStyleData( name , bSet );
					Update();
				}
				super.SetStyleData( name , bSet );
			}
		}
		override public function _SetText( str:String ):void
		{
			super._SetText( str );
			m_pText._SetText( str );
			_SetSize( GetWidth() , GetHeight() );
		}
		private var m_nBeginAddTotalTime:int;
		private var m_nBeginAddCurTime:int;
		private var m_pTimer:dTimer;
		public function BeginAdd( nTotalTime:int ):void
		{
			if ( !m_pTimer )
			{
				m_pTimer = new dTimer();
				m_pTimer.Create( 0 , 0 , _OnFrameMove );
			}
			m_nBeginAddTotalTime = nTotalTime;
			m_nBeginAddCurTime = 0;
			SetValue( 0 );
		}
		public function Stop():void
		{
			if ( m_pTimer )
			{
				m_pTimer.Stop();
				m_pTimer = null;
			}
		}
		private function _OnFrameMove( pTimer:dTimer , nRepeat:int ):void
		{
			m_nBeginAddCurTime += GetImageRoot().GetTimeSinceLastFrame();
			var bFire:Boolean = false;
			if ( m_nBeginAddCurTime > m_nBeginAddTotalTime )
			{
				m_nBeginAddCurTime = m_nBeginAddTotalTime;
				bFire = true;
				Stop();
			}
			SetValue( m_nBeginAddCurTime * GetMaxValue() / m_nBeginAddTotalTime );
			if( bFire ) FireEvent( dUISystem.GUIEVENT_TYPE_PROGRESS_STOP_ADD );
		}
	}

}