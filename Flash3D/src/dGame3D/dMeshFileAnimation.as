//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	import dGame3D.Math.dMatrix;
	import dGame3D.Math.dVector3;
	import dGame3D.Math.dVector4;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author dym
	 */
	public class dMeshFileAnimation 
	{
		protected var m_pDevice:dDevice;
		protected var m_vecKeyList:Vector.<dMeshFileKeyFrames> = new Vector.<dMeshFileKeyFrames>;
		private var m_nKeyMaxFrame:int = 30;// 默认动作1秒
		private static var s_matIdentity:dMatrix = dMatrix.IDENTITY();
		public function dMeshFileAnimation( pDevice:dDevice ) 
		{
			m_pDevice = pDevice;
		}
		public function Release():void
		{
		}
		public function GetSkeletonFrameMatrix( skeletonId:int , frame:int ):dMatrix
		{
			if ( skeletonId == -1 ) return s_matIdentity;
			if ( m_vecKeyList.length == 0 ) return null;
			frame %= m_vecKeyList[ skeletonId ].m_matLocal.length;
			/*var vTrans:dVector3 = m_vecKeyList[ skeletonId ].vecTrans[ frame ];
			var vRot:dVector4 = m_vecKeyList[ skeletonId ].vecRot[ frame ];
			var vSca:dVector3 = m_vecKeyList[ skeletonId ].vecSca[ frame ];
			m_matTrans.Translation( vTrans.x , vTrans.y , vTrans.z );
			m_matRot.FromQuaternion( vRot );
			return m_matRot.Mul( m_matTrans );*/
			return m_vecKeyList[ skeletonId ].m_matLocal[ frame ];
		}
		public function GetSkeletonFrameMatrixByName( strBoneName:String , frame:int ):dMatrix
		{
			return GetSkeletonFrameMatrix( GetSkeletonId( strBoneName ) , frame );
		}
		public function GetSkeletonId( strBoneName:String ):int
		{
			for ( var i:int = 0 ; i < m_vecKeyList.length ; i ++ )
			{
				if ( m_vecKeyList[i].strBoneName == strBoneName )
					return i;
			}
			return -1;
		}
		public function LoadFromFile( strFileName:String , onLoadComplate:Function = null ):void
		{
			if ( strFileName.length )
			{
				m_pDevice.LoadBinFromFile( strFileName , function( data:ByteArray ):void
				{
					if ( data )
					{
						data.endian = "littleEndian";
						data.position = 0;
						LoadFromBin( data );
						if ( onLoadComplate != null ) onLoadComplate();
					}
				} );
			}
		}
		private function readMatrix( data:ByteArray ):dMatrix
		{
			var m:dMatrix = new dMatrix();
			m._11 = data.readFloat();
			m._12 = data.readFloat();
			m._13 = data.readFloat();
			m._14 = data.readFloat();
			m._21 = data.readFloat();
			m._22 = data.readFloat();
			m._23 = data.readFloat();
			m._24 = data.readFloat();
			m._31 = data.readFloat();
			m._32 = data.readFloat();
			m._33 = data.readFloat();
			m._34 = data.readFloat();
			m._41 = data.readFloat();
			m._42 = data.readFloat();
			m._43 = data.readFloat();
			m._44 = data.readFloat();
			return m;
		}
		public function LoadFromBin( data:ByteArray ):void
		{
			var magic1:int = data.readByte();
			var magic2:int = data.readByte();
			var magic3:int = data.readByte();
			var magic4:int = data.readByte();
			var version:int = data.readInt();
			var key_num:int = data.readInt();
			var skeleton_num:int = data.readInt();
			var nCompressType:int = data.readInt();
			var nUncompressSize:int = data.readInt();
			var nUnknown2:int = data.readInt();
			if ( magic1 == String( "D" ).charCodeAt( 0 ) &&
				 magic2 == String( "G" ).charCodeAt( 0 ) &&
				 magic3 == String( "3" ).charCodeAt( 0 ) &&
				 magic4 == String( "K" ).charCodeAt( 0 ) )
			{
				m_vecKeyList.length = skeleton_num;
				m_nKeyMaxFrame = 0;
				if ( version == 1 )
				{
					data.position += 4*253// unknow
					for ( var i:int = 0 ; i < skeleton_num ; i ++ )
					{
						m_vecKeyList[i] = new dMeshFileKeyFrames();
						m_vecKeyList[i].strBoneName = data.readMultiByte( 256 * 2 , "unicode" );
						if ( m_nKeyMaxFrame < key_num )
							m_nKeyMaxFrame = key_num;
						for ( var j:int = 0 ; j < key_num ; j ++ )
						{
							var x:Number = data.readFloat();
							var y:Number = data.readFloat();
							var z:Number = data.readFloat();
							var rx:Number = data.readFloat();
							var ry:Number = data.readFloat();
							var rz:Number = data.readFloat();
							var rw:Number = -data.readFloat();
							var matLocal:dMatrix = readMatrix( data );
							var trans:dMatrix = new dMatrix();
							trans.Translation( x , y , z );
							var sca:dMatrix = new dMatrix();
							sca.Scaling( 1 , 1 , 1 );
							var rot:dMatrix = new dMatrix();
							rot.FromQuaternion( new dVector4( rx , ry , rz , rw ) );
							m_vecKeyList[i].m_matLocal[j] = sca.Mul( rot ).Mul( trans );
							//m_vecKeyList[i].m_matLocal[j] = matLocal;
							data.position += 16 * 4;// world matrix
						}
					}
				}
				else if( version == 2 )
				{
					if ( nCompressType == 1 )
					{
						var pUncomData:ByteArray = new ByteArray();
						pUncomData.endian = data.endian;
						data.readBytes( pUncomData , 0 , data.length - data.position );
						pUncomData.uncompress();
						data = pUncomData;
					}
					for ( i = 0 ; i < skeleton_num ; i ++ )
					{
						m_vecKeyList[i] = new dMeshFileKeyFrames();
						m_vecKeyList[i].strBoneName = data.readUTF();
						if ( m_nKeyMaxFrame < key_num )
							m_nKeyMaxFrame = key_num;
						for ( j = 0 ; j < key_num ; j ++ )
						{
							x = data.readFloat();
							y = data.readFloat();
							z = data.readFloat();
							var sx:Number = data.readFloat();
							var sy:Number = data.readFloat();
							var sz:Number = data.readFloat();
							rx = data.readFloat();
							ry = data.readFloat();
							rz = data.readFloat();
							rw = data.readFloat();
							trans = new dMatrix();
							trans.Translation( x , y , z );
							sca = new dMatrix();
							sca.Scaling( sx , sy , sz );
							rot = new dMatrix();
							rot.FromQuaternion( new dVector4( rx , ry , rz , rw ) );
							m_vecKeyList[i].m_matLocal[j] = sca.Mul( rot ).Mul( trans );
						}
					}
				}
			}
		}
		public function GetKeyMaxTime():int
		{
			return m_nKeyMaxFrame * 33;
		}
	}

}
import dGame3D.Math.dMatrix;
import dGame3D.Math.dVector3;
import dGame3D.Math.dVector4;
class dMeshFileKeyFrames
{
	public var strBoneName:String = new String();
	//public var vecTrans:Vector.<dVector3> = new Vector.<dVector3>;
	//public var vecRot:Vector.<dVector4> = new Vector.<dVector4>;
	//public var vecSca:Vector.<dVector3> = new Vector.<dVector3>;
	public var m_matLocal:Vector.<dMatrix> = new Vector.<dMatrix>;
}