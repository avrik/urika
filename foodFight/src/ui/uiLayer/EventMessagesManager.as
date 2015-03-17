package ui.uiLayer 
{
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.utils.Color;
	import ui.ViewComponent;
	/**
	 * ...
	 * @author Avrik
	 */
	public class EventMessagesManager extends ViewComponent
	{
		private var _messages:Vector.<EventMessage> = new Vector.<EventMessage>;
		private var tween:Tween;
		
		
		
		public function EventMessagesManager() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
				
			var quad:Quad = new Quad(500, 50, 0);
			quad.alpha = .2;
			
			addChild(quad);
			
			this.touchable = false;
		}
		
		public function addEventMessage(txt:String, color:uint = Color.WHITE):void
		{
			if (_messages.length)
			{
				for each (var item:EventMessage in _messages) 
				{
					item.moveUp();
				}
			}
			var message:EventMessage = new EventMessage(txt, color);
			addChild(message)
			_messages.push(message);
			
			message.alpha = 0;
			//message.y = 30;
			
			tween = new Tween(message, 1, Transitions.EASE_OUT);
			//tween.moveTo(0, 0);
			tween.fadeTo(1);
			tween.onComplete = function():void
			{
				var tween2:Tween = new Tween(message, 1, Transitions.EASE_OUT);
				//tween2.moveTo(message.x, message.y - 20);
				tween2.delay = 6;
				tween2.fadeTo(0);
				tween2.onComplete = removeMessage;
				tween2.onCompleteArgs = [message];
				Starling.juggler.add(tween2);
			}
			
			Starling.juggler.add(tween);
			//Starling.juggler.add(new DelayedCall(removeMessage, 3, [message]));
		}
		
		private function removeMessage(message:EventMessage):void 
		{
			message.removeEventListeners();
			message.removeFromParent();
			
			
			_messages.splice(_messages.indexOf(message), 1);
		}
		
	}

}