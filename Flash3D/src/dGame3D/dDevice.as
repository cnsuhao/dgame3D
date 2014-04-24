//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dcom.dBitmapData;
	import dcom.dByteArray;
	import dcom.dTimer;
	import dGame3D.Math.dBoundingBox;
	import dGame3D.Math.dVector3;
	import dGame3D.Math.dVector4;
	import dGame3D.Shader.dShader_Animate;
	import dGame3D.Shader.dShader_Effect;
	import dGame3D.Shader.dShader_Grass;
	import dGame3D.Shader.dShader_Ocean;
	import dGame3D.Shader.dShader_Skybox;
	import dGame3D.Shader.dShader_StaticMesh;
	import dGame3D.Shader.dShader_Terrain;
	import dGame3D.Shader.dShaderBase;
	import dUI._dInterface;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.textures.Texture;
	import flash.display3D.VertexBuffer3D;
	/**
	 * ...
	 * @author dym
	 */
	public class dDevice 
	{
		private var m_pDevice:Context3D;
		private var m_pCamera:dCamera;
		private var m_arrShader:Array = new Array();
		public static const SHADER_TERRAIN:int = 1;
		public static const SHADER_STATIC_MESH:int = 2;
		public static const SHADER_ANIMATE:int = 3;
		public static const SHADER_SKYBOX:int = 4;
		public static const SHADER_EFFECT:int = 5;
		public static const SHADER_GRASS:int = 6;
		public static const SHADER_OCEAN:int = 7;
		private var m_nSetVertexBufferIndex:int;
		private var m_nSetVertexBufferIndexLast:int;
		protected var m_vecGlobalLightDir:dVector4;
		public var m_pScene:dScene;
		protected var m_fFogNear:Number = 0.0;
		protected var m_fFogFar:Number = 100.0;
		protected var m_vFogColor:dVector4 = new dVector4( 0 , 0 , 0 , 1 );
		protected var m_bEnableFog:Boolean = true;
		protected var m_pCApi:Object;
		//protected var m_pCApiMemory:ByteArray;
		protected var m_nWindowWidth:int;
		protected var m_nWindowHeight:int;
		protected var m_bZEnable:Boolean = true;
		protected var m_bZWriteEnable:Boolean = true;
		protected var m_pResource:dGameResource;
		protected var m_vecPointLight:Vector.<dPointLight> = new Vector.<dPointLight>;
		protected var m_bSoftware:Boolean = false;
		public function dDevice( pBaseDevice:Context3D ) 
		{
			m_pDevice = pBaseDevice;
			if ( m_pDevice.driverInfo.indexOf( "Software" ) != -1 )
				m_bSoftware = true;
			m_pResource = new dGameResource( this );
			SetGlobalLightDir( new dVector4( 3 , 5 , 1 , 1 ) );
			/*var loader:CLibInit = new CLibInit();
			m_pCApi = loader.init();
			var ns:Namespace = new Namespace( "cmodule.dGame3DCApi" );
			m_pCApiMemory = (ns::gstate).ds;*/
			
			m_pCamera = new dCamera( this );
			m_arrShader[ SHADER_TERRAIN ] = new dShader_Terrain( this );
			m_arrShader[ SHADER_STATIC_MESH ] = new dShader_StaticMesh( this );
			m_arrShader[ SHADER_ANIMATE ] = new dShader_Animate( this );
			m_arrShader[ SHADER_SKYBOX ] = new dShader_Skybox( this );
			m_arrShader[ SHADER_EFFECT ] = new dShader_Effect( this );
			m_arrShader[ SHADER_GRASS ] = new dShader_Grass( this );
			m_arrShader[ SHADER_OCEAN ] = new dShader_Ocean( this );
			SetZEnable( true );
			SetZWriteEnable( true );
			SetCulling( 0 );
			SetBlendFactor( 0 );
			m_vecPointLight.length = 8;
			for ( var i:int = 0 ; i < m_vecPointLight.length ; i ++ )
			{
				m_vecPointLight[i] = new dPointLight();
				m_vecPointLight[i].id = i;
			}
		}
		public function isDisposed():Boolean
		{
			return GetDevice().driverInfo == "Disposed";
		}
		public function isSuportCApi():Boolean
		{
			return m_pCApi != null;
		}
		public function GetScene():dScene
		{
			return m_pScene;
		}
		public function GetResource():dGameResource
		{
			return m_pResource;
		}
		public function SetScreenSize( width:int , height:int ):void
		{
			if ( height < 32 ) height = 32;
			if ( width < 32 ) width = 32;
			m_nWindowWidth = width;
			m_nWindowHeight = height;
			if ( m_pDevice.driverInfo == "Disposed" )
			{
				
			}
			else
				m_pDevice.configureBackBuffer( width , height , 0 , true );
			//m_pScene.OnResize( width , height );
		}
		public function GetScreenWidth():int
		{
			return m_nWindowWidth;
		}
		public function GetScreenHeight():int
		{
			return m_nWindowHeight;
		}
		public function SetGlobalLightDir( vecDir:dVector4 ):void
		{
			var v3:dVector3 = new dVector3( vecDir.x , vecDir.y , vecDir.z );
			v3.Normalize();
			m_vecGlobalLightDir = new dVector4( v3.x , v3.y , v3.z , 1.0 );
		}
		public function GetGlobalLightDir():dVector4
		{
			return m_vecGlobalLightDir;
		}
		public function GetDevice():Context3D
		{
			return m_pDevice;
		}
		public function GetShader( shader:int ):dShaderBase
		{
			return m_arrShader[ shader ];
		}
		public function GetCamera():dCamera
		{
			return m_pCamera;
		}
		public function ClearState():void
		{
			for ( var i:int = 0 ; i < 8 ; i ++ )
			{
				m_pDevice.setTextureAt( i , null );
				m_pDevice.setVertexBufferAt( i , null );
			}
		}
		protected var m_nCulling:int;
		public function SetCulling( nCull:int ):void
		{
			m_nCulling = nCull;
			if ( nCull == 0 )
				m_pDevice.setCulling( Context3DTriangleFace.NONE );
			else if ( nCull == 1 )
				m_pDevice.setCulling( Context3DTriangleFace.FRONT );
			else if ( nCull == 2 )
				m_pDevice.setCulling( Context3DTriangleFace.BACK );
		}
		public function GetCulling():int
		{
			return m_nCulling;
		}
		public function SetBlendFactor( nType:int ):void
		{
			if( nType == 0 )
				m_pDevice.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			else if ( nType == 1 )
				m_pDevice.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE);
		}
		public function SetZEnable( bEnable:Boolean ):void
		{
			m_bZEnable = bEnable;
			m_pDevice.setDepthTest( m_bZWriteEnable , m_bZEnable?Context3DCompareMode.LESS:Context3DCompareMode.ALWAYS );
		}
		public function SetZWriteEnable( bEnable:Boolean ):void
		{
			m_bZWriteEnable = bEnable;
			m_pDevice.setDepthTest( m_bZWriteEnable , m_bZEnable?Context3DCompareMode.LESS:Context3DCompareMode.ALWAYS );
		}
		public function GetTick():int
		{
			return m_nCurTickTime;
		}
		private var m_nCurPresentTime:int;
		private var m_nCurTickTime:int;
		private var m_pRenderToTexture:Texture;
		private var m_pRenderToTextureVB:dVertexBuffer;
		private var m_pRenderToTextureIB:dIndexBuffer;
		public function BeginScene():void
		{
			/*if ( isSoftware() )
			{
				if ( !m_pRenderToTexture ) m_pRenderToTexture = m_pDevice.createTexture( 1024 , 1024 , Context3DTextureFormat.BGRA , true );
				m_pDevice.setRenderToTexture( m_pRenderToTexture , true );
			}*/
		}
		public function Present( bPresentToScreen:Boolean ):void
		{
			var time:int = dTimer.GetTickCount();
			m_nCurTickTime = time - m_nCurPresentTime;
			m_nCurPresentTime = time;
			if ( isSoftware() && m_pRenderToTexture )
			{
				m_pDevice.setRenderToBackBuffer();
			}
			if( bPresentToScreen )
				m_pDevice.present();
			else
			{
				m_pDevice.clear();
				m_pDevice.present();
			}
		}
		public function LoadBinFromFile( strFileName:String , onLoadComplate:Function , onLoadProgress:Function = null ):void
		{
			var p:dByteArray = new dByteArray();
			p.LoadFromFile( strFileName , function( _p:dByteArray ):void
			{
				onLoadComplate( _dInterface.iBridge_OldByteArray( _p ) );
			}, onLoadProgress , null );
		}
		public function LoadBitmapFromFile( strFileName:String , onLoadComplate:Function , onLoadProgress:Function = null ):void
		{
			var p:dBitmapData = new dBitmapData();
			p.LoadFromFile( strFileName , function( _p:dBitmapData ):void
			{
				onLoadComplate( _dInterface.iBridge_OldBitmap( _p ) );
			} , onLoadProgress , null );
		}
		public function SetFogRange( fNear:Number , fFar:Number ):void
		{
			m_fFogNear = fNear;
			m_fFogFar = fFar;
		}
		public function GetFogNear():Number
		{
			return m_fFogNear;
		}
		public function GetFogFar():Number
		{
			return m_fFogFar;
		}
		public function SetFogColor( vColor:dVector4 ):void
		{
			m_vFogColor = vColor;
		}
		public function GetFogColor():dVector4
		{
			return m_vFogColor;
		}
		public function EnableFog( bEnable:Boolean ):void
		{
			m_bEnableFog = bEnable;
		}
		public function isEnableFog():Boolean
		{
			return m_bEnableFog;
		}
		public function CreatePointLight():dPointLight
		{
			for ( var i:int = 0 ; i < m_vecPointLight.length ; i ++ )
			{
				if ( m_vecPointLight[i].bValid == false )
				{
					m_vecPointLight[i].bValid = true;
					return m_vecPointLight[i];
				}
			}
			return null;
		}
		public function DeletePointLight( p:dPointLight ):void
		{
			if ( p ) p.bValid = false;
		}
		public function GetPointLightList():Vector.<dPointLight>
		{
			return m_vecPointLight;
		}
		public function isSoftware():Boolean
		{
			return m_bSoftware;
		}
		/*public function AS3C_ClearObjAABB():void
		{
			//if( m_pCApi ) m_pCApi.AS3C_ClearObjAABB();
		}
		public function AS3C_CreateObjAABB( id:int , p:dRenderObj ):void
		{
			//var aabb:dBoundingBox = p.GetAABB();
			//if( m_pCApi ) m_pCApi.AS3C_CreateObjAABB( id , p.GetObjType() , int( p.isShow() ) , aabb.x1 , aabb.y1 , aabb.z1 , aabb.x2 , aabb.y2 , aabb.z2 );
		}
		public function AS3C_ReleaseObjAABB( id:int ):void
		{
			//if( m_pCApi ) m_pCApi.AS3C_ReleaseObjAABB( id );
		}
		public function AS3C_ObjAABBCheckFustum():ByteArray
		{
			if ( !m_pCApiMemory ) return null;
			var data:ByteArray = new ByteArray();
			data.endian = "littleEndian";
			var vecFustum:Vector.<dVector4> = m_pCamera.GetFustumPlane();
			for ( var i:int = 0 ; i < 6 ; i ++ )
			{
				data.writeFloat( vecFustum[i].x );
				data.writeFloat( vecFustum[i].y );
				data.writeFloat( vecFustum[i].z );
				data.writeFloat( vecFustum[i].w );
			}
			data.position = 0;
			m_pCApiMemory.position = m_pCApi.AS3C_ObjAABBCheckFustum( data );
			return m_pCApiMemory;
		}
		public function AS3C_ObjAABBRayOverlap( objType:int , objExcept:int , vPos:dVector3 , vDir:dVector3 ):int
		{
			if ( !m_pCApi ) return 0;
			return m_pCApi.AS3C_ObjAABBRayOverlap( objType , objExcept , vPos.x , vPos.y , vPos.z , vDir.x , vDir.y , vDir.z );
		}*/
	}

}
import dcom.dByteArray;
class QueueData
{
	public var pData:dByteArray;
	public var pFunction:Function;
	public function QueueData( _data:dByteArray , pFun:Function ):void
	{
		pData = _data;
		pFunction = pFun;
	}
}