package ui.uiLayer 
{
	import assets.AssetsEnum;
	import assets.AssetsLoader;
	import assets.FontManager;
	import globals.MainGlobals;
	import players.Player;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Graphics;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import ui.ViewComponent;
	/**
	 * ...
	 * @author Avrik
	 */
	public class PlayerInfoDisplay extends ViewComponent
	{
		private var _player:Player;
		private var _totalSoldiersTF:TextField;
		private var _armyNameTF:TextField;
		private var _onBox:Image;
		private var charImage:Image;
		//private var box:Sprite;
		private var box:Button;
		private var _territoriesTF:TextField;
		private var tween:Tween;
		
		public function PlayerInfoDisplay(player:Player) 
		{
			this._player = player;

		}
		
		override protected function init():void 
		{
			super.init();
			
			var mc:MovieClip = AssetsLoader.getArmyUIBoxMC();
			
			box = new Button(mc.getFrameTexture(0));
			box.addEventListener(Event.TRIGGERED, boxClicked);
			addChild(box);
			
			//box.addChild(new Image(mc.getFrameTexture(0))) as Image;
			this._onBox = box.addChild(new Image(mc.getFrameTexture(1))) as Image;
			this._onBox.color = this._player.army.armyData.color;
			this._onBox.touchable = false;
			
			_armyNameTF = new TextField(box.width-10, 50, this._player.army.armyData.name, FontManager.Badaboom, BitmapFont.NATIVE_SIZE, 0xffffff, true);
			_armyNameTF.hAlign = HAlign.RIGHT;
			_armyNameTF.touchable = false;
			//_armyNameTF.vAlign = "center";
			_armyNameTF.autoScale = true;
			_armyNameTF.y = box.height - _armyNameTF.height / 2 - 20;
			box.addChild(_armyNameTF);
			//_armyNameTF.filter = BlurFilter.createGlow(0,1,1,.2);
			
			_totalSoldiersTF = new TextField(box.width - 10, 50, this._player.army.getSoldiersNumber().toString(), FontManager.Badaboom, -2, 0xffffff, true);
			_totalSoldiersTF.hAlign = HAlign.RIGHT;
			_totalSoldiersTF.vAlign = VAlign.CENTER;
			_totalSoldiersTF.autoScale = true;
			_totalSoldiersTF.touchable = false;
			//_totalSoldiersTF.y = box.height - _armyNameTF.height / 2 - 10;
			box.addChild(_totalSoldiersTF);
			
			this.pivotX = box.width / 2;
			this.pivotY = box.height / 2;
			setChar();
			
			var territoriesCircle:Sprite = new Sprite();
				
			var territoriesGraphics:Graphics = new Graphics(territoriesCircle);
			territoriesGraphics.lineStyle(2,0xD87EF9,.5);
			territoriesGraphics.beginFill(0x6E1B87, 1);
			territoriesGraphics.drawCircle(0, 0, 15);
			territoriesGraphics.endFill();
			box.addChild(territoriesCircle);
			
			territoriesCircle.x = box.width - territoriesCircle.width / 2 - 5;
			territoriesCircle.touchable = false;
			
			_territoriesTF = new TextField(territoriesCircle.width + 6, territoriesCircle.height, "0", FontManager.Badaboom, -1, 0xffff00);
			_territoriesTF.autoScale = true;
			_territoriesTF.x = 3;
			_territoriesTF.pivotX = _territoriesTF.width / 2;
			_territoriesTF.pivotY = _territoriesTF.height / 2;
			
			territoriesCircle.addChild(_territoriesTF);
		}
		
		private function boxClicked(e:Event):void 
		{
			//LoggerHandler.getInstance.info(this,"BOX CLICKED");
			dispatchEvent(new Event(Event.SELECT));
		}

		public function setChar():void
		{
			var charMC:MovieClip = new MovieClip(MainGlobals.assetsManger.getTextureAtlas(AssetsEnum.CHARS_SH).getTextures());
			charImage = this.addChild(new Image(charMC.getFrameTexture((this._player.army.armyData.id-1)))) as Image;
			charImage.scaleX = charImage.scaleY = .8;
			charImage.x = -25;
			charImage.y = -40;
			charImage.touchable = false;
			
			clearMark();
		}
		
		public function update():void
		{
			this.totalSoldiers = this._player.army.getSoldiersNumber();
			
			if (!this._player.army.getSoldiersNumber() && this._player.alive)
			{
				this.visible = false;
			}
			
			_territoriesTF.text = this._player.territories.length.toString();
		}
		
		public function markMyTurn():void
		{
			charImage.setVertexColor(0, 0xffffff);
			charImage.setVertexColor(1, 0xffffff);
			charImage.setVertexColor(2, 0xffffff);
			_onBox.visible = true;
			//this.scaleX = this.scaleY = 1.1;
			
			tween = new Tween(this, .5, Transitions.EASE_OUT_BOUNCE);
			tween.scaleTo(1.1);
			
			Starling.juggler.add(tween);
		}
		
		public function clearMark():void 
		{
			var c:uint = 0x666666;
			charImage.setVertexColor(0, c);
			charImage.setVertexColor(1, c);
			charImage.setVertexColor(2, c);
			charImage.setVertexColor(3, 0x333333);

			_onBox.visible = false;
			//this.scaleX = this.scaleY = 1;
			
			tween = new Tween(this, .5, Transitions.EASE_OUT);
			tween.scaleTo(1);
			
			Starling.juggler.add(tween);
		}
		
		public function set totalSoldiers(value:int):void 
		{
			_totalSoldiersTF.text = value.toString();
		}
		
		public function get onBox():Image 
		{
			return _onBox;
		}
		
		public function get player():Player 
		{
			return _player;
		}
		
	}

}