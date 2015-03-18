package 
{
	//import com.purplebrain.adbuddiz.sdk.nativeExtensions.AdBuddizSDK;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import nape.util.ShapeDebug;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	import starling.utils.formatString;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	/*import com.appflood.AppFlood; 
	import com.appflood.AppFlood.AFEventDelegate; 
	import com.appflood.AppFlood.AFRequestDelegate; */
	/**
	 * ...
	 * @author Avrik
	 */
	
	// TODO : Sounds
	// TODO : Animations
	// TODO : PayTable page
	// TODO : Summary page
	// TODO : LOGO
	
	// TODO BEFORE UPLOAD : QA
	// TODO BEFORE UPLOAD : Remove debug

	
	public class Main extends Sprite 
	{
		private var mStarling:Starling;
		
		[Embed(source = "../lib/loadingScreen/urikaScreen.jpg")]
		private static var Background:Class;
		public static var debug:ShapeDebug;
		
		
	   
   
		public function Main():void 
		{
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			//stage.autoOrients = true;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(flash.events.Event.DEACTIVATE, deactivate);
			stage.frameRate = 60;
			//stage.color = 0x192823;
			stage.color = 0;
			
			
			CONFIG::debug
			{
				trace("ON DEBUG");
				debug = new ShapeDebug(stage.stageWidth, stage.stageHeight);
				addChild(debug.display);
			}
			
			// touch or gesture?
			//Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			//Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			// entry point
			
			// new to AIR? please read *carefully* the readme.txt files!
			
			var stageWidth:int  = 720;
            var stageHeight:int = 1280;
			
			//var stageWidth:int  = this.stage.fullScreenWidth;
			//var stageHeight:int = this.stage.fullScreenHeight;
			
			trace("WIDTH === " + stageWidth);
			trace("HEIGHT === " + stageHeight);
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			Starling.multitouchEnabled = true;
			
			 var viewPort:Rectangle = RectangleUtil.fit(
                new Rectangle(0, 0, stageWidth, stageHeight),
                new Rectangle(0, 0, this.stage.fullScreenWidth, this.stage.fullScreenHeight),
                ScaleMode.SHOW_ALL, iOS);
            
            // create the AssetManager, which handles all required assets for this resolution
            
            //var scaleFactor:int = viewPort.height < 480 ? 1 : 2; // midway between 320 and 640
            var scaleFactor:int = 1;// viewPort.height < 1000 ? 1 : 2; // midway between 320 and 640
			
			
			//Tracer.alert("SCALE FACTOR === " + scaleFactor);
			
			
            var appDir:File = File.applicationDirectory;
            var assets:AssetManager = new AssetManager(scaleFactor);
            
            assets.verbose = Capabilities.isDebugger;
            assets.enqueue(
                //appDir.resolvePath("audio"),
                //appDir.resolvePath(formatString("fonts/{0}x", scaleFactor)),
                //appDir.resolvePath(formatString("textures/{0}x", scaleFactor)),
				
            );
            
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
            var background:Bitmap = scaleFactor == 1 ? new Background() : new Background();

            //Background = BackgroundHD = null; // no longer needed!
            
            background.x = viewPort.x;
            background.y = viewPort.y;
            background.width  = viewPort.width;
            background.height = viewPort.height;
            background.smoothing = true;
            addChild(background);
            
            // launch Starling
            
            mStarling = new Starling(TopLevel, stage, viewPort);
            mStarling.stage.stageWidth  = stageWidth;  // <- same size on all devices!
            mStarling.stage.stageHeight = stageHeight; // <- same size on all devices!
            mStarling.simulateMultitouch  = true;
            mStarling.enableErrorChecking = false;
			
            mStarling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
            {
                removeChild(background);

                var app:TopLevel = mStarling.root as TopLevel;
                var bgTexture:Texture = Texture.fromBitmap(background, false, false, scaleFactor);
                
                app.start(assets);
                mStarling.start();
            });
            
            // When the game becomes inactive, we pause Starling; otherwise, the enter frame event
            // would report a very long 'passedTime' when the app is reactivated. 
            
            NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.ACTIVATE, function (e:*):void { mStarling.start(); });
            
            NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.DEACTIVATE, function (e:*):void { mStarling.stop(); } );
				
		}
		
		private function deactivate(e:flash.events.Event):void 
		{
			NativeApplication.nativeApplication.exit();
		}
		
	}
	
}