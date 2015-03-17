package players 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class PlayerData 
	{
		private var _name:String;
		
		public function PlayerData(data:Object) 
		{
			this._name = data.name;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
	}

}