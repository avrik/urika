package ui.uiLayer 
{
	import players.Player;
	import starling.display.Sprite;
	import starling.events.Event;
	import ui.ViewComponent;
	import utils.events.GlobalEventManger;
	import utils.events.GlobalEventsEnum;
	/**
	 * ...
	 * @author Avrik
	 */
	public class PlayersRibbon extends ViewComponent
	{
		private var playersInfoDisplayArr:Vector.<PlayerInfoDisplay> = new Vector.<PlayerInfoDisplay>;
		private var playerInfoBar:PlayerInfoBar
		private var playersBoxHolder:Sprite;
		
		public function PlayersRibbon() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			playersBoxHolder = new Sprite();
			if (GameApp.game.playersManager.playersArr.length)
			{
				this.setPlayersDisplay();
			}
			
			GlobalEventManger.addEvent(GlobalEventsEnum.ACTION_LAYER_CLICKED, removePlayerInfo);
		}
		
		private function setPlayersDisplay():void 
		{
			addChild(playersBoxHolder);
			var playerBox:PlayerInfoDisplay;
			for (var i:String in GameApp.game.playersManager.playersArr) 
			{
				playerBox = new PlayerInfoDisplay(GameApp.game.playersManager.playersArr[i]);
				playersBoxHolder.addChild(playerBox);
			
				playerBox.x = (parseInt(i) * (playerBox.onBox.width + 20)) + 50;
				playerBox.y = 35;
				playerBox.addEventListener(Event.SELECT, playerInfoSelected);
				playersInfoDisplayArr.push(playerBox);
			}
			
		}
		
		private function playerInfoSelected(e:Event):void 
		{
			var playerBox:PlayerInfoDisplay = e.currentTarget as PlayerInfoDisplay;

			
			if (!playerInfoBar || playerBox.player.id != playerInfoBar.player.id)
			{
				removePlayerInfo();
				showPlayerInfo(playerBox.player);
			} else
			{
				removePlayerInfo();
			}
			
		}
		
		private function removePlayerInfo():void 
		{
			if (playerInfoBar)
			{
				playerInfoBar.removeEventListeners();
				playerInfoBar.removeFromParent(true);
				playerInfoBar = null;
			}
		}
		
		private function showPlayerInfo(player:Player):void 
		{
			playerInfoBar = new PlayerInfoBar(player);
			playerInfoBar.addEventListener(Event.CLOSE, closePlayerInfo);
			addChild(playerInfoBar);
			playerInfoBar.x = -35;
			playerInfoBar.y = -130;
			
			addChild(playersBoxHolder);
		}
		
		private function closePlayerInfo(e:Event):void 
		{
			removePlayerInfo();
		}
			
		public function update(num:int = -1):void
		{
			if (!playersInfoDisplayArr.length && GameApp.game.playersManager.playersArr.length)
			{
				this.setPlayersDisplay();
			}
			
			if (num >= 0)
			{
				playersInfoDisplayArr[num].update();
			} else
			{
				for each (var item:PlayerInfoDisplay in playersInfoDisplayArr) 
				{
					item.update();
				}
			}
			
		}
		
		public function markPlayer(num:int):void
		{
			if (playersInfoDisplayArr && playersInfoDisplayArr.length)
			{
				for each (var item:PlayerInfoDisplay in playersInfoDisplayArr) 
				{
					item.clearMark();
					item.y = 35;
				}
				playersInfoDisplayArr[num].markMyTurn();
				playersInfoDisplayArr[num].y = 30;
			}
		}
		
		public function clear():void
		{
			for (var i:String in playersInfoDisplayArr) 
			{
				var playerInfo:PlayerInfoDisplay = playersInfoDisplayArr[i];
				this.removeChild(playerInfo);
			}
			playersInfoDisplayArr = new Vector.<PlayerInfoDisplay>;
		}
		
	}

}