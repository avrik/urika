package  
{
	import assets.AssetsEnum;
	import feathers.core.PopUpManager;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import game.Board;
	import game.cubes.Cube;
	import game.Game;
	import game.payTable.PayTableWindow;
	import starling.display.Graphics;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;


	/**
	 * ...
	 * @author Avrik
	 */
	public class Application extends flash.events.EventDispatcher
	{
		private static var instance:Application = new Application();
		
		
		private static var _game:Game;
		
		public static var debugMode:Boolean = false;
		private static var _appHud:AppHud;
		
		private static var _hudPH:Sprite;
		private static var _gamePH:Sprite;
		static private var _payTableWindow:PayTableWindow;
		
		
		public static function getInstance():Application
		{
			return instance;
		}
		public  static var highScore:int;
		
		public function Application() 
		{
			
		}
		
		/*private var adBuddizSDK:AdBuddizSDK = initSDK();
		
		private function initSDK():AdBuddizSDK {
			CONFIG::release
			{
				var sdk:AdBuddizSDK = new AdBuddizSDK();
				sdk.cacheAds(); // to start caching ads as soon as your app starts
				return sdk;
			}
			
			return null;
	   }*/
   
		
		static public function startNewGame():void 
		{
			_game.startGame();
		}
		
		static public function newGame():void 
		{
			trace("NEW GAME");
			if (_game)
			{
				_game.dispose();
				_game = null;
			}
			
			_game = new Game();
			_game.initGame();
			
		}
		
		static public function start():void 
		{
			
			highScore = getHighScore();
			var bgImg:Image = new Image(TopLevel.assets.getTexture(AssetsEnum.GAME_BG));
			
			var frameMC:MovieClip = new MovieClip(TopLevel.assets.getTextureAtlas(AssetsEnum.GAME_FRAME_SS).getTextures());
			
			TopLevel.mainPH.addChild(bgImg);
			
			var widthNum:Number = Cube.getCubeSize() * Board.CUBES_IN_ROW;
			var matrixBG:Sprite = new Sprite();
			var g:Graphics = new Graphics(matrixBG);
			//g.beginFill(Color.GREEN);
			//g.beginFill(0x192823);
			g.beginFill(0);
			g.drawRoundRect( -5, -5, widthNum + 5, widthNum + 5, 5);
			g.endFill();
			
			matrixBG.pivotX = matrixBG.width >> 1;
			matrixBG.pivotY = matrixBG.height >> 1;
			
			matrixBG.x = TopLevel.mainPH.stage.stageWidth / 2;
			matrixBG.y = TopLevel.mainPH.stage.stageHeight / 2;
			TopLevel.mainPH.addChild(matrixBG);
			
			
			bgImg.x = (TopLevel.mainPH.stage.stageWidth - bgImg.width) / 2;
			bgImg.y = (TopLevel.mainPH.stage.stageHeight - bgImg.height) / 2;
			_gamePH = TopLevel.mainPH.addChild(new Sprite()) as Sprite;
			_hudPH = TopLevel.mainPH.addChild(new Sprite()) as Sprite;
			
			
			var frameImg:Image = new Image(frameMC.getFrameTexture(0));
			frameImg.x = -20
			frameImg.y = -20;

			matrixBG.addChild(frameImg) as Image;
			newGame()
			
			
			_appHud = new AppHud();
			_hudPH.addChild(_appHud);
		}
		
		static public function getHighScore():int
		{
			var file:File = File.applicationStorageDirectory.resolvePath("pokerSwipe.file");
			if (!file.exists) {
				Tracer.alert("There is no object saved!");
				return 0;
			}
			
			//create a file stream and open it for reading
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var object:Object = fileStream.readObject(); //read the object
			Tracer.alert("Game High score: " + object.highScore)

			return parseInt(object.highScore);
		}
		
		
		static public function saveHighScore(score:int):void
		{
			highScore = score;
			var object:Object = new Object();//create an object to store
			object.highScore =  score.toString();// asObject.text; //set the text field value to the value property

			var file:File = File.applicationStorageDirectory.resolvePath("pokerSwipe.file");
			if (file.exists)
				file.deleteFile();
			
			var fileStream:FileStream = new FileStream(); //create a file stream
			fileStream.open(file, FileMode.WRITE);// and open the file for write
			fileStream.writeObject(object);//write the object to the file
			fileStream.close();
		}
		
		static public function openPayTableWindow():void 
		{
			if (!_payTableWindow)
			{
				_game.pauseGame();
				_payTableWindow = new PayTableWindow()
				_payTableWindow.addEventListener(Event.CLOSE, closePayTable);
				
				PopUpManager.addPopUp(_payTableWindow);
				_payTableWindow.show();
			}
		}
		
		static private function closePayTable(e:Event):void 
		{
			if (_payTableWindow)
			{
				_game.unpauseGame();
				PopUpManager.removePopUp(_payTableWindow);
				_payTableWindow = null;
			}
			
		}
		
		
		
		static public function get game():Game 
		{
			return _game;
		}
		
		static public function get appHud():AppHud 
		{
			return _appHud;
		}
		
		static public function get hudPH():Sprite 
		{
			return _hudPH;
		}
		
		static public function get gamePH():Sprite 
		{
			return _gamePH;
		}
		
	}

}