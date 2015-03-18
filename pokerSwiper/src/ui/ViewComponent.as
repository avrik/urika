package ui 
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class ViewComponent extends Sprite 
	{
		
		public function ViewComponent() 
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			init();
		}
		
		protected function init():void 
		{
			
		}
		
		public function bringToFront():void
		{
			this.parent.addChild(this);
		}
		
		protected function centerPivot():void
		{
			//this.pivotX = this.width / 2;
			//this.pivotY = this.height / 2;
			
			this.pivotX = this.width >> 1;
			this.pivotY = this.height >> 1;
		}
		
	}

}