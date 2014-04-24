//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	import dcom.dBitmapData;
	import dcom.dRect;
	/**
	 * 九切片的图像处理类
	 * @author dym
	 */
	public class dUITileImageT9 extends dUIImageCanDrag
	{
		protected var m_arrImage:Array;
		public function dUITileImageT9( pFather:dUIImage , bUsingMask:Boolean = false , bInit:Boolean = true )
		{
			super( pFather , bUsingMask );
		}
		override public function SetSize( w:int , h:int ):void
		{
			if ( GetWidth() != w || GetHeight() != h )
			{
				super.SetSize( w , h );
				_computeSrcRectTile9();
			}
		}
		override public function OnLoadImageComplate( strImageFileName:String , arr:Array ):void
		{
			if ( !m_bRelease && strImageFileName == m_strImageSetName )
			{
				m_bLoading = false;
				m_arrImage = arr;
				if ( m_arrImage.length < 9 )
				{
					for ( var i:int = m_arrImage.length ; i < 9 ; i ++ )
						m_arrImage[i] = m_arrImage[i - 1];
				}
				_computeSrcRectTile9();
				FireEvent( dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED );
			}
		}
		override public function OnSetShow( bShow:Boolean ):void
		{
			super.OnSetShow( bShow );
			if ( bShow )
				_computeSrcRectTile9();
			else
				ReleaseImg();
		}
		public function _computeSrcRectTile9():void
		{
			//GetImageRoot()._RegEnterFrame( function():void
			//{
				if ( m_arrImage && GetWidth() && GetHeight() && m_arrImage.length )
				{
					/*if ( !m_img || GetWidth() != m_img.GetWidth() || GetHeight() != m_img.GetHeight() )
					{
						m_img = new dUIImageBitmapData();
						m_img.Create( GetWidth() , GetHeight() , 0 );
						dSpriteSetBitmapData( m_img );
					}
					else m_img.FillColor( 0 );*/
					dSpriteCreateBitmapData( GetWidth() , GetHeight() );
					_computeTilePic();
					if ( m_nAlpha != 255 )
						dSpriteSetAlpha( m_nAlpha );
					if ( m_pColorTransform ) SetColorTransform( m_pColorTransform );
				}
				else if ( GetWidth() <= 0 || GetHeight() <= 0 )
				{
					//dSpriteSetBitmapData( null );
					dSpriteCreateBitmapData( 0 , 0 );
					if ( m_img ) m_img = null;
				}
			//} );
		}
		protected function _computeTileBitblt( idx:int , srcRect:dUIImageRect , descRect:dUIImageRect ):void
		{
			//m_img.Draw( m_arrImage[idx] , descRect.left , descRect.top , descRect.right , descRect.bottom , srcRect.left , srcRect.top , srcRect.right , srcRect.bottom );
			dSpriteDrawBitmapData( m_arrImage[idx] , descRect.left , descRect.top , descRect.right , descRect.bottom , srcRect.left , srcRect.top , srcRect.right , srcRect.bottom );
		}
		public function _computeTilePic():void
		{
			if ( m_arrImage )
			{
				var w:int = GetWidth();
				var h:int = GetHeight();
				var w1:int = DYM_GUI_MIN( w / 2 , m_arrImage[0].GetWidth() );
				var h1:int = DYM_GUI_MIN( h / 2 , m_arrImage[0].GetHeight() );
				var w2:int = DYM_GUI_MIN( w / 2 , m_arrImage[2].GetWidth() );
				var h2:int = DYM_GUI_MIN( h / 2 , m_arrImage[2].GetHeight() );
				_computeTileBitblt( 0 , new dUIImageRect( 0 , 0 , w1 , h1 ) , new dUIImageRect( 0 , 0 , w1 , h1 ) );
				_computeTileBitblt( 1 , new dUIImageRect( 0 , 0 , m_arrImage[1].GetWidth() , h1 ) , new dUIImageRect( w1 , 0 , w - w2 , h1 ) );
				_computeTileBitblt( 2 , new dUIImageRect( m_arrImage[2].GetWidth() - w2 , 0 , m_arrImage[2].GetWidth() , h2 ) , new dUIImageRect( w - w2 , 0 , w , h2 ) );
				var w3:int = DYM_GUI_MIN( w / 2 , m_arrImage[6].GetWidth() );
				var h3:int = DYM_GUI_MIN( h / 2 , m_arrImage[6].GetHeight() );
				var w4:int = DYM_GUI_MIN( w / 2 , m_arrImage[8].GetWidth() );
				var h4:int = DYM_GUI_MIN( h / 2 , m_arrImage[8].GetHeight() );
				
				var w5:int = DYM_GUI_MIN( w / 2 , m_arrImage[3].GetWidth() );
				var h5:int = DYM_GUI_MIN( h / 2 , m_arrImage[3].GetHeight() );
				var w6:int = DYM_GUI_MIN( w / 2 , m_arrImage[5].GetWidth() );
				var h6:int = DYM_GUI_MIN( h / 2 , m_arrImage[5].GetHeight() );
				
				_computeTileBitblt( 3 , new dUIImageRect( 0 , 0 , w5 , m_arrImage[3].GetHeight() ) , new dUIImageRect( 0 , h2 , w5 , h - h3 ) );
				_computeTileBitblt( 4 , new dUIImageRect( 0 , 0 , m_arrImage[4].GetWidth() , m_arrImage[4].GetHeight() ) , new dUIImageRect( w5 , h2 , w - w6 , h - h3 ) );
				_computeTileBitblt( 5 , new dUIImageRect( m_arrImage[5].GetWidth() - w6 , 0 , m_arrImage[5].GetWidth() , m_arrImage[5].GetHeight() ) , new dUIImageRect( w - w6 , h2 , w , h - h4 ) );
				
				_computeTileBitblt( 6 , new dUIImageRect( 0 , m_arrImage[6].GetHeight() - h3 , w3 , m_arrImage[6].GetHeight() ) , new dUIImageRect( 0 , h - h3 , w3 , h ) );
				_computeTileBitblt( 7 , new dUIImageRect( 0 , m_arrImage[7].GetHeight() - h3 , m_arrImage[7].GetWidth() , m_arrImage[7].GetHeight() ) , new dUIImageRect( w3 , h - h3 , w - w4 , h ) );
				_computeTileBitblt( 8 , new dUIImageRect( m_arrImage[8].GetWidth() - w4 , m_arrImage[8].GetHeight() - h4 , m_arrImage[8].GetWidth() , m_arrImage[8].GetHeight() ) , new dUIImageRect( w - w4 , h - h4 , w , h ) );
				
			}
		}
		override public function GetImage( idx:int ):dUIImageBitmapData
		{
			return m_arrImage[idx];
		}
		override public function GetSelfImage():dUIImageBitmapData
		{
			if ( !dSpriteGetBitmapData() ) return null;
			var ret:dUIImageBitmapData = new dUIImageBitmapData();
			ret.Copy( dSpriteGetBitmapData() );
			return ret;
		}
		override public function GetSelfImageWidth():int
		{
			return GetWidth();
		}
		override public function GetSelfImageHeight():int
		{
			return GetHeight();
		}
		override public function GetImageList():Array
		{
			return m_arrImage;
		}
		override public function DrawTo( pDest:dBitmapData , dest_left:int , dest_top:int , dest_right:int , dest_bottom:int , src_left:int , src_top:int , src_right:int , src_bottom:int , pClip:dRect = null ):void
		{
			dSpriteDrawToBitmapData( pDest , dest_left , dest_top , dest_right , dest_bottom , src_left , src_top , src_right , src_bottom , pClip );
		}
		override public function GetImageColorBound( idx:int ):dUIImageRect
		{
			if ( idx < 0 || idx >= m_arrImage.length ) return new dUIImageRect();
			var rc:dRect = ( m_arrImage[idx] as dUIImageBitmapData ).GetColorBound();
			return new dUIImageRect( rc.left , rc.top , rc.right , rc.bottom );
		}
		override public function GetUsingResourceName( ret:Array ):void
		{
			if ( !m_arrImage ) return;
			for ( var i:int = 0 , n:int = m_arrImage.length ; i < n ; i ++ )
			{
				var img:dUIImageBitmapData = m_arrImage[i];
				if ( img )
				{
					if ( !ret[ img.m_strBitmapFileName ] )
						 ret[ img.m_strBitmapFileName ] = 0;
					ret[ img.m_strBitmapFileName ]++;
				}
			}
		}
	}

}