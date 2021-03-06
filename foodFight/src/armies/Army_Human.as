package armies 
{
	import armies.data.ArmyData;
	import gamePlay.Battle;
	import gameWorld.WorldView;
	import starling.events.Event;
	import urikatils.LoggerHandler;
	import utils.events.GlobalEventManger;
	import utils.events.GlobalEventsEnum;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class Army_Human extends Army 
	{
		private var deployManager:DeployUnitsManager;
		private var pickedArmyUnit:ArmyUnit;
		
		public function Army_Human(armyData:ArmyData) 
		{
			super(armyData);
		}
		
		override public function deactivate():void 
		{
			super.deactivate();
		}
		
		override public function activateForNewRound():void 
		{
			super.activateForNewRound();
		}

		
		override public function addAndDeployRoundUnits():void 
		{
			super.addAndDeployRoundUnits();
			
			MainGameApp.getInstance.game.world.map.setTerritoriesFocus(this.myPlayer.territories);
			deployManager = new DeployUnitsManager(this, _soldiersToDeployArr);
			deployManager.addEventListener(Event.COMPLETE, humanDeployComplete);
			deployManager.start();
		}
		
		private function humanDeployComplete(e:Event):void 
		{
			MainGameApp.getInstance.game.world.map.clearTerritoriesFocus();

			deployManager.dispose();
			deployManager.removeEventListeners();
			
			MainGameApp.getInstance.game.disableAll = false;
			
			dispatchEvent(new Event(DEPLOY_COMPLETED));
		}
		
		override public function attackTerritory(myArmyUnit:ArmyUnit, targetArmyUnit:ArmyUnit):void 
		{
			super.attackTerritory(myArmyUnit, targetArmyUnit);

			var minX:Number = Math.min(myArmyUnit.getLocationPoint().x, targetArmyUnit.getLocationPoint().x);
			var maxX:Number = Math.max(myArmyUnit.getLocationPoint().x, targetArmyUnit.getLocationPoint().x);
			var minY:Number = Math.min(myArmyUnit.getLocationPoint().y, targetArmyUnit.getLocationPoint().y);
			var maxY:Number = Math.max(myArmyUnit.getLocationPoint().y, targetArmyUnit.getLocationPoint().y);
			
			var xx:Number = minX + ((maxX - minX) / 2);
			var yy:Number = minY + ((maxY - minY) / 2);
		
			MainGameApp.getInstance.game.world.view.addEventListener(WorldView.ZOOM_COMPLETE, attackZoomComplete);
			MainGameApp.getInstance.game.world.view.zoomIn(xx, yy);
			MainGameApp.getInstance.game.disableAll = true;
		}
		
		private function attackZoomComplete(e:Event):void 
		{
			MainGameApp.getInstance.game.world.view.removeEventListener(WorldView.ZOOM_COMPLETE, attackZoomComplete);
			MainGameApp.getInstance.game.warManager.addEventListener(Battle.BATTLE_END, humanAttackComplete);
			MainGameApp.getInstance.game.warManager.addEventListener(Battle.BATTLE_END_AND_WON, humanAttackCompleteAndWon);
			MainGameApp.getInstance.game.warManager.startWar();
		}

		private function humanAttackCompleteAndWon(e:Event):void 
		{
			resetAction()
			attackComplete()
		}
		
		private function humanAttackComplete(e:Event):void 
		{
			//GameApp.getInstance.game.warManager.removeEventListeners();
			//GameApp.getInstance.game.disableAll = false;

			//handleActionCompleted();
			if (myPlayer.attacksLeft <= 0)
			{
				resetAction();
			} else
			{
				handleActionCompleted()
			}
			
			attackComplete()
		}
		
		override protected function attackComplete():void 
		{
			super.attackComplete();
			MainGameApp.getInstance.game.disableAll = false;
		}
		
		override public function moveForcesToTerritory(myArmyUnit:ArmyUnit, targetArmyUnit:ArmyUnit):void 
		{
			MainGameApp.getInstance.game.disableAll = true;
			super.moveForcesToTerritory(myArmyUnit, targetArmyUnit);
			
		}
		
		override protected function moveForceComplete(myArmyUnit:ArmyUnit,targetArmyUnit:ArmyUnit, soldier:Soldier):void 
		{
			super.moveForceComplete(myArmyUnit,targetArmyUnit, soldier);
			MainGameApp.getInstance.game.disableAll = false;
			//handleActionCompleted();
			
			resetAction();
			/*if (myPlayer.movesLeft <= 0)
			{
				resetAction();
			} else
			{
				handleActionCompleted()
			}*/
		}
		
		private function handleActionCompleted():void
		{
			/*if (pickedArmyUnit)
			{
				if (pickedArmyUnit.totalSoldiers <= 1)
				{
					resetAction()
				} else
				{
					pickedArmyUnit.setNeighborsForInteraction();
					GameApp.getInstance.game.world.map.setTerritoriesFocus(pickedArmyUnit.getNeighborsAndMe());
				}
			} else
			{
				resetAction()
			}*/
			
			MainGameApp.getInstance.game.world.view.zoomOut();
			MainGameApp.getInstance.game.world.map.clearTerritoriesFocus();
		}
		
		private function resetAction():void
		{
			MainGameApp.getInstance.game.world.view.zoomOut();
			MainGameApp.getInstance.game.world.map.clearTerritoriesFocus();

			//clearPickedUnit();
			
			//removeClickableFromAllUnits();
			//setClickableArmyUnits();
		}
	}

}