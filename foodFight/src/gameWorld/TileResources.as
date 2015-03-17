package gameWorld 
{
	import ascb.util.NumberUtilities;
	import flash.utils.Dictionary;
	import resources.Resource;
	import resources.ResourcesManager;
	//import ascb.util.NumberUtilities;
	/**
	 * ...
	 * @author Avrik
	 */
	public class TileResources extends ResourcesManager
	{
		//static public const MAX_GOLD_INIT:int = 4;
		//static public const MAX_FOOD_INIT:int = 10;
		
	
		public function TileResources() 
		{
			//_goldAmount = Math.round(Math.random() * MAX_GOLD_INIT);
			//_foodAmount = Math.round(Math.random() * MAX_FOOD_INIT);
			
			/*addCarbohydrates(NumberUtilities.random(0, 3));
			addProteins(NumberUtilities.random(0, 3));
			addSugars(NumberUtilities.random(0, 3));
			addFats(NumberUtilities.random(0, 3));*/
			super();
			for (var i:int = 0; i < ConfigurationData.resourcesData.resources.length; i++) 
			{
				//resourcesDic[ ConfigurationData.resourcesData.resources[i].name] = ConfigurationData.resourcesData.resources[i];
				//resourcesDic[ ConfigurationData.resourcesData.resources[i].name] = new Resource(ConfigurationData.resourcesData.resources[i]);
				resourcesArr[i].amount = NumberUtilities.random(0, 3);
			}
			
			//initTilesResources();
		}
		
		private function initTilesResources():void 
		{
			
		}
		
		
		
	}

}