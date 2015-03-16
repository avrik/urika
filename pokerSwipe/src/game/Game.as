package game
{
	import assets.AssetsEnum;
	//import com.purplebrain.adbuddiz.sdk.nativeExtensions.AdBuddizSDK;
	import game.Board;
	import game.cards.CardData;
	import game.hud.GameHud;
	import game.levels.Level;
	import game.levels.LevelData;
	import game.hud.GameHud;
	import game.hud.Hud_Timer;
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.text.TextField;
	import ui.MessageAdder;
	import ui.MessageParams;
	import ui.ScreenMessage;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Game extends EventDispatcher
	{
		private var _score:int;
		private var _board:Board;
		private var _hud:GameHud;
		private var _level:int = 0;
		private var _onLevel:Level
		private var _deck:Deck;
		private var _gameTimer:GameTimer;
		private var _preview:HandPreview;
		
		
	   
		public function Game() 
		{
			Tracer.alert("NEW GAME");
		}
		
		public function initGame():void
		{
			newBoard();
			setNewGameHud();
			
			newLevel();
			setNewDeck();
			
			_gameTimer = new GameTimer();
			_board.activate();

			_preview = new HandPreview();
			_preview.y = _board.y +_board.height + 50;
			Application.gamePH.addChild(_preview);
		}
		
		public function startGame():void
		{
			_gameTimer.startTimer();
		}
		
		
		private function setNewDeck():void 
		{
			_deck = new Deck();
		}
	
		public function newLevel():void
		{
			if (_level)
			{
				//MessageAdder.addMessage(new ScreenMessage("Deck " + _level + " completed!", new MessageParams(0xECB036, 0xffffff, -.5)), Application.gamePH.stage.stageWidth / 2, Application.gamePH.stage.stageHeight / 2 - 450);
				MessageAdder.addMessage(new ScreenMessage("Deck " + _level + " completed!", new MessageParams(0xffffff, 0xffffff, -.5)), Application.gamePH.stage.stageWidth / 2, Application.gamePH.stage.stageHeight / 2 - 450);
			}
			
			_level++;
			onLevel = new Level(_level, new LevelData(_level));
		}
		
		public function pauseGame():void
		{
			_board.disable = true;
			_gameTimer.pauseTimer = true;
		}
		
		public function unpauseGame():void
		{
			_board.disable = false;
			_gameTimer.pauseTimer = false;
		}
		
		private function setNewGameHud():void 
		{
			_hud = new GameHud();
			Application.gamePH.addChild(_hud);
		}
		
		public function newBoard():void
		{
			_board = new Board();
			Application.gamePH.addChild(_board);
		}
		
		public function reportActionComplete():void
		{
			if (_gameTimer.timeEnd)
			{
				gameOver();
			}
		}
		
		public function gameOver():void 
		{
			_hud.gameOver();
			Tracer.alert("GAME OVER");
			_board.touchable = false;
			_board.clearBoard();
			//_board.moveFloor();
			
			if (this._score > Application.highScore)
			{
				Application.saveHighScore(this._score);
			}
			
			Application.appHud.showNewGameButn();
			
			//MessageAdder.addMessage(new ScreenMessage("GAME OVER", new MessageParams(0xECB036, 0xffffff, -.5)), Application.gamePH.stage.stageWidth / 2, Application.gamePH.stage.stageHeight / 2 - 450);
		}
		
		public function dispose():void 
		{
			_preview.removeFromParent(true);
			_preview = null;
			
			_board.removeEventListeners();
			_board.removeFromParent(true);
			_board = null;
			
			_hud.removeEventListeners();
			_hud.removeFromParent(true);
			_hud = null;
		}
		
		public function calculateScore(amount:Number, is5inRow:Boolean=false):int 
		{
			Tracer.alert("SCORE === " + amount);
			Tracer.alert("IS % IN A ROW!!!! === " + is5inRow);
			if (is5inRow)
			{
				amount += 100;
			}
			//var totalScore:int = (amount * _onLevel.levelData.scoreFactor);
			//var totalScore:int = (amount + (amount * (_onLevel.levelData.scoreFactor * 10)));
			var totalScore:int = amount * _onLevel.levelData.scoreFactor;
			
			Tracer.alert("TOTAL ADD SCORE === " + totalScore);
			score += totalScore
			
			return totalScore
		}
		
		public function timeOver():void 
		{
			if (!_board.hold)
			{
				this.gameOver();
			}
		}
		
		public function clearPreview():void 
		{
			_preview.clearPreview();
		}
		public function addToHandPreview(cardData:CardData, index:int):void 
		{
			_preview.addToPreview(cardData,index);
			
		}
		
		public function get hud():GameHud 
		{
			return _hud;
		}
		
		public function get onLevel():Level 
		{
			return _onLevel;
		}
		
		public function get board():Board 
		{
			return _board;
		}
		
		public function get deck():Deck 
		{
			return _deck;
		}
		
		public function get level():int 
		{
			return _level;
		}
		
		public function set level(value:int):void 
		{
			_level = value;
			
		}
		
		public function get score():int 
		{
			return _score;
		}
		
		public function set score(value:int):void 
		{
			_score = value;
			_hud.updateScore(_score);
		}
		
		public function get gameTimer():GameTimer 
		{
			return _gameTimer;
		}
		
		public function set onLevel(value:Level):void 
		{
			_onLevel = value;
			_hud.updateLevel(value.id);
		}

		
	}

}