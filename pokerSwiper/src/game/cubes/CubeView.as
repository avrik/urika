package game.cubes 
{
	import assets.AssetsEnum;
	import starling.display.Image;
	import starling.display.MovieClip;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class CubeView extends ViewComponent 
	{
		
		private var cubeMC:MovieClip
		public function CubeView() 
		{
			cubeMC = new MovieClip(TopLevel.assets.getTextureAtlas(AssetsEnum.CUBE_SS).getTextures());
		}
		
		override protected function init():void 
		{
			super.init();
			
			addChild(new Image(cubeMC.getFrameTexture(0)));
			
			centerPivot();
		}
		
		
		
		
		
	}

}