package gameWorld.data 
{
	import gameWorld.maps.data.MapsData;
	/**
	 * ...
	 * @author Avrik
	 */
	public class WorldData 
	{
		public var totalTiles:int;
		public var tilesInRow:int;
		public var totalTerritories:int;
		//public var mapsData:MapsData
		//public var territoryMaxSize:int;
		
		public function WorldData(data:Object) 
		{
			totalTiles = parseInt(data.totalTiles);
			tilesInRow = parseInt(data.tilesInRow);
			totalTerritories = parseInt(data.totalTerritories);
			//territoryMaxSize = parseInt(data.territoryMaxSize);
			
			/*if (data.maps)
			{
				mapsData = new MapsData(data.maps);
			}*/
			
		}
		
	}

}