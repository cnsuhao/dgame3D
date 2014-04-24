//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dcom.dVector;
	import dGame3D.Math.dBoundingBox;
	import dGame3D.Math.dColorTransform;
	import dGame3D.Math.dMatrix;
	import dGame3D.Math.dVector2;
	import dGame3D.Math.dVector3;
	import dGame3D.Math.dVector4;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author dym
	 */
	public class dGame3DSystem
	{
		protected var m_pDevice:dDevice;
		protected var m_pCamera:dCamera;
		protected var m_pScene:dScene;
		public static const TERRAIN_BITMAP_TEX1:int = 0;
		public static const TERRAIN_BITMAP_TEX2:int = 1;
		public static const TERRAIN_BITMAP_TEX3:int = 2;
		public static const TERRAIN_BITMAP_TEX4:int = 3;
		public static const TERRAIN_BITMAP_BLEND:int = 4;
		public static const TERRAIN_BITMAP_HEIGHTMAP:int = 5;
		public static const TERRAIN_BITMAP_CANREACH:int = 6;
		public static const TERRAIN_BITMAP_SHADOW:int = 7;
		public static const TERRAIN_BITMAP_GRASS:int = 8;
		public static const SCENE_UPDATE_ALL:int = 0x7FFFFFFF;
		public static const SCENE_UPDATE_HEIGHTMAP:int = 1;
		public static const SCENE_UPDATE_BLENDTEX:int = 2;
		public static const SCENE_UPDATE_CANREACH:int = 4;
		public static const SCENE_UPDATE_RENDEROBJ:int = 8;
		public static const SCENE_UPDATE_OCEAN:int = 16;
		public static const SCENE_UPDATE_GRASS:int = 32;
		public static const RENDEROBJ_TYPE_ALL:int = 0x7FFFFFFF;
		public static const RENDEROBJ_TYPE_MESH:int = 1;
		public static const RENDEROBJ_TYPE_CHARACTER:int = 2;
		public static const RENDEROBJ_TYPE_EFFECT:int = 4;
		public static const RENDEROBJ_TYPE_TILE:int = 8;
		public static const RENDEROBJ_TYPE_OCEAN:int = 16;
		//public static const RENDEROBJ_TYPE_CHARACTER_STATIC:int = 32;
		public static const PRESENT_FLAG_RENDER_SHADOW:int = 1;
		public static const PRESENT_FLAG_RENDER_CANREACH:int = 2;
		public static const SHADER_WORLD:int = 1;
		public static const SHADER_VIEW:int = 2;
		public static const SHADER_PROJ:int = 3;
		public static const SHADER_LIGHT:int = 4;
		public static const SHADER_UVDATA:int = 5;
		public static const SHADER_SKELETON:int = 6;
		public static const SHADER_BRIGHT:int = 7;
		public static const SHADER_LERP:int = 8;
		public static const SHADER_ALPHATEST:int = 9;
		public static const LOADSCENE_WITH_MONSTER:int = 1;
		
		public static const BNUMBER_PLAY_NONE:int = 0;
		public static const BNUNBER_PLAY_JUMP:int = 1;
		public static const BNUMBER_PLAY_FLY:int = 2;
		protected var m_mapKey:Array = new Array();
		public function dGame3DSystem( pContext3D:Object , flag:int = 0 ) 
		{
			m_pDevice = new dDevice( pContext3D as Context3D );
			m_pCamera = m_pDevice.GetCamera();
			m_pScene = new dScene( m_pDevice );
			m_pDevice.m_pScene = m_pScene;
			m_pDevice.SetBlendFactor( 0 );
			m_pStage.addEventListener( KeyboardEvent.KEY_DOWN , function( e:KeyboardEvent ):void
			{
				m_mapKey[ e.keyCode ] = true;
			} );
			m_pStage.addEventListener( KeyboardEvent.KEY_UP , function( e:KeyboardEvent ):void
			{
				m_mapKey[ e.keyCode ] = false;
			} );
			m_pStage.addEventListener( Event.DEACTIVATE , function( e:Event ):void
			{
				ClearKeyState();
			} );
		}
		// 按键是否按下
		public function isKeyDown( keyCode:int ):Boolean
		{
			if ( m_pStage.focus != null && m_pStage.focus != m_pStage )
				ClearKeyState();
			return m_mapKey[ keyCode ];
		}
		// 清除按键
		public function ClearKeyState():void
		{
			for ( var key:String in m_mapKey )
			{
				m_mapKey[key] = false;
			}
		}
		static private var m_pContext3D:Context3D;
		static private var m_pStage:Stage;
		// 创建Context3D
		static public function CreateContext3D( stage:Stage , onCreateOK:Function ):void
		{
			m_pStage = stage;
			if ( m_pContext3D ) onCreateOK( m_pContext3D );
			else
			{
				var pStage3D:Stage3D = stage.stage3Ds[0];
				pStage3D.addEventListener(Event.CONTEXT3D_CREATE, function( event:Event ):void
				{
					m_pContext3D = pStage3D.context3D;
					m_pContext3D.configureBackBuffer(stage.stageWidth,stage.stageHeight,0,true);
					onCreateOK( m_pContext3D );
				});
				pStage3D.requestContext3D(Context3DRenderMode.AUTO);
			}
		}
		//--------------------------------------------------------------
		// 场景相关
		// 创建场景
		public function CreateScene( width:int , height:int ):void
		{
			ClearKeyState();
			m_pScene.CreateScene( width , height );
		}
		// 保存场景
		public function SaveScene():ByteArray
		{
			return m_pScene.SaveScene();
		}
		// 读取场景
		public function LoadSceneFromBin( data:ByteArray , onLoadComplate:Function , nFlag:int = 0 ):void
		{
			ClearKeyState();
			m_pScene.LoadFromBin( data , onLoadComplate , true , nFlag );
		}
		// 从文件中读取场景
		public function LoadSceneFromFile( strFileName:String , onLoadComplate:Function , nFlag:int = 0 , onLoadProgress:Function = null ):void
		{
			ClearKeyState();
			m_pScene.LoadFromFile( strFileName , onLoadComplate , nFlag , onLoadProgress );
		}
		// 获得场景文件名
		public function GetSceneFileName():String
		{
			return m_pScene.GetSceneFileName();
		}
		// 设置天空盒贴图文件
		public function SetSkyboxTextureFileName( strFileName:String ):void
		{
			m_pScene.SetSkyboxTextureFileName( strFileName );
		}
		// 更新场景
		public function UpdateScene( nFlag:int = 0 ):void
		{
			m_pScene.UpdateScene( nFlag );
		}
		// 设置场景是否有碰撞
		public function SetShowCanReach( bShow:Boolean ):void
		{
			if ( m_pScene )
				m_pScene.SetShowCanReach( bShow );
		}
		// 创建模型
		public function CreateMeshObj( strFileName:String ):int
		{
			var p:dRenderObj = m_pScene.CreateMeshObjFromFile( strFileName );
			return p.id;
		}
		// 创建特效
		public function CreateEffectObj( strFileName:String , bPlayEndAutoDelete:Boolean = false ):int
		{
			var p:dRenderObj = m_pScene.CreateEffectObjFromFile( strFileName , bPlayEndAutoDelete );
			return p.id;
		}
		// 创建人物
		public function CreateCharacter( strFileName:String = null , pColorTransform:dColorTransform = null ):int
		{
			var p:dRenderObj = m_pScene.CreateCharacter( strFileName , pColorTransform );
			return p.id;
		}
		// 创建水面
		public function CreateOcean( vPos:dVector3 ):int
		{
			var p:dRenderObj = m_pScene.CreateOcean( vPos );
			return p.id;
		}
		// 考贝创建
		public function CreateObjCopy( id:int ):int
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) return m_pScene.CreateObjCopy( p ).id;
			return -1;
		}
		// 删除物体
		public function DeleteRenderObj( id:int ):void
		{
			m_pScene.DeleteRenderObj( id );
		}
		// 设置物体是否显示
		public function SetObjShow( id:int , bShow:int ):void
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) p.SetShow( Boolean( bShow ) );
		}
		// 获得物体是否显示
		public function GetObjShow( id:int ):int
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) return int( p.isShow() );
			return 0;
		}
		// 设置物体坐标
		public function SetObjPos( id:int , vPos:dVector3 ):void
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) p.SetPos( vPos );
		}
		// 获得物体坐标
		public function GetObjPos( id:int ):dVector3
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) return p.GetPos();
			return new dVector3();
		}
		// 设置物体高度偏移
		public function SetObjYOffset( id:int , fY:Number ):void
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) p.SetYOffset( fY );
		}
		// 获得物体高度偏移
		public function GetObjYOffset( id:int ):Number
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) return p.GetYOffset();
			return 0.0;
		}
		// 设置物体缩放
		public function SetObjSca( id:int , vSca:dVector3 ):void
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) p.SetSca( vSca );
		}
		// 获得物体缩放
		public function GetObjSca( id:int ):dVector3
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) return p.GetSca();
			return new dVector3( 1 , 1 , 1 );
		}
		// 设置物体旋转
		public function SetObjRot( id:int , vRot:dVector4 ):void
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) p.SetRot( vRot );
		}
		// 设置物体Y轴旋转
		public function SetObjRotY( id:int , angle:Number ):void
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) p.SetRotY( angle );
		}
		// 获得物体旋转
		public function GetObjRot( id:int ):dVector4
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) return p.GetRot();
			return new dVector4( 0 , 0 , 0 , 1 );
		}
		// 获得物体Y轴旋转
		public function GetObjRotY( id:int ):Number
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) return p.GetRotY();
			return 0.0;
		}
		// 设置物体2维方向
		public function SetObjDir2( id:int , x:Number , z:Number ):void
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) p.SetDir2( x , z );
		}
		// 获得物体2维方向
		public function GetObjDir2( id:int ):dVector2
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) return p.GetDir2();
			return new dVector2();
		}
		// 获得物体类型
		public function GetObjType( id:int ):int
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) return p.GetObjType();
			return 0;
		}
		// 获得物体文件名
		public function GetObjFileName( id:int ):String
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) return p.GetFileName();
			return "";
		}
		// 获得物体列表
		public function GetObjList( nObjType:int ):Vector.<int>
		{
			return m_pScene.GetSceneObjList( nObjType );
		}
		// 获得物体绑定盒
		public function GetObjBoundingBox( id:int ):dBoundingBox
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) return p.GetBoundingBox();
			return new dBoundingBox();
		}
		// 获得物体AABB
		public function GetObjAABB( id:int ):dBoundingBox
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) return p.GetAABB();
			return new dBoundingBox();
		}
		// 获得物体世界矩阵
		public function GetObjWorldMatrix( id:int ):dMatrix
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) return p.GetWorldMatrix();
			var r:dMatrix = new dMatrix();
			r.Identity();
			return r;
		}
		// 设置物体是否接收鼠标
		public function SetObjHandleMouse( id:int , bHandle:Boolean ):void
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) p.SetHandleMouse( bHandle );
		}
		// 获得物体是否接收鼠标
		public function GetObjHandleMouse( id:int ):Boolean
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id );
			if ( p ) return p.isHandleMouse();
			return false;
		}
		// 给定点获得场景地形高度
		public function GetSceneHeight( x:Number , z:Number ):Number
		{
			if ( !m_pScene.GetTerrain() ) return 0.0;
			return m_pScene.GetTerrain().GetHeight( x , z );
		}
		// 获得场景地形大小
		public function GetSceneSizeX():int
		{
			if ( !m_pScene.GetTerrain() ) return 0;
			return m_pScene.GetTerrain().GetSceneSizeX();
		}
		// 获得场景地形大小
		public function GetSceneSizeZ():int
		{
			if ( !m_pScene.GetTerrain() ) return 0;
			return m_pScene.GetTerrain().GetSceneSizeZ();
		}
		// 重设场景大小
		public function ResizeScene( newWidth:int , newHeight:int , onComplateFun:Function ):void
		{
			if ( m_pScene ) m_pScene.ResizeScene( newWidth , newHeight , onComplateFun );
			else if( onComplateFun != null ) onComplateFun();
		}
		// 获得全局光照
		public function GetGlobalLightDir():dVector3
		{
			var v4:dVector4 = m_pDevice.GetGlobalLightDir();
			return new dVector3( v4.x , v4.y , v4.z );
		}
		// 设置全局光照
		public function SetGlobalLightDir( vDir:dVector3 ):void
		{
			vDir.Normalize();
			m_pDevice.SetGlobalLightDir( new dVector4( vDir.x , vDir.y , vDir.z , 1.0 ) );
		}
		// 获得场景文件列表
		public function GetSceneObjFileNameList():Vector.<String>
		{
			return m_pScene.GetSceneObjFileNameList( dGame3DSystem.RENDEROBJ_TYPE_MESH | dGame3DSystem.RENDEROBJ_TYPE_EFFECT );
		}
		// 获得场景文件中物体列表
		public function GetSceneStaticCharacter():Vector.<dSceneStaticCharacter>
		{
			return m_pScene.GetSceneStaticCharacter();
		}
		// 场景与直线碰撞
		public function CheckCollectionRay( vPos:dVector3 , vDir:dVector3 , vPosOut:dVector3 = null , nObjType:int = RENDEROBJ_TYPE_ALL ):int
		{
			return m_pScene.CheckCollectionRay( vPos , vDir , vPosOut , nObjType );
		}
		// 场景与鼠标碰撞
		public function CheckCollectionMousePt( x:int , y:int , nWindowWidth:int , nWindowHeight:int , vPosOut:dVector3 = null , nObjType:int = RENDEROBJ_TYPE_ALL ):int
		{
			var vPos:dVector3 = new dVector3();
			var vDir:dVector3 = new dVector3();
			m_pDevice.GetCamera().MousePt2Dir( x , y , nWindowWidth , nWindowHeight , vPos , vDir );
			return CheckCollectionRay( vPos , vDir , vPosOut , nObjType );
		}
		// 设置是否显示地形
		public function SetShowTerrain( bShow:Boolean ):void
		{
			m_pScene.SetShowTerrain( bShow );
		}
		// 获得是否显示地形
		public function isShowTerrain():Boolean
		{
			return m_pScene.isShowTerrain();
		}
		//--------------------------------------------------------------
		// 角色相关
		// 获得当前鼠标选中的角色
		public function GetMousePassCharacterID():int
		{
			return m_pScene.GetMousePassCharacterID();
		}
		// 角色添加装备模型
		public function CharacterAddPartMesh( id:int , strPartName:String , strFileName:String ,
			strBoundingBonePartName:String = null , strBoundingBoneCharactorName:String = null , pColorTransform:dColorTransform = null ):void
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) p.AddPartMesh( strPartName , strFileName , strBoundingBonePartName , strBoundingBoneCharactorName , pColorTransform );
		}
		// 角色添加动作
		public function CharacterAddAnimationKey( id:int , strKeyName:String , strFileName:String , bCanMove:int = 1 , bAddToHorse:Boolean = false , onLoadComplate:Function = null ):void
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p )
			{
				if ( bAddToHorse )
					p.AddAnimationKeyHorse( strKeyName , strFileName , onLoadComplate );
				else
					p.AddAnimationKey( strKeyName , strFileName , bCanMove , onLoadComplate );
			}
		}
		// 设置角色动作属性
		public function CharacterSetAnimationKeyDeclare( id:int , strKeyName:String , nStartTime:int , nLoopStartTime:int , nLoopEndTime:int ):void
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p )
				p.SetAnimationDeclare( strKeyName , nStartTime , nLoopStartTime , nLoopEndTime );
		}
		// 设置物体在场景切换时不被删除
		public function SetObjNoDelete( id:int , bNoDelete:Boolean ):void
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id ) as dRenderObj;
			if ( p ) p.SetNoDelete( bNoDelete );
		}
		// 设置人物坐骑
		public function CharacterSetHorse( id:int , strHorseFileName:String , strHorseBoneName:String = "EQ-Horse" , strChatarctorBoneName:String = "EQ-Ride" ):void
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) p.SetHorse( strHorseFileName , strHorseBoneName , strChatarctorBoneName );
		}
		// 播放人物动作
		public function CharacterSetCurrentKey( id:int , strKeyName:String ):void
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) p.SetCurrentKey( strKeyName );
		}
		// 获得当前人物播放动作
		public function CharacterGetCurrentKey( id:int ):String
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) return p.GetCurrentKey();
			return "";
		}
		// 获得人物动作最大播放时间
		public function CharacterGetKeyMaxTime( id:int , strAniName:String ):int
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) return p.GetKeyMaxTime( strAniName );
			return 0;
		}
		// 设置人物移动和站立里的默认动作
		public function CharacterSetRunAniName( id:int , strRunAniName:String , strStandAniName:String ):void
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) p.CharacterSetRunAniName( strRunAniName , strStandAniName );
		}
		// 人物向给定方向移动
		public function CharacterMoveDir( id:int , vDir:dVector3 ):void
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) p.MoveDir( vDir );
		}
		// 人物向给定目标点移动
		public function CharacterMoveTarget( id:int , vTarget:dVector3 , bSearchPath:Boolean = false , bCheckCollection:Boolean = false , moveEndFun:Function = null , fIgnoreLength:Number = 0.0 ):int
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) return p.MoveTarget( vTarget , bSearchPath , bCheckCollection , moveEndFun , fIgnoreLength );
			return 0;
		}
		// 人物停止移动
		public function CharacterStopMove( id:int ):void
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) p.StopMove();
		}
		// 设置人物移动速度
		public function CharacterSetMoveSpeed( id:int , fSpeed:Number ):void
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) p.SetMoveSpeed( fSpeed );
		}
		// 获得人物移动速度
		public function CharacterGetMoveSpeed( id:int ):Number
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) return p.GetMoveSpeed();
			return 0.0;
		}
		// 获得人物是否正在移动中
		public function CharacterIsRunning( id:int ):Boolean
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) return p.isRunning();
			return false;
		}
		// 设置人物名称
		public function CharacterSetName( id:int , strName:String ):void
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) p.SetCharacterName( strName );
		}
		// 获得人物名称
		public function CharacterGetName( id:int ):String
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) return p.GetCharacterName();
			return "";
		}
		// 添加人物头上的数字
		public function CharacterAddBNumber( id:int , list:Vector.<int> , nPlayType:int = BNUNBER_PLAY_JUMP ):void
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) p.AddBNumber( list , nPlayType );
		}
		// 添加特效
		public function CharacterAddEffect( id:int , strEffectName:String , strHitEffectName:String , vStartPos:dVector3 , nBoneHero:int , strStartBoneName:String , nStartTime:int = 0 , fFlySpeed:Number = 10.0 ):void
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) p.AddMyEffect( strEffectName , strHitEffectName , vStartPos , nBoneHero , strStartBoneName , nStartTime , fFlySpeed );
		}
		// 设置人物2维方向
		public function CharacterSetObjDir2( id:int , nTargetID:int ):void
		{
			var p:dRenderObj = m_pScene.FindRenderObj( id ) as dRenderObj;
			var pTarget:dRenderObj = m_pScene.FindRenderObj( nTargetID ) as dRenderObj;
			if ( p && pTarget )
			{
				p.SetDir2( pTarget.GetPos().x - p.GetPos().x , pTarget.GetPos().z - p.GetPos().z );
			}
		}
		// 获得人物骨骼坐标
		public function CharacterGetBonePos( id:int , strBoneName:String ):dVector3
		{
			var p:dCharacter = m_pScene.FindRenderObj( id ) as dCharacter;
			if ( p ) return p.GetBonePostation( strBoneName );
			return new dVector3();
		}
		//--------------------------------------------------------------
		// 摄像机相关
		// 设置眼睛坐标
		public function SetCameraEye( vEye:dVector3 ):void
		{
			m_pCamera.SetEye( vEye );
		}
		// 设置目标点坐标
		public function SetCameraLookat( vLookat:dVector3 ):void
		{
			m_pCamera.SetLookat( vLookat );
		}
		// 设置上方向坐标
		public function SetCameraUpVec( vUpVec:dVector3 ):void
		{
			m_pCamera.SetUpVec( vUpVec );
		}
		// 获得眼睛坐标
		public function GetCameraEye():dVector3
		{
			return m_pCamera.GetEye();
		}
		// 获得目标点坐标
		public function GetCameraLookat():dVector3
		{
			return m_pCamera.GetLookat();
		}
		// 获得上方向坐标
		public function GetCameraUpVec():dVector3
		{
			return m_pCamera.GetUpVec();
		}
		// 获得摄像机方向
		public function GetCameraDir():dVector3
		{
			return m_pCamera.GetDir();
		}
		// 获得摄像机方向与上方向的叉积
		public function GetCameraCross():dVector3
		{
			return m_pCamera.GetDir().Cross( new dVector3( 0 , -1 , 0 ) );
		}
		// 设置最近裁剪面
		public function SetCameraNearPlane( fNear:Number ):void
		{
			m_pCamera.SetNearPlane( fNear );
		}
		// 设置最远裁剪面
		public function SetCameraFarPlane( fFar:Number ):void
		{
			m_pCamera.SetFarPlane( fFar );
		}
		// 获得最近裁剪面
		public function GetCameraNearPlane():Number
		{
			return m_pCamera.GetNearPlane();
		}
		// 获得最远裁剪面
		public function GetCameraFarPlane():Number
		{
			return m_pCamera.GetFarPlane();
		}
		// 设置摄像机眼睛绕目标点横向旋转角度
		public function SetCameraRotationH( angle:Number ):void
		{
			m_pCamera.SetRotationH( angle );
		}
		// 设置摄像机眼睛绕目标点纵向旋转角度
		public function SetCameraRotationV( angle:Number ):void
		{
			m_pCamera.SetRotationV( angle );
		}
		// 获得摄像机眼睛绕目标点横向旋转角度
		public function GetCameraRotationH():Number
		{
			return m_pCamera.GetRotationH();
		}
		// 获得摄像机眼睛绕目标点纵向旋转角度
		public function GetCameraRotationV():Number
		{
			return m_pCamera.GetRotationV();
		}
		// 设置摄像机眼睛与目标点的距离
		public function SetCameraRotationRadio( length:Number ):void
		{
			return m_pCamera.SetRotationRadio( length );
		}
		// 获得摄像机眼睛与目标点的距离
		public function GetCameraRotationRadio():Number
		{
			return m_pCamera.GetRotationRadio();
		}
		// 设置摄像机眼睛与目标点距离的最小,最大范围
		public function SetCameraRotationRadioLimit( fNear:Number , fFar:Number ):void
		{
			m_pCamera.SetRotationRadioLimit( fNear , fFar );
		}
		// 设置摄像机向前移动(沿目标点方向)
		public function SetCameraMoveForword( speed:Number ):void
		{
			m_pCamera.MoveForword( speed );
		}
		// 设置摄像机向后移动
		public function SetCameraMoveBack( speed:Number ):void
		{
			m_pCamera.MoveBack( speed );
		}
		// 减少摄像机眼睛与目标点的距离
		public function SetCameraMoveNear( speed:Number ):void
		{
			m_pCamera.MoveNear( speed );
		}
		// 增加摄像机眼睛与目标点的距离
		public function SetCameraMoveFar( speed:Number ):void
		{
			m_pCamera.MoveFar( speed );
		}
		// 设置摄像机向左移动,(沿目标点方向与上方向的叉积方向)
		public function SetCameraMoveLeft( speed:Number ):void
		{
			m_pCamera.MoveLeft( speed );
		}
		// 设置摄像机向右移动
		public function SetCameraMoveRight( speed:Number ):void
		{
			m_pCamera.MoveRight( speed );
		}
		// 设置摄像机目标点与眼睛的横向和纵向角度
		public function SetCameraRotationLookat( angleH:Number , angleV:Number ):void
		{
			m_pCamera.SetRotationLookat( angleH , angleV );
		}
		// 设置摄像机宽高比
		public function SetCameraAspect( f:Number ):void
		{
			m_pCamera.SetAspect( f );
		}
		// 获得摄像机视矩阵
		public function GetCameraView():dMatrix
		{
			return m_pCamera.GetView();
		}
		// 获得摄像机投影矩阵
		public function GetCameraProj():dMatrix
		{
			return m_pCamera.GetProj();
		}
		// 获得摄像机视投影相乘矩阵
		public function GetCameraViewProj():dMatrix
		{
			return m_pCamera.GetViewProj();
		}
		// 设置摄像机正交投影宽高
		public function SetCameraOrthoSize( width:Number , height:Number ):void
		{
			return m_pCamera.SetOrthoSize( width , height );
		}
		// 获得摄像机正交投影宽
		public function GetCameraOrthoWidth():Number
		{
			return m_pCamera.GetOrthoWidth();
		}
		// 获得摄像机正交投影高
		public function GetCameraOrthoHeight():Number
		{
			return m_pCamera.GetOrthoHeight();
		}
		// 设置摄像机透视类型,0为透视,1为正交
		public function SetCameraPerspectiveType( nType:int ):void
		{
			m_pCamera.SetCameraPerspectiveType( nType );
		}
		// 获得摄像机透视类型
		public function GetCameraPespectiveType():int
		{
			return m_pCamera.GetCameraPerspectiveType();
		}
		// 设置摄像机是否与地面碰撞
		public function SetCameraCollection( bColl:Boolean ):void
		{
			m_pCamera.SetCollection( bColl );
		}
		// 获得摄像机是否与地面碰撞
		public function GetCameraCollection():Boolean
		{
			return m_pCamera.isCollection();
		}
		// 设置雾效的最近最远范围
		public function SetFogRange( fNear:Number , fFar:Number ):void
		{
			m_pDevice.SetFogRange( fNear , fFar );
		}
		// 获得雾效的最近距离
		public function GetFogNear():Number
		{
			return m_pDevice.GetFogNear();
		}
		// 获得雾效的最远距离
		public function GetFogFar():Number
		{
			return m_pDevice.GetFogFar();
		}
		// 设置雾效颜色
		public function SetFogColor( vColor:dVector4 ):void
		{
			m_pDevice.SetFogColor( vColor );
		}
		// 设置雾效颜色
		public function SetFogColorUint( dwColor:uint ):void
		{
			var v:dVector4 = new dVector4( 0.0 , 0.0 , 0.0 , 1.0 );
			v.x = ((dwColor & 0x00FF0000) >> 16) / 255.0;
			v.y = ((dwColor & 0x0000FF00) >> 8 ) / 255.0;
			v.z = ((dwColor & 0x000000FF) ) / 255.0;
			SetFogColor( v );
		}
		// 获得雾效颜色
		public function GetFogColor():dVector4
		{
			return m_pDevice.GetFogColor();
		}
		// 设置是否启用雾效
		public function EnableFog( bEnable:Boolean ):void
		{
			m_pDevice.EnableFog( bEnable );
		}
		// 获得是否启用雾效
		public function isEnableFog():Boolean
		{
			return m_pDevice.isEnableFog();
		}
		// 设置窗口大小
		public function SetScreenSize( width:int , height:int ):void
		{
			m_pDevice.SetScreenSize( width , height );
			m_pCamera.SetAspect( width / height );
		}
		// 获得地形贴图
		public function GetTerrainBitmap( index:int ):BitmapData
		{
			return m_pScene.GetTerrain().GetTextureBitmap( index );
		}
		// 帧循环
		public function FrameMove( mouseX:int , mouseY:int ):void
		{
			m_pScene.OnFrameMove( mouseX , mouseY );
		}
		// 获得显示驱动名称
		public function GetDriverInfo():String
		{
			return m_pDevice.GetDevice().driverInfo;
		}
		// 清除缓存数据
		public function ClearResourceBuffer():void
		{
			m_pDevice.GetResource().ClearResourceBuffer( m_pScene.GetRenderObjListS() );
		}
		// 获得tick时间
		public function GetTick():int
		{
			return m_pDevice.GetTick();
		}
		// 是否软件渲染
		public function isSoftware():Boolean
		{
			return m_pDevice.isSoftware();
		}
		// 绘制屏幕
		public function Present( pRenderToBitmap:BitmapData = null , nFlag:int = 0 , fClearAlpha:Number = 1.0 ):int
		{
			var vFogColor:dVector4 = GetFogColor();
			m_pDevice.BeginScene();
			m_pDevice.GetDevice().clear( vFogColor.x , vFogColor.y , vFogColor.z , fClearAlpha );
			var nNumFace:int = m_pScene.Render( nFlag );
			m_pCamera.Present();
			if ( pRenderToBitmap )
			{
				m_pDevice.GetDevice().drawToBitmapData( pRenderToBitmap );
				m_pDevice.Present( false );
			}
			else
				m_pDevice.Present( true );
			if ( GetTick() > 1500 )
				ClearKeyState();
			return nNumFace;
		}
	}

}