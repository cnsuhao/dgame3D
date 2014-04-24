//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dcom
{
	public class dVector
	{
		protected var m_pData:Vector.<*>;
		private var m_nSysSize:int;
		private var m_nSize:int;
		private var m_pDefaultValue:*;
		
		public function Default(t:*):dVector
		{
			for( var i:int = 0 , n:int = Size();i < n;i ++ ) if( m_pData[i] == m_pDefaultValue ) m_pData[i] = t;
			m_pDefaultValue = t;
			return this;
		}
		public function Copy(t:dVector):dVector
		{
			Clear();
			Resize( t.Size() );
			for( var i:int = 0;i < t.Size();i ++ ) Set( i , t.Get( i ) );
			return this;
		}
		protected function CheckSize(nOldSize:int):void
		{
			while( m_nSysSize <= m_nSize )
			{
				if( m_nSysSize < 1024 ) m_nSysSize += 16;
				else m_nSysSize *= 2;
				if( m_nSysSize <= m_nSize ) continue;
				var pNewData:Vector.<*> = new Vector.<*>(m_nSysSize);
				for( var i:int = 0;i < nOldSize;i ++ ) pNewData[i] = m_pData[i];
				for( i = nOldSize;i < m_nSysSize;i ++ ) pNewData[i] = m_pDefaultValue;
				m_pData = pNewData;
			}
		}
		protected function operator_get_array(index:int):*
		{
			return Get( index );
		}
		public function Get(index:int):*
		{
			if( index < 0 || index >= m_nSize ) return m_pDefaultValue;
			return (m_pData[index]);
		}
		protected function operator_set_array(index:int, data:*):void
		{
			Set( index , data );
		}
		public function Set(index:int, data:*):void
		{
			if( index == Size() ) Resize( index + 1 );
			m_pData[index] = data;
		}
		public function SetArray(data:Vector.<*>):dVector
		{
			for( var i:int = 0;i < data.length;i ++ ) Set( i , data[i] );
			return this;
		}
		public function Push(t:*):dVector
		{
			CheckSize( m_nSize );
			m_pData[m_nSize] = t;
			m_nSize ++;
			return this;
		}
		public function PushVector(t:dVector):dVector
		{
			for( var i:int = 0;i < t.Size();i ++ ) Push( t.Get( i ) );
			return this;
		}
		public function Pop():*
		{
			if( m_nSize > 0 )
			{
				var ret:* = m_pData[m_nSize - 1];
				m_nSize --;
				return ret;
			}
			return m_pDefaultValue;
		}
		public function Insert(at:int, t:*):void
		{
			if( at >= 0 && at < m_nSize )
			{
				CheckSize( m_nSize );
				for( var i:int = m_nSize;i > at;i -- ) m_pData[i] = m_pData[i - 1];
				m_pData[at] = t;
				m_nSize ++;
			}
			else if( at >= m_nSize ) Push( t );
		}
		public function Erase(at:int):void
		{
			if( at >= 0 && at < m_nSize )
			{
				for( var i:int = at;i < m_nSize - 1;i ++ ) m_pData[i] = m_pData[i + 1];
				m_pData[m_nSize - 1] = m_pDefaultValue;
				m_nSize --;
			}
		}
		public function Remove(t:*):void
		{
			for( var i:int = 0;i < m_nSize;i ++ )
			{
				if( m_pData[i] == t )
				{
					Erase( i );
					break;
				}
			}
		}
		public function Clear():void
		{
			m_nSysSize = 0;
			m_pData = null;
			m_nSize = 0;
		}
		public function Size():int
		{
			return m_nSize;
		}
		public function Resize(nNewSize:int):dVector
		{
			if( m_nSize != nNewSize )
			{
				var nOldSize:int = m_nSize;
				m_nSize = nNewSize;
				if( m_nSysSize < m_nSize ) CheckSize( nOldSize );
			}
			return this;
		}
		public function Data():Vector.<*>
		{
			return m_pData;
		}
		public function Find(v:*):int
		{
			for( var i:int = 0 , n:int = Size();i < n;i ++ )
			{
				if( Get( i ) == v ) return i;
			}
			return - 1;
		}
		public function set_Item( index:int , p:* ):void
		{
			return Set( index , p );
		}
		public function get_Item( index:int ):*
		{
			return Get( index );
		}
	}
}