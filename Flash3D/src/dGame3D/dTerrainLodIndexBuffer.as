//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dGame3D 
{
	/**
	 * ...
	 * @author dym
	 */
	public class dTerrainLodIndexBuffer 
	{
		protected var m_pIBNormal:dIndexBuffer;
		protected var m_pIBLeftMore:dIndexBuffer;		// |
		protected var m_pIBDownMore:dIndexBuffer;		//  _
		protected var m_pIBRightMore:dIndexBuffer;		//   |
		protected var m_pIBTopMore:dIndexBuffer;		//  ^
		protected var m_pIBLeftDownMore:dIndexBuffer;	// |_
		protected var m_pIBDownRightMore:dIndexBuffer;	//  _|
		protected var m_pIBRightTopMore:dIndexBuffer;	//	^|
		protected var m_pIBLeftTopMore:dIndexBuffer;	// |^
		public function dTerrainLodIndexBuffer( pDevice:dDevice , TILE_SIZE:int , _lod:int ) 
		{
			var lod:int;
			var lodlast:int;
			if ( _lod == 0 ) { lod = 1; }
			else if ( _lod == 1 ) { lod = 2; lodlast = 1; }
			else if ( _lod == 2 ) { lod = 5; lodlast = 2; }
			else if ( _lod == 3 ) { lod = 10; lodlast = 5; }
			else if ( _lod == 4 ) { lod = TILE_SIZE; lodlast = TILE_SIZE; }
			var bLodLeft:Boolean = false;
			var bLodDown:Boolean = false;
			var bLodTop:Boolean = false;
			var bLodRight:Boolean = false;
			for ( var k:int = 0 ; k < 9 ; k ++ )
			{
				if ( lod == 1 && k > 0 ) break;// lod0没有衔接
				bLodLeft = false;
				bLodDown = false;
				bLodTop = false;
				bLodRight = false;
				if ( k == 1 ) bLodLeft = true;
				else if ( k == 2 ) bLodDown = true;
				else if ( k == 3 ) bLodRight = true;
				else if ( k == 4 ) bLodTop = true;
				else if ( k == 5 ) { bLodLeft = true ; bLodDown = true ; }
				else if ( k == 6 ) { bLodDown = true ; bLodRight = true; }
				else if ( k == 7 ) { bLodRight = true ; bLodTop = true; }
				else if ( k == 8 ) { bLodTop = true ; bLodLeft = true; }
				var index:Vector.<uint> = new Vector.<uint>;
				for ( var j:int = 0 ; j < TILE_SIZE ; j += lod )
				{
					for ( var i:int = 0 ; i < TILE_SIZE ; i += lod )
					{
						var i1:int = i;
						var j1:int = j;
						var i2:int = i;
						var j2:int = j;
						var lodLinkNum:int = lod / lodlast;
						if ( lod == 5 )
						{
							if ( i == 5 || i == 15 || i == 25 || i == 35 || i == 45 )
								i2++;
							else if ( i == 0 || i == 10 || i == 20 || i == 30 || i == 40 )
							{
								i1++;
								if( bLodLeft && i == 0 || bLodRight && i == TILE_SIZE - lod )
									lodLinkNum++;
							}
							if ( j == 5 || j == 15 || j == 25 || j == 35 || j == 45 )
								j2++;
							else if ( j == 0 || j == 10 || j == 20 || j == 30 || j == 40 )
							{
								j1++;
								if( bLodDown && j == TILE_SIZE - lod || bLodTop && j == 0 )
									lodLinkNum++;
							}
							if ( lodLinkNum > 2 ) lodLinkNum = 2;
						}
						if ( bLodDown && j == TILE_SIZE - lod && bLodLeft && i == 0 )// 左下
						{
							//        3     2               2               2               2
							//        | _ ///|        | _ ///|        | _ ///|        | _ ///|
							//       1|/  /| |       3|/  /| |        |/  /| |        |/  /| |
							//        |  / / |        |  / / |        |  / / |        |  / / |
							// face1  |/  /  | face1  |/  /  | face1  |/  /  | face1  |/  /  |
							//                         1               3  1               3  1
							for ( t = 0 ; t < lodLinkNum ; t ++ )
							{
								index.push( (j2 + lodlast*(t+1)) * (TILE_SIZE + 1) + i2 );	// 下行 中
								index.push( j2 * (TILE_SIZE + 1) + i1 + lod );		// 本行 2
								index.push( (j2 + lodlast*t)* (TILE_SIZE + 1) + i2 );				// 本行 1
							}
							
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );		// 下行 1
							index.push( j2 * (TILE_SIZE + 1) + i1 + lod );		// 本行 2
							index.push( (j2 + lodlast * lodLinkNum) * (TILE_SIZE + 1) + i2 );	// 下行 中
							
							for ( t = 0 ; t < lodLinkNum ; t ++ )
							{
								index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 + lodlast*(t+1) );// 下行 中
								index.push( j2 * (TILE_SIZE + 1) + i1 + lod );			// 本行 2
								index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 + lodlast*t );			// 下行 1
							}
							
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i1 + lod );	// 下行 2
							index.push( j2 * (TILE_SIZE + 1) + i1 + lod );			// 本行 2
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 + lodlast * lodLinkNum );// 下行 中
						}
						else if ( bLodDown && j == TILE_SIZE - lod && bLodRight && i == TILE_SIZE - lod ) // 下右
						{
							//        3    2              2              3
							//        |   /||        |   /||        |   /||        |   /||
							//        |  // |        |  // |        |  // |2       |  // |2
							//        | /| /|        | /| /|        | /| /|        | /| /|
							// face1  |/ |/ | face2  |/ |/ | face3  |/ |/ | face4  |/ |/ |
							//        1              3  1              1              3  1
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );			// 下行 1
							index.push( j2 * (TILE_SIZE + 1) + i1 + lod );			// 本行 2
							index.push( j2 * (TILE_SIZE + 1) + i2 );					// 本行 1
							
							for ( t = 0 ; t < lodLinkNum ; t ++ )
							{
								index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 + lodlast * (t+1) );// 下行 中
								index.push( j2 * (TILE_SIZE + 1) + i1 + lod );			// 本行 2
								index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 + lodlast * t );			// 下行 1
							}
							
							for ( t = 0 ; t < lodLinkNum ; t ++ )
							{
								index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 + lodlast );// 下行 中
								index.push( (j2 + lodlast * (t+1)) * (TILE_SIZE + 1) + i1 + lod );// 中行 2
								index.push( (j2 + lodlast * t) * (TILE_SIZE + 1) + i1 + lod );			// 本行 2
							}
							
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i1 + lod );	// 下行 2
							index.push( (j2 + lodlast) * (TILE_SIZE + 1) + i1 + lod );// 中行 2
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 + lodlast * lodLinkNum );// 下行 中
						}
						else if ( bLodRight && i == TILE_SIZE - lod && bLodTop && j == 0 )// 右上
						{
							//        3  2              3  2              3
							//        |  / /|        |  / /|        |  / /|        |  / /|
							//        | |_/ |        | |_/ |        | |_/ |2       | |_/ |2
							//        | /_ /|        | /_ /|        | /_ /|        | /_ /|
							// face1  |//   | face2  |//   | face3  |//   | face4  |//   |
							//        1               1              1              3    1
							for ( t = 0 ; t < lodLinkNum ; t ++ )
							{
								index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );			// 下行 1
								index.push( j2 * (TILE_SIZE + 1) + i2 + lodlast * (t+1) );		// 本行 中
								index.push( j2 * (TILE_SIZE + 1) + i2 + lodlast * t );					// 本行 1
							}
							
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );			// 下行 1
							index.push( j2 * (TILE_SIZE + 1) + i1 + lod );			// 本行 2
							index.push( j2 * (TILE_SIZE + 1) + i2 + lodlast * lodLinkNum );		// 本行 中
							
							for ( t = 0 ; t < lodLinkNum ; t ++ )
							{
								index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );			// 下行 1
								index.push( (j2 + lodlast*(t+1)) * (TILE_SIZE + 1) + i1 + lod );// 中行 2
								index.push( (j2 + lodlast*t)* (TILE_SIZE + 1) + i1 + lod );			// 本行 2
							}
							
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i1 + lod );	// 下行 2
							index.push( (j2 + lodlast) * (TILE_SIZE + 1) + i1 + lod );// 中行 2
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );			// 下行 1
						}
						else if ( bLodLeft && i == 0 && bLodTop && j == 0 )// 左上
						{
							//        3  2              2             3   2              2
							//        | /| /|        | /| /|        | /| /|        | /| /|
							//       1|/ // |       3|/ // |        |/ // |        |/ // |
							//        | |/  |        | |/  |        | |/  |        | |/  |
							// face1  |//   | face2  |//   | face3  |//   | face4  |//   |
							//                       1               1              3    1
							for ( t = 0 ; t < lodLinkNum + 1 ; t ++ )
							{
								index.push( (j2 + lodlast*(t+1)) * (TILE_SIZE + 1) + i2 );		// 中行 1
								index.push( j2 * (TILE_SIZE + 1) + i2 + lodlast );	// 本行 中
								index.push( (j2 + lodlast*t) * (TILE_SIZE + 1) + i2 );		// 本行 1
							}
							
							//index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );			// 下行 1
							//index.push( j2 * (TILE_SIZE + 1) + i2 + lodlast * lodLinkNum );		// 本行 中
							//index.push( ( j2 + lodlast ) * (TILE_SIZE + 1) + i2 );		// 中行 1
							
							for ( t = 0 ; t < lodLinkNum ; t ++ )
							{
								index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );			// 下行 1
								index.push( j2 * (TILE_SIZE + 1) + i2 + lodlast*(t+2) );			// 本行 2
								index.push( j2 * (TILE_SIZE + 1) + i2 + lodlast*(t+1) );		// 本行 中
							}
							
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i1 + lod );	// 下行 2
							index.push( j2 * (TILE_SIZE + 1) + i1 + lod );			// 本行 2
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );			// 下行 1
						}
						else if ( bLodDown && j == TILE_SIZE - lod )
						{
							//        3    2              2              2
							//        |   /||        |   /||        |   /||
							//        |  / /|        |  / /|        |  / /|
							//        | / / |        | / / |        | / / |
							// face1  |/ |  |  face2 |/ |  |  face3 |/ |  |
							//        1              3  1              3  1
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );	// 下行 1
							index.push( j2 * (TILE_SIZE + 1) + i1 + lod );	// 本行 2
							index.push( j2 * (TILE_SIZE + 1) + i2 );			// 本行 1

							for ( var t:int = 0 ; t < lodLinkNum ; t ++ )
							{
								index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 + lodlast * (t+1) );// 下行 中
								index.push( j2 * (TILE_SIZE + 1) + i1 + lod );			// 本行 2
								index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 + lodlast * t);	// 下行 1
							}
							
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i1 + lod );	// 下行 2
							index.push( j2 * (TILE_SIZE + 1) + i1 + lod );			// 本行 2
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 + lodlast * lodLinkNum );// 下行 中
						}
						else if ( bLodLeft && i == 0 )
						{
							//        3     2              2              2
							//        | __//|         | __//|        | __//|   
							//        |/  / |         |/  / |        |/  / |
							// face1 1|  /  |  face2 3|  /  |  face3 |  /  |
							//        | /   |         | /   |        | /   |
							//                        1              3     1
							for ( t = 0 ; t < lodLinkNum ; t ++ )
							{
								index.push( (j2 + lodlast*(t+1)) * (TILE_SIZE + 1) + i2 );	// 中行 1
								index.push( j2 * (TILE_SIZE + 1) + i1 + lod );		// 本行 2
								index.push( (j2 + lodlast*t) * (TILE_SIZE + 1) + i2 );				// 本行 1
							}
							
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );		// 下行 1
							index.push( j2 * (TILE_SIZE + 1) + i1 + lod );		// 本行 2
							index.push( (j2 + lodlast * lodLinkNum) * (TILE_SIZE + 1) + i2 );	// 中行 1

							index.push( (j1 + lod) * (TILE_SIZE + 1) + i1 + lod );// 下行 2
							index.push( j2 * (TILE_SIZE + 1) + i1 + lod );		// 本行 2
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );		// 下行 1
						}
						else if ( bLodRight && i == TILE_SIZE - lod )
						{
							//        3    2              3
							//        |   / |        |   / |        |   / |
							//        |  / _|        |  / _|2       |  / _|2
							//        | /_/ |        | /_/ |        | /_/ |
							// face1  |//   | face2  |//   | face3  |//   |
							//         1              1              3    1
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );	// 下行 1
							index.push( j2 * (TILE_SIZE + 1) + i1 + lod );	// 本行 2
							index.push( j2 * (TILE_SIZE + 1) + i2 );			// 本行 1
							
							for ( t = 0 ; t < lodLinkNum ; t ++ )
							{
								index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );			// 下行 1
								index.push( (j2 + lodlast * (t+1) ) * (TILE_SIZE + 1) + i1 + lod );// 中行 2
								index.push( (j2 + lodlast * t ) * (TILE_SIZE + 1) + i1 + lod );			// 本行 2
							}
							
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i1 + lod );	// 下行 2
							index.push( (j2 + lodlast * lodLinkNum) * (TILE_SIZE + 1) + i1 + lod );// 中行 2
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );			// 下行 1
						}
						else if ( bLodTop && j == 0 )
						{
							//        3  2              3  2              2
							//        |  / /|        |  / /|        |  / /|
							//        | | / |        | | / |        | | / |
							//        | |/  |        | |/  |        | |/  |
							// face1  |//   | face2  |//   | face3  |//   |
							//        1               1              3    1
							for ( t = 0 ; t < lodLinkNum ; t ++ )
							{
								index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );	// 下行 1
								index.push( j2 * (TILE_SIZE + 1) + i2 + lodlast * (t+1) );// 本行 中
								index.push( j2 * (TILE_SIZE + 1) + i2 + lodlast * t);			// 本行 1
							}
							
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );	// 下行 1
							index.push( j2 * (TILE_SIZE + 1) + i1 + lod );	// 本行 2
							index.push( j2 * (TILE_SIZE + 1) + i2 + lodlast * lodLinkNum );// 本行 中
							
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i1 + lod );	// 下行 2
							index.push( j2 * (TILE_SIZE + 1) + i1 + lod );	// 本行 2
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );	// 下行 1
						}
						else
						{
							//        3 2           2
							// face1  |/|  face2  |/|
							//        1           3 1
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );	// 下行 1
							index.push( j2 * (TILE_SIZE + 1) + i1 + lod );	// 本行 2
							index.push( j2 * (TILE_SIZE + 1) + i2 );			// 本行 1

							index.push( (j1 + lod) * (TILE_SIZE + 1) + i1 + lod );// 下行 2
							index.push( j2 * (TILE_SIZE + 1) + i1 + lod );		// 本行 2
							index.push( (j1 + lod) * (TILE_SIZE + 1) + i2 );		// 下行 1
						}
					}
				}
				if ( k == 0 )
				{
					m_pIBNormal = new dIndexBuffer( index.length / 3 , pDevice );
					m_pIBNormal.UploadIndexBufferFromVector( index );
				}
				else if ( k == 1 )
				{
					m_pIBLeftMore = new dIndexBuffer( index.length / 3 , pDevice );
					m_pIBLeftMore.UploadIndexBufferFromVector( index );
				}
				else if ( k == 2 )
				{
					m_pIBDownMore = new dIndexBuffer( index.length / 3 , pDevice );
					m_pIBDownMore.UploadIndexBufferFromVector( index );
				}
				else if ( k == 3 )
				{
					m_pIBRightMore = new dIndexBuffer( index.length / 3 , pDevice );
					m_pIBRightMore.UploadIndexBufferFromVector( index );
				}
				else if ( k == 4 )
				{
					m_pIBTopMore = new dIndexBuffer( index.length / 3 , pDevice );
					m_pIBTopMore.UploadIndexBufferFromVector( index );
				}
				else if ( k == 5 )
				{
					m_pIBLeftDownMore = new dIndexBuffer( index.length / 3 , pDevice );
					m_pIBLeftDownMore.UploadIndexBufferFromVector( index );
				}
				else if ( k == 6 )
				{
					m_pIBDownRightMore = new dIndexBuffer( index.length / 3 , pDevice );
					m_pIBDownRightMore.UploadIndexBufferFromVector( index );
				}
				else if ( k == 7 )
				{
					m_pIBRightTopMore = new dIndexBuffer( index.length / 3 , pDevice );
					m_pIBRightTopMore.UploadIndexBufferFromVector( index );
				}
				else if ( k == 8 )
				{
					m_pIBLeftTopMore = new dIndexBuffer( index.length / 3 , pDevice );
					m_pIBLeftTopMore.UploadIndexBufferFromVector( index );
				}
			}
		}
		public function Release():void
		{
			if( m_pIBNormal ) m_pIBNormal.Release();
			if( m_pIBLeftMore ) m_pIBLeftMore.Release();
			if( m_pIBDownMore ) m_pIBDownMore.Release();
			if( m_pIBRightMore ) m_pIBRightMore.Release();
			if( m_pIBTopMore ) m_pIBTopMore.Release();
			if( m_pIBLeftDownMore ) m_pIBLeftDownMore.Release();
			if( m_pIBDownRightMore ) m_pIBDownRightMore.Release();
			if( m_pIBRightTopMore ) m_pIBRightTopMore.Release();
			if( m_pIBLeftTopMore ) m_pIBLeftTopMore.Release();
		}
		public function GetIndexBuffer( bLeftMore:Boolean = false , bDownMore:Boolean = false , bRightMore:Boolean = false , bTopMore:Boolean = false ):dIndexBuffer
		{
			if ( bLeftMore )
			{
				if( bDownMore )
					return m_pIBLeftDownMore;
				else if ( bTopMore )
					return m_pIBLeftTopMore;
				return m_pIBLeftMore;
			}
			else if ( bRightMore )
			{
				if ( bDownMore )
					return m_pIBDownRightMore;
				else if ( bTopMore )
					return m_pIBRightTopMore;
				return m_pIBRightMore;
			}
			else if ( bTopMore ) return m_pIBTopMore;
			else if ( bDownMore ) return m_pIBDownMore;
			return m_pIBNormal;
		}
	}

}