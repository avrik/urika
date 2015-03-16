package game.payTable 
{
	import assets.FontManager;
	import game.HandChecker;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class PayTableWindow extends ViewComponent 
	{
		private var _PH:Sprite;
		private var _strips:Vector.<PayTableStrip>;
		
		private var tween:Tween;
		private var startY:Number;
		
		private var previewArr:Array = [
		
		
			[12,25],
			[12,25,11,24],
			[12,25,38],
			[8,22,10,37,12],
			[11,2,5,9,7],
			[12,25,38,11,24],
			[12,25,38,51],
			[8,9,10,11,12],
			[12,25,38,51,12],
		]
		
		public function PayTableWindow() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			//0xEBB035 yellow
			//0x06A2CB blue

			var black:Quad = new Quad(this.stage.stageWidth, stage.stageHeight, 0);
			addChild(black)
			black.alpha = .8;
			
			_PH = new Sprite();
			addChild(_PH);
			
			var bg:Quad = new Quad(this.stage.stageWidth, 800, 0xEBB035);
			var titleTF:TextField = new TextField(this.stage.stageWidth, 100, "PAY TABLE", FontManager.BubbleGum, -1,0xffffff);
			
			bg.y = -50;
			_PH.addChild(bg);
			
			var payTableStrip:PayTableStrip;
			
			_strips = new Vector.<PayTableStrip>;
			
			var handsArr:Array = HandChecker.getHandsByIndex();
			
			for (var i:int = 0; i < handsArr.length; ++i) 
			{
				payTableStrip = new PayTableStrip(i, handsArr[i], previewArr[i]);
				_PH.addChild(payTableStrip);
				
				payTableStrip.y = i * (payTableStrip.height);
				_strips.push(payTableStrip);
			}
			
			var closeButn:Button = new Button(Texture.empty(this.stage.stageWidth, this.stage.stageHeight));
			closeButn.addEventListener(Event.TRIGGERED, closeButnClicked);
			addChild(closeButn);
			
			_PH.addChild(titleTF);
			titleTF.y = -100;
		}
		
		public function show():void
		{
			_PH.alpha = 0;
			_PH.y = stage.stageHeight / 2 + 200;
			
			tween = new Tween(_PH, .8, Transitions.EASE_OUT_ELASTIC);
			tween.fadeTo(1);
			tween.animate("y", (this.stage.stageHeight - _PH.height) / 2);
			
			Starling.juggler.add(tween);
		}
		
		
		private function closeButnClicked(e:Event):void 
		{
			remove();
			//dispatchEvent(new Event(Event.CLOSE));
			
			//this.removeFromParent(true);
		}
		
		private function remove():void 
		{
			tween = new Tween(_PH, .3, Transitions.EASE_IN);
			//tween.fadeTo(0);
			tween.animate("y", -1500);
			tween.onComplete=close;
			
			Starling.juggler.add(tween);
		}
		
		private function close():void 
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
	}

}