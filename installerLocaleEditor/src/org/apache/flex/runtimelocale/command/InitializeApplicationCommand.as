package org.apache.flex.runtimelocale.command {
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import org.apache.flex.runtimelocale.event.ApplicationStatusEvent;
	import org.apache.flex.runtimelocale.ini.IniReader;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;
	import org.springextensions.actionscript.ioc.config.property.impl.Properties;

	public class InitializeApplicationCommand extends AbstractApplicationModelAwareBaseCommand implements IApplicationContextAware {

		private static const logger:ILogger = getClassLogger(InitializeApplicationCommand);

		public function InitializeApplicationCommand(event:Event) {
			super(event);
		}

		private var _applicationContext:IApplicationContext;

		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}

		override public function execute():* {
			var iniFile:File = File.applicationStorageDirectory.resolvePath('config.ini');
			if (!iniFile.exists) {
				createIniWithDefaults(iniFile.nativePath);
			}
			readIni(iniFile.nativePath);
		}

		private function createIniWithDefaults(iniPath:String):void {
			logger.info("Creating '{0}' for first use", [iniPath]);
			var configContent:Array = [];
			configContent[configContent.length] = "localefilepath=";
			configContent[configContent.length] = "logging=true";
			configContent[configContent.length] = "showhelp=true";

			var iniFile:File = new File(iniPath);
			var stream:FileStream = new FileStream();
			try {
				stream.open(iniFile, FileMode.WRITE);
				stream.writeUTFBytes(configContent.join("\n"));
			} catch (e:Error) {
				dispatchEvent(new ApplicationStatusEvent(ApplicationStatusEvent.APPLICATION_ERROR_STATUS, e.message, "Error saving config file"));
			} finally {
				stream.close();
			}
		}

		private function readIni(iniPath:String):void {
			var iniReader:IniReader = new IniReader();
			var configProperties:Object = iniReader.readFromFile(iniPath);
			setDefaults(configProperties);
			applicationModel.configurationProperties = configProperties;
			for (var key:String in configProperties) {
				_applicationContext.propertiesProvider ||= new Properties();
				_applicationContext.propertiesProvider.setProperty(key, configProperties[key]);
			}
		}

		private function setDefaults(configProperties:Object):void {
			if (!configProperties['logging']) {
				configProperties['logging'] = 'true';
			}
			if (!configProperties['showhelp']) {
				configProperties['showhelp'] = 'true';
			}
		}
	}
}
