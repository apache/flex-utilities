package org.apache.flex.runtimelocale.event {
	import flash.events.Event;
	import org.apache.flex.runtimelocale.model.locale.LocaleDataVO;

	public class LocaleEvent extends Event {

		public static const CREATE_LOCALE_REQUEST:String = "createLocaleRequest";
		public static const LOCALE_CREATED:String = "localeCreated";
		public static const LOCALE_REMOVED:String = "localeRemoved";
		public static const NEW_LOCALE_REQUEST:String = "newLocaleRequest";
		public static const REMOVE_LOCALE_REQUEST:String = "removeLocaleRequest";

		public function LocaleEvent(type:String, locale:String=null, data:LocaleDataVO=null, bubbles:Boolean=false, cancelable:Boolean=true) {
			super(type, bubbles, cancelable);
			_localeName = locale;
			_localeData = data;
		}

		private var _localeData:LocaleDataVO;
		private var _localeName:String;

		override public function clone():Event {
			return new LocaleEvent(type, _localeName, _localeData, bubbles, cancelable);
		}

		public function get localeData():LocaleDataVO {
			return _localeData;
		}

		public function set localeData(value:LocaleDataVO):void {
			_localeData = value;
		}

		public function get localeName():String {
			return _localeName;
		}

		public function set localeName(value:String):void {
			_localeName = value;
		}
	}
}
