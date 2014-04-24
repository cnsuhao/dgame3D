//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dUITree extends dUIImage
	{
		protected var m_pScroll:dUIScroll;
		public var m_pTreeRoot:dUITreeObj;
		protected var m_vecSelectTreeObj:Array = new Array();
		protected var m_bFirstInitTreeRoot:Boolean;
		protected var m_nChildStepOffsetX:int = 0;
		protected var m_pSelectOver:dUIGroup;
		public function dUITree( pFather:dUIImage ) 
		{
			super( pFather );
			m_nObjType = dUISystem.GUIOBJ_TYPE_TREE;
			m_pScroll = new dUIScroll( this );
			m_bFirstInitTreeRoot = true;
			// 设置默认
			SetSize( 200 , 200 );
			SetHandleMouse( true );
			SetAlignType( 1 );// 左对齐
			SetStyleData( "ShowSelectOver" , true );
			SetStyleData( "ShowSelection" , true );
			SetStyleData( "ShowLine" , true );
			SetStyleData( "FatherNoSelection" , true );

			m_pSelectOver = GetImageRoot().NewObj( dUISystem.GUIOBJ_TYPE_GROUP , m_pScroll.GetClient() , true , GetObjType() ) as dUIGroup;
			m_pSelectOver.LoadFromImageSet( "列表移入1,列表移入2,列表移入3,列表移入4,列表移入5,列表移入6,列表移入7,列表移入8,列表移入9" );
			m_pSelectOver.SetShow( false );
			m_pTreeRoot = new dUITreeObj( m_pScroll.GetClient() , this );
			m_pTreeRoot.SetHandleMouse( isHandleMouse() );
			m_pTreeRoot.SetShow( true );
			
			
		}
		private function OnDeleteTreeObj( pDel:dUITreeObj ):void
		{
			for ( var i:int = 0 ; i < m_vecSelectTreeObj.length ; i ++ )
			{
				if ( m_vecSelectTreeObj[i] == pDel )
				{
					m_vecSelectTreeObj.splice( i , 1 );
					break;
				}
			}
		}
		public function GetChildStepOffsetX():int
		{
			return m_nChildStepOffsetX;
		}
		public function SetChildStepOffsetX( width:int ):void
		{
			m_nChildStepOffsetX = width;
		}
		public function OnTreeObjResize():void
		{
			var h:int = 0;
			var w:int = 0;
			var p:dUITreeObj = m_pTreeRoot;
			while( p )
			{
				h += p.GetHeight();
				if ( w < p.GetWidth() )
					w = p.GetWidth();
				p = p.m_pTreeNext;
			}
			m_pScroll.SetClientSize( w , h );
		}
		public function OnTreeObjLButtonDown( pObj:dUITreeObj ):void
		{
			if ( isWindowEnable() )
			{
				if ( isStyleData( "FatherNoSelection" ) && pObj.isButtonShow() )
				{
					pObj.Expand( !pObj.isExpand() );
					FireEvent( dUISystem.GUIEVENT_TYPE_TREE_EXPANT , int( pObj.isExpand() ) , 0 , pObj.GetFullText() );
				}
				else
				{
					ClearCurSel();
					SetCurSel( pObj );
					if ( pObj )
					{
						var s:String = new String();
						var p:dUITreeObj = pObj;
						while ( p )
						{
							if ( s.length ) s = "|" + s;
							s = p.GetText() + s;
							p = p.GetTreeFather();
						}
						FireEvent( dUISystem.GUIEVENT_TYPE_TREE_LBUTTON_DOWN , int( pObj.isExpand() ) , 0 , s );
					}
				}
			}
		}
		public function OnTreeObjRButtonDown( pObj:dUITreeObj ):void
		{
			if ( isWindowEnable() )
			{
				if ( isStyleData( "FatherNoSelection" ) && pObj.isButtonShow() )
				{
					pObj.Expand( !pObj.isExpand() );
				}
				else
				{
					if ( pObj )
					{
						var s:String = new String();
						var p:dUITreeObj = pObj;
						while ( p )
						{
							if ( s.length ) s = "|" + s;
							s = p.GetText() + s;
							p = p.GetTreeFather();
						}
						FireEvent( dUISystem.GUIEVENT_TYPE_TREE_RBUTTON_DOWN , 0 , 0 , s );
					}
				}
			}
		}
		public function OnTreeObjMouseIn( pObj:dUITreeObj ):void
		{
			if ( isStyleData( "ShowSelectOver" ) )
			{
				pObj.SetShowSelectOver( m_pSelectOver );
				m_pSelectOver.SetShow( true );
			}
			if ( isRegMouseLowEvent() )
				FireEvent( dUISystem.GUIEVENT_TYPE_TREE_OBJ_MOUSE_IN , 0 , 0 , pObj.GetFullText() );
		}
		public function OnTreeObjMouseOut( pObj:dUITreeObj ):void
		{
			m_pSelectOver.SetShow( false );
			if ( isRegMouseLowEvent() )
				FireEvent( dUISystem.GUIEVENT_TYPE_TREE_OBJ_MOUSE_OUT , 0 , 0 , pObj.GetFullText() );
		}
		private function isSelectListHaveObj( pObj:dUITreeObj ):Boolean
		{
			for ( var i:int = 0 ; i < m_vecSelectTreeObj.length ; i ++ )
			{
				if ( m_vecSelectTreeObj[i] == pObj ) return true;
			}
			return false;
		}
		protected function _UpdateAll( pTree:dUITreeObj , vecTmp:Vector.<dUITreeObj> ):void
		{
			while( pTree )
			{
				vecTmp.push( pTree );
				_UpdateAll( pTree.GetTreeChild() , vecTmp );
				pTree = pTree.GetTreeNext();
			}
		}
		protected function UpdateAll( bReshow:Boolean = false ):void
		{
			var vecTmp:Vector.<dUITreeObj> = new Vector.<dUITreeObj>;
			_UpdateAll( m_pTreeRoot , vecTmp );
			for ( var i:int = vecTmp.length - 1 ; i >= 0 ; i -- )
			{
				if ( bReshow ) vecTmp[i]._SetShow( vecTmp[i].isShow() );
				vecTmp[i].Update();
				//vecTmp[i].UpdateFrame();
			}
		}
		public function SetCurSel( pTreeObj:dUITreeObj ):void
		{
			if ( pTreeObj && !isSelectListHaveObj( pTreeObj ) )
			{
				m_vecSelectTreeObj.push( pTreeObj );
				//if ( pTreeObj.isNeedUpdate() )
				//	UpdateAll();
				var p:dUITreeObj = pTreeObj.GetTreeFather();
				while ( p )
				{
					p.Expand( true );
					p = p.GetTreeFather();
				}
				pTreeObj.Update();
				pTreeObj.SetShowSelect( isStyleData( "ShowSelection" ) );
				var x:int = pTreeObj.GetPosX_WhetherRoot();
				var y:int = pTreeObj.GetPosY_WhetherRoot();
				var h:int = pTreeObj.GetSelectImageHeight();
				m_pScroll.SetInView( x , y , h );
			}
		}
		public function GetCurSel():String
		{
			var str:String = new String();
			for ( var i:int = 0 ; i < m_vecSelectTreeObj.length ; i ++ )
			{
				if ( str.length ) str += ",";
				str += ( m_vecSelectTreeObj[i] as dUITreeObj ).GetFullText();
			}
			return str;
		}
		override public function SetSize( w:int , h:int ):void
		{
			super.SetSize( w , h );
			m_pScroll.SetSize( w , h );
		}
		public function CreateTreeByString( str:String , cSplitKey:String = "|" , nAddAt:int = -1 , pNew:dUITreeObj = null ):dUITreeObj
		{
			var strTmp:String = new String();
			var pObj:dUITreeObj = GetTreeRoot();
			var bFirst:Boolean = true;
			var bInYinHao:Boolean;
			for( var i:int = 0 ; i <= str.length ; i ++ )
			{
				if( i == str.length || str.charAt(i) == cSplitKey && (!bInYinHao) )
				{
					var bLast:Boolean = i == str.length;
					if( bFirst )
					{
						if( m_bFirstInitTreeRoot )
						{
							if ( pNew )
							{
								m_pTreeRoot.Release();
								m_pTreeRoot = pNew;
							}
							else
								pObj.SetText( strTmp );
							m_bFirstInitTreeRoot = false;
						}
						else
						{
							var p:dUITreeObj = pObj;
							var pLastValid:dUITreeObj = pObj;
							var bFind:Boolean = false;
							while( p )
							{
								if( strTmp == p.GetText() )
								{
									bFind = true;
									break;
								}
								p = p.GetTreeNext();
								if( p ) pLastValid = p;
							}
							if( !bFind )
							{
								if ( nAddAt == -1 )
								{
									p = pLastValid.CreateTreeToNext( pNew );
									p.SetShow( true );
								}
								else
								{
									p = pObj;
									while ( p && nAddAt )
									{
										pLastValid = p;
										p = p.GetTreeNext();
										nAddAt--;
									}
									if ( !p )
									{
										p = pLastValid.CreateTreeToNext( pNew );
										p.SetShow( true );
									}
									else
									{
										p = p.CreateTreeToPrev( pNew );
										p.SetShow( true );
									}
								}
								p.SetText( strTmp );
							}
							else if ( bLast && nAddAt != -1 )
							{
								RemoveTree( p );
								//pObj.Update();
								return CreateTreeByString( str , cSplitKey , nAddAt , p );
							}
							pObj = p;
						}
					}
					else
					{
						p = pObj.GetTreeChild();
						bFind = false;
						while( p )
						{
							if( strTmp == p.GetText() )
							{
								bFind = true;
								break;
							}
							p = p.GetTreeNext();
						}
						if( !bFind )
						{
							p = pObj.CreateTreeToChild( nAddAt , pNew );
							if ( pObj.GetTreeChild() ) p.SetShow( pObj.GetTreeChild().isShow() );
							p.SetText( strTmp );
						}
						else if ( bLast && nAddAt != -1 )
						{
							RemoveTree( p );
							return CreateTreeByString( str , cSplitKey , nAddAt , p );
						}
						pObj = p;
					}
					bFirst = false;
					strTmp = "";
				}
				else
				{
					if ( i >= 10 && str.charAt(i) == "'" && str.charAt( i-10 ) == "&" && !bInYinHao )
					{
						var b:Boolean = true;
						for ( var j:int = i - 8 ; j < i ; i ++ )
						{
							if ( !(str.charCodeAt( j ) >= "0".charCodeAt() &&
								 str.charCodeAt( j ) <= "9".charCodeAt() ||
								 str.charCodeAt( j ) >= "A".charCodeAt() &&
								 str.charCodeAt( j ) <= "Z".charCodeAt() ||
								 str.charCodeAt( j ) >= "a".charCodeAt() &&
								 str.charCodeAt( j ) <= "z".charCodeAt() ) )
							{
								b = false;
								break;
							}
						}
						if ( b )
							bInYinHao = true;
					}
					else if ( str.charAt(i) == "'" && bInYinHao )
						bInYinHao = !bInYinHao;
					strTmp += str.charAt(i);
				}
			}
			return pObj;
		}
		public function DeleteTreeByString( str:String , cSplitKey:String = "|" ):void
		{
			var pObj:dUITreeObj = FindObjByString( str , cSplitKey );
			if ( pObj )
			{
				DeleteTree( pObj );
				m_pScroll.CheckButtonPos();
			}
		}
		private function _GetAllObj( pObj:dUITreeObj , out:Object ):void
		{
			while ( pObj )
			{
				if ( out.ret.length ) out.ret += ",";
				out.ret += pObj.GetFullText();
				_GetAllObj( pObj.GetTreeChild() , out );
				pObj = pObj.GetTreeNext();
			}
		}
		public function GetAllObj( strTreeObjName:String ):String
		{
			var ret:Object = { ret:"" };
			var pObj:dUITreeObj;
			if ( strTreeObjName == "" )
				pObj = GetTreeRoot();
			else
			{
				pObj = FindObjByString( strTreeObjName );
				if ( pObj ) pObj = pObj.GetTreeChild();
			}
			if( pObj )
				_GetAllObj( pObj , ret );
			return ret.ret;
		}
		public function ClearCurSel():void
		{
			for ( var i:int = 0 ; i < m_vecSelectTreeObj.length ; i ++ )
			{
				( m_vecSelectTreeObj[i] as dUITreeObj ).SetShowSelect( false );
			}
			m_vecSelectTreeObj.length = 0;
		}
		public function ClearTreeChild( pTreeFather:dUITreeObj ):void
		{
			var pObj:dUITreeObj = pTreeFather.GetTreeChild();
			while ( pObj )
			{
				var pNext:dUITreeObj = pObj.GetTreeNext();
				DeleteTree( pObj );
				pObj = pNext;
			}
		}
		protected function _FindObjByUserData( pObj:dUITreeObj , pUserData:Object ):String
		{
			while ( pObj )
			{
				if ( pObj.GetUserData() == pUserData )
				{
					return pObj.GetFullText();
				}
				var str:String = _FindObjByUserData( pObj.m_pTreeChild , pUserData );
				if ( str.length ) return str;
				pObj = pObj.m_pTreeNext;
			}
			return "";
		}
		public function FindObjByUserData( pUserData:Object ):String
		{
			return _FindObjByUserData( m_pTreeRoot , pUserData );
		}
		/// 通过字符串查找Obj
		public function FindObjByString( str:String , cSplitKey:String = "|" ):dUITreeObj
		{
			var strTmp:String = new String;
			var pObj:dUITreeObj = GetTreeRoot();
			var bFirst:Boolean = true;
			var bInYinHao:Boolean;
			for( var i:int = 0 ; i <= str.length ; i ++ )
			{
				if( i == str.length || str.charAt(i) == cSplitKey && (!bInYinHao) )
				{
					if( bFirst )
					{
						var p:dUITreeObj = pObj;
						var pLastValid:dUITreeObj = pObj;
						var bFind:Boolean = false;
						while( p )
						{
							if( strTmp == p.GetText() )
							{
								bFind = true;
								break;
							}
							p = p.GetTreeNext();
							if( p ) pLastValid = p;
						}
						if( !bFind )
						{
							return null;
						}
						pObj = p;
						if( i == str.length )
						{
							return pObj;
						}
						bFirst = false;
						strTmp = "";
					}
					else
					{
						p = pObj.GetTreeChild();
						bFind = false;
						while( p )
						{
							if( strTmp == p.GetText() )
							{
								bFind = true;
								break;
							}
							p = p.GetTreeNext();
						}
						if( !bFind || !p )
						{
							return null;
						}
						pObj = p;
						if( i == str.length )
						{
							return pObj;
						}
						strTmp = "";
					}
				}
				else
				{
					if ( i >= 10 && str.charAt(i) == "'" && str.charAt( i-10 ) == "&" && !bInYinHao )
					{
						var b:Boolean = true;
						for ( var j:int = i - 8 ; j < i ; i ++ )
						{
							if ( !(str.charCodeAt( j ) >= "0".charCodeAt() &&
								 str.charCodeAt( j ) <= "9".charCodeAt() ||
								 str.charCodeAt( j ) >= "A".charCodeAt() &&
								 str.charCodeAt( j ) <= "Z".charCodeAt() ||
								 str.charCodeAt( j ) >= "a".charCodeAt() &&
								 str.charCodeAt( j ) <= "z".charCodeAt() ) )
							{
								b = false;
								break;
							}
						}
						if ( b )
							bInYinHao = true;
					}
					else if ( str.charAt(i) == "'" && bInYinHao )
						bInYinHao = !bInYinHao;
					strTmp += str.charAt(i);
				}
			}
			return null;
		}
		protected function _SetHandleMouse( pTree:dUITreeObj , bSet:Boolean ):void
		{
			while( pTree )
			{
				pTree.SetHandleMouse( bSet );
				_SetHandleMouse( pTree.GetTreeChild() , bSet );
				pTree = pTree.GetTreeNext();
			}
		}
		override public function SetHandleMouse( bSet:Boolean ):void
		{
			if ( m_bHandleMouse != bSet )
			{
				_SetHandleMouse( m_pTreeRoot , bSet );
				m_bHandleMouse = bSet;
			}
		}
		/// 设置全部展开
		protected function _ExpandAll( pTree:dUITreeObj , bExpand:Boolean ):void
		{
			while( pTree )
			{
				pTree.Expand( bExpand );
				_ExpandAll( pTree.GetTreeChild() , bExpand );
				pTree = pTree.GetTreeNext();
			}
		}
		public function ExpandAll( bExpand:Boolean ):void
		{
			_ExpandAll( m_pTreeRoot , bExpand );
		}
		protected function _EnableWindow( pTree:dUITreeObj , bEnable:Boolean ):void
		{
			while( pTree )
			{
				pTree.EnableWindow( bEnable );
				_EnableWindow( pTree.GetTreeChild() , bEnable );
				pTree = pTree.GetTreeNext();
			}
		}
		override public function EnableWindow( bEnable:Boolean ):void
		{
			super.EnableWindow( bEnable );
			_EnableWindow( m_pTreeRoot , bEnable );
		}
		public function ClearTree():void
		{
			var pTree:dUITreeObj = m_pTreeRoot;
			while( pTree )
			{
				var pNext:dUITreeObj = pTree.GetTreeNext();
				pTree.Release();
				OnDeleteTreeObj( pTree );
				pTree = null;
				pTree = pNext;
			}
			m_pTreeRoot = new dUITreeObj( m_pScroll.GetClient() , this );
			m_pTreeRoot.SetShow( true );
			m_pTreeRoot.SetHandleMouse( isHandleMouse() );
			m_bFirstInitTreeRoot = true;
			m_pScroll.CheckButtonPos();
		}
		public function GetScroll():dUIScroll
		{
			return m_pScroll;
		}
		/*public function CreateTreeToNext( pInsert:dUITreeObj = null ):dUITreeObj
		{
			if( pInsert == null ) pInsert = m_pTreeRoot;
			return pInsert.CreateTreeToNext();
		}
		public function CreateTreeToPrev( pInsert:dUITreeObj = null ):dUITreeObj
		{
			if( pInsert == null ) pInsert = m_pTreeRoot;
			return pInsert.CreateTreeToPrev();
		}
		public function CreateTreeToChild( pInsert:dUITreeObj = null ):dUITreeObj
		{
			if( pInsert == null ) pInsert = m_pTreeRoot;
			return pInsert.CreateTreeToChild();
		}*/
		protected function RemoveTree( pTree:dUITreeObj ):void
		{
			if( !pTree )return;
			if ( pTree == m_pTreeRoot ) m_pTreeRoot = pTree.GetTreeNext();
			if ( pTree.m_pTreeNext )
				pTree.m_pTreeNext.m_pTreePrev = pTree.m_pTreePrev;
			if ( pTree.m_pTreePrev )
				pTree.m_pTreePrev.m_pTreeNext = pTree.m_pTreeNext;
			if ( pTree.m_pTreeFather )
			{
				if ( pTree.m_pTreeFather.m_pTreeChild == pTree )
					pTree.m_pTreeFather.SetTreeChild( pTree.GetTreeNext() );
				pTree.m_pTreeFather.Update();
			}
			else if ( m_pTreeRoot ) m_pTreeRoot.Update();
			if( m_pTreeRoot == null )
			{
				m_pTreeRoot = new dUITreeObj( m_pScroll.GetClient() , this );
				m_pTreeRoot.SetShow( true );
				m_pTreeRoot.SetHandleMouse( isHandleMouse() );
				m_bFirstInitTreeRoot = true;
			}
		}
		private function _DeleteTree( pTree:dUITreeObj ):void
		{
			if ( !pTree ) return;
			_DeleteTree( pTree.GetTreeChild() );
			var p:dUITreeObj = pTree;
			while ( p )
			{
				OnDeleteTreeObj( p );
				p.Release();
				p = p.GetTreeNext();
			}
		}
		public function DeleteTree( pTree:dUITreeObj ):void
		{
			if ( !pTree ) return;
			_DeleteTree( pTree.GetTreeChild() );
			RemoveTree( pTree );
			OnDeleteTreeObj( pTree );
			pTree.Release();
			pTree = null;
			if( m_pTreeRoot == null )
			{
				m_pTreeRoot = new dUITreeObj( m_pScroll.GetClient() , this );
				m_pTreeRoot.SetShow( true );
				m_pTreeRoot.SetHandleMouse( isHandleMouse() );
				m_bFirstInitTreeRoot = true;
			}
		}
		public function GetTreeRoot():dUITreeObj
		{
			return m_pTreeRoot;
		}
		public function SetToTop():void
		{
			m_pScroll.SetToTop();
		}
		public function SetToBottom():void
		{
			m_pScroll.SetToBottom();
		}
		override public function SetStyleData( name:String , bSet:Boolean ):void
		{
			if ( name == "ShowHScroll" ||
				 name == "ShowVScroll" ||
				 name == "ShowSelection" ||
				 name == "ShowSelectOver" ||
				 name == "ShowLine" ||
				 name == "AlwaysShowHScroll" ||
				 name == "AlwaysShowVScroll" ||
				 name == "VScrollMirror" ||
				 name == "HScrollMirror" ||
				 name == "FatherNoSelection" ||
				 name == "ExpandOnlyOne" ||
				 name == "ForceHideExpand" ||
				 name == "ButtonStyle" )
			{
				if ( isStyleData( name ) == bSet ) return;
				super.SetStyleData( name , bSet );
				if ( name == "ShowHScroll" || name == "ShowVScroll" || name == "AlwaysShowHScroll" || name == "AlwaysShowVScroll" ||
					 name == "VScrollMirror" || name == "HScrollMirror" )
				{
					m_pScroll.SetStyleData( name , bSet );
				}
				else if ( name == "ShowSelection" )
				{
					for ( var i:int = 0 ; i < m_vecSelectTreeObj.length ; i ++ )
						(m_vecSelectTreeObj[i] as dUITreeObj).SetShowSelect( bSet );
				}
				else if ( name == "ShowSelectOver" )
				{
					if ( !bSet )
						m_pSelectOver.SetShow( bSet );
				}
				else if ( name == "ShowLine" )
				{
					UpdateAll();
				}
				else if ( name == "ButtonStyle" )
				{
					UpdateAll( true );
				}
			}
		}
		override public function isStyleData( name:String ):Boolean
		{
			if ( name == "ShowVScroll" || name == "ShowHScroll" )
				return m_pScroll.isStyleData( name );
			return super.isStyleData( name );
		}
		private function _SetMouseStyle( pTree:dUITreeObj , nType:int ):void
		{
			while( pTree )
			{
				pTree.SetMouseStyle( nType );
				_SetMouseStyle( pTree.GetTreeChild() , nType );
				pTree = pTree.GetTreeNext();
			}
		}
		override public function SetMouseStyle( nType:int ):void
		{
			super.SetMouseStyle( nType );
			m_pScroll.SetMouseStyle( nType );
			_SetMouseStyle( m_pTreeRoot , nType );
		}
	}

}