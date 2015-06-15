package org.apache.flex.runtimelocale.command {
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import org.apache.flex.runtimelocale.event.ApplicationStatusEvent;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class SaveConfigurationRequestCommand extends AbstractApplicationModelAwareBaseCommand {

		private static const logger:ILogger = getClassLogger(SaveConfigurationRequestCommand);

		public function SaveConfigurationRequestCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var properties:Object = applicationModel.configurationProperties;
			var configContent:Array = [];
			for (var key:String in properties) {
				configContent[configContent.length] = key + "=" + properties[key];
			}

			var iniFile:File = File.applicationStorageDirectory.resolvePath('config.ini');
			var stream:FileStream = new FileStream();
			try {
				stream.open(iniFile, FileMode.WRITE);
				stream.writeUTFBytes(configContent.join("\n"));
			} catch (e:Error) {
				logger.error("Error saving config file {0}: {1}", [iniFile.nativePath, e.message]);
				dispatchEvent(new ApplicationStatusEvent(ApplicationStatusEvent.APPLICATION_ERROR_STATUS, e.message, "Error saving config file"));
			} finally {
				stream.close();
			}
			logger.info("Saved config file '{0}'", [iniFile.nativePath]);
		}
	}
}
