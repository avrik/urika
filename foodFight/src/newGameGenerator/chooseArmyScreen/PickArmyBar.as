package newGameGenerator.chooseArmyScreen 
{
	import ascb.util.NumberUtilities;
	import assets.AssetsEnum;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class PickArmyBar extends ViewComponent 
	{
		private var _pickButns:Vector.<PickArmyButton>
		private var _lastPicked:PickArmyButton;
		private var assetsMC:MovieClip;
		
		public function PickArmyBar(assetsMC:MovieClip) 
		{
			this.assetsMC = assetsMC;
			assetsMC = assetsMC;
		}
		
		override protected function init():void 
		{
			super.init();

			_pickButns = new Vector.<PickArmyButton>;
			//var assetsMC:MovieClip = new MovieClip(TopLevel.assets.getTextureAtlas(AssetsEnum.SCREEN_ARMY_PICK_ASSETS).getTextures());

			addChild(new Image(assetsMC.getFrameTexture(0)))
			
			var pickButton:PickArmyButton
			for (var i:int = 0; i < 6; i++) 
			{
				pickButton = new PickArmyButton(i, assetsMC);
				pickButton.addEventListener(Event.SELECT, butnSelected);
				
				pickButton.x = i * 202;
				addChild(pickButton);
				
				_pickButns.push(pickButton);
			}
			
			
			var frame:Image = addChild(new Image(assetsMC.getFrameTexture(1))) as Image;
			frame.touchable = false;
			
			var pickedNum:int = NumberUtilities.random(0, _pickButns.length - 1);
			
			_pickButns[pickedNum].picked = true;
			_lastPicked = _pickButns[pickedNum];
			GamePlayManager.userArmyNum = pickedNum;
			dispatchEvent(new Event(Event.SELECT));
			
		}
		
		private function butnSelected(e:Event):void 
		{
			var pickButton:PickArmyButton = e.currentTarget as PickArmyButton;
			if (pickButton != _lastPicked)
			{
				if (_lastPicked)
				{
					_lastPicked.picked = false;
				}
				_lastPicked = pickButton;
				pickButton.picked = true;
				GamePlayManager.userArmyNum = pickButton.id;
				
				//dispatchEvent(new Event(Event.SELECT));
			}
		}
		
		public function get lastPicked():PickArmyButton 
		{
			return _lastPicked;
		}
		
	}

}