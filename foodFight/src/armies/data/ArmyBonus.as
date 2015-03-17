package armies.data 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class ArmyBonus 
	{
		public var attackBonus:Boolean;
		public var defenceBonus:Boolean;
		public var attackActionBonus:Boolean;
		public var moveActionBonus:Boolean;
		public var diplomacyActionBonus:Boolean;
		public var luckBonus:Boolean;
		
		public function ArmyBonus(data:Object) 
		{
			attackBonus = data.attackBonus == "true"?true:false;
			defenceBonus = data.defenceBonus == "true"?true:false;
			attackActionBonus = data.attackActionBonus == "true"?true:false;
			moveActionBonus = data.moveActionBonus == "true"?true:false;
			diplomacyActionBonus = data.diplomacyActionBonus == "true"?true:false;
			luckBonus = data.luckBonus == "true"?true:false;
		}
		
	}

}