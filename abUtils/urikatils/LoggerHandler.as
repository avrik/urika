package urikatils 
{
	import mx.utils.StringUtil;
	/**
	 * ...
	 * @author Avrik
	 */
	public class LoggerHandler 
	{
		static private const WARN:String = "WARN";
		static private const ERROR:String = "ERROR";
		static private const FATAL:String = "FATAL";
		static private const INFO:String = "INFO";
		static private const DEBUG:String = "DEBUG";
		static private const STATE:String = "STATE";
		
		private static var instance:LoggerHandler = new LoggerHandler();
		
		public static function get getInstance():LoggerHandler { return instance }
		
		public function LoggerHandler() 
		{
			
		}
		
		public function error(target:Object, message:String, ...rest):void
		{
			logMessage(target, ERROR, message, rest);
		}
		
		public function warn(target:Object, message:String, ...rest):void
		{
			logMessage(target, WARN, message, rest);
		}
		
		public function fatal(target:Object, message:String, ...rest):void
		{
			logMessage(target, FATAL, message, rest);
		}
		
		public function info(target:Object, message:String, ...rest):void
		{
			logMessage(target, INFO, message, rest);
		}
		
		public function state(target:Object, message:String, ...rest):void
		{
			logMessage(target, STATE, message, rest);
		}
		
		public function debug(target:Object, message:String, ...rest):void
		{
			logMessage(target, DEBUG, message, rest);
		}
		
		private function logMessage(target:Object, level:String, message:String, ...rest):void
		{
			var c:uint
			switch (level) 
			{
				case STATE:
					c = 4;
					break;
				case ERROR:
					c = 3;
					break;
				case WARN:
					c = 2;
					break;
				case INFO:
					c = 1;
					break;
				default:
			}
			//var logItem:LogItem
			trace(c+":[" + level + "]" + String(target).replace("object", "") + " " + StringUtil.substitute(message, rest));
			
		}
		
	}

}