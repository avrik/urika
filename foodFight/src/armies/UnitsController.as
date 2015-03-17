package armies 
{
	import starling.core.Starling;
	import utils.events.GlobalEventManger;
	import utils.events.GlobalEventsEnum;
	/**
	 * ...
	 * @author Avrik
	 */
	public class UnitsController 
	{
		private var _pickedUnit:ArmyUnit;
		
		public function UnitsController() 
		{
			
		}
		
		
		public function unitPicked():void
		{
			
		}
		
		public function setPickedUnit(armyUnit:ArmyUnit):void 
		{
			clearPicked();
			_pickedUnit = armyUnit;
			_pickedUnit.isPicked = true;
			
			GameApp.game.world.view.zoomIn( _pickedUnit.getLocationPoint().x, _pickedUnit.getLocationPoint().y);
			GameApp.game.world.map.setTerritoriesFocus(_pickedUnit.getNeighborsAndMe());
			
			GlobalEventManger.addEvent(GlobalEventsEnum.ACTION_LAYER_CLICKED, actionLayerClicked);
		}
		
		private function actionLayerClicked():void 
		{
			this.clearPicked();
		}
		
		public function setInteractionUnit(armyUnit:ArmyUnit):void 
		{
			if (_pickedUnit.myArmy == armyUnit.myArmy) 
			{
				if (_pickedUnit.myArmy.myPlayer.movesLeft)
				{
					_pickedUnit.myArmy.moveForcesToTerritory(_pickedUnit, armyUnit);
				}
				
			} else
			{
				_pickedUnit.myArmy.attackTerritory(_pickedUnit, armyUnit);
			}
			
			clearPicked()
		}
		
		public function clearPicked():void
		{
			if (_pickedUnit)
			{
				GlobalEventManger.removeEvent(GlobalEventsEnum.ACTION_LAYER_CLICKED, actionLayerClicked);
				
				Army_Human(_pickedUnit.myArmy).removeClickableFromAllUnits();
				Army_Human(_pickedUnit.myArmy).setClickableArmyUnits();
				
				_pickedUnit.isPicked = false;
				_pickedUnit.clearNeighborsInteraction();
				_pickedUnit = null;
			}
			
		}
		
	}

}