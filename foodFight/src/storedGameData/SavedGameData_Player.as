package storedGameData 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class SavedGameData_Player  implements ISavedData
	{
		public var armyID:int;
		public var id:int;
		public var name:String;
		public var isHuman:Boolean;
		public var score:Number;
		public var alive:Boolean;
		public var armyData:SavedGameData_Army;
		
		public function SavedGameData_Player(data:Object) 
		{
			if (data)
			{
				armyID = parseInt(data.@armyID);
				id = parseInt(data.@id);
				name = data.@name;
				isHuman = data.@isHuman == "true"?true:false;
				score = parseFloat(data.@score);
				alive = data.@alive == "true"?true:false;
				
				armyData = new SavedGameData_Army(data.army);
			}
		}
		
	}

}