package org.apache.flex.runtimelocale.command {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import org.apache.flex.runtimelocale.view.HelpView;

	public class ShowHelpRequestCommand extends AbstractBaseCommand {

		public function ShowHelpRequestCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var popup:HelpView = new HelpView();
			PopUpManager.addPopUp(popup, (FlexGlobals.topLevelApplication as DisplayObject));
			PopUpManager.centerPopUp(popup);
		}
	}
}
