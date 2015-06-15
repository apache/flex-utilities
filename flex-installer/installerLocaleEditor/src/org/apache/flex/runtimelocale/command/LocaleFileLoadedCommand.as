package org.apache.flex.runtimelocale.command {
	import flash.events.Event;
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	import org.apache.flex.runtimelocale.event.ApplicationStatusEvent;
	import org.apache.flex.runtimelocale.event.LocaleFileEvent;
	import org.apache.flex.runtimelocale.event.LocaleFileLoadedEvent;
	import org.apache.flex.runtimelocale.event.ShowLocaleFileSelectorViewEvent;
	import org.as3commons.asblocks.dom.IASCompilationUnit;
	import org.as3commons.asblocks.impl.ASTASParser;
	import org.as3commons.async.operation.impl.AbstractOperation;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class LocaleFileLoadedCommand extends AbstractApplicationModelAwareBaseCommand {

		private static const logger:ILogger = getClassLogger(LocaleFileLoadedCommand);

		public function LocaleFileLoadedCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var loadedEvent:LocaleFileLoadedEvent = event as LocaleFileLoadedEvent;
			if (loadedEvent) {
				logger.info("Executing LocaleFileLoadedCommand for file path '{0}'", [loadedEvent.filePath]);
				applicationModel.currentLocalFilePath = loadedEvent.filePath;
				var operation:AbstractOperation = new AbstractOperation();
				operation.result = this;
				parseContent(loadedEvent.fileContent, operation);
				return operation;
			}
		}

		private function parseContent(fileContent:String, operation:AbstractOperation):void {
			dispatchEvent(new ApplicationStatusEvent(ApplicationStatusEvent.APPLICATION_INFO_STATUS, "Parsing locale file, hold on, this may take a while..."));
			CursorManager.setBusyCursor();
			var count:int = 0;
			//Somehow I have to wait 2 frames for the statusbar and cursor to actually update,
			//if I don't hack it like this the parser will already block the UI thread...
			var handleNextFrame:Function = function():void {
				if (++count == 2) {
					logger.info("Starting processing locale file");
					FlexGlobals.topLevelApplication.stage.removeEventListener(Event.ENTER_FRAME, handleNextFrame);
					var parser:ASTASParser = new ASTASParser();
					try {
						var unit:IASCompilationUnit = parser.parse(fileContent);
						applicationModel.localeCompilationUnit = unit;
						dispatchEvent(new ApplicationStatusEvent(ApplicationStatusEvent.APPLICATION_INFO_STATUS, "Locale file parsed succesfully!"));
						dispatchEvent(new LocaleFileEvent(LocaleFileEvent.FILE_READY));
						operation.dispatchCompleteEvent();
					} catch (e:Error) {
						logger.info("Error parsing file: {0}", [e.message]);
						dispatchEvent(new ShowLocaleFileSelectorViewEvent(ShowLocaleFileSelectorViewEvent.SHOW_LOCALE_FILE_SELECTOR));
						dispatchEvent(new ApplicationStatusEvent(ApplicationStatusEvent.APPLICATION_ERROR_STATUS, e.message, "Error parsing file"));
						operation.dispatchErrorEvent();
					} finally {
						CursorManager.removeBusyCursor();
					}
				}
			};
			FlexGlobals.topLevelApplication.stage.addEventListener(Event.ENTER_FRAME, handleNextFrame)
		}
	}
}
