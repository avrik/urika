package utils.events 
{
	import flash.utils.Dictionary;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Avrik
	 */
	public class GlobalEventManger 
	{
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		
		private static var _eventListeners:Vector.<GlobalEventListener> = new Vector.<GlobalEventListener>;
		
		public function GlobalEventManger() 
		{
			
		}
		
		public static function addEvent(eventStr:String, callBackFunc:Function):void
		{
			dispatcher.addEventListener(eventStr, callBackFunc);
			var e:GlobalEventListener = new GlobalEventListener(dispatcher, eventStr, callBackFunc);
			_eventListeners.push(e);
		}
		
		static public function dispatchEvent(str:String, target:Object = null):void
		{
			dispatcher.dispatchEvent(new GlobalEvent(str, target));
		}
		
		static public function removeEvent(eventStr:String, callBackFunc:Function):void
		{
			dispatcher.removeEventListener(eventStr, callBackFunc);
			
			for each (var item:GlobalEventListener in _eventListeners) 
			{
				if (dispatcher == item.dispatcher && eventStr == item.eventStr && callBackFunc == item.callBackFunc)
				{
					_eventListeners.splice(_eventListeners.indexOf(item), 1)
					break;
				}
			}
		}
		
		static public function removeAllEvents():void 
		{
			for each (var item:GlobalEventListener in _eventListeners) 
			{
				item.dispatcher.removeEventListener(item.eventStr, item.callBackFunc);
			}
			
			_eventListeners = new Vector.<GlobalEventListener>;
		}
		
	}

}