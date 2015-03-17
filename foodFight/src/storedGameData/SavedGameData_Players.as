package storedGameData 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class SavedGameData_Players  implements ISavedData
	{
		public var players:Vector.<SavedGameData_Player>
		public var virtualPlayers:Vector.<SavedGameData_Player>
		public var humanPlayer:SavedGameData_Player;
		
		public function SavedGameData_Players(data:Object) 
		{
			if (data)
			{
				if (data.player.length())
				{
					players = new Vector.<SavedGameData_Player>;
					virtualPlayers = new Vector.<SavedGameData_Player>;

					for (var i:int = 0; i < data.player.length() ; i++)
					{
						var playerData:SavedGameData_Player = new SavedGameData_Player(data.player[i]);
						if (playerData.isHuman)
						{
							humanPlayer = playerData;
						} else
						{
							virtualPlayers.push(playerData);
						}
						players.push(playerData);
					}
				}
			}
		}
		
	}

}