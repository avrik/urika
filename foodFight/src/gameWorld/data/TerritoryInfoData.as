package gameWorld.data 
{
	import armies.data.ArmyData;
	import armies.Soldier;
	/**
	 * ...
	 * @author Avrik
	 */
	public class TerritoryInfoData 
	{
		public var defenceBonus:Number;
		public var ownerData:ArmyData;
		public var soldiers:Vector.<Soldier>;
		//public var resources:ResourcesManager;
		
		public function TerritoryInfoData(ownerData:ArmyData, soldiers:Vector.<Soldier>, defenceBonus:Number)
		{
			this.defenceBonus = defenceBonus;
			//this.resources = resources;
			this.soldiers = soldiers;
			this.ownerData = ownerData;
			
		}
		
	}

}