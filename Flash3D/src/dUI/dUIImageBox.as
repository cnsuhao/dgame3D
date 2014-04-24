//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	import dcom.dRect;
	import dcom.dSprite;
	import dcom.dVector;
	/**
	 * ...
	 * @author dym
	 */
	public class dUIImageBox extends dUIImageCanDrag
	{
		public function dUIImageBox( pFather:dUIImage ) 
		{
			super( pFather , true );
			m_nObjType = dUISystem.GUIOBJ_TYPE_IMAGEBOX;
		}
		public function FillColor( color:uint ):void
		{
			var w:int = GetWidth();
			var h:int = GetHeight();
			CreateImage( 1 , 1 , color );
			SetSize( w , h );
			if ( isStyleData( "CircalMask" ) )
			{
				DrawMaskCircal();
			}
		}
		private function _DrawImage( objx:int , objy:int , clip_left:int , clip_top:int , clip_right:int , clip_bottom:int , pObj:dUIImage ):void
		{
			if ( clip_left >= clip_right || clip_top >= clip_bottom ||
				clip_left >= pObj.GetWidth() + objx || clip_top >= pObj.GetHeight() + objy ||
				clip_right <= objx || clip_bottom <= objy ) return;
			var vecChild:Vector.<dUIImage> = pObj.GetChild();
			//if ( pObj.GetSelfImage() )
				pObj.DrawTo( m_img , objx , objy , pObj.GetWidth() + objx , pObj.GetHeight() + objy ,
					0 , 0 , pObj.GetSelfImageWidth() , pObj.GetSelfImageHeight() ,
					new dRect( clip_left , clip_top , clip_right , clip_bottom ) );
			for ( var i:int = 0 ; i < vecChild.length ; i ++ )
			{
				var img:dUIImage = vecChild[i];
				if ( img.isShow() )
				{
					var ox:int = img.GetPosX() + objx;
					var oy:int = img.GetPosY() + objy;
					var clip_left2:int = ox;
					var clip_top2:int = oy;
					var clip_right2:int = img.GetWidth() + clip_left2;
					var clip_bottom2:int = img.GetHeight() + clip_top2;
					if ( clip_left2 < clip_left ) clip_left2 = clip_left;
					if ( clip_top2 < clip_top ) clip_top2 = clip_top;
					if ( clip_right2 > clip_right ) clip_right2 = clip_right;
					if ( clip_bottom2 > clip_bottom ) clip_bottom2 = clip_bottom;
					_DrawImage( ox , oy , clip_left2 , clip_top2 , clip_right2 , clip_bottom2 , img );
				}
			}
		}
		public function DrawWindow( pImage:dUIImage ):void
		{
			var w:int = pImage.GetWidth();
			var h:int = pImage.GetHeight();
			if ( !m_img || m_img.GetWidth() != w || m_img.GetHeight() != h )
				CreateImage( w , h , 0 );
			SetSize( w , h );
			_DrawImage( 0 , 0 , 0 , 0 , w , h , pImage );
		}
		public function GetColorData( left:int = 0 , top:int = 0 , right:int = 0 , bottom:int = 0 ):dVector
		{
			if ( !m_img ) return null;
			return m_img.GetPixels( left , top , right , bottom );
		}
		public function DrawMaskCircal():void
		{
			dSpriteDrawMaskCircal();
		}
		override public function SetHandleMouse( bSet:Boolean ):void
		{
			super.SetHandleMouse( bSet );
			RegMouseLowEvent( bSet );
		}
		override public function OnMouseMove( x:int , y:int ):void
		{
			if( !m_bDragging )
				FireEvent( dUISystem.GUIEVENT_TYPE_IMAGEBOX_MOUSE_MOVE , x , y );
		}
		override public function SetSize( w:int , h:int ):void
		{
			if ( GetWidth() != w || GetHeight() != h )
			{
				super.SetSize( w , h );

				if ( isStyleData( "CircalMask" ) )
				{
					DrawMaskCircal();
				}
			}
		}
		override public function SetStyleData( name:String , bSet:Boolean ):void
		{
			if ( name == "CanDrag" ||
				 name == "CircalMask" )
			{
				if ( isStyleData( name ) == bSet ) return;
				super.SetStyleData( name , bSet );
				if ( name == "CanDrag" )
				{
					SetHandleMouse( bSet );
				}
				else if ( name == "CircalMask" )
				{
					if( bSet )
						DrawMaskCircal();
				}
			}
		}
		override public function _LoadFromImageSet( name:String ):void
		{
			super._LoadFromImageSet( name );
			
			if ( isStyleData( "CircalMask" ) )
			{
				DrawMaskCircal();
			}
		}
		override public function OnLoadImageComplate( strImageFileName:String , arr:Array ):void
		{
			if ( !m_bRelease && strImageFileName == m_strImageSetName )
			{
				m_bLoading = false;
				super.OnLoadImageComplate( strImageFileName , arr );
				
				if ( m_img )
				{
					if( GetWidth() == 0 && GetHeight() == 0 )
						SetSize( m_img.GetWidth() , m_img.GetHeight() );

					FireEvent( dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED ,
						m_img.GetWidth() , m_img.GetHeight() , strImageFileName );
				}
			}
		}
	}

}