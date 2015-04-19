package gameConfig  
{
	import armies.data.ArmiesData;
	import debug.DebugData;
	import gameWorld.data.WorldData;
	import ui.windows.store.data.StoreData;
	/**
	 * ...
	 * @author Avrik
	 */
	public class ConfigurationData 
	{
		public static var armiesData:ArmiesData;
		public static var worldData:WorldData;
		public static var debugData:DebugData;
		public static var storeData:StoreData;
		
		public function ConfigurationData(data:Object) 
		{
			armiesData = new ArmiesData(data.armies);
			worldData = new WorldData(data.world);
			debugData = new DebugData(data.debug);
			storeData = new StoreData(data.store);
		}
		
	}

}