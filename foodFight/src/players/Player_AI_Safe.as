package players 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class Player_AI_Safe extends Player_AI 
	{
		
		public function Player_AI_Safe(player:Player_Virtual)
		{
			super(player)
			_myAttackMethod = AI_AttackMethodEnum.SAFE;
		}
		
	}

}