//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Math.dMatrix;
	/**
	 * ...
	 * @author dym
	 */
	public class dMeshAnimation 
	{
		protected var m_pDevice:dDevice;
		protected var m_vecKeyResultBuffer:Array = new Array();
		protected var m_vecSkeletonWorldMatrix:Array = new Array();
		protected var m_pAniFile:dMeshFileAnimation;
		public function dMeshAnimation( pDevice:dDevice ) 
		{
			m_pDevice = pDevice;
		}
		public function SetSkeletonResult( frame:int , vec:Vector.<dMatrix> ):void
		{
			m_vecKeyResultBuffer[frame] = vec;
		}
		public function GetSkeletonResult( frame:int ):Vector.<dMatrix>
		{
			return m_vecKeyResultBuffer[frame];
		}
		public function SetSkeletonWorldMatrix( frame:int , vec:Vector.<dMatrix> ):void
		{
			m_vecSkeletonWorldMatrix[frame] = vec;
		}
		public function GetSkeletonWorldMatrix( frame:int ):Vector.<dMatrix>
		{
			return m_vecSkeletonWorldMatrix[frame];
		}
		public function LoadFromFile( strFileName:String , onLoadComplate:Function ):void
		{
			m_pDevice.GetResource().LoadAnimation( strFileName , function( p:dMeshFileAnimation ):void
			{
				m_pAniFile = p;
				if ( onLoadComplate != null ) onLoadComplate();
			} );
		}
		public function GetKeyMaxTime():int
		{
			if ( !m_pAniFile ) return 1000;
			return m_pAniFile.GetKeyMaxTime();
		}
		public function GetSkeletonFrameMatrix( skeletonId:int , frame:int ):dMatrix
		{
			if ( !m_pAniFile ) return null;
			return m_pAniFile.GetSkeletonFrameMatrix( skeletonId , frame );
		}
		public function GetSkeletonFrameMatrixByName( strBoneName:String , frame:int ):dMatrix
		{
			if ( !m_pAniFile ) return null;
			return m_pAniFile.GetSkeletonFrameMatrixByName( strBoneName , frame );
		}
		public function GetSkeletonId( strBoneName:String ):int
		{
			if ( !m_pAniFile ) return 0;
			return m_pAniFile.GetSkeletonId( strBoneName );
		}
	}

}