package armies 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class UnitStatusEnum 
	{
		static public const WAITING_FOR_DEPLOY:String = "waitingForDeploy";
		static public const WAITING_FOR_ACTION:String = "waitingForAction";
		static public const WAITING_FOR_INTERACTION:String = "waitingForInteraction";
		
		static public const PICKED_FOR_ACTION:String = "pickedForAction";
		static public const PICKED_FOR_INTERACTION:String = "pickedForInteraction";
		
		static public const ATTACK:String = "attack";
		static public const MOVE:String = "move";
		static public const ATTACKED:String = "attacked";
		static public const ACTIONLESS:String = "actionless";
		
		
		public function UnitStatusEnum() 
		{
			
		}
		
	}

}