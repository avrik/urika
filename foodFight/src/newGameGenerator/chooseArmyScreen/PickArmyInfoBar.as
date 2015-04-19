package newGameGenerator.chooseArmyScreen 
{
	import assets.FontManager;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import ui.ViewComponent;
	import urikatils.LoggerHandler;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class PickArmyInfoBar extends ViewComponent 
	{
		private var assetsMC:MovieClip;
		private var _titleTF:TextField;
		private var _descriptionTF:TextField;
		private var _extraTF:TextField;
		
		private var titlesArr:Array = [	"Sweet Army!",
										"Fruit Army!",
										"Meat Army!",
										"Pastry Army!",
										"Dairy Army!",
										"Vege Army!"
														];
														
		private var descriptionArr:Array = ["use the sugar rush to crush all the other flavors Distributed sweetness and overpower foodland!",
											"use the sugar rush to crush all the other flavors Distributed sweetness and overpower foodland!",
											"use the sugar rush to crush all the other flavors Distributed sweetness and overpower foodland!",
											"use the sugar rush to crush all the other flavors Distributed sweetness and overpower foodland!",
											"use the sugar rush to crush all the other flavors Distributed sweetness and overpower foodland!",
											"use the sugar rush to crush all the other flavors Distributed sweetness and overpower foodland!"

														];
		
		private var extraArr:Array = [	"swift : 1 extra move each turn",
										"lucky : 1 extra attack each turn",
										"Bloodthirsty : +1 attack in battle",
										"diplomatic : +1 in diplomacy",
										"flexible : random bonus each turn",
										"peaceful : +1 defence in battle"
										];											
		
		public function PickArmyInfoBar(assetsMC:MovieClip) 
		{
			this.assetsMC = assetsMC;
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			addChild(new Image(assetsMC.getFrameTexture(23))) as Image;
			
			this._titleTF = addTF( -3, 0xFFFFFF, 20);
			this._descriptionTF = addTF( -2, 0xC88DDF, 110);
			this._extraTF = addTF( -2, 0x99FFCC, 190);
			
			this.touchable = false;
			setArmyNum(0);
		}
		
		private function addTF(size:Number,color:uint,y:Number):TextField
		{
			var tf:TextField = new TextField(580, 100, "", FontManager.Badaboom,size, color);
			tf.hAlign = HAlign.LEFT;
			tf.autoScale = true;
			tf.y = y;
			tf.x = 370;
			
			addChild(tf);
			return tf;
		}
		
		public function setArmyNum(num:int):void
		{
			LoggerHandler.getInstance.info(this,"SET ARMY NUM == " + num);
			this._titleTF.text = titlesArr[num];
			this._descriptionTF.text = descriptionArr[num];
			this._extraTF.text = extraArr[num];
		}

		
	}

}