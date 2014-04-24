//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dcom
{

    public class dTextFormat extends Object
    {
        public var nBeginIndex:int;
        public var nEndIndex:int;
        public var strFontFace:String;
        public var strLinkData:String;
        public var dwFontColor:uint;
        public var dwFontGradientColor:uint;
        public var nFontSize:int;
        public var dwEdgeColor:uint;
        public var nEdgeSize:int;
        public var bBold:Boolean;
        public var bItaric:Boolean;
        public var bUnderLine:Boolean;
        public var nImageWidth:int;
        public var nImageHeight:int;
		public var nShadowLength:int;

        public function dTextFormat() : void
        {
            return;
        }// end function

        public function Copy(param1:dTextFormat) : void
        {
            this.nBeginIndex = param1.nBeginIndex;
            this.nEndIndex = param1.nEndIndex;
            this.strFontFace = param1.strFontFace;
            this.strLinkData = param1.strLinkData;
            this.dwFontColor = param1.dwFontColor;
            this.nFontSize = param1.nFontSize;
            this.dwEdgeColor = param1.dwEdgeColor;
            this.nEdgeSize = param1.nEdgeSize;
            this.bBold = param1.bBold;
            this.bItaric = param1.bItaric;
            this.bUnderLine = param1.bUnderLine;
            this.nImageWidth = param1.nImageHeight;
            this.nImageHeight = param1.nImageHeight;
			nShadowLength = param1.nShadowLength;
            return;
        }// end function

    }
}
