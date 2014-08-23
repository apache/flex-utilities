////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.as3commons.lang {
	
	/**
	 * <p>Methods in this class give sample code to explain their operation.
	 * The symbol <code>*</code> is used to indicate any input
	 * including <code>null</code>.</p>
	 *
	 * @author Steffen Leistner
	 * @author Christophe Herreman
	 */
	public class StringUtils { // NO PMD TooManyFunction TooManyPublic
		
		/**
		 * The empty String <code>""</code>
		 */
		private static const EMPTY:String = '';
		
		/**
		 * Represents a failed index search.
		 */
		private static const INDEX_NOT_FOUND:int = -1;
		
		/**
		 * The control character code
		 */
		private static const WHITE:uint = 32;
		
		/**
		 * <p>The maximum size to which the padding constant(s) can expand.</p>
		 */
		private static const PAD_LIMIT:uint = 8192;
		
		/**
		 * <p>Returns a simple Initials like string.</p>
		 *
		 * StringUtils.toInitials("stringutils") 		= s
		 * StringUtils.toInitials("stringUtils") 		= su
		 * StringUtils.toInitials("stringUtilsTest") 	= sut
		 */
		public static function toInitials(str:String):String {
			if (isEmpty(str)) {
				return str;
			}
			return str.match(/[A-Z]/g).join('').toLowerCase();
		}
		
		/**
		 * <p>Removes one newline from end of a String if it's there,
		 * otherwise leave it alone.  A newline is &quot;<code>\n</code>&quot;,
		 * &quot;<code>\r</code>&quot;, or &quot;<code>\r\n</code>&quot;.</p>
		 *
		 * <pre>
		 * StringUtils.chomp(null)          = null
		 * StringUtils.chomp("")            = ""
		 * StringUtils.chomp("abc \r")      = "abc "
		 * StringUtils.chomp("abc\n")       = "abc"
		 * StringUtils.chomp("abc\r\n")     = "abc"
		 * StringUtils.chomp("abc\r\n\r\n") = "abc\r\n"
		 * StringUtils.chomp("abc\n\r")     = "abc\n"
		 * StringUtils.chomp("abc\n\rabc")  = "abc\n\rabc"
		 * StringUtils.chomp("\r")          = ""
		 * StringUtils.chomp("\n")          = ""
		 * StringUtils.chomp("\r\n")        = ""
		 * </pre>
		 *
		 * @param str  the String to chomp a newline from, may be null
		 * @return String without newline, <code>null</code> if null String input
		 */
		public static function chomp(str:String):String {
			return chompString(str, '(\r\n|\r|\n)');
		}
		
		/**
		 * <p>Removes <code>separator</code> from the end of
		 * <code>str</code> if it's there, otherwise leave it alone.</p>
		 *
		 * <p>It now more closely matches Perl chomp.
		 * For the previous behavior, use #substringBeforeLast(String, String).
		 * This method uses #endsWith(String).</p>
		 *
		 * <pre>
		 * StringUtils.chompString(null, *)         = null
		 * StringUtils.chompString("", *)           = ""
		 * StringUtils.chompString("foobar", "bar") = "foo"
		 * StringUtils.chompString("foobar", "baz") = "foobar"
		 * StringUtils.chompString("foo", "foo")    = ""
		 * StringUtils.chompString("foo ", "foo")   = "foo "
		 * StringUtils.chompString(" foo", "foo")   = " "
		 * StringUtils.chompString("foo", "foooo")  = "foo"
		 * StringUtils.chompString("foo", "")       = "foo"
		 * StringUtils.chompString("foo", null)     = "foo"
		 * </pre>
		 *
		 * @param str  the String to chomp from, may be null
		 * @param separator  separator String, may be null
		 * @return String without trailing separator, <code>null</code> if null String input
		 */
		public static function chompString(str:String, separator:String):String {
			if (isEmpty(str) || separator == null) {
				return str;
			}
			return str.replace(new RegExp(separator + '$', ''), '')
		}
		
		/**
		 * <p>Removes control characters(char &lt;= 32) from both
		 * ends of this String, handling <code>null</code> by returning
		 * <code>null</code>.</p>
		 *
		 * <p>Trim removes start and end characters &lt;= 32.
		 * To strip whitespace use #strip(String).</p>
		 *
		 * <p>To trim your choice of characters, use the
		 * #strip(String, String) methods.</p>
		 *
		 * <pre>
		 * StringUtils.trim(null)          = null
		 * StringUtils.trim("")            = ""
		 * StringUtils.trim("     ")       = ""
		 * StringUtils.trim("abc")         = "abc"
		 * StringUtils.trim("    abc    ") = "abc"
		 * </pre>
		 *
		 * @param str  the String to be trimmed, may be null
		 * @return the trimmed string, <code>null</code> if null String input
		 */
		public static function trim(str:String):String {
			if (str == null) {
				return null;
			}
			return str.replace(/^\s*/, '').replace(/\s*$/, '');
		}
		
		/**
		 * <p>Deletes all 'space' characters from a String as defined by
		 *
		 * <pre>
		 * StringUtils.deleteSpaces(null)           = null
		 * StringUtils.deleteSpaces("")             = ""
		 * StringUtils.deleteSpaces("abc")          = "abc"
		 * StringUtils.deleteSpaces(" \tabc \n ") = " abc  "
		 * StringUtils.deleteSpaces("a\nb\tc     ") = "abc     "
		 * </pre>
		 *
		 * <p>Spaces are defined as <code>{'\t', '\r', '\n', '\b'}</code>
		 * in line with the deprecated <code>isSpace</code> method.</p>
		 *
		 * @param str  the String to delete spaces from, may be null
		 * @return the String without 'spaces', <code>null</code> if null String input
		 */
		public static function deleteSpaces(str:String):String {
			return deleteFromString(str, /\t|\r|\n|\b/g);
		}
		
		/**
		 * <p>Deletes all whitespaces from a String.</p>
		 *
		 * <pre>
		 * StringUtils.deleteWhitespace(null)         = null
		 * StringUtils.deleteWhitespace("")           = ""
		 * StringUtils.deleteWhitespace("abc")        = "abc"
		 * StringUtils.deleteWhitespace("   ab  c  ") = "abc"
		 * </pre>
		 *
		 * @param str  the String to delete whitespace from, may be null
		 * @return the String without whitespaces, <code>null</code> if null String input
		 */
		public static function deleteWhitespace(str:String):String {
			return deleteFromString(str, /\s/g);
		}
		
		private static function deleteFromString(str:String, pattern:RegExp):String {
			if (isEmpty(str)) {
				return str;
			}
			return str.replace(pattern, '');
		}
		
		/**
		 * <p>Gets the leftmost <code>len</code> characters of a String.</p>
		 *
		 * <p>If <code>len</code> characters are not available, or the
		 * String is <code>null</code>, the String will be returned without
		 * an exception. An exception is thrown if len is negative.</p>
		 *
		 * <pre>
		 * StringUtils.left(null, *)    = null
		 * StringUtils.left(*, -ve)     = ""
		 * StringUtils.left("", *)      = ""
		 * StringUtils.left("abc", 0)   = ""
		 * StringUtils.left("abc", 2)   = "ab"
		 * StringUtils.left("abc", 4)   = "abc"
		 * </pre>
		 *
		 * @param str  the String to get the leftmost characters from, may be null
		 * @param len  the length of the required String, must be zero or positive
		 * @return the leftmost characters, <code>null</code> if null String input
		 */
		public static function left(str:String, len:int):String {
			if (str == null) {
				return null;
			}
			
			if (len < 0) {
				return EMPTY;
			}
			
			if (str.length <= len) {
				return str;
			}
			return str.substring(0, len);
		}
		
		/**
		 * <p>Centers a String in a larger String of size <code>size</code>.
		 * Uses a supplied String as the value to pad the String with.</p>
		 *
		 * <p>If the size is less than the String length, the String is returned.
		 * A <code>null</code> String returns <code>null</code>.
		 * A negative size is treated as zero.</p>
		 *
		 * <pre>
		 * StringUtils.center(null, *, *)     = null
		 * StringUtils.center("", 4, " ")     = "    "
		 * StringUtils.center("ab", -1, " ")  = "ab"
		 * StringUtils.center("ab", 4, " ")   = " ab "
		 * StringUtils.center("abcd", 2, " ") = "abcd"
		 * StringUtils.center("a", 4, " ")    = " a  "
		 * StringUtils.center("a", 4, "yz")   = "yayz"
		 * StringUtils.center("abc", 7, null) = "  abc  "
		 * StringUtils.center("abc", 7, "")   = "  abc  "
		 * </pre>
		 *
		 * @param str  the String to center, may be null
		 * @param size  the int size of new String, negative treated as zero
		 * @param padStr  the String to pad the new String with, must not be null or empty
		 * @return centered String, <code>null</code> if null String input
		 */
		public static function center(str:String, size:int, padStr:String):String {
			if (str == null || size <= 0) {
				return str;
			}
			
			if (isEmpty(padStr)) {
				padStr = " ";
			}
			var strLen:int = str.length;
			var pads:int = size - strLen;
			
			if (pads <= 0) {
				return str;
			}
			str = leftPad(str, strLen + pads / 2, padStr);
			str = rightPad(str, size, padStr);
			
			return str;
		}
		
		/**
		 * <p>Left pad a String with a specified String.</p>
		 *
		 * <p>Pad to a size of <code>size</code>.</p>
		 *
		 * <pre>
		 * StringUtils.leftPad(null, *, *)      = null
		 * StringUtils.leftPad("", 3, "z")      = "zzz"
		 * StringUtils.leftPad("bat", 3, "yz")  = "bat"
		 * StringUtils.leftPad("bat", 5, "yz")  = "yzbat"
		 * StringUtils.leftPad("bat", 8, "yz")  = "yzyzybat"
		 * StringUtils.leftPad("bat", 1, "yz")  = "bat"
		 * StringUtils.leftPad("bat", -1, "yz") = "bat"
		 * StringUtils.leftPad("bat", 5, null)  = "  bat"
		 * StringUtils.leftPad("bat", 5, "")    = "  bat"
		 * </pre>
		 *
		 * @param str  the String to pad out, may be null
		 * @param size  the size to pad to
		 * @param padStr  the String to pad with, null or empty treated as single space
		 * @return left padded String or original String if no padding is necessary,
		 *  <code>null</code> if null String input
		 */
		public static function leftPad(str:String, size:int, padStr:String):String {
			if (str == null) {
				return null;
			}
			
			if (isEmpty(padStr)) {
				padStr = " ";
			}
			var padLen:int = padStr.length;
			var strLen:int = str.length;
			var pads:int = size - strLen;
			
			if (pads <= 0) {
				return str; // returns original String when possible
			}
			
			if (padLen == 1 && pads <= PAD_LIMIT) {
				return leftPadChar(str, size, padStr.charAt(0));
			}
			
			if (pads == padLen) {
				return padStr.concat(str);
			} else if (pads < padLen) {
				return padStr.substring(0, pads).concat(str);
			} else {
				var padding:Array = [];
				var padChars:Array = padStr.split("");
				
				for (var i:int = 0; i < pads; i++) {
					padding[i] = padChars[i % padLen];
				}
				return padding.join("").concat(str);
			}
		}
		
		/**
		 * <p>Left pad a String with a specified character.</p>
		 *
		 * <p>Pad to a size of <code>size</code>.</p>
		 *
		 * <pre>
		 * StringUtils.leftPadChar(null, *, *)     = null
		 * StringUtils.leftPadChar("", 3, 'z')     = "zzz"
		 * StringUtils.leftPadChar("bat", 3, 'z')  = "bat"
		 * StringUtils.leftPadChar("bat", 5, 'z')  = "zzbat"
		 * StringUtils.leftPadChar("bat", 1, 'z')  = "bat"
		 * StringUtils.leftPadChar("bat", -1, 'z') = "bat"
		 * </pre>
		 *
		 * @param str  the String to pad out, may be null
		 * @param size  the size to pad to
		 * @param padChar  the character to pad with
		 * @return left padded String or original String if no padding is necessary,
		 *  <code>null</code> if null String input
		 */
		public static function leftPadChar(str:String, size:int, padChar:String):String {
			if (str == null) {
				return null;
			}
			var pads:int = size - str.length;
			
			if (pads <= 0) {
				return str; // returns original String when possible
			}
			
			if (pads > PAD_LIMIT) {
				return leftPad(str, size, padChar);
			}
			return padding(pads, padChar).concat(str);
		}
		
		/**
		 * <p>Right pad a String with a specified String.</p>
		 *
		 * <p>The String is padded to the size of <code>size</code>.</p>
		 *
		 * <pre>
		 * StringUtils.rightPad(null, *, *)      = null
		 * StringUtils.rightPad("", 3, "z")      = "zzz"
		 * StringUtils.rightPad("bat", 3, "yz")  = "bat"
		 * StringUtils.rightPad("bat", 5, "yz")  = "batyz"
		 * StringUtils.rightPad("bat", 8, "yz")  = "batyzyzy"
		 * StringUtils.rightPad("bat", 1, "yz")  = "bat"
		 * StringUtils.rightPad("bat", -1, "yz") = "bat"
		 * StringUtils.rightPad("bat", 5, null)  = "bat  "
		 * StringUtils.rightPad("bat", 5, "")    = "bat  "
		 * </pre>
		 *
		 * @param str  the String to pad out, may be null
		 * @param size  the size to pad to
		 * @param padStr  the String to pad with, null or empty treated as single space
		 * @return right padded String or original String if no padding is necessary,
		 *  <code>null</code> if null String input
		 */
		public static function rightPad(str:String, size:int, padStr:String):String {
			if (str == null) {
				return null;
			}
			
			if (isEmpty(padStr)) {
				padStr = " ";
			}
			var padLen:int = padStr.length;
			var strLen:int = str.length;
			var pads:int = size - strLen;
			
			if (pads <= 0) {
				return str; // returns original String when possible
			}
			
			if (padLen == 1 && pads <= PAD_LIMIT) {
				return rightPadChar(str, size, padStr.charAt(0));
			}
			
			if (pads == padLen) {
				return str.concat(padStr);
			} else if (pads < padLen) {
				return str.concat(padStr.substring(0, pads));
			} else {
				var padding:Array = [];
				var padChars:Array = padStr.split("");
				
				for (var i:int = 0; i < pads; i++) {
					padding[i] = padChars[i % padLen];
				}
				return str.concat(padding.join(""));
			}
		}
		
		/**
		 * <p>Right pad a String with a specified character.</p>
		 *
		 * <p>The String is padded to the size of <code>size</code>.</p>
		 *
		 * <pre>
		 * StringUtils.rightPadChar(null, *, *)     = null
		 * StringUtils.rightPadChar("", 3, 'z')     = "zzz"
		 * StringUtils.rightPadChar("bat", 3, 'z')  = "bat"
		 * StringUtils.rightPadChar("bat", 5, 'z')  = "batzz"
		 * StringUtils.rightPadChar("bat", 1, 'z')  = "bat"
		 * StringUtils.rightPadChar("bat", -1, 'z') = "bat"
		 * </pre>
		 *
		 * @param str  the String to pad out, may be null
		 * @param size  the size to pad to
		 * @param padChar  the character to pad with
		 * @return right padded String or original String if no padding is necessary,
		 *  <code>null</code> if null String input
		 */
		public static function rightPadChar(str:String, size:int, padChar:String):String {
			if (str == null) {
				return null;
			}
			var pads:int = size - str.length;
			
			if (pads <= 0) {
				return str; // returns original String when possible
			}
			
			if (pads > PAD_LIMIT) {
				return rightPad(str, size, padChar);
			}
			return str.concat(padding(pads, padChar));
		}
		
		/**
		 * <p>Returns padding using the specified delimiter repeated
		 * to a given length.</p>
		 *
		 * <pre>
		 * StringUtils.padding(0, 'e')  = ""
		 * StringUtils.padding(3, 'e')  = "eee"
		 * StringUtils.padding(-2, 'e') = IndexOutOfBoundsException
		 * </pre>
		 *
		 * @param repeat  number of times to repeat delim
		 * @param padChar  character to repeat
		 * @return String with repeated character
		 */
		private static function padding(repeat:int, padChar:String):String {
			var buffer:String = '';
			
			for (var i:int = 0; i < repeat; i++) {
				buffer += padChar;
			}
			return buffer;
		}
		
		/**
		 * <p>Replaces all occurrences of a String within another String.</p>
		 *
		 * <p>A <code>null</code> reference passed to this method is a no-op.</p>
		 *
		 * <pre>
		 * StringUtils.replace(null, *, *)        = null
		 * StringUtils.replace("", *, *)          = ""
		 * StringUtils.replace("any", null, *)    = "any"
		 * StringUtils.replace("any", *, null)    = "any"
		 * StringUtils.replace("any", "", *)      = "any"
		 * StringUtils.replace("aba", "a", null)  = "aba"
		 * StringUtils.replace("aba", "a", "")    = "b"
		 * StringUtils.replace("aba", "a", "z")   = "zbz"
		 * </pre>
		 *
		 * @param text  text to search and replace in, may be null
		 * @param pattern  the String to search for, may be null
		 * @param repl  the String to replace with, may be null
		 * @return the text with any replacements processed,
		 *  <code>null</code> if null String input
		 */
		public static function replace(text:String, pattern:String, repl:String):String {
			if (text == null || isEmpty(pattern) || repl == null) {
				return text;
			}
			return text.replace(new RegExp(pattern, 'g'), repl);
		}
		
		/**
		 * <p>Replaces a String with another String inside a larger String,
		 * for the first <code>max</code> values of the search String.</p>
		 *
		 * <p>A <code>null</code> reference passed to this method is a no-op.</p>
		 *
		 * <pre>
		 * StringUtils.replaceTo(null, *, *, *)         = null
		 * StringUtils.replaceTo("", *, *, *)           = ""
		 * StringUtils.replaceTo("any", null, *, *)     = "any"
		 * StringUtils.replaceTo("any", *, null, *)     = "any"
		 * StringUtils.replaceTo("any", "", *, *)       = "any"
		 * StringUtils.replaceTo("any", *, *, 0)        = "any"
		 * StringUtils.replaceTo("abaa", "a", null, -1) = "abaa"
		 * StringUtils.replaceTo("abaa", "a", "", -1)   = "b"
		 * StringUtils.replaceTo("abaa", "a", "z", 0)   = "abaa"
		 * StringUtils.replaceTo("abaa", "a", "z", 1)   = "zbaa"
		 * StringUtils.replaceTo("abaa", "a", "z", 2)   = "zbza"
		 * StringUtils.replaceTo("abaa", "a", "z", -1)  = "zbzz"
		 * </pre>
		 *
		 * @param text  text to search and replace in, may be null
		 * @param repl  the String to search for, may be null
		 * @param with  the String to replace with, may be null
		 * @param max  maximum number of values to replace, or <code>-1</code> if no maximum
		 * @return the text with any replacements processed,
		 *  <code>null</code> if null String input
		 */
		public static function replaceTo(text:String, pattern:String, repl:String, max:int):String {
			if (text == null || isEmpty(pattern) || repl == null || max == 0) {
				return text;
			}
			
			var buf:String = "";
			var start:int = 0;
			var end:int = 0;
			
			while ((end = text.indexOf(pattern, start)) != -1) {
				buf += text.substring(start, end) + repl;
				start = end + pattern.length;
				
				if (--max == 0) {
					break;
				}
			}
			return buf += text.substring(start);
		}
		
		/**
		 * <p>Replaces a String with another String inside a larger String, once.</p>
		 *
		 * <p>A <code>null</code> reference passed to this method is a no-op.</p>
		 *
		 * <pre>
		 * StringUtils.replaceOnce(null, *, *)        = null
		 * StringUtils.replaceOnce("", *, *)          = ""
		 * StringUtils.replaceOnce("any", null, *)    = "any"
		 * StringUtils.replaceOnce("any", *, null)    = "any"
		 * StringUtils.replaceOnce("any", "", *)      = "any"
		 * StringUtils.replaceOnce("aba", "a", null)  = "aba"
		 * StringUtils.replaceOnce("aba", "a", "")    = "ba"
		 * StringUtils.replaceOnce("aba", "a", "z")   = "zba"
		 * </pre>
		 *
		 * @see #replaceTo(text:String, pattern:String, repl:String, max:int)
		 * @param text  text to search and replace in, may be null
		 * @param repl  the String to search for, may be null
		 * @param with  the String to replace with, may be null
		 * @return the text with any replacements processed,
		 *  <code>null</code> if null String input
		 */
		public static function replaceOnce(text:String, pattern:String, repl:String):String {
			if (text == null || isEmpty(pattern) || repl == null) {
				return text;
			}
			return text.replace(new RegExp(pattern, ''), repl);
		}
		
		/**
		 * <p>Returns either the passed in String, or if the String is
		 * empty or <code>null</code>, the value of <code>defaultStr</code>.</p>
		 *
		 * <pre>
		 * StringUtils.defaultIfEmpty(null, "NULL")  = "NULL"
		 * StringUtils.defaultIfEmpty("", "NULL")    = "NULL"
		 * StringUtils.defaultIfEmpty("bat", "NULL") = "bat"
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @param defaultStr  the default String to return
		 *  if the input is empty("") or <code>null</code>, may be null
		 * @return the passed in String, or the default
		 */
		public static function defaultIfEmpty(str:String, defaultStr:String):String {
			return isEmpty(str) ? defaultStr : str;
		}
		
		/**
		 * <p>Checks if a String is empty("") or null.</p>
		 *
		 * <pre>
		 * StringUtils.isEmpty(null)      = true
		 * StringUtils.isEmpty("")        = true
		 * StringUtils.isEmpty(" ")       = false
		 * StringUtils.isEmpty("bob")     = false
		 * StringUtils.isEmpty("  bob  ") = false
		 * </pre>
		 *
		 * <p>NOTE: This method changed in Lang version 2.0.
		 * It no longer trims the String.
		 * That functionality is available in isBlank().</p>
		 *
		 * @param str  the String to check, may be null
		 * @return <code>true</code> if the String is empty or null
		 */
		public static function isEmpty(str:String):Boolean {
			if (str == null) {
				return true;
			}
			return str.length == 0;
		}
		
		/**
		 * <p>Checks if a String is not empty("") and not null.</p>
		 *
		 * <pre>
		 * StringUtils.isNotEmpty(null)      = false
		 * StringUtils.isNotEmpty("")        = false
		 * StringUtils.isNotEmpty(" ")       = true
		 * StringUtils.isNotEmpty("bob")     = true
		 * StringUtils.isNotEmpty("  bob  ") = true
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @return <code>true</code> if the String is not empty and not null
		 */
		public static function isNotEmpty(str:String):Boolean {
			return !isEmpty(str);
		}
		
		/**
		 * <p>Checks if a String is whitespace, empty("") or null.</p>
		 *
		 * <pre>
		 * StringUtils.isBlank(null)      = true
		 * StringUtils.isBlank("")        = true
		 * StringUtils.isBlank(" ")       = true
		 * StringUtils.isBlank("bob")     = false
		 * StringUtils.isBlank("  bob  ") = false
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @return <code>true</code> if the String is null, empty or whitespace
		 */
		public static function isBlank(str:String):Boolean {
			return isEmpty(trimToEmpty(str));
		}
		
		/**
		 * <p>Checks if a String is not empty(""), not <code>null</code>
		 * and not whitespace only.</p>
		 *
		 * <pre>
		 * StringUtils.isNotBlank(null)      = false
		 * StringUtils.isNotBlank("")        = false
		 * StringUtils.isNotBlank(" ")       = false
		 * StringUtils.isNotBlank("bob")     = true
		 * StringUtils.isNotBlank("  bob  ") = true
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @return <code>true</code> if the String is
		 *  not empty and not null and not whitespace
		 */
		public static function isNotBlank(str:String):Boolean {
			return !isBlank(str);
		}
		
		/**
		 * <p>Removes control characters (char &lt;= 32) from both
		 * ends of this String returning <code>null</code> if the String is
		 * empty ("") after the trim or if it is <code>null</code>.
		 *
		 * <p>The String is trimmed using #trim().
		 * Trim removes start and end characters &lt;= 32.</p>
		 *
		 * <pre>
		 * StringUtils.trimToNull(null)          = null
		 * StringUtils.trimToNull("")            = null
		 * StringUtils.trimToNull("     ")       = null
		 * StringUtils.trimToNull("abc")         = "abc"
		 * StringUtils.trimToNull("    abc    ") = "abc"
		 * </pre>
		 *
		 * @param str  the String to be trimmed, may be null
		 * @return the trimmed String,
		 *  <code>null</code> if only chars &lt;= 32, empty or null String input
		 */
		public static function trimToNull(str:String):String {
			var trimedString:String = trim(str);
			return isEmpty(trimedString) ? null : trimedString;
		}
		
		/**
		 * <p>Removes control characters (char &lt;= 32) from both
		 * ends of this String returning an empty String ("") if the String
		 * is empty ("") after the trim or if it is <code>null</code>.
		 *
		 * <p>The String is trimmed using #trim().
		 * Trim removes start and end characters &lt;= 32.
		 * To strip whitespace use #stripToEmpty(String).</p>
		 *
		 * <pre>
		 * StringUtils.trimToEmpty(null)          = ""
		 * StringUtils.trimToEmpty("")            = ""
		 * StringUtils.trimToEmpty("     ")       = ""
		 * StringUtils.trimToEmpty("abc")         = "abc"
		 * StringUtils.trimToEmpty("    abc    ") = "abc"
		 * </pre>
		 *
		 * @param str  the String to be trimmed, may be null
		 * @return the trimmed String, or an empty String if <code>null</code> input
		 */
		public static function trimToEmpty(str:String):String {
			return str == null ? EMPTY : trim(str);
		}
		
		/**
		 * <p>Capitalizes a String changing the first letter to title case.
		 * No other letters are changed.</p>
		 *
		 * A <code>null</code> input String returns <code>null</code>.</p>
		 *
		 * <pre>
		 * StringUtils.capitalize(null)  = null
		 * StringUtils.capitalize("")    = ""
		 * StringUtils.capitalize("cat") = "Cat"
		 * StringUtils.capitalize("cAt") = "CAt"
		 * </pre>
		 *
		 * @param str  the String to capitalize, may be null
		 * @return the capitalized String, <code>null</code> if null String input
		 * @see titleize(String)
		 * @see #uncapitalize(String)
		 */
		public static function capitalize(str:String):String {
			if (isEmpty(str)) {
				return str;
			}
			return str.charAt(0).toUpperCase() + str.substring(1);
		}
		
		/**
		 * <p>Uncapitalizes a String changing the first letter to title case.
		 * No other letters are changed.</p>
		 *
		 * <pre>
		 * StringUtils.uncapitalize(null)  = null
		 * StringUtils.uncapitalize("")    = ""
		 * StringUtils.uncapitalize("Cat") = "cat"
		 * StringUtils.uncapitalize("CAT") = "cAT"
		 * </pre>
		 *
		 * @param str  the String to uncapitalize, may be null
		 * @return the uncapitalized String, <code>null</code> if null String input
		 * @see #capitalize(String)
		 */
		public static function uncapitalize(str:String):String {
			if (isEmpty(str)) {
				return str;
			}
			return str.charAt(0).toLowerCase() + str.substring(1);
		}
		
		/**
		 * <p>Capitalizes all the words and replaces some characters in
		 * the string to create a nicer looking title.
		 * Titleize is meant for creating pretty output.</p>
		 *
		 * <pre>
		 * StringUtils.titleize(null)  = null
		 * StringUtils.titleize("")    = ""
		 * StringUtils.titleize("man from the boondocks") = "Man From The Boondocks"
		 * StringUtils.titleize("man from THE bOOndocks") = "Man From The Boondocks"
		 * </pre>
		 *
		 * @param str  the String to uncapitalize, may be null
		 * @return the uncapitalized String, <code>null</code> if null String input
		 * @see #capitalize(String)
		 */
		public static function titleize(str:String):String {
			if (isEmpty(str)) {
				return str;
			}
			var words:Array = str.toLowerCase().split(' ');
			
			for (var i:int = 0; i < words.length; i++) {
				words[i] = capitalize(words[i]);
			}
			return words.join(' ');
		}
		
		/**
		 * <p>Gets the substring after the first occurrence of a separator.
		 * The separator is not returned.</p>
		 *
		 * <p>A <code>null</code> string input will return <code>null</code>.
		 * An empty("") string input will return the empty string.
		 * A <code>null</code> separator will return the empty string if the
		 * input string is not <code>null</code>.</p>
		 *
		 * <pre>
		 * StringUtils.substringAfter(null, *)      = null
		 * StringUtils.substringAfter("", *)        = ""
		 * StringUtils.substringAfter(*, null)      = ""
		 * StringUtils.substringAfter("abc", "a")   = "bc"
		 * StringUtils.substringAfter("abcba", "b") = "cba"
		 * StringUtils.substringAfter("abc", "c")   = ""
		 * StringUtils.substringAfter("abc", "d")   = ""
		 * StringUtils.substringAfter("abc", "")    = "abc"
		 * </pre>
		 *
		 * @param str  the String to get a substring from, may be null
		 * @param separator  the String to search for, may be null
		 * @return the substring after the first occurrence of the separator,
		 *  <code>null</code> if null String input
		 */
		public static function substringAfter(str:String, separator:String):String {
			if (isEmpty(str)) {
				return str;
			}
			
			if (separator == null) {
				return EMPTY;
			}
			var pos:int = str.indexOf(separator);
			
			if (pos == INDEX_NOT_FOUND) {
				return EMPTY;
			}
			return str.substring(pos + separator.length);
		}
		
		/**
		 * <p>Gets the substring after the last occurrence of a separator.
		 * The separator is not returned.</p>
		 *
		 * <p>A <code>null</code> string input will return <code>null</code>.
		 * An empty("") string input will return the empty string.
		 * An empty or <code>null</code> separator will return the empty string if
		 * the input string is not <code>null</code>.</p>
		 *
		 * <pre>
		 * StringUtils.substringAfterLast(null, *)      = null
		 * StringUtils.substringAfterLast("", *)        = ""
		 * StringUtils.substringAfterLast(*, "")        = ""
		 * StringUtils.substringAfterLast(*, null)      = ""
		 * StringUtils.substringAfterLast("abc", "a")   = "bc"
		 * StringUtils.substringAfterLast("abcba", "b") = "a"
		 * StringUtils.substringAfterLast("abc", "c")   = ""
		 * StringUtils.substringAfterLast("a", "a")     = ""
		 * StringUtils.substringAfterLast("a", "z")     = ""
		 * </pre>
		 *
		 * @param str  the String to get a substring from, may be null
		 * @param separator  the String to search for, may be null
		 * @return the substring after the last occurrence of the separator,
		 *  <code>null</code> if null String input
		 */
		public static function substringAfterLast(str:String, separator:String):String {
			if (isEmpty(str)) {
				return str;
			}
			
			if (isEmpty(separator)) {
				return EMPTY;
			}
			var pos:int = str.lastIndexOf(separator);
			
			if (pos == INDEX_NOT_FOUND || pos == (str.length - separator.length)) {
				return EMPTY;
			}
			return str.substring(pos + separator.length);
		}
		
		/**
		 * <p>Gets the substring before the first occurrence of a separator.
		 * The separator is not returned.</p>
		 *
		 * <p>A <code>null</code> string input will return <code>null</code>.
		 * An empty("") string input will return the empty string.
		 * A <code>null</code> separator will return the input string.</p>
		 *
		 * <pre>
		 * StringUtils.substringBefore(null, *)      = null
		 * StringUtils.substringBefore("", *)        = ""
		 * StringUtils.substringBefore("abc", "a")   = ""
		 * StringUtils.substringBefore("abcba", "b") = "a"
		 * StringUtils.substringBefore("abc", "c")   = "ab"
		 * StringUtils.substringBefore("abc", "d")   = "abc"
		 * StringUtils.substringBefore("abc", "")    = ""
		 * StringUtils.substringBefore("abc", null)  = "abc"
		 * </pre>
		 *
		 * @param str  the String to get a substring from, may be null
		 * @param separator  the String to search for, may be null
		 * @return the substring before the first occurrence of the separator,
		 *  <code>null</code> if null String input
		 */
		public static function substringBefore(str:String, separator:String):String {
			if (isEmpty(str) || separator == null) {
				return str;
			}
			
			if (separator.length == 0) {
				return EMPTY;
			}
			var pos:int = str.indexOf(separator);
			
			if (pos == INDEX_NOT_FOUND) {
				return str;
			}
			return str.substring(0, pos);
		}
		
		/**
		 * <p>Gets the substring before the last occurrence of a separator.
		 * The separator is not returned.</p>
		 *
		 * <p>A <code>null</code> string input will return <code>null</code>.
		 * An empty("") string input will return the empty string.
		 * An empty or <code>null</code> separator will return the input string.</p>
		 *
		 * <pre>
		 * StringUtils.substringBeforeLast(null, *)      = null
		 * StringUtils.substringBeforeLast("", *)        = ""
		 * StringUtils.substringBeforeLast("abcba", "b") = "abc"
		 * StringUtils.substringBeforeLast("abc", "c")   = "ab"
		 * StringUtils.substringBeforeLast("a", "a")     = ""
		 * StringUtils.substringBeforeLast("a", "z")     = "a"
		 * StringUtils.substringBeforeLast("a", null)    = "a"
		 * StringUtils.substringBeforeLast("a", "")      = "a"
		 * </pre>
		 *
		 * @param str  the String to get a substring from, may be null
		 * @param separator  the String to search for, may be null
		 * @return the substring before the last occurrence of the separator,
		 *  <code>null</code> if null String input
		 */
		public static function substringBeforeLast(str:String, separator:String):String {
			if (isEmpty(str) || isEmpty(separator)) {
				return str;
			}
			var pos:int = str.lastIndexOf(separator);
			
			if (pos == INDEX_NOT_FOUND) {
				return str;
			}
			return str.substring(0, pos);
		}
		
		/**
		 * <p>Gets the String that is nested in between two Strings.
		 * Only the first match is returned.</p>
		 *
		 * <p>A <code>null</code> input String returns <code>null</code>.
		 * A <code>null</code> open/close returns <code>null</code>(no match).
		 * An empty("") open/close returns an empty string.</p>
		 *
		 * <pre>
		 * StringUtils.substringBetween(null, *, *)          = null
		 * StringUtils.substringBetween("", "", "")          = ""
		 * StringUtils.substringBetween("", "", "tag")       = null
		 * StringUtils.substringBetween("", "tag", "tag")    = null
		 * StringUtils.substringBetween("yabcz", null, null) = null
		 * StringUtils.substringBetween("yabcz", "", "")     = ""
		 * StringUtils.substringBetween("yabcz", "y", "z")   = "abc"
		 * StringUtils.substringBetween("yabczyabcz", "y", "z")   = "abc"
		 * </pre>
		 *
		 * @param str  the String containing the substring, may be null
		 * @param open  the String before the substring, may be null
		 * @param close  the String after the substring, may be null
		 * @return the substring, <code>null</code> if no match
		 */
		public static function substringBetween(str:String, open:String, close:String):String {
			if (str == null || open == null || close == null) {
				return null;
			}
			var start:int = str.indexOf(open);
			
			if (start != INDEX_NOT_FOUND) {
				var end:int = str.indexOf(close, start + open.length);
				
				if (end != INDEX_NOT_FOUND) {
					return str.substring(start + open.length, end);
				}
			}
			return null;
		}
		
		/**
		 * <p>Strips any of a set of characters from the start and end of a String.
		 * This is similar to #trim() but allows the characters
		 * to be stripped to be controlled.</p>
		 *
		 * <p>A <code>null</code> input String returns <code>null</code>.
		 * An empty string("") input returns the empty string.</p>
		 *
		 * <pre>
		 * StringUtils.strip(null, *)          = null
		 * StringUtils.strip("", *)            = ""
		 * StringUtils.strip("abc", null)      = "abc"
		 * StringUtils.strip("  abc", null)    = "abc"
		 * StringUtils.strip("abc  ", null)    = "abc"
		 * StringUtils.strip(" abc ", null)    = "abc"
		 * StringUtils.strip("  abcyx", "xyz") = "  abc"
		 * </pre>
		 *
		 * @param str  the String to remove characters from, may be null
		 * @param stripChars  the characters to remove, null treated as whitespace
		 * @return the stripped String, <code>null</code> if null String input
		 */
		public static function strip(str:String, stripChars:String):String {
			if (isEmpty(str)) {
				return str;
			}
			return stripEnd(stripStart(str, stripChars), stripChars);
		}
		
		/**
		 * <p>Strips any of a set of characters from the start of a String.</p>
		 *
		 * <p>A <code>null</code> input String returns <code>null</code>.
		 * An empty string("") input returns the empty string.</p>
		 *
		 * <pre>
		 * StringUtils.stripStart(null, *)          = null
		 * StringUtils.stripStart("", *)            = ""
		 * StringUtils.stripStart("abc", "")        = "abc"
		 * StringUtils.stripStart("abc", null)      = "abc"
		 * StringUtils.stripStart("  abc", null)    = "abc"
		 * StringUtils.stripStart("abc  ", null)    = "abc  "
		 * StringUtils.stripStart(" abc ", null)    = "abc "
		 * StringUtils.stripStart("yxabc  ", "xyz") = "abc  "
		 * </pre>
		 *
		 * @param str  the String to remove characters from, may be null
		 * @param stripChars  the characters to remove, null treated as whitespace
		 * @return the stripped String, <code>null</code> if null String input
		 */
		public static function stripStart(str:String, stripChars:String):String {
			if (isEmpty(str)) {
				return str;
			}
			var p:RegExp = new RegExp('^[' + (stripChars != null ? stripChars : ' ') + ']*', '');
			return str.replace(p, '');
		}
		
		/**
		 * <p>Strips any of a set of characters from the end of a String.</p>
		 *
		 * <p>A <code>null</code> input String returns <code>null</code>.
		 * An empty string("") input returns the empty string.</p>
		 *
		 * <p>If the stripChars String is <code>null</code>, whitespace is
		 * stripped.</p>
		 *
		 * <pre>
		 * StringUtils.stripEnd(null, *)          = null
		 * StringUtils.stripEnd("", *)            = ""
		 * StringUtils.stripEnd("abc", "")        = "abc"
		 * StringUtils.stripEnd("abc", null)      = "abc"
		 * StringUtils.stripEnd("  abc", null)    = "  abc"
		 * StringUtils.stripEnd("abc  ", null)    = "abc"
		 * StringUtils.stripEnd(" abc ", null)    = " abc"
		 * StringUtils.stripEnd("  abcyx", "xyz") = "  abc"
		 * </pre>
		 *
		 * @param str  the String to remove characters from, may be null
		 * @param stripChars  the characters to remove, null treated as whitespace
		 * @return the stripped String, <code>null</code> if null String input
		 */
		public static function stripEnd(str:String, stripChars:String):String {
			if (isEmpty(str)) {
				return str;
			}
			var p:RegExp = new RegExp('[' + (stripChars != null ? stripChars : ' ') + ']*$', '');
			return str.replace(p, '');
		}
		
		/**
		 * <p>Abbreviates a String using ellipses. This will turn
		 * "Now is the time for all good men" into "...is the time for..."</p>
		 *
		 * <p>Works like <code>abbreviate(String, int)</code>, but allows you to specify
		 * a "left edge" offset.  Note that this left edge is not necessarily going to
		 * be the leftmost character in the result, or the first character following the
		 * ellipses, but it will appear somewhere in the result.
		 *
		 * <p>In no case will it return a String of length greater than
		 * <code>maxWidth</code>.</p>
		 *
		 * <pre>
		 * StringUtils.abbreviate(null, *, *)                = null
		 * StringUtils.abbreviate("", 0, 4)                  = ""
		 * StringUtils.abbreviate("abcdefghijklmno", -1, 10) = "abcdefg..."
		 * StringUtils.abbreviate("abcdefghijklmno", 0, 10)  = "abcdefg..."
		 * StringUtils.abbreviate("abcdefghijklmno", 1, 10)  = "abcdefg..."
		 * StringUtils.abbreviate("abcdefghijklmno", 4, 10)  = "abcdefg..."
		 * StringUtils.abbreviate("abcdefghijklmno", 5, 10)  = "...fghi..."
		 * StringUtils.abbreviate("abcdefghijklmno", 6, 10)  = "...ghij..."
		 * StringUtils.abbreviate("abcdefghijklmno", 8, 10)  = "...ijklmno"
		 * StringUtils.abbreviate("abcdefghijklmno", 10, 10) = "...ijklmno"
		 * StringUtils.abbreviate("abcdefghijklmno", 12, 10) = "...ijklmno"
		 * StringUtils.abbreviate("abcdefghij", 0, 3)        = IllegalArgumentException
		 * StringUtils.abbreviate("abcdefghij", 5, 6)        = IllegalArgumentException
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @param offset  left edge of source String
		 * @param maxWidth  maximum length of result String, must be at least 4
		 * @return abbreviated String, <code>null</code> if null String input
		 * @throws IllegalArgumentException if the width is too small
		 */
		public static function abbreviate(str:String, offset:int, maxWidth:int):String {
			if (str == null) {
				return str;
			}
			
			if (maxWidth < 4) {
				throw new IllegalArgumentError("Minimum abbreviation width is 4");
			}
			
			if (str.length <= maxWidth) {
				return str;
			}
			
			if (offset > str.length) {
				offset = str.length;
			}
			
			if ((str.length - offset) < (maxWidth - 3)) {
				offset = str.length - (maxWidth - 3);
			}
			
			if (offset <= 4) {
				return str.substring(0, maxWidth - 3) + "...";
			}
			
			if (maxWidth < 7) {
				throw new IllegalArgumentError("Minimum abbreviation width with offset is 7");
			}
			
			if ((offset + (maxWidth - 3)) < str.length) {
				return "..." + abbreviate(str.substring(offset), 0, maxWidth - 3);
			}
			return "..." + str.substring(str.length - (maxWidth - 3));
		}
		
		/**
		 * <p>Finds the n-th index within a String, handling <code>null</code>.
		 * This method uses String#indexOf(String).</p>
		 *
		 * <p>A <code>null</code> String will return <code>-1</code>.</p>
		 *
		 * <pre>
		 * StringUtils.ordinalIndexOf(null, *, *)          = -1
		 * StringUtils.ordinalIndexOf(*, null, *)          = -1
		 * StringUtils.ordinalIndexOf("", "", *)           = 0
		 * StringUtils.ordinalIndexOf("aabaabaa", "a", 1)  = 0
		 * StringUtils.ordinalIndexOf("aabaabaa", "a", 2)  = 1
		 * StringUtils.ordinalIndexOf("aabaabaa", "b", 1)  = 2
		 * StringUtils.ordinalIndexOf("aabaabaa", "b", 2)  = 5
		 * StringUtils.ordinalIndexOf("aabaabaa", "ab", 1) = 1
		 * StringUtils.ordinalIndexOf("aabaabaa", "ab", 2) = 4
		 * StringUtils.ordinalIndexOf("aabaabaa", "", 1)   = 0
		 * StringUtils.ordinalIndexOf("aabaabaa", "", 2)   = 0
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @param searchStr  the String to find, may be null
		 * @param ordinal  the n-th <code>searchStr</code> to find
		 * @return the n-th index of the search String,
		 *  <code>-1</code>(<code>INDEX_NOT_FOUND</code>) if no match or <code>null</code> string input
		 */
		public static function ordinalIndexOf(str:String, searchStr:String, ordinal:int):int {
			if (str == null || searchStr == null || ordinal <= 0) {
				return INDEX_NOT_FOUND;
			}
			
			if (searchStr.length == 0) {
				return 0;
			}
			var found:int = 0;
			var index:int = INDEX_NOT_FOUND;
			
			do {
				index = str.indexOf(searchStr, index + 1);
				
				if (index < 0) {
					return index;
				}
				found++;
			} while (found < ordinal);
			return index;
		}
		
		/**
		 * <p>Counts how many times the substring appears in the larger String.</p>
		 *
		 * <p>A <code>null</code> or empty("") String input returns <code>0</code>.</p>
		 *
		 * <pre>
		 * StringUtils.countMatches(null, *)       = 0
		 * StringUtils.countMatches("", *)         = 0
		 * StringUtils.countMatches("abba", null)  = 0
		 * StringUtils.countMatches("abba", "")    = 0
		 * StringUtils.countMatches("abba", "a")   = 2
		 * StringUtils.countMatches("abba", "ab")  = 1
		 * StringUtils.countMatches("abba", "xxx") = 0
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @param sub  the substring to count, may be null
		 * @return the number of occurrences, 0 if either String is <code>null</code>
		 */
		public static function countMatches(str:String, sub:String):int {
			if (isEmpty(str) || isEmpty(sub)) {
				return 0;
			}
			return str.match(new RegExp('(' + sub + ')', 'g')).length;
		}
		
		/**
		 * <p>Checks if String contains a search String, handling <code>null</code>.
		 *
		 * <p>A <code>null</code> String will return <code>false</code>.</p>
		 *
		 * <pre>
		 * StringUtils.contains(null, *)     = false
		 * StringUtils.contains(*, null)     = false
		 * StringUtils.contains("", "")      = true
		 * StringUtils.contains("abc", "")   = true
		 * StringUtils.contains("abc", "a")  = true
		 * StringUtils.contains("abc", "z")  = false
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @param searchStr  the String to find, may be null
		 * @return true if the String contains the search String,
		 *  false if not or <code>null</code> string input
		 */
		public static function contains(str:String, searchStr:String):Boolean {
			if (str == null || searchStr == null) {
				return false;
			}
			return new RegExp('(' + searchStr + ')', 'g').test(str);
		}
		
		/**
		 * <p>Checks that the String does not contain certain characters.</p>
		 *
		 * <p>A <code>null</code> String will return <code>true</code>.
		 * A <code>null</code> invalid character array will return <code>true</code>.
		 * An empty String("") always returns true.</p>
		 *
		 * <pre>
		 * StringUtils.containsNone(null, *)       = true
		 * StringUtils.containsNone(*, null)       = true
		 * StringUtils.containsNone("", *)         = true
		 * StringUtils.containsNone("ab", "")      = true
		 * StringUtils.containsNone("abab", "xyz") = true
		 * StringUtils.containsNone("ab1", "xyz")  = true
		 * StringUtils.containsNone("abz", "xyz")  = false
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @param invalidChars  a String of invalid chars, may be null
		 * @return true if it contains none of the invalid chars, or is null
		 */
		public static function containsNone(str:String, invalidChars:String):Boolean {
			if (isEmpty(str) || invalidChars == null) {
				return true;
			}
			return new RegExp('^[^' + invalidChars + ']*$', '').test(str);
		}
		
		/**
		 * <p>Checks if the String contains only certain characters.</p>
		 *
		 * <p>A <code>null</code> String will return <code>false</code>.
		 * A <code>null</code> valid character String will return <code>false</code>.
		 * An empty String("") always returns <code>true</code>.</p>
		 *
		 * <pre>
		 * StringUtils.containsOnly(null, *)       = false
		 * StringUtils.containsOnly(*, null)       = false
		 * StringUtils.containsOnly("", *)         = true
		 * StringUtils.containsOnly("ab", "")      = false
		 * StringUtils.containsOnly("abab", "abc") = true
		 * StringUtils.containsOnly("ab1", "abc")  = false
		 * StringUtils.containsOnly("abz", "abc")  = false
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @param validChars  a String of valid chars, may be null
		 * @return true if it only contains valid chars and is non-null
		 */
		public static function containsOnly(str:String, validChars:String):Boolean {
			if (str == null || isEmpty(validChars)) {
				return false;
			}
			
			if (str.length == 0) {
				return true;
			}
			return new RegExp('^[' + validChars + ']*$', 'g').test(str);
		}
		
		/**
		 * <p>Search a String to find the first index of any
		 * character in the given set of characters.</p>
		 *
		 * <p>A <code>null</code> String will return <code>-1</code>.
		 * A <code>null</code> search string will return <code>-1</code>.</p>
		 *
		 * <pre>
		 * StringUtils.indexOfAny(null, *)            = -1
		 * StringUtils.indexOfAny("", *)              = -1
		 * StringUtils.indexOfAny(*, null)            = -1
		 * StringUtils.indexOfAny(*, "")              = -1
		 * StringUtils.indexOfAny("zzabyycdxx", "za") = 0
		 * StringUtils.indexOfAny("zzabyycdxx", "by") = 3
		 * StringUtils.indexOfAny("aba","z")          = -1
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @param searchChars  the chars to search for, may be null
		 * @return the index of any of the chars, -1 if no match or null input
		 */
		public static function indexOfAny(str:String, searchChars:String):int {
			if (isEmpty(str) || isEmpty(searchChars)) {
				return INDEX_NOT_FOUND;
			}
			return str.search(new RegExp('[' + searchChars + ']', ''));
		}
		
		/**
		 * <p>Search a String to find the first index of any
		 * character not in the given set of characters.</p>
		 *
		 * <p>A <code>null</code> String will return <code>-1</code>.
		 * A <code>null</code> search string will return <code>-1</code>.</p>
		 *
		 * <pre>
		 * StringUtils.indexOfAnyBut(null, *)            = -1
		 * StringUtils.indexOfAnyBut("", *)              = -1
		 * StringUtils.indexOfAnyBut(*, null)            = -1
		 * StringUtils.indexOfAnyBut(*, "")              = -1
		 * StringUtils.indexOfAnyBut("zzabyycdxx", "za") = 3
		 * StringUtils.indexOfAnyBut("aba","ab")         = -1
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @param searchChars  the chars to search for, may be null
		 * @return the index of any of the chars, -1 if no match or null input
		 */
		public static function indexOfAnyBut(str:String, searchChars:String):int {
			if (isEmpty(str) || isEmpty(searchChars)) {
				return INDEX_NOT_FOUND;
			}
			return str.search(new RegExp('[^' + searchChars + ']', ''));
		}
		
		/**
		 * <p>Compares two Strings, and returns the portion where they differ.
		 *(More precisely, return the remainder of the second String,
		 * starting from where it's different from the first.)</p>
		 *
		 * <p>For example,
		 * <code>difference("i am a machine", "i am a robot") -> "robot"</code>.</p>
		 *
		 * <pre>
		 * StringUtils.difference(null, null) = null
		 * StringUtils.difference("", "") = ""
		 * StringUtils.difference("", "abc") = "abc"
		 * StringUtils.difference("abc", "") = ""
		 * StringUtils.difference("abc", "abc") = ""
		 * StringUtils.difference("ab", "abxyz") = "xyz"
		 * StringUtils.difference("abcde", "abxyz") = "xyz"
		 * StringUtils.difference("abcde", "xyz") = "xyz"
		 * </pre>
		 *
		 * @param str1  the first String, may be null
		 * @param str2  the second String, may be null
		 * @return the portion of str2 where it differs from str1; returns the
		 * empty String if they are equal
		 */
		public static function difference(str1:String, str2:String):String {
			if (str1 == null) {
				return str2;
			}
			
			if (str2 == null) {
				return str1;
			}
			var att:int = indexOfDifference(str1, str2);
			
			if (att == -1) {
				return EMPTY;
			}
			return str2.substring(att);
		}
		
		/**
		 * <p>Compares two Strings, and returns the index at which the
		 * Strings begin to differ.</p>
		 *
		 * <p>For example,
		 * <code>indexOfDifference("i am a machine", "i am a robot") -> 7</code></p>
		 *
		 * <pre>
		 * StringUtils.indexOfDifference(null, null) = -1
		 * StringUtils.indexOfDifference("", "") = -1
		 * StringUtils.indexOfDifference("", "abc") = 0
		 * StringUtils.indexOfDifference("abc", "") = 0
		 * StringUtils.indexOfDifference("abc", "abc") = -1
		 * StringUtils.indexOfDifference("ab", "abxyz") = 2
		 * StringUtils.indexOfDifference("abcde", "abxyz") = 2
		 * StringUtils.indexOfDifference("abcde", "xyz") = 0
		 * </pre>
		 *
		 * @param str1  the first String, may be null
		 * @param str2  the second String, may be null
		 * @return the index where str2 and str1 begin to differ; -1 if they are equal
		 */
		public static function indexOfDifference(str1:String, str2:String):int {
			if (str1 == str2) {
				return INDEX_NOT_FOUND;
			}
			
			if (isEmpty(str1) || isEmpty(str2)) {
				return 0;
			}
			var charIndex:int;
			
			for (charIndex = 0; charIndex < str1.length && charIndex < str2.length; ++charIndex) {
				if (str1.charAt(charIndex) != str2.charAt(charIndex)) {
					break;
				}
			}
			
			if (charIndex < str2.length || charIndex < str1.length) {
				return charIndex;
			}
			return INDEX_NOT_FOUND;
		}
		
		/**
		 * <p>Compares two Strings, returning <code>true</code> if they are equal.</p>
		 *
		 * <p><code>null</code>s are handled without exceptions. Two <code>null</code>
		 * references are considered to be equal. The comparison is case sensitive.</p>
		 *
		 * <pre>
		 * StringUtils.equals(null, null)   = true
		 * StringUtils.equals(null, "abc")  = false
		 * StringUtils.equals("abc", null)  = false
		 * StringUtils.equals("abc", "abc") = true
		 * StringUtils.equals("abc", "ABC") = false
		 * </pre>
		 *
		 * @param str1  the first String, may be null
		 * @param str2  the second String, may be null
		 * @return <code>true</code> if the Strings are equal, case sensitive, or
		 *  both <code>null</code>
		 */
		public static function equals(str1:String, str2:String):Boolean {
			return str1 === str2;
		}
		
		/**
		 * <p>Compares two Strings, returning <code>true</code> if they are equal ignoring
		 * the case.</p>
		 *
		 * <p><code>null</code>s are handled without exceptions. Two <code>null</code>
		 * references are considered equal. Comparison is case insensitive.</p>
		 *
		 * <pre>
		 * StringUtils.equalsIgnoreCase(null, null)   = true
		 * StringUtils.equalsIgnoreCase(null, "abc")  = false
		 * StringUtils.equalsIgnoreCase("abc", null)  = false
		 * StringUtils.equalsIgnoreCase("abc", "abc") = true
		 * StringUtils.equalsIgnoreCase("abc", "ABC") = true
		 * </pre>
		 *
		 * @param str1  the first String, may be null
		 * @param str2  the second String, may be null
		 * @return <code>true</code> if the Strings are equal, case insensitive, or
		 *  both <code>null</code>
		 */
		public static function equalsIgnoreCase(str1:String, str2:String):Boolean {
			if (str1 == null && str2 == null) {
				return true;
			} else if (str1 == null || str2 == null) {
				return false;
			}
			return equals(str1.toLowerCase(), str2.toLowerCase());
		}
		
		/**
		 * <p>Checks if the String contains only unicode letters.</p>
		 *
		 * <p><code>null</code> will return <code>false</code>.
		 * An empty String("") will return <code>true</code>.</p>
		 *
		 * <pre>
		 * StringUtils.isAlpha(null)   = false
		 * StringUtils.isAlpha("")     = true
		 * StringUtils.isAlpha("  ")   = false
		 * StringUtils.isAlpha("abc")  = true
		 * StringUtils.isAlpha("ab2c") = false
		 * StringUtils.isAlpha("ab-c") = false
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @return <code>true</code> if only contains letters, and is non-null
		 */
		public static function isAlpha(str:String):Boolean {
			return testString(str, /^[a-zA-Z]*$/);
		}
		
		/**
		 * <p>Checks if the String contains only unicode letters and
		 * space(' ').</p>
		 *
		 * <p><code>null</code> will return <code>false</code>
		 * An empty String("") will return <code>true</code>.</p>
		 *
		 * <pre>
		 * StringUtils.isAlphaSpace(null)   = false
		 * StringUtils.isAlphaSpace("")     = true
		 * StringUtils.isAlphaSpace("  ")   = true
		 * StringUtils.isAlphaSpace("abc")  = true
		 * StringUtils.isAlphaSpace("ab c") = true
		 * StringUtils.isAlphaSpace("ab2c") = false
		 * StringUtils.isAlphaSpace("ab-c") = false
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @return <code>true</code> if only contains letters and space,
		 *  and is non-null
		 */
		public static function isAlphaSpace(str:String):Boolean {
			return testString(str, /^[a-zA-Z\s]*$/);
		}
		
		/**
		 * <p>Checks if the String contains only unicode letters or digits.</p>
		 *
		 * <p><code>null</code> will return <code>false</code>.
		 * An empty String("") will return <code>true</code>.</p>
		 *
		 * <pre>
		 * StringUtils.isAlphanumeric(null)   = false
		 * StringUtils.isAlphanumeric("")     = true
		 * StringUtils.isAlphanumeric("  ")   = false
		 * StringUtils.isAlphanumeric("abc")  = true
		 * StringUtils.isAlphanumeric("ab c") = false
		 * StringUtils.isAlphanumeric("ab2c") = true
		 * StringUtils.isAlphanumeric("ab-c") = false
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @return <code>true</code> if only contains letters or digits,
		 *  and is non-null
		 */
		public static function isAlphanumeric(str:String):Boolean {
			return testString(str, /^[a-zA-Z0-9]*$/);
		}
		
		/**
		 * <p>Checks if the String contains only unicode letters, digits
		 * or space(<code>' '</code>).</p>
		 *
		 * <p><code>null</code> will return <code>false</code>.
		 * An empty String("") will return <code>true</code>.</p>
		 *
		 * <pre>
		 * StringUtils.isAlphanumericSpace(null)   = false
		 * StringUtils.isAlphanumericSpace("")     = true
		 * StringUtils.isAlphanumericSpace("  ")   = true
		 * StringUtils.isAlphanumericSpace("abc")  = true
		 * StringUtils.isAlphanumericSpace("ab c") = true
		 * StringUtils.isAlphanumericSpace("ab2c") = true
		 * StringUtils.isAlphanumericSpace("ab-c") = false
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @return <code>true</code> if only contains letters, digits or space,
		 *  and is non-null
		 */
		public static function isAlphanumericSpace(str:String):Boolean {
			return testString(str, /^[a-zA-Z0-9\s]*$/);
		}
		
		/**
		 * <p>Checks if the String contains only unicode digits.
		 * A decimal point is not a unicode digit and returns false.</p>
		 *
		 * <p><code>null</code> will return <code>false</code>.
		 * An empty String("") will return <code>true</code>.</p>
		 *
		 * <pre>
		 * StringUtils.isNumeric(null)   = false
		 * StringUtils.isNumeric("")     = true
		 * StringUtils.isNumeric("  ")   = false
		 * StringUtils.isNumeric("123")  = true
		 * StringUtils.isNumeric("12 3") = false
		 * StringUtils.isNumeric("ab2c") = false
		 * StringUtils.isNumeric("12-3") = false
		 * StringUtils.isNumeric("12.3") = false
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @return <code>true</code> if only contains digits, and is non-null
		 */
		public static function isNumeric(str:String):Boolean {
			return testString(str, /^[0-9]*$/);
		}
		
		/**
		 * <p>Checks if the String contains only unicode digits or space
		 *(<code>' '</code>).
		 * A decimal point is not a unicode digit and returns false.</p>
		 *
		 * <p><code>null</code> will return <code>false</code>.
		 * An empty String("") will return <code>true</code>.</p>
		 *
		 * <pre>
		 * StringUtils.isNumericSpace(null)   = false
		 * StringUtils.isNumericSpace("")     = true
		 * StringUtils.isNumericSpace("  ")   = true
		 * StringUtils.isNumericSpace("123")  = true
		 * StringUtils.isNumericSpace("12 3") = true
		 * StringUtils.isNumericSpace("ab2c") = false
		 * StringUtils.isNumericSpace("12-3") = false
		 * StringUtils.isNumericSpace("12.3") = false
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @return <code>true</code> if only contains digits or space,
		 *  and is non-null
		 */
		public static function isNumericSpace(str:String):Boolean {
			return testString(str, /^[0-9\s]*$/);
		}
		
		/**
		 * <p>Checks if the String contains only whitespace.</p>
		 *
		 * <p><code>null</code> will return <code>false</code>.
		 * An empty String("") will return <code>true</code>.</p>
		 *
		 * <pre>
		 * StringUtils.isWhitespace(null)   = false
		 * StringUtils.isWhitespace("")     = true
		 * StringUtils.isWhitespace("  ")   = true
		 * StringUtils.isWhitespace("abc")  = false
		 * StringUtils.isWhitespace("ab2c") = false
		 * StringUtils.isWhitespace("ab-c") = false
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @return <code>true</code> if only contains whitespace, and is non-null
		 */
		public static function isWhitespace(str:String):Boolean {
			return testString(str, /^[\s]*$/);
		}
		
		private static function testString(str:String, pattern:RegExp):Boolean {
			return str != null && pattern.test(str);
		}
		
		/**
		 * <p>Overlays part of a String with another String.</p>
		 *
		 * <p>A <code>null</code> string input returns <code>null</code>.
		 * A negative index is treated as zero.
		 * An index greater than the string length is treated as the string length.
		 * The start index is always the smaller of the two indices.</p>
		 *
		 * <pre>
		 * StringUtils.overlay(null, *, *, *)            = null
		 * StringUtils.overlay("", "abc", 0, 0)          = "abc"
		 * StringUtils.overlay("abcdef", null, 2, 4)     = "abef"
		 * StringUtils.overlay("abcdef", "", 2, 4)       = "abef"
		 * StringUtils.overlay("abcdef", "", 4, 2)       = "abef"
		 * StringUtils.overlay("abcdef", "zzzz", 2, 4)   = "abzzzzef"
		 * StringUtils.overlay("abcdef", "zzzz", 4, 2)   = "abzzzzef"
		 * StringUtils.overlay("abcdef", "zzzz", -1, 4)  = "zzzzef"
		 * StringUtils.overlay("abcdef", "zzzz", 2, 8)   = "abzzzz"
		 * StringUtils.overlay("abcdef", "zzzz", -2, -3) = "zzzzabcdef"
		 * StringUtils.overlay("abcdef", "zzzz", 8, 10)  = "abcdefzzzz"
		 * </pre>
		 *
		 * @param str  the String to do overlaying in, may be null
		 * @param overlay  the String to overlay, may be null
		 * @param start  the position to start overlaying at
		 * @param end  the position to stop overlaying before
		 * @return overlayed String, <code>null</code> if null String input
		 */
		public static function overlay(str:String, overlay:String, start:int, end:int):String {
			if (str == null) {
				return null;
			}
			
			if (overlay == null) {
				overlay = EMPTY;
			}
			var len:int = str.length;
			
			if (start < 0) {
				start = 0;
			}
			
			if (start > len) {
				start = len;
			}
			
			if (end < 0) {
				end = 0;
			}
			
			if (end > len) {
				end = len;
			}
			
			if (start > end) {
				var temp:int = start; // NO PMD WronglyNamedVariable
				start = end;
				end = temp;
			}
			return str.substring(0, start).concat(overlay).concat(str.substring(end));
		}
		
		/**
		 * <p>Removes all occurances of a substring from within the source string.</p>
		 *
		 * <p>A <code>null</code> source string will return <code>null</code>.
		 * An empty("") source string will return the empty string.
		 * A <code>null</code> remove string will return the source string.
		 * An empty("") remove string will return the source string.</p>
		 *
		 * <pre>
		 * StringUtils.remove(null, *)        = null
		 * StringUtils.remove("", *)          = ""
		 * StringUtils.remove(*, null)        = *
		 * StringUtils.remove(*, "")          = *
		 * StringUtils.remove("queued", "ue") = "qd"
		 * StringUtils.remove("queued", "zz") = "queued"
		 * </pre>
		 *
		 * @param str  the source String to search, may be null
		 * @param remove  the String to search for and remove, may be null
		 * @return the substring with the string removed if found,
		 *  <code>null</code> if null String input
		 */
		public static function remove(str:String, remove:String):String {
			return safeRemove(str, new RegExp(remove, 'g'));
		}
		
		/**
		 * <p>Removes a substring only if it is at the end of a source string,
		 * otherwise returns the source string.</p>
		 *
		 * <p>A <code>null</code> source string will return <code>null</code>.
		 * An empty("") source string will return the empty string.
		 * A <code>null</code> search string will return the source string.</p>
		 *
		 * <pre>
		 * StringUtils.removeEnd(null, *)      = null
		 * StringUtils.removeEnd("", *)        = ""
		 * StringUtils.removeEnd(*, null)      = *
		 * StringUtils.removeEnd("www.domain.com", ".com")   = "www.domain"
		 * StringUtils.removeEnd("www.domain.com", "domain") = "www.domain.com"
		 * StringUtils.removeEnd("abc", "")    = "abc"
		 * </pre>
		 *
		 * @param str  the source String to search, may be null
		 * @param remove  the String to search for and remove, may be null
		 * @return the substring with the string removed if found,
		 *  <code>null</code> if null String input
		 */
		public static function removeEnd(str:String, remove:String):String {
			return safeRemove(str, new RegExp(remove + '$', ''));
		}
		
		/**
		 * <p>Removes a substring only if it is at the begining of a source string,
		 * otherwise returns the source string.</p>
		 *
		 * <p>A <code>null</code> source string will return <code>null</code>.
		 * An empty("") source string will return the empty string.
		 * A <code>null</code> search string will return the source string.</p>
		 *
		 * <pre>
		 * StringUtils.removeStart(null, *)      = null
		 * StringUtils.removeStart("", *)        = ""
		 * StringUtils.removeStart(*, null)      = *
		 * StringUtils.removeStart("www.domain.com", "www.")   = "domain.com"
		 * StringUtils.removeStart("domain.com", "www.")       = "domain.com"
		 * StringUtils.removeStart("www.domain.com", "domain") = "www.domain.com"
		 * StringUtils.removeStart("abc", "")    = "abc"
		 * </pre>
		 *
		 * @param str  the source String to search, may be null
		 * @param remove  the String to search for and remove, may be null
		 * @return the substring with the string removed if found,
		 *  <code>null</code> if null String input
		 */
		public static function removeStart(str:String, remove:String):String {
			return safeRemove(str, new RegExp('^' + remove, ''));
		}
		
		private static function safeRemove(str:String, pattern:RegExp):String {
			if (isEmpty(str)) {
				return str;
			}
			return str.replace(pattern, '');
		}
		
		/**
		 * <p>Checks if the String end characters match the given end string.</p>
		 *
		 * <p><code>null</code> will return <code>false</code>.
		 *
		 * <pre>
		 * StringUtils.endsWith(null, *)	 				= false
		 * StringUtils.endsWith(null, null) 				= false
		 * StringUtils.endsWith(*, null)	   				= false
		 * StringUtils.endsWith("www.domain.com", "com") = true
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @param end the string to compare
		 * @return <code>true</code> if only contains whitespace, and is non-null
		 */
		public static function endsWith(str:String, end:String):Boolean {
			return testString(str, new RegExp(end + '$', ''));
		}
		
		/**
		 * <p>Checks if the String start characters match the given start string.</p>
		 *
		 * <p><code>null</code> will return <code>false</code>.
		 *
		 * <pre>
		 * StringUtils.startsWith(null, *)	 				= false
		 * StringUtils.startsWith(null, null) 				= false
		 * StringUtils.startsWith(*, null)	   				= false
		 * StringUtils.startsWith("www.domain.com", "www.")	= true
		 * </pre>
		 *
		 * @param str  the String to check, may be null
		 * @param start the string to compare
		 * @return <code>true</code> if only contains whitespace, and is non-null
		 */
		public static function startsWith(str:String, start:String):Boolean {
			return testString(str, new RegExp('^' + start, ''));
		}
		
		/**
		 * Compares two strings lexicographically, ignoring case
		 * differences. This method returns an integer whose sign is that of
		 * calling <code>compareTo</code> with normalized versions of the strings
		 * where case differences have been eliminated by calling
		 * <code>Character.toLowerCase(Character.toUpperCase(character))</code> on
		 * each character.
		 * <p>
		 *
		 * @param   str1   the <code>String</code> to be compared.
		 * @param   str2   the <code>String</code> to be compared.
		 * @return  a negative integer, zero, or a positive integer as the
		 *		specified String is greater than, equal to, or less
		 *		than this String, ignoring case considerations.
		 */
		public static function compareToIgnoreCase(str1:String, str2:String):int {
			if (str1 == null) {
				str1 = "";
			}
			
			if (str2 == null) {
				str2 = "";
			}
			
			return compareTo(str1.toLowerCase(), str2.toLowerCase());
		}
		
		/**
		 * Compares two strings lexicographically.
		 * The comparison is based on the Unicode value of each character in
		 * the strings. The character sequence represented by this
		 * <code>String</code> object is compared lexicographically to the
		 * character sequence represented by the argument string. The result is
		 * a negative integer if this <code>String</code> object
		 * lexicographically precedes the argument string. The result is a
		 * positive integer if this <code>String</code> object lexicographically
		 * follows the argument string. The result is zero if the strings
		 * are equal; <code>compareTo</code> returns <code>0</code> exactly when
		 * the #equals(Object) method would return <code>true</code>.
		 * <p>
		 * This is the definition of lexicographic ordering. If two strings are
		 * different, then either they have different characters at some index
		 * that is a valid index for both strings, or their lengths are different,
		 * or both. If they have different characters at one or more index
		 * positions, let <i>k</i> be the smallest such index; then the string
		 * whose character at position <i>k</i> has the smaller value, as
		 * determined by using the &lt; operator, lexicographically precedes the
		 * other string. In this case, <code>compareTo</code> returns the
		 * difference of the two character values at position <code>k</code> in
		 * the two string -- that is, the value:
		 * <blockquote><pre>
		 * this.charAt(k)-anotherString.charAt(k)
		 * </pre></blockquote>
		 * If there is no index position at which they differ, then the shorter
		 * string lexicographically precedes the longer string. In this case,
		 * <code>compareTo</code> returns the difference of the lengths of the
		 * strings -- that is, the value:
		 * <blockquote><pre>
		 * this.length-anotherString.length
		 * </pre></blockquote>
		 *
		 * @param   anotherString   the <code>String</code> to be compared.
		 * @return  the value <code>0</code> if the argument string is equal to
		 *          this string; a value less than <code>0</code> if this string
		 *          is lexicographically less than the string argument; and a
		 *          value greater than <code>0</code> if this string is
		 *          lexicographically greater than the string argument.
		 */
		public static function compareTo(str1:String, str2:String):int {
			if (str1 == null) {
				str1 = "";
			}
			
			if (str2 == null) {
				str2 = "";
			}
			return str1.localeCompare(str2);
		}
		
		/**
		 * Adds/inserts a new string at a certain position in the source string.
		 */
		public static function addAt(string:String, value:*, position:int):String {
			if (position > string.length) {
				position = string.length;
			}
			var firstPart:String = string.substring(0, position);
			var secondPart:String = string.substring(position, string.length);
			return (firstPart + value + secondPart);
		}
		
		/**
		 * Replaces a part of the text between 2 positions.
		 */
		public static function replaceAt(string:String, value:*, beginIndex:int, endIndex:int):String {
			beginIndex = Math.max(beginIndex, 0);
			endIndex = Math.min(endIndex, string.length);
			var firstPart:String = string.substr(0, beginIndex);
			var secondPart:String = string.substr(endIndex, string.length);
			return (firstPart + value + secondPart);
		}
		
		/**
		 * Removes a part of the text between 2 positions.
		 */
		public static function removeAt(string:String, beginIndex:int, endIndex:int):String {
			return StringUtils.replaceAt(string, "", beginIndex, endIndex);
		}
		
		/**
		 * Fixes double newlines in a text.
		 */
		public static function fixNewlines(string:String):String {
			return string.replace(/\r\n/gm, "\n");
		}
		
		/**
		 * Checks if the given string has actual text.
		 */
		public static function hasText(string:String):Boolean {
			if (!string)
				return false;
			return (StringUtils.trim(string).length > 0);
		}
		
		/**
		 * Removes all empty characters at the beginning of a string.
		 *
		 * <p>Characters that are removed: spaces {@code " "}, line forwards {@code "\n"}
		 * and extended line forwarding {@code "\t\n"}.
		 *
		 * @param string the string to trim
		 * @return the trimmed string
		 */
		public static function leftTrim(string:String):String {
			return leftTrimForChars(string, "\n\t\n ");
		}
		
		/**
		 * Removes all empty characters at the end of a string.
		 *
		 * <p>Characters that are removed: spaces {@code " "}, line forwards {@code "\n"}
		 * and extended line forwarding {@code "\t\n"}.
		 *
		 * @param string the string to trim
		 * @return the trimmed string
		 */
		public static function rightTrim(string:String):String {
			return rightTrimForChars(string, "\n\t\n ");
		}
		
		/**
		 * Removes all characters at the beginning of the {@code string} that match to the
		 * set of {@code chars}.
		 *
		 * <p>This method splits all {@code chars} and removes occurencies at the beginning.
		 *
		 * <p>Example:
		 * <code>
		 *   trace(StringUtil.rightTrimForChars("ymoynkeym", "ym")); // oynkeym
		 *   trace(StringUtil.rightTrimForChars("monkey", "mo")); // nkey
		 *   trace(StringUtil.rightTrimForChars("monkey", "om")); // nkey
		 * </code>
		 *
		 * @param string the string to trim
		 * @param chars the characters to remove from the beginning of the {@code string}
		 * @return the trimmed string
		 */
		public static function leftTrimForChars(string:String, chars:String):String {
			var from:Number = 0;
			var endIndex:Number = string.length;
			
			while (from < endIndex && chars.indexOf(string.charAt(from)) >= 0) {
				from++;
			}
			return (from > 0 ? string.substr(from, endIndex) : string);
		}
		
		/**
		 * Removes all characters at the end of the {@code string} that match to the set of
		 * {@code chars}.
		 *
		 * <p>This method splits all {@code chars} and removes occurencies at the end.
		 *
		 * <p>Example:
		 * <code>
		 *   trace(StringUtil.rightTrimForChars("ymoynkeym", "ym")); // ymoynke
		 *   trace(StringUtil.rightTrimForChars("monkey***", "*y")); // monke
		 *   trace(StringUtil.rightTrimForChars("monke*y**", "*y")); // monke
		 * </code>
		 *
		 * @param string the string to trim
		 * @param chars the characters to remove from the end of the {@code string}
		 * @return the trimmed string
		 */
		public static function rightTrimForChars(string:String, chars:String):String {
			var from:Number = 0;
			var endIndex:Number = string.length - 1;
			
			while (from < endIndex && chars.indexOf(string.charAt(endIndex)) >= 0) {
				endIndex--;
			}
			return (endIndex >= 0 ? string.substr(from, endIndex + 1) : string);
		}
		
		/**
		 * Removes all characters at the beginning of the {@code string} that matches the
		 * {@code char}.
		 *
		 * <p>Example:
		 * <code>
		 *   trace(StringUtil.leftTrimForChar("yyyymonkeyyyy", "y"); // monkeyyyy
		 * </code>
		 *
		 * @param string the string to trim
		 * @param char the character to remove
		 * @return the trimmed string
		 * @throws IllegalArgumentException if you try to remove more than one character
		 */
		public static function leftTrimForChar(string:String, char:String):String {
			if (char.length != 1) {
				throw new IllegalArgumentError("The Second Attribute char [" + char + "] must exactly one character.");
			}
			return leftTrimForChars(string, char);
		}
		
		/**
		 * Removes all characters at the end of the {@code string} that matches the passed-in
		 * {@code char}.
		 *
		 * <p>Example:
		 * <code>
		 *   trace(StringUtil.rightTrimForChar("yyyymonkeyyyy", "y"); // yyyymonke
		 * </code>
		 *
		 * @param string the string to trim
		 * @param char the character to remove
		 * @return the trimmed string
		 * @throws IllegalArgumentException if you try to remove more than one character
		 */
		public static function rightTrimForChar(string:String, char:String):String {
			if (char.length != 1) {
				throw new IllegalArgumentError("The Second Attribute char [" + char + "] must exactly one character.");
			}
			return rightTrimForChars(string, char);
		}
		
		/**
		 * Extended String::indexOf
		 *
		 * @param haystack string to search in
		 * @param n which ocurance of needle
		 * @param needle The substring for which to search
		 * @param startIndex An optional integer specifying the starting index of the search.
		 * @returns startIndex if n is 0
		 * @returns -1 if not enough ocurances of needle are found
		 * @returns charIndex of nth needle ocurances
		 */
		public static function nthIndexOf(haystack:String, n:uint, needle:String, startIndex:Number = 0):int {
			var result:int = startIndex;
			
			if (n >= 1) {
				result = haystack.indexOf(needle, result);
				
				for (var i:int = 1; result != -1 && i < n; i++) {
					result = haystack.indexOf(needle, result + 1);
				}
			}
			return result;
		}
		
		/**
		 * Returns if the given character is a white space or not.
		 */
		public static function characterIsWhitespace(a:String):Boolean {
			return (a.charCodeAt(0) <= 32);
		}
		
		/**
		 * Returns if the given character is a digit or not.
		 */
		public static function characterIsDigit(a:String):Boolean {
			var charCode:Number = a.charCodeAt(0);
			return (charCode >= 48 && charCode <= 57);
		}
		
		/**
		 * Natural sort order compare function.
		 *
		 * @ignore Based on the JavaScript version by Kristof Coomans.
		 * (http://sourcefrog.net/projects/natsort/natcompare.js)
		 */
		public static function naturalCompare(a:String, b:String):int { // NO PMD TooLongFunction
			var iaa:int = 0, ibb:int = 0;
			var nza:int = 0, nzb:int = 0;
			var caa:String, cbb:String;
			var result:int;
			var lowerCaseBeforeUpperCase:Boolean = true; // used to be a method argument, keep this
			
			// replace null values with empty strings
			if (!a)
				a = "";
			
			if (!b)
				b = "";
			
			/*if (!caseSensitive) {
			a = a.toLowerCase();
			b = b.toLowerCase();
			}*/
			
			var stringsAreCaseInsensitiveEqual:Boolean = false;
			
			if (a.toLocaleLowerCase() == b.toLocaleLowerCase()) {
				stringsAreCaseInsensitiveEqual = true;
			} else {
				a = a.toLowerCase();
				b = b.toLowerCase();
			}
			
			while (true) {
				// only count the number of zeroes leading the last number compared
				nza = nzb = 0;
				
				caa = a.charAt(iaa);
				cbb = b.charAt(ibb);
				
				// skip over leading spaces or zeros
				while (StringUtils.characterIsWhitespace(caa) || caa == "0") {
					if (caa == "0") {
						nza++;
					} else {
						// only count consecutive zeroes
						nza = 0;
					}
					
					caa = a.charAt(++iaa);
				}
				
				while (StringUtils.characterIsWhitespace(cbb) || cbb == "0") {
					if (cbb == "0") {
						nzb++;
					} else {
						// only count consecutive zeroes
						nzb = 0;
					}
					
					cbb = b.charAt(++ibb);
				}
				
				// process run of digits
				if (StringUtils.characterIsDigit(caa) && StringUtils.characterIsDigit(cbb)) {
					if ((result = compareRight(a.substring(iaa), b.substring(ibb))) != 0) {
						return result;
					}
				}
				
				if (caa == "" && cbb == "") {
					// The strings compare the same.  Perhaps the caller
					// will want to call strcmp to break the tie.
					return nza - nzb;
				}
				
				if (stringsAreCaseInsensitiveEqual) {
					// If the characters are in another case (upper or lower)
					if (caa != cbb) {
						if (caa < cbb) { // NO PMD DeeplyNestedIf
							return lowerCaseBeforeUpperCase ? +1 : -1;
						} else if (caa > cbb) {
							return lowerCaseBeforeUpperCase ? -1 : +1;
						}
					}
				}
				
				if (caa < cbb) {
					return -1;
				} else if (caa > cbb) {
					return +1;
				}
				
				++iaa;
				++ibb;
			}
			
			return 0;
		}
		
		/**
		 * Helper function used by the naturalCompare method.
		 */
		private static function compareRight(a:String, b:String):int {
			var bias:int = 0;
			var iaa:int = 0;
			var ibb:int = 0;
			var caa:String;
			var cbb:String;
			
			// The longest run of digits wins.  That aside, the greatest
			// value wins, but we can't know that it will until we've scanned
			// both numbers to know that they have the same magnitude, so we
			// remember it in BIAS.
			for (; ; iaa++, ibb++) {
				caa = a.charAt(iaa);
				cbb = b.charAt(ibb);
				
				if (!StringUtils.characterIsDigit(caa) && !StringUtils.characterIsDigit(cbb)) {
					return bias;
				} else if (!StringUtils.characterIsDigit(caa)) {
					return -1;
				} else if (!StringUtils.characterIsDigit(cbb)) {
					return +1;
				} else if (caa < cbb) {
					if (bias == 0) {
						bias = -1;
					}
				} else if (caa > cbb) {
					if (bias == 0)
						bias = +1;
				} else if (caa == "" && cbb == "") {
					return bias;
				}
			}
			
			return 0;
		}
		
		/**
		 * Tokenizes a string to an array using the given delimiters.
		 */
		public static function tokenizeToArray(string:String, delimiters:String):Array {
			var result:Array = [];
			var numCharacters:int = string.length;
			var delimiterFound:Boolean = false; // NO PMD UnusedLocalVariable
			var token:String = "";
			
			for (var i:int = 0; i < numCharacters; i++) {
				var character:String = string.charAt(i);
				
				if (delimiters.indexOf(character) == -1) {
					token += character;
				} else {
					result.push(token);
					token = "";
				}
				
				// add the last token if we reached the end of the string
				if (i == numCharacters - 1) {
					result.push(token);
				}
			}
			
			return result;
		}
	}
}