package game.board 
{
	import starling.display.Button;
	import starling.display.Graphics;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class NodeSpot extends Sprite 
	{
		static public const SPOT_SIZE:Number = 10;
		private var _graphics:Graphics;
		private var _clickButn:Button;
		
		public function NodeSpot() 
		{
			super();
			init();
		}
		
		public function init():void
		{
			_graphics = new Graphics(this);
			_graphics.lineStyle(1, 0);
			_graphics.beginFill(0x666666);
			_graphics.drawCircle(0, 0, SPOT_SIZE);
			_graphics.endFill();

			
			_clickButn = new Button(Texture.empty(this.width, this.height),"1");
			_clickButn.addEventListener(Event.TRIGGERED, onClick);
						
			addChild(_clickButn);
		}
		
		private function onClick(e:Event):void 
		{
			trace("AA");
			
			dispatchEvent(new BoardEvent(BoardEvent.NODE_CLICK, true));
		}
		
	}

}