package org.apache.flex.runtimelocale.command {
	import flash.display.Sprite;
	import flash.events.Event;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import org.apache.flex.runtimelocale.event.LocaleItemEvent;
	import org.apache.flex.runtimelocale.model.ApplicationModel;
	import org.apache.flex.runtimelocale.model.locale.LocaleDataVO;
	import org.apache.flex.runtimelocale.model.locale.LocaleItemDataVO;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class RemoveLocaleItemRequestCommand extends AbstractApplicationModelAwareBaseCommand {

		private static const logger:ILogger = getClassLogger(RemoveLocaleItemRequestCommand);

		public function RemoveLocaleItemRequestCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var localeEvent:LocaleItemEvent = event as LocaleItemEvent;
			if (localeEvent) {
				var localeData:LocaleDataVO = localeEvent.localeData;
				if (localeData === applicationModel.referenceLocale) {
					var appModel:ApplicationModel = applicationModel;
					var closeHandler:Function = function(closeEvent:CloseEvent):void {
						if (closeEvent.detail == Alert.YES) {
							for each (var otherLocaleData:LocaleDataVO in appModel.localeData) {
								deleteKey(otherLocaleData, localeEvent.itemKey);
								logger.info("Deleted translation key '{0}' from locale '{1}'", [localeEvent.itemKey, otherLocaleData.name]);
							}
						} else {
							deleteKey(localeData, localeEvent.itemKey);
							logger.info("Deleted translation key '{0}' from locale '{1}'", [localeEvent.itemKey, localeData.name]);
						}
					};
					Alert.show("You are currently editing the reference locale, do you want to delete the translation key '" + localeEvent.itemKey + "' from all the other locales as well?", "Confirm", Alert.YES | Alert.NO, (FlexGlobals.topLevelApplication as Sprite), closeHandler);
				} else {
					deleteKey(localeData, localeEvent.itemKey);
					logger.info("Deleted translation key '{0}' from locale '{1}'", [localeEvent.itemKey, localeData.name]);
				}
			}
		}

		private function deleteKey(localeData:LocaleDataVO, itemKey:String):void {
			var localeItem:LocaleItemDataVO = localeData.getItemByKey(itemKey);
			if (localeItem) {
				localeData.removeItem(localeItem);
			} else {
				var idx:int = localeData.missingKeys.getItemIndex(itemKey);
				if (idx > -1) {
					localeData.missingKeys.removeItemAt(idx);
				}
			}
		}
	}
}
