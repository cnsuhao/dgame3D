//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dUI 
{
	import dcom.dBitmapData;
	/**
	 * ...
	 * @author dym
	 */
	public class dUIImageBitmapData extends dBitmapData
	{
		public var m_strImageSetName:String;
		public var m_strBitmapFileName:String;
		public var m_rcImageFrom:dUIImageRect;
		public var m_bFromImageSet:Boolean;
		public var m_pRotationNew:dUIImageBitmapData;
		
		public function SetRect( rc:dUIImageRect ):void
		{
			var w:int = rc.Width();
			var h:int = rc.Height();
			var pNew:dBitmapData = new dBitmapData();
			pNew.Create( w > 0 ? w:1 , h > 0 ? h:1 , 0 );
			pNew.Draw( this , 0 , 0 , rc.Width() , rc.Height() , rc.left , rc.top , rc.right , rc.bottom );
			//Create( w > 0 ? w:1 , h > 0 ? h:1 , 0 );
			//this.Draw( pNew , 0 , 0 , rc.Width() , rc.Height() , 0 , 0 , rc.Width() , rc.Height() );
			m_pBaseObject = pNew.m_pBaseObject;
		}
		public function ImageLoadFromFile ( pCustomLoadFun:Function , url:String, onLoadComplete:Function, onProgress:Function, onFailed:Function) : void
		{
			if ( pCustomLoadFun != null )
			{
				var pThis:dUIImageBitmapData = this;
				pCustomLoadFun( this , url , function( bmp:dBitmapData ):void
				{
					onLoadComplete( bmp );
				}, onProgress , onFailed );
			}
			else super.LoadFromFile( url , onLoadComplete , onProgress , onFailed );
		}
		public function LoadFromBitmapData( bmp:dBitmapData , onLoadComplete:Function , onFaild:Function ):void
		{
			m_pBaseObject = bmp.m_pBaseObject;
			onLoadComplete( this );
		}
	}

}