package armies 
{
	import armies.data.ArmyData;
	import gamePlay.Battle;
	import starling.core.Starling;
	import starling.events.Event;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Army_Virtual extends Army 
	{
		
		public function Army_Virtual(armyData:ArmyData) 
		{
			super(armyData);
		}
		
		override public function addAndDeployRoundUnits():void 
		{
			super.addAndDeployRoundUnits();
			
			deployUnits(DEPLOY_BY_ENEMYS);
		}
		
		override public function attackTerritory(myArmyUnit:ArmyUnit, targetArmyUnit:ArmyUnit):void 
		{
			super.attackTerritory(myArmyUnit, targetArmyUnit);
			
			MainGameApp.getInstance.game.warManager.addEventListener(Battle.BATTLE_COMPLETE, virtualAttackComplete);
			MainGameApp.getInstance.game.warManager.startWar();
		}
		
		private function virtualAttackComplete(e:Event):void 
		{
			Starling.juggler.delayCall(function():void
				{
					
					attackComplete();
				},.3
			);
			//myPlayer.reportActionComplete();
		}
	}

}