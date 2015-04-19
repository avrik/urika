package gamePlay  
{
	import armies.data.ArmyData;
	import gameWorld.data.TerritoryInfoData;
	/**
	 * ...
	 * @author Avrik
	 */
	public class GamePlayManager 
	{
		static public var totalPlayersPlaying:int = 5;
		static public var userArmyNum:int = 0;
		static public var armiesPickedForPlaying:Vector.<ArmyData>;
		static public var shuffleAllPlayer:Boolean = false;
		
		public function GamePlayManager() 
		{
			
		}
		
		static public function showTerritoryInfo(infoData:TerritoryInfoData):void 
		{
			//removeTerritoryInfo();
			//territoryInfo = GameApp.getInstance.viewPort.addChild(new TerritoryInfo(infoData)) as TerritoryInfo;
			
		}
		
		static public function removeTerritoryInfo():void 
		{
			/*if (territoryInfo)
			{
				territoryInfo.destroy();
				territoryInfo = null;
			}*/
		}
		
		
		
	}

}