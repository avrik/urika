package players
{
	import armies.Army;
	import ascb.util.NumberUtilities;
	import gameWorld.territories.Territory;
	import urikatils.LoggerHandler;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class Player_AI
	{
		private var _player:Player_Virtual;
		private var _myAttackMethod:String;
		
		public function Player_AI(player:Player_Virtual)
		{
			this._player = player;
			_myAttackMethod = AI_AttackMethodEnum.STRONGEST_ARMY;
		}

		public function canAct():String
		{
			if (!this._player.alive)
				return "PLAYER DEAD";
			if (!this._player.actionsLeft())
				return "PLAYER GOT NO MOVES";
			if (this._player.army.getSoldiersNumber() <= (this._player.army.armyUnits.length * 2))
				return "PLAYER GOT NOT ENOUTH SOLDIERS";
			return "YES";
		}
		
		public function pickTerritoryToAttackFrom():Territory
		{
			var territory:Territory;
			
			if (this._player.army.getSoldiersNumber() > this._player.territories.length + 2)
			{
				var territoryArrByStrength:Vector.<Territory> = new Vector.<Territory>;
				for each (var item:Territory in this._player.territories)
				{
					if (item.enemyTerritories.length && item.armyUnit.totalSoldiers > 1)
					{
						territoryArrByStrength.push(item)
					}
				}
				territoryArrByStrength = territoryArrByStrength.sort(sortTerritoryByStrength);
				
				/*if (territoryArrByStrength && territoryArrByStrength.length)
				   {
				   return territoryArrByStrength[0];
				 }*/
				
				for each (var territoryOption:Territory in territoryArrByStrength)
				{
					for each (var territoryOptionEnemy:Territory in territoryOption.enemyTerritories)
					{
						if (!territoryOption.owner.myPlayer.isMyAlly(territoryOptionEnemy.owner.myPlayer))
						{
							if (territoryOption.armyUnit.totalSoldiers >= territoryOptionEnemy.armyUnit.totalSoldiers)
							{
								return territoryOption;
							}
						}
						
					}
				}
			}
			else
			{
				LoggerHandler.getInstance.info(this,"NOT ENOUGH SOLDIERS TO ATTACK");
			}
			
			return territory;
		}
		
		private function sortTerritoryByArmyStrength(a:Territory, b:Territory):int
		{
			if (a.owner.getTotalStrenght() > b.owner.getTotalStrenght())
			{
				return -1;
			}
			else if (a.owner.getTotalStrenght() < b.owner.getTotalStrenght())
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		private function sortTerritoryByRandom(a:Territory, b:Territory):int
		{
			return Math.floor( Math.random() * 3 - 1 );
		}
		
		private function sortTerritoryByStrength(a:Territory, b:Territory):int
		{
			if (a.armyUnit.totalSoldiers > b.armyUnit.totalSoldiers)
			{
				return -1;
			}
			else if (a.armyUnit.totalSoldiers < b.armyUnit.totalSoldiers)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		public function pickTerritoryToAttack(pickedTerritory:Territory):Territory
		{
			if (!pickedTerritory.enemyTerritories.length)
			{
				//LoggerHandler.getInstance.info(this,"pickTerritoryToAttack 000 is 0");
				return null;
			}
			
			var territory:Territory;
			
			var enemysArr:Vector.<Territory> = new Vector.<Territory>;
			//LoggerHandler.getInstance.info(this,"pickTerritoryToAttack 111 == " + pickedTerritory.enemyTerritories.length);
			
			for each (var item:Territory in pickedTerritory.enemyTerritories)
			{
				if (!pickedTerritory.owner.myPlayer.isMyAlly(item.owner.myPlayer))
				{
					enemysArr.push(item)
				}
			}
			
			//enemysArr = enemysArr.sort(sortTerritoryByStrength).reverse();
			
			switch (_myAttackMethod)
			{
				case AI_AttackMethodEnum.RANDOM:
					enemysArr = enemysArr.sort(sortTerritoryByRandom);
					break;

				case AI_AttackMethodEnum.SAFE:
					enemysArr = enemysArr.sort(sortTerritoryByStrength).reverse();
					break;

				case AI_AttackMethodEnum.STRONGEST_ARMY:
					enemysArr = enemysArr.sort(sortTerritoryByArmyStrength);
					break;
					
				case AI_AttackMethodEnum.WEAKEST_ARMY:
					enemysArr = enemysArr.sort(sortTerritoryByArmyStrength).reverse();
					break;
			}
			//LoggerHandler.getInstance.info(this,"pickTerritoryToAttack 222 == " + enemysArr.length);
			//enemysArr = enemysArr.reverse();
			
			//do
			//{
			//territory = enemysArr.pop();
			territory = enemysArr[0];
			//}
			//while (enemysArr.length);
			//LoggerHandler.getInstance.info(this,"pickTerritoryToAttack 222 == " + territory);
			return territory;
		}
		
		public function pickTerritoryToAccupayFrom():Object
		{
			for each (var item:Territory in this._player.territories)
			{
				for each (var neighbor:Territory in item.neighborsArr)
				{
					if (!neighbor.owner)
					{
						return {a: item.armyUnit, b: neighbor};
					}
				}
			}
			
			return null;
		}
		
		public function pickTerritoryNeedAid():Territory 
		{
			var territoriesArr:Vector.<Territory> = duplicateArr(_player.territories);
			
			/*for each (var item:Territory in _player.territories)
			{
				territoriesArr.push(item)
			}*/
			
			territoriesArr = territoriesArr.sort(sortTerritoryByStrength).reverse();
			
			for each (var item2:Territory in territoriesArr)
			{
				if (item2.myTerritories.length)
				{
					return item2;
				}
			}
			
			return null;
		}
		
		public function getTerritoryForAid(pickedTerritory:Territory):Territory 
		{
			var territoriesArr:Vector.<Territory> = duplicateArr(pickedTerritory.myTerritories);
			territoriesArr = territoriesArr.sort(sortTerritoryByStrength);
			
			for each (var item:Territory in territoriesArr)
			{
				if (item.armyUnit.totalSoldiers > 2)
				{
					return item;
				}
			}
			
			return null;
		}
		
		private function duplicateArr(arr:Vector.<Territory>):Vector.<Territory>
		{
			var newArr:Vector.<Territory> = new Vector.<Territory>;
			
			for each (var item:Territory in arr)
			{
				newArr.push(item)
			}
			
			return newArr;
		}
		
		
		
		/*private function getPlayerToAttack():Player
		{
			var player:Player;
			
			do
			{
				player = GameApp.getInstance.game.playersManager.playersArr[NumberUtilities.random(0, (GameApp.getInstance.game.playersManager.getTotalPlayers() - 1))];
			} while (player == this._player && !player.alive)
			
			return player;
		}*/
	
	}

}