package players 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class Player_AI_Strategy extends Player_AI 
	{
		
		public function Player_AI_Strategy(player:Player_Virtual) 
		{
			super(player)
			_myAttackMethod = AI_AttackMethodEnum.STRONGEST_ARMY;
		}
		
	}

}