package gameWorld.maps.data 
{
	import storedGameData.SavedGameData_Map;
	/**
	 * ...
	 * @author Avrik
	 */
	public class MapsData 
	{
		public static var mapsDataArr:Vector.<SavedGameData_Map>
		
		public function MapsData(data:Object) 
		{
			if (data.map.length())
			{
				mapsDataArr = new Vector.<SavedGameData_Map>;
				for (var i:int = 0; i <data.map.length() ; ++i) 
				{
					mapsDataArr.push(new SavedGameData_Map(data.map[i]));
				}
			}
		}
		
	}

}