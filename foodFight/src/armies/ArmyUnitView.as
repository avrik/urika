package armies 
{
	import armies.data.ArmyData;
	import assets.AssetsEnum;
	import assets.AssetsLoader;
	import assets.FontManager;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Graphics;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class ArmyUnitView extends ViewComponent 
	{
		static public const DESTROY_COMPLETE:String = "destroyComplete";
		
		private var _showClickArea	:Boolean;
		private var _totalTF		:TextField;
		private var _butn			:Button;
		private var _mySprite		:Sprite;
		private var _onScale		:Number = 1;
		private var armyData		:ArmyData;
		private var armyUnitMC		:MovieClip;
		private var _clickCircle	:Sprite;
		private var clickGraphics	:Graphics;
		private var spriteTween		:Tween;
		private var waitTween		:Tween;
		private var _startingScale	:Number = .4;
		private var _isClickable:Boolean;
		
		public function ArmyUnitView(armyData:ArmyData) 
		{
			this.armyData = armyData;
			
			armyUnitMC = AssetsLoader.getArmyUnitsMC();
			_mySprite = this.addChild(new Sprite) as Sprite;
			
			addClickableIndecator();
			
			var img:Image = new Image(armyUnitMC.getFrameTexture(armyData.id - 1));

			_butn = new Button(img.texture);
			_butn.alphaWhenDisabled = 1;
			
			_butn.pivotX = _butn.width / 2;
			_butn.pivotY = _butn.height/ 2;
			mySprite.addChild(_butn);
			
			_butn.scaleX = _butn.scaleY = _startingScale
			mySprite.y = -20;
			
			drawAmountIndecator();
		}
		
		private function addClickableIndecator():void 
		{
			_clickCircle = new Sprite();
			_clickCircle.visible = false;
			clickGraphics = new Graphics(_clickCircle);
			
			_mySprite.addChild(_clickCircle);
			
			clickGraphics.beginFill(0, .4);
			clickGraphics.drawCircle(0, 25, 45);
			clickGraphics.endFill();
		
			waitTween = new Tween(this._clickCircle, .6, Transitions.EASE_OUT_BACK);
			
			/*_clickCircle.alpha = 0.1;
			_clickCircle.scaleX = .5
			_clickCircle.scaleY = .2;
				
			this._mySprite.y = -20;
			
			waitTween = new Tween(this._clickCircle,.6,Transitions.EASE_OUT_BACK);
			waitTween.animate("scaleX", 1.2);
			waitTween.animate("scaleY", .8);
			waitTween.fadeTo(1);
			
			waitTween.repeatCount = int.MAX_VALUE;;
			waitTween.reverse = true;
			waitTween.repeatDelay = .2;*/
		}
		
		public function showBuildAnimation():void 
		{
			this._mySprite.scaleX = this._mySprite.scaleY = 0;
			spriteTween = new Tween(this._mySprite, .3, Transitions.EASE_OUT_BACK);
			spriteTween.scaleTo(1);

			Starling.juggler.add(spriteTween);
		}
		
		public function setClickable(value:Boolean, showCircle:Boolean = true, color:uint = 0):void
		{
			_isClickable = value;
			_butn.enabled = value;
			
			if (value)
			{
				_clickCircle.alpha = 0.1;
				_clickCircle.scaleX = .5
				_clickCircle.scaleY = .2;
			
				_clickCircle.visible = true;
				waitTween.reset(this._clickCircle,.5,Transitions.EASE_OUT_BACK);
				waitTween.animate("scaleX", 1.2);
				waitTween.animate("scaleY", .8);
				waitTween.fadeTo(1);
				
				//waitTween.repeatCount = int.MAX_VALUE;;
				//waitTween.reverse = true;
				waitTween.repeatDelay = .3;
				Starling.juggler.add(waitTween);
				
			} else
			{	
				_clickCircle.visible = false;
				Starling.juggler.remove(waitTween);
			}
		}
		
		private function scaleUnit(value:Number):void 
		{
			this._mySprite.scaleX = this._mySprite.scaleY = value;
		}
		
		private function drawAmountIndecator():void
		{
			_totalTF = new TextField(_butn.width, _butn.height, "0", FontManager.Badaboom, -1, 0xf8c500);
			_totalTF.autoScale = true;
			_totalTF.y = -10;
			_totalTF.hAlign = HAlign.CENTER;
			_totalTF.vAlign = VAlign.CENTER;
			_totalTF.touchable = false;
			_totalTF.pivotX = _totalTF.width / 2;
			_totalTF.pivotY = _totalTF.height / 2;

			this._mySprite.addChild(_totalTF);
		}
		
		public function downAnimation():void
		{
			scaleUnit(0)
			
			spriteTween = new Tween(this._mySprite, .4, Transitions.EASE_OUT_ELASTIC);
			spriteTween.scaleTo(this._onScale);
			
			Starling.juggler.add(spriteTween);
		}
		
		public function set showClickArea(value:Boolean):void 
		{
			_showClickArea = value;
			if (this._clickCircle)
			{
				if (value && _isClickable)
				{
					//this._clickCircle.visible = value;
					setClickable(true);
				}
				
				/*if (!value)
				{
					removeWaitAnimation();
				}*/
			}
		}
		
		public function destroyAnimation():void 
		{
			if (this._clickCircle)
			{
				this._clickCircle.visible = false;
			}

			var defeatImg:Image = new Image(TopLevel.assets.getTexture(AssetsEnum.DEFEAT_BALLOON));
			addChild(defeatImg);
			
			defeatImg.pivotX = defeatImg.width / 2;
			defeatImg.pivotY = defeatImg.height / 2;
			defeatImg.scaleX = defeatImg.scaleY = 0;
			
			var balloonTween:Tween = new Tween(defeatImg, .5, Transitions.EASE_OUT_BACK);
			balloonTween.scaleTo(1);

			balloonTween.onComplete = function():void
			{
				balloonTween = new Tween(defeatImg, .3, Transitions.EASE_OUT);
				balloonTween.scaleTo(1.2);
				balloonTween.fadeTo(0)
				
				Starling.juggler.add(balloonTween);
			}
			
			Starling.juggler.add(balloonTween);
			
			removeArmyUnit();
		}
		
		private function removeArmyUnit():void 
		{
			spriteTween = new Tween(this._mySprite, .6, Transitions.EASE_IN_BACK);
			spriteTween.delay = .3;
			spriteTween.scaleTo(0);
			spriteTween.onComplete = destroyComplete;

			Starling.juggler.add(spriteTween);
		}
		
		private function destroyComplete():void 
		{
			dispatchEvent(new Event(DESTROY_COMPLETE));
			GameApp.game.world.actionLayer.removeObject(this);
			
		}

		override public function dispose():void 
		{
			Starling.juggler.remove(spriteTween);
			mySprite.removeFromParent();
			butn.removeFromParent();
			_totalTF.removeFromParent();
			super.dispose();
		}
		
		public function setSoldiersNum(value:int):void 
		{
			if (totalTF) {
				totalTF.text = value?value.toString():"";
			}
		}
		
		public function setPicked(value:Boolean):void 
		{
			var num:int = value?(6 + armyData.id - 1):(armyData.id - 1);
			butn.upState = armyUnitMC.getFrameTexture(num);
			
			_totalTF.color = value?0xffffff:0xf8c500;
		}
			
		public function get totalTF():TextField 
		{
			return _totalTF;
		}
		
		public function get mySprite():Sprite 
		{
			return _mySprite;
		}
		
		public function get butn():Button 
		{
			return _butn;
		}
		
	}

}