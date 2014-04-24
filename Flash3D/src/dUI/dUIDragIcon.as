//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	import dcom.*;
	/**
	 * ...
	 * @author dym
	 */
	public class dUIDragIcon extends dUIImage
	{
		protected var m_pBkImage:dUIImage;
		protected var m_pIcon:dUIImageBox;
		protected var m_pCool1:dUIAniImageBox;
		//protected var m_pSelect:dUIImage;
		protected var m_nCoolTimeMax:int;
		protected var m_nCoolTimeCur:int;
		protected var m_nCoolTimeMax2:int;
		protected var m_nCoolTimeCur2:int;
		protected var m_pNumber:dUISuperText;
		protected var m_bMouseDowned:Boolean;
		protected var m_bIconDragging:Boolean;
		protected var m_rcImageOffset:dUIImageRect = new dUIImageRect();
		protected var m_pPic:dUIImageBox;
		protected var m_pAni:dUIAniImageBox;
		protected var m_strCoolImageName:String = "图标时间,8,8";
		public function dUIDragIcon( pFather:dUIImage ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_DRAGICON;
			m_pBkImage = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_BASEOBJ , this , true , GetObjType() );
			m_pIcon = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_IMAGEBOX , this , true , GetObjType() ) as dUIImageBox;
			m_pIcon.SetUIEventFunction( _OnIconLoaded );
			//m_pSelect = new dUIImage( this );
			m_pNumber = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_SUPPERTEXT , this , true , GetObjType() ) as dUISuperText;
			m_pBkImage.LoadFromImageSet( "图标底纹1" );
			m_pNumber.SetStyleData( "AutoSetSize" , true );
			
			//m_pSelect.LoadFromImageSet( "图标选中" );
			//m_pSelect.SetShow( false );
			SetHandleMouse( true );
			//addEventListener( Event.ENTER_FRAME , _OnFrameMove , false , 0 , true );
			//GetImageRoot()._RegEnterFrameLoop( _OnFrameMove );
			RegCanDoubleClick( true );
			var pImageSet:dUIImageSet = GetImageRoot().GetImageSet();
			m_rcImageOffset = pImageSet.GetImageRect( "图标内容偏移" );
			// 设置默认
			m_nCoolTimeMax = 2000;
			m_nCoolTimeCur = 0;
			m_nCoolTimeMax2 = 2000;
			m_nCoolTimeCur2 = 0;
			SetSize( m_pBkImage.GetWidth() , m_pBkImage.GetHeight() );
			SetStyleData( "CanDrag" , true );
			SetStyleData( "ShowBackImage" , true );
			SetAlignType( dUISystem.GUI_ALIGN_RIGHT | dUISystem.GUI_ALIGN_BOTTOM );
		}
		override public function Release():void
		{
			ClearStatus();
			super.Release();
		}
		protected function _OnIconLoaded( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED )
			{
				SetLoading( false );
				m_pIcon.SetShow( true );
			}
			FireEvent( event.type , event.nParam1 , event.nParam2 , event.sParam , event.oParam );
		}
		override public function SetHandleMouse( bSet:Boolean ):void
		{
			super.SetHandleMouse( bSet );
			RegMouseLowEvent( bSet );
		}
		override public function SetSize( w:int , h:int ):void
		{
			super.SetSize( w , h );
			m_pBkImage.SetSize( w , h );
			m_pIcon.SetPos( m_rcImageOffset.left , m_rcImageOffset.top );
			var w2:int = -m_rcImageOffset.right + m_rcImageOffset.left;
			var h2:int = -m_rcImageOffset.bottom + m_rcImageOffset.top;
			m_pIcon.SetSize( w - w2 , h - h2 );
			if ( m_pCool1 )
			{
				m_pCool1.SetPos( m_rcImageOffset.left , m_rcImageOffset.top );
				m_pCool1.SetSize( w - w2 , h - h2 );
			}
			//m_pSelect.SetPos( m_rcImageOffset.left , m_rcImageOffset.top );
			//m_pSelect.SetSize( w - w2 , h - h2 );
			m_pNumber.SetAlignPos( GetAlignType() , GetWidth() , GetHeight() , -w2 + GetEdgeLeft() , -h2 + GetEdgeTop() );
			if ( m_pAni ) m_pAni.SetSize( w , h );
			if ( m_pPic ) m_pPic.SetPos( 3 , h - 3 - m_pPic.GetHeight() );
		}
		override public function SetGray( bGray:Boolean ):void
		{
			m_pIcon.SetGray( bGray );
		}
		override public function isGray():Boolean
		{
			return m_pIcon.isGray();
		}
		override public function LoadFromBin( data:dByteArray ):void
		{
			m_pIcon.LoadFromBin( data );
			m_strImageSetName = "";
			SetSize( GetWidth() , GetHeight() );
		}
		private function SetLoading( bLoading:Boolean ):void
		{
			if ( bLoading )
			{
				m_pBkImage.LoadFromImageSet( "默认图标" );
				m_pBkImage.SetShow( true );
			}
			else
			{
				m_pBkImage.LoadFromImageSet( "图标底纹1" );
				m_pBkImage.SetShow( isStyleData( "ShowBackImage" ) );
			}
		}
		override public function LoadFromImageSet( strName:String ):void
		{
			if ( m_bRelease || strName == null ) return;
			if ( GetImageSetName() != strName )
			{
				m_strImageSetName = strName;
				if ( strName != "" )
					SetLoading( true );
				SetSize( GetWidth() , GetHeight() );
			}
			m_pIcon.LoadFromImageSet( strName );
			if ( isEmpty() && m_bIconDragging )
			{
				var pDraggingIcon:dUIDragIcon = GetImageRoot().GetGlobalDragIcon();
				pDraggingIcon.SetShow( false );
				m_bIconDragging = false;
			}
		}
		/*override public function _LoadFromImageSet( strName:String ):void
		{
			if( strName != "" )
			{
				SetLoading( true );
			}
			//if( strName == "" )
			//	FillColor( 0x20000000 );
			m_pIcon.LoadFromImageSet( strName );
			m_strImageSetName = strName;
			SetSize( GetWidth() , GetHeight() );
		}*/
		override public function LoadFromBitmapData( bmp:dBitmapData ):void
		{
			SetLoading( false );
			m_pIcon.LoadFromBitmapData( bmp );
			m_strImageSetName = "";
			SetSize( GetWidth() , GetHeight() );
		}
		public function SetIconAni( strAniName:String ):void
		{
			if ( !strAniName || strAniName == "" )
			{
				if ( m_pAni )
				{
					m_pAni.Release();
					m_pAni = null;
				}
			}
			else
			{
				if ( !m_pAni )
				{
					m_pAni = new dUIAniImageBox( this );
					OrderImage();
				}
				m_pAni.LoadFromImageSet( strAniName );
				SetSize( GetWidth() , GetHeight() );
				if ( m_pAni ) m_pAni.SetColorTransform( m_pAniColorTransform );
			}
		}
		public function GetIconAniName():String
		{
			if ( m_pAni ) return m_pAni.GetImageSetName();
			return "";
		}
		public function SetIconPic( strPicName:String ):void
		{
			if ( !strPicName || strPicName == "" )
			{
				if ( m_pPic )
				{
					m_pPic.Release();
					m_pPic = null;
				}
			}
			else
			{
				if ( !m_pPic )
				{
					m_pPic = new dUIImageBox( this );
					m_pPic.SetUIEventFunction( OnPicEvent );
					OrderImage();
				}
				m_pPic.LoadFromImageSet( strPicName );
				SetSize( GetWidth() , GetHeight() );
			}
		}
		private function OnPicEvent( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_ON_IMAGEBOX_FILE_LOADED )
				SetSize( GetWidth() , GetHeight() );
		}
		public function GetIconPicName():String
		{
			if ( m_pPic ) return m_pPic.GetImageSetName();
			return "";
		}
		protected function OrderImage():void
		{
			if ( m_pAni ) m_pAni.MoveTop();
			if ( m_pPic ) m_pPic.MoveTop();
			if ( m_pCool1 ) m_pCool1.MoveTop();
			m_pNumber.MoveTop();
		}
		public function FillColor( color:uint ):void
		{
			m_pIcon.FillColor( color );
		}
		override public function _SetText( strText:String ):void
		{
			if ( strText != "图标" )
			{
				super._SetText( strText );
				m_pNumber.SetText( strText );
				m_pNumber.SetShow( true );
				SetSize( GetWidth() , GetHeight() );
			}
		}
		override public function SetAlignType( nType:int , nIndex:int = 0 ):void
		{
			super.SetAlignType( nType , nIndex );
			m_pNumber.SetAlignType( nType );
			SetSize( GetWidth() , GetHeight() );
		}
		protected var m_bRegFramed:Boolean;
		protected function CheckRegFrame():void
		{
			if ( (m_nCoolTimeCur > 0 || m_nCoolTimeCur2 > 0) && !m_bRegFramed )
			{
				GetImageRoot()._RegEnterFrameLoop( _OnFrameMove , this );
				m_bRegFramed = true;
			}
			else if ( m_nCoolTimeCur == 0 && m_nCoolTimeCur2 == 0 && m_bRegFramed )
			{
				GetImageRoot()._UnregEnterFrameLoop( _OnFrameMove );
				m_bRegFramed = false;
				if ( m_pCool1 ) m_pCool1.SetShow( isStyleData( "AlwaysShowCoolImage" ) );
			}
		}
		public function SwapStatus( pIcon:dUIDragIcon ):void
		{
			var nCoolTimeMax:int = m_nCoolTimeMax;
			var nCoolTimeCur:int = m_nCoolTimeCur;
			var nCoolTimeMax2:int = m_nCoolTimeMax2;
			var nCoolTimeCur2:int = m_nCoolTimeCur2;
			var pTooltip:Object = GetTooltip();
			var strImageSetName:String = GetImageSetName();
			var strText:String = GetText();
			var w:int = GetWidth();
			var h:int = GetHeight();
			var pUserData:Object = GetUserData();
			var strPicName:String = GetIconPicName();
			var strAniName:String = GetIconAniName();
			var pColorTransform:dUIColorTransform = GetAniColorTransform();
			var bShowBackImage:Boolean = isStyleData( "ShowBackImage" );
			var nAlignType:int = GetAlignType();
			
			m_nCoolTimeMax = pIcon.m_nCoolTimeMax;
			m_nCoolTimeCur = pIcon.m_nCoolTimeCur;
			m_nCoolTimeMax2 = pIcon.m_nCoolTimeMax2;
			m_nCoolTimeCur2 = pIcon.m_nCoolTimeCur2;
			SetTooltip( pIcon.GetTooltip() );
			LoadFromImageSet( pIcon.GetImageSetName() );
			SetText( pIcon.GetText() );
			SetSize( pIcon.GetWidth() , pIcon.GetHeight() );
			SetUserData( pIcon.GetUserData() );
			SetIconPic( pIcon.GetIconPicName() );
			SetIconAni( pIcon.GetIconAniName() );
			SetAniColorTransform( pIcon.GetAniColorTransform() );
			SetStyleData( "ShowBackImage" , pIcon.isStyleData( "ShowBackImage" ) );
			SetAlignType( pIcon.GetAlignType() );
			
			pIcon.m_nCoolTimeMax = nCoolTimeMax;
			pIcon.m_nCoolTimeCur = nCoolTimeCur;
			pIcon.m_nCoolTimeMax2 = nCoolTimeMax2;
			pIcon.m_nCoolTimeCur2 = nCoolTimeCur2;
			pIcon.SetTooltip( pTooltip );
			pIcon.LoadFromImageSet( strImageSetName );
			pIcon.SetText( strText );
			pIcon.SetSize( w , h );
			pIcon.SetUserData( pUserData );
			pIcon.SetIconPic( strPicName );
			pIcon.SetIconAni( strAniName );
			pIcon.SetAniColorTransform( pColorTransform );
			pIcon.SetStyleData( "ShowBackImage" , bShowBackImage );
			pIcon.SetAlignType( nAlignType );
			
			CheckRegFrame();
			pIcon.CheckRegFrame();
		}
		public function CopyStatus( pIcon:dUIDragIcon ):void
		{
			m_nCoolTimeMax = pIcon.m_nCoolTimeMax;
			m_nCoolTimeCur = pIcon.m_nCoolTimeCur;
			m_nCoolTimeMax2 = pIcon.m_nCoolTimeMax2;
			m_nCoolTimeCur2 = pIcon.m_nCoolTimeCur2;
			SetTooltip( pIcon.GetTooltip() );
			if ( pIcon.GetImageSetName().length )
			{
				LoadFromImageSet( pIcon.GetImageSetName() );
			}
			else
			{
				var bmp:dUIImageBitmapData = pIcon.m_pIcon.GetImage( 0 );
				if ( bmp )
				{
					LoadFromBitmapData( bmp );
				}
			}
			SetText( pIcon.GetText() );
			SetSize( pIcon.GetWidth() , pIcon.GetHeight() );
			SetGray( pIcon.isGray() );
			SetUserData( pIcon.GetUserData() );
			SetIconPic( pIcon.GetIconPicName() );
			SetIconAni( pIcon.GetIconAniName() );
			SetAniColorTransform( pIcon.GetAniColorTransform() );
			SetStyleData( "ShowBackImage" , pIcon.isStyleData( "ShowBackImage" ) );
			SetAlignType( pIcon.GetAlignType() );
			
			CheckRegFrame();
		}
		public function ClearStatus():void
		{
			m_nCoolTimeCur = 0;
			m_nCoolTimeCur2 = 0;
			if ( m_pCool1 ) m_pCool1.SetShow( false );
			if ( m_pAni )
			{
				m_pAni.Release();
				m_pAni = null;
			}
			if ( m_pPic )
			{
				m_pPic.Release();
				m_pPic = null;
			}
			SetText( "" );
			m_pIcon.SetShow( false );
			SetAniColorTransform( null );
			CheckRegFrame();
			m_strImageSetName = "";
			SetLoading( false );
		}
		protected function SetStoneFrame( nFrame:int ):void
		{
			if ( m_pCool1 )
			{
				var x:int = nFrame % 8;
				var y:int = nFrame / 8;
				var width:int = m_pCool1.GetWidth();
				var height:int = m_pCool1.GetHeight();
				//m_pCool1.SetImageSrcRect( new dUIImageRect( x * 32 , y * 32 , x * 32 + 32 , y * 32 + 32 ) );
				m_pCool1.SetCurFrame( nFrame );
				m_pCool1.SetSize( width , height );
			}
		}
		public function isCooling():Boolean
		{
			return m_nCoolTimeCur > 0;
		}
		private function _OnFrameMove():void
		{
			if ( m_nCoolTimeCur > 0 )
			{
				if ( !m_pCool1 )
				{
					//m_pCool1 = new dUIImage( this );
					m_pCool1 = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_ANIIMAGEBOX , this , true , GetObjType() ) as dUIAniImageBox;
					m_pCool1.LoadFromImageSet( m_strCoolImageName );
					m_pCool1.Stop();
					//m_pCool1.SetImageSrcRect( new dUIImageRect( 0 , 0 , 32 , 32 ) );
					m_pCool1.SetShow( isStyleData( "AlwaysShowCoolImage" ) );
					m_pCool1.SetSize( GetWidth() , GetHeight() );
					OrderImage();
				}
			
				m_nCoolTimeCur -= GetImageRoot().GetTimeSinceLastFrame();
				if ( m_nCoolTimeCur < 0 ) m_nCoolTimeCur = 0;
				if ( m_nCoolTimeMax >= m_nCoolTimeCur )
				{
					if ( !m_bIconDragging )
						m_pCool1.SetShow( true );
					SetStoneFrame( ( m_nCoolTimeMax - m_nCoolTimeCur ) * 60 / m_nCoolTimeMax );
				}
				else
				{
					SetStoneFrame( 0 );
					m_pCool1.SetShow( isStyleData( "AlwaysShowCoolImage" ) );
				}
			}
			else
			{
				m_nCoolTimeCur = 0;
				if ( m_pCool1 ) m_pCool1.SetShow( isStyleData( "AlwaysShowCoolImage" ) );
				CheckRegFrame();
			}
		}
		public function SetCoolTimeCur( time:int ):void
		{
			m_nCoolTimeCur = time;
			CheckRegFrame();
		}
		public function GetCoolTimeCur():int
		{
			return m_nCoolTimeCur;
		}
		public function SetCoolTimeMax( time:int ):void
		{
			m_nCoolTimeMax = time;
			CheckRegFrame();
		}
		public function GetCoolTimeMax():int
		{
			return m_nCoolTimeMax;
		}
		override public function SetStyleData( name:String , bSet:Boolean ):void
		{
			if( name == "CopyDrag" ||
				name == "ShowBackImage" ||
				name == "CanDrag" ||
				name == "Select" ||
				name == "AlwaysShowCoolImage" )
			{
				if ( name == "ShowBackImage" )
					m_pBkImage.SetShow( bSet );
				else if ( name == "AlwaysShowCoolImage" && m_pCool1 )
					m_pCool1.SetShow( bSet );
				var bHandleMouse:Boolean = isHandleMouse();
				super.SetStyleData( name , bSet );
				SetHandleMouse( bHandleMouse );
			}
		}
		override public function OnLButtonDown( x:int , y:int ):void
		{
			super.OnLButtonDown( x , y );
			if ( isWindowEnable() )
			{
				if ( isEmpty() )
					FireEvent( dUISystem.GUIEVENT_TYPE_ICON_LBUTTON_DOWN_EMPTY );
				else if ( isCooling() )
					FireEvent( dUISystem.GUIEVENT_TYPE_ICON_LBUTTON_DOWN_STONING );
				else
					FireEvent( dUISystem.GUIEVENT_TYPE_ICON_LBUTTON_DOWN );
				m_bMouseDowned = true;
			}
		}
		override public function OnRButtonUp( x:int , y:int ):void
		{
			super.OnRButtonUp( x , y );
			if ( isWindowEnable() && isMouseIn() )
			{
				if ( isEmpty() )
					FireEvent( dUISystem.GUIEVENT_TYPE_ICON_RIGHTCLK_EMPTY );
				else if ( isCooling() )
					FireEvent( dUISystem.GUIEVENT_TYPE_ICON_RIGHTCLK_STONING );
				else
					FireEvent( dUISystem.GUIEVENT_TYPE_ICON_RIGHTCLK );
			}
		}
		public function isEmpty():Boolean
		{
			return GetImageSetName().length == 0;
		}
		override public function OnLButtonDblClick( x:int , y:int ):void
		{
			if ( isWindowEnable() )
			{
				if ( isEmpty() )
				{
				}
				else if( !isCooling() )
					FireEvent( dUISystem.GUIEVENT_TYPE_ICON_DBL_CLK );
				else
					FireEvent( dUISystem.GUIEVENT_TYPE_ICON_DBL_CLK_STONING );
			}
		}
		override public function OnLButtonDrag( x:int , y:int ):void
		{
			//super.OnLButtonDrag( x , y );
			if ( isWindowEnable() && isStyleData( "CanDrag" ) &&
				!isEmpty() )
			{
				var pDraggingIcon:dUIDragIcon = GetImageRoot().GetGlobalDragIcon();
				if ( !m_bIconDragging )
				{
					FireEvent( dUISystem.GUIEVENT_TYPE_ICON_DRAG_START );
					m_bIconDragging = true;
					if ( !isStyleData( "CopyDrag" ) )
					{
						m_pIcon.SetShow( false );
						m_pNumber.SetShow( false );
						if ( m_pCool1 ) m_pCool1.SetShow( false );
						if ( m_pAni ) m_pAni.SetShow( false );
						if ( m_pPic ) m_pPic.SetShow( false );
					}
					pDraggingIcon.CopyStatus( this );
					pDraggingIcon.SetShow( true );
				}
				pDraggingIcon.SetPos( GetImageRoot().GetMouseX() - pDraggingIcon.GetWidth() / 2 ,
					GetImageRoot().GetMouseY() - pDraggingIcon.GetHeight() / 2 );
			}
		}
		override public function OnLButtonUp( x:int , y:int ):void
		{
			if ( m_bIconDragging )
			{
				var pDraggingIcon:dUIDragIcon = GetImageRoot().GetGlobalDragIcon();
				pDraggingIcon.SetShow( false );
				var pHit:dUIImage = GetImageRoot().GetObjByPos( GetImageRoot().GetMouseX() ,
					GetImageRoot().GetMouseY() );
				var pHit2:dUIImage = GetImageRoot().GetObjByPos( GetImageRoot().GetMouseX() ,
					GetImageRoot().GetMouseY() , 1 );
				if ( !isEmpty() )
				{
					if ( pHit != this )
					{
						if ( pHit )
						{
							var nHit2ID:int = pHit2 ? pHit2.GetID() : 0;
							if ( pHit.GetObjType() == dUISystem.GUIOBJ_TYPE_TABCONTROL_BUTTON )
								FireEvent( dUISystem.GUIEVENT_TYPE_ICON_DRAG_DOWN , nHit2ID , pHit.GetID() , String( (pHit as dUITabButton).GetTabID() + 1 ) );
							else FireEvent( dUISystem.GUIEVENT_TYPE_ICON_DRAG_DOWN , nHit2ID , pHit.GetID() );
						}
						else FireEvent( dUISystem.GUIEVENT_TYPE_ICON_DRAG_DOWN , 0 );
					}
					else FireEvent( dUISystem.GUIEVENT_TYPE_ICON_DRAG_DOWN_SELF , GetID() , GetID() );
				}
			}
			else if ( isMouseIn() && isWindowEnable() )
			{
				if ( m_bMouseDowned )
				{
					if ( isEmpty() )
						FireEvent( dUISystem.GUIEVENT_TYPE_ICON_CLK_EMPTY );
					else if ( isCooling() )
						FireEvent( dUISystem.GUIEVENT_TYPE_ICON_CLK_STONING );
					else
						FireEvent( dUISystem.GUIEVENT_TYPE_ICON_CLK );
				}
			}
			m_bMouseDowned = false;
			m_bIconDragging = false;
			if ( !isEmpty() )
			{
				m_pIcon.SetShow( true );
				m_pNumber.SetShow( true );
				if ( m_pCool1 && ( m_nCoolTimeCur || m_nCoolTimeCur2 ) )
					m_pCool1.SetShow( true );
				if ( m_pPic ) m_pPic.SetShow( true );
				if ( m_pAni ) m_pAni.SetShow( true );
			}
			super.OnLButtonUp( x , y );
		}
		protected var m_pAniColorTransform:dUIColorTransform;
		public function SetAniColorTransform( pColorTransform:dUIColorTransform ):void
		{
			m_pAniColorTransform = pColorTransform;
			if ( m_pAni ) m_pAni.SetColorTransform( m_pAniColorTransform );
		}
		public function GetAniColorTransform():dUIColorTransform
		{
			return m_pAniColorTransform;
		}
		public function SetAniCurFrame( nFrame:int ):void
		{
			if ( m_pAni ) m_pAni.SetCurFrame( nFrame );
		}
		public function SetIconCoolImageName( strName:String ):void
		{
			m_strCoolImageName = strName;
			if ( m_pCool1 )
			{
				m_pCool1.LoadFromImageSet( m_strCoolImageName );
				//m_pCool1.SetImageSrcRect( new dUIImageRect( 0 , 0 , 32 , 32 ) );
				m_pCool1.SetShow( isStyleData( "AlwaysShowCoolImage" ) );
				m_pCool1.SetSize( GetWidth() , GetHeight() );
			}
		}
		public function GetIconCoolImageName():String
		{
			return m_strCoolImageName;
		}
		public function SetPlaySpeed( speed:int ):void
		{
			if ( m_pAni ) m_pAni.SetPlaySpeed( speed );
		}
	}
}