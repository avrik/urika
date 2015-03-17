package game.board.events 
{
	import game.board.boxes.BoxView;
	import starling.events.Event;
	import game.board.boxes.BoxModel;
	import game.board.boxes.BoxModel;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class BoxTouchEvent extends Event 
	{
		static public const BOX_TOUCHED:String = "boxTouched";
		private var _boxView:BoxView;
		
		public function BoxTouchEvent(type:String, boxView:BoxView,bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this._boxView = boxView;
			
		} 
		
		public function get boxView():BoxView 
		{
			return _boxView;
		}
		
	}
	
}