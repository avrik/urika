package storedGameData 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class SavedGameData_Map implements ISavedData 
	{
		public var territoriesData:SavedGameData_Territories;
		public var tilesInRow:int;
		public var totalTiles:int;
		public var totalTerritories:int;
		public var name:String;
		
		public function SavedGameData_Map(data:Object) 
		{
			if (data)
			{
				territoriesData = new SavedGameData_Territories(data.territories);
				tilesInRow = parseInt(data.@tilesInRow);
				totalTiles = parseInt(data.@totalTiles);
				totalTerritories = parseInt(data.@totalTerritories);
				name = data.@name;
			}
		}
		
	}

}