package game.board.boxes 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class BoxModel 
	{
		public var id:int;
		public var color:uint;
		public var xStartPos:int;
		public var yStartPos:int;
		public var xPos:int;
		public var yPos:int;
		
		public function BoxModel(x:int, y:int, myColor:uint) 
		{
			xStartPos = x;
			yStartPos = y;
			xPos = xStartPos;
			yPos = yStartPos;
			color = myColor;
		}
		
	}

}