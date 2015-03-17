package players 
{
	import resources.ResourcesManager;

	/**
	 * ...
	 * @author Avrik
	 */
	public class PlayerResourcesManager extends ResourcesManager
	{
		public function PlayerResourcesManager() 
		{
			
		}
		
		public function resetTurnCount():void 
		{
			for (var i:String in this.resourcesArr) 
			{
				this.resourcesArr[i].addPerTurn = 0;
			}
		}
	}

}