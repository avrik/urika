package storedGameData 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class SavedGameData_Soldier  implements ISavedData
	{
		public var exp:Number;
		
		public function SavedGameData_Soldier(data:Object) 
		{
			if (data)
			{
				exp = parseFloat(data.@exp);
			}
		}
		
	}

}