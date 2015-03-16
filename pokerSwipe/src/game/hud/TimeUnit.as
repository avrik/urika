package game.hud 
{
	import assets.AssetsEnum;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.utils.Color;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class TimeUnit extends ViewComponent 
	{
		private var img:Image;
		
		public function TimeUnit(id:int) 
		{
			var mc:MovieClip = new MovieClip(TopLevel.assets.getTextureAtlas(AssetsEnum.TIMER_SS).getTextures());
			img = new Image(mc.getFrameTexture(1));
			addChild(img);
			
			if (id < 5)
			{
				img.color = 0xDD1E2F;
			} else if (id < 10)
			{
				img.color = 0xFF6633;
			}
			
			addAnimation()
		}
		
		override protected function init():void 
		{
			super.init();
			
			
		}
		
		public function addAnimation():void
		{
			this.alpha = 0;
			var tween:Tween = new Tween(this, .2);
			tween.fadeTo(1);
			//tween.onComplete = destroy;
			
			Starling.juggler.add(tween);
		}
		
		public function removeAnimation():void
		{
			var tween:Tween = new Tween(this, .5);
			tween.fadeTo(0);
			tween.onComplete = destroy;
			
			Starling.juggler.add(tween);
		}
		
		private function destroy():void 
		{
			this.removeFromParent(true);
		}
		
		
		
	}

}