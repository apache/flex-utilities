package org.apache.flex.runtimelocale.command {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import org.apache.flex.runtimelocale.view.TextFileContentView;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class LocaleFileShowRequestCommand extends AbstractApplicationModelAwareBaseCommand {

		private static const logger:ILogger = getClassLogger(LocaleFileShowRequestCommand);

		public function LocaleFileShowRequestCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var view:TextFileContentView = new TextFileContentView();
			view.fileContent = LocaleFileSaveRequestCommand.FILE_HEADER + applicationModel.localeCompilationUnit.toString();
			view.filePath = applicationModel.currentLocalFilePath;
			PopUpManager.addPopUp(view, (FlexGlobals.topLevelApplication as DisplayObject));
			PopUpManager.centerPopUp(view);
			logger.info("Executed LocaleFileShowRequestCommand");
		}
	}
}
