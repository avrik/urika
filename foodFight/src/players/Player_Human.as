package players 
{
	import armies.Army;
	import starling.events.Event;
	import utils.events.GlobalEventManger;
	import utils.events.GlobalEventsEnum;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Player_Human extends Player 
	{
		private var _newItemAdder:NewItemAdder;
		private var _econamyMinister:PlayerEconamyMinister
		
		public function Player_Human(id:int, playerData:PlayerData, army:Army)
		{
			this._isHuman = true;
			super(id, playerData, army);
			
			GlobalEventManger.addEvent(GlobalEventsEnum.END_ROUND_CLICKED, endRoundClicked);
			_econamyMinister = new PlayerEconamyMinister(this);
			_newItemAdder = new NewItemAdder(this);
			//_actionView = new Player_Human_View(this);
		}
		
		private function endRoundClicked(e:Event):void 
		{
			this.endMyTurn();
		}
		
		override public function activate():void 
		{
			super.activate();
			
			GameApp.game.disableAll = false;
			GameApp.game.uiLayer.infoRibbon.showTurns();
			GameApp.game.uiLayer.infoRibbon.updateInfo();
		}
		
		override public function deactivate():void 
		{
			super.deactivate();
			
			GameApp.game.disableAll = true;
			GameApp.game.uiLayer.infoRibbon.hideTurns();
		}
		
		override public function endMyTurn():void 
		{
			GameApp.game.world.view.zoomOut();

			super.endMyTurn();
		}
		
		override public function addToScore(value:Number):void 
		{
			super.addToScore(value);
			
			GameApp.game.uiLayer.infoRibbon.addToScore(value);
		}
		
		override public function set diplomacyLeft(value:int):void 
		{
			super.diplomacyLeft = value;
			GameApp.game.uiLayer.infoRibbon.updateInfo();
		}

		override public function set attacksLeft(value:int):void 
		{
			super.attacksLeft = value;
			
			GameApp.game.uiLayer.infoRibbon.updateInfo();
		}

		override public function set movesLeft(value:int):void 
		{
			super.movesLeft = value;
			GameApp.game.uiLayer.infoRibbon.updateInfo();
		}
		
		override public function reportActionComplete():void 
		{
			super.reportActionComplete();
			
			army.setArmyUnitsForInteraction();

			if (attacksLeft <= 0 && movesLeft <= 0)
			{
				GameApp.game.uiLayer.hintTheEndButn();
			}
		}

		
		override public function get alive():Boolean 
		{
			return super.alive;
		}
		
		override public function set alive(value:Boolean):void 
		{
			super.alive = value;
			
			
		}
		
		
		override public function get coinsAmount():int 
		{
			return super.coinsAmount;
		}
		
		override public function set coinsAmount(value:int):void 
		{
			if (value > this._coinsAmount)
			{
				GameApp.game.uiLayer.coinCollector.addToCoinsAmount(value - this._coinsAmount);
			} else
			{
				GameApp.game.uiLayer.coinCollector.reduceCoinsAmount(this._coinsAmount - value);
				//GameApp.game.uiLayer.coinCollector.coinsAmount = value;
			}
			
			super.coinsAmount = value;
		}
		
		public function get newItemAdder():NewItemAdder 
		{
			return _newItemAdder;
		}
		
		override public function reportAttack():void 
		{
			if (!ConfigurationData.debugData.cheatData.unlimitedMoves)
			{
				super.reportAttack();
			}
		}
		
		override public function reportMove():void 
		{
			if (!ConfigurationData.debugData.cheatData.unlimitedMoves)
			{
				super.reportMove();
			}
			
		}
	}

}