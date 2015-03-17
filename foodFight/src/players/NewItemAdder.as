package players 
{
	import armies.ArmyUnit;
	import armies.Soldier;
	import interfaces.IBuyItem;
	import starling.events.Event;
	/**
	 * ...
	 * @author Avrik
	 */
	public class NewItemAdder 
	{
		private var _myPlayer:Player_Human;
		private var _buyItem:IBuyItem;
		
		public function NewItemAdder(player:Player_Human) 
		{
			_myPlayer = player;
		}
		
		public function addNewUnit(soldier:Soldier):void 
		{
			_buyItem = soldier as IBuyItem;
			
			
			GameApp.game.world.map.setTerritoriesFocus(this._myPlayer.territories);
			GameApp.game.uiLayer.addTitle("Place Your New Unit");
			
			for each (var item:ArmyUnit in this._myPlayer.army.armyUnits) 
			{
				item.waitingForDeploy = true;
				item.addEventListener(ArmyUnit.PICK_FOR_DEPLOY_NEW_SOLDIER, addToArmyUnitClick);
			}
		}
		
		private function addToArmyUnitClick(e:Event):void 
		{
			var armyUnit:ArmyUnit = e.currentTarget as ArmyUnit;
			armyUnit.addSoldier(_buyItem as Soldier);
			
			GameApp.game.uiLayer.removeTitle();
			GameApp.game.world.map.clearTerritoriesFocus();
			
			for each (var item:ArmyUnit in this._myPlayer.army.armyUnits) 
			{
				item.waitingForDeploy = false;
				item.removeEventListener(ArmyUnit.PICK_FOR_DEPLOY_NEW_SOLDIER, addToArmyUnitClick);
			}
		}
		
	}

}