//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dcom
{

    public class dDateTime extends Object
    {
        public var m_nYear:int;
        public var m_nMonth:int;
        public var m_nDay:int;
        public var m_nHour:int;
        public var m_nMinute:int;
        public var m_nSecond:int;
        public var m_nMilliseconds:int;

        public function dDateTime() : void
        {
            dInterface.ptr.CreateDate(this);
            return;
        }// end function

        public function get_year() : int
        {
            return this.m_nYear;
        }// end function

        public function set_year(param1:int) : void
        {
            this.m_nYear = param1;
            return;
        }// end function

        public function get_month() : int
        {
            return this.m_nMonth;
        }// end function

        public function set_month(param1:int) : void
        {
            this.m_nMonth = param1;
            return;
        }// end function

        public function get_day() : int
        {
            return this.m_nDay;
        }// end function

        public function set_day(param1:int) : void
        {
            this.m_nDay = param1;
            return;
        }// end function

        public function get_hour() : int
        {
            return this.m_nHour;
        }// end function

        public function set_hour(param1:int) : void
        {
            this.m_nHour = param1;
            return;
        }// end function

        public function get_minute() : int
        {
            return this.m_nMinute;
        }// end function

        public function set_minute(param1:int) : void
        {
            this.m_nMinute = param1;
            return;
        }// end function

        public function get_second() : int
        {
            return this.m_nSecond;
        }// end function

        public function set_second(param1:int) : void
        {
            this.m_nSecond = param1;
            return;
        }// end function

        public function get_milliseconds() : int
        {
            return this.m_nMilliseconds;
        }// end function

        public function set_milliseconds(param1:int) : void
        {
            this.m_nMilliseconds = param1;
            return;
        }// end function

        public function Copy(param1:dDateTime) : void
        {
            this.set_year(param1.get_year());
            this.set_month(param1.get_month());
            this.set_day(param1.get_day());
            this.set_hour(param1.get_hour());
            this.set_minute(param1.get_minute());
            this.set_second(param1.get_second());
            this.set_milliseconds(param1.get_milliseconds());
            return;
        }// end function

    }
}
