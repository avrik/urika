package resources 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Avrik
	 */
	public class ResourcesManager 
	{

		public var resourcesArr:Vector.<Resource> = new Vector.<Resource>;
		
		public function ResourcesManager() 
		{
			
			
			for (var i:int = 0; i < ConfigurationData.resourcesData.resources.length; i++) 
			{
				//resourcesDic[ ConfigurationData.resourcesData.resources[i].name] = ConfigurationData.resourcesData.resources[i];
				resourcesArr.push(new Resource(ConfigurationData.resourcesData.resources[i]));
				//Resource(resourcesDic[ ConfigurationData.resourcesData.resources[i].name]).amount = NumberUtilities(0, 3);
			}
		}
		
	/*	public function addCarbohydrates(num:int):void
		{
			for (var i:int = 0; i <num ; i++) 
			{
				var item:Resource_Carbohydrate = new Resource_Carbohydrate();
				_carbohydrates.push(item);
			}
		}
		
		public function addProteins(num:int):void
		{
			for (var i:int = 0; i <num ; i++) 
			{
				var item:Resource_Protein = new Resource_Protein();
				_proteins.push(item);
			}
		}
		
		public function addSugars(num:int):void
		{
			for (var i:int = 0; i <num ; i++) 
			{
				var item:Resource_Sugar = new Resource_Sugar();
				_sugars.push(item);
			}
		}
		
		public function addFats(num:int):void
		{
			for (var i:int = 0; i <num ; i++) 
			{
				var item:Resource_Fat = new Resource_Fat();
				_fats.push(item);
			}
		}
		
		public function get carbohydrates():Vector.<Resource_Carbohydrate> 
		{
			return _carbohydrates;
		}
		
		public function get proteins():Vector.<Resource_Protein> 
		{
			return _proteins;
		}
		
		public function get sugars():Vector.<Resource_Sugar> 
		{
			return _sugars;
		}
		
		public function get fats():Vector.<Resource_Fat> 
		{
			return _fats;
		}*/
	}

}