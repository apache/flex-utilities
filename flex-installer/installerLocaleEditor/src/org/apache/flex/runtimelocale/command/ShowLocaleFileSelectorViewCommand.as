package org.apache.flex.runtimelocale.command {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import org.apache.flex.runtimelocale.view.LocaleFileSelectorView;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class ShowLocaleFileSelectorViewCommand extends AbstractBaseCommand {

		private static const logger:ILogger = getClassLogger(ShowLocaleFileSelectorViewCommand);

		public function ShowLocaleFileSelectorViewCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var selectorView:LocaleFileSelectorView = new LocaleFileSelectorView();
			PopUpManager.addPopUp(selectorView, (FlexGlobals.topLevelApplication as DisplayObject));
			PopUpManager.centerPopUp(selectorView);
			logger.info("Executed ShowLocaleFileSelectorViewCommand, now showing LocaleFileSelectorView popup");
		}
	}
}
