package  
{
	import assets.AssetsLoader;
	import assets.FontManager;
	import com.communication.XmlProvider;
	import flash.display.Bitmap;
	import flash.events.DataEvent;
	import gameWorld.maps.data.MapsData;
	import interfaces.IScene;
	import starling.core.Starling;
	import starling.core.StatsDisplay;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import urikatils.LoggerHandler;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class TopLevel extends Sprite 
	{
		[Embed(source="../lib/loadingScreen/loadingBg.jpg")]
        private static var Background:Class;

		private static var sAssets:AssetManager;
        
       // private var mActiveScene:IScene;
		private var _xmlProvider:XmlProvider;
		private var bg:DisplayObject;
		private var progressBar:MainProgressBar;
		
		public static var mainPH:Sprite
		
		public function TopLevel() 
		{
			mainPH = this;
		}
		
        public function start(assets:AssetManager):void
        {
			FontManager.setFont();
			
			 // the asset manager is saved as a static variable; this allows us to easily access
            // all the assets from everywhere by simply calling "Root.assets"
            sAssets = assets;
            
            // The background is passed into this method for two reasons:
            // 
            // 1) we need it right away, otherwise we have an empty frame
            // 2) the Startup class can decide on the right image, depending on the device.
            
            //bg = addChild(new Image(background));
            var b:Bitmap = sAssets.scaleFactor == 1 ? new Background() : new Background();
			bg = addChild(new Image(Texture.fromBitmap(b))) as Image;
			
			// The AssetManager contains all the raw asset data, but has not created the textures
            // yet. This takes some time (the assets might be loaded from disk or even via the
            // network), during which we display a progress indicator. 
            
            progressBar = new MainProgressBar(500, 50);
            progressBar.x = (bg.width  - progressBar.width)  / 2;
            //progressBar.y = (background.height - progressBar.height) / 2;
            progressBar.y = bg.height * 0.85;
            addChild(progressBar);
           
			AssetsLoader.loadAssets();
			
			Starling.current.showStats = true;
            sAssets.loadQueue(function onProgress(ratio:Number):void
            {
                //progressBar.ratio = ratio;
                
                // a progress bar should always show the 100% for a while,
                // so we show the main menu only after a short delay. 
                 trace("ratio = " + ratio);
				 if (isNaN(ratio))
				 {
					 init();
					 Starling.juggler.delayCall(removeSplash, 2);
					 
					 return
				 }
                if (ratio == 1)
                    Starling.juggler.delayCall(function():void
                    {
						removeSplash();
                        progressBar.removeFromParent(true);

						 init();
                    }, 0.15);
            });
			LoggerHandler.getInstance.info(this, "Assets ready");

        }
		
		private function removeSplash():void 
		{
			LoggerHandler.getInstance.info(this, "removeSplash");
			bg.removeFromParent(true);
			progressBar.removeFromParent(true);
		}
		
		private function init():void
		{
			this.loadGameConfigurationData();
			
			
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
			
			new ConfigurationData(this._xmlProvider.data);

			loadMapsData();
			addChild(bg);
			addChild(progressBar);
		}
		
		private function loadMapsData():void 
		{
			LoggerHandler.getInstance.info(this, "loadMapsData");
			
			this._xmlProvider = new XmlProvider("maps.xml");
			this._xmlProvider.addEventListener(DataEvent.DATA, loadMapsDataComplete);
			this._xmlProvider.load();

		}
		
		private function loadMapsDataComplete(e:DataEvent):void 
		{
			LoggerHandler.getInstance.info(this, "loadMapsDataComplete");
			
			new MapsData(this._xmlProvider.data);
			
			GameApp.start();
		}
		
        public static function get getAssets():AssetManager { return sAssets; }
		
	}

}