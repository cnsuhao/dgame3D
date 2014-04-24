//  Copyright (c) 2014 www.9miao.com All rights reserved.
package 
{
	import dcom.dByteArray;
	import dcom.dInterface;
	import dcom.dTimer;
	import dGame3D.dGame3DSystem;
	import dUI._dInterface;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.Security;
	import flash.utils.ByteArray;

	[SWF(backgroundColor="#808080", frameRate="60", width="600", height="600")]
	public class Main extends Sprite
	{
		protected var m_pdGame3D:dGame3DSystem;
		protected var m_pGame:Game;
		public function Main( pParam:Object = null ):void 
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			// 初始化接口类
			_dInterface.Init( this , stage );
			// 设置工作路径
			dByteArray.SetCurrentPath( "MeshData" );
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;
			stage.addEventListener( Event.RESIZE , onScreenResize );
			stage.addEventListener( "rightClick" , function( event:Event ):void { } );
			
			// 创建Context3D
			dGame3DSystem.CreateContext3D( stage , function( context3D:Object ):void
			{
				m_pdGame3D = new dGame3DSystem( context3D );
				m_pdGame3D.SetScreenSize( stage.stageWidth , stage.stageHeight );
				m_pGame = new Game( m_pdGame3D , stage );
				var pTimer:dTimer = new dTimer();
				pTimer.Create( 0 , 0 , function( p:dTimer , nRepeat:int ):void
				{
					if ( m_pdGame3D )
					{
						EnterFrameMove();
					}
				} );
			} );
		}
		public function onScreenResize( event:Event ):void
		{
			m_pdGame3D.SetScreenSize( stage.stageWidth , stage.stageHeight );
			m_pGame.OnFrameScreenResize( stage.stageWidth , stage.stageHeight );
		}
		public function EnterFrameMove():void
		{
			m_pGame.EnterFrameMove();
			m_pdGame3D.Present();
		}
	}
}
