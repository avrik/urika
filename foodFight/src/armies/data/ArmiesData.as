package armies.data 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class ArmiesData 
	{
		public var armies:Vector.<ArmyData>
		
		public function ArmiesData(data:Object) 
		{
			if (data.army.length())
			{
				armies = new Vector.<ArmyData>();
				for (var i:int = 0; i <data.army.length() ; i++) 
				{
					armies.push(new ArmyData(data.army[i]));
				}
			}
			
		}
		
	}

}