package storedGameData 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class SavedGameData_ArmyUnit  implements ISavedData 
	{
		public var soldiers:Vector.<SavedGameData_Soldier>;
		public var onTileID:int;
		public var teritoryID:int;
		public var active:Boolean;
		
		public function SavedGameData_ArmyUnit(data:Object) 
		{
			onTileID = parseInt(data.@onTile);
			teritoryID = parseInt(data.@teritoryID);
			active = data.@active == "true"?true:false;
			
			if (data)
			{
				if (data.soldier.length())
				{
					soldiers = new Vector.<SavedGameData_Soldier>;

					for (var i:int = 0; i <data.soldier.length() ; i++) 
					{
						soldiers.push(new SavedGameData_Soldier(data.soldier[i]));
					}
				}
			}
		}
		
	}

}