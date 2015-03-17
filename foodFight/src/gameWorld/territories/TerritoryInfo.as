package gameWorld.territories 
{
	import flash.display.MovieClip;
	import gameWorld.data.TerritoryInfoData;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class TerritoryInfo extends ViewComponent
	{
		private var _uiDisplay:MovieClip;
		private var _infoData:TerritoryInfoData;
		
		public function TerritoryInfo(infoData:TerritoryInfoData) 
		{
			this._infoData = infoData;
			
		}
		
		override protected function init():void 
		{
			super.init();

		}
		

	}

}