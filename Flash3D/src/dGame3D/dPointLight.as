//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Math.dVector3;
	/**
	 * ...
	 * @author dym
	 */
	public class dPointLight 
	{
		public var id:int;
		public var bValid:Boolean = false;
		public var vPos:dVector3 = new dVector3();
		public var vColor:dVector3 = new dVector3( 1 , 1 , 1 );
		public var fRange:Number = 10.0;
	}

}