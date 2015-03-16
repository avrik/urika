package  com.eventUtils
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class ListenerDictionaryExt extends Dictionary {
		
		private var _length:int;
		public function get length():int { return _length }
		
		private var _enumeratorVec:Vector.<ListenerStruct>
		public function get enumeratorVec():Vector.<ListenerStruct> { return _enumeratorVec }
		
		public function ListenerDictionaryExt(weakRef:Boolean = true) {
			super(weakRef);
			_length = 0;
			_enumeratorVec = new Vector.<ListenerStruct>();
		}
		
		/**
		 * Adds a key-value pair to the dictionary
		 * @param	key
		 * @param	val
		 * @return The new length of the dictionary
		 */
		public function add(key:ListenerStruct, val:IEventDispatcher):int {
			if (!this[key]) _length++;
			this[key] = val;
			_enumeratorVec.push(key);
			return _length;
		}
		
		private function removeByPos(index:int):void {
			var key:ListenerStruct = _enumeratorVec[index];
			IEventDispatcher(this[_enumeratorVec[index]]).removeEventListener(key.type, key.func);
			_enumeratorVec.splice(index, 1);
			delete this[key];
			_length--;
		}
		
		/**
		 * Removes all key-value pairs having a given EventDispatcher obect as the value. 
		 * @param	val The EventDispatcher object to remove from the dictionary
		 * @return The new length of the dictionary
		 */
		public function removeByVal(val:IEventDispatcher):int {
			for (var i:int = 0; i < _enumeratorVec.length; i++) 
			{
				if (this[_enumeratorVec[i]] == val) {
					removeByPos(i);
					i--;
				}
			}
			return _length;
		}
		
		/**
		 * Gets all event types of event listeners assigned to a given EventDispatcher object. 
		 * @param	val The object for which to search for event listeners
		 * @return An Array of all event types of event listeners assigned to the EventDispatcher object.
		 */
		public function getByVal(val:IEventDispatcher):Array {
			var arr:Array = [];
			for (var i:int = 0; i < _enumeratorVec.length; i++) 
			{
				if (this[_enumeratorVec[i]] == val) {
					arr.push(_enumeratorVec[i].type);
				}
			}
			return arr;
		}
		
		/**
		 * Removes a given event listener from the dictionary
		 * @param	dispatcher The EventDispatcher object to which the event listener is attached
		 * @param	type The event type of the event listener
		 * @param	func The event handler
		 * @return The new length of the dictionary
		 */
		public function remove(dispatcher:IEventDispatcher, type:String, func:Function):int {
			for (var i:int = 0; i < _enumeratorVec.length; i++) 
			{
				var struct:ListenerStruct = _enumeratorVec[i];
				if (struct.type == type && struct.func == func && this[struct] == dispatcher) {
					removeByPos(i);
					i--;
				}
			}
			return _length;
		}
	}
	
}
