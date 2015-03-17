package storedGameData 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class SavedGameData_World implements ISavedData 
	{
		public var mapData:SavedGameData_Map;
		
		public function SavedGameData_World(data:Object) 
		{
			if (data)
			{
				mapData = new SavedGameData_Map(data.map);
			}
		}
		
	}

}