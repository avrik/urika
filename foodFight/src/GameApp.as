package  
{
	import external.LocalStorage;
	import flash.desktop.NativeApplication;
	//import flash.desktop.NativeApplication;
	import flash.system.System;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import storedGameData.SavedAppData;
	import storedGameData.SavedUserData;
	import user.User;
	
	/**
	 * ...
	 * @author Avrik
	 */
	
	public class GameApp
	{
		//TODO -- build map editor 							[ 80% DONE ]
		//TODO -- score logic 								[ 10% DONE ]
		//TODO -- defeat animations 						[ 60% DONE ]
		//TODO -- move all texts to xml 					[ 0% DONE ]
		//TODO -- texts & contenet	 						[ 20% DONE ]
		//TODO -- territoryInfo		 						[ 0% DONE ]
		//TODO -- tutorial			 						[ 0% DONE ]
		//TODO -- zoom by pinch	 							[ 0% DONE ]
		//TODO -- army bonuses								[ 50% DONE ]
		//TODO -- coins logic								[ 50% DONE ]
		//TODO -- reset game function						[ 20% DONE ] 
		//TODO -- + bonus/exp animation						[ 0% DONE ]  design
		//TODO -- achivments								[ 0% DONE ]  design
		//TODO -- shop										[ 20% DONE ] design
		//TODO -- game over screen							[ 20% DONE ] design
		
		
		//TODO #2 -- SD/HD assets for diffrent resulotions
		//TODO #2 -- sounds
		//TODO #2 -- animations
		//TODO #2 -- QA
		//TODO #2 -- Switch all assets from PNG to ATF
		//TODO #2 -- preformence
		
		//TODO #3 -- facebook features version
		
		
		//BUGS
		
		// problem with the move action and marking the new clickable army units
		// when player is out of the game, the game stuck (maybe the last player in the ui)
		// coins amount not right
		// 
		
		public static var appUser:User;
		public static var game:Game;
		
		public function GameApp() 
		{
			
		}

		public static function start(userData:SavedUserData=null):void
		{
			appUser = new User(userData);
			startNewGame(true);
			
		}
		
		public static function startNewGame(restoreLastGame:Boolean=false):void
		{
			removeLastGame();
			
			//var savedGameAppXml:XML = LocalStorage.loadSavedGame();
			var savedGameAppXml:XML
			CONFIG::mobile {
				
				savedGameAppXml = LocalStorage.loadSavedGame();
			}
			
			var savedAppData:SavedAppData = new SavedAppData(savedGameAppXml);
			
			game = new Game();
			TopLevel.mainPH.addChild(game.viewClass);
			
			//Tracer.alert("MY LAST SAVED GAME == " + savedGameAppXml);
			
			if (restoreLastGame && ConfigurationData.debugData.restoreLastGame && savedAppData.gameData)
			{
				game.translateBackFromData(savedAppData.gameData);
			} else
			{
				game.setNewGame();
			}
		}
		
		static public function restartGame():void 
		{
			
		}
		
		static private function removeLastGame():void 
		{
			if (game)
			{
				game.dispose();
				game = null;
				saveGameApp();
			}
		}
		
		public static function quit():void
		{
			CONFIG::mobile {
				NativeApplication.nativeApplication.exit(0);
			}
		}
		
		public static function saveGameApp():void
		{
			var xmlDoc:XMLDocument = new XMLDocument('<?xml version="1.0" encoding="utf-8" ?>');
			var gameAppNode:XMLNode= new XMLNode(XMLNodeType.ELEMENT_NODE, "application");
			
			//gameAppNode.appendChild(user.getDataTranslateObject());
			gameAppNode.appendChild(appUser.getDataTranslateObject());
			if (game)
			{
				gameAppNode.appendChild(game.getDataTranslateObject());
			}
			
			//gameAppNode.appendChild(playersManager.getDataTranslateObject());
			xmlDoc.appendChild(gameAppNode);
			
			CONFIG::mobile {
				LocalStorage.saveGame(xmlDoc.toString());
			}
			
			Tracer.alert(" -- GAME APP SAVED --- ");
		}
		
		
		
	}

}