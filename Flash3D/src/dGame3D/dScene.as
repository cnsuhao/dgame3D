//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dcom.dMath;
	import dcom.dTimer;
	import dGame3D.Math.dBoundingBox;
	import dGame3D.Math.dColorTransform;
	import dGame3D.Math.dMatrix;
	import dGame3D.Math.dVector3;
	import dGame3D.Math.dVector4;
	import dGame3D.Shader.dShaderBase;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import dGame3D.PNGEncoder;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author dym
	 */
	public class dScene 
	{
		protected var m_pDevice:dDevice;
		protected var m_pTerrain:dTerrain;
		protected var m_vecRenderObj:Vector.<dRenderObj> = new Vector.<dRenderObj>;
		protected var m_vecStaticCharacter:Vector.<dSceneStaticCharacter> = new Vector.<dSceneStaticCharacter>;
		protected var m_pSkybox:dMeshFile;
		protected var m_matSkyboxWorld:dMatrix = new dMatrix();
		protected var m_vecVisableObjList:Vector.<dRenderObj> = new Vector.<dRenderObj>;
		protected var m_nCurMousePassCharacter:int = -1;
		protected var m_hHeroID:int = 0;
		protected var m_pSearchPath:dSearchPath = new dSearchPath();
		protected var m_vecWaterTexture:Vector.<dTexture> = new Vector.<dTexture>;
		protected var m_pWaterEdgeTexture:dTexture;
		protected var m_pDefaultNumberTexture:dTexture;
		protected var m_strSkyBoxName:String = null;
		protected var m_bShowTerrain:Boolean = true;
		public function dScene( pDevice:dDevice ) 
		{
			m_pDevice = pDevice;
			m_pSkybox = new dMeshFile( m_pDevice );
			m_pSkybox.LoadFromFile( "Map/Skybox/skybox.DG3D" , function():void
			{
				if ( m_strSkyBoxName )
					m_pSkybox.SetTextureFromFile( m_strSkyBoxName );
			});
			m_matSkyboxWorld.Scaling( 50 , 50 , 50 );
			m_matSkyboxWorld._42 = 200.0;
			
			for ( var i:int = 0 ; i < 1 ; i ++ )
			{
				var pTexture:dTexture = new dTexture( m_pDevice );
				pTexture.LoadFromFile( "system/ocean/jpg_水_" + i + ".jpg" );
				m_vecWaterTexture.push( pTexture );
			}
			m_pWaterEdgeTexture = new dTexture( m_pDevice );
			m_pWaterEdgeTexture.LoadFromFile( "system/ocean/spray.png" );
			m_pDefaultNumberTexture = new dTexture( m_pDevice );
			m_pDefaultNumberTexture.LoadFromFile( "system/number.png" );
			for ( var j:int = 0 ; j < 6 ; j ++ )
			{
				for ( i = 0 ; i < 14 ; i ++ )
				{
					var decl:dTextureRect = new dTextureRect( i * 30 / 512 , j * 40 / 512 , (i + 1) * 30 / 512 , (j + 1) * 40 / 512 );
					m_pDefaultNumberTexture.AddDeclRect( decl );
				}
			}
		}
		public function Release():void
		{
			m_pSkybox.Release();
			m_pSkybox = null;
			m_pWaterEdgeTexture.Release();
			m_pWaterEdgeTexture = null;
			for ( var i:int = 0 ; i < m_vecWaterTexture.length ; i ++ )
				m_vecWaterTexture[i].Release();
			m_vecWaterTexture.length = 0;
			m_pDefaultNumberTexture.Release();
			m_pDefaultNumberTexture = null;
		}
		public function SetSkyboxTextureFileName( strFileName:String ):void
		{
			m_strSkyBoxName = strFileName;
			m_pSkybox.SetTextureFromFile( strFileName );
		}
		public function GetDefaultNumberTexture():dTexture
		{
			return m_pDefaultNumberTexture;
		}
		public function CreateScene( width:int , height:int ):void
		{
			ReleaseScene();
			m_pTerrain = new dTerrain( m_pDevice );
			m_pTerrain.CreateTerrain( width , height );
			var tileList:Vector.<dTerrainTile> = m_pTerrain.GetTileObjs();
			for ( var i:int = 0 ; i < tileList.length ; i ++ )
				AddRenderObj( tileList[i] );
		}
		protected function _SaveFileList( idListOut:Vector.<int> ):ByteArray
		{
			var list:Array = new Array();
			var len:int = 0;
			for ( var i:int = 0 ; i < m_vecRenderObj.length ; i ++ )
			{
				var p:dRenderObj = m_vecRenderObj[i];
				if ( p && ( p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_MESH ||
					 p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_EFFECT ) )
				{
					var str:String = p.GetFileName();
					if ( list[str] == null )
					{
						list[str] = len + 1;
						len++;
					}
					idListOut.push( list[str] );
				}
				else idListOut.push( 0 );
			}
			var data:ByteArray = new ByteArray();
			data.writeInt( len );
			for ( var key:String in list )
			{
				data.writeInt( list[key] );
				data.writeUTF( key );
			}
			return data;
		}
		protected function _LoadFileList( data:ByteArray ):Array
		{
			var list:Array = new Array();
			data.position = 0;
			var num:int = data.readInt();
			for ( var i:int = 0 ; i < num ; i ++ )
			{
				var id:int = data.readInt();
				var str:String = data.readUTF();
				list[id] = str;
			}
			return list;
		}
		protected function _SaveRenderObj( idList:Vector.<int> ):ByteArray
		{
			var data:ByteArray = new ByteArray();
			var num:int = 0;
			for ( var i:int = 0 ; i < m_vecRenderObj.length ; i ++ )
			{
				if ( m_vecRenderObj[i] && ( m_vecRenderObj[i].GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_MESH ||
					 m_vecRenderObj[i].GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_EFFECT ) )
					num++;
			}
			data.writeInt( num );
			for ( i = 0 ; i < m_vecRenderObj.length ; i ++ )
			{
				var p:dRenderObj = m_vecRenderObj[i];
				if ( p && ( p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_MESH || p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_EFFECT ) )
				{
					data.writeInt( p.GetObjType() );
					data.writeInt( idList[i] );
					data.writeFloat( p.GetPos().x );
					data.writeFloat( p.GetPos().y );
					data.writeFloat( p.GetPos().z );
					data.writeFloat( p.GetSca().x );
					data.writeFloat( p.GetSca().y );
					data.writeFloat( p.GetSca().z );
					data.writeFloat( p.GetRot().x );
					data.writeFloat( p.GetRot().y );
					data.writeFloat( p.GetRot().z );
					data.writeFloat( p.GetRot().w );
					var pAABB:dBoundingBox = p.GetAABB();
					data.writeFloat( pAABB.x1 );
					data.writeFloat( pAABB.y1 );
					data.writeFloat( pAABB.z1 );
					data.writeFloat( pAABB.x2 );
					data.writeFloat( pAABB.y2 );
					data.writeFloat( pAABB.z2 );
					data.writeByte( 1 );// 其它属性个数
					data.writeFloat( p.GetYOffset() );
				}
			}
			return data;
		}
		protected function _LoadRenderObj( data:ByteArray , idFileName:Array ):void
		{
			//m_pDevice.AS3C_ClearObjAABB();
			data.position = 0;
			var num:int = data.readInt();
			var p:dRenderObj;
			for ( var i:int = 0 ; i < num ; i ++ )
			{
				var objType:int = data.readInt();
				var fileID:int = data.readInt();
				if ( objType == dGame3DSystem.RENDEROBJ_TYPE_MESH )
					p = CreateMeshObjFromFile( idFileName[fileID] );
				else if ( objType == dGame3DSystem.RENDEROBJ_TYPE_EFFECT )
					p = CreateEffectObjFromFile( idFileName[fileID] );
				p.SetPos( new dVector3( data.readFloat() , data.readFloat() , data.readFloat() ) );
				p.SetSca( new dVector3( data.readFloat() , data.readFloat() , data.readFloat() ) );
				p.SetRot( new dVector4( data.readFloat() , data.readFloat() , data.readFloat() , data.readFloat() ) );
				p.SetAABB( new dBoundingBox( data.readFloat() , data.readFloat() , data.readFloat() ,
					data.readFloat() , data.readFloat() , data.readFloat() ) );
				//m_pDevice.AS3C_CreateObjAABB( p.id , p );
				var nOtherProptyNum:int = data.readByte();
				if ( nOtherProptyNum > 0 )
				{
					p.SetYOffset( data.readFloat() );
				}
				/*for ( var j:int = 0 ; j < m_vecRenderObj.length ; j ++ )
				{
					var pp:dRenderObj = m_vecRenderObj[j];
					if ( pp && pp != p && pp.GetPos().x == p.GetPos().x &&
						 pp.GetPos().y == p.GetPos().y &&
						 pp.GetPos().z == p.GetPos().z )
					{
						DeleteRenderObj( j );
						j--;
					}
				}*/
			}
		}
		public function SaveScene():ByteArray
		{
			if ( !m_pTerrain ) return null;
			var data:ByteArray = new ByteArray();
			var idList:Vector.<int> = new Vector.<int>;
			var fileListData:ByteArray = _SaveFileList( idList );
			// save file list
			data.writeInt( PNGEncoder.MakeChunk( "S" , "F" , "L" , "I" ) );// scene file list
			data.writeInt( fileListData.length );
			data.writeBytes( fileListData );
			var renderObjData:ByteArray = _SaveRenderObj( idList );
			// save sceneObj
			data.writeInt( PNGEncoder.MakeChunk( "S" , "O" , "B" , "J" ) );// render obj
			data.writeInt( renderObjData.length );
			data.writeBytes( renderObjData );
			// save terrain
			var terrainData:ByteArray = m_pTerrain.Save();
			data.writeInt( PNGEncoder.MakeChunk( "T" , "E" , "R" , "R" ) );
			data.writeInt( terrainData.length );
			data.writeBytes( terrainData );
			// save show terrain
			if ( !m_bShowTerrain )
			{
				var terrainShow:ByteArray = new ByteArray();
				terrainShow.writeInt( int( m_bShowTerrain ) );
				terrainShow.writeInt( 0 );
				terrainShow.writeInt( 0 );
				terrainShow.writeInt( 0 );
				data.writeInt( PNGEncoder.MakeChunk( "T" , "E" , "S" , "W" ) );
				data.writeInt( terrainShow.length );
				terrainShow.position = 0;
				data.writeBytes( terrainShow );
			}
			// save monster
			var arrMonster:Array = new Array();
			var nMonsterCount:int = 0;
			for ( var i:int = 0; i < m_vecRenderObj.length ; i ++ )
			{
				var p:dRenderObj = m_vecRenderObj[i];
				if ( p && p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_CHARACTER )
				{
					var strCharacterName:String = ( p as dCharacter ).GetCharacterName();
					if ( strCharacterName.length )
					{
						if ( arrMonster[ strCharacterName ] == null )
						{
							arrMonster[ strCharacterName ] = new Vector.<MonsterData>;
							nMonsterCount++;
						}
						var pMonsterData:MonsterData = new MonsterData();
						pMonsterData.x = p.GetPos().x;
						pMonsterData.y = p.GetPos().y;
						pMonsterData.z = p.GetPos().z;
						pMonsterData.dirX = p.GetDir2().x;
						pMonsterData.dirZ = p.GetDir2().y;
						arrMonster[ strCharacterName ].push( pMonsterData );
					}
				}
			}
			if ( nMonsterCount )
			{
				data.writeInt( PNGEncoder.MakeChunk( "M" , "O" , "N" , "S" ) );
				var pMonsterBin:ByteArray = new ByteArray();
				pMonsterBin.writeInt( nMonsterCount );
				for ( var strKey:String in arrMonster )
				{
					var vecMonsterData:Vector.<MonsterData> = arrMonster[ strKey ];
					pMonsterBin.writeUTF( strKey );
					pMonsterBin.writeInt( vecMonsterData.length );
					for ( i = 0 ; i < vecMonsterData.length ; i ++ )
					{
						pMonsterBin.writeFloat( vecMonsterData[i].x );
						pMonsterBin.writeFloat( vecMonsterData[i].y );
						pMonsterBin.writeFloat( vecMonsterData[i].z );
						pMonsterBin.writeFloat( vecMonsterData[i].dirX );
						pMonsterBin.writeFloat( vecMonsterData[i].dirZ );
					}
				}
				data.writeInt( pMonsterBin.length );
				pMonsterBin.position = 0;
				data.writeBytes( pMonsterBin );
			}
			// save ocean
			var vecOcean:Vector.<dOcean> = new Vector.<dOcean>;
			for ( i = 0; i < m_vecRenderObj.length ; i ++ )
			{
				p = m_vecRenderObj[i];
				if ( p && p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_OCEAN )
					vecOcean.push( p as dOcean );
			}
			if ( vecOcean.length )
			{
				var pOceanBin:ByteArray = new ByteArray();
				pOceanBin.writeInt( vecOcean.length );
				pOceanBin.writeInt( 1 );// version
				for ( i = 0 ; i < vecOcean.length ; i ++ )
				{
					pOceanBin.writeFloat( vecOcean[i].GetPos().x );
					pOceanBin.writeFloat( vecOcean[i].GetPos().y + vecOcean[i].GetYOffset() );
					pOceanBin.writeFloat( vecOcean[i].GetPos().z );
				}
				data.writeInt( PNGEncoder.MakeChunk( "O" , "C" , "E" , "A" ) );
				data.writeInt( pOceanBin.length );
				pOceanBin.position = 0;
				data.writeBytes( pOceanBin );
			}
			
			// save end
			data.writeInt( PNGEncoder.MakeChunk( "S" , "E" , "N" , "D" ) );
			data.writeInt( 0 );
			return data;
		}
		protected function ReleaseScene():void
		{
			m_bShowTerrain = true;
			var vecNoDeleteList:Vector.<String> = new Vector.<String>;
			var vecNew:Vector.<dRenderObj> = new Vector.<dRenderObj>;
			vecNew.length = m_vecRenderObj.length;
			for ( var i:int = 0 ; i < m_vecRenderObj.length ; i ++ )
			{
				if ( m_vecRenderObj[i] )
				{
					if( m_vecRenderObj[i].GetNoDelete() == false )
						DeleteRenderObj( i );
					else
					{
						//vecNew.push( m_vecRenderObj[i] );
						vecNew[i] = m_vecRenderObj[i];
						m_vecRenderObj[i].GetResourceList( vecNoDeleteList );
					}
				}
			}
			m_vecRenderObj = vecNew;
			if ( m_pTerrain ) m_pTerrain.Release();
			m_pTerrain = null;
			m_vecVisableObjList.length = 0;
			m_pDevice.GetResource().ClearResourceBuffer( vecNoDeleteList );
		}
		public function GetRenderObjListS():Vector.<String>
		{
			var vecNoDeleteList:Vector.<String> = new Vector.<String>;
			for ( var i:int = 0 ; i < m_vecRenderObj.length ; i ++ )
			{
				if ( m_vecRenderObj[i] )
				{
					m_vecRenderObj[i].GetResourceList( vecNoDeleteList );
				}
			}
			return vecNoDeleteList;
		}
		private var m_bLoadFromFile:Boolean = false;
		private var m_strFileName:String = "";
		private var m_nLoadFlag:int;
		public function LoadFromFile( strFileName:String , onLoadComplate:Function , nFlag:int = 0 , onLoadProgress:Function = null ):void
		{
			m_bLoadFromFile = true;
			ReleaseScene();
			m_strFileName = strFileName;
			m_nLoadFlag = nFlag;
			m_pDevice.LoadBinFromFile( strFileName , function( data:ByteArray ):void
			{
				if( m_bLoadFromFile )
					LoadFromBin( data , onLoadComplate , false , m_nLoadFlag );
			} , onLoadProgress );
		}
		public function GetSceneFileName():String
		{
			return m_strFileName;
		}
		public function LoadFromBin( data:ByteArray , onLoadComplate:Function , bRelease:Boolean = true , nFlag:int = 0 , nForceWidth:int = -1 , nForceHeight:int = -1 ):void
		{
			var pTimer:Timer = new Timer( 100 , 1 );
			var fun:Function = function( event:TimerEvent ):void
			{
				pTimer.removeEventListener( TimerEvent.TIMER_COMPLETE , fun );
				m_bLoadFromFile = false;
				m_nLoadFlag = nFlag;
				if( bRelease )
					ReleaseScene();
				m_pTerrain = new dTerrain( m_pDevice );
				m_vecStaticCharacter.length = 0;
				data.position = 0;
				var pOceanData:ByteArray;
				var pTerrainLoadComplate:Function = function():void
				{
					if ( pOceanData )// 地形载完载水面
					{
						var num:int = pOceanData.readInt();
						var ver:int = pOceanData.readInt();
						for ( var i:int = 0 ; i < num ; i ++ )
						{
							var pos:dVector3 = new dVector3();
							pos.x = pOceanData.readFloat();
							pos.y = pOceanData.readFloat();
							pos.z = pOceanData.readFloat();
							CreateOcean( pos );
						}
					}
					UpdateScene( dGame3DSystem.SCENE_UPDATE_RENDEROBJ );
					if ( onLoadComplate != null ) onLoadComplate();
				}
				if ( !m_pTerrain ) m_pTerrain = new dTerrain( m_pDevice );
				while ( data.length )
				{
					var chunk:int = data.readInt();
					var size:int = data.readInt();
					if ( chunk == PNGEncoder.MakeChunk( "S" , "E" , "N" , "D" ) )
						break;
					else if ( chunk == PNGEncoder.MakeChunk( "S" , "F" , "L" , "I" ) )// file name list
					{
						var pData:ByteArray = new ByteArray();
						data.readBytes( pData , 0 , size );
						var idFileName:Array = _LoadFileList( pData );
					}
					else if ( chunk == PNGEncoder.MakeChunk( "S" , "O" , "B" , "J" ) )// scene obj
					{
						pData = new ByteArray();
						data.readBytes( pData , 0 , size );
						_LoadRenderObj( pData , idFileName );
					}
					else if ( chunk == PNGEncoder.MakeChunk( "T" , "E" , "R" , "R" ) )
					{
						pData = new ByteArray();
						data.readBytes( pData , 0 , size );
						m_pTerrain.LoadFromBin( pData , pTerrainLoadComplate , nForceWidth , nForceHeight );
						var tileList:Vector.<dTerrainTile> = m_pTerrain.GetTileObjs();
						for ( var i:int = 0 ; i < tileList.length ; i ++ )
							AddRenderObj( tileList[i] );
					}
					else if ( chunk == PNGEncoder.MakeChunk( "T" , "E" , "S" , "W" ) )
					{
						pData = new ByteArray();
						data.readBytes( pData , 0 , size );
						m_bShowTerrain = Boolean( pData.readInt() );
						pData.readInt();
						pData.readInt();
						pData.readInt();
					}
					else if ( chunk == PNGEncoder.MakeChunk( "M" , "O" , "N" , "S" ) )
					{
						pData = new ByteArray();
						data.readBytes( pData , 0 , size );
						pData.position = 0;
						var nCount:int = pData.readInt();
						for ( i = 0 ; i < nCount ; i ++ )
						{
							var strCharacterName:String = pData.readUTF();
							var nSubNum:int = pData.readInt();
							for ( var j:int = 0 ; j < nSubNum ; j ++ )
							{
								var x:Number = pData.readFloat();
								var y:Number = pData.readFloat();
								var z:Number = pData.readFloat();
								var dirX:Number = pData.readFloat();
								var dirZ:Number = pData.readFloat();
								if ( nFlag & dGame3DSystem.LOADSCENE_WITH_MONSTER )
								{
									var pMonster:dRenderObj = CreateCharacter( null , null );
									( pMonster as dCharacter ).SetCharacterName( strCharacterName );
									pMonster.SetPos( new dVector3( x , y , z ) );
									pMonster.SetDir2( dirX , dirZ );
								}
								var pStatic:dSceneStaticCharacter = new dSceneStaticCharacter();
								pStatic.id = strCharacterName;
								pStatic.x = x;
								pStatic.y = y;
								pStatic.z = z;
								pStatic.dirX = dirX;
								pStatic.dirZ = dirZ;
								m_vecStaticCharacter.push( pStatic );
							}
						}
					}
					else if ( chunk == PNGEncoder.MakeChunk( "O" , "C" , "E" , "A" ) )
					{
						pOceanData = new ByteArray();
						data.readBytes( pOceanData , 0 , size );
					}
					else data.position += size;
				}
				if ( nForceWidth != -1 && nForceHeight != -1 )
				{
					var fPosScaleX:Number = nForceWidth / m_pTerrain.GetFileSceneSizeX();
					var fPosScaleY:Number = nForceHeight / m_pTerrain.GetFileSceneSizeZ();
					for ( i = 0 ; i < m_vecRenderObj.length ; i ++ )
					{
						var p:dRenderObj = m_vecRenderObj[i];
						if ( p && (p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_MESH ||
							p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_EFFECT ||
							p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_CHARACTER ||
							p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_OCEAN ) )
						{
							var v:dVector3 = p.GetPos();
							v.x *= fPosScaleX;
							v.z *= fPosScaleY;
							p.SetPos( v );
						}
					}
					UpdateScene( dGame3DSystem.SCENE_UPDATE_RENDEROBJ );
				}
			}
			pTimer.addEventListener( TimerEvent.TIMER_COMPLETE , fun );
			pTimer.start();
		}
		public function CreateMeshObjFromFile( strFileName:String ):dRenderObj
		{
			var pMesh:dMeshObj = new dMeshObj( m_pDevice );
			pMesh.LoadFromFile( strFileName );
			AddRenderObj( pMesh );
			return pMesh;
		}
		public function CreateEffectObjFromFile( strFileName:String , bPlayEndAutoDelete:Boolean = false ):dRenderObj
		{
			var pEffect:dEffect = new dEffect( m_pDevice );
			pEffect.LoadFromFile( strFileName );
			pEffect.m_bPlayEndAutoDelete = bPlayEndAutoDelete;
			AddRenderObj( pEffect );
			return pEffect;
		}
		public function CreateCharacter( strFileName:String , pColorTransform:dColorTransform ):dRenderObj
		{
			var pCharacter:dCharacter = new dCharacter( m_pDevice );
			AddRenderObj( pCharacter );
			if ( strFileName && strFileName.length ) pCharacter.AddPartMesh( "body" , strFileName , null , null , pColorTransform );
			pCharacter.m_pColorTransform = pColorTransform;
			return pCharacter;
		}
		public function CreateOcean( vPos:dVector3 ):dRenderObj
		{
			var pOcean:dOcean = new dOcean( m_pDevice );
			pOcean.Create( vPos );
			AddRenderObj( pOcean );
			pOcean.UpdateToAS3C();
			return pOcean;
		}
		public function CreateObjCopy( p:dRenderObj ):dRenderObj
		{
			var ret:dRenderObj = null;
			if ( p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_MESH )
				ret = CreateMeshObjFromFile( p.GetFileName() );
			else if ( p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_EFFECT )
				ret = CreateEffectObjFromFile( p.GetFileName() );
			else if ( p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_CHARACTER )
			{
				ret = CreateCharacter( p.GetFileName() , p.m_pColorTransform );
				(ret as dCharacter).SetCharacterName( (p as dCharacter).GetCharacterName() );
			}
			if ( ret )
			{
				ret.SetPos( p.GetPos().Add( new dVector3( 1 , 0 , 1 ) ) );
				ret.SetRot( p.GetRot() );
				ret.SetSca( p.GetSca() );
			}
			return ret;
		}
		public function DeleteRenderObj( idx:int ):void
		{
			if ( idx >= 0 && idx < m_vecRenderObj.length && m_vecRenderObj[idx] )
			{
				//m_pDevice.AS3C_ReleaseObjAABB( m_vecRenderObj[idx].id );
				m_vecRenderObj[idx].Release();
				m_vecRenderObj[idx] = null;
			}
		}
		protected function AddRenderObj( p:dRenderObj ):void
		{
			for ( var i:int = 0 ; i < m_vecRenderObj.length ; i ++ )
			{
				if ( m_vecRenderObj[i] == null )
				{
					m_vecRenderObj[i] = p;
					p.id = i;
					return;
				}
			}
			m_vecRenderObj.push( p );
			p.id = m_vecRenderObj.length - 1;
		}
		public function FindRenderObj( id:int ):dRenderObj
		{
			if ( id < 0 || id >= m_vecRenderObj.length ) return null;
			return m_vecRenderObj[id];
		}
		private var m_vPosForCheckCharacterMousePass:dVector3 = new dVector3();
		private var m_vDirForCheckCharacterMousePass:dVector3 = new dVector3();
		public function OnFrameMove( mouseX:int , mouseY:int ):void
		{
			if ( m_vecRenderObj )
			{
				for ( var i:int = 0 ; i < m_vecRenderObj.length ; i ++ )
				{
					var p:dRenderObj = m_vecRenderObj[i] as dRenderObj;
					if ( p && p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_CHARACTER )
					{
						p.OnFrameMove();
					}
				}
			}
			// 鼠标碰撞检测
			m_pDevice.GetCamera().MousePt2Dir( mouseX , mouseY , m_pDevice.GetScreenWidth() , m_pDevice.GetScreenHeight() ,
				m_vPosForCheckCharacterMousePass , m_vDirForCheckCharacterMousePass );
			/*if ( m_pDevice.isSuportCApi() )
			{
				m_nCurMousePassCharacter = m_pDevice.AS3C_ObjAABBRayOverlap( dGame3DSystem.RENDEROBJ_TYPE_CHARACTER ,
					m_hHeroID , m_vPosForCheckCharacterMousePass , m_vDirForCheckCharacterMousePass );
			}
			else*/
			{
				m_nCurMousePassCharacter = -1;
				for ( i = 0 ; i < m_vecSortMesh.length ; i ++ )
				{
					p = m_vecSortMesh[i] as dRenderObj;
					if ( p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_CHARACTER && p.isHandleMouse() )
					{
						if ( p.GetAABB().isCollectionRay( m_vPosForCheckCharacterMousePass , m_vDirForCheckCharacterMousePass ) )
							m_nCurMousePassCharacter = p.id;
					}
				}
			}
		}
		protected var m_bShowCanReach:Boolean;
		public function SetShowCanReach( bShow:Boolean ):void
		{
			m_bShowCanReach = bShow;
		}
		private var m_vecSortMesh:Vector.<dRenderObj> = new Vector.<dRenderObj>;
		public function Render( nFlag:int ):int
		{
			if ( !m_pTerrain ) return 0;
			var r:int = 0;
			var vEye:dVector3 = m_pDevice.GetCamera().GetEye();
			var bRenderShadow:Boolean = (nFlag & dGame3DSystem.PRESENT_FLAG_RENDER_SHADOW) != 0;
			var bComputingCanReach:Boolean = (nFlag & dGame3DSystem.PRESENT_FLAG_RENDER_CANREACH) != 0;
			if( bComputingCanReach )
				bRenderShadow = bComputingCanReach;
			var p:dRenderObj;
			/*if ( m_pDevice.isSuportCApi() )
			{
				var meshObjData:ByteArray = m_pDevice.AS3C_ObjAABBCheckFustum();
				var num:int = meshObjData.readInt();
				m_vecVisableObjList.length = num;
				for ( i = 0 ; i < num ; i ++ )
				{
					m_vecVisableObjList[i] = m_vecRenderObj[meshObjData.readInt()];
				}
			}
			else*/
			{
				m_vecVisableObjList.length = 0;
				for ( var i:int = 0 ; i < m_vecRenderObj.length ; i ++ )
				{
					if ( m_vecRenderObj[i] && m_vecRenderObj[i].isShow() && m_vecRenderObj[i].GetAABB().isCollectionFustumPlane( m_pDevice.GetCamera().GetFustumPlane() ) )
						m_vecVisableObjList.push( m_vecRenderObj[i] );
				}
			}
			if ( bRenderShadow )
				m_pDevice.SetCulling( 0 );
			if ( !bRenderShadow )
			{
				// 天空盒
				m_pDevice.ClearState();
				var fCameraFar:Number = m_pDevice.GetCamera().GetFarPlane();
				m_pDevice.GetDevice().setCulling( Context3DTriangleFace.NONE );
				m_pDevice.GetCamera()._SysSetFarPlane( 1000.0 );
				var pSkyBoxShader:dShaderBase = m_pDevice.GetShader( dDevice.SHADER_SKYBOX );
				pSkyBoxShader.SetToDevice();
				pSkyBoxShader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_VIEW , m_pDevice.GetCamera().GetView() );
				pSkyBoxShader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_PROJ , m_pDevice.GetCamera().GetProj() );
				m_matSkyboxWorld._41 = vEye.x;
				//m_matSkyboxWorld._42 = vEye.y;
				m_matSkyboxWorld._43 = vEye.z;
				var rr:Number = dTimer.GetTickCount() / 100000.0;
				m_matSkyboxWorld._11 = dMath.Cos( rr ) * m_matSkyboxWorld._22;
				m_matSkyboxWorld._13 = -dMath.Sin( rr ) * m_matSkyboxWorld._22;
				m_matSkyboxWorld._31 = dMath.Sin( rr ) * m_matSkyboxWorld._22;
				m_matSkyboxWorld._33 =  dMath.Cos( rr ) * m_matSkyboxWorld._22;
				pSkyBoxShader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_WORLD , m_matSkyboxWorld );
				m_pDevice.GetDevice().setDepthTest( false , Context3DCompareMode.ALWAYS );
				m_pDevice.SetCulling( 0 );
				r += m_pSkybox.Render();
				m_pDevice.GetCamera()._SysSetFarPlane( fCameraFar );
				m_pDevice.GetDevice().setDepthTest( true , Context3DCompareMode.LESS );
				m_pDevice.SetCulling( 1 );
				// 地形
				m_pDevice.ClearState();
				if ( m_bShowCanReach )
				{
					r += m_pTerrain.Render( m_vecVisableObjList , false );
					var vOldEye:dVector3 = m_pDevice.GetCamera().GetEye();
					m_pDevice.GetCamera().SetEye( vOldEye.Add( m_pDevice.GetCamera().GetDir().Mul( 0.01 ) ) );
					m_pDevice.SetBlendFactor( 1 );
					r += m_pTerrain.Render( m_vecVisableObjList , true );
					m_pDevice.SetBlendFactor( 0 );
					m_pDevice.GetCamera().SetEye( vOldEye );
				}
				else if( m_bShowTerrain ) r += m_pTerrain.Render( m_vecVisableObjList , false );
				// 角色
				m_pDevice.SetCulling( 2 );
				m_pDevice.ClearState();
				var pCharacterShader:dShaderBase = m_pDevice.GetShader( dDevice.SHADER_ANIMATE );
				pCharacterShader.SetToDevice();
				pCharacterShader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_VIEW , m_pDevice.GetCamera().GetView() );
				pCharacterShader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_PROJ , m_pDevice.GetCamera().GetProj() );
				pCharacterShader.SetShaderConstantsFloat4( dGame3DSystem.SHADER_LIGHT , m_pDevice.GetGlobalLightDir() );
				for ( i = 0 ; i < m_vecVisableObjList.length ; i ++ )
				{
					p = m_vecVisableObjList[i] as dRenderObj;
					if ( p && p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_CHARACTER )
					{
						if ( m_nCurMousePassCharacter == p.id )
							pCharacterShader.SetShaderConstantsFloat( dGame3DSystem.SHADER_BRIGHT , 0.5 );
						else
							pCharacterShader.SetShaderConstantsFloat( dGame3DSystem.SHADER_BRIGHT , 0.0 );
						r += p.Render( pCharacterShader );
					}
				}
			}
			// 排序模型和特效
			m_vecSortMesh.length = 0;
			for ( i = 0 ; i < m_vecVisableObjList.length ; i ++ )
			{
				p = m_vecVisableObjList[i] as dRenderObj;
				if ( p && (p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_MESH ||
					 p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_EFFECT ||
					 p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_CHARACTER) )
				{
					m_vecSortMesh.push( p );
				}
			}
			m_vecSortMesh.sort( function( t1:dRenderObj , t2:dRenderObj ):int
			{
				var x1:int = (t1.m_vPos.x - vEye.x)*(t1.m_vPos.x - vEye.x) + (t1.m_vPos.z - vEye.z)*(t1.m_vPos.z - vEye.z);
				var x2:int = (t2.m_vPos.x - vEye.x)*(t2.m_vPos.x - vEye.x) + (t2.m_vPos.z - vEye.z)*(t2.m_vPos.z - vEye.z);
				if ( x1 < x2 ) return 1;
				else if ( x1 > x2 ) return -1;
				return 0;
			} );
			// 模型
			m_pDevice.ClearState();
			var pMeshShader:dShaderBase = m_pDevice.GetShader( dDevice.SHADER_STATIC_MESH );
			pMeshShader.SetToDevice();
			pMeshShader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_VIEW , m_pDevice.GetCamera().GetView() );
			pMeshShader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_PROJ , m_pDevice.GetCamera().GetProj() );
			pMeshShader.SetShaderConstantsFloat4( dGame3DSystem.SHADER_LIGHT , m_pDevice.GetGlobalLightDir() );
			if ( bComputingCanReach ) pMeshShader.SetShaderConstantsFloat( dGame3DSystem.SHADER_ALPHATEST , 1.0 );
			else pMeshShader.SetShaderConstantsFloat( dGame3DSystem.SHADER_ALPHATEST , 0.5 );
			
			for ( i = 0 ; i < m_vecSortMesh.length ; i ++ )
			{
				if( m_vecSortMesh[i].GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_MESH )
					r += m_vecSortMesh[i].Render( pMeshShader );
			}
			if ( !bRenderShadow )
			{
				// 草
				r += m_pTerrain.RenderGrass();
				// 水面
				m_pDevice.ClearState();
				m_pDevice.SetCulling( 0 );
				m_pDevice.SetZWriteEnable( false );
				var pOceanShader:dShaderBase = m_pDevice.GetShader( dDevice.SHADER_OCEAN );
				pOceanShader.SetToDevice();
				pOceanShader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_VIEW , m_pDevice.GetCamera().GetView() );
				pOceanShader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_PROJ , m_pDevice.GetCamera().GetProj() );
				var nWaterFrame:int = (dTimer.GetTickCount() * m_vecWaterTexture.length / 1000)%m_vecWaterTexture.length;
				for ( i = 0 ; i < m_vecVisableObjList.length ; i ++ )
				{
					p = m_vecVisableObjList[i] as dRenderObj;
					if ( p && p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_OCEAN )
					{
						(p as dOcean).SetTexture( m_vecWaterTexture[ nWaterFrame ] , m_pWaterEdgeTexture );
						r += p.Render( pOceanShader );
					}
				}
				m_pDevice.ClearState();
				// 特效
				m_pDevice.SetZWriteEnable( false );
				m_pDevice.SetCulling( 0 );
				m_pDevice.ClearState();
				var pEffectShader:dShaderBase = m_pDevice.GetShader( dDevice.SHADER_EFFECT );
				pEffectShader.SetToDevice();
				pEffectShader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_VIEW , m_pDevice.GetCamera().GetView() );
				var proj:dMatrix = new dMatrix( m_pDevice.GetCamera().GetProj() );
				//proj.PerspectiveFovRH( 
				pEffectShader.SetShaderConstantsMatrix( dGame3DSystem.SHADER_PROJ , proj );
				pEffectShader.SetShaderConstantsFloat4( dGame3DSystem.SHADER_LIGHT , m_pDevice.GetGlobalLightDir() );
				for ( i = 0 ; i < m_vecSortMesh.length ; i ++ )
				{
					if ( m_vecSortMesh[i].GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_EFFECT )
					{
						var ret:int = m_vecSortMesh[i].Render( pEffectShader );
						if ( ret == -1 )// 特效播放完毕并且被设置成自动删除
							DeleteRenderObj( m_vecSortMesh[i].id );
						else r += ret;
					}
					else if ( m_vecSortMesh[i].GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_CHARACTER )
						(m_vecSortMesh[i] as dCharacter).RenderBillboard( pEffectShader );
				}
				m_pDevice.SetBlendFactor( 0 );
				m_pDevice.SetCulling( 2 );
				m_pDevice.SetZWriteEnable( true );
			}
			return r;
		}
		public function CheckCollectionRay( vPos:dVector3 , vDir:dVector3 , vPosOut:dVector3 , nObjType:int ):int
		{
			if ( !m_pTerrain ) return -1;
			var p:dRenderObj;
			var fLength:Number = 999999.0;
			var vCheckPos:dVector3 = new dVector3();
			var nObjID:int = -1;
			for ( var i:int = 0 ; i < m_vecVisableObjList.length ; i ++ )
			{
				p = m_vecVisableObjList[i] as dRenderObj;
				if ( p && (p.GetObjType() & nObjType) && p.CheckCollectionRay( vPos , vDir , vCheckPos ) )
				{
					var l:Number = vPos.Sub( vCheckPos ).Length();
					if ( fLength > l )
					{
						nObjID = p.id;
						fLength = l;
						if( vPosOut )vPosOut.Copy( vCheckPos );
					}
				}
			}
			return nObjID;
		}
		public function GetTerrain():dTerrain
		{
			return m_pTerrain;
		}
		public function GetHeight( x:Number , z:Number ):Number
		{
			if ( !m_pTerrain ) return 0.0;
			return m_pTerrain.GetHeightFloat( x , z );
		}
		public function UpdateScene( nFlag:int ):void
		{
			if ( m_pTerrain )
			{
				m_pTerrain.Update( nFlag );
				if ( (nFlag & dGame3DSystem.SCENE_UPDATE_RENDEROBJ) ||
					 (nFlag & dGame3DSystem.SCENE_UPDATE_HEIGHTMAP) )
				{
					for ( var i:int = 0 ; i < m_vecRenderObj.length ; i ++ )
					{
						var p:dRenderObj = m_vecRenderObj[i];
						if ( p && (p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_MESH ||
							p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_EFFECT ||
							p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_CHARACTER) )
						{
							var pos:dVector3 = p.GetPos();
							pos.y = m_pTerrain.GetHeight( pos.x , pos.z );
							p.SetPos( pos );
						}
					}
				}
			}
			if ( nFlag & dGame3DSystem.SCENE_UPDATE_OCEAN )
			{
				for ( i = 0 ; i < m_vecRenderObj.length ; i ++ )
				{
					p = m_vecRenderObj[i];
					if ( p && (p.GetObjType() == dGame3DSystem.RENDEROBJ_TYPE_OCEAN) )
						(p as dOcean).Update();
				}
			}
		}
		public function GetSceneObjList( nObjType:int ):Vector.<int>
		{
			var ret:Vector.<int> = new Vector.<int>;
			for ( var i:int = 0 ; i < m_vecRenderObj.length ; i ++ )
			{
				var p:dRenderObj = m_vecRenderObj[i];
				if ( p && (p.GetObjType() & nObjType) ) ret.push( p.id );
			}
			return ret;
		}
		public function GetSceneStaticCharacter():Vector.<dSceneStaticCharacter>
		{
			return m_vecStaticCharacter;
		}
		public function GetSceneObjFileNameList( nObjType:int ):Vector.<String>
		{
			var ret:Vector.<String> = new Vector.<String>;
			for ( var i:int = 0 ; i < m_vecRenderObj.length ; i ++ )
			{
				var p:dRenderObj = m_vecRenderObj[i];
				if ( p && (p.GetObjType() & nObjType) ) ret.push( p.GetFileName() );
			}
			return ret;
		}
		public function GetCanReach( x:int , z:int ):int
		{
			if ( !m_pTerrain ) return -1;
			return m_pTerrain.GetCanReach( x , z );
		}
		public function SearchPath( nStartX:Number , nStartY:Number , nEndX:Number , nEndY:Number ):Array
		{
			return m_pSearchPath.findPath( GetCanReach , new Point( nStartX , nStartY ) , new Point( nEndX , nEndY ) );
		}
		public function GetMousePassCharacterID():int
		{
			return m_nCurMousePassCharacter;
		}
		public function OnResize( width:int , height:int ):void
		{
			
		}
		public function ResizeScene( newWidth:int , newHeight:int , onComplateFun:Function ):void
		{
			if ( m_pTerrain )
			{
				var p:ByteArray = SaveScene();
				LoadFromBin( p , onComplateFun , true , m_nLoadFlag , newWidth , newHeight );
			}
			else if( onComplateFun != null ) onComplateFun();
		}
		public function SetShowTerrain( bShow:Boolean ):void
		{
			m_bShowTerrain = bShow;
		}
		public function isShowTerrain():Boolean
		{
			return m_bShowTerrain;
		}
	}

}
class MonsterData
{
	public var x:Number;
	public var y:Number;
	public var z:Number;
	public var dirX:Number;
	public var dirZ:Number;
}