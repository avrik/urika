package storedGameData 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class SavedUserData implements ISavedData 
	{
		public var name:String = "test";
		public var totalScore:Number = 0;
		public var totalCredits:int = 0;
		public var level:int = 0;
		public var highScore:Number=0;
		
		public function SavedUserData(data:Object=null) 
		{
			if (data)
			{
				name = data.@name;
				totalScore = parseFloat(data.@totalScore);
				highScore = parseFloat(data.@highScore);
				totalCredits = parseInt(data.@totalCredits);
				level = parseInt(data.@level);
			}
		}
		
	}

}