package game.hud 
{
	import assets.AssetsEnum;
	import assets.FontManager;
	import flash.display.Bitmap;
	import flash.globalization.LocaleID;
	import flash.globalization.NumberFormatter;
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import ui.ViewComponent;
	import ui.Windicator;
	
	/**
	 * ...
	 * @author Avrik
	 */
	
	public class GameHud extends ViewComponent
	{
		private var _timer:Hud_Timer;
		private var _scoreTF:TextField;
		private var _highScoreTF:TextField;

		private var _pauseButn:Button;
		private var _payTableButn:Button;
		private var _onPause:Boolean;
		private var butnsMC:MovieClip;
		private var tween:Tween;
		private var _levelTF:TextField;
		private var _leftTF:TextField;
		private var _scoreDelay:DelayedCall;
		private var _targetScore:int;
		private var _score:int;
		private var formatter:NumberFormatter 
		
		public function GameHud() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			formatter = new NumberFormatter(LocaleID.DEFAULT);
			formatter.fractionalDigits = 0;
			formatter.leadingZero = true;
			formatter.trailingZeros = true;
			
			_timer = new Hud_Timer();
			
			var c:uint = 0xEBB035;
			var c2:uint = 0xffffff;
			var font:String = FontManager.BubbleGum;
			
			_scoreTF = new TextField(stage.stageWidth-10, 100, "0",font , -1, c2);
			_scoreTF.hAlign = HAlign.RIGHT;

			//_scoreTF.x = stage.x + 5;
			_scoreTF.y = stage.y + 10;
			
			addChild(_scoreTF);
			
			_highScoreTF = new TextField(stage.stageWidth-10, 100, formatter.formatUint(Application.highScore), font, -.5, c);
			_highScoreTF.hAlign = HAlign.RIGHT;
			//_highScoreTF.x = stage.x;
			_highScoreTF.y = stage.y + 60;
			addChild(_highScoreTF);
			
			_levelTF = new TextField(stage.stageWidth - 10, 100, "1", font, -1, c2);
			_levelTF.hAlign = HAlign.LEFT;
			_levelTF.x = stage.x + 5;
			_levelTF.y = _scoreTF.y
			
			_leftTF = new TextField(stage.stageWidth - 10, 100, "1", font, 32, c);
			_leftTF.hAlign = HAlign.LEFT;
			_leftTF.x = stage.x + 5;
			_leftTF.y = stage.y + 60;
			
			addChild(_leftTF);
			addChild(_levelTF);
			
			addChild(_timer);
			
			_timer.x = (stage.stageWidth-_timer.width) / 2;
			_timer.y = _leftTF.y + _leftTF.height + 120;
			
			butnsMC = new MovieClip(TopLevel.assets.getTextureAtlas(AssetsEnum.BUTNS_SS).getTextures());
			
			_payTableButn = new Button(butnsMC.getFrameTexture(3));
			_payTableButn.addEventListener(Event.TRIGGERED, payTableClick);
			_payTableButn.x = stage.stageWidth - (_payTableButn.width + 20);
			_payTableButn.y = stage.stageHeight - (_payTableButn.height + 30);
			
			addChild(_payTableButn);
			
			_pauseButn = new Button(butnsMC.getFrameTexture(1));
			_pauseButn.addEventListener(Event.TRIGGERED, pauseClick);
			//_pauseButn.pivotX = _pauseButn.width >> 1;
			//_pauseButn.pivotY = _pauseButn.height >> 1;
			//_pauseButn.x = stage.stageWidth / 2;
			_pauseButn.x = stage.x + 20;

			_pauseButn.y = stage.stageHeight - (_pauseButn.height + 30);
			_pauseButn.scaleWhenDown = .9;
			_pauseButn.scaleX = _pauseButn.scaleY = 0;

			addChild(_pauseButn);
			
			tween = new Tween(_pauseButn, .3, Transitions.EASE_OUT_BACK);
			tween.scaleTo(1);
			
			Starling.juggler.add(tween);
		}
		
		private function payTableClick(e:Event):void 
		{
			Application.openPayTableWindow();
		}
		
		private function pauseClick(e:Event):void 
		{
			_onPause = !_onPause;
			_pauseButn.upState = butnsMC.getFrameTexture(_onPause?2:1);
			
			if (_onPause)
			{
				Application.game.pauseGame();
			} else
			{
				Application.game.unpauseGame();
			}
			
		}
		
		public function get timer():Hud_Timer 
		{
			return _timer;
		}
		
		
		
		public function updateCardsLeft(value:int):void
		{
			_leftTF.text = value + " Cards left";
		}
		
		public function updateLevel(value:int):void
		{
			var factorStr:String = "";
			
			/*if (Application.game.onLevel && Application.game.onLevel.levelData.scoreFactor>1)
			{
				factorStr = " (x " + Application.game.onLevel.levelData.scoreFactor + ")";
			}*/
			_levelTF.text = "Deck " + value.toString() + factorStr;
		}
		
		public function updateScore(value:int):void
		{
			/*if (_scoreDelay)
			{
				score = _targetScore;
			}
			_scoreDelay = new DelayedCall(scoreElapse, 0.01)
			_scoreDelay.repeatCount = value;
			
			
			_targetScore = value;
			_scoreTF.text = formatter.formatUint(value);
			
			Starling.juggler.add(_scoreDelay);*/
			//score = value;
			
			tween = new Tween(_scoreTF, .2, Transitions.EASE_OUT);
			tween.scaleTo(1.1);
			tween.moveTo(_scoreTF.x - 70,_scoreTF.y - 5);
			
			tween.reverse = true;
			tween.repeatCount = 2;
			tween.onComplete = function():void
			{
				//scoreTF.color = 0xEBB035;
			}
			tween.onRepeat = function():void
			{
				//Tracer.alert("REPEAT === " + tween.repeatCount);
				//_scoreTF.color = 0xffffff;
				
				score = value;
			}
			
			Starling.juggler.add(tween);
		}
		
		private function scoreElapse():void 
		{
			if (_scoreDelay.isComplete)
			{
				Starling.juggler.remove(_scoreDelay);
				_scoreDelay = null;
			}
			score++;
		}
		
		public function get scoreTF():TextField 
		{
			return _scoreTF;
		}
		
		public function get score():int 
		{
			return _score;
		}
		
		public function set score(value:int):void 
		{
			
			_score = value;
			_scoreTF.text = formatter.formatUint(value)
		}
		
		
		
		public function gameOver():void 
		{
			_pauseButn.visible = false;
		}
		
		public function showWindicator(x:Number, y:Number, winScore:int,handName:String):void
		{
			var windicator:Windicator = new Windicator(winScore, handName);
			addChild(windicator);
			
			windicator.x = x;
			windicator.y = y;
			
			var _tween:Tween = new Tween(windicator, 1, Transitions.EASE_IN);
			_tween.moveTo(this.scoreTF.bounds.right, this._scoreTF.y+this._scoreTF.height/2);
			_tween.delay = .5;
			
			_tween.onComplete = function():void
			{
				score += winScore;
				windicator.removeFromParent(true);
				
			}
			
			Starling.juggler.add(_tween);
		}
		
		
		
	}

}