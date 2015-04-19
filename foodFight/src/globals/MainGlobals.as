package globals 
{
	import starling.display.Sprite;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author Avrik
	 */
	public class MainGlobals 
	{
		static private var _assets:AssetManager;
		static public var mainPH:Sprite;
		
		public function MainGlobals() 
		{
			
		}
		
		 public static function set assetsManger(value:AssetManager):void { _assets=value; }
		 public static function get assetsManger():AssetManager { return _assets; }
		
	}

}