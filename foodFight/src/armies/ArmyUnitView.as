package armies 
{
	import armies.data.ArmyData;
	import assets.AssetsEnum;
	import assets.AssetsLoader;
	import assets.FontManager;
	import globals.MainGlobals;
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
		private var _onFocus:Boolean;
		
		private var _showClickArea	:Boolean;
		private var _totalTF		:TextField;
		//private var _butn			:Button;
		private var _mainSprite		:Sprite;
		private var _onScale		:Number = 1;
		private var armyData		:ArmyData;
		private var armyUnitMC		:MovieClip;
		private var _clickCircle	:Sprite;
		private var clickGraphics	:Graphics;
		private var spriteTween		:Tween;
		private var waitTween		:Tween;
		private var _startingScale	:Number = .4;
		//private var _isClickable:Boolean;
		private var _armyUnit:ArmyUnit;
		private var _healthBar:Sprite;
		private var _unitImage:Image;
		private var _pauseAnimations:Boolean;
		private var _startY:Number;
		
		public function ArmyUnitView(armyUnit:ArmyUnit, armyData:ArmyData) 
		{
			this._armyUnit = armyUnit;
			this.armyData = armyData;
			
			armyUnitMC = AssetsLoader.getArmyUnitsMC();
			_mainSprite = this.addChild(new Sprite) as Sprite;
			
			_unitImage = new Image(armyUnitMC.getFrameTexture(armyData.id - 1));
			_mainSprite.addChild(_unitImage)

			_unitImage.scaleX = _unitImage.scaleY = _startingScale
			_startY = _unitImage.y 
			//this.y = -50;
			_unitImage.alignPivot();
			
			_healthBar = new Sprite();
			_healthBar.y = this.bounds.top;
			mySprite.addChild(_healthBar);
			
			//drawAmountIndecator();
			this.touchable = false;
			alignPivot();
			
			_mainSprite.y = -40;
		}
		
		public function addClickableIndecator():void 
		{
			_clickCircle = new Sprite();
			_clickCircle.visible = false;
			clickGraphics = new Graphics(_clickCircle);
			
			_mainSprite.addChild(_clickCircle);
			
			clickGraphics.beginFill(0, .4);
			clickGraphics.drawCircle(0, 25, 45);
			clickGraphics.endFill();
		
			_unitImage.alpha = .8;
			//waitTween = new Tween(this._clickCircle, .6, Transitions.EASE_OUT_BACK);
			waitTween = new Tween(_unitImage, .3, Transitions.EASE_OUT);
			waitTween.fadeTo(1)
			waitTween.moveTo(_unitImage.x, _unitImage.y - 10);
			waitTween.reverse = true;
			waitTween.repeatDelay = .2
			waitTween.repeatCount = 0;
			
			Starling.juggler.add(waitTween);
		}
		
		public function continueAnimation():void 
		{
			Starling.juggler.add(waitTween);
			//_pauseAnimations = false;
		}
		
		public function stopAnimation():void 
		{
			//_pauseAnimations = true;
			//_unitImage.y = _startY;
			Starling.juggler.remove(waitTween);
		}
		
		public function showBuildAnimation():void 
		{
			this._mainSprite.scaleX = this._mainSprite.scaleY = 0;
			spriteTween = new Tween(this._mainSprite, .3, Transitions.EASE_OUT_BACK);
			spriteTween.scaleTo(1);

			Starling.juggler.add(spriteTween);
		}

		private function scaleUnit(value:Number):void 
		{
			this._mainSprite.scaleX = this._mainSprite.scaleY = value;
		}
		
		private function drawAmountIndecator():void
		{
			//_totalTF = new TextField(_butn.width, _butn.height, "0", FontManager.Badaboom, -1, 0xf8c500);
			_totalTF = new TextField(_unitImage.width, _unitImage.height, "0", FontManager.Badaboom, -1, 0xf8c500);
			_totalTF.autoScale = true;
			_totalTF.y = -10;
			_totalTF.hAlign = HAlign.CENTER;
			_totalTF.vAlign = VAlign.CENTER;
			_totalTF.touchable = false;
			_totalTF.pivotX = _totalTF.width / 2;
			_totalTF.pivotY = _totalTF.height / 2;

			this._mainSprite.addChild(_totalTF);
		}
		
		public function downAnimation():void
		{
			scaleUnit(0)
			
			spriteTween = new Tween(this._mainSprite, .4, Transitions.EASE_OUT_ELASTIC);
			spriteTween.scaleTo(this._onScale);
			
			Starling.juggler.add(spriteTween);
		}
		
		public function set showClickArea(value:Boolean):void 
		{
			_showClickArea = value;
			if (this._clickCircle)
			{
				/*if (value && _isClickable)
				{
					//this._clickCircle.visible = value;
					setClickable(true);
				}*/
				
				/*if (!value)
				{
					removeWaitAnimation();
				}*/
			}
		}
		
		public function destroyAnimation():void 
		{
			MainGameApp.getInstance.game.world.actionLayer.removeArmyUnitFromAction(this)
			
			if (this._clickCircle)
			{
				this._clickCircle.visible = false;
			}

			var defeatImg:Image = new Image(MainGlobals.assetsManger.getTexture(AssetsEnum.DEFEAT_BALLOON));
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
			spriteTween = new Tween(this._mainSprite, .6, Transitions.EASE_IN_BACK);
			spriteTween.delay = .3;
			spriteTween.scaleTo(0);
			spriteTween.onComplete = destroyComplete;

			Starling.juggler.add(spriteTween);
		}
		
		private function destroyComplete():void 
		{
			dispatchEvent(new Event(DESTROY_COMPLETE));
			MainGameApp.getInstance.game.world.actionLayer.removeObject(this);
			
		}

		override public function dispose():void 
		{
			if (_unitImage)
			{
				_unitImage.removeFromParent(true);
				_unitImage = null;
			}
			Starling.juggler.remove(spriteTween);
			mySprite.removeFromParent();
			//butn.removeFromParent();
			//_totalTF.removeFromParent();
			super.dispose();
		}
		
		public function setSoldiersNum(value:int):void 
		{
			if (totalTF) {
				totalTF.text = value?value.toString():"";
			}
		}
		
		/*public function setPicked(value:Boolean):void 
		{
			var num:int = value?(6 + armyData.id - 1):(armyData.id - 1);
			butn.upState = armyUnitMC.getFrameTexture(num);
			
			_totalTF.color = value?0xffffff:0xf8c500;
		}*/
		
		public function showHealthBar(value:int):void 
		{
			for (var i:int = 0; i < 10; i++) 
			{
				showHealthBox(i,i<=value?true:false);
			}
			
			_healthBar.alignPivot(HAlign.CENTER,VAlign.TOP);
		}
		
		
		
		private function showHealthBox(num:int,filled:Boolean):void
		{
			var sprite:Sprite = new Sprite();
			var g:Graphics = new Graphics(sprite);
			_healthBar.addChild(sprite);
			g.clear();
			//g.lineStyle(1, 0);
			g.beginFill(filled?0x00ff00:0);
			g.drawRect(0, 0, 5, 8);
			g.endFill();
			g.lineStyle(1, 0);
			g.moveTo(0, 8);
			g.lineTo(5, 8);
			
			
			sprite.x = num * 5;
		}
			
		public function get totalTF():TextField 
		{
			return _totalTF;
		}
		
		public function get mySprite():Sprite 
		{
			return _mainSprite;
		}
		
		/*public function get butn():Button 
		{
			return _butn;
		}*/
		
		public function get armyUnit():ArmyUnit 
		{
			return _armyUnit;
		}
		
		public function set onFocus(value:Boolean):void 
		{
			_onFocus = value;
			_healthBar.visible = value;
		}
		
	}

}