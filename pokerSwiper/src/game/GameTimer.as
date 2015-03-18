package game 
{
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Avrik
	 */
	public class GameTimer 
	{
		static public const MAX_TIME:int = 56;
		static public const START_TIME:int = 15;
		
		private var _pauseTimer:Boolean;
		private var _timer:DelayedCall;
		//private var _timeTF:TextField;
		private var _onPauseTime:int;
		private var _timeEnd:Boolean;
		
		public function GameTimer() 
		{
			_timer = new DelayedCall(updateTimer, 1);
			addToTimer(START_TIME);
		}

		public function startTimer():void 
		{
			
			Starling.juggler.add(_timer);
		}
		
		private function updateTimer():void 
		{
			if (_timer.isComplete)
			{
				_timeEnd = true;
				Application.game.timeOver();
			} else
			{
				Application.game.hud.timer.removeTimeUnit();
			}
		}
		
		public function addToTimer(value:int):void
		{
			//Tracer.alert("OPOI === "+_timer.repeatCount)
			if (_timer.repeatCount + value > MAX_TIME)
			{
				value = MAX_TIME-_timer.repeatCount;
			}
			
			_timer.repeatCount += value;
			
			if (value)
			{
				Application.game.hud.timer.addTimeUnits(value);
			}
			
		}
		
		public function set pauseTimer(value:Boolean):void 
		{
			_pauseTimer = value;
			
			if (value)
			{
				_onPauseTime = _timer.repeatCount;
				Starling.juggler.remove(_timer);
			} else
			{
				_timer = new DelayedCall(updateTimer, 1);
				_timer.repeatCount = _onPauseTime;

				Starling.juggler.add(_timer);
			}
		}
		
		public function get timeEnd():Boolean 
		{
			return _timeEnd;
		}
		
	}

}