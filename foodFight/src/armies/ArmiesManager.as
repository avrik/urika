package armies 
{
	import armies.data.ArmyData;
	import ascb.util.ArrayUtilities;
	import urikatils.VectorUtils;
	/**
	 * ...
	 * @author Avrik
	 */
	public class ArmiesManager 
	{
		private var _disableAll:Boolean;
		private var _armies:Vector.<Army>
		private var _armiesData:Vector.<ArmyData>
		//private var _armiesAvailable:Vector.<Object>
		
		public function ArmiesManager() 
		{
			_armies = new Vector.<Army>;
			//_armiesAvailable = new Vector.<Object>;
			
			
			_armiesData = new Vector.<ArmyData>;
			_armiesData = _armiesData.concat(ConfigurationData.armiesData.armies);
			_armiesData.sort(randomzieArmies);
			
			Tracer.alert("VVVVVVVVVVVVVVVVVVVVVvv === " + _armiesData);
			/*for (var i:int = 0; i < ConfigurationData.armiesData.armies.length; i++) 
			{
				var newArmy:Army = new Army(ConfigurationData.armiesData.armies[i]);
				_armies.push(newArmy);
				_armiesAvailable.push(newArmy);
			}*/

			//_armiesAvailable = VectorUtils.randomize(_armiesAvailable);
		}
		
		private function randomzieArmies(a:ArmyData, b:ArmyData):int
		{
			return Math.floor( Math.random() * 3 - 1 );
		}
		
		public function get armies():Vector.<Army> 
		{
			return _armies;
		}
		
		public function set disableAll(value:Boolean):void 
		{
			_disableAll = value;
			
			for each (var item:Army in _armies) 
			{
				item.disableUnits = value;
			}
		}
		
		public function getAvailableArmy(num:int = -1, isHuman:Boolean = false):Army
		{
			/*if (!_armiesAvailable.length) return null;
			if (num != -1)
			{
				for each (var item:Army in _armies) 
				{
					if (item.armyData.id == (num + 1)) {
						_armiesAvailable.splice(_armiesAvailable.indexOf(item), 1);
						return item;
					}
				}
			}
			
			return _armiesAvailable.pop();*/
			
			
			var army:Army;
			var armyData:ArmyData;
			
			if (num != -1)
			{
				for each (var item:ArmyData in _armiesData) 
				{
					if (item.id == (num + 1)) {
						armyData = item;
						_armiesData.splice(_armiesData.indexOf(item), 1);
						
					}
				}
			} else
			{
				armyData = _armiesData.pop();
			}
			
			army = isHuman?new Army_Human(armyData):new Army_Virtual(armyData);
			_armies.push(army);
			
			return army;
		}
		
		public function getArmyByID(num:int,isHuman:Boolean):Army 
		{
			/*for each (var item:Army in _armies) 
			{
				
				if (item.armyData.id == (num + 1)) return item;
			*/
				
			return getAvailableArmy(num,isHuman);
			
			//return null
		}
		
		
		public function removeAllArmies():void
		{
			for each (var item:Army in _armies) 
			{
				item.dispose();
			}
		}
		
	}

}