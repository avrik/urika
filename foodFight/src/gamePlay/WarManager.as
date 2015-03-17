package gamePlay 
{
	import armies.ArmyUnit;
	import armies.UnitStatusEnum;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import ui.uiLayer.UILayer;


	/**
	 * ...
	 * @author Avrik
	 */
	
	public class WarManager extends EventDispatcher
	{
		private static var _battles:Vector.<Battle> = new Vector.<Battle>;
		
		private var _onBattle:Battle;

		public function WarManager() 
		{
			
		}

		public function setBattle(attacer:ArmyUnit, defender:ArmyUnit):void 
		{
			_onBattle = new Battle(attacer, defender);
			
			
			
			_battles.push(onBattle);
		}
		
		public function startWar():void 
		{
			onBattle.addEventListener(Battle.BATTLE_COMPLETE, battleComplete);
			onBattle.addEventListener(Battle.BATTLE_END, battleEnd);
			onBattle.addEventListener(Battle.BATTLE_END_AND_WON, battleCompleteAndWon);
			onBattle.start();
		}
		
		private function battleEnd(e:Event):void 
		{
			dispatchEvent(new Event(Battle.BATTLE_END));
		}
		private function battleCompleteAndWon(e:Event):void 
		{
			dispatchEvent(new Event(Battle.BATTLE_END_AND_WON));
		}
		
		private function battleComplete(e:Event):void 
		{
			var battle:Battle = e.currentTarget as Battle;
			
			battle.removeEventListeners();
			_battles.splice(_battles.indexOf(battle), 1);
			if (!_battles.length)
			{
				_onBattle = null;
			}
			//Game.disableAll = false;
			dispatchEvent(new Event(Battle.BATTLE_COMPLETE));
			GameApp.game.uiLayer.playersInfoBar.update();
		}
		
		public function get onBattle():Battle 
		{
			return _onBattle;
		}
		
	}

}