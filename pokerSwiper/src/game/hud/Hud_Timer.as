package game.hud 
{
	import assets.AssetsEnum;
	import feathers.controls.ProgressBar;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.geom.Rectangle;
	import starling.animation.DelayedCall;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Graphics;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class Hud_Timer extends ViewComponent 
	{
		private var _timeBarSprite:Sprite;
		private var _timeLeftBar:Sprite;
		private var img:Image;
		private var _barSprite:Sprite;
		private var _timeUnits:Vector.<TimeUnit> = new Vector.<TimeUnit>;
		private var delay:DelayedCall;
		
		public function Hud_Timer() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			this.touchable = false;
			_barSprite = new Sprite();
			
			var mc:MovieClip = new MovieClip(TopLevel.assets.getTextureAtlas(AssetsEnum.TIMER_SS).getTextures());
			
			
			_timeBarSprite = new Sprite();
			_timeBarSprite.addChild(new Image(mc.getFrameTexture(0)) as Image);
			
			addChild(_timeBarSprite);
			
			//_barSprite.addChild(new Image(mc.getFrameTexture(1)));
			
			addChild(_barSprite);

			//_timeBarSprite.pivotX = _timeBarSprite.width >> 1;
			//_barSprite.pivotX = _barSprite.width >> 1;
		}
		
		/*public function setTimer(count:int):void 
		{
			var num:int = Math.round(count / 100);
			
			if (num <= 60)
			{
				//_barSprite.width = count / 10; 
			}
		}*/
		
		public function addTimeUnits(num:int):void
		{
			for (var i:int = 0; i < num; ++i) 
			{
				addTimeUnit();
			}
		}
		
		public function addTimeUnit():void
		{
			var tu:TimeUnit = new TimeUnit(_timeUnits.length);
			_timeUnits.push(tu);
			
			_barSprite.addChild(tu);
			tu.x = ((_timeUnits.length - 1) * 11) + 1;
			tu.y = 1;
			
			if (_timeUnits.length > 10 && delay)
			{
				Starling.juggler.remove(delay);
				_barSprite.alpha = 1;
				delay = null;
			}
		}
		
		public function removeTimeUnit():void
		{
			if (_timeUnits.length)
			{
				//_barSprite.removeChild(_timeUnits.pop())
				_timeUnits.pop().removeAnimation();
			}
			
			if (_timeUnits.length < 10)
			{
				if (!delay)
				{
					delay = new DelayedCall(warnning, .2);
					delay.repeatCount = int.MAX_VALUE;
				
					Starling.juggler.add(delay);
				}
				
			} 
			
		}
		
		private function warnning():void 
		{
			_barSprite.alpha = delay.repeatCount % 2 == 0?.5:1;
		}
	}

}