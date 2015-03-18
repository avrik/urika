package  
{
	import assets.FontManager;
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
	public class StartWindow extends ViewComponent 
	{
		static public const REMOVED:String = "StartWindowRemoved";
		private var _firstTime:Boolean;
		private var _tf:TextField;
		private var _butn:Button;
		private var tween:Tween;
		
		private var _PH:Sprite = new Sprite();
		private var darken:Quad;
		
		public function StartWindow() 
		{
			//this._firstTime = firstTime;
		}
		
		override protected function init():void 
		{
			super.init();
			
			var quad:Quad = new Quad(stage.stageWidth, 200, 0xDD1E2E);
			darken = new Quad(stage.stageWidth, stage.stageHeight, 0);
			darken.alpha = .2;
			addChild(darken);
			
			addChild(_PH);
			
			_PH.addChild(quad);
			
			//var str:String = this._firstTime?"Tap to start":"try Again";
			_tf = new TextField(_PH.width, _PH.height, "", FontManager.BubbleGum, -1,0xECB036);
			
			_PH.addChild(_tf);
			
			_butn = new Button(Texture.empty(this.width, this.height));
			
			addChild(butn);
		}
		
		public function show(str:String):void
		{
			_tf.text = str;
			_PH.alpha = 0;
			_PH.y = stage.stageHeight / 2+200;
			
			tween = new Tween(_PH, .8, Transitions.EASE_OUT_ELASTIC);
			tween.fadeTo(1);
			tween.animate("y", _PH.y - 200);
			
			Starling.juggler.add(tween);
			
			var tween2:Tween = new Tween(darken, .4);
			tween2.fadeTo(.2);
			Starling.juggler.add(tween2);
		}
		
		public function remove():void
		{
			tween = new Tween(_PH, .4, Transitions.EASE_IN_BACK);
			tween.animate("y", _PH.stage.y - 200);
			tween.onComplete = function():void
			{
				dispatchEvent(new Event(REMOVED));
			}
			
			Starling.juggler.add(tween);
			
			var tween2:Tween = new Tween(darken, .4);
			tween2.fadeTo(0);
			Starling.juggler.add(tween2);
		}
		
		public function get butn():Button 
		{
			return _butn;
		}
		
	}

}