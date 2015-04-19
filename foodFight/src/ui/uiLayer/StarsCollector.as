package ui.uiLayer 
{
	import assets.AssetsEnum;
	import assets.FontManager;
	import globals.MainGlobals;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.text.TextField;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class StarsCollector extends ViewComponent 
	{
		private var _starButn:Button;
		private var _starsAmount:int
		private var _amountTF:TextField
		private var _starTween:Tween;
		private var starImg:Image;
		
		public function StarsCollector() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			_starButn = new Button(MainGlobals.assetsManger.getTexture(AssetsEnum.RIBBON_GENERIC_BUTN));
			this.addChild(_starButn);
			
			centerPivot();
			
			_starButn.pivotX = _starButn.width / 2;
			_starButn.pivotY = _starButn.height / 2;
			
			starImg = new Image(MainGlobals.assetsManger.getTexture(AssetsEnum.STAR));
			starImg.pivotX = starImg.width / 2;
			starImg.pivotY = starImg.height / 2;
			
			
			
			addChild(starImg);
			
			//starImg.x = (starImg.width) / 2;
			//starImg.y = (starImg.height) / 2;
			
			_amountTF = new TextField(this.width, 50, "0", FontManager.Badaboom, -2, 0xfffc00);
			_amountTF.touchable = false;
			_amountTF.autoScale = true;
			
			_amountTF.pivotX = _amountTF.width / 2;
			_amountTF.pivotY = _amountTF.height / 2;
			
			addChild(_amountTF);
			
			_amountTF.y = (_starButn.height - _amountTF.height / 2) - 30;
		}
		
		public function get starsAmount():int 
		{
			return _starsAmount;
		}
		
		public function set starsAmount(value:int):void 
		{
			_starsAmount = value;
			//_amountTF.text = value.toString();
			
			
			_starTween = new Tween(starImg, .3, Transitions.EASE_OUT);
			_starTween.scaleTo(1.5);
			_starTween.reverse = true;
			_starTween.repeatCount = 2;
			_starTween.onComplete = function():void
			{
				_amountTF.text = _starsAmount.toString();
			}
			
			
			Starling.juggler.add(_starTween);
		}
		
		
		
	}

}