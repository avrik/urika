package ui.uiLayer 
{
	import com.MovieClipExtended;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import gameWorld.Tile;
	import resources.Resource;
	import ui.interfaces.IVisualDisplay;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class TileInfoBar extends MovieClipExtended implements IVisualDisplay
	{
		//private var _armyTF:TextField;
		//private var _infoPH:MovieClip;
		//private var _resourcesTF:TextField;
		private var _uiDisplay:MovieClip;
		
		public function TileInfoBar() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			uiDisplay = new SideBarWindowMC();
			this.visible = false;
		}
		
		public function showInfoOf(tile:Tile):void
		{
			this.visible = true;
			/*if (this._infoPH)
			{
				this.removeChild(this._infoPH)
			}
			this._infoPH = new MovieClip();
			this.addChild(this._infoPH);
			this._armyTF = TextFieldAdder.add(this._infoPH, TextFormater.getDefultFormat());
			this._armyTF.text = "Owner : " + tile.owner.name + " Family\nSoldiers : " + tile.armyUnit.totalSoldiers;
			this._armyTF.x = 5;
			this._armyTF.y = 5;
			
			this._resourcesTF = TextFieldAdder.add(this._infoPH, TextFormater.getDefultFormat());
			
			var str:String = "Tile Resources : \n";
			for each (var item:Resource in tile.resources.resourcesArr) 
			{
				str += item.data.name + " : " + item.amount + "\n";
			}
			this._resourcesTF.width = this.width - 5;
			this._resourcesTF.text = str;
			this._resourcesTF.multiline = true;
			this._resourcesTF.wordWrap = true;
			this._resourcesTF.x = 5;
			this._resourcesTF.y = this._armyTF.y + this._armyTF.height + 10;*/
			var str:String = "Tile Info : \nOwner : " + tile.owner.name + " Family\nSoldiers : " + tile.armyUnit.totalSoldiers + "\n\n";
			str += "Tile Resources : \n";
			for each (var item:Resource in tile.resources.resourcesArr) 
			{
				str += item.data.name + " : " + item.amount + "\n";
			}
			TextField(this._uiDisplay.labelTxt.label).text = str;
		}
		
		public function clear():void 
		{
			/*if (this._infoPH)
			{
				this.removeChild(this._infoPH)
				this._infoPH = new MovieClip();
				this._infoPH = null;
			}*/
			this.visible = false;
			
		}
		
		/* INTERFACE ui.interfaces.IVisualDisplay */
		
		public function set uiDisplay(value:MovieClip):void 
		{
			_uiDisplay = value;
			this.addChild(_uiDisplay);
		}
		
	}

}