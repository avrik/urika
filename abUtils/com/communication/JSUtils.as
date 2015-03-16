package com.communication 
{
	/**
	 * ...
	 * @author Amit
	 */
	public class JSUtils 
	{
		
		public static function getFunctionString(funcName:String, ...rest):String {
			var func:String = funcName + "(";
			if(rest && rest.length){
				for (var i:int = 0; i < rest.length; i++) 
				{
					func += "'";
					if (rest[i] is Array) {
						var arr:Array = rest[i] as Array;
						for (var j:String in arr) 
						{
							func += arr[j] + ",";
						}
						func = func.slice(0, func.length - 1);
					}
					else{
						func += rest[i];
					}
					func += "',";
				}
				func = func.slice(0, func.length - 1);
			}
			func += ")";
			return func;
		}
		
	}

}