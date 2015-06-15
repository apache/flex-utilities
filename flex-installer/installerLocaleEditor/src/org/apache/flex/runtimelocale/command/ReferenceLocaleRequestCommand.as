package org.apache.flex.runtimelocale.command {
	import flash.events.Event;
	import mx.collections.ArrayCollection;
	import org.apache.flex.runtimelocale.event.ReferenceLocaleRequestEvent;
	import org.apache.flex.runtimelocale.model.locale.LocaleDataVO;
	import org.apache.flex.runtimelocale.model.locale.LocaleItemDataVO;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class ReferenceLocaleRequestCommand extends AbstractApplicationModelAwareBaseCommand {

		private static const logger:ILogger = getClassLogger(ReferenceLocaleRequestCommand);

		public function ReferenceLocaleRequestCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var refEvent:ReferenceLocaleRequestEvent = event as ReferenceLocaleRequestEvent;
			if (refEvent) {
				var referenceLocale:LocaleDataVO = findLocale(refEvent.localeName);
				if (referenceLocale) {
					applicationModel.referenceLocale = referenceLocale;
					addMissingKeysToLocales(applicationModel.referenceLocale, applicationModel.localeData);
					logger.info("Set '{0}' as the enw reference locale", [refEvent.localeName]);
				}
				logger.info("Executed ReferenceLocaleRequestCommand");
			}
		}

		private function addMissingKeysToLocale(referenceLocale:LocaleDataVO, localeData:LocaleDataVO):void {
			var missingKeys:Array = [];
			for each (var item:LocaleItemDataVO in referenceLocale.content) {
				if (localeData.getItemByKey(item.key) == null) {
					missingKeys[missingKeys.length] = item.key;
				}
			}
			localeData.missingKeys = new ArrayCollection(missingKeys);
		}

		private function addMissingKeysToLocales(referenceLocale:LocaleDataVO, localeDatas:Vector.<LocaleDataVO>):void {
			for each (var localeData:LocaleDataVO in localeDatas) {
				if (referenceLocale !== localeData) {
					addMissingKeysToLocale(referenceLocale, localeData);
				}
			}
		}

		private function findLocale(locale:String):LocaleDataVO {
			for each (var data:LocaleDataVO in applicationModel.localeData) {
				if (data.name == locale) {
					return data;
				}
			}
			return null;
		}
	}
}
