package org.apache.flex.runtimelocale.event {

	import flash.events.Event;

	public class LocaleFileLoadedEvent extends Event {

		public static const LOCALE_FILE_LOADED:String = "localeFileLoaded";
		private var _fileContent:String;
		private var _filePath:String;

		public function LocaleFileLoadedEvent(fileContent:String, filePath:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(LOCALE_FILE_LOADED, bubbles, cancelable);
			_fileContent = fileContent;
			_filePath = filePath;
		}

		public function get filePath():String {
			return _filePath;
		}

		public function get fileContent():String {
			return _fileContent;
		}

		override public function clone():Event {
			return new LocaleFileLoadedEvent(_fileContent, _filePath, bubbles, cancelable);
		}
	}
}
