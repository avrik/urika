package debug 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class DebugData 
	{
		public var restoreLastGame:Boolean;
		public var showTutorial:Boolean;
		public var cheatData:CheatData;
		
		public function DebugData(data:Object) 
		{
			restoreLastGame = data.@restoreLastGame=="true"?true:false;
			showTutorial = data.@restoreLastGame=="true"?true:false;
			cheatData = new CheatData(data.cheatData);
		}
		
	}

}