//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dcom
{

    public class dInterface extends Object
    {
        public static var ptr:dInterface;

        public function dInterface() : void
        {
            return;
        }

        public function ThrowError(param1:String) : void
        {
            return;
        }

        public function CreateSprite() : Object
        {
            return null;
        }

        public function SpriteSetFather(param1:Object, param2:Object, param3:int) : void
        {
            return;
        }

        public function SpriteRemoveFather(param1:Object) : void
        {
            return;
        }

        public function SpriteSetPos(param1:Object, param2:int, param3:int) : void
        {
            return;
        }

        public function SpriteSetSize(param1:Object, param2:int, param3:int) : void
        {
            return;
        }

        public function SpriteSetBitmapData(param1:Object, param2:Object) : void
        {
            return;
        }

        public function SpriteSetMouseEventFun(param1:Object, param2:Function) : void
        {
            return;
        }

        public function SpriteSetMouseMoveFun(param1:Object, param2:Function) : void
        {
            return;
        }

        public function SpriteSetKeyEventFun(param1:Object, param2:Function) : void
        {
            return;
        }

        public function SpriteSetFrameEventFun(param1:Object, param2:Function) : void
        {
            return;
        }

        public function SpriteSetCapture(param1:Object, param2:Boolean) : Boolean
        {
            return false;
        }

        public function SpriteSetShow(param1:Object, param2:Boolean) : void
        {
            return;
        }

        public function SpriteGetMouseX(param1:Object) : int
        {
            return 0;
        }

        public function SpriteGetMouseY(param1:Object) : int
        {
            return 0;
        }

        public function SpriteSetMouseStyle(param1:Object, param2:int) : void
        {
            return;
        }

        public function SpriteSetAlpha(param1:Object, param2:int) : void
        {
            return;
        }

        public function SpriteSetColorTransform(param1:Object, param2:int, param3:int, param4:int, param5:int) : void
        {
            return;
        }

        public function SpriteIsKeyDown(param1:Object, param2:int) : Boolean
        {
            return false;
        }

        public function SpriteDrawMaskCircal(param1:Object) : void
        {
            return;
        }

        public function SpriteCreateBitmapData(param1:Object, param2:int, param3:int) : void
        {
            return;
        }

        public function SpriteDrawBitmapData( p:Object , src:Object , dest_left:int , dest_top:int , dest_right:int , dest_bottom:int , src_left:int , src_top:int , src_right:int , src_bottom:int , pClip:dRect = null ) : void
        {
            return;
        }
		
		public function SpriteDrawToBitmapData( p:Object , dest:Object , dest_left:int , dest_top:int , dest_right:int , dest_bottom:int , src_left:int , src_top:int , src_right:int , src_bottom:int , pClip:dRect = null ):void
		{
			
		}

		public function SpriteGetBitmapData( p:Object ):dBitmapData
		{
			return null;
		}
        public function SpriteCreateInputBox( p:Object , nAlign:int , text:String , dest_width:int , bGetCharBound:Boolean , onComplete:Function , vecFormat:Vector.<dTextFormat> , nFormatArgNum:int , nFlag:int ) : void
        {
            return;
        }

        public function SpriteReleaseInputBox(param1:Object) : void
        {
            return;
        }

        public function SpriteSetInputBoxSelection(param1:Object, param2:int, param3:int) : void
        {
            return;
        }

        public function SpriteGetInputBoxSelectionBegin(param1:Object) : int
        {
            return 0;
        }

        public function SpriteGetInputBoxSelectionEnd(param1:Object) : int
        {
            return 0;
        }

        public function SpriteSetInputBoxFocus(param1:Object, param2:Boolean) : void
        {
            return;
        }

        public function CreateBitmapData(param1:Object, param2:int, param3:int, param4:uint) : Object
        {
            return null;
        }

        public function BitmapDataFillColor(param1:Object, param2:uint) : void
        {
            return;
        }

        public function BitmapDataLoadFromFile(param1:Object, param2:String, param3:Function, param4:Function, param5:Function) : void
        {
            return;
        }

        public function BitmapDataLoadFromBin(param1:Object, param2:Object, param3:Function, param4:Function) : void
        {
            return;
        }

        public function BitmapDataLoadFromText( p:Object , nAlign:int , text:String , dest_width:int , bGetCharBound:Boolean , onComplete:Function , vecFormat:Vector.<dTextFormat> , nFormatArgNum:int ) : void
        {
            return;
        }

        public function BitmapDataDraw( dest2:Object , src2:Object , dest_left:int , dest_top:int , dest_right:int , dest_bottom:int , src_left:int , src_top:int , src_right:int , src_bottom:int , pClip:dRect ) : void
        {
            return;
        }

        public function BitmapDataDrawRotation(dest:Object , src:Object , fAngle:Number , bMirrorX:Boolean , bMirrorY:Boolean) : void
        {
            return;
        }

        public function BitmapDataDrawChannel(param1:Object, param2:Object, param3:int, param4:int) : void
        {
            return;
        }

        public function BitmapDataGetWidth(param1:Object) : int
        {
            return 0;
        }

        public function BitmapDataGetHeight(param1:Object) : int
        {
            return 0;
        }

        public function BitmapDataGetColorBound(param1:Object) : dRect
        {
            return null;
        }

        public function BitmapDataGetPixels(param1:Object, param2:int, param3:int, param4:int, param5:int) : dVector
        {
            return null;
        }

        public function BitmapDataSetPixels(param1:Object, param2:dVector, param3:int, param4:int, param5:int, param6:int) : void
        {
            return;
        }

        public function BitmapDataApplyColorTransform(param1:Object, param2:int, param3:int, param4:int, param5:int) : void
        {
            return;
        }

        public function CreateMap() : Object
        {
            return null;
        }

        public function SetMap(param1:Object, param2:Object, param3:Object) : void
        {
            return;
        }

        public function GetMap(param1:Object, param2:Object, param3:Object) : Object
        {
            return null;
        }

        public function MapBegin(param1:Object) : Object
        {
            return null;
        }

        public function MapNext(param1:Object, param2:Object) : Object
        {
            return param2;
        }

        public function MapRemoveIterator(param1:Object, param2:Object) : Object
        {
            return this.MapNext(param1, param2);
        }

        public function MapRemoveKey(param1:Object, param2:Object) : void
        {
            return;
        }

        public function MapFirst(param1:Object, param2:Object) : Object
        {
            return null;
        }

        public function MapSecond(param1:Object, param2:Object) : Object
        {
            return null;
        }

        public function MapSize(param1:Object) : int
        {
            return 0;
        }

        public function MapClear(param1:Object) : void
        {
            return;
        }

        public function CreateByteArray() : Object
        {
            return null;
        }

        public function ByteArrayReadChar(param1:Object) : int
        {
            return 0;
        }

        public function ByteArrayReadByte(param1:Object) : int
        {
            return 0;
        }

        public function ByteArrayReadShort(param1:Object) : int
        {
            return 0;
        }

        public function ByteArrayReadUnsignedShort(param1:Object) : int
        {
            return 0;
        }

        public function ByteArrayReadInt(param1:Object) : int
        {
            return 0;
        }

        public function ByteArrayReadFloat(param1:Object) : Number
        {
            return 0;
        }

        public function ByteArrayReadDouble(param1:Object) : Number
        {
            return 0;
        }

        public function ByteArrayReadString(param1:Object, param2:int, param3:int) : String
        {
            return null;
        }

        public function ByteArrayToString(param1:Object) : String
        {
            return null;
        }

        public function ByteArrayReadBin(param1:Object, param2:int) : Object
        {
            return null;
        }

        public function ByteArrayWriteByte(param1:Object, param2:int) : void
        {
            return;
        }

        public function ByteArrayWriteShort(param1:Object, param2:int) : void
        {
            return;
        }

        public function ByteArrayWriteInt(param1:Object, param2:int) : void
        {
            return;
        }

        public function ByteArrayWriteFloat(param1:Object, param2:Number) : void
        {
            return;
        }

        public function ByteArrayWriteDouble(param1:Object, param2:Number) : void
        {
            return;
        }

        public function ByteArrayWriteString(param1:Object, param2:String, param3:int, param4:int) : void
        {
            return;
        }

        public function ByteArrayWriteBin(param1:Object, param2:Object, param3:int) : void
        {
            return;
        }

        public function ByteArrayGetPos(param1:Object) : int
        {
            return 0;
        }

        public function ByteArraySetPos(param1:Object, param2:int) : void
        {
            return;
        }

        public function ByteArraySize(param1:Object) : int
        {
            return 0;
        }

        public function ByteArrayAvailableSize(param1:Object) : int
        {
            return 0;
        }

        public function ByteArrayGetEndian(param1:Object) : int
        {
            return 0;
        }

        public function ByteArraySetEndian(param1:Object, param2:int) : void
        {
            return;
        }

        public function ByteArrayLoadFromFile(param1:Object, param2:String, param3:Function, param4:Function, param5:Function) : void
        {
            return;
        }

        public function ByteArrayCompress(param1:Object) : void
        {
            return;
        }

        public function ByteArrayUncompress(param1:Object) : void
        {
            return;
        }

        public function CreateTimer(param1:int, param2:int, param3:Function) : Object
        {
            return null;
        }

        public function TimerStop(param1:Object) : void
        {
            return;
        }
		public function TimerIntervalFor( nStart:int , nLess:int , nStep:int , onLoop:Function , onComplete:Function ):Object { return null; }
		public function TimerIntervalForBreak( p:Object ):void { }
		public function TimerIntervalForPause( p:Object , bPause:Boolean ):void{}
		public function TimerThreadWork( strClassName:Object , strFunctionName:String , pData:dByteArray , onReturn:Function ):void{}
		public function TimerThreadReturn( p:Object , pRetData:dByteArray ):void{}

        public function GetTickCount() : int
        {
            return 0;
        }

        public function CreateDate(param1:dDateTime) : void
        {
            return;
        }

        public function CreateSocket() : Object
        {
            return null;
        }

        public function SocketConnect(param1:Object, param2:String, param3:int) : void
        {
            return;
        }

        public function SocketListen(param1:Object, param2:int, param3:int) : int
        {
            return 0;
        }

        public function SocketSetEventFunction(param1:Object, param2:Function, param3:Function) : void
        {
            return;
        }

        public function SocketSend(param1:Object, param2:int, param3:Object) : void
        {
            return;
        }

        public function StringFind(param1:String, param2:String, param3:int) : int
        {
            return -1;
        }

        public function StringCharCodeAt(param1:String, param2:int, param3:int) : int
        {
            return 0;
        }

        public function StringFromCharCode(param1:int, param2:int) : String
        {
            return "";
        }

        public function StringCharAt(param1:String, param2:int) : String
        {
            return "";
        }

        public function StringLength(param1:String) : int
        {
            var _loc_2:int = 0;
            while (this.StringCharCodeAt(param1, _loc_2, 0))
            {
                
                _loc_2 = _loc_2 + 1;
            }
            return _loc_2;
        }

        public function StringToInt(param1:String) : int
        {
            return 0;
        }

        public function StringToFloat(param1:String) : Number
        {
            return 0;
        }

        public function IntToString(param1:int) : String
        {
            return "";
        }

        public function FloatToString(param1:Number) : String
        {
            return "";
        }

        public function OutputString(param1:String, param2:int) : void
        {
            return;
        }

        public function MathRandom() : Number
        {
            return 0;
        }

        public function MathSin(param1:Number) : Number
        {
            return 0;
        }

        public function MathCos(param1:Number) : Number
        {
            return 0;
        }

        public function MathTan(param1:Number) : Number
        {
            return 0;
        }

        public function MathAsin(param1:Number) : Number
        {
            return 0;
        }

        public function MathAcos(param1:Number) : Number
        {
            return 0;
        }

        public function MathAtan(param1:Number) : Number
        {
            return 0;
        }

        public function MathSqrt(param1:Number) : Number
        {
            return 0;
        }

        public function MathPow(param1:Number, param2:Number) : Number
        {
            return 0;
        }

        public function CreateSql() : Object
        {
            return null;
        }

        public function SqlInit(param1:Object, param2:String, param3:String, param4:String, param5:String, param6:int) : Boolean
        {
            return false;
        }

        public function SqlOpenTable(param1:Object, param2:String, param3:String) : Boolean
        {
            return false;
        }

        public function SqlCreateTable(param1:Object, param2:String, param3:dVector, param4:dVector, param5:String) : Boolean
        {
            return false;
        }

        public function SqlIsTableExist(param1:Object, param2:String) : Boolean
        {
            return false;
        }

        public function SqlFindLine(param1:Object, param2:String) : Boolean
        {
            return false;
        }

        public function SqlGetFindMasterValueCount(param1:Object) : int
        {
            return 0;
        }

        public function SqlGetFindMasterValueList(param1:Object) : dVector
        {
            return null;
        }

        public function SqlReadLine(param1:Object, param2:String, param3:String, param4:String) : String
        {
            return "";
        }

        public function SqlReadLines(param1:Object, param2:dVector, param3:String, param4:String) : dVector
        {
            return null;
        }

        public function SqlWriteLine(param1:Object, param2:String, param3:String, param4:String = null) : Boolean
        {
            return false;
        }

        public function SqlWriteLines(param1:Object, param2:dVector, param3:dVector, param4:String) : Boolean
        {
            return false;
        }

        public function SqlGetLastError(param1:Object) : String
        {
            return "";
        }

        dInterface.ptr = new dInterface;
    }
}
