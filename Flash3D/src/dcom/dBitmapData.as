//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dcom
{
    public class dBitmapData extends Object
    {
        public var m_pBaseObject:Object;

        public function dBitmapData() : void
        {
            this.m_pBaseObject = dInterface.ptr.CreateBitmapData(null, 0, 0, 0);
            return;
        }// end function

		public function Copy( pFrom:dBitmapData ):void
		{
			m_pBaseObject = pFrom.m_pBaseObject;
		}
        public function Create(param1:int, param2:int, param3:uint) : void
        {
            dInterface.ptr.CreateBitmapData(this.m_pBaseObject, param1, param2, param3);
            return;
        }// end function

        public function FillColor(param1:uint) : void
        {
            dInterface.ptr.BitmapDataFillColor(this.m_pBaseObject, param1);
            return;
        }// end function

        public function LoadFromBin(data:dByteArray , onLoadComplete:Function , onFailed:Function) : void
        {
			var pThis:* = this;
            dInterface.ptr.BitmapDataLoadFromBin( m_pBaseObject , data.m_pBaseObject , function( pObj:Object ):void
			{
				onLoadComplete( pThis );
			} , onFailed );
        }// end function

        public function LoadFromFile(url:String , onLoadComplete:Function , onProgress:Function , onFailed:Function) : void
        {
			if ( url.charAt( 1 ) != ":" )
				url = dByteArray.s_strCurrentFilePath + url;
			var pThis:* = this;
            dInterface.ptr.BitmapDataLoadFromFile( m_pBaseObject , url , function( pObj:Object ):void
			{
				onLoadComplete( pThis );
			} , onProgress , onFailed );
        }// end function

        public function LoadFromText(nAlign:int , text:String ,  dest_width:int , bGetCharBounds:Boolean , onCompleteFun:Function , vecFormat:Vector.<dTextFormat> , nFormatArgCount:int) : void
        {
			var pThis:* = this;
            dInterface.ptr.BitmapDataLoadFromText( m_pBaseObject , nAlign , text , dest_width , bGetCharBounds , function( pObj:Object , vecBoundRect:Vector.<dRect> , nBoundArgNum:int ):void
			{
				onCompleteFun( pThis , vecBoundRect , nBoundArgNum );
			} , vecFormat , nFormatArgCount );
        }// end function

        public function GetWidth() : int
        {
            if (!this.m_pBaseObject)
            {
                return 0;
            }
            return dInterface.ptr.BitmapDataGetWidth(this.m_pBaseObject);
        }// end function

        public function GetHeight() : int
        {
            if (!this.m_pBaseObject)
            {
                return 0;
            }
            return dInterface.ptr.BitmapDataGetHeight(this.m_pBaseObject);
        }// end function

        public function Draw(param1:dBitmapData, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int , pClip:dRect = null ) : void
        {
            if (param1)
            {
                if (param1.m_pBaseObject)
                {
                    dInterface.ptr.BitmapDataDraw(this.m_pBaseObject, param1.m_pBaseObject, param2, param3, param4, param5, param6, param7, param8, param9 , pClip);
                }
            }
            return;
        }// end function

        public function DrawRotation(param1:dBitmapData, param2:Number , bMirrorX:Boolean , bMirrorY:Boolean ) : void
        {
            dInterface.ptr.BitmapDataDrawRotation(this.m_pBaseObject, param1.m_pBaseObject, param2 , bMirrorX , bMirrorY );
            return;
        }// end function

        public function DrawChannel(param1:dBitmapData, param2:int, param3:int) : void
        {
            dInterface.ptr.BitmapDataDrawChannel(this.m_pBaseObject, param1.m_pBaseObject, param2, param3);
            return;
        }// end function

        public function GetPixels(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0) : dVector
        {
            return dInterface.ptr.BitmapDataGetPixels(this.m_pBaseObject, param1, param2, param3, param4);
        }// end function

        public function SetPixels(param1:dVector, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0) : void
        {
            dInterface.ptr.BitmapDataSetPixels(this.m_pBaseObject, param1, param2, param3, param4, param5);
            return;
        }// end function

        public function GetColorBound() : dRect
        {
            if (!this.m_pBaseObject)
                return new dRect();
            return dInterface.ptr.BitmapDataGetColorBound(this.m_pBaseObject);
        }// end function

        public function ApplyColorTransform(param1:int, param2:int, param3:int, param4:int) : void
        {
            dInterface.ptr.BitmapDataApplyColorTransform(this.m_pBaseObject, param1, param2, param3, param4);
            return;
        }// end function

		
    }
}
