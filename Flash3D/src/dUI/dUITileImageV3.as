//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUITileImageV3 extends dUITileImageT9
	{
		public function dUITileImageV3( pFather:dUIImage , bUsingMask:Boolean = false ) 
		{
			super( pFather , bUsingMask , false );
		}
		override public function _LoadFromImageSet( strName:String ):void
		{
			super._LoadFromImageSet( strName );
			var rc:dUIImageRect = GetImageRoot().GetImageSet().GetImageRect( strName.split( "," )[0] , true );
			if( rc )
				SetSize( rc.Width() , 0 );
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
				var h1:int = DYM_GUI_MIN( h / 2 , m_arrImage[0].GetHeight() );
				var h2:int = DYM_GUI_MIN( (h+1) / 2 , m_arrImage[2].GetHeight() );
				_computeTileBitblt( 0 , new dUIImageRect( 0 , 0 , m_arrImage[0].GetWidth() , h1 ) , new dUIImageRect( 0 , 0 , w , h1 ) );
				_computeTileBitblt( 1 , new dUIImageRect( 0 , 0 , m_arrImage[1].GetWidth() , m_arrImage[1].GetHeight() ) , new dUIImageRect( 0 , h1 , w , h - h2 ) );
				_computeTileBitblt( 2 , new dUIImageRect( 0 , m_arrImage[2].GetHeight() - h2 , m_arrImage[2].GetWidth() , m_arrImage[2].GetHeight() ) , new dUIImageRect( 0 , h - h2 , w , h ) );
			}
		}
	}

}