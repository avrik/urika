package  
{
	import assets.AssetsLoader;
	import assets.FontManager;
	import com.communication.XmlProvider;
	import flash.display.Bitmap;
	import flash.events.DataEvent;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.ResizeEvent;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class TopLevel extends Sprite 
	{
		
		//[Embed(source="../lib/loadingScreen/loadingBg.jpg")]
       // private static var Background:Class;
		

		private static var sAssets:AssetManager;
        
       // private var mActiveScene:IScene;
		private var _xmlProvider:XmlProvider;
		private var bg:DisplayObject;
		//private var progressBar:MainProgressBar;
		
		public static var mainPH:Sprite
		
		public function TopLevel() 
		{
			//GlobalEventManger.addEvent(GlobalEventsEnum.NEW_GAME, initNewGame);
			mainPH = this;
		}
		
        public function start(assets:AssetManager):void
        {
			trace("AA= == " + Starling.current.viewPort.bottom);
			
			stage.addEventListener(ResizeEvent.RESIZE, onResize);
 

			//FontManager.setFont();
			
			 // the asset manager is saved as a static variable; this allows us to easily access
            // all the assets from everywhere by simply calling "Root.assets"
            sAssets = assets;
            
            // The background is passed into this method for two reasons:
            // 
            // 1) we need it right away, otherwise we have an empty frame
            // 2) the Startup class can decide on the right image, depending on the device.
            
            //bg = addChild(new Image(background));
            //var b:Bitmap = sAssets.scaleFactor == 1 ? new Background() : new Background();
			//bg = addChild(new Image(Texture.fromBitmap(b))) as Image;
			
			// The AssetManager contains all the raw asset data, but has not created the textures
            // yet. This takes some time (the assets might be loaded from disk or even via the
            // network), during which we display a progress indicator. 
            
            /*progressBar = new MainProgressBar(500, 50);
            progressBar.x = (bg.width  - progressBar.width)  / 2;
            //progressBar.y = (background.height - progressBar.height) / 2;
            progressBar.y = bg.height * 0.85;
            addChild(progressBar);*/
           
			AssetsLoader.loadAssets(TopLevel.assets.scaleFactor);
			FontManager.setFonts();
			
			CONFIG::debug
			{
				Starling.current.showStats = true;
			}
			
			sAssets.loadQueue(function onProgress(ratio:Number):void
            {
                //progressBar.ratio = ratio;
                
                // a progress bar should always show the 100% for a while,
                // so we show the main menu only after a short delay. 
                 trace("ratio" + ratio);
				 if (isNaN(ratio))
				 {
					
					 //progressBar.removeFromParent(true);
					 init();
					 Starling.juggler.delayCall(removeSplash, 2);
					 
					 return
				 }
                if (ratio == 1)
                    Starling.juggler.delayCall(function():void
                    {
						removeSplash();
                        //progressBar.removeFromParent(true);
                        //showScene(NewGameGenerator);
						init();
                    }, 0.15);
            });

        }
		
		
		private function onResize(e:ResizeEvent):void
		{
			Tracer.alert("RESIZE!!!!!");
			  // set rectangle dimensions for viewPort:
			  var viewPortRectangle:Rectangle = new Rectangle();
			  viewPortRectangle.width = e.width; viewPortRectangle.height = e.height
		 
			  // resize the viewport:
			  Starling.current.viewPort = viewPortRectangle;
		 
			  // assign the new stage width and height:
			  stage.stageWidth = e.width;
			  stage.stageHeight = e.height;
		}
		
		private function removeSplash():void 
		{
			//bg.removeFromParent(true);
			//progressBar.removeFromParent(true);
		}
		
		private function init():void
		{
			//this.loadGameConfigurationData();
			
			Application.start();
		}
        
		/*private function loadGameConfigurationData():void 
		{
			this._xmlProvider = new XmlProvider("../xml/gameConfiguration.xml");
			this._xmlProvider.addEventListener(DataEvent.DATA, loadDataComplete);
			this._xmlProvider.load();
		}*/
		
		private function loadDataComplete(e:DataEvent):void 
		{
			new ConfigurationData(this._xmlProvider.data);

			//addChild(bg);
			//addChild(progressBar);
			
			Application.start();
		}

		
        public static function get assets():AssetManager { return sAssets; }
		
	}

}