//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUITileImageH3 extends dUITileImageT9
	{
		/*protected var m_pObjLeft:dUIImage;
		protected var m_pObjMid:dUIImage;
		protected var m_pObjRight:dUIImage;
		protected var m_rcRightImageSrc:dUIImageRect = new dUIImageRect();
		public function dUITileImageH3( pFather:dUIImage , bUsingMask:Boolean = false ) 
		{
			super( pFather , bUsingMask );
			m_pObjLeft = new dUIImage( this );
			m_pObjMid = new dUIImage( this );
			m_pObjRight = new dUIImage( this );
		}
		override public function _LoadFromImageSet( strName:String ):void
		{
			var str:Vector.<String> = SplitName( strName , 3 );
			m_pObjLeft.LoadFromImageSet( str[0] );
			m_pObjMid.LoadFromImageSet( str[1] );
			m_pObjRight.LoadFromImageSet( str[2] );
			m_rcRightImageSrc = m_pObjRight.GetImageSrcRect();
			SetSize( 0 , m_pObjMid.GetImageSrcRect().Height() );
		}
		override public function SetSize( w:int , h:int ):void
		{
			if( w < 0 ) w = 0;
			if( h < 0 ) h = 0;
			m_pObjLeft.SetSize( DYM_GUI_MIN( m_pObjLeft.GetImageSrcRect().Width () , w/2 ) , h );
			m_pObjRight.SetSize( DYM_GUI_MIN( m_rcRightImageSrc.Width () , w/2 ) , h );
			if( m_pObjRight.GetWidth() < m_rcRightImageSrc.Width() )
				m_pObjRight.SetImageSrcRect( new dUIImageRect( (m_rcRightImageSrc.Width()-m_pObjRight.GetWidth())+m_rcRightImageSrc.left  , 
				m_rcRightImageSrc.top , m_rcRightImageSrc.right , m_rcRightImageSrc.bottom ) );
			else
				m_pObjRight.SetImageSrcRect( m_rcRightImageSrc );
			m_pObjRight.SetSize( DYM_GUI_MIN( m_rcRightImageSrc.Width () , w/2+1 ) , h );
			m_pObjMid.SetSize( w-m_pObjLeft.GetWidth()-m_pObjRight.GetWidth() , h );
			m_pObjMid.SetPos ( m_pObjLeft.GetWidth() , 0 );
			m_pObjRight.SetPos ( m_pObjLeft.GetWidth()+m_pObjMid.GetWidth() , 0 );

			return super.SetSize ( w , h );
		}
		override public function SetAlpha( nAlpha255:int , bSetToChild:Boolean = true ):void
		{
			super.SetAlpha( nAlpha255 , bSetToChild );
			m_pObjLeft.SetAlpha( nAlpha255 , bSetToChild );
			m_pObjMid.SetAlpha( nAlpha255 , bSetToChild );
			m_pObjRight.SetAlpha( nAlpha255 , bSetToChild );
		}*/
		public function dUITileImageH3( pFather:dUIImage , bUsingMask:Boolean = false ) 
		{
			super( pFather , bUsingMask , false );
		}
		override public function _LoadFromImageSet( strName:String ):void
		{
			super._LoadFromImageSet( strName );
			var rc:dUIImageRect = GetImageRoot().GetImageSet().GetImageRect( strName.split( "," )[0] , true );
			if( rc )
				SetSize( 0 , rc.Height() );
		}
		override public function OnLoadImageComplate( strImageFileName:String , arr:Array ):void
		{
			if ( !m_bRelease && strImageFileName == m_strImageSetName )
			{
				m_arrImage = arr;
				if ( m_arrImage.length < 3 )
				{
					for ( var i:int = m_arrImage.length ; i < 3 ; i ++ )
						m_arrImage[i] = m_arrImage[i - 1];
				}
				_computeSrcRectTile9();
				FireEvent( dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED );
			}
		}
		override public function _computeTilePic():void
		{
			if ( m_arrImage )
			{
				var w:int = GetWidth();
				var h:int = GetHeight();
				var w1:int = DYM_GUI_MIN( w / 2 , m_arrImage[0].GetWidth() );
				var w2:int = DYM_GUI_MIN( ( w + 1 )/ 2 , m_arrImage[2].GetWidth() );
				_computeTileBitblt( 0 , new dUIImageRect( 0 , 0 , w1 , m_arrImage[0].GetHeight() ) , new dUIImageRect( 0 , 0 , w1 , h ) );
				_computeTileBitblt( 1 , new dUIImageRect( 0 , 0 , m_arrImage[1].GetWidth() , m_arrImage[1].GetHeight() ) , new dUIImageRect( w1 , 0 , w - w2 , h ) );
				_computeTileBitblt( 2 , new dUIImageRect( m_arrImage[2].GetWidth() - w2 , 0 , m_arrImage[2].GetWidth() , m_arrImage[2].GetHeight() ) , new dUIImageRect( w - w2 , 0 , w , h ) );
			}
		}
	}

}