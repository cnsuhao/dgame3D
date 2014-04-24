//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dcom
{

    public class dRect extends Object
    {
        public var left:int;
        public var top:int;
        public var right:int;
        public var bottom:int;

        public function dRect( param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0 ):void
		{
			Set( param1 , param2 , param3 , param4 );
		}
		public function Set( param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0) : dRect
        {
            this.left = param1;
            this.top = param2;
            this.right = param3;
            this.bottom = param4;
            return this;
        }// end function

        public function Width() : int
        {
            return this.right - this.left;
        }// end function

        public function Height() : int
        {
            return this.bottom - this.top;
        }// end function

    }
}
