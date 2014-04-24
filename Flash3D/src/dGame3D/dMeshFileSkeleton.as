//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Math.dMatrix;
	/**
	 * ...
	 * @author dym
	 */
	public class dMeshFileSkeleton 
	{
		public var name:String;
		public var matInverse:dMatrix;
		public var m_nParentId:int;
		public var m_vecChildId:Vector.<int> = new Vector.<int>;
		public var m_nAniSkeletonId:int;
		
		public function dMeshFileSkeleton() 
		{
			m_nParentId = -1;
			m_nAniSkeletonId = -1;
		}
		
	}

}