package org.apache.flex.runtimelocale.command {
	import flash.events.Event;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.managers.CursorManager;
	import org.apache.flex.runtimelocale.event.LocaleDataEvent;
	import org.apache.flex.runtimelocale.model.locale.LocaleDataVO;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class RequestAddMissingKeysCommand extends AbstractBaseCommand {

		private static const logger:ILogger = getClassLogger(RequestAddMissingKeysCommand);

		public function RequestAddMissingKeysCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var localeEvent:LocaleDataEvent = event as LocaleDataEvent;
			if (localeEvent) {
				var localeData:LocaleDataVO = localeEvent.localeData;
				CursorManager.setBusyCursor();
				try {
					for each (var key:String in localeData.missingKeys) {
						localeData.addKey(key);
					}
					localeData.missingKeys.removeAll();
					logger.info("Added all misssing translation keys to locale '{0}'", [localeData.name]);
				} finally {
					CursorManager.removeBusyCursor();
				}
			}
		}
	}
}
