package utils.events 
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class GlobalEvent extends Event 
	{
		private var _dispatchTarget:Object;
		
		public function GlobalEvent(type:String, dispatchTarget:Object,bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this._dispatchTarget = dispatchTarget;
			
		} 

		
		public function get dispatchTarget():Object 
		{
			return _dispatchTarget;
		}
		
	}
	
}