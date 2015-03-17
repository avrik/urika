package storedGameData 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class SavedGameData_Army  implements ISavedData
	{
		public var armyUnits:Vector.<SavedGameData_ArmyUnit>;
		public var armyID:int;
		
		public function SavedGameData_Army(data:Object) 
		{
			if (data)
			{
				armyID = parseInt(data.@armyID);
				if (data.armyUnit.length())
				{
					armyUnits = new Vector.<SavedGameData_ArmyUnit>;

					for (var i:int = 0; i <data.armyUnit.length() ; i++) 
					{
						armyUnits.push(new SavedGameData_ArmyUnit(data.armyUnit[i]));
					}
				}
			}
		}
		
	}

}