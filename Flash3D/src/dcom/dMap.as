//  Copyright (c) 2014 www.9miao.com All rights reserved.
package dcom
{
	
	public class dMap extends Object
	{
		private var m_pBaseObj:Object;
		private var m_pDefaultValue:*;
		
		public function dMap():void
		{
			m_pBaseObj = dInterface.ptr.CreateMap();
		}
		public function Default(v:*):dMap
		{
			m_pDefaultValue = v;
			return this;
		}
		public function Get(index:*):*
		{
			if ( m_pDefaultValue != null && Find( index ) == null ) return m_pDefaultValue;
			return dInterface.ptr.GetMap( m_pBaseObj , index , m_pDefaultValue );
		}
		public function Set(index:*, data:*):dMap
		{
			dInterface.ptr.SetMap( m_pBaseObj , index , data );
			return this;
		}
		protected function operator_get_array(index:*):*
		{
			return Get( index );
		}
		protected function operator_set_array(index:*, data:*):void
		{
			Set( index , data );
		}
		public function Begin():Object
		{
			return dInterface.ptr.MapBegin( m_pBaseObj );
		}
		public function Find(index:*):Object
		{
			return dInterface.ptr.GetMap( m_pBaseObj , index , null );
		}
		public function First(iterator:Object):*
		{
			if( iterator == null ) iterator = Begin();
			return dInterface.ptr.MapFirst( m_pBaseObj , iterator );
		}
		public function Second(iterator:Object):*
		{
			if( iterator == null ) iterator = Begin();
			return dInterface.ptr.MapSecond( m_pBaseObj , iterator );
		}
		public function Next(iterator:Object):Object
		{
			return dInterface.ptr.MapNext( m_pBaseObj , iterator );
		}
		public function Erase(iterator:Object):Object
		{
			return dInterface.ptr.MapRemoveIterator( m_pBaseObj , iterator );
		}
		public function Remove(_key:*):void
		{
			dInterface.ptr.MapRemoveKey( m_pBaseObj , _key );
		}
		public function Size():int
		{
			return dInterface.ptr.MapSize( m_pBaseObj );
		}
		public function Insert(_key:*, v:*):void
		{
		}
		public function Clear():void
		{
			dInterface.ptr.MapClear( m_pBaseObj );
		}
	}
}
