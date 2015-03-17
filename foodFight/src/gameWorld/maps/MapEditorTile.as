package gameWorld.maps 
{
	import gameWorld.territories.Territory;
	import gameWorld.Tile;
	import starling.display.Button;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class MapEditorTile extends Tile 
	{
		
		public function MapEditorTile(id:int)
		{
			
			super(id);
			
		}
		
		public function activate():void
		{
			//var _butn:Button = new Button(Texture.empty(view.width, view.height));
			var _butn:Button = new Button(view.tileImg.texture);
			_butn.addEventListener(Event.TRIGGERED, tileClicked);
			view.addChild(_butn);
		}
		
		private function tileClicked(e:Event):void 
		{
			//Tracer.alert("TILE CLICKED");
			
			if (view.empty)
			{
				view.setUnEmpty();
			} else
			{
				view.setEmpty();
			}
			
			dispatchEvent(new Event(Event.SELECT));
		}
		
		override public function get territory():Territory 
		{
			return super.territory;
		}
		
		override public function set territory(value:Territory):void 
		{
			super.territory = value;
			
			this.view.myColor = 0x00ff00;
		}
		
		
		
		
		
	}

}