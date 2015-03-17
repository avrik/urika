package storedGameData 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class SavedGameData_Territories  implements ISavedData
	{
		public var territories:Vector.<SavedGameData_Territory>
		
		public function SavedGameData_Territories(data:Object) 
		{
			if (data)
			{
				var len:int = data.territory.length();
				if (len)
				{
					territories = new Vector.<SavedGameData_Territory>;

					for (var i:int = 0; i <len ; i++) 
					{
						territories.push(new SavedGameData_Territory(data.territory[i]));
					}
				}
			}
		}
		
	}

}