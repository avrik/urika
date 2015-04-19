package armies 
{
	import assets.AssetsLoader;
	import assets.FontManager;
	import interfaces.IDisposable;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import urikatils.LoggerHandler;
	/**
	 * ...
	 * @author Avrik
	 */
	public class DeployUnitsManager extends EventDispatcher implements IDisposable
	{
		private var _army:Army;
		private var deployRefImg:Button;
		private var _soldiersToDeployArr:Vector.<Soldier>;
		private var _totalTF:TextField;
		private var titleTF:TextField;
		private var refTween:Tween;
		
		public function DeployUnitsManager(army:Army,soldiersToDeployArr:Vector.<Soldier>) 
		{
			this._soldiersToDeployArr = soldiersToDeployArr;
			this._army = army;
		}
		
		public function start():void 
		{
			titleTF = new TextField(MainGameApp.getInstance.game.view.topLayerPH.stage.stageWidth, 100, "Place your new units", FontManager.Badaboom, -2, 0xffffff);
			MainGameApp.getInstance.game.view.topLayerPH.addChild(titleTF);
			
			titleTF.x = 5;
			titleTF.y = 20;
			titleTF.autoScale = true;
			titleTF.touchable = false;
			
			/*var img:Image =  new Image(SoldierView.getSoldierView(_army.armyData.id - 1));
			deployRefImg = new Button(img.texture);
			deployRefImg.addEventListener(Event.TRIGGERED, clicked);
			
			deployRefImg.scaleX = deployRefImg.scaleY = .5;
			deployRefImg.pivotX = deployRefImg.width / 2;
			deployRefImg.pivotY = deployRefImg.height / 2;
			deployRefImg.y = -deployRefImg.height/2;
			
		
			MainGameApp.getInstance.game.world.actionLayer.addObject(deployRefImg, titleTF.textBounds.left - deployRefImg.width - 100, -(deployRefImg.height / 2 + 10));
			
			_totalTF = new TextField(img.width, img.height, String(this._soldiersToDeployArr.length), FontManager.Badaboom, -2, 0xffffff);
			_totalTF.autoScale = true;
			//_totalTF.hAlign = HAlign.CENTER;
			_totalTF.touchable = false;
			
			deployRefImg.addChild(_totalTF);
			
			LoggerHandler.getInstance.info(this,"INIT WAIT FOR DEPOT ARMY UNIT");
			
			for each (var item:ArmyUnit in _army.armyUnits) 
			{
				item.waitingForDeploy = true;
				item.addEventListener(ArmyUnit.PICK_FOR_DEPLOY_NEW_SOLDIER, addToArmyUnitClick);
			}*/
		}
		
		private function clicked(e:Event):void 
		{
			//LoggerHandler.getInstance.info(this,"CLICKED");
			var total:int = this._soldiersToDeployArr.length;
			
			//GameApp.getInstance.game.world.actionLayer.removeObject(deployRefImg);
			
			for (var i:int = 0; i <total ; ++i) 
			{
				sendNewSoldierToArmyUnit(_army.getRandomUnit(Army.DEPLOY_BY_ENEMYS));
			}
		}
		
		private function addToArmyUnitClick(e:Event):void 
		{
			var armyUnit:ArmyUnit = e.currentTarget as ArmyUnit;
			
			if (this._soldiersToDeployArr.length > 1)
			{
				_totalTF.text = String(this._soldiersToDeployArr.length - 1);
			} else
			{
				//deployRefImg.removeFromParent(true);
				//GameApp.getInstance.game.world.actionLayer.removeObject(deployRefImg);
				//deployRefImg = null;
				deployRefImg.visible = false;
			}
			
			sendNewSoldierToArmyUnit(armyUnit)
		}
		
		private function sendNewSoldierToArmyUnit(armyUnit:ArmyUnit):void 
		{
			//sendNewSoldierToArmyUnit();
			var soldier:Soldier = _army.getNewSoldier();
			var soldierVisual:Sprite = soldier.getVisual(3);
			
			soldierVisual.x = deployRefImg.x;
			soldierVisual.y = deployRefImg.y;
			
			refTween = new Tween(soldierVisual, .5, Transitions.EASE_OUT);
			refTween.scaleTo(1);
			refTween.onComplete = unitMoveComplete;
			refTween.onCompleteArgs = [armyUnit, soldierVisual];
			refTween.moveTo(armyUnit.getLocationPoint().x, armyUnit.getLocationPoint().y);
			
			Starling.juggler.add(refTween);

			MainGameApp.getInstance.game.world.map.disable = true;
		}
		
		private function unitMoveComplete(armyUnit:ArmyUnit,soldierVisual:Sprite):void 
		{
			MainGameApp.getInstance.game.world.map.disable = false;
			MainGameApp.getInstance.game.world.actionLayer.removeObject(soldierVisual);
			
			//soldierVisual.removeFromParent(true);
			
			armyUnit.addSoldier(this._soldiersToDeployArr.pop());
			
			if (!this._soldiersToDeployArr.length)
			{
				for each (var item:ArmyUnit in _army.armyUnits) 
				{
					item.waitingForDeploy = false;
					item.removeEventListener(ArmyUnit.PICK_FOR_DEPLOY_NEW_SOLDIER, addToArmyUnitClick);
				}
				
				
				dispatchEvent(new Event(Event.COMPLETE));
			}
			armyUnit.myArmy.myPlayer.reportActionComplete();
		}
		
		
		/* INTERFACE interfaces.IDisposable */
		
		public function dispose():void 
		{
			if (deployRefImg)
			{
				MainGameApp.getInstance.game.world.actionLayer.removeObject(deployRefImg);
				deployRefImg = null;
			}
			
			_totalTF.removeFromParent(true);
			//deployRefImg.removeFromParent(true);
			titleTF.removeFromParent(true);
			Starling.juggler.remove(refTween);
		}
		
	}

}