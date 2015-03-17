package game.pions 
{
	import starling.display.Graphics;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class Pion extends Sprite 
	{
		private var _color:uint;
		private var _graphics:Graphics;
		
		public function Pion(teamColor:uint) 
		{
			super();
			this._graphics = new Graphics(this);
			
			color = teamColor;
		}
		
		public function get color():uint 
		{
			return _color;
		}
		
		public function set color(value:uint):void 
		{
			_color = value;
			
			_graphics.clear();
			_graphics.beginFill(_color);
			_graphics.drawCircle(0, 0, 10);
			_graphics.endFill();
		}
		
	}

}