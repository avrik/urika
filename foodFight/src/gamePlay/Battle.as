package gamePlay 
{
	import armies.ArmyUnit;
	import armies.Soldier;
	import armies.UnitStatusEnum;
	import assets.AssetsEnum;
	import flash.geom.Point;
	import gameWorld.territories.SentencesLibrary;
	import gameWorld.territories.Territory;
	import players.Player;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Avrik
	 */
	
	public class Battle extends EventDispatcher 
	{
		static public const BATTLE_END:String = "battleEnd";
		static public const BATTLE_END_AND_WON:String = "battleEndAndWon";
		static public const BATTLE_COMPLETE:String = "battleComplete";
		
		static private var _attackUnit:ArmyUnit;
		static private var _attackPlayer:Player;
		
		static private var _defenceUnit:ArmyUnit;
		static private var _defencePlayer:Player;
		static private var _fightTillDefeat:Boolean = true;
		
		private var _attackSoldiersArr:Vector.<Soldier>;
		private var _defenceSoldiersArr:Vector.<Soldier>;
		
		public function Battle(attacer:ArmyUnit, defender:ArmyUnit) 
		{
			_attackUnit = attacer;
			_defenceUnit = defender;
			
			_attackPlayer = _attackUnit.myArmy.myPlayer;
			_defencePlayer = _defenceUnit.myArmy.myPlayer;
		}
		
		public function start():void 
		{
			var territoriesToFocus:Vector.<Territory> = new Vector.<Territory>;
			territoriesToFocus.push(_attackUnit.onTerritory, _defenceUnit.onTerritory)
			GameApp.game.world.map.setTerritoriesFocus(territoriesToFocus);
			
			setAttack();
		}
		
		private function setAttack():void 
		{
			if (_attackUnit.totalSoldiers <= 1) {
				Tracer.alert("NOT ENOUGH SOLDIERS FOR ATTACK");
				battleComplete();
				//return;
			}
			
			_defenceSoldiersArr = new Vector.<Soldier>;
			var maxSoldiersForDefence:int = _defenceUnit.totalSoldiers >= 2?2:_defenceUnit.totalSoldiers;
			for (var j:int = 0; j < maxSoldiersForDefence; ++j) 
			{
				_defenceSoldiersArr.push(setSoldier(j, _defenceUnit, j == (maxSoldiersForDefence-1)?startAttack:null));
			}
			
			_attackSoldiersArr = new Vector.<Soldier>;
			var maxSoldiersForAttack:int = _attackUnit.totalSoldiers > 3?3:(_attackUnit.totalSoldiers - 1);
			for (var i:int = 0; i < maxSoldiersForAttack; ++i) 
			{
				_attackSoldiersArr.push(setSoldier(i, _attackUnit));
			}
		}
		
		private function setSoldier(num:int, fromArmyUnit:ArmyUnit, onMoveComplete:Function = null):Soldier
		{
			var soldier:Soldier = fromArmyUnit.getSoldier();
			var soldierVisual:Sprite = soldier.getVisual();

			//GameApp.game.world.actionLayer.bringObjectToFrontOf(soldierVisual)
			
			var xx:Number = num * 25 - 20;
			var yy:Number = num == 1? -(soldierVisual.height+20): -(soldierVisual.height +15);

			if (_attackUnit == fromArmyUnit)
			{
				soldier.generateAttackScore();
			} else
			{
				soldier.generateDefenceScore();
			}
			
			var tween:Tween = new Tween(soldierVisual, .5, Transitions.EASE_OUT);
			tween.moveTo(soldierVisual.x + xx, soldierVisual.y + yy);
			tween.onComplete = onMoveComplete;
			Starling.juggler.add(tween);
			
			return soldier;
		}

		private function startAttack():void 
		{
			_attackUnit.status = UnitStatusEnum.ATTACK;
			_defenceUnit.status = UnitStatusEnum.ATTACKED;
			
			_attackSoldiersArr.sort(sortByAttackPoints);
			_defenceSoldiersArr.sort(sortByDefencePoints);
			match(_attackSoldiersArr.pop(), _defenceSoldiersArr.pop());
		}
		
		private function sortByAttackPoints(a:Soldier, b:Soldier):int
		{
			if (a.attackScore < b.attackScore)
			{
				return -1;
			}
			else if (a.attackScore > b.attackScore)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		private function sortByDefencePoints(a:Soldier, b:Soldier):int
		{
			if (a.defenceScore < b.defenceScore)
			{
				return -1;
			}
			else if (a.defenceScore > b.defenceScore)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		private function match(attackSoldier:Soldier, defenceSoldier:Soldier):void 
		{
			var minX:Number = Math.min(attackSoldier.soldierVisual.x, defenceSoldier.soldierVisual.x);
			var maxX:Number = Math.max(attackSoldier.soldierVisual.x, defenceSoldier.soldierVisual.x);
			var minY:Number = Math.min(attackSoldier.soldierVisual.y, defenceSoldier.soldierVisual.y);
			var maxY:Number = Math.max(attackSoldier.soldierVisual.y, defenceSoldier.soldierVisual.y);
			var xx:Number =  (minX + (maxX - minX)/ 2) ;
			var yy:Number =  (minY + (maxY - minY)/ 2) ;
			//var matchPoint:Point = new Point(xx, yy);
			var matchPoint:Point = new Point(defenceSoldier.soldierVisual.x, defenceSoldier.soldierVisual.y);
			
			var tween:Tween = new Tween(attackSoldier.soldierVisual, .4, Transitions.LINEAR);
			tween.moveTo(matchPoint.x, matchPoint.y);
			
			tween.onComplete = matchWaveComplete;
			tween.onCompleteArgs = [attackSoldier,defenceSoldier];
			
			var tween2:Tween = new Tween(attackSoldier.soldierVisual, .2, Transitions.EASE_OUT);
			
			tween2.scaleTo(attackSoldier.soldierVisual.scaleX *3);
			tween2.reverse = true;
			tween2.repeatCount = 2;
			
			Starling.juggler.add(tween);
			Starling.juggler.add(tween2);
			
			/*var tween2:Tween = new Tween(defenceSoldier.soldierVisual, .5, Transitions.EASE_OUT);
			tween2.moveTo(xx, yy);
			Starling.juggler.add(tween2);*/
		}
		
		private function matchWaveComplete(attackSoldier:Soldier, defenceSoldier:Soldier):void 
		{
			var attackPoints:Number = attackSoldier.attackScore;
			var defencePoints:Number = defenceSoldier.defenceScore;
			var winner:Soldier;// = ?attackSoldier:defenceSoldier;
			var loser:Soldier;// = attackPoints > defencePoints?defenceSoldier:attackSoldier;
		
			if (attackPoints > defencePoints)
			{
				winner = attackSoldier;
				loser = defenceSoldier;
			} else if (attackPoints <= defencePoints)
			{
				winner = defenceSoldier;
				loser = attackSoldier;
			}

			//loser.kill();
			
			if (winner == attackSoldier)
			{
				attackSoldier.attackExp++;
				winner.returnToBase();
				//_attackSoldiersArr.push(attackSoldier)
				loser.kill();
			} else if (loser == attackSoldier)
			{
				defenceSoldier.defenceExp++;
				//_defenceSoldiersArr.push(defenceSoldier);
				_defenceSoldiersArr.unshift(defenceSoldier);
				loser.kill();

			} /*else
			{
				//attackSoldier.returnToBase();
				//defenceSoldier.returnToBase();
				
				attackSoldier.returnToBase();
				defenceSoldier.returnToBase();
				//_defenceSoldiersArr.push(defenceSoldier);
				//_attackSoldiersArr.push(attackSoldier)
			}*/
			
			
			if (_attackSoldiersArr.length && _defenceSoldiersArr.length)
			{
				match(_attackSoldiersArr.pop(), _defenceSoldiersArr.pop());

			} else
			{
				Starling.juggler.delayCall(endMatch, .2);
			}
		}
		
		private function endMatch():void 
		{
			for each (var attackItem:Soldier in _attackSoldiersArr) 
			{
				attackItem.returnToBase();
			}
			
			for each (var defenceItem:Soldier in _defenceSoldiersArr) 
			{
				defenceItem.returnToBase();
			}
			
			if ((_defenceUnit.totalSoldiers + _defenceSoldiersArr.length) == 0)
			{
				_attackUnit.myArmy.myPlayer.addStar();
				
				if (_attackUnit.myArmy.myPlayer.isHuman)
				{
					showStarAnimation();
				}
				
				_defenceUnit.addEventListener(ArmyUnit.DESTROYED, armyUnitDestroyedAfterDefeat);
				_defenceUnit.onTerritory.citizen.talk(SentencesLibrary.getRandomLoseSentence());
				_defenceUnit.onTerritory.citizen.view.hideImg();
				_defenceUnit.destroy();
		
			} else
			{
				//battleComplete();
				Starling.juggler.delayCall(battleComplete,.5)
			}
			
			//_attackUnit.myArmy.myPlayer.addToScore(50);
		}
		
		private function showStarAnimation():void 
		{
			var starImg:Image = new Image(TopLevel.assets.getTexture(AssetsEnum.STAR));
			starImg.pivotX = starImg.width / 2;
			starImg.pivotY = starImg.height / 2;

			GameApp.game.world.actionLayer.addObject(starImg, _defenceUnit.getLocationPoint().x, _defenceUnit.getLocationPoint().y - 30, 1, false);
			
			starImg.scaleX = starImg.scaleY = 0;
			var tween:Tween = new Tween(starImg, .8, Transitions.LINEAR);
			tween.moveTo(_attackUnit.getLocationPoint().x, _attackUnit.getLocationPoint().y);
			//tween.animate("rotation", 180);
			tween.delay = .3;
			//tween.fadeTo(0);
			tween.onComplete = function():void
			{
				starImg.removeFromParent(true);
				GameApp.game.uiLayer.starsCollector.starsAmount++;
				
			};
			//tween.onCompleteArgs = [attackSoldier,defenceSoldier];
			
			var tween2:Tween = new Tween(starImg, .4, Transitions.EASE_OUT);
			
			tween2.delay = tween.delay;
			
			tween2.scaleTo(2);
			tween2.reverse = true;
			tween2.repeatCount = 2;
			
			Starling.juggler.add(tween);
			Starling.juggler.add(tween2);
		}
		
		private function armyUnitDestroyedAfterDefeat(e:Event):void 
		{
			Tracer.alert("DESTROY COMPLETE!!!!!!!!!!!!!!!!");
			var armyUnit:ArmyUnit = e.currentTarget as ArmyUnit;
			armyUnit.removeEventListener(ArmyUnit.DESTROYED, armyUnitDestroyedAfterDefeat);
			//armyUnit.myArmy.removeArmyUnit(armyUnit);
			handleWinnersNewTerritory();
		}
		
		private function handleWinnersNewTerritory():void
		{
			Tracer.alert("HANDLE WINNERS NEW TERRITORY");
			
			_attackUnit.onTerritory.citizen.talk(SentencesLibrary.getRandomWinSentence(_attackUnit.myArmy.armyData.name));

			var moveToNewLandArr:Vector.<Soldier> = new Vector.<Soldier>;
			var total:int = Math.ceil(_attackUnit.totalSoldiers / 2);
			
			for (var j:int = 0; j < total; ++j)
			{
				moveToNewLandArr.push(_attackUnit.getSoldier());
			}
			
			moveForce(moveToNewLandArr)
		}
		
		private function moveForce(moveToNewLandArr:Vector.<Soldier>, newArmyUnit:ArmyUnit = null):void
		{
			var coinsInUnit:int = _defenceUnit.coinsInStorage;
			if (moveToNewLandArr.length)
			{
				var targetPoint:Point = new Point(_defenceUnit.getLocationPoint().x, _defenceUnit.getLocationPoint().y);
				var duration:Number = .3;
				var tween:Tween;
				
				var soldier:Soldier = moveToNewLandArr.pop();
				soldier.getVisual(1);
		
				tween = new Tween(soldier.soldierVisual, duration, Transitions.LINEAR);
				tween.moveTo(targetPoint.x, targetPoint.y);

				tween.onComplete = moveForceComplete
				tween.onCompleteArgs = [moveToNewLandArr, soldier, newArmyUnit,coinsInUnit];
				
				Starling.juggler.add(tween);
			} else
			{
				_attackUnit.myArmy.myPlayer.addToScore(newArmyUnit.onTerritory.worth);
				battleComplete(true, coinsInUnit);
			}
		}
		
		private function moveForceComplete(moveToNewLandArr:Vector.<Soldier>, soldier:Soldier, armyUnit:ArmyUnit,coinsInUnit:int):void
		{
			//Tracer.alert("MOVE FORCE TO NEW TERRITORY COMPLETE!!!");
			
			if (!armyUnit)
			{
				var t:Territory = _defenceUnit.myArmy.myPlayer.removeTerritory(_defenceUnit.onTerritory);
				
				armyUnit = _attackUnit.myArmy.addNewArmyUnit(null, coinsInUnit);
				_attackUnit.myArmy.myPlayer.coinsAmount += coinsInUnit;
				t.armyUnit = armyUnit;
				armyUnit.myArmy.myPlayer.assignTerritory(t, true);
			}
			
			soldier.removeVisualDisplay();
			armyUnit.addSoldier(soldier);
			
			moveForce(moveToNewLandArr, armyUnit);
		}
		
		private function battleComplete(defeatAchived:Boolean = false, coinsInUnit:int=0):void
		{
			_attackUnit.status = UnitStatusEnum.WAITING_FOR_ACTION;
			_defenceUnit.status = UnitStatusEnum.WAITING_FOR_ACTION;
			
			if (defeatAchived)
			{
				_attackPlayer.refreshLinksToCapital();
				_defencePlayer.refreshLinksToCapital();
				
				GameApp.game.world.map.clearTerritoriesFocus();		
				GameApp.game.uiLayer.eventMessagesManager.addEventMessage(_attackPlayer.army.armyData.name + " army conquer new territory and plunder " + coinsInUnit + " coins");
				
				dispatchEvent(new Event(BATTLE_END_AND_WON));
			} else
			{
				dispatchEvent(new Event(BATTLE_END));
			}
			
			dispatchEvent(new Event(BATTLE_COMPLETE));
		}
		
		
	}

}