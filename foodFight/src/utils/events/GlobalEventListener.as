package utils.events 
{
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Avrik
	 */
	public class GlobalEventListener 
	{
		public var dispatcher:EventDispatcher;
		public var eventStr:String;
		public var callBackFunc:Function;
		
		public function GlobalEventListener(dispatcher:EventDispatcher, eventStr:String, callBackFunc:Function) 
		{
			this.callBackFunc = callBackFunc;
			this.eventStr = eventStr;
			this.dispatcher = dispatcher;
			
		}
		
	}

}