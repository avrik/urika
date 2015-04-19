package assets 
{
	import com.greensock.loading.ImageLoader;
	import globals.MainGlobals;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author Avrik
	 */
	public class AssetsLoader 
	{
		//[Embed(source = "../../lib/BlockSprite.png")]
		//private static var BlockSprite:Class;
		
		
		//NEW GAME MENUS UI
		
		[Embed(source = "../../lib/screens/pickArmyScreen/armyPickScreenSH.png")]
		private static var ArmyPickScreenSH:Class;
		[Embed(source = "../../lib/screens/pickArmyScreen/armyPickScreenSH.xml", mimeType = "application/octet-stream")]
		private static var ArmyPickScreenSH_Data:Class;
		
		//[Embed(source="../../lib/screens/pickArmyScreen/pickArmyOptions.png")]
		//private static var ChooseArmyOptions:Class;
		//[Embed(source="../../lib/screens/pickArmyScreen/pickArmyInfo.png")]
		//private static var ChooseArmyInfo:Class;
		[Embed(source="../../lib/screens/pickArmyScreen/pickArmyBG.jpg")]
		private static var ChooseArmyScreenBg:Class;
		[Embed(source = "../../lib/screens/pickArmyScreen/okButn.png")]
		private static var ChooseArmyOkButn:Class;
		
		
		[Embed(source="../../lib/screens/pickMapScreen/mapPickScreenSH.png")]
		private static var MapPickScreenSH:Class;
		[Embed(source = "../../lib/screens/pickMapScreen/mapPickScreenSH.xml", mimeType = "application/octet-stream")]
		
		private static var MapPickScreenSH_Data:Class;
		
		[Embed(source = "../../lib/screens/pickMapScreen/mapPickOppAssetsSH.png")]
		private static var MapPickOppAssetsSH:Class;
		
		[Embed(source = "../../lib/screens/pickMapScreen/mapPickOppAssetsSH.xml", mimeType = "application/octet-stream")]
		private static var MapPickOppAssetsSH_Data:Class;
		
		
		//[Embed(source = "../../lib/screens/pickMapScreen/pickMap_BG.jpg")]
		//private static var PickMap_BG:Class;
		[Embed(source = "../../lib/screens/pickMapScreen/mapPH.png")]
		private static var PickMap_Map_PH:Class;
		//[Embed(source = "../../lib/screens/pickMapScreen/opponentChoser.png")]
		//private static var PickMap_OpponentChoserBase:Class;
		[Embed(source = "../../lib/screens/pickMapScreen/okButn.png")]
		private static var PickMap_OK_Butn:Class;
		[Embed(source = "../../lib/screens/pickMapScreen/randomButn.png")]
		private static var PickMap_Random_Butn:Class;
		[Embed(source = "../../lib/screens/pickMapScreen/custemButn.png")]
		private static var PickMap_custem_Butn:Class;
		
		//game over window
		[Embed(source = "../../lib/screens/gameOverScreen/gameOverWindow.png")]
		private static var GameOverWindow:Class;
		[Embed(source="../../lib/screens/gameOverScreen/gameOverWindowRow.png")]
		private static var GameOverWindowRow:Class;
		
		
		//GAME PLAY ASSETS
		[Embed(source = "../../lib/armyUnits/armyUnitsSH.png")]
		private static var ArmyUnitsTexture:Class;
	 
		[Embed(source="../../lib/gamePlay/mapBG.jpg")]
		private static var MapBG:Class;
		
		// --- tiles
		/*[Embed(source = "../../lib/tile.png")]
		private static var Tile:Class;
		[Embed(source="../../lib/tileEmpty.png")]
		private static var TileEmpty:Class;*/
		
		
		[Embed(source = "../../lib/gamePlay/tiles/TilesSS.png")]
		private static var TilesSS:Class;
		[Embed(source="../../lib/gamePlay/tiles/TilesSS.xml", mimeType = "application/octet-stream")]
		private static var TilesSS_Data:Class;

		// --- armies
		[Embed(source = "../../lib/armyUnits/armyUnitsSH.xml", mimeType = "application/octet-stream")]
		private static var ArmyUnitsSH_Data:Class;
		[Embed(source = "../../lib/armyUnits/armyUnitsSH.png")]
		private static var ArmyUnitsSH:Class;
		
		[Embed(source = "../../lib/armyUnits/soldiersSS.xml", mimeType = "application/octet-stream")]
		private static var SoldiersSH_Data:Class;
		[Embed(source = "../../lib/armyUnits/soldiersSS.png")]
		private static var SoldiersSH:Class;
		

		[Embed(source = "../../lib/armyUnits/cityzensSS.xml", mimeType = "application/octet-stream")]
		private static var CityzensSH_Data:Class;
		[Embed(source = "../../lib/armyUnits/cityzensSS.png")]
		private static var CityzensSH:Class;
		
		
		[Embed(source = "../../lib/gamePlay/defeatBalloon.png")]
		private static var DefeatBalloon:Class;
		
		//TOP LAYER UI ASSETS
		[Embed(source="../../lib/uiTopLayer/endTurnButn.png")]
		private static var EndTurnButton:Class;
		[Embed(source = "../../lib/uiTopLayer/coinButn.png")]
		private static var CoinButton:Class;
		[Embed(source = "../../lib/uiTopLayer/settingsButn.png")]
		private static var SettingsButton:Class;
		[Embed(source = "../../lib/uiTopLayer/ribbonArmyBox_off.png")]
		private static var ArmyUIBox1:Class;
		[Embed(source = "../../lib/uiTopLayer/ribbonArmyBox_on.png")]
		private static var ArmyUIBox2:Class;
		[Embed(source="../../lib/uiTopLayer/ribbonBase.png")]
		private static var RibbonBase:Class;
		
		[Embed(source="../../lib/uiTopLayer/ribbonInfoBar.png")]
		private static var RibbonInfoBar:Class;
		
		[Embed(source = "../../lib/gamePlay/tiles/TileBorderSH.xml",mimeType="application/octet-stream")]
		private static var TileBorderSH_Data:Class;
		[Embed(source = "../../lib/gamePlay/tiles/TileBorderSH.png")]
		private static var TileBorderSH:Class;
		
		[Embed(source = "../../lib/uiTopLayer/charsSH.xml",mimeType="application/octet-stream")]
		private static var charsSH_Data:Class;
		[Embed(source="../../lib/uiTopLayer/charsSH.png")]
		private static var charsSH:Class;
		
		[Embed(source = "../../lib/uiTopLayer/charsInFrame.xml",mimeType="application/octet-stream")]
		private static var charsInFrameSH_Data:Class;
		[Embed(source="../../lib/uiTopLayer/charsInFrame.png")]
		private static var charsInFrameSH:Class;
		
		[Embed(source = "../../lib/uiTopLayer/settingsWindow.png")]
		private static var SettingsWindow:Class;
		
		[Embed(source="../../lib/uiTopLayer/settingsWindowCloseButn.png")]
		private static var SettingsWindowCloseButn:Class;
		
		[Embed(source="../../lib/armyUnits/talkBaloon.png")]
		private static var SpeechBalloon:Class;
		
		
		[Embed(source = "../../lib/uiTopLayer/ribbonGenericButn.png")]
		private static var RibbonGenericButn:Class;
		
		[Embed(source="../../lib/uiTopLayer/star.png")]
		private static var StarImage:Class;
		
		[Embed(source="../../lib/uiTopLayer/coin.png")]
		private static var CoinImage:Class;
		
		public function AssetsLoader() 
		{
			
		}
		
		public static  function loadAssets():void
		{
			var tileBorderTexture:Texture = Texture.fromBitmap(new TileBorderSH());
			var tileBorderXmlData:XML = XML(new TileBorderSH_Data());
			var tileBorderTextureAtlas:TextureAtlas =  new TextureAtlas(tileBorderTexture, tileBorderXmlData);
				
			
			var charsTexture:Texture = Texture.fromBitmap(new charsSH());
			var charsXmlData:XML = XML(new charsSH_Data());
			var charsTextureAtlas:TextureAtlas =  new TextureAtlas(charsTexture, charsXmlData);
					
			var charsFrameTexture:Texture = Texture.fromBitmap(new charsInFrameSH());
			var charsFrameXmlData:XML = XML(new charsInFrameSH_Data());
			var charsFrameTextureAtlas:TextureAtlas =  new TextureAtlas(charsFrameTexture, charsFrameXmlData);

			var armyUnitsTexture:Texture = Texture.fromBitmap(new ArmyUnitsSH());
			var armyUnitsXmlData:XML = XML(new ArmyUnitsSH_Data());
			var armyUnitsTextureAtlas:TextureAtlas =  new TextureAtlas(armyUnitsTexture, armyUnitsXmlData);
			
			
			var armyPickScreenTextureAtlas:TextureAtlas =  new TextureAtlas( Texture.fromBitmap(new ArmyPickScreenSH()), XML(new ArmyPickScreenSH_Data()));
			var mapPickScreenTextureAtlas:TextureAtlas =  new TextureAtlas( Texture.fromBitmap(new MapPickScreenSH()), XML(new MapPickScreenSH_Data()));
			var pickOppTextureAtlas:TextureAtlas =  new TextureAtlas( Texture.fromBitmap(new MapPickOppAssetsSH()), XML(new MapPickOppAssetsSH_Data()));
			var tilesTextureAtlas:TextureAtlas =  new TextureAtlas( Texture.fromBitmap(new TilesSS()), XML(new TilesSS_Data()));
			var soldiersTextureAtlas:TextureAtlas =  new TextureAtlas( Texture.fromBitmap(new SoldiersSH()), XML(new SoldiersSH_Data()));
			var cityzensTextureAtlas:TextureAtlas =  new TextureAtlas( Texture.fromBitmap(new CityzensSH()), XML(new CityzensSH_Data()));
			
			MainGlobals.assetsManger.addTextureAtlas(AssetsEnum.TILE_BORDER_SH, tileBorderTextureAtlas);
			MainGlobals.assetsManger.addTextureAtlas(AssetsEnum.CHARS_SH, charsTextureAtlas);
			MainGlobals.assetsManger.addTextureAtlas(AssetsEnum.CHARS_FRAME_SH, charsFrameTextureAtlas);
			MainGlobals.assetsManger.addTextureAtlas(AssetsEnum.ARMY_UNITS, armyUnitsTextureAtlas);
			MainGlobals.assetsManger.addTextureAtlas(AssetsEnum.SCREEN_ARMY_PICK_ASSETS, armyPickScreenTextureAtlas);
			MainGlobals.assetsManger.addTextureAtlas(AssetsEnum.SCREEN_MAP_PICK_ASSETS, mapPickScreenTextureAtlas);
			MainGlobals.assetsManger.addTextureAtlas(AssetsEnum.SCREEN_OPP_PICK_ASSETS, pickOppTextureAtlas);
			MainGlobals.assetsManger.addTextureAtlas(AssetsEnum.TILES_SS, tilesTextureAtlas);
			MainGlobals.assetsManger.addTextureAtlas(AssetsEnum.SOLDIERS_SS, soldiersTextureAtlas);
			MainGlobals.assetsManger.addTextureAtlas(AssetsEnum.CITYZENS_SS, cityzensTextureAtlas);
			 
			//TopLevel.assets.addTexture(AssetsEnum.SCREEN_PICK_ARMY, getTexture(ChooseArmyScreen));
			MainGlobals.assetsManger.addTexture(AssetsEnum.SCREEN_PICK_ARMY_BG, getTexture(ChooseArmyScreenBg));
			//TopLevel.assets.addTexture(AssetsEnum.SCREEN_PICK_ARMY_OPTIONS_BAR, getTexture(ChooseArmyOptions));
			MainGlobals.assetsManger.addTexture(AssetsEnum.SCREEN_PICK_OK_BUTN, getTexture(ChooseArmyOkButn));
			//TopLevel.assets.addTexture(AssetsEnum.SCREEN_PICK_INFO, getTexture(ChooseArmyInfo));
			
			//TopLevel.assets.addTexture(AssetsEnum.SCREEN_PICK_MAP_BG, getTexture(PickMap_BG));
			MainGlobals.assetsManger.addTexture(AssetsEnum.SCREEN_PICK_MAP_PH, getTexture(PickMap_Map_PH));
			//TopLevel.assets.addTexture(AssetsEnum.SCREEN_PICK_MAP_OPP_CHOSER, getTexture(PickMap_OpponentChoserBase));
			MainGlobals.assetsManger.addTexture(AssetsEnum.SCREEN_PICK_MAP_OK_BUTN, getTexture(PickMap_OK_Butn));
			MainGlobals.assetsManger.addTexture(AssetsEnum.SCREEN_PICK_MAP_CUSTEM_BUTN, getTexture(PickMap_custem_Butn));
			MainGlobals.assetsManger.addTexture(AssetsEnum.SCREEN_PICK_MAP_RANDOM_BUTN, getTexture(PickMap_Random_Butn));
			
			MainGlobals.assetsManger.addTexture(AssetsEnum.SPEECH_BALLOON_BASE, getTexture(SpeechBalloon));
			//TopLevel.assets.addTexture(AssetsEnum.TILE, getTexture(Tile));
			//TopLevel.assets.addTexture(AssetsEnum.TILE_EMPTY, getTexture(TileEmpty));
			//TopLevel.assets.addTexture(AssetsEnum.BLOCK_SPRITE, getTexture(BlockSprite));
			MainGlobals.assetsManger.addTexture(AssetsEnum.END_TURN_BUTTON, getTexture(EndTurnButton));
			MainGlobals.assetsManger.addTexture(AssetsEnum.MAP_BG, getTexture(MapBG));
			MainGlobals.assetsManger.addTexture(AssetsEnum.RIBBON_BASE, getTexture(RibbonBase));
			MainGlobals.assetsManger.addTexture(AssetsEnum.COIN_BUTTON, getTexture(CoinButton));
			MainGlobals.assetsManger.addTexture(AssetsEnum.SETTINGS_BUTTON, getTexture(SettingsButton));
			MainGlobals.assetsManger.addTexture(AssetsEnum.DEFEAT_BALLOON, getTexture(DefeatBalloon));
			
			
			MainGlobals.assetsManger.addTexture(AssetsEnum.GAME_OVER_WINDOW_BASE, getTexture(GameOverWindow));
			MainGlobals.assetsManger.addTexture(AssetsEnum.GAME_OVER_WINDOW_ROW, getTexture(GameOverWindowRow));
			
			MainGlobals.assetsManger.addTexture(AssetsEnum.SETTINGS_WINDOW_BASE, getTexture(SettingsWindow));
			MainGlobals.assetsManger.addTexture(AssetsEnum.SETTINGS_WINDOW_CLOSE_BUTN, getTexture(SettingsWindowCloseButn));
			
			MainGlobals.assetsManger.addTexture(AssetsEnum.RIBBON_GENERIC_BUTN, getTexture(RibbonGenericButn));
			MainGlobals.assetsManger.addTexture(AssetsEnum.RIBBON_INFO_BAR, getTexture(RibbonInfoBar));
			MainGlobals.assetsManger.addTexture(AssetsEnum.STAR, getTexture(StarImage));
			MainGlobals.assetsManger.addTexture(AssetsEnum.COIN, getTexture(CoinImage));
			
		}
		
		static private function loadAsset():void
		{
			
		}
		
		static public function getArmyUIBoxMC():MovieClip
		{
			var arr:Vector.<Texture> = new Vector.<Texture>;

			arr.push(getTexture(ArmyUIBox1));
			arr.push(getTexture(ArmyUIBox2));
			return new MovieClip(arr);
		}
		
		static public function getArmyUnitsMC():MovieClip
		{
			return new MovieClip(MainGlobals.assetsManger.getTextureAtlas(AssetsEnum.ARMY_UNITS).getTextures());
		}
		
		private static function getTexture(bitmap:Class):Texture
		{
			return Texture.fromBitmap(new bitmap, false, false,MainGlobals.assetsManger.scaleFactor);
		}
		
	}

}