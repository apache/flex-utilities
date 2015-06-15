package org.apache.flex.runtimelocale.model {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import mx.managers.CursorManager;
	import org.apache.flex.runtimelocale.IStatusReporter;
	import org.apache.flex.runtimelocale.event.ApplicationStatusEvent;
	import org.apache.flex.runtimelocale.event.LocaleFileLoadedEvent;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class LocaleFileSelectorPM extends EventDispatcher implements IStatusReporter {

		private static const logger:ILogger = getClassLogger(LocaleFileSelectorPM);

		public function LocaleFileSelectorPM() {
			super();
		}

		private var _applicationModel:ApplicationModel;
		private var _localeASFile:File;
		private var _selectedFile:String;

		public function get applicationModel():ApplicationModel {
			return _applicationModel;
		}

		public function set applicationModel(value:ApplicationModel):void {
			_applicationModel = value;
			if (_applicationModel) {
				selectedFile = _applicationModel.configurationProperties['localefilepath'];
			}
		}

		public function browseFile():void {
			_localeASFile = new File();
			_localeASFile.addEventListener(Event.CANCEL, cancelBrowse);
			_localeASFile.addEventListener(Event.SELECT, fileSelected);
			_localeASFile.browse([new FileFilter('RuntimeLocale.as', 'RuntimeLocale.as')]);
		}

		public function loadFile(filePath:String):void {
			if (_localeASFile == null) {
				_localeASFile = new File(filePath);
			} else {
				_localeASFile.nativePath = filePath;
			}
			var fileContent:String;
			var errorMessage:String;
			if (_localeASFile.exists) {
				_applicationModel.configurationProperties['localefilepath'] = filePath;
				logger.info("Added .as file path '{0}' to application properties", [filePath]);
				var fileStream:FileStream = new FileStream();
				CursorManager.setBusyCursor();
				try {
					fileStream.open(_localeASFile, FileMode.READ);
					fileContent = fileStream.readUTFBytes(fileStream.bytesAvailable);
				} catch (e:Error) {
					logger.error("Error loading .as file '{0}': {1}", [filePath, e.message]);
					dispatchEvent(new ApplicationStatusEvent(ApplicationStatusEvent.APPLICATION_ERROR_STATUS, e.message, "Error loading file"));
				} finally {
					CursorManager.removeBusyCursor();
					fileStream.close();
				}
				logger.info("Successfully loaded .as file '{0}'", [filePath]);
			} else {
				errorMessage = "File " + filePath + " does not exist";
				logger.error(errorMessage);
				dispatchEvent(new ApplicationStatusEvent(ApplicationStatusEvent.APPLICATION_ERROR_STATUS, errorMessage, "File does not exist"));
			}
			_localeASFile = null;
			if (fileContent) {
				dispatchEvent(new LocaleFileLoadedEvent(fileContent, filePath));
			}
		}

		public function get selectedFile():String {
			return _selectedFile;
		}

		[Bindable(event="selectedFileChanged")]
		public function set selectedFile(value:String):void {
			if (value != _selectedFile) {
				_selectedFile = value;
				dispatchEvent(new Event("selectedFileChanged"));
			}
		}

		protected function cancelBrowse(event:Event):void {
			_localeASFile.removeEventListener(Event.CANCEL, cancelBrowse);
			_localeASFile.removeEventListener(Event.SELECT, fileSelected);
			_localeASFile = null;
		}

		protected function fileSelected(event:Event):void {
			_localeASFile.removeEventListener(Event.CANCEL, cancelBrowse);
			_localeASFile.removeEventListener(Event.SELECT, fileSelected);
			selectedFile = _localeASFile.nativePath;
		}

		protected function loadComplete(event:Event):void {
			_localeASFile.removeEventListener(Event.COMPLETE, loadComplete);
			_localeASFile.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
		}

		protected function loadError(event:IOErrorEvent):void {
			_localeASFile.removeEventListener(Event.COMPLETE, loadComplete);
			_localeASFile.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			_localeASFile = null;
		}
	}
}
