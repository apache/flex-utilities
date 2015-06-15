package org.apache.flex.runtimelocale.command {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import org.apache.flex.runtimelocale.event.LocaleEvent;
	import org.apache.flex.runtimelocale.view.NewLocaleView;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class NewLocaleRequestCommand extends AbstractBaseCommand {

		private static const logger:ILogger = getClassLogger(NewLocaleRequestCommand);

		public function NewLocaleRequestCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var localeEvent:LocaleEvent = event as LocaleEvent;
			if (localeEvent) {
				var popup:NewLocaleView = new NewLocaleView();
				PopUpManager.addPopUp(popup, (FlexGlobals.topLevelApplication as DisplayObject), true);
				PopUpManager.centerPopUp(popup);
				logger.info("Executed NewLocaleRequestCommand, now showing NewLocaleView popup");
			}
		}
	}
}
