package game.levels 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class Level 
	{
		private var _levelData:LevelData;
		private var _id:int;
		
		public function Level(id:int, levelData:LevelData) 
		{
			this._id = id;
			this._levelData = levelData;
			
		}
		
		public function get levelData():LevelData 
		{
			return _levelData;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
	}

}