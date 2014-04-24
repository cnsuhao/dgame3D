//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dcom
{
	public class dCompleteCallback
	{
		protected var m_nCompleteRef:int;
		protected var m_nCompleteRefTotal:int;
		protected var m_onComplete:Object;
		protected var m_onProgress:Object;
		protected var m_pTarget:Object;
		
		public function SetProgress(onProgress:Object):void
		{
			m_onProgress = onProgress;
		}
		public function SetCompleteFun(onComplete:Object):void
		{
			m_onComplete = onComplete;
			if( m_nCompleteRef == m_nCompleteRefTotal && m_onComplete != null ) m_onComplete.OnLoadComplete( this );
		}
		/*public function CreateCompleteFun_Normal():Function
		{
			m_nCompleteRefTotal ++;
			return this;
		}*/
		public function Add():void
		{
			m_nCompleteRefTotal ++;
		}
		public function DoComplete():void
		{
			m_nCompleteRef ++;
			if( m_onProgress != null ) m_onProgress( this , m_nCompleteRef * 100 / m_nCompleteRefTotal );
			if( m_nCompleteRef == m_nCompleteRefTotal && m_onComplete != null ) m_onComplete( m_pTarget );
		}
		public function OnLoadComplete(pTarget:Object):void
		{
			DoComplete();
		}
	}
}
