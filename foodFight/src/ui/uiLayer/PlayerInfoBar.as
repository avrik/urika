package ui.uiLayer 
{
	import assets.AssetsEnum;
	import assets.FontManager;
	import feathers.core.PopUpManager;
	import players.Player;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class PlayerInfoBar extends ViewComponent
	{

		private var _player:Player;
		private var allianceRequestWindow:AllianceRequestAnswerWindow;


		public function PlayerInfoBar(player:Player) 
		{
			this._player = player;

			
		}
		
		override protected function init():void 
		{
			super.init();
			
			addChild(new Image(TopLevel.assets.getTexture(AssetsEnum.RIBBON_INFO_BAR)));
			addInfoTab("INFO", 0, ["flavor: " + _player.army.armyData.name, "status: " + _player.getMyStatus()]);
			addInfoTab("ARMY", 250, ["soldiers: " + _player.army.getSoldiersNumber()]);
			addInfoTab("ASSETS", 500, ["coins: " + _player.coinsAmount + "(" + _player.getTotalTerritoryCoinsNumber() + ")"]);
			addInfoTab("LAND", 750, ["territories: " + _player.territories.length, "Capital linked: " + _player.linkedToCapitalArr.length]);
			
			var names:String = "";
			
			var arr:Vector.<Player> = GameApp.game.diplomacyManager.getMyAllies(_player);
			var length:int = arr.length;
			var alliesStr:String = "";
			if (length)
			{
				for (var i:int = 0; i <length ; i++) 
				{
					names += arr[i].army.armyData.name
					if (i < (length-1)) names += ",";
				}
				
				alliesStr = "allies: " + names;
			}
			
			addInfoTab("DIPLOMACY", 1000, ["", alliesStr ]);
			
			if (_player != GameApp.game.playersManager.userPlayer)
			{
				//var isAllied:Boolean = GameApp.game.playersManager.userPlayer.diplomacy.isAlly(this._player);
				var isAllied:Boolean = GameApp.game.diplomacyManager.areAllies(GameApp.game.playersManager.userPlayer, this._player);
				if (!GameApp.game.playersManager.userPlayer.allies.length || isAllied)
				{
					var butn:Button = new Button(Texture.empty(240, 100), isAllied?"CANCEL ALLIANCE": "OFFER ALLIANCE");
					butn.fontName = FontManager.Badaboom;
					butn.fontSize = -1;
					butn.fontColor = 0xffffff;
					butn.x = 1000;
					butn.y = -10;
					butn.addEventListener(Event.TRIGGERED, isAllied?cancelAllianceClick:offerAllianceClick);
					addChild(butn);
					
					if (GameApp.game.playersManager.userPlayer.diplomacyLeft <= 0 || GameApp.game.disableAll)
					{
						butn.enabled = false;
					}
				}
			}
			
		}
		
		private function cancelAllianceClick(e:Event):void 
		{
			GameApp.game.playersManager.userPlayer.diplomacyLeft--;
			GameApp.game.diplomacyManager.cancelAllianceByPlayer(this._player);
			close()
		}
		
		private function offerAllianceClick(e:Event):void 
		{
			var accept:Boolean = _player.allianceRequest(GameApp.game.playersManager.userPlayer);
			
			GameApp.game.playersManager.userPlayer.diplomacyLeft--;
			if (accept)
			{
				//GameApp.game.playersManager.userPlayer.setNewAlliance(this._player);
				GameApp.game.diplomacyManager.addNewAlliance(GameApp.game.playersManager.userPlayer, _player);
			}
			
			allianceRequestWindow = new AllianceRequestAnswerWindow(accept,GameApp.game.playersManager.userPlayer,_player);
			allianceRequestWindow.addEventListener(Event.CLOSE, allianceRequestWindowClosed);
			PopUpManager.addPopUp(allianceRequestWindow);
			
			close();
		}
		
		private function close():void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function allianceRequestWindowClosed(e:Event):void 
		{
			var allianceRequestWindow:AllianceRequestAnswerWindow = e.currentTarget as AllianceRequestAnswerWindow;
			PopUpManager.removePopUp(allianceRequestWindow);
			allianceRequestWindow.removeEventListeners();
			allianceRequestWindow.removeFromParent(true);
			
		}
		
		private function addInfoTab(title:String, x:Number, infoArr:Array):void
		{
			var tf:TextField = new TextField(240, 100, title, FontManager.Badaboom, -1, 0xffffff);
			tf.touchable = false;
			tf.y = -50;
			tf.x = x;
			addChild(tf);
			
			var tf2:TextField
			for (var i:int = 0; i < infoArr.length; ++i) 
			{
				tf2 = new TextField(240, 100, infoArr[i], FontManager.Badaboom, -1, 0xffff00);
				tf2.touchable = false;
				tf2.x = x;
				tf2.y = i * 30 - 10;
				addChild(tf2);
			}
		}
		
		public function get player():Player 
		{
			return _player;
		}

		
	}

}