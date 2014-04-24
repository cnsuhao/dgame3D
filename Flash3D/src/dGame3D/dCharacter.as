//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Math.dColorTransform;
	import dGame3D.Math.dMatrix;
	import dGame3D.Math.dVector2;
	import dGame3D.Math.dVector3;
	import dGame3D.Shader.dShaderBase;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author dym
	 */
	public class dCharacter extends dRenderObj
	{
		protected var m_pNameBillboard:dCharacterBillboard;
		protected var m_vecBNumber:Vector.<dCharacterBillboard> = new Vector.<dCharacterBillboard>;
		protected var m_arrMeshFile:Array = new Array();
		protected var m_arrAniKey:Array = new Array();
		protected var m_vecSkeleton:Vector.<dMeshFileSkeleton>;
		protected var m_vecSkeletonsOrder:Vector.<int> = new Vector.<int>;
		protected var m_strCurrentAni:String = new String();
		protected var m_nCurrentTime:int;
		protected var m_bPlayingDefaultKey:Boolean = false;
		protected var m_pHorse:dCharacter;
		protected var m_bShowHorse:Boolean;
		protected var m_strHorseBoneName:String;
		protected var m_strChatarctorBoneName:String;
		protected var m_vecMoveTarget:Vector.<dVector3> = new Vector.<dVector3>;
		protected var m_vMoveDir:dVector3 = new dVector3();
		protected var m_fMoveSpeed:Number = 5.0;
		protected var m_strRunAniName:String = "跑";
		protected var m_strStandAniName:String = "待机";
		protected var m_vecRenderOrder:Vector.<String> = new Vector.<String>;
		protected var m_strCharacterName:String = new String();
		protected var m_vecMyEffectList:Vector.< MyEffect > = new Vector.< MyEffect >;
		protected var m_vecMyTimer:Vector.<MyTimer> = new Vector.<MyTimer>;
		protected var m_bMoveTargetCheckCollection:Boolean = false;
		protected var m_moveEndFun:Function = null;
		protected var m_fSearchPathIgnoreLength:Number = 0.0;
		
		public function dCharacter( pDevice:dDevice ) 
		{
			super( pDevice , dGame3DSystem.RENDEROBJ_TYPE_CHARACTER );
		}
		override public function Release():void
		{
			if ( m_pNameBillboard ) m_pNameBillboard.Release();
			for ( var i:int = 0 ; i < m_vecMyEffectList.length ; i ++ )
			{
				m_pDevice.DeletePointLight( m_vecMyEffectList[i].pPointLight );
				if( m_vecMyEffectList[i].pEffect )
					m_pDevice.GetScene().DeleteRenderObj( m_vecMyEffectList[i].pEffect.id );
			}
			m_vecMyEffectList.length = 0;
		}
		override public function GetResourceList( push:Vector.<String> ):void
		{
			for ( var i:int = 0 ; i < m_vecRenderOrder.length ; i ++ )
			{
				var pMesh:PartMesh = m_arrMeshFile[ m_vecRenderOrder[i] ];
				push.push( pMesh.m_strFileName );
			}
			for each( var pKey:AniKey in m_arrAniKey )
			{
				push.push( pKey.m_strFileName );
			}
			if ( m_pHorse ) m_pHorse.GetResourceList( push );
		}
		public function AddBNumber( list:Vector.<int> , nPlayType:int ):void
		{
			var p:dCharacterBillboard = new dCharacterBillboard( m_pDevice );
			p.CreateByTexture( list , null );
			p.Play( nPlayType );
			m_vecBNumber.push( p );
		}
		protected var m_strFirstPartName:String;
		public function AddPartMesh( strPartName:String , strFileName:String ,
			strBoundingBonePartName:String = null , strBoundingBoneCharactorName:String = null , pColorTransform:dColorTransform = null ):void
		{
			super.LoadFromFile( strFileName );
			if ( strFileName == null || strFileName.length == 0 )
			{
				m_arrMeshFile[ strPartName ] = null;
			}
			else
			{
				var bHave:Boolean = false;
				for ( var i:int = 0 ; i < m_vecRenderOrder.length ; i ++ )
				{
					if ( m_vecRenderOrder[i] == strPartName )
					{
						bHave = true;
						break;
					}
				}
				if ( m_strFirstPartName == null ) m_strFirstPartName = strPartName;
				if ( !bHave ) m_vecRenderOrder.push( strPartName );
				var pMesh:PartMesh = new PartMesh();
				pMesh.m_strBoundingBonePartName = strBoundingBonePartName;
				pMesh.m_strBoundingBoneCharactorName = strBoundingBoneCharactorName;
				pMesh.m_strFileName = strFileName;
				m_arrMeshFile[ strPartName ] = pMesh;
				m_pDevice.GetResource().LoadMesh( strFileName , function( p:dMeshFile ):void
				{
					pMesh.m_pMesh = p;
					_ComputeMesh( strPartName , pMesh.m_pMesh , strBoundingBonePartName == null );
				} , true , pColorTransform );
			}
		}
		public function AddAnimationKey( strKeyName:String , strFileName:String , isCanMove:int , onLoadComplate:Function ):void
		{
			var pKey:AniKey = new AniKey( m_pDevice );
			m_arrAniKey[ strKeyName ] = pKey;
			pKey.m_strFileName = strFileName;
			pKey.bCanMove = isCanMove;
			pKey.LoadFromFile( strFileName , onLoadComplate );
		}
		public function AddAnimationKeyHorse( strKeyName:String , strFileName:String , onLoadComplate:Function ):void
		{
			if ( m_pHorse ) m_pHorse.AddAnimationKey( strKeyName , strFileName , 1 , onLoadComplate );
		}
		public function SetAnimationDeclare( strKeyName:String , nStartTime:int , nLoopStartTime:int , nLoopEndTime:int ):void
		{
			var pKey:AniKey = m_arrAniKey[ strKeyName ];
			if ( pKey )
			{
				var max:int = pKey.GetKeyMaxTime() - 1;
				if ( nStartTime > max ) nStartTime = max;
				if ( nLoopStartTime > max ) nLoopStartTime = max;
				if ( nLoopEndTime > max ) nLoopEndTime = max;
				pKey.nStartTime = nStartTime;
				pKey.nLoopStartTime = nLoopStartTime;
				pKey.nLoopEndTime = nLoopEndTime;
			}
		}
		public function SetCharacterName( strName:String ):void
		{
			m_strCharacterName = strName;
			if ( m_pNameBillboard == null )
				m_pNameBillboard = new dCharacterBillboard( m_pDevice );
			m_pNameBillboard.CreateByString( m_strCharacterName );
		}
		public function GetCharacterName():String
		{
			return m_strCharacterName;
		}
		public function SetHorse( strHorseFileName:String , strHorseBoneName:String = "EQ-Horse" , strChatarctorBoneName:String = "EQ-Ride" ):void
		{
			m_pHorse = null;
			m_strHorseBoneName = strHorseBoneName;
			m_strChatarctorBoneName = strChatarctorBoneName;
			if ( strHorseFileName && strHorseFileName.length )
			{
				m_pHorse = new dCharacter( m_pDevice );
				m_pHorse.AddPartMesh( "body" , strHorseFileName );
				m_pHorse.SetNoDelete( GetNoDelete() );
			}
		}
		public function ShowHorse( bShow:Boolean ):void
		{
			m_bShowHorse = bShow;
		}
		public function SetCurrentKey( strKeyName:String ):void
		{
			var pKey:AniKey = m_arrAniKey[ strKeyName ] as AniKey;
			if ( pKey )
			{
				if ( m_strCurrentAni != strKeyName )
				{
					m_nCurrentTime = pKey.nStartTime;
					m_bPlayingDefaultKey = false;
					m_strCurrentAni = strKeyName;
					if ( m_pHorse && m_pHorse.m_arrAniKey[ strKeyName ] != null )
					{
						m_pHorse.SetCurrentKey( strKeyName );
						ShowHorse( true );
					}
					else
						ShowHorse( false );
				}
				else
				{
					var nRange:int = pKey.GetKeyMaxTime() - pKey.nStartTime;
					if ( nRange == 0 ) m_nCurrentTime = pKey.nStartTime;
					else
						m_nCurrentTime = (m_nCurrentTime % nRange) + pKey.nStartTime;
				}
			}
		}
		public function GetCurrentKey():String
		{
			return m_strCurrentAni;
		}
		public function GetKeyMaxTime( strAniName:String ):int
		{
			if ( m_arrAniKey[ strAniName ] )
				return (m_arrAniKey[ strAniName ] as AniKey).GetKeyMaxTime();
			return 0;
		}
		public function CharacterSetRunAniName( strRunAniName:String , strStandAniName:String ):void
		{
			m_strRunAniName = strRunAniName;
			m_strStandAniName = strStandAniName;
		}
		private function _OrderSkeleton( no_skeleton:int , tmp:Vector.<int> ):void
		{
			m_vecSkeletonsOrder[ tmp[0] ] = no_skeleton;
			tmp[0] ++;
			for( var i:int = 0 ; i < m_vecSkeleton[ no_skeleton ].m_vecChildId.length ; i ++ )
				_OrderSkeleton( m_vecSkeleton[ no_skeleton ].m_vecChildId[i] , tmp );
		}
		private function _ComputeMesh( strPartName:String , pNewMesh:dMeshFile , bMergeBoundingBox:Boolean ):void
		{
			if ( pNewMesh && m_vecSkeleton == null && strPartName == m_strFirstPartName )
			{
				m_vecSkeleton = pNewMesh.GetSkeleton();
				if ( m_vecSkeleton )
				{
					m_vecSkeletonsOrder.length = m_vecSkeleton.length;
					var tmp:Vector.<int> = new Vector.<int>;
					tmp[0] = 0;
					for( var i:int = 0 ; i < m_vecSkeleton.length ; i ++ )
						if( m_vecSkeleton[i].m_nParentId == -1 )
							_OrderSkeleton( i , tmp );
				}
				m_vBoundingBox = pNewMesh.GetBoundingBox();
			}
			else if ( bMergeBoundingBox )
				m_vBoundingBox.Merge( pNewMesh.GetBoundingBox() );
			SetBoundingBox( m_vBoundingBox );
		}
		protected function _GetCurrentKeyAnimation():AniKey
		{
			return m_arrAniKey[ m_strCurrentAni ];
		}
		protected function GetSkeletonMatrixByName( strBoneName:String ):dMatrix
		{
			/*for ( var i:int = 0 ; i < m_vecSkeleton.length ; i ++ )
			{
				if ( m_vecSkeleton[i].name == strBoneName )
					return m_vecSkeleton[i].matWorldZeroTime;
			}
			return dMatrix.IDENTITY();*/
			var pCurKey:AniKey = _GetCurrentKeyAnimation();
			var frame:int = m_nCurrentTime / 33;
			var nOrder:int = GetSkeletonOrderByName( strBoneName );
			var vecMatrix:Vector.<dMatrix> = pCurKey.GetSkeletonWorldMatrix( frame );
			if ( !vecMatrix )
			{
				ComputeAniMatrix( frame );
				vecMatrix = pCurKey.GetSkeletonWorldMatrix( frame );
			}
			if ( vecMatrix && nOrder >= 0 && nOrder < vecMatrix.length )
				return vecMatrix[ nOrder ];
			return dMatrix.IDENTITY();
		}
		protected function GetSkeletonWorldInverseMatrix( strBoneName:String ):dMatrix
		{
			for ( var i:int = 0 ; i < m_vecSkeleton.length ; i ++ )
			{
				if ( m_vecSkeleton[i].name == strBoneName )
					return m_vecSkeleton[i].matInverse;
			}
			return dMatrix.IDENTITY();
		}
		protected function GetSkeletonOrderByName( strBoneName:String ):int
		{
			for ( var i:int = 0 ; i < m_vecSkeleton.length ; i ++ )
			{
				if ( m_vecSkeleton[i].name == strBoneName )
					return m_vecSkeletonsOrder[i];
			}
			return 0;
		}
		public function isRunning():Boolean
		{
			if ( m_vecMoveTarget.length )
			{
				var vPos:dVector3 = GetPos();
				var vTarget:dVector3 = m_vecMoveTarget[0];
				if ( vPos.x != vTarget.x || vPos.z != vTarget.z )
					return true;
			}
			return false;
		}
		override public function OnFrameMove():void
		{
			if ( m_pHorse ) m_pHorse.OnFrameMove();
			if ( m_strCurrentAni == "" ) SetCurrentKey( m_strStandAniName );
			var tick:int = m_pDevice.GetTick();
			m_nCurrentTime += tick;
			var pKey:AniKey = _GetCurrentKeyAnimation();
			if ( pKey )
			{
				var maxTime:int = pKey.GetKeyMaxTime();
				if ( m_nCurrentTime > maxTime || m_nCurrentTime >= pKey.nLoopEndTime && pKey.nLoopEndTime != 0 )
				{
					
					//if ( m_vecMoveTarget.length == 0 )
					{
						if( pKey.nLoopStartTime == 0 && pKey.nLoopEndTime == 0 )
							SetCurrentKey( m_strStandAniName );
						else
							m_nCurrentTime = pKey.nLoopStartTime;
					}
				}
				if ( pKey.bCanMove )
				{
					var fSpeed:Number = m_fMoveSpeed * tick / 1000;
					if ( fSpeed > 1.0 ) fSpeed = 1.0;
					if ( m_vecMoveTarget.length )
					{
						var vPos:dVector3 = GetPos();
						var vTarget:dVector3 = m_vecMoveTarget[0];
						if ( vPos.x != vTarget.x || vPos.z != vTarget.z )
						{
							var vDir:dVector3 = vTarget.Sub( GetPos() );
							vDir.y = 0.0;
							if ( fSpeed > 1 ) fSpeed = 1;
							var bInIgnore:Boolean = false;
							if ( m_fSearchPathIgnoreLength != 0.0 )
							{
								var vTargetEnd:dVector3 = m_vecMoveTarget[ m_vecMoveTarget.length - 1 ];
								bInIgnore = Math.sqrt( (vPos.x - vTargetEnd.x) * (vPos.x - vTargetEnd.x) +
									(vPos.z - vTargetEnd.z) * (vPos.z - vTargetEnd.z) ) < m_fSearchPathIgnoreLength;
							}
							if ( vDir.Length() < fSpeed || bInIgnore )
							{
								m_vecMoveTarget.splice( 0 , 1 );
								{
									vTarget.y = m_pDevice.GetScene().GetHeight( vTarget.x , vTarget.z );
									if ( !bInIgnore && ( !m_bMoveTargetCheckCollection ||
										m_bMoveTargetCheckCollection && m_pDevice.GetScene().GetCanReach( vTarget.x , vTarget.z ) == 0 ) )
										SetPos( vTarget );
									if ( m_vecMoveTarget.length == 0 )
										SetCurrentKey( m_strStandAniName );
								}
							}
							else
							{
								vDir.Normalize();
								for ( i = 0 ; i < 3 ; i ++ )
								{
									vPos = GetPos();
									if ( i == 0 )
									{
										vPos.x += vDir.x * fSpeed ;
										vPos.z += vDir.z * fSpeed ;
									}
									else if ( i == 1 )
									{
										if ( Math.abs( vDir.x ) >= Math.abs( vDir.z ) )
										{
											if( vDir.x != 0.0 )
												vPos.x += vDir.x / Math.abs( vDir.x ) * fSpeed;
										}
										else
										{
											if ( vDir.z != 0.0 )
												vPos.z += vDir.z / Math.abs( vDir.z ) * fSpeed;
										}
									}
									else
									{
										if ( Math.abs( vDir.x ) < Math.abs( vDir.z ) )
										{
											if( vDir.x != 0.0 )
												vPos.x += vDir.x / Math.abs( vDir.x ) * fSpeed;
										}
										else
										{
											if ( vDir.z != 0.0 )
												vPos.z += vDir.z / Math.abs( vDir.z ) * fSpeed;
										}
									}
									if ( !m_bMoveTargetCheckCollection ||
										 m_bMoveTargetCheckCollection && m_pDevice.GetScene().GetCanReach( vPos.x , vPos.z ) == 0 )
									{
										vPos.y = m_pDevice.GetScene().GetHeight( vPos.x , vPos.z );
										SetPos( vPos );
										break;
									}
								}
								SetDir2( vDir.x , vDir.z );
								SetCurrentKey( m_strRunAniName );
							}
						}
						else m_vecMoveTarget.splice( 0 , 1 );
						if ( m_vecMoveTarget.length == 0 && m_moveEndFun != null )
							m_moveEndFun( 1 );
					}
					else if ( m_vMoveDir.x != 0.0 || m_vMoveDir.z != 0.0 )
					{
						for ( i = 0 ; i < 3 ; i ++ )
						{
							vPos = GetPos();
							vDir = m_vMoveDir;
							if ( i == 0 )
							{
								vPos.x += vDir.x * fSpeed ;
								vPos.z += vDir.z * fSpeed ;
							}
							else if ( i == 1 )
							{
								if ( Math.abs( vDir.x ) >= Math.abs( vDir.z ) )
								{
									if( vDir.x != 0.0 )
										vPos.x += vDir.x / Math.abs( vDir.x ) * fSpeed;
								}
								else
								{
									if ( vDir.z != 0.0 )
										vPos.z += vDir.z / Math.abs( vDir.z ) * fSpeed;
								}
							}
							else
							{
								if ( Math.abs( vDir.x ) < Math.abs( vDir.z ) )
								{
									if( vDir.x != 0.0 )
										vPos.x += vDir.x / Math.abs( vDir.x ) * fSpeed;
								}
								else
								{
									if ( vDir.z != 0.0 )
										vPos.z += vDir.z / Math.abs( vDir.z ) * fSpeed;
								}
							}
							var nCanReach:int = m_pDevice.GetScene().GetCanReach( vPos.x , vPos.z );
							if ( nCanReach == 0 )
							{
								vPos.y = m_pDevice.GetScene().GetHeight( vPos.x , vPos.z );
								SetPos( vPos );
								break;
							}
						}
						SetDir2( m_vMoveDir.x , m_vMoveDir.z );
						SetCurrentKey( m_strRunAniName );
					}
				}
			}
			for ( var i:int = 0 ; i < m_vecBNumber.length ; i ++ )
			{
				if ( m_vecBNumber[i].OnFrameMove() )
				{
					m_vecBNumber[i].Release();
					m_vecBNumber.splice( i , 1 );
					i--;
				}
			}
			for ( i = 0 ; i < m_vecMyTimer.length ; i ++ )
			{
				m_vecMyTimer[i].m_nDelay -= tick;
				if ( m_vecMyTimer[i].m_nDelay <= 0 )
				{
					m_vecMyTimer[i].m_pCallFun();
					m_vecMyTimer.splice( i , 1 );
					i--;
				}
			}
			if ( m_vecMyEffectList.length )
			{
				var vMyBody:dVector3 = GetAABB().GetCenter();
				for ( i = 0 ; i < m_vecMyEffectList.length ; i ++ )
				{
					if ( m_vecMyEffectList[i].pEffect )
					{
						vPos = m_vecMyEffectList[i].pEffect.GetPos();
						var fFlySpeed:Number = m_vecMyEffectList[i].fFlySpeed * tick / 1000.0;
						if ( vPos.LengthOther( vMyBody ) < fFlySpeed )
						{
							if ( m_vecMyEffectList[i].strHitEffect && m_vecMyEffectList[i].strHitEffect.length )
							{
								if ( m_vecMyEffectList[i].strHitEffect.toLowerCase().indexOf( ".dg3e" ) != -1 )
								{
									var pHit:dRenderObj = m_pDevice.GetScene().CreateEffectObjFromFile( m_vecMyEffectList[i].strHitEffect , true );
									pHit.SetPos( vMyBody );
								}
							}
							m_pDevice.DeletePointLight( m_vecMyEffectList[i].pPointLight );
							m_pDevice.GetScene().DeleteRenderObj( m_vecMyEffectList[i].pEffect.id );
							m_vecMyEffectList.splice( i , 1 );
							i--;
						}
						else
						{
							vDir = vMyBody.Sub( vPos );
							vDir.Normalize();
							m_vecMyEffectList[i].pEffect.SetDir2( vDir.x , vDir.z );
							vDir.MulAppend( fFlySpeed );
							vPos.AddAppend( vDir );
							m_vecMyEffectList[i].pEffect.SetPos( vPos );
							if ( m_vecMyEffectList[i].pPointLight )
							{
								m_vecMyEffectList[i].pPointLight.vColor.Set( 0 , 0 , 5 );
								m_vecMyEffectList[i].pPointLight.vPos.Copy( vPos );
							}
						}
					}
					else
					{
						if ( m_vecMyEffectList[i].strHitEffect && m_vecMyEffectList[i].strHitEffect.length )
						{
							if ( m_vecMyEffectList[i].strHitEffect.toLowerCase().indexOf( ".dg3e" ) != -1 )
							{
								pHit = m_pDevice.GetScene().CreateEffectObjFromFile( m_vecMyEffectList[i].strHitEffect , true );
								pHit.SetPos( vMyBody );
							}
						}
						m_pDevice.DeletePointLight( m_vecMyEffectList[i].pPointLight );
						m_vecMyEffectList.splice( i , 1 );
						i--;
					}
				}
			}
		}
		public function MoveDir( vDir:dVector3 ):void
		{
			if ( vDir == null )
			{
				m_vMoveDir.x = 0.0;
				m_vMoveDir.z = 0.0;
				if( m_vecMoveTarget.length == 0 )
					StopMove();
			}
			else
			{
				m_vecMoveTarget.length = 0;
				m_vMoveDir.x = vDir.x;
				m_vMoveDir.z = vDir.z;
				m_vMoveDir.Normalize();
			}
		}
		public function MoveTarget( vTargetPos:dVector3 , bSearchPath:Boolean = false , bCheckCollection:Boolean = false , moveEndFun:Function = null , fIgnoreLength:Number = 0.0 ):int
		{
			var nRet:int = 1;
			m_bMoveTargetCheckCollection = bCheckCollection;
			if ( !bSearchPath )
			{
				if( !isRunning() )
					StopMove();
				else
				{
					m_vecMoveTarget.length = 0;
					m_vMoveDir.x = 0.0;
					m_vMoveDir.z = 0.0;
				}
				var p:dVector3 = new dVector3( vTargetPos.x , 0.0 , vTargetPos.z );
				m_vecMoveTarget.push( p );
			}
			else
			{
				var ret:Array = m_pDevice.GetScene().SearchPath( GetPos().x , GetPos().z , vTargetPos.x , vTargetPos.z );
				if( !isRunning() )
					StopMove();
				else
				{
					m_vecMoveTarget.length = 0;
					m_vMoveDir.x = 0.0;
					m_vMoveDir.z = 0.0;
				}
				if ( ret && ret.length )
				{
					for ( var i:int = 0 ; i < ret.length - 1 ; i ++ )
					{
						p = new dVector3( ret[i].x , 0.0 , ret[i].y );
						m_vecMoveTarget.push( p );
					}
					p = new dVector3( vTargetPos.x , 0.0 , vTargetPos.z );
					m_vecMoveTarget.push( p );
				}
				else
				{
					if ( moveEndFun != null ) moveEndFun( 0 );
					nRet = 0;
				}
			}
			m_moveEndFun = moveEndFun;
			m_fSearchPathIgnoreLength = fIgnoreLength;
			return nRet;
		}
		public function StopMove():void
		{
			m_moveEndFun = null;
			m_fSearchPathIgnoreLength = 0.0;
			m_vecMoveTarget.length = 0;
			m_vMoveDir.x = 0.0;
			m_vMoveDir.z = 0.0;
			if ( GetCurrentKey() == m_strRunAniName )
				SetCurrentKey( m_strStandAniName );
		}
		public function SetMoveSpeed( fSpeed:Number ):void
		{
			m_fMoveSpeed = fSpeed;
		}
		public function GetMoveSpeed():Number
		{
			return m_fMoveSpeed;
		}
		override public function Render( shader:dShaderBase ):int
		{
			var pCurKey:AniKey = _GetCurrentKeyAnimation();
			var r:int = 0;
			if ( !pCurKey )
			{
				shader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_WORLD , GetWorldMatrix() );
				var vecSkeleton:Vector.<dMatrix> = new Vector.<dMatrix>;
				vecSkeleton.length = 128;
				for ( var i:int = 0 ; i < vecSkeleton.length ; i ++ )
					vecSkeleton[i] = dMatrix.IDENTITY();
				for ( i = 0 ; i < m_vecRenderOrder.length ; i ++ )
				{
					var pMesh:PartMesh = m_arrMeshFile[ m_vecRenderOrder[i] ];
					if ( pMesh && pMesh.m_pMesh )
					{
						r += pMesh.m_pMesh.Render( vecSkeleton , shader );
					}
				}
				return r;
			}
			if ( !m_vecSkeleton ) return 0;
			var matWorld:dMatrix = GetWorldMatrix();
			var frame:int = m_nCurrentTime / 33;
			if ( m_pHorse && m_bShowHorse )
			{
				m_pHorse.SetPos( GetPos() );
				m_pHorse.SetRot( GetRot() );
				m_pHorse.SetSca( GetSca() );
				var pHorseCurKey:AniKey = m_pHorse._GetCurrentKeyAnimation();
				if ( pHorseCurKey )
				{
					var matHorse:dMatrix = m_pHorse.GetSkeletonMatrixByName( m_strHorseBoneName );
					//var matHorse:dMatrix = m_pHorse.GetSkeletonWorldInverseMatrix( m_strHorseBoneName );
					//matHorse.Inverse();
					var matBody:dMatrix = new dMatrix( GetSkeletonMatrixByName( m_strChatarctorBoneName ) );
					matBody.Inverse();
					matWorld = matBody.Mul( matHorse ).Mul( matWorld );
					/*m_matWorld = new dMatrix( matWorld );
					matWorld._41 += matBody._41 + matHorse._41;
					matWorld._42 += matBody._42 + matHorse._42;
					matWorld._43 += matBody._43 + matHorse._43;*/
				}
			}
			shader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_WORLD , matWorld );
			var vecResult:Vector.<dMatrix> = pCurKey.GetSkeletonResult( frame );
			if( !vecResult )
				vecResult = ComputeAniMatrix( frame );
			if ( !vecResult ) return 0;
			
			//for each( var pMesh:PartMesh in m_arrMeshFile )
			for ( i = 0 ; i < m_vecRenderOrder.length ; i ++ )
			{
				pMesh = m_arrMeshFile[ m_vecRenderOrder[i] ];
				if ( pMesh && pMesh.m_pMesh )
				{
					if ( pMesh.m_strBoundingBonePartName && pMesh.m_strBoundingBoneCharactorName )
					{
						matHorse = pMesh.m_pMesh.GetSkeletonInverseMatrixByName( pMesh.m_strBoundingBonePartName );
						//matBody = GetSkeletonMatrixByName( pMesh.m_strBoundingBoneCharactorName );
						matBody = pCurKey.GetSkeletonWorldMatrix( frame )[ GetSkeletonOrderByName( pMesh.m_strBoundingBoneCharactorName ) ];
						shader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_WORLD , matHorse.Mul( matBody ).Mul( matWorld ) );
						var nCull:int = m_pDevice.GetCulling();
						m_pDevice.SetCulling( 0 );
						r += pMesh.m_pMesh.Render( vecResult , shader );
						m_pDevice.SetCulling( nCull );
						shader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_WORLD , matWorld );
					}
					else
						r += pMesh.m_pMesh.Render( vecResult , shader );
				}
			}
			if( m_pHorse && m_bShowHorse )
				r += m_pHorse.Render( shader );
			return r;
		}
		protected function ComputeAniMatrix( frame:int ):Vector.<dMatrix>
		{
			var pCurKey:AniKey = _GetCurrentKeyAnimation();
			if ( pCurKey && m_vecSkeleton )
			{
				var vecSkeletonResult:Vector.<dMatrix> = new Vector.<dMatrix>;
				var vecSkeletonWorld:Vector.<dMatrix> = new Vector.<dMatrix>;
				vecSkeletonResult.length = m_vecSkeleton.length;
				vecSkeletonWorld.length = m_vecSkeleton.length;
				for ( var i:int = 0 ; i < vecSkeletonResult.length ; i ++ )
				{
					vecSkeletonResult[i] = new dMatrix();
					vecSkeletonWorld[i] = new dMatrix();
				}
				for ( i = 0 ; i < m_vecSkeleton.length ; i ++ )
				{
					var order:int = m_vecSkeletonsOrder[i];
					vecSkeletonWorld[order] = pCurKey.GetSkeletonFrameMatrix( pCurKey.GetSkeletonId( m_vecSkeleton[order].name ) , frame );
					if ( !vecSkeletonWorld[order] ) return null;
					var parentNo:int = m_vecSkeleton[order].m_nParentId;
					if( parentNo != -1 )
						vecSkeletonWorld[order] = vecSkeletonWorld[order].Mul( vecSkeletonWorld[parentNo] );
					vecSkeletonResult[order] = m_vecSkeleton[order].matInverse.Mul( vecSkeletonWorld[order] );
				}
				pCurKey.SetSkeletonResult( frame , vecSkeletonResult );
				pCurKey.SetSkeletonWorldMatrix( frame , vecSkeletonWorld );
				return vecSkeletonResult;
			}
			return null;
		}
		public function GetBonePostation( strBoneName:String ):dVector3
		{
			var pCurKey:AniKey = _GetCurrentKeyAnimation();
			if ( pCurKey )
			{
				var frame:int = m_nCurrentTime / 33;
				var list:Vector.<dMatrix> = pCurKey.GetSkeletonWorldMatrix( frame );
				if ( !list ) ComputeAniMatrix( frame );
				list = pCurKey.GetSkeletonWorldMatrix( frame );
				if ( !list ) return GetPos();
				var mat:dMatrix = list[ GetSkeletonOrderByName( strBoneName ) ];
				var r:dVector3 = new dVector3( mat._41 , mat._42 , mat._43 );
				//r.Transform( mat );
				r.AddAppend( m_vPos );
				return r;
			}
			return GetPos();
		}
		public function RenderBillboard( shader:dShaderBase ):void
		{
			m_pDevice.SetBlendFactor( 0 );
			var mat:dMatrix = new dMatrix();
			mat.Translation( m_vPos.x , m_vPos.y , m_vPos.z );
			mat._42 += GetBoundingBox().y2 * GetSca().y + 0.2;
			if ( m_pNameBillboard ) m_pNameBillboard.Render( mat , shader );
			for ( var i:int = 0 ; i < m_vecBNumber.length ; i ++ )
			{
				m_vecBNumber[i].Render( mat , shader );
			}
		}
		public function AddMyEffect( strEffectName:String , strHitEffectName:String , vStartPos:dVector3 , nBoneHero:int , strStartBoneName:String , nStartTime:int = 0 , fFlySpeed:Number = 10.0 ):void
		{
			m_vecMyTimer.push( new MyTimer( nStartTime , function():void
			{
				var myEffect:MyEffect = new MyEffect();
				myEffect.strHitEffect = strHitEffectName;
				if( strEffectName.toLowerCase().indexOf( ".dg3e" ) != -1 )
					myEffect.pEffect = m_pDevice.GetScene().CreateEffectObjFromFile( strEffectName );
				var vBonePos:dVector3 = new dVector3();
				if ( nBoneHero != -1 && strStartBoneName && strStartBoneName.length )
				{
					var pHero:dCharacter = m_pDevice.GetScene().FindRenderObj( nBoneHero ) as dCharacter;
					if ( pHero ) vBonePos.Copy( pHero.GetBonePostation( strStartBoneName ) );
				}
				if ( myEffect.pEffect )
				{
					if( vStartPos )
						myEffect.pEffect.SetPos( vStartPos.Add( vBonePos ) );
					else
						myEffect.pEffect.SetPos( vBonePos );
				}
				myEffect.fFlySpeed = fFlySpeed;
				myEffect.pPointLight = m_pDevice.CreatePointLight();
				m_vecMyEffectList.push( myEffect );
			} ) );
		}
		override public function SetPos( vPos:dVector3 ):void
		{
			vPos.y = m_pDevice.GetScene().GetHeight( vPos.x , vPos.z ) + GetYOffset();
			super.SetPos( vPos );
		}
		override public function SetNoDelete( bNoDelete:Boolean ):void
		{
			super.SetNoDelete( bNoDelete );
			if ( m_pHorse ) m_pHorse.SetNoDelete( bNoDelete );
		}
	}

}
import dGame3D.dMeshFile;
import dGame3D.dRenderObj;
import dGame3D.dDevice;
import dGame3D.dMeshAnimation;
import dGame3D.dPointLight;
class PartMesh
{
	public var m_strBoundingBonePartName:String;
	public var m_strBoundingBoneCharactorName:String;
	public var m_strFileName:String;
	public var m_pMesh:dMeshFile;
	public function PartMesh():void
	{
	}
}
class AniKey extends dMeshAnimation
{
	public var bCanMove:int;
	public var m_strFileName:String;
	public var nStartTime:int;
	public var nLoopStartTime:int;
	public var nLoopEndTime:int;
	public function AniKey( pDevice:dDevice ) 
	{
		super( pDevice );
	}
}
class MyEffect
{
	public var pEffect:dRenderObj;
	public var strHitEffect:String;
	public var fFlySpeed:Number;
	public var pPointLight:dPointLight;
}
class MyTimer
{
	public var m_nDelay:int;
	public var m_pCallFun:Function;
	public function MyTimer( delay:int , callFun:Function ):void
	{
		m_nDelay = delay;
		m_pCallFun = callFun;
	}
}