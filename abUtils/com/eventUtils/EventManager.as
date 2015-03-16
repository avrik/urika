package com.eventUtils
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Amit
	 */
	public class EventManager 
	{
		private static var _listenersDictionary:Dictionary = new Dictionary();
		
		/**
		 * Adds an event listener to an EventDispatcher object.
		 * When the event listener is added, it is associated with a group of event listeners of the same group number for easier removal of event listeners.
		 * @param	dispatcher The object to which to add the event listener
		 * @param	type The listener type
		 * @param	func The event handler function
		 * @param	groupNum The number of the group to which to assign the event listener. Recommended to send as an exponent of 2 (1, 2, 4, 8, 16, etc.). If a sum of different exponents is sent, the event will be associated with both (ex. : 7 will assign the event to group 1, 2 and 4).
		 * @param	useWeakRef Whether to use a weak reference. Defaults to true.
		 */
		public static function addEvent(dispatcher:IEventDispatcher, type:String, func:Function, groupNum:int = 0, useWeakRef:Boolean = true):void {
			dispatcher.addEventListener(type, func, false, 0, useWeakRef);
			var groupNumArr:Array = getArrayFromEnum(groupNum);
			for (var i:int = 0; i < groupNumArr.length; i++) 
			{
				var struct:ListenerStruct = new ListenerStruct(type, func);
				if (!_listenersDictionary[groupNumArr[i]])
					_listenersDictionary[groupNumArr[i]] = new ListenerDictionaryExt();
				ListenerDictionaryExt(_listenersDictionary[groupNumArr[i]]).add(struct, dispatcher);
			}
		}
		
		/**
		 * Removes an event listener from an EventDispatcher object.
		 * @param	dispatcher The object from which to remove the event listener
		 * @param	type The listener type
		 * @param	func func The event handler function
		 */
		public static function removeEvent(dispatcher:IEventDispatcher, type:String, func:Function):void {
			if (!(dispatcher && type && func is Function)) {
				return;
			}
			dispatcher.removeEventListener(type, func);
			for (var i:String in _listenersDictionary) 
			{
				var dict:ListenerDictionaryExt = _listenersDictionary[i] as ListenerDictionaryExt;
				var length:int = dict.length;
				length = dict.remove(dispatcher, type, func);
			}
		}
		
		/**
		 * Removes all event listeners added by the EventManager from a given EventDispatcher object.
		 * @param	dispatcher The object from which to remove all event listeners
		 */
		public static function clearEventsByDispatcher(dispatcher:IEventDispatcher):void {
			if (!dispatcher) return;
			for (var i:String in _listenersDictionary) {
				var dict:ListenerDictionaryExt = _listenersDictionary[i] as ListenerDictionaryExt;
				var length:int = dict.length;
				length = dict.removeByVal(dispatcher);
			}
		}
		
		/**
		 * Gets all event listeners assigned to a given EventDispatcher object.
		 * @param	dispatcher The object for which to search for event listeners
		 * @return An Array of all event types of event listeners assigned to the EventDispatcher object.
		 */
		public static function getEventsForDispatcher(dispatcher:IEventDispatcher):Array {
			var arr:Array = [];
			for (var i:String in _listenersDictionary) {
				var dict:ListenerDictionaryExt = _listenersDictionary[i] as ListenerDictionaryExt;
				arr = arr.concat(dict.getByVal(dispatcher));
			}
			return arr;
		}
		
		/**
		 * Clear all events assigned to a given group.
		 * Notice: Will not treat sum of exponents as separate groups (ex. : group number 7 will be treated as 7, and not as the sum of 1, 2 and 4)
		 * @param	groupNum The group number for which to remove all assigned event listeners
		 */
		public static function clearEventsByGroupName(groupNum:int):void {

			if (!_listenersDictionary[groupNum])
				return;
			var dict:ListenerDictionaryExt = _listenersDictionary[groupNum] as ListenerDictionaryExt;
			emptyDictionary(dict);
			
			delete _listenersDictionary[groupNum];
			
			
			
		}
		
		private static function emptyDictionary(dict:ListenerDictionaryExt):void {
			while (dict.enumeratorVec.length > 0)
			{
				var struct:ListenerStruct = dict.enumeratorVec[0];
				removeEvent(dict[struct], struct.type, struct.func);
			}
		}
		
		private static function enumIntoArray(enum:int, arr:Array):Array {
			if (arr.length == 1) {
				if(arr[0] == enum)
					return arr;
				return null;
			}
			var arrSum:int = getSum(arr);
			if (arrSum == enum) {
				return arr;
			}
			if (arrSum < enum) {
				return null;
			}
			var thisNum:int = arr.shift();
			var tempArr:Array = copyArr(arr);
			var arrWithThisNum:Array = enumIntoArray(enum - thisNum, arr);
			if (arrWithThisNum) {
				arr = arrWithThisNum;
				arr.push(thisNum);
				return arr;
			}
			var arrWithoutThisNum:Array = enumIntoArray(enum, tempArr);
			if (arrWithoutThisNum) {
				arr = arrWithoutThisNum;
				return arr;
			}
			return null;
		}
		
		private static function copyArr(arr:Array):Array {
			var arr2:Array = [];
			for (var i:int = 0; i < arr.length; i++) 
			{
				arr2.push(arr[i]);
			}
			return arr2;
		}
		
		private static function getSum(arr:Array):int {
			var sum:int = 0;
			for (var i:int = 0; i < arr.length; i++) 
			{
				sum += arr[i];
			}
			return sum;
		}
		
		private static function getArrayFromEnum(enum:int):Array {
			if (enum == 0) return [0];
			var sum:int = 0;
			var pow:int = 0;
			var arr:Array = [];
			do {
				var added:int = int(Math.pow(2, pow));
				if (added == enum) {
					arr = [enum];
					break;
				}
				if (added > enum) break;
				sum += added;
				arr.push(added);
				pow++;
			} while (sum < enum);
			return enumIntoArray(enum, arr);
		}
	}

}