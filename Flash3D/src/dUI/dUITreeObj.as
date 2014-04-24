//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUITreeObj extends dUIImage
	{
		public var m_pTreeNext:dUITreeObj;
		public var m_pTreePrev:dUITreeObj;
		public var m_pTreeFather:dUITreeObj;
		public var m_pTreeChild:dUITreeObj;
		protected var m_pTreeRoot:dUITree;
		protected var m_pUpLine:dUIImage;
		protected var m_pDownLine:dUIImage;
		protected var m_pRightLine:dUIImage;
		protected var m_pButtonAdd:dUIImageButton;
		protected var m_pButtonSub:dUIImageButton;
		protected var m_pText:dUISuperText;
		protected var m_pTextButton:dUIButton;
		protected var m_bMin:Boolean;
		protected var m_nImageWidth:int;
		protected var m_nImageHeight:int;
		protected var m_pSelect:dUIImage;
		protected var m_bFrameUpdate:Boolean = false;
		protected var m_bForceShowExpandButton:Boolean = false;
		public function dUITreeObj( pFather:dUIImage , pTreeRoot:dUITree )
		{
			super( pFather , false );
			m_nObjType = dUISystem.GUIOBJ_TYPE_TREEOBJ;
			m_pTreeRoot = pTreeRoot;
			m_bMin = true;
			SetShow( false );
		}
		private function GetSelectImage():dUIImage
		{
			if ( !m_pSelect )
			{
				m_pSelect = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_GROUP , this , true , GetObjType() );
				m_pSelect.SetShow( false );
				m_pSelect.MoveBottom();
			}
			return m_pSelect;
		}
		public function _SetShow( bShow:Boolean ):void
		{
			if ( bShow )
			{
				if ( (m_pTreeChild != null || m_bForceShowExpandButton )&& m_pTreeRoot.isStyleData( "ButtonStyle" ) )
				{
					if ( m_pText != null )
					{
						m_pText.Release();
						m_pText = null;
					}
					if ( m_pButtonAdd != null )
					{
						m_pButtonAdd.Release();
						m_pButtonAdd = null;
					}
					if ( m_pButtonSub != null )
					{
						m_pButtonSub.Release();
						m_pButtonSub = null;
					}
					if ( m_pTextButton == null )
					{
						m_pTextButton = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_BUTTON , this , true , GetObjType() ) as dUIButton;
						m_pTextButton.LoadFromImageSet( "#左边按钮" );
						m_pTextButton.SetUIEventFunction( _OnAddButtonDown );
						SetMouseStyle( m_pTreeRoot.GetMouseStyle() );
						_SetText( GetText() );
					}
				}
				else if ( !m_pText )
				{
					if ( m_pTextButton )
					{
						m_pTextButton.Release();
						m_pTextButton = null;
					}
					//m_pButtonAdd = new dUIImageButton( this );
					m_pButtonAdd = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_IMAGEBUTTON , this , true , GetObjType() ) as dUIImageButton;
					//m_pButtonSub = new dUIImageButton( this );
					m_pButtonSub = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_IMAGEBUTTON , this , true , GetObjType() ) as dUIImageButton;
					//m_pText = new dUISuperText( this );
					m_pText = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_SUPPERTEXT , this , true , GetObjType() ) as dUISuperText;
					m_pText.SetStyleData( "AutoSetSize" , true );
					m_pText.SetAlignType( m_pTreeRoot.GetAlignType() );
					m_pText.SetShow( false );
					m_pText.SetText( "" );
					m_pText.SetUIEventFunction( OnTextEvent );
					m_pText.SetHandleMouse( isHandleMouse() );
					m_pText.RegMouseLowEvent( true );
					m_pButtonAdd.LoadFromImageSet( "树控件加号按钮正常,树控件加号按钮发亮,树控件加号按钮按下,树控件加号按钮无效" );
					m_pButtonSub.LoadFromImageSet( "树控件减号按钮正常,树控件减号按钮发亮,树控件减号按钮按下,树控件减号按钮无效" );
					m_nImageWidth = 0;
					m_nImageHeight = GetButtonAddHeight();
					m_pButtonAdd.SetUIEventFunction( _OnAddButtonDown );
					m_pButtonSub.SetUIEventFunction( _OnAddButtonDown );
					m_pButtonAdd.SetShow( false );
					m_pButtonSub.SetShow( false );
					SetMouseStyle( m_pTreeRoot.GetMouseStyle() );
					_SetText( GetText() );
				}
			}
		}
		override public function SetShow( bShow:Boolean ):void
		{
			if ( isShow() != bShow )
			{
				super.SetShow( bShow );
				_SetShow( bShow );
			}
		}
		private function _OnAddButtonDown( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_BUTTON_DOWN )
			{
				Expand( m_bMin );
				m_pTreeRoot.FireEvent( dUISystem.GUIEVENT_TYPE_TREE_EXPANT , int( isExpand() ) , 0 , GetFullText() );
			}
			else if ( event.type == dUISystem.GUIEVENT_TYPE_RBUTTON_DOWN )
				m_pTreeRoot.OnTreeObjRButtonDown( this );
		}
		override public function EnableWindow( bEnable:Boolean ):void
		{
			super.EnableWindow( bEnable );
			if ( m_pButtonAdd != null ) m_pButtonAdd.EnableWindow( bEnable );
			if ( m_pButtonSub != null ) m_pButtonSub.EnableWindow( bEnable );
			if ( m_pTextButton != null ) m_pTextButton.EnableWindow( bEnable );
		}
		public function Expand( bSet:Boolean ):void
		{
			if ( m_pTreeRoot.isWindowEnable() )
			{
				m_bMin = !bSet;
				Update();
				if ( bSet && m_pTreeRoot.isStyleData( "ExpandOnlyOne" ) )
				{
					var p:dUITreeObj = GetTreePrev();
					while ( p )
					{
						p.Expand( false );
						p = p.GetTreePrev();
					}
					p = GetTreeNext();
					while ( p )
					{
						p.Expand( false );
						p = p.GetTreeNext();
					}
				}
				if ( m_pTreeRoot.isStyleData( "ExpandOnlyOne" ) && m_pTextButton )
				{
					m_pTextButton.SetStyleData( "AlwaysPushDown" , true );
					m_pTextButton.SetPushDown( bSet );
				}
			}
		}
		public function isExpand():Boolean
		{
			return !m_bMin;
		}
		override public function _SetText( str:String ):void
		{
			//if ( GetText() != str )
			{
				super._SetText( str );
				if ( isShow() )
				{
					if ( m_pText != null )
					{
						m_pText.SetText( str );
						if ( m_pText.GetHeight() < GetButtonAddHeight() )
							m_pText.SetPos( (m_pButtonAdd.isShow()?GetButtonAddWidth():0) + (m_pButtonSub.isShow()?m_pButtonSub.GetWidth():0) +
								(m_pRightLine&&m_pRightLine.isShow()?m_pRightLine.GetWidth():0) , ( GetButtonAddHeight() - m_pText.GetHeight() ) / 2 );
						else
							m_pText.SetPos( (m_pButtonAdd.isShow()?GetButtonAddWidth():0) + (m_pButtonSub.isShow()?m_pButtonSub.GetWidth():0) +
								(m_pRightLine && m_pRightLine.isShow()?m_pRightLine.GetWidth():0) , 0 );
					}
					if ( m_pTextButton != null )
					{
						m_pTextButton.SetText( str );
						m_pTextButton.SetSizeAsText();
						m_pTextButton.SetSize( m_pTextButton.GetWidth() , 30 );
					}
					Update();
				}
			}
		}
		public function isButtonShow():Boolean
		{
			if ( m_pButtonAdd == null ) return false;
			return m_pButtonAdd.isShow() || m_pButtonSub.isShow();
		}
		public function GetFullText():String
		{
			var ret:String = new String();
			ret += GetText();
			var p:dUITreeObj = m_pTreeFather;
			while ( p )
			{
				ret = p.GetText() + "|" + ret;
				p = p.m_pTreeFather;
			}
			return ret;
		}
		public function Update():void
		{
			/*if ( m_bFrameUpdate == false )
			{
				var pImageRoot:dUIImageRoot = GetImageRoot();
				if ( pImageRoot )
				{
					pImageRoot._RegEnterFrame( UpdateFrame );
					m_bFrameUpdate = true;
				}
			}*/
			_Update();
		}
		/*public function UpdateFrame():void
		{
			if ( m_bFrameUpdate )
			{
				m_bFrameUpdate = false;
				_Update();
			}
		}*/
		public function isNeedUpdate():Boolean
		{
			return false;
			//return m_bFrameUpdate;
		}
		public function ComputeSize():void
		{
			var bShowLine:Boolean = m_pTreeRoot.isStyleData( "ShowLine" );
			if ( bShowLine )
			{
				if ( !m_pUpLine )
				{
					m_pUpLine = new dUIImage( this );
					m_pUpLine.LoadFromImageSet( "树控件竖线" );
				}
				if ( !m_pDownLine )
				{
					m_pDownLine = new dUIImage( this );
					m_pDownLine.LoadFromImageSet( "树控件竖线" );
				}
				if ( !m_pRightLine )
				{
					m_pRightLine = new dUIImage( this );
					m_pRightLine.LoadFromImageSet( "树控件横线" );
				}
			}
			else
			{
				if ( m_pUpLine )
				{
					m_pUpLine.Release();
					m_pUpLine = null;
				}
				if ( m_pDownLine )
				{
					m_pDownLine.Release();
					m_pDownLine = null;
				}
				if ( m_pRightLine )
				{
					m_pRightLine.Release();
					m_pRightLine = null;
				}
			}
			
			if ( m_pText != null ) m_pText.SetShow( true );
			if ( m_pTextButton != null ) m_pTextButton.SetShow( true );
			if ( bShowLine )
			{
				m_pUpLine.SetShow( m_pTreePrev != null || m_pTreeFather != null );
				m_pDownLine.SetShow( m_pTreeNext != null );
			}
			if ( m_bMin )
			{
				if ( m_pButtonAdd != null ) m_pButtonAdd.SetShow( true );
				if ( m_pButtonSub != null ) m_pButtonSub.SetShow( false );
			}
			else
			{
				if ( m_pButtonAdd != null ) m_pButtonAdd.SetShow( false );
				if ( m_pButtonSub != null ) m_pButtonSub.SetShow( true );
			}
			if ( m_pTreeChild == null && m_bForceShowExpandButton == false || m_pTreeRoot.isStyleData( "ForceHideExpand" ) && m_bForceShowExpandButton == false )
			{
				if ( m_pButtonAdd != null ) m_pButtonAdd.SetShow( false );
				if ( m_pButtonSub != null ) m_pButtonSub.SetShow( false );
			}
			if ( m_pRightLine )
			{
				m_pRightLine.SetSize( GetButtonAddWidth() / 2 , m_pRightLine.GetHeight() );
				if ( m_pButtonAdd != null )
					m_pRightLine.SetShow( (!(m_pButtonAdd.isShow() || m_pButtonSub.isShow())) && m_pTreeRoot.isStyleData( "ShowLine" ) );
				else
					m_pRightLine.SetShow( false );
			}
			if ( m_pText != null )
			{
				m_pText.SetPos( (m_pButtonAdd.isShow()?m_pButtonAdd.GetWidth():0) + (m_pButtonSub.isShow()?m_pButtonSub.GetWidth():0) +
					(m_pRightLine && m_pRightLine.isShow()?m_pRightLine.GetWidth():0) , m_pText.GetPosY() );
				m_nImageWidth = m_pText.GetWidth() + m_pText.GetPosX();
				m_nImageHeight = m_pText.GetHeight() + m_pText.GetPosY();
				if ( m_nImageHeight < GetButtonAddHeight() )
					m_nImageHeight = GetButtonAddHeight();
			}
			if ( m_pTextButton != null )
			{
				m_pTextButton.SetSize( DYM_GUI_MAX( m_pTreeRoot.GetScroll().GetClient().GetWidth() , m_pTreeRoot.GetScroll().GetView().GetWidth() ) , m_pTextButton.GetHeight() );
				m_nImageWidth = m_pTextButton.GetWidth();
				m_nImageHeight = m_pTextButton.GetHeight();
			}
			if ( m_bMin )
				SetSize( m_nImageWidth , m_nImageHeight );
		}
		public function _Update():void
		{
			if ( m_bRelease || !isShow() ) return;
			ComputeSize();
			var y:int = m_nImageHeight;
			var p:dUITreeObj = m_pTreeChild;
			var x:int = m_nImageWidth;
			while( p )
			{
				p.SetShow( !m_bMin );
				p.SetPos( GetChildPosX() , y );
				y += p.GetHeight();
				x = DYM_GUI_MAX( x , p.GetWidth() + p.GetPosX() );
				p = p.m_pTreeNext;
			}
			if( !m_bMin )
				SetSize( x , y );
			if ( m_pButtonAdd != null ) m_pButtonAdd.SetPos( 0 , (m_nImageHeight-GetButtonAddHeight())/2 );
			if ( m_pButtonSub != null ) m_pButtonSub.SetPos( 0 , (m_nImageHeight-GetButtonAddHeight())/2 );
			if ( m_pDownLine && m_pRightLine && m_pUpLine )
			{
				m_pUpLine.SetPos( (GetButtonAddWidth() - m_pUpLine.GetWidth()) / 2 , 0 );
				m_pDownLine.SetPos( m_pUpLine.GetPosX() , m_nImageHeight/2 );
				m_pRightLine.SetPos( m_pUpLine.GetPosX() , (GetButtonAddHeight()-m_pRightLine.GetHeight())/2+GetButtonAddPosY() );
				m_pUpLine.SetSize( m_pUpLine.GetWidth() , m_nImageHeight / 2 );
				m_pDownLine.SetSize( m_pDownLine.GetWidth() , GetHeight() - m_pDownLine.GetPosY() );
			}
			
			if( GetTreePrev() )
				SetPos( GetPosX() , GetTreePrev().GetPosY()+GetTreePrev().GetHeight() );
			else
			{
				if( m_pTreeFather )
					SetPos( GetPosX() , m_pTreeFather.GetHeight() );
				else
					SetPos( GetPosX() , 0 );
			}
			p = m_pTreeNext;
			y = GetHeight()+GetPosY();
			while( p )
			{
				p.SetPos( p.GetPosX() , y );
				y += p.GetHeight();
				p = p.m_pTreeNext;
			}
			if( m_pTreeFather )
				m_pTreeFather._Update();
			else
				m_pTreeRoot.OnTreeObjResize();
			if ( m_pSelect )
				SetShowSelect( GetSelectImage().isShow() );
			m_pTreeRoot.GetScroll().CheckButtonPos();
		}
		protected function GetButtonAddWidth():int
		{
			if ( m_pButtonAdd != null ) return m_pButtonAdd.GetWidth();
			return 0;
		}
		protected function GetButtonAddHeight():int
		{
			if ( m_pButtonAdd != null ) return m_pButtonAdd.GetHeight();
			return 0;
		}
		protected function GetButtonAddPosY():int
		{
			if ( m_pButtonAdd != null ) return m_pButtonAdd.GetPosY();
			return 0;
		}
		public function GetTreeNext():dUITreeObj
		{
			return m_pTreeNext;
		}
		public function GetTreePrev():dUITreeObj
		{
			return m_pTreePrev;
		}
		public function GetTreeFather():dUITreeObj
		{
			return m_pTreeFather;
		}
		public function GetTreeChild():dUITreeObj
		{
			return m_pTreeChild;
		}
		public function GetChildPosX():int
		{
			//return m_pTreeRoot.isStyleData( "ShowLine" )?m_pRightLine.GetWidth():10;
			//return m_pRightLine.GetWidth() + m_pUpLine.GetPosX();
			if ( m_pButtonAdd == null ) return m_pTreeRoot.GetChildStepOffsetX() + 20;
			return DYM_GUI_MAX( GetButtonAddWidth() , m_pButtonSub.GetWidth() ) - (m_pRightLine? m_pRightLine.GetWidth():0) + m_pTreeRoot.GetChildStepOffsetX();
		}
		public function AddTreeToNext( pObj:dUITreeObj ):void
		{
			if( m_pTreeNext )
				m_pTreeNext.m_pTreePrev = pObj;
			pObj.m_pTreePrev = this;
			pObj.m_pTreeNext = m_pTreeNext;
			m_pTreeNext = pObj;
			pObj.m_pTreeFather = m_pTreeFather;
			pObj.SetPos( 0 , GetHeight() );
			pObj.Update();
		}
		public function AddTreeToPrev( pObj:dUITreeObj ):void
		{
			if( m_pTreePrev )
				m_pTreePrev.m_pTreeNext = pObj;
			pObj.m_pTreeNext = this;
			pObj.m_pTreePrev = m_pTreePrev;
			m_pTreePrev = pObj;
			pObj.m_pTreeFather = m_pTreeFather;
			if( m_pTreeFather )
				if( m_pTreeFather.m_pTreeChild == this )
					m_pTreeFather.m_pTreeChild = pObj;
			if( m_pTreeRoot.m_pTreeRoot == this )
				m_pTreeRoot.m_pTreeRoot = pObj;
			else
				pObj.SetPos( 0 , GetHeight() );
			pObj.Update();
		}
		public function CreateTreeToNext( pNew:dUITreeObj = null ):dUITreeObj
		{
			var pObj:dUITreeObj = pNew;
			if ( !pObj ) pObj = new dUITreeObj( m_pFather , m_pTreeRoot );
			pObj.SetHandleMouse( isHandleMouse() );
			AddTreeToNext( pObj );
			Update();
			return pObj;
		}
		public function CreateTreeToPrev( pNew:dUITreeObj = null ):dUITreeObj
		{
			var pObj:dUITreeObj = pNew;
			if ( !pObj ) pObj = new dUITreeObj( m_pFather , m_pTreeRoot );
			pObj.SetHandleMouse( isHandleMouse() );
			AddTreeToPrev( pObj );
			Update();
			return pObj;
		}
		public function CreateTreeToChild( nAddAt:int = -1 , pNew:dUITreeObj = null ):dUITreeObj
		{
			var pObj:dUITreeObj = pNew;
			if ( !pObj ) pObj = new dUITreeObj( this , m_pTreeRoot );
			pObj.SetHandleMouse( isHandleMouse() );
			if( m_pTreeChild )
			{
				var p:dUITreeObj = m_pTreeChild;
				if ( nAddAt == -1 )
				{
					while( p.m_pTreeNext )
						p = p.m_pTreeNext;
					p.AddTreeToNext( pObj );
				}
				else
				{
					var pLastValid:dUITreeObj = p;
					while ( p && nAddAt )
					{
						if ( p.m_pTreeNext ) pLastValid = p.m_pTreeNext;
						p = p.m_pTreeNext;
						nAddAt--;
					}
					if ( p )
						p.AddTreeToPrev( pObj );
					else
					{
						p = pLastValid;
						pLastValid.AddTreeToNext( pObj );
					}
				}
				p.Update();
			}
			else
			{
				m_pTreeChild = pObj;
				pObj.SetPos( 0 , GetHeight() );
			}
			pObj.m_pTreeFather = this;
			_SetShow( isShow() );
			pObj.Update();
			Update();
			return pObj;
		}
		public function SetTreeChild( pTreeChild:dUITreeObj ):void
		{
			m_pTreeChild = pTreeChild;
			_SetShow( isShow() );
		}
		public function SetShowSelect( bShow:Boolean ):void
		{
			if ( bShow && m_pText != null && m_pText.GetText().length )
			{
				if ( isShow() )
				{
					var w:int = m_pText.GetWidth();
					var h:int = m_pText.GetHeight();
					if ( w && h )
					{
						SelectionSetSize( GetSelectImage() , w , h );
						GetSelectImage().SetPos( m_pText.GetPosX() , m_pText.GetPosY() );
					}
					GetSelectImage().SetShow( Boolean( w && h ) );
				}
			}
			else GetSelectImage().SetShow( false );
		}
		public function SetShowSelectOver( pObj:dUIImage ):void
		{
			pObj.SetPos( GetPosX_WhetherRoot() + m_pText.GetPosX() , GetPosY_WhetherRoot() + m_pText.GetPosY() );
			pObj.SetSize( m_pText.GetWidth() , m_pText.GetHeight() );
		}
		public function SelectionSetSize( pObj:dUIImage , w:int , h:int ):void
		{
			if ( pObj.GetWidth() != w || pObj.GetHeight() != h )
			{
				/*var color:uint = 0xff72c8c7;
				var pSprite:Sprite = new Sprite();
				for ( var k:int = 0 ; k < 3 ; k ++ )
				{
					pSprite.graphics.lineStyle( 1 , color & 0x00ffffff , (k+1) / 3 );
					pSprite.graphics.drawRect( k , k , w - k * 2 - 1 , h - k * 2 - 1 );
				}
				if ( w && h )
				{
					var pBitmapData:BitmapData = new BitmapData( w , h , true , 0 );
					pBitmapData.draw( pSprite );
				}
				pObj.LoadFromBitmapData( pBitmapData );*/
				pObj.LoadFromImageSet( "列表选中1,列表选中2,列表选中3,列表选中4,列表选中5,列表选中6,列表选中7,列表选中8,列表选中9" );
				pObj.SetSize( w , h );
			}
		}
		public function GetSelectImageHeight():int
		{
			return GetSelectImage().GetHeight();
		}
		public function GetPosX_WhetherRoot():int
		{
			var p:dUITreeObj = this;
			var ret:int = 0;
			while ( p )
			{
				ret += p.GetPosX();
				p = p.GetTreeFather();
			}
			return ret;
		}
		public function GetPosY_WhetherRoot():int
		{
			var p:dUITreeObj = this;
			var ret:int = 0;
			while ( p )
			{
				ret += p.GetPosY();
				p = p.GetTreeFather();
			}
			return ret;
		}
		public function OnTextEvent( event:dUIEvent ):void
		{
			if ( event.type == dUISystem.GUIEVENT_TYPE_MOUSE_IN )
				m_pTreeRoot.OnTreeObjMouseIn( this );
			else if ( event.type == dUISystem.GUIEVENT_TYPE_MOUSE_OUT )
				m_pTreeRoot.OnTreeObjMouseOut( this );
			else if ( event.type == dUISystem.GUIEVENT_TYPE_LBUTTON_DOWN )
				m_pTreeRoot.OnTreeObjLButtonDown( this );
			else if ( event.type == dUISystem.GUIEVENT_TYPE_RBUTTON_DOWN )
				m_pTreeRoot.OnTreeObjRButtonDown( this );
			else FireEvent( event.type , event.nParam1 , event.nParam2 , event.sParam , event.oParam );
		}
		public function SetForceShowExpandButton( bShow:Boolean ):void
		{
			if ( m_bForceShowExpandButton != bShow )
			{
				m_bForceShowExpandButton = bShow;
				_SetShow( isShow() );
				Update();
			}
		}
		public function isForceShowExpandButton():Boolean
		{
			return m_bForceShowExpandButton;
		}
		override public function SetMouseStyle( nType:int ):void
		{
			if ( m_pButtonAdd != null ) m_pButtonAdd.SetMouseStyle( nType );
			if ( m_pButtonSub != null ) m_pButtonSub.SetMouseStyle( nType );
			if ( m_pTextButton != null ) m_pTextButton.SetMouseStyle( nType );
			if ( m_pText != null ) m_pText.SetMouseStyle( nType );
		}
		public function GetTextBoundingRect( nIndex:int ):dUIImageRect
		{
			var str:String = GetFullText();
			if ( nIndex < 0 ) return null;
			var rc:dUIImageRect;
			if ( m_pText != null )
				rc = m_pText.GetTextBoundingRect( nIndex );
			else
				rc = new dUIImageRect( 0 , 0 , m_pTextButton.GetWidth() , m_pTextButton.GetHeight() );
			if ( rc )
			{
				var x:int = GetPosX_WhetherRoot();
				var y:int = GetPosY_WhetherRoot();
				rc.left += x;
				rc.right += x;
				rc.top += y;
				rc.bottom += y;
			}
			return rc;
		}
		override public function SetHandleMouse( bHandle:Boolean ):void
		{
			super.SetHandleMouse( bHandle );
			if ( m_pText ) m_pText.SetHandleMouse( bHandle );
		}
	}
}