package armies 
{
	import armies.data.ArmyData;
	import gamePlay.Battle;
	import gameWorld.WorldView;
	import starling.events.Event;
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
			
			removeClickableFromAllUnits();
			
			for each (var item:ArmyUnit in armyUnits) 
			{
				item.removeEventListener(ArmyUnit.PICKED_FOR_ACTION, unitPickedForAction);
			}
			
			//clearPickedUnit();
			GameApp.game.unitsController.clearPicked();
		}
		
		override public function activateForNewRound():void 
		{
			super.activateForNewRound();
			
			this.setClickableArmyUnits();
			
			for each (var item:ArmyUnit in armyUnits) 
			{
				item.addEventListener(ArmyUnit.PICKED_FOR_ACTION, unitPickedForAction);
			}
		}
		
		/*private function actionLayerClicked():void 
		{
			Tracer.alert("ACTION LAYER IN ARMY CLICKED");
			this.clearPickedUnit();
			
			this.removeClickableFromAllUnits();
			this.setClickableArmyUnits();
		}*/
		
		private function unitPickedForAction(e:Event):void 
		{
			Tracer.alert("PICK UNIT FOR ACTION");
			/*if (pickedArmyUnit)
			{
				pickedArmyUnit.isPicked = false;
			}*/
			//clearPickedUnit();
			
			/*pickedArmyUnit = e.currentTarget as ArmyUnit;
			pickedArmyUnit.isPicked = true;
			
			GameApp.game.world.view.zoomIn( pickedArmyUnit.getLocationPoint().x, pickedArmyUnit.getLocationPoint().y);
			GameApp.game.world.map.setTerritoriesFocus(pickedArmyUnit.getNeighborsAndMe());
			
			GlobalEventManger.addEvent(GlobalEventsEnum.ACTION_LAYER_CLICKED, actionLayerClicked);*/
		}
		
		/*public function clearPickedUnit():void
		{
			Tracer.alert("CLEAR PICKED UNIT");
			if (pickedArmyUnit)
			{
				pickedArmyUnit.isPicked = false;
				pickedArmyUnit = null;
			}
			
			GameApp.game.unitsController.clearPicked();
			//removeClickableFromAllUnits();
			//setClickableArmyUnits();
			
			//GlobalEventManger.removeEvent(GlobalEventsEnum.ACTION_LAYER_CLICKED, actionLayerClicked);
		}*/

		public function setClickableArmyUnits():void 
		{
			//removeClickableFromAllUnits();
			
			var length:int = this.armyUnits.length;
			var armyUnit:ArmyUnit;
			for (var i:int = 0; i <length ; ++i) 
			{
				armyUnit = this.armyUnits[i];

				if (armyUnit.totalSoldiers > 1)
				{
					if (this.myPlayer.movesLeft > 0 && armyUnit.onTerritory.myTerritories.length)
					{
						armyUnit.clickable = true;
					} 
					
					if (this.myPlayer.attacksLeft > 0 && armyUnit.onTerritory.enemyTerritories.length)
					{
						armyUnit.clickable = true;
					}
				}
			}
		}
		
		public function removeClickableFromAllUnits(exeptionArmyUnit:ArmyUnit=null):void 
		{
			var length:int = this.armyUnits.length;
			var armyUnit:ArmyUnit;
			
			for (var i:int = 0; i <length ; ++i) 
			{
				armyUnit = this.armyUnits[i];
				if (!(exeptionArmyUnit && armyUnit == exeptionArmyUnit))
				{
					armyUnit.clickable = false;
				}
			}
		}
		
		override public function addAndDeployRoundUnits():void 
		{
			super.addAndDeployRoundUnits();
			
			GameApp.game.world.map.setTerritoriesFocus(this.myPlayer.territories);
			deployManager = new DeployUnitsManager(this, _soldiersToDeployArr);
			deployManager.addEventListener(Event.COMPLETE, humanDeployComplete);
			deployManager.start();
		}
		
		private function humanDeployComplete(e:Event):void 
		{
			GameApp.game.world.map.clearTerritoriesFocus();

			deployManager.dispose();
			deployManager.removeEventListeners();
			
			this.setClickableArmyUnits();
			GameApp.game.disableAll = false;
			
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
		
			GameApp.game.world.view.addEventListener(WorldView.ZOOM_COMPLETE, attackZoomComplete);
			GameApp.game.world.view.zoomIn(xx, yy);
			GameApp.game.disableAll = true;
		}
		
		private function attackZoomComplete(e:Event):void 
		{
			GameApp.game.world.view.removeEventListener(WorldView.ZOOM_COMPLETE, attackZoomComplete);
			GameApp.game.warManager.addEventListener(Battle.BATTLE_END, humanAttackComplete);
			GameApp.game.warManager.addEventListener(Battle.BATTLE_END_AND_WON, humanAttackCompleteAndWon);
			GameApp.game.warManager.startWar();
		}

		private function humanAttackCompleteAndWon(e:Event):void 
		{
			resetAction()
			attackComplete()
		}
		
		private function humanAttackComplete(e:Event):void 
		{
			//GameApp.game.warManager.removeEventListeners();
			//GameApp.game.disableAll = false;

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
			GameApp.game.disableAll = false;
		}
		
		override public function moveForcesToTerritory(myArmyUnit:ArmyUnit, targetArmyUnit:ArmyUnit):void 
		{
			GameApp.game.disableAll = true;
			super.moveForcesToTerritory(myArmyUnit, targetArmyUnit);
			
		}
		
		override protected function moveForceComplete(myArmyUnit:ArmyUnit,targetArmyUnit:ArmyUnit, soldier:Soldier):void 
		{
			super.moveForceComplete(myArmyUnit,targetArmyUnit, soldier);
			GameApp.game.disableAll = false;
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
					GameApp.game.world.map.setTerritoriesFocus(pickedArmyUnit.getNeighborsAndMe());
				}
			} else
			{
				resetAction()
			}*/
			
			GameApp.game.world.view.zoomOut();
			GameApp.game.world.map.clearTerritoriesFocus();
		}
		
		private function resetAction():void
		{
			GameApp.game.world.view.zoomOut();
			GameApp.game.world.map.clearTerritoriesFocus();

			//clearPickedUnit();
			
			removeClickableFromAllUnits();
			setClickableArmyUnits();
		}
	}

}