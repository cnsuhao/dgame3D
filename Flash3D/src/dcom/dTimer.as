//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dcom
{

    public class dTimer extends Object
    {
        public var m_pBaseObject:Object;

        public function dTimer() : void
        {
            return;
        }// end function

        public function Stop() : void
        {
            if (this.m_pBaseObject)
            {
                dInterface.ptr.TimerStop(this.m_pBaseObject);
            }
            return;
        }// end function

        public function Create(delay:int, repeatCount:int, fun:Function) : void
        {
			var pThis:* = this;
			m_pBaseObject = dInterface.ptr.CreateTimer( delay , repeatCount , function( pTimer:Object , nRepeat:int ):void
			{
				fun( pThis , nRepeat );
			} );
        }// end function

        public static function GetTickCount() : int
        {
            return dInterface.ptr.GetTickCount();
        }// end function
		
		public function IntervalFor( nStart:int , nLess:int , nStep:int , onLoop:Function , onComplete:Function ):void
		{
			m_pBaseObject = dInterface.ptr.TimerIntervalFor( nStart , nLess , nStep , onLoop , onComplete );
		}

		public function IntervalForBreak():void
		{
			dInterface.ptr.TimerIntervalForBreak( m_pBaseObject );
		}
		public function IntervalForPause():void
		{
			dInterface.ptr.TimerIntervalForPause( m_pBaseObject , true );
		}
		public function IntervalForResume():void
		{
			dInterface.ptr.TimerIntervalForPause( m_pBaseObject , false );
		}
    }
}
