//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	import dcom.dTimer;
	/**
	 * ...
	 * @author dym
	 */
	public class dUIAniImageBox extends dUIImageBox
	{
		protected var m_vecImageList:Vector.<dUIAniImageBoxObj> = new Vector.<dUIAniImageBoxObj>;
		protected var m_nCurFrame:int;
		protected var m_nPlaySpeed:int;
		protected var m_nMaxWidth:int;
		protected var m_nMaxHeight:int;
		protected var m_nNeedDownNum:int;
		protected var m_bPlay:Boolean;
		protected var m_pTimer:dTimer;
		public function dUIAniImageBox( pFather:dUIImage ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_ANIIMAGEBOX;
			m_nPlaySpeed = GetImageRoot().GetConfig().nDefaultAniPlaySpeed;
		}
		override public function Release():void
		{
			Stop();
			for ( var i:int = 0 ; i < m_vecImageList.length ; i ++ )
				m_vecImageList[i].Release();
			super.Release();
		}
		private function OnImageEvent( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED )
			{
				if ( m_nMaxWidth < event.nParam1 ) m_nMaxWidth = event.nParam1;
				if ( m_nMaxHeight < event.nParam2 ) m_nMaxHeight = event.nParam2;
				m_nNeedDownNum--;
				var pObj:dUIAniImageBoxObj = event.pObj as dUIAniImageBoxObj;
				if ( m_nNeedDownNum == 0 )
				{
					if ( GetWidth() == 0 && GetHeight() == 0 )
						SetSize( m_nMaxWidth , m_nMaxHeight );
					FireEvent( dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED , m_nMaxWidth , m_nMaxHeight );
				}
			}
		}
		override public function OnLoadImageComplate( strImageFileName:String , arr:Array ):void
		{
			super.OnLoadImageComplate( strImageFileName , arr );
			if ( GetWidth() == 0 && GetHeight() == 0 )
			{
				m_nMaxWidth = 0;
				m_nMaxHeight = 0;
				for ( var i:int = 0 ; i < m_vecImageList.length ; i ++ )
				{
					if ( m_nMaxWidth < m_vecImageList[i].GetWidth() ) m_nMaxWidth = m_vecImageList[i].GetWidth();
					if ( m_nMaxHeight < m_vecImageList[i].GetHeight() ) m_nMaxHeight = m_vecImageList[i].GetHeight();
				}
				SetSize( m_nMaxWidth , m_nMaxHeight );
			}
		}
		override public function _LoadFromImageSet( strName:String ):void
		{
			m_nMaxWidth = 0;
			m_nMaxHeight = 0;
			var vecFileNameList:Vector.<String> = SplitString( strName , -1 , "," );
			var nPerWidth:int = 0;
			var nPerHeight:int = 0;
			if ( vecFileNameList.length > 1 && vecFileNameList[1].indexOf( "." ) == -1 && int( vecFileNameList[1] ) > 0 )
				nPerWidth = int( vecFileNameList[1] );
			if ( vecFileNameList.length > 2 && vecFileNameList[2].indexOf( "." ) == -1 && int( vecFileNameList[2] ) > 0 )
				nPerHeight = int( vecFileNameList[2] );
			if ( nPerWidth > 0 )
			{
				if ( nPerHeight < 1 ) nPerHeight = 1;
				var nFrame:int = nPerWidth * nPerHeight;
				for ( var i:int = m_vecImageList.length ; i < nFrame ; i ++ )
				{
					var p:dUIAniImageBoxObj = new dUIAniImageBoxObj( this );
					p.SetColorTransform( GetColorTransform() );
					p.SetGray( isGray() );
					p.SetUIEventFunction( OnImageEvent );
					m_vecImageList.push( p );
				}
				for ( i = nFrame ; i < m_vecImageList.length ; i ++ )
					m_vecImageList[i].Release();
				m_vecImageList.length = nFrame;
				m_nNeedDownNum = nFrame;
				for ( i = 0 ; i < nFrame ; i ++ )
				{
					m_vecImageList[i].SetSize( GetWidth() , GetHeight() );
					m_vecImageList[i].LoadFromImageSet( vecFileNameList[0] + "^-1^" + nPerWidth + "^" + nPerHeight + "^" + String( i ) );
				}
			}
			else
			{
				for ( i = m_vecImageList.length ; i < vecFileNameList.length ; i ++ )
				{
					p = new dUIAniImageBoxObj( this );
					p.SetColorTransform( GetColorTransform() );
					p.SetGray( isGray() );
					p.SetUIEventFunction( OnImageEvent );
					m_vecImageList.push( p );
				}
				for ( i = vecFileNameList.length ; i < m_vecImageList.length ; i ++ )
					m_vecImageList[i].Release();
				m_vecImageList.length = vecFileNameList.length;
				m_nNeedDownNum = m_vecImageList.length;
				for ( i = 0 ; i < vecFileNameList.length ; i ++ )
				{
					m_vecImageList[i].SetSize( GetWidth() , GetHeight() );
					m_vecImageList[i].LoadFromImageSet( vecFileNameList[i] );
				}
			}
			SetCurFrame( 0 );
			Play();
		}
		public function SetMaxFrameNum( nFrameNum:int ):void
		{
			m_vecImageList.length = nFrameNum;
			for ( var i:int = 0 ; i < m_vecImageList.length ; i ++ )
			{
				if ( m_vecImageList[i] == null )
				{
					m_vecImageList[i] = new dUIAniImageBoxObj( this );
					m_vecImageList[i].SetColorTransform( GetColorTransform() );
				}
			}
		}
		public function GetMaxFrameNum():int
		{
			return m_vecImageList.length;
		}
		public function SetCurFrame( nFrame:int ):void
		{
			if ( nFrame < 0 ) nFrame = 0;
			m_nCurFrame = nFrame;
			if ( m_vecImageList.length ) m_nCurFrame %= m_vecImageList.length;
			for ( var i:int = 0 ; i < m_vecImageList.length ; i ++ )
				m_vecImageList[i].SetShow( i == m_nCurFrame );
		}
		public function GetCurFrame():int
		{
			return m_nCurFrame;
		}
		public function Play():void
		{
			Stop();
			m_pTimer = new dTimer();
			m_pTimer.Create( m_nPlaySpeed , 0 , _OnFrameMove );
			m_nCurFrame = 0;
			//m_nTimeAdd = 0;
			m_bPlay = true;
		}
		public function Stop():void
		{
			if ( m_pTimer )
			{
				m_pTimer.Stop();
				m_pTimer = null;
			}
			m_bPlay = false;
		}
		public function isPlaying():Boolean
		{
			return m_bPlay;
		}
		public function SetPlaySpeed( speed:int ):void
		{
			if ( m_nPlaySpeed != speed )
			{
				m_nPlaySpeed = speed;
				if ( m_pTimer )
				{
					m_pTimer.Stop();
					m_pTimer = null;
				}
				m_pTimer = new dTimer();
				m_pTimer.Create( m_nPlaySpeed , 0 , _OnFrameMove );
			}
		}
		public function GetPlaySpeed():int
		{
			return m_nPlaySpeed;
		}
		/*public function LoadFromBitmapDataList( pBitmapData:BitmapData , idx:int ):void
		{
			if ( idx < 0 ) return ;
			if ( m_vecImageList.length <= idx )
			{
				m_vecImageList.length = idx + 1;
				for ( var i:int = 0 ; i < m_vecImageList.length ; i ++ )
				{
					if ( m_vecImageList[i] == null )
					{
						m_vecImageList[i] = new dUIAniImageBoxObj( this );
						m_vecImageList[i].SetColorTransform( GetColorTransform() );
					}
				}
			}
			m_vecImageList[idx].LoadFromBitmapData( pBitmapData );
			m_vecImageList[idx].SetSize( GetWidth() , GetHeight() );
		}*/
		protected function _OnFrameMove( p:dTimer , ii:int ):void
		{
			if ( !isShow() || ( GetFather() && !GetFather().isShow() ) ) return;
			if ( m_vecImageList.length && isPlaying() )
			{
				m_nCurFrame ++;
				if ( m_nCurFrame >= m_vecImageList.length )
				{
					if ( m_bRegMouseLowEvent )
					{
						FireEvent( dUISystem.GUIEVENT_TYPE_ANIPLAYEND );
						if ( !isPlaying() )
						{
							m_nCurFrame = m_vecImageList.length - 1;
							SetCurFrame( m_nCurFrame );
							return;
						}
					}
					m_nCurFrame = 0;
					m_nCurFrame %= m_vecImageList.length;
				}
				SetCurFrame( m_nCurFrame );
			}
		}
		override public function SetSize( w:int , h:int ):void
		{
			for ( var i:int = 0 ; i < m_vecImageList.length ; i ++ )
				m_vecImageList[i].SetSize( w , h );
			super.SetSize( w , h );
		}
		override public function SetColorTransform( pColorTransform:dUIColorTransform ):void
		{
			super.SetColorTransform( pColorTransform );
			for ( var i:int = 0 ; i < m_vecImageList.length ; i ++ )
				m_vecImageList[i].SetColorTransform( pColorTransform );
		}
		override public function SetGray( bGray:Boolean ):void
		{
			super.SetGray( bGray );
			for ( var i:int = 0 ; i < m_vecImageList.length ; i ++ )
				m_vecImageList[i].SetGray( bGray );
		}
	}

}