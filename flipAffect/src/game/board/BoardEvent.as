package game.board 
{
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class BoardEvent extends Event 
	{
		static public const NODE_CLICK:String = "nodeClick";
		
		public function BoardEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 

		
	}
	
}