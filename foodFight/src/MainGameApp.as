package  
{
	import external.LocalStorage;
	import flash.desktop.NativeApplication;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import gameConfig.ConfigurationData;
	import globals.MainGlobals;
	import storedGameData.SavedAppData;
	import storedGameData.SavedUserData;
	import urikatils.LoggerHandler;
	import user.User;
	
	/**
	 * ...
	 * @author Avrik
	 */
	
	public class MainGameApp
	{
		private static var _instance:MainGameApp = new MainGameApp();
		
		public static function get getInstance():MainGameApp
		{
			return _instance;
		}
		
		public function get appUser():User 
		{
			return _appUser;
		}
		
		public function get game():Game 
		{
			return _game;
		}
		
		private var _appUser:User;
		private var _game:Game;
		
		public function MainGameApp() 
		{
			
		}

		public function start(userData:SavedUserData=null):void
		{
			_appUser = new User(userData);
			startNewGame(true);
			
		}
		
		public function startNewGame(restoreLastGame:Boolean=false):void
		{
			LoggerHandler.getInstance.state(this," -- START NEW GAME --- ");
			
			removeLastGame();
			
			//var savedGameAppXml:XML = LocalStorage.loadSavedGame();
			var savedGameAppXml:XML
			CONFIG::mobile {
				
				savedGameAppXml = LocalStorage.loadSavedGame();
			}
			
			var savedAppData:SavedAppData = new SavedAppData(savedGameAppXml);
			
			_game = new Game();
			MainGlobals.mainPH.addChild(game.viewClass);
			//Application.mainPH.addChild(game.viewClass);
			
			//LoggerHandler.getInstance.info(this,"MY LAST SAVED GAME == " + savedGameAppXml);
			
			if (restoreLastGame && gameConfig.ConfigurationData.debugData.restoreLastGame && savedAppData.gameData)
			{
				game.translateBackFromData(savedAppData.gameData);
			} else
			{
				game.setNewGame();
			}
		}
		
		public function restartGame():void 
		{
			
		}
		
		private function removeLastGame():void 
		{
			if (_game)
			{
				_game.dispose();
				_game = null;
				saveGameApp();
			}
		}
		
		public function quit():void
		{
			CONFIG::mobile {
				NativeApplication.nativeApplication.exit(0);
			}
		}
		
		public function saveGameApp():void
		{
			var xmlDoc:XMLDocument = new XMLDocument('<?xml version="1.0" encoding="utf-8" ?>');
			var gameAppNode:XMLNode= new XMLNode(XMLNodeType.ELEMENT_NODE, "application");
			
			//gameAppNode.appendChild(user.getDataTranslateObject());
			gameAppNode.appendChild(_appUser.getDataTranslateObject());
			if (game)
			{
				gameAppNode.appendChild(game.getDataTranslateObject());
			}
			
			//gameAppNode.appendChild(playersManager.getDataTranslateObject());
			xmlDoc.appendChild(gameAppNode);
			
			CONFIG::mobile {
				LocalStorage.saveGame(xmlDoc.toString());
			}
			
			LoggerHandler.getInstance.state(this," -- GAME APP SAVED --- ");
		}
		
		
		
	}

}