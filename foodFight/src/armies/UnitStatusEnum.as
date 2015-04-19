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
		
		
		
		static public const IDLE:String = "IDLE";
		static public const HIDE_FROM_ACTION:String = "HIDE_FROM_ACTION";
		static public const SELECTED_FOR_ACTION:String = "SELECTED_FOR_ACTION";
		static public const READY_TO_BE_SELECTED:String = "READY_TO_BE_SELECTED";
		
		
		public function UnitStatusEnum() 
		{
			
		}
		
	}

}