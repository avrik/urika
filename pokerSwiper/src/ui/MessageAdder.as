package ui 
{
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	/**
	 * ...
	 * @author Avrik
	 */
	public class MessageAdder 
	{
		
		public function MessageAdder() 
		{
			

		}
		
		public static function addMessage(message:ScreenMessage, x:Number = -1, y:Number = -1,delay:Number=0):void
		{
			Application.gamePH.addChild(message);
			
			message.x = x == -1?(Application.gamePH.stage.stageWidth) / 2:x;
			message.y = y == -1?(Application.gamePH.stage.stageHeight) / 2 - 350:y;
			message.alpha = 0;
			message.scaleX = message.scaleY = .6;
			
			//var tween:Tween = new Tween(message, .5, Transitions.EASE_OUT_BACK);
			var tween:Tween = new Tween(message, .3, Transitions.EASE_OUT);
			tween.fadeTo(1);
			tween.delay = delay;
			tween.scaleTo(1);
			tween.animate("y", message.y - 50);
			tween.reverse = true;
			tween.repeatCount = 2;
			tween.repeatDelay = .8;
			//tween.onComplete = removeMessage;
			tween.onComplete = function():void
			{
				message.removeFromParent(true);
			}
			tween.onCompleteArgs = [message];
			
			Starling.juggler.add(tween);
		}
		
		static private function removeMessage(message:ScreenMessage):void 
		{
			//var tween:Tween = new Tween(message, .5, Transitions.EASE_IN_BACK);
			var tween:Tween = new Tween(message, .3, Transitions.EASE_IN);
			tween.delay = .3;
			tween.fadeTo(0);
			tween.animate("y", message.y - 150);
			tween.onComplete = function():void
			{
				message.removeFromParent(true);
			}
			
			Starling.juggler.add(tween);
		}
		
	}

}