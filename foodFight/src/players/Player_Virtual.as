package players 
{
	import armies.Army;
	import ascb.util.NumberUtilities;
	import gameWorld.territories.Territory;
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.events.Event;
	import ui.uiLayer.AllianceRequestWindow;
	import urikatils.LoggerHandler;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Player_Virtual extends Player 
	{
		
		static public const RANDOM_TILE:String = "randomTile";
		
		private var _pickedTerritory:Territory;
		private var _ai:Player_AI;
		
		public function Player_Virtual(id:int,playerData:PlayerData,army:Army) 
		{
			super(id, playerData, army);
			_ai = new Player_AI(this);
		}
		
		override public function activate():void 
		{
			super.activate();
			//setMyNextMove();
			//GameApp.getInstance.game.disableAll = true;
		}
		
		
		
		override protected function readyToStartMyTurn():void 
		{
			super.readyToStartMyTurn();
			
			Starling.juggler.add(new DelayedCall(setMyNextMove, .5));
			//setMyNextMove();
		}
		
		
		private function moveForcesComplete(e:Event):void 
		{
			this.army.removeEventListener(Army.MOVE_FORCES_COMPLETE, moveForcesComplete);
			setMyNextMove();
		}
		
		private function attackComplete(e:Event):void 
		{
			this.army.removeEventListener(Army.ATTACK_COMPLETE, attackComplete);
			setMyNextMove();
		}
		
		private function accupayComplete(e:Event):void 
		{
			this.army.removeEventListener(Army.ACCUPAY_COMPLETE, accupayComplete);
			setMyNextMove();
		}
		
		private function setMyNextMove():void
		{
			var actStr:String = _ai.canAct();
			if (actStr == "YES")
			{
				if (!this.buyAction())
				{
					if (!this.diplomacyAction())
					{
						if (!this.accupayLand())
						{
							if (!this.attackAnEnemy())
							{
								if (!this.moveForces())
								{
									this.endMyTurn();
								}
							}
						} 
					}
				}
			} else
			{
				LoggerHandler.getInstance.info(this," --- WONT ATTACK IN THIS TURN "+actStr);
				this.endMyTurn();
			}
		}
		
		private function buyAction():Boolean 
		{
			return false;
		}
		
		private function diplomacyAction():Boolean 
		{
			if (!this.diplomacyLeft || gotAllies()) return false;
			
			var rand:int = NumberUtilities.random(0, 10);
			
			if (rand < MainGameApp.getInstance.game.playersManager.activePlayers.length)
			{
				this.diplomacyLeft--;
				
				var player:Player = MainGameApp.getInstance.game.playersManager.activePlayers[rand];
				
				if (player is Player && player != this && player.alive && !player.gotAllies())
				{
					if (player.isHuman)
					{
						var requestWindow:AllianceRequestWindow = MainGameApp.getInstance.game.uiLayer.openAllianceRequestWindow(this);
						requestWindow.addEventListener(AllianceRequestWindow.DECLINE, allianceRequestWindowDeclined);
						requestWindow.addEventListener(AllianceRequestWindow.ACCEPT, allianceRequestWindowAccepted);
						
						return true;
					} else
					{
						if (player.allianceRequest(this))
						{
							MainGameApp.getInstance.game.diplomacyManager.addNewAlliance(player, this);
						}
						
					}
					
				}
			}
			
			return false;
		}
		
		private function allianceRequestWindowDeclined(e:Event):void 
		{
			setMyNextMove();
		}
		
		private function allianceRequestWindowAccepted(e:Event):void 
		{
			MainGameApp.getInstance.game.diplomacyManager.addNewAlliance(this, MainGameApp.getInstance.game.playersManager.userPlayer);
			setMyNextMove();
		}
		
		private function accupayLand():Boolean 
		{
			var pickedTerritoryObj:Object = _ai.pickTerritoryToAccupayFrom();
			if (pickedTerritoryObj)
			{
				this.army.addEventListener(Army.ACCUPAY_COMPLETE, accupayComplete);
				this.army.accupayTerritory(pickedTerritoryObj.a, pickedTerritoryObj.b);
				return true;
			}
			return false;
		}
		
		private function moveForces():Boolean 
		{
			if (!this.movesLeft || NumberUtilities.random(0, 1)) return false;
			
			this._pickedTerritory = _ai.pickTerritoryNeedAid();
			
			if (this._pickedTerritory)
			{
				var helpingTerritory:Territory = _ai.getTerritoryForAid(this._pickedTerritory);
				if (helpingTerritory)
				{
					this.army.addEventListener(Army.MOVE_FORCES_COMPLETE, moveForcesComplete);
					this.army.moveForcesToTerritory(helpingTerritory.armyUnit, this._pickedTerritory.armyUnit);
				} else
				{
					return false;
				}
			} else
			{
				return false;
			}
			
			return true;
		}
		
		private function attackAnEnemy():Boolean 
		{
			if (!this.attacksLeft) return false;
			
			this._pickedTerritory = _ai.pickTerritoryToAttackFrom();
			
			if (this._pickedTerritory)
			{
				var enemyTerritory:Territory = _ai.pickTerritoryToAttack(this._pickedTerritory);
				if (enemyTerritory)
				{
					this.army.addEventListener(Army.ATTACK_COMPLETE, attackComplete);
					this.army.attackTerritory(this._pickedTerritory.armyUnit, enemyTerritory.armyUnit);
				} else
				{
					LoggerHandler.getInstance.info(this,"TERRITORY GOT NO ENEMYS");

					return false;
				}
			} else
			{
				LoggerHandler.getInstance.info(this,"NO SUITABLE TERRITORY TO ATTACK FROM");

				return false;
			}
			
			return true;
		}
		
	}

}