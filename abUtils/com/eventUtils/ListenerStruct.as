package com.eventUtils
{
	import flash.events.IEventDispatcher;
	/**
	 * ...
	 * @author Amit
	 */
	public class ListenerStruct 
	{
		private var _type:String;
		public function get type():String { return _type }
		private var _func:Function;
		public function get func():Function { return _func }
		
		
		public function set func(value:Function):void 
		{
			_func = value;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
		
		public function ListenerStruct(type:String, func:Function) 
		{
			_type = type;
			_func = func;
		}
		
	}

}