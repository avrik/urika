package players 
{
	import armies.Army;
	import gameConfig.ConfigurationData;
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
			
			MainGameApp.getInstance.game.disableAll = false;
			MainGameApp.getInstance.game.uiLayer.infoRibbon.showTurns();
			MainGameApp.getInstance.game.uiLayer.infoRibbon.updateInfo();
		}
		
		override public function deactivate():void 
		{
			super.deactivate();
			
			MainGameApp.getInstance.game.disableAll = true;
			MainGameApp.getInstance.game.uiLayer.infoRibbon.hideTurns();
		}
		
		override public function endMyTurn():void 
		{
			MainGameApp.getInstance.game.world.view.zoomOut();

			super.endMyTurn();
		}
		
		override public function addToScore(value:Number):void 
		{
			super.addToScore(value);
			
			MainGameApp.getInstance.game.uiLayer.infoRibbon.addToScore(value);
		}
		
		override public function set diplomacyLeft(value:int):void 
		{
			super.diplomacyLeft = value;
			MainGameApp.getInstance.game.uiLayer.infoRibbon.updateInfo();
		}

		override public function set attacksLeft(value:int):void 
		{
			super.attacksLeft = value;
			
			MainGameApp.getInstance.game.uiLayer.infoRibbon.updateInfo();
		}

		override public function set movesLeft(value:int):void 
		{
			super.movesLeft = value;
			MainGameApp.getInstance.game.uiLayer.infoRibbon.updateInfo();
		}
		
		override public function reportActionComplete():void 
		{
			super.reportActionComplete();
			
			//army.setArmyUnitsForInteraction();

			if (attacksLeft <= 0 && movesLeft <= 0)
			{
				MainGameApp.getInstance.game.uiLayer.hintTheEndButn();
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
				MainGameApp.getInstance.game.uiLayer.coinCollector.addToCoinsAmount(value - this._coinsAmount);
			} else
			{
				MainGameApp.getInstance.game.uiLayer.coinCollector.reduceCoinsAmount(this._coinsAmount - value);
				//GameApp.getInstance.game.uiLayer.coinCollector.coinsAmount = value;
			}
			
			super.coinsAmount = value;
		}
		
		public function get newItemAdder():NewItemAdder 
		{
			return _newItemAdder;
		}
		
		override public function reportAttack():void 
		{
			if (!gameConfig.ConfigurationData.debugData.cheatData.unlimitedMoves)
			{
				super.reportAttack();
			}
		}
		
		override public function reportMove():void 
		{
			if (!gameConfig.ConfigurationData.debugData.cheatData.unlimitedMoves)
			{
				super.reportMove();
			}
			
		}
	}

}