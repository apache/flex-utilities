package org.apache.flex.runtimelocale.command {
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import org.apache.flex.runtimelocale.IStatusReporter;
	import org.apache.flex.runtimelocale.event.ApplicationStatusEvent;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class LocaleFileSaveRequestCommand extends AbstractApplicationModelAwareBaseCommand implements IStatusReporter {

		//ASBlocks doesn't save the comments all the way at the top of a file,
		//I expect this to be a temporary bug so for now I just re-add the header
		//before saving the file.
		public static const FILE_HEADER:String = '////////////////////////////////////////////////////////////////////////////////' + "\n" + //
			'//' + "\n" + //
			'// Licensed to the Apache Software Foundation (ASF) under one or more' + "\n" + //
			'// contributor license agreements. See the NOTICE file distributed with' + "\n" + //
			'// this work for additional information regarding copyright ownership.' + "\n" + //
			'// The ASF licenses this file to You under the Apache License, Version 2.0' + "\n" + //
			'// (the "License"); you may not use this file except in compliance with' + "\n" + //
			'// the License. You may obtain a copy of the License at' + "\n" + //
			'//' + "\n" + //
			'// http://www.apache.org/licenses/LICENSE-2.0' + "\n" + //
			'//' + "\n" + //
			'// Unless required by applicable law or agreed to in writing, software' + "\n" + //
			'// distributed under the License is distributed on an "AS IS" BASIS,' + "\n" + //
			'// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.' + "\n" + //
			'// See the License for the specific language governing permissions and' + "\n" + //
			'// limitations under the License.' + "\n" + //
			'//' + "\n" + //
			'////////////////////////////////////////////////////////////////////////////////' + "\n" + //
			'' + "\n" + //
			'' + "\n" + //
			'';

		private static const logger:ILogger = getClassLogger(LocaleFileSaveRequestCommand);

		public function LocaleFileSaveRequestCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var localeFile:File = new File(applicationModel.currentLocalFilePath);
			var stream:FileStream = new FileStream();
			try {
				stream.open(localeFile, FileMode.WRITE);
				stream.writeUTFBytes(FILE_HEADER + applicationModel.localeCompilationUnit.toString());
				dispatchEvent(new ApplicationStatusEvent(ApplicationStatusEvent.APPLICATION_INFO_STATUS, "'" + applicationModel.currentLocalFilePath + "' saved succesfully!"));
			} catch (e:Error) {
				logger.error("Error saving locale .as file '{0}': {1}", [applicationModel.currentLocalFilePath, e.message]);
				dispatchEvent(new ApplicationStatusEvent(ApplicationStatusEvent.APPLICATION_ERROR_STATUS, e.message, "Error saving locale file"));
			} finally {
				stream.close();
			}
			logger.error("Saved locale .as file '{0}'", [applicationModel.currentLocalFilePath]);
		}
	}
}
