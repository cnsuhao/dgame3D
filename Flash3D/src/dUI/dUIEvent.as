//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUIEvent 
	{
		public var id:int;
		public var type:int;
		public var nParam1:int;
		public var nParam2:int;
		public var sParam:String;
		public var pObj:dUIImage;
		public var oParam:Object;
		
		public function dUIEvent( _id:int = 0 , _type:int = 0 , _nParam1:int = 0 , _nParam2:int = 0 , _sParam:String = "" , _pObj:dUIImage = null , _oParam:Object = null )
		{
			id = _id;
			type = _type;
			nParam1 = _nParam1;
			nParam2 = _nParam2;
			sParam = _sParam;
			pObj = _pObj;
			oParam = _oParam;
		}
	}

}