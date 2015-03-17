package storedGameData 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class SavedAppData implements ISavedData 
	{
		public var gameData:SavedGameData;
		public var userData:SavedUserData;
		public var settingsData:SavedSettingsData;
		
		
		public function SavedAppData(data:Object) 
		{
			if (!data) return;
			
			gameData = new SavedGameData(data.game);
			settingsData = new SavedSettingsData(data.settings);
			userData = new SavedUserData(data.user);
		}
		
	}

}