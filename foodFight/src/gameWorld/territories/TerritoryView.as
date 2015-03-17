package gameWorld.territories 
{
	import assets.FontManager;
	import starling.display.Button;
	import starling.display.Graphics;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import ui.ViewComponent;
	/**
	 * ...
	 * @author Avrik
	 */
	public class TerritoryView extends ViewComponent
	{
		private var typeTF:TextField;
		private var _territory:Territory;
		private var _flag:Sprite;
		
		public function TerritoryView(territory:Territory) 
		{
			this._territory = territory;
			//this.typeTF = new TextField(100, 100, "C", FontManager.Badaboom, -1);
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			//addChild(this.typeTF)
			
			
		}
		
		public function setClickable():void
		{
			var butn:Button = new Button(Texture.empty(this.width, this.height));
			butn.addEventListener(Event.TRIGGERED, clicked);
			
			addChild(butn);
		}
		
		private function clicked(e:Event):void 
		{
			Tracer.alert("CLICKED ON ME");
		}
		
		public function setType(str:String):void
		{
			//this.typeTF.text = str;
		}
		
		public function addCapitalFlag():void 
		{
			removeCapitalFlag();
			_flag = new Sprite();
			_flag.touchable = false;
			var g:Graphics = new Graphics(flag);
			g.lineStyle(1, 0);
			
			g.beginFill(this._territory.armyUnit.myArmy.armyData.color);
			g.drawRect(0, 0, 30, 20);
			g.endFill();
			
			g.lineStyle(0, 0);
			g.beginFill(0xffffff);
			g.drawRect(10, 1, 10, 19);
			g.endFill();
			
			g.lineStyle(2, 0);
			g.moveTo(0, 0);
			g.lineTo(0, 50);
			//_flag.flatten();
			
			GameApp.game.world.actionLayer.addObject(flag, this._territory.mainTile.view.x+10, this._territory.mainTile.view.y - 70, 0, false);
		}
		
		public function get flag():Sprite 
		{
			return _flag;
		}
		
		public function removeCapitalFlag():void
		{
			if (_flag)
			{
				_flag.removeFromParent(true);
				_flag = null;
			}
		}
		override public function dispose():void 
		{
			removeCapitalFlag();
			super.dispose();
		}
		
		
	}

}