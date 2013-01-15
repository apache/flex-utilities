package org.apache.flex.runtimelocale.command {
	import flash.events.Event;
	import flash.utils.setTimeout;
	import mx.core.FlexGlobals;
	import org.apache.flex.runtimelocale.event.ApplicationStatusEvent;
	import spark.components.WindowedApplication;
	import spark.components.supportClasses.TextBase;

	public class ApplicationInfoStatusCommand extends AbstractBaseCommand {

		public function ApplicationInfoStatusCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var infoEvent:ApplicationStatusEvent = event as ApplicationStatusEvent;
			if (infoEvent) {
				var app:WindowedApplication = (FlexGlobals.topLevelApplication as WindowedApplication);
				app.status = infoEvent.statusMessage;
				flashStatusText(app.statusText);
			}
		}

		private function flashStatusText(statusText:TextBase):void {
			statusText.setStyle("backgroundColor", 0x000000);
			statusText.setStyle("color", 0xFFFFFF);
			setTimeout(function():void {
				statusText.setStyle("backgroundColor", 0xDDDDDD);
				statusText.setStyle("color", 0x008800);
			}, 1000);
		}
	}
}
