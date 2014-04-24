//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dcom 
{
    public class dMath extends Object
    {
        public function dMath()
        {
            super();
            return;
        }

        public static function Random():Number
        {
            return dInterface.ptr.MathRandom();
        }

        public static function RandomI():int
        {
            return dMath.Random() * 65535;
        }

        public static function Sin(arg1:Number):Number
        {
            return dInterface.ptr.MathSin(arg1);
        }

        public static function Cos(arg1:Number):Number
        {
            return dInterface.ptr.MathCos(arg1);
        }

        public static function Tan(arg1:Number):Number
        {
            return dInterface.ptr.MathTan(arg1);
        }

        public static function Asin(arg1:Number):Number
        {
            return dInterface.ptr.MathAsin(arg1);
        }

        public static function Acos(arg1:Number):Number
        {
            return dInterface.ptr.MathAcos(arg1);
        }

        public static function Atan(arg1:Number):Number
        {
            return dInterface.ptr.MathAtan(arg1);
        }

        public static function Atan2(arg1:Number, arg2:Number):Number
        {
            if (arg2 == 0) 
            {
                if (arg1 == 0) 
                {
                    return 0;
                }
            }
            var loc2:*=arg1 >= 0 ? arg1 : -arg1;
            var loc1:*=arg2 >= 0 ? arg2 : -arg2;
            if (loc2 - loc1 == loc2) 
            {
                return arg1 >= 0 ? 1.57079637051 : -1.57079637051;
            }
            if (loc1 - loc2 != loc1) 
            {
                loc3 = dMath.Atan(arg1 / arg2);
            }
            else 
            {
                var loc3:*=0;
            }
            if (!(arg2 <= 0)) 
            {
                return loc3;
            }
            if (!(arg1 >= 0)) 
            {
                return loc3 - 3.14159274101;
            }
            return loc3 + 3.14159274101;
        }

        public static function Sqrt(arg1:Number):Number
        {
            return dInterface.ptr.MathSqrt(arg1);
        }

        public static function Pow(arg1:Number, arg2:Number):Number
        {
            return dInterface.ptr.MathPow(arg1, arg2);
        }

        public static function Abs___int_int(arg1:int):int
        {
            if (!(arg1 >= 0)) 
            {
                return -arg1;
            }
            return arg1;
        }

        public static function Abs___float_float(arg1:Number):Number
        {
            if (!(arg1 >= 0)) 
            {
                return -arg1;
            }
            return arg1;
        }

        public static function Floor___float_float(arg1:Number):Number
        {
            if (arg1 == arg1) 
            {
                return arg1;
            }
            return arg1 <= 0 ? arg1 - 1 : arg1;
        }

        public static function Floor___double_double(arg1:Number):Number
        {
            if (arg1 == arg1) 
            {
                return arg1;
            }
            return arg1 <= 0 ? arg1 - 1 : arg1;
        }

        public static function Ceil___float_float(arg1:Number):Number
        {
            if (arg1 == arg1) 
            {
                return arg1;
            }
            return dMath.Floor___float_float(arg1) + 1;
        }

        public static function Ceil___double_double(arg1:Number):Number
        {
            if (arg1 == arg1) 
            {
                return arg1;
            }
            return dMath.Floor___double_double(arg1) + 1;
        }

        public static function Round___float_float(arg1:Number):Number
        {
            return arg1 <= 0 ? dMath.Ceil___float_float(arg1 - 0.5) : dMath.Floor___float_float(arg1 + 0.5);
        }

        public static function Round___double_double(arg1:Number):Number
        {
            return arg1 <= 0 ? dMath.Ceil___double_double(arg1 - 0.5) : dMath.Floor___double_double(arg1 + 0.5);
        }

        public static function Max___int_int_int(arg1:int, arg2:int):int
        {
            return arg1 <= arg2 ? arg2 : arg1;
        }

        public static function Min___int_int_int(arg1:int, arg2:int):int
        {
            return arg1 >= arg2 ? arg2 : arg1;
        }

        public static function Max___float_float_float(arg1:Number, arg2:Number):Number
        {
            return arg1 <= arg2 ? arg2 : arg1;
        }

        public static function Min___float_float_float(arg1:Number, arg2:Number):Number
        {
            return arg1 >= arg2 ? arg2 : arg1;
        }

        
        {
            dMath.PI = 3.14159274101;
        }

        public static var PI:Number;
    }
}


