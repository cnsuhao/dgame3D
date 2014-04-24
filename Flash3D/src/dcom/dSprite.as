//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dcom
{
    public class dSprite extends Object
    {
        public var m_pBaseObject:Object;
        public var m_nPosX:int;
        public var m_nPosY:int;
        public var m_nWidth:int;
        public var m_nHeight:int;
        public var m_bShow:Boolean;
        private var m_pFather:dSprite;
        public static var MOUSE_LBUTTONDOWN:int = 1;
        public static var MOUSE_LBUTTONUP:int = 2;
        public static var MOUSE_MBUTTONDOWN:int = 3;
        public static var MOUSE_MBUTTONUP:int = 4;
        public static var MOUSE_RBUTTONDOWN:int = 5;
        public static var MOUSE_RBUTTONUP:int = 6;
        public static var MOUSE_IN:int = 7;
        public static var MOUSE_OUT:int = 8;
        public static var MOUSE_WHEEL:int = 9;
        public static var KEY_DOWN:int = 10;
        public static var KEY_UP:int = 11;
        public static var FRAME_MOUSE_WHEEL:int = 12;
        public static var FRAME_RESIZE_WINDOW:int = 13;
        public static var TEXT_INPUT:int = 14;
        public static var TEXT_CHANGED:int = 15;
        public static var TEXT_FOCUS_IN:int = 16;
        public static var TEXT_FOCUS_LOST:int = 17;
        public static var MOUSE_STYLE_ARROW:int = 0;
        public static var MOUSE_STYLE_HAND:int = 1;
        public static var MOUSE_STYLE_EDIT:int = 2;
        public static var VK_CONTROL:int = 1;
        public static var VK_SHIFT:int = 2;
        public static var VK_ALT:int = 3;

        public function dSprite() : void
        {
            this.m_bShow = true;
            this.m_pBaseObject = dInterface.ptr.CreateSprite();
            return;
        }// end function

        public function _GetBaseObject() : Object
        {
            return this.m_pBaseObject;
        }// end function

        public function dSpriteSetFather(param1:dSprite, param2:int = -1) : void
        {
            this.m_pFather = param1;
            if (!param1)
            {
                dInterface.ptr.SpriteSetFather(this.m_pBaseObject, null, param2);
                return;
            }
            dInterface.ptr.SpriteSetFather(this.m_pBaseObject, param1.m_pBaseObject, param2);
            return;
        }// end function

        public function dSpriteRemoveFather() : void
        {
            dInterface.ptr.SpriteRemoveFather(this.m_pBaseObject);
            return;
        }// end function

        public function dSpriteGetFather() : dSprite
        {
            return this.m_pFather;
        }// end function

        public function SetPos(x:int, y:int) : void
        {
            this.m_nPosX = x;
            this.m_nPosY = y;
            dInterface.ptr.SpriteSetPos(this.m_pBaseObject, x, y);
            return;
        }// end function

        public function GetPosX() : int
        {
            return this.m_nPosX;
        }// end function

        public function GetPosY() : int
        {
            return this.m_nPosY;
        }// end function

        public function GetPosX_World() : int
        {
            var ret:int = 0;
            var p:dSprite = this;
            while (p)
            {
                ret = ret + p.GetPosX();
                p = p.dSpriteGetFather();
            }
            return ret;
        }// end function

        public function GetPosY_World() : int
        {
            var ret:int = 0;
            var p:dSprite = this;
            while (p)
            {
                ret = ret + p.GetPosY();
                p = p.dSpriteGetFather();
            }
            return ret;
        }// end function

        public function SetSize(param1:int, param2:int) : void
        {
            this.m_nWidth = param1;
            this.m_nHeight = param2;
            dInterface.ptr.SpriteSetSize(this.m_pBaseObject, param1, param2);
            return;
        }// end function

        public function GetWidth() : int
        {
            return this.m_nWidth;
        }// end function

        public function GetHeight() : int
        {
            return this.m_nHeight;
        }// end function

        public function SetShow(param1:Boolean) : void
        {
            this.m_bShow = param1;
            dInterface.ptr.SpriteSetShow(this.m_pBaseObject, param1);
            return;
        }// end function

        public function isShow() : Boolean
        {
            return this.m_bShow;
        }// end function

        public function dSpriteSetBitmapData(param1:dBitmapData) : void
        {
            if (!param1)
            {
                dInterface.ptr.SpriteSetBitmapData(this.m_pBaseObject, null);
                return;
            }
            dInterface.ptr.SpriteSetBitmapData(this.m_pBaseObject, param1.m_pBaseObject);
            return;
        }// end function

        public function dSpriteSetMouseEventFun(param1:Function) : void
        {
            dInterface.ptr.SpriteSetMouseEventFun(this.m_pBaseObject, param1);
            return;
        }// end function

        public function dSpriteSetMouseMoveFun(param1:Function) : void
        {
            dInterface.ptr.SpriteSetMouseMoveFun(this.m_pBaseObject, param1);
            return;
        }// end function

        public function dSpriteSetKeyEventFun(param1:Function) : void
        {
            dInterface.ptr.SpriteSetKeyEventFun(this.m_pBaseObject, param1);
            return;
        }// end function

        public function dSpriteSetFrameEventFun(param1:Function) : void
        {
            dInterface.ptr.SpriteSetFrameEventFun(this.m_pBaseObject, param1);
            return;
        }// end function

        public function dSpriteSetCapture(param1:Boolean) : Boolean
        {
            return dInterface.ptr.SpriteSetCapture(this.m_pBaseObject, param1);
        }// end function

        public function dSpriteGetMouseX() : int
        {
            return dInterface.ptr.SpriteGetMouseX(this.m_pBaseObject);
        }// end function

        public function dSpriteGetMouseY() : int
        {
            return dInterface.ptr.SpriteGetMouseY(this.m_pBaseObject);
        }// end function

        public function dSpriteSetMouseStyle(param1:int) : void
        {
            dInterface.ptr.SpriteSetMouseStyle(this.m_pBaseObject, param1);
            return;
        }// end function

        public function dSpriteSetAlpha(param1:int) : void
        {
            dInterface.ptr.SpriteSetAlpha(this.m_pBaseObject, param1);
            return;
        }// end function

        public function dSpriteSetColorTransform(param1:int, param2:int, param3:int, param4:int) : void
        {
            dInterface.ptr.SpriteSetColorTransform(this.m_pBaseObject, param1, param2, param3, param4);
            return;
        }// end function

        public function dSpriteIsKeyDown(param1:int) : Boolean
        {
            return dInterface.ptr.SpriteIsKeyDown(this.m_pBaseObject, param1);
        }// end function

        public function dSpriteDrawMaskCircal() : void
        {
            dInterface.ptr.SpriteDrawMaskCircal(this.m_pBaseObject);
            return;
        }// end function

        public function dSpriteCreateBitmapData(param1:int, param2:int) : void
        {
            dInterface.ptr.SpriteCreateBitmapData(this.m_pBaseObject, param1, param2);
            return;
        }// end function

        public function dSpriteDrawBitmapData(param1:dBitmapData, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int) : void
        {
            if (param1)
            {
                if (param1.m_pBaseObject)
                {
                    dInterface.ptr.SpriteDrawBitmapData(this.m_pBaseObject, param1.m_pBaseObject, param2, param3, param4, param5, param6, param7, param8, param9);
                }
            }
            return;
        }
		public function dSpriteDrawToBitmapData( dest:dBitmapData , dest_left:int , dest_top:int , dest_right:int , dest_bottom:int , src_left:int , src_top:int , src_right:int , src_bottom:int , pClip:dRect = null ):void
		{
			dInterface.ptr.SpriteDrawToBitmapData( m_pBaseObject , dest.m_pBaseObject , dest_left , dest_top , dest_right , dest_bottom , src_left , src_top , src_right , src_bottom , pClip );
		}

        public function dSpriteCreateInputBox(nAlign:int , text:String , dest_width:int , bGetCharBounds:Boolean , onCompleteFun:Function , vecFormat:Vector.<dTextFormat> , nFormatArgCount:int , nFlag:int) : void
        {
			var pThis:* = this;
           dInterface.ptr.SpriteCreateInputBox( m_pBaseObject , nAlign , text , dest_width , bGetCharBounds , function( pObj:Object , vecBoundRect:Array , nBoundArgNum:int ):void
			{
				onCompleteFun( pThis , vecBoundRect , nBoundArgNum );
			} , vecFormat , nFormatArgCount , nFlag );
        }// end function

        public function dSpriteReleaseInputBox() : void
        {
            dInterface.ptr.SpriteReleaseInputBox(this.m_pBaseObject);
            return;
        }// end function

        public function dSpriteSetInputBoxSelection(param1:int, param2:int) : void
        {
            dInterface.ptr.SpriteSetInputBoxSelection(this.m_pBaseObject, param1, param2);
            return;
        }// end function

        public function dSpriteGetInputBoxSelectionBegin() : int
        {
            return dInterface.ptr.SpriteGetInputBoxSelectionBegin(this.m_pBaseObject);
        }// end function

        public function dSpriteGetInputBoxSelectionEnd() : int
        {
            return dInterface.ptr.SpriteGetInputBoxSelectionEnd(this.m_pBaseObject);
        }// end function

        public function dSpriteSetInputBoxFocus(param1:Boolean) : void
        {
            dInterface.ptr.SpriteSetInputBoxFocus(this.m_pBaseObject, param1);
            return;
        }// end function
		
		public function dSpriteGetBitmapData():dBitmapData
		{
			return dInterface.ptr.SpriteGetBitmapData( m_pBaseObject );
		}
    }
}
