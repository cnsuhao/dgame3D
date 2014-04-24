//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIConfig 
	{
		static public const OUTSIDE_WINDOW_TYPE_PIXEL:int = 0;
		static public const OUTSIDE_WINDOW_TYPE_PERSENT:int = 1;
		
		public var onUIEventCallback:Function;
		public var strDefaultFontFaceName:String = "Arial";
		public var nDefaultFontSize:int = 12;
		public var nDefaultFontColor:uint = 0xFFFFFFFF;
		public var nDefaultFontEdgeColor:uint = 0xFF000000;
		public var nDefaultAniPlaySpeed:int = 100;
		public var nDefaultFontEdgeSize:int = 1;
		public var OnDeleteCallbackGlobal:Function;
		public var OnImageDragOutsideWindow:Function = dUIConfig._OnImageDragOutsideWindow;
		
		static public function _OnImageDragOutsideWindow( obj:Object , nObjWidth:int , nObjHeight:int , nWindowWidth:int , nWindowHeight:int ):void
		{
			var nSize:int = 10;
			if ( obj.x < -nObjWidth + nSize )
				obj.x = -nObjWidth + nSize;
			else if ( obj.x > nWindowWidth - nSize )
				obj.x = nWindowWidth - nSize;
			if ( obj.y < -nObjHeight + nSize )
				obj.y = -nObjHeight + nSize;
			else if ( obj.y > nWindowHeight - nSize )
				obj.y = nWindowHeight - nSize;
		}
	}

}