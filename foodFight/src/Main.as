package 
{
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import globals.MainGlobals;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class Main extends Sprite 
	{
		//static public var mainStage:Sprite;
		[Embed(source = "../lib/loadingScreen/urikaScreen.jpg")]
		private static var Background:Class;
		 
		private var _starling:Starling;

		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(flash.events.Event.DEACTIVATE, deactivate);
			stage.frameRate = 60;
			stage.color = 0;
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			//Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			// entry point
			
			// new to AIR? please read *carefully* the readme.txt files!
			var stageWidth:int  = 1280;
            var stageHeight:int = 720;
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			Starling.multitouchEnabled = true;
			
			 var viewPort:Rectangle = RectangleUtil.fit(
                new Rectangle(0, 0, stageWidth, stageHeight), 
                new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
                ScaleMode.SHOW_ALL, iOS);
            
            // create the AssetManager, which handles all required assets for this resolution
            
            var scaleFactor:int = 1;// viewPort.width < 1280 ? 1 : 2; // midway between 320 and 640
            var appDir:File = File.applicationDirectory;
            var assets:AssetManager = new AssetManager(scaleFactor);
            
            assets.verbose = Capabilities.isDebugger;
            assets.enqueue(
                //appDir.resolvePath("audio"),
                //appDir.resolvePath(formatString("fonts/{0}x", scaleFactor)),
                //appDir.resolvePath(formatString("textures/{0}x", scaleFactor)),
				
            );
            
			MainGlobals.assetsManger = assets;
            // While Stage3D is initializing, the screen will be blank. To avoid any flickering, 
            // we display a startup image now and remove it below, when Starling is ready to go.
            // This is especially useful on iOS, where "Default.png" (or a variant) is displayed
            // during Startup. You can create an absolute seamless startup that way.
            // 
            // These are the only embedded graphics in this app. We can't load them from disk,
            // because that can only be done asynchronously - i.e. flickering would return.
            // 
            // Note that we cannot embed "Default.png" (or its siblings), because any embedded
            // files will vanish from the application package, and those are picked up by the OS!
            
            //var background:Bitmap = scaleFactor == 1 ? new Background() : new BackgroundHD();
            var background:Bitmap = new Background();
            background.x = viewPort.x;
            background.y = viewPort.y;
            background.width  = viewPort.width;
            background.height = viewPort.height;
            background.smoothing = true;
            addChild(background);
            
            // launch Starling
            
            _starling = new Starling(Application, stage, viewPort);
            _starling.stage.stageWidth  = stageWidth;  // <- same size on all devices!
            _starling.stage.stageHeight = stageHeight; // <- same size on all devices!
            _starling.simulateMultitouch  = true;
            _starling.enableErrorChecking = false;
			
            _starling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
            {
                removeChild(background);

                var app:Application = _starling.root as Application;
                var bgTexture:Texture = Texture.fromBitmap(background, false, false, scaleFactor);

                app.start();
                _starling.start();
            });
            
            // When the game becomes inactive, we pause Starling; otherwise, the enter frame event
            // would report a very long 'passedTime' when the app is reactivated. 
			
            NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.ACTIVATE, function (e:*):void { _starling.start(); });
            
            NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.DEACTIVATE, function (e:*):void { _starling.stop(); });
			
			//mainStage = this;
			//this.addChild(new GameApp()) as GameApp;
		}
		
		private function deactivate(e:flash.events.Event):void 
		{
			// auto-close
			NativeApplication.nativeApplication.exit();
		}
		
	}
	
}