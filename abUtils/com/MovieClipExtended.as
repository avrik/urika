package com
{
	import com.eventUtils.EventManager;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Avrik Berman
	 */
	public class MovieClipExtended extends Sprite
	{
		//public var displayContainer:MovieClip;
		
		public function MovieClipExtended() 
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
		}
		
		private function addedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			//this.displayContainer = MovieClip(parent);
			this.init();
		}
		
		protected function init():void
		{
			
			
		}
		
		public function destroy():void
		{
			EventManager.clearEventsByDispatcher(this as IEventDispatcher);
		}
		
	}

}