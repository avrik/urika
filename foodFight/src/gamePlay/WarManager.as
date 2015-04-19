package gamePlay 
{
	import armies.ArmyUnit;
	import armies.Soldier;
	import armies.UnitStatusEnum;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
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

		
		public function fight(attackArmyUnits:Vector.<ArmyUnit>, defender:ArmyUnit):void 
		{
			
			var attackSoldiers:Vector.<Soldier> = new Vector.<Soldier>;
			
			for (var i:int = 0; i < attackArmyUnits.length; i++) 
			{
				for each (var item:Soldier in attackArmyUnits[i].soldiers) 
				{
					attackSoldiers.push(item);
				}
			}
			trace("total attackers === " + attackSoldiers.length);
			
			var tween:Tween
			var attackPoints:Number = 0;
			
			for (var j:int = 0; j < attackSoldiers.length; j++) 
			{
				var attackSoldier:Soldier = attackSoldiers[j];

				attackPoints = Math.random() * attackSoldier.getAttackPoints();
				tween = new Tween(attackSoldier.view, 1,Transitions.EASE_IN_BACK);
				if (j) tween.delay = j / 10;
				tween.moveTo(defender.view.x,defender.view.y);
				tween.onComplete = attackAnimationComplete;
				tween.onCompleteArgs = [defender,attackPoints];
				Starling.juggler.add(tween);
			}
			
			
			
			
			
		}
		
		private function attackAnimationComplete(defender:ArmyUnit,attackPoints:Number):void 
		{
			trace("ATTACK POINTS === " + attackPoints);
			defender.healthPoints -= attackPoints;
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
			MainGameApp.getInstance.game.uiLayer.playersInfoBar.update();
		}
		
		public function get onBattle():Battle 
		{
			return _onBattle;
		}
		
	}

}