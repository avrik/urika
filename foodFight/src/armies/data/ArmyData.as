package armies.data 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class ArmyData 
	{
		public var name:String;
		public var color:uint;
		public var code:String;
		public var bonus:int;
		public var units:Vector.<ArmyUnitData>
		public var id:int;
		
		public function ArmyData(data:Object) 
		{
			name = data.@name;
			color = parseInt(data.@color);
			id = parseInt(data.@id);
			bonus = parseInt(data.features.bonus.@id);
			code = data.@code;
			
			if (data.armyUnit.length())
			{
				units = new Vector.<ArmyUnitData>();
				for (var i:int = 0; i <data.armyUnit.length() ; i++) 
				{
					units.push(new ArmyUnitData(data.armyUnit[i]));
				}
			}
		}
		
	}

}