package storedGameData 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class SavedGameData implements ISavedData
	{
		public var worldData:SavedGameData_World;
		//public var territoriesData:SavedGameData_Territories;
		public var playersData:SavedGameData_Players;
		public var roundData:SavedGameData_Round;
		
		public function SavedGameData(data:Object) 
		{
			if (data)
			{									
				//territoriesData = new SavedGameData_Territories(data.world.territories);
				if ("players" in data)
				{
					playersData = new SavedGameData_Players(data.players);
				}
				worldData = new SavedGameData_World(data.world);
			}
		}
		
	}

}