package storedGameData 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class SavedGameData_Tile implements ISavedData
	{
		public var id:int;
		public var xpos:int;
		public var ypos:int;
		
		public function SavedGameData_Tile(data:Object) 
		{
			if (data)
			{
				id = parseInt(data.@id);
				xpos = parseInt(data.@xpos);
				ypos = parseInt(data.@ypos);
			}
		}
		
	}

}