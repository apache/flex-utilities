package org.apache.flex.runtimelocale.event {
	import flash.events.Event;

	import org.apache.flex.runtimelocale.model.locale.LocaleDataVO;

	public class LocaleDataEvent extends Event {
		public static const REQUEST_ADD_MISSING_KEYS:String = "requestAddMissingKeys";
		private var _localeData:LocaleDataVO;

		public function LocaleDataEvent(type:String, data:LocaleDataVO, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_localeData = data;
		}

		public function get localeData():LocaleDataVO {
			return _localeData;
		}

		public function set localeData(value:LocaleDataVO):void {
			_localeData = value;
		}

		override public function clone():Event {
			return new LocaleDataEvent(type, _localeData, bubbles, cancelable);
		}
	}
}
