//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIImageCanDrag extends dUIImage
	{
		public function dUIImageCanDrag( pFather:dUIImage , bUsingMask:Boolean = false ) 
		{
			super( pFather , bUsingMask );
		}
		override public function OnLButtonDrag( x:int , y:int ):void
		{
			if ( isStyleData( "CanDrag" ) )
			{
				var newX:int = GetPosX() + x;
				var newY:int = GetPosY() + y;
				if ( GetFather() )
				{
					var nFatherWidth:int = GetFather().GetWidth();
					var nFatherHeight:int = GetFather().GetHeight();
					/*if ( newX > nFatherWidth - GetWidth() )
						newX = nFatherWidth - GetWidth();
					if ( newX < 0 )
						newX = 0;
					if ( newY > nFatherHeight - GetHeight() )
						newY = nFatherHeight - GetHeight();
					if ( newY < 0 )
						newY = 0;*/
					var obj:Object = { x:newX , y:newY };
					GetImageRoot().GetConfig().OnImageDragOutsideWindow( obj , GetWidth() , GetHeight() , nFatherWidth , nFatherHeight );
					newX = obj.x;
					newY = obj.y;
				}
				SetPos( newX , newY );
			}
			FireEvent( dUISystem.GUIEVENT_TYPE_IMAGEBOX_ON_DRAG , x , y );
		}
	}

}