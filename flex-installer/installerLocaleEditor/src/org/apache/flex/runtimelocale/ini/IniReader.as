package org.apache.flex.runtimelocale.ini {
	import flash.errors.IllegalOperationError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class IniReader {

		/** Character code for the APPLE line break. */
		public static const MAC_BREAK:String = String.fromCharCode(13);
		/** Character used internally for line breaks. */
		public static const NEWLINE_CHAR:String = "\n";

		/** Character code for the WINDOWS line break. */
		public static const WIN_BREAK:String = String.fromCharCode(13) + String.fromCharCode(10);

		private static var logger:ILogger = getClassLogger(IniReader);

		/**
		 * Constructs a new MultilineString.
		 */
		public function IniReader() {
			super();
		}

		/** Separation of all lines for the string. */
		private var _lines:Array;

		/** Original content without standardized line breaks. */
		private var _original:String;

		/**
		 * Returns a specific line within the <code>MultilineString</code>.
		 *
		 * <p>It will return <code>undefined</code> if the line does not exist.</p>
		 *
		 * <p>The line does not contain the line break.</p>
		 *
		 * <p>The counting of lines startes with <code>0</code>.</p>
		 *
		 * @param line number of the line to get the content of
		 * @return content of the line
		 */
		public function getLine(line:uint):String {
			return _lines[line];
		}

		/**
		 * Returns the content as array that contains each line.
		 *
		 * @return content split into lines
		 */
		public function get lines():Array {
			return _lines.concat();
		}

		/**
		 * Returns the amount of lines in the content.
		 *
		 * @return amount of lines within the content
		 */
		public function get numLines():uint {
			return _lines.length;
		}

		/**
		 * Returns the original used string (without line break standardisation).
		 *
		 * @return the original used string
		 */
		public function get originalString():String {
			return _original;
		}

		public function readFromFile(iniFilePath:String):Object {
			logger.debug("Reading local .ini file: " + iniFilePath);
			var file:File = File.applicationDirectory.resolvePath(iniFilePath);
			var stream:FileStream = new FileStream();
			var string:String;
			try {
				stream.open(file, FileMode.READ);
				stream.position = 0;
				string = stream.readMultiByte(stream.bytesAvailable, "utf-8");
			} finally {
				stream.close();
			}
			_original = string;
			_lines = string.split(WIN_BREAK).join(NEWLINE_CHAR).split(MAC_BREAK).join(NEWLINE_CHAR).split(NEWLINE_CHAR);
			var properties:Object = {};
			delete properties['prototype'];
			for each (var line:String in _lines) {
				if (line.substr(0, 2) != '//' && line.substr(0, 1) != '#') {
					var parts:Array = line.split('=');
					if (parts.length > 1) {
						if (parts[0] in properties) {
							throw new IllegalOperationError("Duplicate property name encountered: " + parts[0]);
						}
						properties[parts[0]] = parts[1];
						logger.debug("Extracted property: " + parts[0] + ' = ' + parts[1]);
					}
				}
			}
			return properties;
		}
	}
}
