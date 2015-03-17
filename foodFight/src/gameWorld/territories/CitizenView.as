package gameWorld.territories 
{
	import armies.data.ArmyData;
	import ascb.util.NumberUtilities;
	import assets.AssetsEnum;
	import assets.FontManager;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.geom.Rectangle;
	import gameWorld.Tile;
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Graphics;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class CitizenView extends ViewComponent 
	{
		private var jumpTween:Tween;
		private var citizenImg:Image;
		private var shadow:Sprite
		private var patrolTween:Tween;
		private var _onTilePatrol:Tile;
		private var speechBallon:Sprite
		private var speechBallonTF:TextField;
		private var citizen:Citizen;
		private var _pause:Boolean;
		private var tilesToPatrol:Vector.<Tile>;
		private var _imgButn:Button;
		private var balloonTween:Tween;
		private var _onPatrol:Boolean;
		
		public function CitizenView(citizen:Citizen) 
		{
			this.citizen = citizen;
			//this.touchable = false;
		}
		
		override protected function init():void 
		{
			super.init();
			
			var mc:MovieClip = new MovieClip(TopLevel.assets.getTextureAtlas(AssetsEnum.CITYZENS_SS).getTextures());
			citizenImg = new Image(mc.getFrameTexture(citizen.armyData.id - 1));
			
			_imgButn = new Button(citizenImg.texture);
			_imgButn.pivotX = _imgButn.width / 2;
			_imgButn.pivotY = _imgButn.height / 2;
			
			this._imgButn.scaleX = this._imgButn.scaleY = .25;
			
			addShadow();
			addChild(_imgButn);
			
			
			//centerPivot();
			
			speechBallon = new Sprite();

			var scaleTexture:Scale9Textures = new Scale9Textures(TopLevel.assets.getTexture(AssetsEnum.SPEECH_BALLOON_BASE), new Rectangle(7, 7,30, 15));
			var scaleImg:Scale9Image = new Scale9Image(scaleTexture);
			scaleImg.width = 100;
			
			speechBallon.addChild(scaleImg) as Scale9Image;
			speechBallonTF = new TextField(speechBallon.width-10, speechBallon.height - 6, "", FontManager.Badaboom, 24, 0xce0300);
			speechBallonTF.autoScale = true;
			speechBallonTF.touchable = false;
			speechBallonTF.x = 5;
			
			speechBallon.addChild(speechBallonTF);
			speechBallon.pivotX = 50;
			speechBallon.pivotY = speechBallon.height;
			speechBallon.visible = false;
			speechBallon.touchable = false;
			
			addChild(speechBallon);
			_imgButn.addEventListener(Event.TRIGGERED, clicked);
			
			this.visible = false;
			
			
		}
		
		private function addShadow():void 
		{
			shadow = new Sprite();
			
			var graphics:Graphics = new Graphics(shadow);
			graphics.beginFill(0, .5);
			graphics.drawCircle(_imgButn.width / 2 - 10, _imgButn.height, 10);
			//graphics.drawCircle(0, 0, 10);
			graphics.endFill();
			
			shadow.pivotX = shadow.width / 2;
			shadow.pivotY = shadow.height / 2;
			
			shadow.scaleY = .6;
			addChild(shadow);
		}
		
		private function clicked(e:Event):void 
		{
			showTalkBaloon(SentencesLibrary.getRandomClickSentence(), citizen.armyData.color);
		}
		
		public function startPatrol(tilesToPatrol:Vector.<Tile>):void
		{
			citizen.inBase = false;
			this.tilesToPatrol = tilesToPatrol;
			//_onPatrolNum = 0;
			
			if (!_pause)
			{
				_onPatrol = true;
				this.visible = true;
			}
			
			patrol(this.tilesToPatrol.pop(),0);
		}
		
		public function patrol(gotoTile:Tile, delay:Number = -1,completeFunc:Function=null):void
		{
			if (this._onTilePatrol == gotoTile) patrol(this._onTilePatrol.getRandomNeighbor());
			//_onPatrolNum++;
			/*if (!_pause)
			{
				this.visible = true;
			}*/
			
			this._onTilePatrol = gotoTile;

			patrolTween = new Tween(this, 1.5);
			
			patrolTween.moveTo(gotoTile.view.x, gotoTile.view.y - 15);
			patrolTween.onStart = onStartPatrol
			patrolTween.onUpdate = onUpdataPatrol
			patrolTween.delay = delay == -1?NumberUtilities.random(3, 10):delay;
			patrolTween.onCompleteArgs = [gotoTile];
			patrolTween.onComplete = completeFunc!=null?completeFunc:patrolComplete;
			
			Starling.juggler.add(patrolTween);
		}
		
		private function lastPatrolComplete(gotoTile:Tile):void 
		{
			_onPatrol = false;
			citizen.completePatrol();
			citizen.inBase = true;
			this.visible = false;
		}
		
		private function patrolComplete(gotoTile:Tile):void 
		{
			Starling.juggler.remove(patrolTween);
			
			if (this.tilesToPatrol.length)
			{
				this.saySomething()
				patrol(this.tilesToPatrol.pop());
			} else
			{
				returnToBase();
				
			}
		}
		
		public function returnToBase():void 
		{
			patrol(citizen.onTerritory.mainTile, 0, lastPatrolComplete);
		}
		
		public function stopPatrol():void 
		{
			this._pause = true;
			if (!this.citizen.inBase)
			{
				this.visible = false;
			}
			
			//Starling.juggler.removeTweens(this);
			//Starling.juggler.removeTweens(citizenImg);
		}
		
		public function continuePatrol():void 
		{
			this._pause = false;
			
			if (!this.citizen.inBase)
			{
				this.visible = true;
			}
			
			/*if (_onPatrol && this.tilesToPatrol.length)
			{
				this.startPatrol(this.tilesToPatrol);
			}*/
			/*if (this._onTilePatrol)
			{
				patrol(this._onTilePatrol);
			}*/
		}
		
		public function showTalkBaloon(str:String, color:uint = 0xce0300):void
		{
			if (!_pause)
			{
				if (citizen.inBase)
				{
					this.visible = true;
					//this._imgButn.alpha = 0;
				}
				speechBallon.y = citizen.inBase? -50:0;

				speechBallonTF.text = str;
				//speechBallonTF.color = color;
				speechBallonTF.color = citizen.armyData.color;
				speechBallon.scaleX = speechBallon.scaleY = 0;
				speechBallon.visible = true;
				
				//var delay:DelayedCall = new DelayedCall(removeTalkBalloon,2);
				
				balloonTween = new Tween(speechBallon,.5,Transitions.EASE_OUT_ELASTIC);
				balloonTween.scaleTo(1);
				
				Starling.juggler.add(balloonTween);
				Starling.juggler.add(new DelayedCall(removeTalkBalloon, 2));
			}
		}
		
		private function removeTalkBalloon():void 
		{
			//var delay:DelayedCall = new DelayedCall(removeTalkBalloon,2);
			
			balloonTween = new Tween(speechBallon,.5,Transitions.EASE_OUT);
			balloonTween.fadeTo(0);
			balloonTween.animate("y", speechBallon.y - 10);
			balloonTween.onComplete = function():void
			{
				speechBallon.visible = false;
				speechBallon.alpha = 1;
				speechBallon.y += 10;
				
				if (citizen.inBase)
				{
					visible = false;
					//_imgButn.alpha = 1;
				}
			}
			
			Starling.juggler.add(balloonTween);
		}
		
		public function saySomething():void  
		{
			var num:int = NumberUtilities.random(0, 20);
			
			if (num < 4)
			{
				var armiesArr:Vector.<ArmyData> = new Vector.<ArmyData>;
				for each (var item:ArmyData in ConfigurationData.armiesData.armies) 
				{
					if (item != citizen.armyData)
					{
						armiesArr.push(item);
					}
				}
				
				var pickEnemyData:ArmyData = armiesArr[NumberUtilities.random(0, armiesArr.length - 1)];
				//var talkOptions:Array = [citizen.armyData.name + " ROLE!", "mmm..", "yummy?" , "death to " + pickEnemyData.name];
				showTalkBaloon(SentencesLibrary.getRandomPatrolSentence(citizen.armyData.name,pickEnemyData.name), 0x00ff00);
			}
		}
		
		private function onUpdataPatrol():void 
		{
			/*if (this.y > this.citizen.onTerritory.armyUnit.view.y)
			{
				//this.bringToFront();
				GameApp.game.world.actionLayer.bringObjectToFrontOf(this, this.citizen.onTerritory.armyUnit.view);
				
			} else
			{
				//this.citizen.onTerritory.armyUnit.view.bringToFront();
				GameApp.game.world.actionLayer.bringObjectToFrontOf(this.citizen.onTerritory.armyUnit.view, this);
			}*/
			if (this.citizen.onTerritory.armyUnit)
			{
				GameApp.game.world.actionLayer.updateDepths();
			}
			
		}
		
		private function onStartPatrol():void 
		{
			jumpTween = new Tween(_imgButn, .2,Transitions.EASE_OUT);
			jumpTween.animate("y", _imgButn.y - 5);
			//jumpTween.delay = NumberUtilities.random(.2, 1);
			jumpTween.repeatCount = 8//int.MAX_VALUE;
			jumpTween.reverse = true;
			
			Starling.juggler.add(jumpTween);
		}
		
		override public function dispose():void 
		{
			Starling.juggler.remove(patrolTween);
			Starling.juggler.removeTweens(this);
			Starling.juggler.removeTweens(_imgButn);
			shadow.removeFromParent(true);
			citizenImg.removeFromParent(true);
			super.dispose();
		}
		
		public function hideImg():void
		{
			_imgButn.visible = false;
		}
		
	}

}