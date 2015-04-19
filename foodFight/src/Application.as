package  
{
	import assets.AssetsLoader;
	import assets.FontManager;
	import com.communication.XmlProvider;
	import flash.events.DataEvent;
	import gameConfig.ConfigurationData;
	import gameWorld.maps.data.MapsData;
	import globals.MainGlobals;
	import preloader.MainProgressBar;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import urikatils.LoggerHandler;
	
	/**
	 * ...
	 * @author Avrik
	 */
	
	//TODO -- build map editor 							[ 80% DONE ]
	//TODO -- score logic 								[ 10% DONE ]
	//TODO -- defeat animations 						[ 60% DONE ]
	//TODO -- move all texts to xml 					[ 0% DONE ]
	//TODO -- texts & contenet	 						[ 20% DONE ]
	//TODO -- territoryInfo		 						[ 0% DONE ]
	//TODO -- tutorial			 						[ 0% DONE ]
	//TODO -- zoom by pinch	 							[ 0% DONE ]
	//TODO -- army bonuses								[ 50% DONE ]
	//TODO -- coins logic								[ 50% DONE ]
	//TODO -- reset game function						[ 20% DONE ] 
	//TODO -- + bonus/exp animation						[ 0% DONE ]  design
	//TODO -- achivments								[ 0% DONE ]  design
	//TODO -- shop										[ 20% DONE ] design
	//TODO -- game over screen							[ 20% DONE ] design
	
	
	//TODO #2 -- SD/HD assets for diffrent resulotions
	//TODO #2 -- sounds
	//TODO #2 -- animations
	//TODO #2 -- QA
	//TODO #2 -- Switch all assets from PNG to ATF
	//TODO #2 -- preformence
	
	//TODO #3 -- facebook features version
	
	
	//BUGS
	
	// problem with the move action and marking the new clickable army units
	// when player is out of the game, the game stuck (maybe the last player in the ui)
	// coins amount not right
	// 
		
		
	public class Application extends Sprite 
	{
		[Embed(source="../lib/loadingScreen/loadingBg.jpg")]
        private static var Background:Class;

		private var _xmlProvider		:XmlProvider;
		private var _loadingBackground	:Image;
		private var _progressBar		:MainProgressBar;
		
		public function Application() 
		{
			MainGlobals.mainPH = new Sprite();
			this.addChild(MainGlobals.mainPH);
		}
		
        public function start():void
        {
			Starling.current.showStats = true;
			
			setPreloader()
			FontManager.setFont();
			AssetsLoader.loadAssets();
			this.loadGameConfigurationData();
        }
		
		private function setPreloader():void 
		{
			_loadingBackground = new Image(Texture.fromBitmap(new Background()));
			addChild(_loadingBackground);

            _progressBar = new preloader.MainProgressBar(500, 50);
            _progressBar.x = (_loadingBackground.width  - _progressBar.width)  / 2;
            //progressBar.y = (background.height - progressBar.height) / 2;
            _progressBar.y = _loadingBackground.height * 0.85;
            addChild(_progressBar);
		}
		
		private function loadGameConfigurationData():void 
		{
			LoggerHandler.getInstance.info(this, "loadGameConfigurationData");
			
			this._xmlProvider = new XmlProvider("gameConfiguration.xml");
			this._xmlProvider.addEventListener(DataEvent.DATA, loadDataComplete);
			this._xmlProvider.load();
		}
		
		private function loadDataComplete(e:DataEvent):void 
		{
			LoggerHandler.getInstance.info(this, "loadDataComplete");
			
			new gameConfig.ConfigurationData(this._xmlProvider.data);

			loadMapsData();
			addChild(_loadingBackground);
			addChild(_progressBar);
		}
		
		private function loadMapsData():void 
		{
			LoggerHandler.getInstance.state(this, "loadMapsData");
			
			this._xmlProvider = new XmlProvider("maps.xml");
			this._xmlProvider.addEventListener(DataEvent.DATA, loadMapsDataComplete);
			this._xmlProvider.load()
		}
		
		private function loadMapsDataComplete(e:DataEvent):void 
		{
			LoggerHandler.getInstance.info(this, "loadMapsDataComplete");
			
			new MapsData(this._xmlProvider.data);
			removePreloader()
			MainGameApp.getInstance.start();
		}
		
		private function removePreloader():void 
		{
			LoggerHandler.getInstance.info(this, "removeSplash");
			_loadingBackground.removeFromParent(true);
			_progressBar.removeFromParent(true);
		}

	}

}