package storedGameData 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class SavedGameData_Territory  implements ISavedData
	{
		public var id:int;
		public var ownerID:int;
		public var tiles:Vector.<SavedGameData_Tile>;
		//public var armyUnit:SavedGameData_ArmyUnit;
		public var mainTileID:int;
		
		public function SavedGameData_Territory(data:Object) 
		{
			if (data)
			{
				id = parseInt(data.@id);
				ownerID = parseInt(data.@owner);
				mainTileID = parseInt(data.@mainTileID);
				
				if (data.tile.length())
				{
					tiles = new Vector.<SavedGameData_Tile>;

					for (var i:int = 0; i <data.tile.length() ; i++) 
					{
						tiles.push(new SavedGameData_Tile(data.tile[i]));
					}
				}
				
				//armyUnit = new SavedGameData_ArmyUnit(data.armyUnit);
			}
		}
		
	}

}