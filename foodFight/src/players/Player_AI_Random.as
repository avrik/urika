package players 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class Player_AI_Random extends Player_AI 
	{
		
		public function Player_AI_Random(player:Player_Virtual)
		{
			super(player);
			_myAttackMethod = AI_AttackMethodEnum.RANDOM;
		}
		
	}

}