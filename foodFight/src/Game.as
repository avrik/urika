package  
{
	import armies.ArmiesManager;
	import armies.UnitsController;
	import feathers.core.PopUpManager;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import gamePlay.DiplomacyManager;
	import gamePlay.Round;
	import gamePlay.WarManager;
	import gameWorld.World;
	import interfaces.IDisposable;
	import interfaces.IScene;
	import interfaces.IStorable;
	import newGameGenerator.NewGameGenerator;
	import players.PlayersManager;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import storedGameData.ISavedData;
	import storedGameData.SavedGameData;
	import ui.uiLayer.UILayer;
	import ui.ViewComponent;
	import ui.windows.gameOver.GameOverWindow;
	import urikatils.LoggerHandler;
	import utils.events.GlobalEventManger;
	import utils.events.GlobalEventsEnum;
	
	/**
	 * ...
	 * @author Avrik
	 */
	
	public class Game implements IDisposable, IStorable, IScene
	{
		public var uiLayer			:UILayer;
		
		public var playersManager	:PlayersManager;
		public var armiesManager	:ArmiesManager;
		
		private var _disableAll		:Boolean;
		
		private var _newGameGenerator:NewGameGenerator;
		private var _onRound		:Round;
		
		private var _world			:World;
		private var _view			:GameView;
		private var _onRoundNum		:int;
		public var savedGameData	:SavedGameData;
		
		private var _diplomacyManager:DiplomacyManager;
		private var _warManager:WarManager;
		//private var _unitsController:UnitsController;
		
		public function Game() 
		{
			world =	new World();
			uiLayer = new UILayer();
			_view = new GameView();
			_view.topLayerPH.addChild(uiLayer)
			_view.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			_view.removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		public function setNewGame():void 
		{
			_onRoundNum = 0;
			_newGameGenerator = new NewGameGenerator();
			_newGameGenerator.addEventListener(Event.COMPLETE, setGameComplete);
			view.addChild(_newGameGenerator);
		}
		
		private function setGameComplete(e:Event):void
		{
			_newGameGenerator.removeEventListeners();
			_newGameGenerator.removeFromParent(true);
			_newGameGenerator = null;
			startGame();
		}
		
		private function startGame(savedGameData:SavedGameData = null):void
		{
			LoggerHandler.getInstance.state(this, "start new game");
			
			armiesManager = new ArmiesManager();
			playersManager = new PlayersManager();
			_diplomacyManager = new DiplomacyManager();
			_warManager = new WarManager();
			//_unitsController = new UnitsController();
			
			uiLayer.activate();
			
			if (savedGameData)
			{
				LoggerHandler.getInstance.info(this,"RESTORE SAVED GAME");

				world.translateBackFromData(savedGameData.worldData)
				
				playersManager.translateBackFromData(savedGameData.playersData);
				playersManager.activatePlayers();
				playersManager.playersAreReady(false);
				
				nextRound();
				uiLayer.playersInfoBar.update();
			} else
			{
				GlobalEventManger.addEvent(GlobalEventsEnum.PLAYER_READY_FOR_PLAY, playersReady);
				playersManager.assignArmiesAndPlayers();
				
				disableAll = true;
			}
			
			view.addWorldView(world.view)
			world.activate();
			
			GlobalEventManger.addEvent(GlobalEventsEnum.ROUND_COMPLETE, roundComplete);
		}
		
		/*public function addToGamePlayLayer(obj:DisplayObject):void
		{
			view.gamePlayPH.addChild(obj);
		}*/
		
		private function playersReady():void 
		{
			LoggerHandler.getInstance.info(this,"PLAYER READY FOR START");
			GlobalEventManger.removeEvent(GlobalEventsEnum.PLAYER_READY_FOR_PLAY, playersReady);
			nextRound();
		}
		
		public function nextRound():void 
		{
			_onRoundNum++;
			_onRound = new Round();
			//_onRound.addEventListener(Event.COMPLETE, roundComplete);
			
			
		}
		
		private function roundComplete(e:Event):void 
		{
			LoggerHandler.getInstance.info(this,"ROUND COMPLTE");
			//_onRound.removeEventListeners();
			_onRound = null;
			//playersManager.setRoundComplete();
			
			if (!playersManager.userPlayer.alive || playersManager.activePlayers.length <=1)
			{
				gameOver();
			} else
			{
				this.nextRound();
			}
		}
		
		public function gameOver():void
		{
			var gameOverWindow:GameOverWindow = new GameOverWindow();
			PopUpManager.addPopUp(gameOverWindow);
		}
		
		public function set disableAll(value:Boolean):void 
		{
			LoggerHandler.getInstance.info(this,"DISABLE GAME === " + value);
			if (_disableAll != value)
			{
				_disableAll = value;
				_world.map.disable = value;
				//_world.view.touchable = !value;
				uiLayer.disable = value;
				armiesManager.disableAll = value;
				//playersManager.disable = value;
			}
		}
		
		public function get view():GameView 
		{
			return _view;
		}
		
		public function dispose():void 
		{
			GlobalEventManger.removeAllEvents();
			_onRound = null;
			
			armiesManager.removeAllArmies();
			armiesManager = null;
			
			if (playersManager)
			{
				playersManager.removeAll();
				playersManager = null;
			}
			
			if (world)
			{
				world.dispose();
				world = null;
			}
			
			if (uiLayer)
			{
				uiLayer.removeFromParent(true);
				uiLayer = null;
			}
			
			if (_view)
			{
				_view.removeFromParent(true);
				_view = null;
			}
		}
		
		/* INTERFACE interfaces.IStorable */
		
		public function getDataTranslateObject():XMLNode 
		{
			var gameNode:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "game");
			
			gameNode.appendChild(world.getDataTranslateObject());
			gameNode.appendChild(playersManager.getDataTranslateObject());
			return gameNode;
		}
		
		public function translateBackFromData(data:ISavedData):void 
		{
			var savedGameData:SavedGameData = data as SavedGameData;
			startGame(savedGameData);
		}
		
		/* INTERFACE interfaces.IScene */
		
		public function get viewClass():ViewComponent 
		{
			return _view as ViewComponent;
		}
		
		public function get world():World 
		{
			return _world;
		}
		
		public function set world(value:World):void 
		{
			_world = value;
		}
		
		public function get onRound():Round 
		{
			return _onRound;
		}
		
		public function get onRoundNum():int 
		{
			return _onRoundNum;
		}
		
		public function get disableAll():Boolean 
		{
			return _disableAll;
		}
		
		public function get diplomacyManager():DiplomacyManager 
		{
			return _diplomacyManager;
		}
		
		public function get warManager():WarManager 
		{
			return _warManager;
		}
		
		/*public function get unitsController():UnitsController 
		{
			return _unitsController;
		}*/

		
	}

}