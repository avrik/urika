package armies.data 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class ArmyUnitData 
	{
		public var type:String;
		//public var resources:Array;
		public var code:int;
		
		public function ArmyUnitData(data:Object) 
		{
			type = data.@type;
			code = parseInt(data.@code);
			//resources = String(data.@resources).split(",");
		}
		
	}

}