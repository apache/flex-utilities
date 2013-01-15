package org.apache.flex.runtimelocale.event {
	import flash.events.Event;
	import org.apache.flex.runtimelocale.model.locale.LocaleDataVO;

	public class LocaleItemEvent extends Event {
		public static const NEW_LOCALE_ITEM_REQUEST:String = "newLocaleItemRequest";
		public static const REMOVE_LOCALE_ITEM_REQUEST:String = "removeLocaleItemRequest";

		public function LocaleItemEvent(type:String, key:String, locale:LocaleDataVO=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_itemKey = key;
			_localeData = locale;
		}

		private var _itemKey:String;
		private var _localeData:LocaleDataVO;

		override public function clone():Event {
			return new LocaleItemEvent(type, _itemKey, _localeData, bubbles, cancelable);
		}

		public function get itemKey():String {
			return _itemKey;
		}

		public function get localeData():LocaleDataVO {
			return _localeData;
		}

		public function set localeData(value:LocaleDataVO):void {
			_localeData = value;
		}
	}
}
