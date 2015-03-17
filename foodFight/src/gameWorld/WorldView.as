package gameWorld 
{
	import flash.geom.Point;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import ui.ViewComponent;
	import utils.events.GlobalEventManger;
	import utils.events.GlobalEventsEnum;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class WorldView extends ViewComponent 
	{
		static public const ZOOM_COMPLETE:String = "zoomComplete";
		private var zoomTween:Tween;
		private var startPoint:Point;
		private var _zoomFactor:Number;
		
		public function WorldView() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			startPoint = new Point(this.x, this.y);
		}
		
		public function zoomIn(x:Number = 0, y:Number = 0, zoom:Number = 1.5):void
		{
			zoomTween = new Tween(this, .3, Transitions.LINEAR);
			

			zoomTween.moveTo(this.stage.stageWidth/3+(x*zoom* -1),this.stage.stageHeight/4+ (y*zoom) * -1);
			
			if (zoomFactor != zoom)
			{
				zoomTween.scaleTo(zoom);
			}
			
			
			
			zoomTween.onComplete = function():void
			{
				dispatchEvent(new Event(ZOOM_COMPLETE));
				Starling.juggler.remove(zoomTween);
			}
			_zoomFactor = zoom;

			Starling.juggler.add(zoomTween);
			
			
			dispatchEvent(new Event(ZOOM_COMPLETE));
		}
		
		public function zoomOut():void 
		{
			if (_zoomFactor != 1)
			{
				zoomTween = new Tween(this, .3, Transitions.LINEAR);
				zoomTween.scaleTo(1);
				
				zoomTween.moveTo(startPoint.x, startPoint.y);
				_zoomFactor = 1;

				Starling.juggler.add(zoomTween);
			}
		}
		
		public function get zoomFactor():Number 
		{
			return _zoomFactor;
		}
		
	}

}