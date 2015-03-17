package gameWorld.territories 
{
	import ascb.util.NumberUtilities;
	/**
	 * ...
	 * @author Avrik
	 */
	public class SentencesLibrary 
	{
		
		public function SentencesLibrary() 
		{
			
		}
		
		private static const loseArr	:Array = ["NO!!","MUMMY", "TASTE BAD!","WHY!","U STINK!","I ATE U"];
		private static const winArr		:Array = ["EAT IT!","V", "|army| RULES!"];
		private static const clickArr	:Array = ["WHAT?","GO AWAY", "I'M YUMMY","BITE ME"];
		private static const patrolArr	:Array = ["|army| RULES!", "TASTY", "FEED ME", "DEATH TO |enemy|", "GO |army|"];
		private static const attackArr	:Array = ["ATTACK!", "FIGHT!", "KAWABANGA!"];
		
		public static function getRandomLoseSentence():String
		{
			return loseArr[NumberUtilities.random(0, (loseArr.length - 1))];
		}
		
		public static function getRandomWinSentence(armyName:String):String
		{
			var randStr:String = winArr[NumberUtilities.random(0, (winArr.length - 1))];
			randStr = randStr.replace("|army|", armyName);
			return randStr;
		}
		
		public static function getRandomClickSentence():String
		{
			return clickArr[NumberUtilities.random(0, (clickArr.length - 1))];
		}
		
		public static function getRandomPatrolSentence(armyName:String, enemyName:String):String
		{
			var randStr:String = patrolArr[NumberUtilities.random(0, (patrolArr.length - 1))];
			randStr = randStr.replace("|enemy|", enemyName);
			randStr = randStr.replace("|army|", armyName);
			return randStr;
		}
		
		static public function getRandomAttackSentence():String 
		{
			return attackArr[NumberUtilities.random(0, (attackArr.length - 1))];
		}
	}

}