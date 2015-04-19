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
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class CoinsCollector extends ViewComponent 
	{
		
		private var _coinButn:Button;
		private var _coinsAmount:int
		private var _amountTF:TextField
		private var _coinTween:Tween;
		private var _coinImg:Image;
		
		public function CoinsCollector() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			_coinButn = new Button(MainGlobals.assetsManger.getTexture(AssetsEnum.RIBBON_GENERIC_BUTN));
			
			this.addChild(_coinButn);
			
			centerPivot();
			
			_coinButn.pivotX = _coinButn.width / 2;
			_coinButn.pivotY = _coinButn.height / 2;
			
			_coinImg = new Image(MainGlobals.assetsManger.getTexture(AssetsEnum.COIN));
			_coinImg.pivotX = _coinImg.width / 2;
			_coinImg.pivotY = _coinImg.height / 2;
			
			
			addChild(_coinImg);
			_coinImg.touchable = false;
			//starImg.x = (starImg.width) / 2;
			//starImg.y = (starImg.height) / 2;
			
			_amountTF = new TextField(this.width, 50, "0", FontManager.Badaboom, -2, 0xfffc00);
			_amountTF.touchable = false;
			_amountTF.autoScale = true;
			
			_amountTF.pivotX = _amountTF.width / 2;
			_amountTF.pivotY = _amountTF.height / 2;
			
			addChild(_amountTF);
			
			_amountTF.y = (_coinButn.height - _amountTF.height / 2) - 30;
		}
		
		/*public function get coinsAmount():int 
		{
			return _coinsAmount;
		}*/
		
		public function set coinsAmount(value:int):void 
		{
			_coinsAmount = value;
			_amountTF.text = value.toString();
		}
		
		public function reduceCoinsAmount(value:int):void
		{
			if (value)
			{
				_coinsAmount -= value;
				
				_coinTween = new Tween(_coinImg, .3, Transitions.EASE_OUT);
				_coinTween.scaleTo(1.5);
				_coinTween.reverse = true;
				_coinTween.repeatCount = 2;
				
				_coinTween.onComplete = function():void
				{
					//_amountTF.text = _coinsAmount.toString();
					_amountTF.color = 0xfffc00;
				}
				
				Starling.juggler.add(_coinTween);
				
				_amountTF.text = _coinsAmount.toString();
				_amountTF.color = Color.RED;
			}
		}
		
		public function addToCoinsAmount(value:int):void 
		{
			if (value)
			{
				_coinsAmount += value;
				
				_coinTween = new Tween(_coinImg, .3, Transitions.EASE_OUT);
				_coinTween.scaleTo(1.5);
				_coinTween.reverse = true;
				_coinTween.repeatCount = 2;
				
				_coinTween.onComplete = function():void
				{
					//_amountTF.text = _coinsAmount.toString();
				}
				
				Starling.juggler.add(_coinTween);
				
				_amountTF.text = _coinsAmount.toString();
			}
		}
		
	}

}