package players 
{
	import armies.Soldier;
	import ui.windows.store.data.StoreData;
	import ui.windows.store.data.StoreData_Item;
	import ui.windows.store.StoreItem;
	import utils.events.GlobalEvent;
	import utils.events.GlobalEventManger;
	import utils.events.GlobalEventsEnum;
	/**
	 * ...
	 * @author Avrik
	 */
	public class PlayerEconamyMinister 
	{
		private var _player:Player_Human;
		
		public function PlayerEconamyMinister(player:Player_Human) 
		{
			this._player = player;
			GlobalEventManger.addEvent(GlobalEventsEnum.BUY_ITEM, boughtNewItem);
		}
		
		private function boughtNewItem(e:GlobalEvent):void 
		{
			this.handleNewItem(e.dispatchTarget as StoreData_Item);
		}
		
		private function handleNewItem(itemData:StoreData_Item):void 
		{
			_player.coinsAmount -= itemData.price;
			var s:Soldier = _player.army.getNewSoldier();
			switch (itemData.id) 
			{
				case 0:
					_player.newItemAdder.addNewUnit(s)
				break;
				
				case 1:
					s.defenceExp = 2;
					s.attackExp = 2;
					_player.newItemAdder.addNewUnit(s)
				break;
				
				case 2:
					s.attackMaxResult++;
					_player.newItemAdder.addNewUnit(s)
				break;
				
				case 3:
					s.defenceMaxResult++;
					_player.newItemAdder.addNewUnit(s)
				break;
				default:
			}
		}
		
	}

}