//  Copyright (c) 2014 www.9miao.com All rights reserved.
package
{
	import dcom.dInterface;
	import dGame3D.dGame3DSystem;
	import dGame3D.Math.dVector3;
	import dGame3D.Math.dVector4;
	import dUI._dInterface;
	import flash.display.BitmapData;
	import flash.display.Stage;
	
	import dUI.dUIConfig;
	import dUI.dUIEvent;
	import dUI.dUISystem;
	
	import dcom.dBitmapData;
	import dcom.dByteArray;
	import dcom.dMap;
	import dcom.dMath;
	import dcom.dSprite;
	import dcom.dStringUtils;
	import dcom.dTimer;

	public class Game 
	{
		private var m_ui:dUISystem;
		protected var m_pdGame3D:dGame3DSystem;
		protected var m_hHero:int;
		protected var m_hView:int;
		protected var m_hModel:int;
		protected var m_pParam:Object;
		protected var m_pStage:Stage;
		public function Game( pdGame3D:dGame3DSystem , pStage:Stage ):void 
		{
			m_pdGame3D = pdGame3D;
			m_pStage = pStage;
			var pThis:Game = this;
			var pImageSetData:dByteArray = new dByteArray();
			// 载入UI的必须资源
			pImageSetData.LoadFromFile( "imageset.txt" , function( pTarget:Object ):void
			{
				// 创建ui系统
				m_ui = new dUISystem( m_pStage.stageWidth , m_pStage.stageHeight , (pTarget as dByteArray).ToStringBuffer() );
				// ui设置到舞台上
				m_ui.GetRoot().dSpriteSetFather( null , -1 );
				// 初始化游戏
				InitGame();
			} , null , null );
		}
		// 窗口大小改变
		public function OnFrameScreenResize( width:int , height:int ):void
		{
			if ( m_ui != null ) m_ui.SetSize( 0 , width , height );
			if ( m_pdGame3D != null ) m_pdGame3D.SetCameraOrthoSize( width * ( 3 / 200 ) , height * ( 3 / 200 ) );
		}
		public function InitGame():void
		{
			// 创建全屏view控件用于接收鼠标事件
			m_hView = m_ui.CreateImageBox( 0 , 0 );
			m_ui.SetAutoSizeAsFather( m_hView , 1 );
			m_ui.SetAutoPosPannel( m_hView , 1 );
			m_ui.SetHandleMouse( m_hView , 1 );
			m_ui.ImageBox_RegMouseMove( m_hView , 1 );
			m_ui.SetAutoBringTopPannel( m_hView , 1 );
			// 鼠标右键托拽事件
			m_ui.dUIEventListener( m_hView , dUISystem.GUIEVENT_TYPE_RBUTTON_DRAG , function( event:dUIEvent ):void
			{
				if ( m_pdGame3D && m_pdGame3D.GetCameraPespectiveType() == 0 )
				{
					m_pdGame3D.SetCameraRotationH( m_pdGame3D.GetCameraRotationH() - event.nParam1 / 50.0 );
					m_pdGame3D.SetCameraRotationV( m_pdGame3D.GetCameraRotationV() - event.nParam2 / 50.0 );
				}
			} );
			// 鼠标滚轮事件
			m_ui.dUIEventListener( m_hView , dUISystem.GUIEVENT_TYPE_MOUSE_WHEEL , function( event:dUIEvent ):void
			{
				if ( m_pdGame3D )
				{
					if ( m_ui.isShiftKey() )
						event.nParam1 *= 10;
					if ( m_pdGame3D.GetCameraPespectiveType() == 0 )
						m_pdGame3D.SetCameraRotationRadio( m_pdGame3D.GetCameraRotationRadio() + event.nParam1 / 3 );
					else
						m_pdGame3D.SetCameraOrthoSize( m_pdGame3D.GetCameraOrthoWidth() + event.nParam1 , m_pdGame3D.GetCameraOrthoHeight() + event.nParam1 ); 
				}
			} );
			// 鼠标左键按下事件
			m_ui.dUIEventListener( m_hView , dUISystem.GUIEVENT_TYPE_LBUTTON_DOWN , function( event:dUIEvent ):void
			{
				if ( m_pdGame3D )
				{
					var vPos:dVector3 = new dVector3();// 反回的碰撞点
					var nWindowWidth:int = m_ui.GetWidth( 0 );
					var nWindowHeight:int = m_ui.GetHeight( 0 );
					var nMouseX:int = m_ui.GetMouseX( 0 );
					var nMouseY:int = m_ui.GetMouseY( 0 );
					// 鼠标坐标向场景地形做碰撞检测
					var nCollObj:int = m_pdGame3D.CheckCollectionMousePt( nMouseX , nMouseY , m_pStage.stageWidth , m_pStage.stageHeight , vPos , dGame3DSystem.RENDEROBJ_TYPE_TILE );
					if ( nCollObj != -1 )
					{
						m_pdGame3D.CharacterMoveTarget( m_hHero , vPos , true );
					}
				}
			} );
			// 设置摄像机
			m_pdGame3D.SetCameraCollection( true );// 设置摄像机与地面碰撞
			if ( m_pdGame3D.GetCameraPespectiveType() == 1 )
				m_pdGame3D.SetCameraUpVec( new dVector3( 0 , 0 , 1 ) );
			else
				m_pdGame3D.SetCameraUpVec( new dVector3( 0 , 1 , 0 ) );
			m_pdGame3D.SetCameraOrthoSize( m_pStage.stageWidth * ( 3 / 200 ) , m_pStage.stageHeight * ( 3 / 200 ) );
			m_pdGame3D.SetCameraEye( new dVector3( 0 , 5 , 0 ) );
			m_pdGame3D.SetCameraLookat( new dVector3( 0 , 0 , 1 ) );
			m_pdGame3D.SetCameraNearPlane( 0.2 );
			m_pdGame3D.SetCameraFarPlane( 1000.0 );
			m_pdGame3D.SetFogRange( 50 , 100 );
			m_pdGame3D.SetFogColor( new dVector4( 0.5 , 0.5 , 0.5 , 1 ) );
			// 创建场景
			m_pdGame3D.CreateScene( 100 , 100 );
			// 设置天空盒贴图
			m_pdGame3D.SetSkyboxTextureFileName( "Map/Skybox/skybox22.jpg" );
			var bmp:dBitmapData = new dBitmapData();
			bmp.LoadFromFile( "Terrain/1.jpg" , function( pTarget:Object ):void
			{
				var terrain:BitmapData = m_pdGame3D.GetTerrainBitmap( dGame3DSystem.TERRAIN_BITMAP_TEX1 );
				var terrainBmp:dBitmapData = _dInterface.iBridge_TransBitmap( terrain );
				terrainBmp.Draw( bmp , 0 , 0 , terrainBmp.GetWidth() , terrainBmp.GetHeight() , 0 , 0 , bmp.GetWidth() , bmp.GetHeight() );
				m_pdGame3D.UpdateScene( dGame3DSystem.SCENE_UPDATE_BLENDTEX );
			} , null , null );
			m_pdGame3D.SetCameraRotationRadioLimit( 0.1 , 1000000.0 );
			// 创建模型
			m_hModel = m_pdGame3D.CreateMeshObj( "SceneObj/杂/野外/野外普通民房02.DG3D" );
			m_pdGame3D.SetObjPos( m_hModel , new dVector3( 20 , 0 , 20 ) );
			// 创建人物
			for ( var i:int = 0 ; i < 1 ; i ++ )
			{
				m_hHero = m_pdGame3D.CreateCharacter();
				m_pdGame3D.SetObjHandleMouse( m_hHero , false );
				// 设置人物坐标
				m_pdGame3D.SetObjPos( m_hHero , new dVector3( dMath.Random() * 50 , 0 , dMath.Random() * 50 ) );
				// 载入装备
				m_pdGame3D.CharacterAddPartMesh( m_hHero , "护手" , "模型1/hs01.DG3D" );
				m_pdGame3D.CharacterAddPartMesh( m_hHero , "铠甲" , "模型1/kj01.DG3D" );
				m_pdGame3D.CharacterAddPartMesh( m_hHero , "护腿" , "模型1/ht01.DG3D" );
				m_pdGame3D.CharacterAddPartMesh( m_hHero , "肩甲" , "模型1/jj01.DG3D" );
				m_pdGame3D.CharacterAddPartMesh( m_hHero , "脸部" , "模型1/lb01.DG3D" );
				m_pdGame3D.CharacterAddPartMesh( m_hHero , "头盔" , "模型1/tk01.DG3D" );
				m_pdGame3D.CharacterAddPartMesh( m_hHero , "战靴" , "模型1/zx01.DG3D" );
				m_pdGame3D.CharacterAddPartMesh( m_hHero , "武器" , "弓/弓01.DG3D" , "EQ-WQhand" , "EQ-Rhand" );
				// 载入动作
				m_pdGame3D.CharacterAddAnimationKey( m_hHero , "待机" , "动作/待机.DG3K" );
				m_pdGame3D.CharacterAddAnimationKey( m_hHero , "跑" , "动作/跑.DG3K" );
				// 设置当前动作
				m_pdGame3D.CharacterSetCurrentKey( m_hHero , "跑" );
				m_pdGame3D.CharacterSetRunAniName( m_hHero , "跑" , "待机" );
			}
			m_pdGame3D.SetObjPos( m_hHero , new dVector3( 0 , 0 , 0 ) );
		}
		public function EnterFrameMove():void
		{
			if ( m_pdGame3D != null && m_ui != null)
			{
				var nMouseX:int = m_ui.GetMouseX( 0 );
				var nMouseY:int = m_ui.GetMouseY( 0 );
				var vMoveDir:dVector3 = new dVector3();
				// 判断按键并行走
				if ( m_pdGame3D.GetCameraPespectiveType() == 0 )
				{
					if ( m_pdGame3D.isKeyDown( "W".charCodeAt( 0 ) ) )
						vMoveDir.AddAppend( m_pdGame3D.GetCameraDir() );
					if ( m_pdGame3D.isKeyDown( "S".charCodeAt( 0 ) ) )
						vMoveDir.AddAppend( m_pdGame3D.GetCameraDir().MulAppend( -1 ) );
					if ( m_pdGame3D.isKeyDown( "A".charCodeAt( 0 ) ) )
						vMoveDir.AddAppend( m_pdGame3D.GetCameraCross() );
					if ( m_pdGame3D.isKeyDown( "D".charCodeAt( 0 ) ) )
						vMoveDir.AddAppend( m_pdGame3D.GetCameraCross().MulAppend( -1 ) );
				}
				else
				{
					if ( m_pdGame3D.isKeyDown( "W".charCodeAt( 0 ) ) )
						vMoveDir.AddAppend( m_pdGame3D.GetCameraUpVec() );
					if ( m_pdGame3D.isKeyDown( "S".charCodeAt( 0 ) ) )
						vMoveDir.AddAppend( m_pdGame3D.GetCameraUpVec().MulAppend( -1 ) );
					if ( m_pdGame3D.isKeyDown( "A".charCodeAt( 0 ) ) )
						vMoveDir.AddAppend( m_pdGame3D.GetCameraUpVec().Cross( new dVector3( 0 , -1 , 0 ) ) );
					if ( m_pdGame3D.isKeyDown( "D".charCodeAt( 0 ) ) )
						vMoveDir.AddAppend( m_pdGame3D.GetCameraUpVec().Cross( new dVector3( 0 , -1 , 0 ) ).MulAppend( -1 ) );
				}
				// 设置人物行走
				if ( vMoveDir.x != 0.0 || vMoveDir.z != 0.0 )
					m_pdGame3D.CharacterMoveDir( m_hHero , vMoveDir );
				else m_pdGame3D.CharacterMoveDir( m_hHero , null );
				// 调用3D设备的循环函数
				nMouseX = m_ui.GetMouseX( 0 );
				nMouseY = m_ui.GetMouseY( 0 );
				m_pdGame3D.FrameMove( nMouseX , nMouseY );
				// 设置摄像机旋转
				if ( m_pdGame3D.GetCameraPespectiveType() == 0 )
				{
					m_pdGame3D.SetCameraRotationRadio( m_pdGame3D.GetCameraRotationRadio() );
					m_pdGame3D.SetCameraLookat( m_pdGame3D.GetObjPos( m_hHero ).Add( new dVector3( 0 , 1 , 0 ) ) );
				}
				else
				{
					m_pdGame3D.SetCameraEye( m_pdGame3D.GetObjPos( m_hHero ).Add( new dVector3( 0 , 100 , 0 ) ) );
					m_pdGame3D.SetCameraLookat( m_pdGame3D.GetObjPos( m_hHero ) );
				}
			}
		}
	}
}