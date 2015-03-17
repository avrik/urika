package game.board.boxes 
{
	import starling.events.Event;
	import flash.events.TransformGestureEvent;
	import mvc.View;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Graphics;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	import urikatils.LoggerHandler;

	
	/**
	 * ...
	 * @author Avrik
	 */
	public class BoxView extends View 
	{
		private var _butn:Button;
		private var _model:BoxModel;
		private var _moveTween:Tween;
		static public const HEIGHT:int = 120
		static public const WIDTH:int = HEIGHT
		static public const BOX_MOVE_COMPLETE:String = "boxMoveComplete";
		static public const BOX_MOVE_LEFT_COMPLETE:String = "boxMoveLeftComplete";
		static public const BOX_MOVE_RIGHT_COMPLETE:String = "boxMoveRightComplete";
		
		public function BoxView(boxModel:BoxModel) 
		{
			super();
			this._model = boxModel;
			
			
		}
		
		public function draw():void 
		{
			var graphics:Graphics = new Graphics(this);
			graphics.beginFill(this._model.color);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			graphics.endFill();
			
			_butn = new Button(Texture.empty(WIDTH, HEIGHT));
			//_butn.addEventListener(TouchEvent.TOUCH, boxTouch);
			addChild(_butn);
			
			addEventListener(TransformGestureEvent.GESTURE_SWIPE, boxSwiped);
		}
		
		public function slideLeft():void 
		{
			_moveTween = new Tween(this, .2, Transitions.EASE_OUT);
			_moveTween.moveTo(this.x - (WIDTH + 2), this.y);
			_moveTween.onComplete = slideLeftComplete;
			Starling.juggler.add(_moveTween);
		}
		
		private function slideLeftComplete():void 
		{
			Starling.juggler.remove(_moveTween);
			_moveTween = null;
			this.model.xPos--;
			dispatchEvent(new Event(BOX_MOVE_LEFT_COMPLETE));
		}
		
		
		
		public function slideRight():void 
		{
			_moveTween = new Tween(this, .2, Transitions.EASE_OUT);
			_moveTween.moveTo(this.x + (WIDTH + 2), this.y);
			_moveTween.onComplete = slideRightComplete;
			Starling.juggler.add(_moveTween);
		}
		
		private function slideRightComplete():void 
		{
			Starling.juggler.remove(_moveTween);
			_moveTween = null;
			this.model.xPos++;
			dispatchEvent(new Event(BOX_MOVE_RIGHT_COMPLETE));
		}
		
		
		
		private function boxSwiped(e:TransformGestureEvent):void 
		{
			trace("AAAA");
		}
		
		public function get model():BoxModel 
		{
			return _model;
		}
		
		/*private function boxTouch(e:TouchEvent):void 
		{
			LoggerHandler.getInstance.info(this,"BOX touch ");
			
		}*/
		
	}

}