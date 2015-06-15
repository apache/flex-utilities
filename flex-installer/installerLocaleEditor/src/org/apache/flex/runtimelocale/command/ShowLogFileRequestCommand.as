package org.apache.flex.runtimelocale.command {
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import mx.utils.ObjectUtil;
	import org.apache.flex.runtimelocale.view.TextFileContentView;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class ShowLogFileRequestCommand extends AbstractBaseCommand {

		private static const logger:ILogger = getClassLogger(ShowLogFileRequestCommand);

		public function ShowLogFileRequestCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var logFilePath:File = getNewestLogFilePath();
			if (logFilePath) {
				var fileContent:String = loadLogFile(logFilePath);
				if (fileContent) {
					showLogFile(fileContent, logFilePath.nativePath);
				}
			}
			logger.info("Executed ShowLogFileRequestCommand");
		}

		private function compareCreationDates(f1:File, f2:File):Number {
			return ObjectUtil.dateCompare(f1.creationDate, f2.creationDate);
		}

		private function getNewestLogFilePath():File {
			var listing:Array = File.applicationStorageDirectory.getDirectoryListing();
			var logListing:Array = [];
			for each (var file:File in listing) {
				if (file.extension == "log") {
					logListing[logListing.length] = file;
				}
			}
			if (logListing.length > 1) {
				logListing.sort(compareCreationDates, Array.NUMERIC);
				logListing = logListing.reverse();
			}
			if (logListing.length > 0) {
				return logListing[0];
			}
			return null;
		}

		private function loadLogFile(logFile:File):String {
			if (logFile.exists) {
				try {
					var fileStream:FileStream = new FileStream();
					fileStream.open(logFile, FileMode.READ);
					fileStream.position = 0;
					return fileStream.readMultiByte(fileStream.bytesAvailable, "utf-8");
				} catch (e:Error) {
					logger.error("Error encountered while reading log file '{0}': {0}", [logFile, e.message]);
				} finally {
					fileStream.close();
					logger.info("Successfully loaded logfile: {0}", [logFile.nativePath]);
				}
			}
			return null;
		}

		private function showLogFile(fileContent:String, filePath:String):void {
			var view:TextFileContentView = new TextFileContentView();
			view.fileContent = fileContent;
			view.filePath = filePath;
			PopUpManager.addPopUp(view, (FlexGlobals.topLevelApplication as DisplayObject));
			PopUpManager.centerPopUp(view);
			logger.info("Showing contents of '{0}' in TextFileContentView", [filePath]);
		}
	}
}
