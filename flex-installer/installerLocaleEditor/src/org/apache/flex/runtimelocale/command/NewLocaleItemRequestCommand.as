package org.apache.flex.runtimelocale.command {
	import flash.display.Sprite;
	import flash.events.Event;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import org.apache.flex.runtimelocale.event.LocaleItemEvent;
	import org.apache.flex.runtimelocale.model.ApplicationModel;
	import org.apache.flex.runtimelocale.model.locale.LocaleDataVO;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class NewLocaleItemRequestCommand extends AbstractApplicationModelAwareBaseCommand {

		private static const logger:ILogger = getClassLogger(NewLocaleItemRequestCommand);

		public function NewLocaleItemRequestCommand(event:Event) {
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
								addKey(otherLocaleData, localeEvent.itemKey);
							}
						} else {
							addKey(localeData, localeEvent.itemKey);
							addMissingKeys(appModel, localeEvent.itemKey);
						}
						logger.info("Executed NewLocaleItemRequestCommand");
					};
					Alert.show("You are currently editing the reference locale, do you want to add the translation key '" + //
						localeEvent.itemKey + "' to all the other locales as well?", "Confirm", Alert.YES | Alert.NO, //
						(FlexGlobals.topLevelApplication as Sprite), closeHandler);
				} else {
					addKey(localeData, localeEvent.itemKey);
					logger.info("Executed NewLocaleItemRequestCommand");
				}
			}
		}

		private function addKey(localeData:LocaleDataVO, itemKey:String):void {
			if (localeData.getItemByKey(itemKey) == null) {
				localeData.addKey(itemKey);
			}
		}

		private function addMissingKeys(appModel:ApplicationModel, itemKey:String):void {
			for each (var localeData:LocaleDataVO in appModel.localeData) {
				if (localeData.getItemByKey(itemKey) == null) {
					localeData.missingKeys.addItem(itemKey);
				}
			}
		}
	}
}
