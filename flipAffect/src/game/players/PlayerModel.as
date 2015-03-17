package game.players 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class PlayerModel 
	{
		static public const RED:uint = 0xff0000;
		static public const BLUE:uint = 0x0000ff;
		private var _color:uint;
		
		public function PlayerModel(color:uint) 
		{
			_color = color;
		}
		
		public function get color():uint 
		{
			return _color;
		}
		
	}

}