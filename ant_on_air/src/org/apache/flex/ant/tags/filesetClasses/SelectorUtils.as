/*
*  Licensed to the Apache Software Foundation (ASF) under one or more
*  contributor license agreements.  See the NOTICE file distributed with
*  this work for additional information regarding copyright ownership.
*  The ASF licenses this file to You under the Apache License, Version 2.0
*  (the "License"); you may not use this file except in compliance with
*  the License.  You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
*  Unless required by applicable law or agreed to in writing, software
*  distributed under the License is distributed on an "AS IS" BASIS,
*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*  See the License for the specific language governing permissions and
*  limitations under the License.
*
*/

package org.apache.flex.ant.tags.filesetClasses
{
    import flash.filesystem.File;
    
    /**
     * Ported from org.apache.tools.ant.types.selectors.SelectorUtils.java on 12/03/13.
     * <p>This is a utility class used by selectors and DirectoryScanner. The
     * functionality more properly belongs just to selectors, but unfortunately
     * DirectoryScanner exposed these as protected methods. Thus we have to
     * support any subclasses of DirectoryScanner that may access these methods.
     * </p>
     * <p>This is a Singleton.</p>
     *
     * @since 1.5
     */
    public final class SelectorUtils 
    {
        
        /**
         * The pattern that matches an arbitrary number of directories.
         * @since Ant 1.8.0
         */
        public static const DEEP_TREE_MATCH:String = "**";
        
        private static const instance:SelectorUtils = new SelectorUtils();
        private static const FILE_UTILS:FileUtils = FileUtils.getFileUtils();
        
        /**
         * Private Constructor
         */
        public function SelectorUtils() {
        }
        
        /**
         * Retrieves the instance of the Singleton.
         * @return singleton instance
         */
        public static function getInstance():SelectorUtils {
            return instance;
        }
        
        /**
         * Tests whether or not a given path matches the start of a given
         * pattern up to the first "**".
         * <p>
         * This is not a general purpose test and should only be used if you
         * can live with false positives. For example, <code>pattern=**\a</code>
         * and <code>str=b</code> will yield <code>true</code>.
         *
         * @param pattern The pattern to match against. Must not be
         *                <code>null</code>.
         * @param str     The path to match, as a String. Must not be
         *                <code>null</code>.
         * @param isCaseSensitive Whether or not matching should be performed
         *                        case sensitively.
         *
         * @return whether or not a given path matches the start of a given
         * pattern up to the first "**".
         */
        public static function matchPatternStart(pattern:String, str:String,
            isCaseSensitive:Boolean = true):Boolean  
        {
                // When str starts with a File.separator, pattern has to start with a
                // File.separator.
                // When pattern starts with a File.separator, str has to start with a
                // File.separator.
                if (str.indexOf(File.separator) == 0
                    != pattern.indexOf(File.separator) == 0) {
                    return false;
                }
                
                var patDirs:Vector.<String> = tokenizePathAsArray(pattern);
                var strDirs:Vector.<String> = tokenizePathAsArray(str);
                return matchPatternStartVectors(patDirs, strDirs, isCaseSensitive);
            }
        
        
        /**
         * Tests whether or not a given path matches the start of a given
         * pattern up to the first "**".
         * <p>
         * This is not a general purpose test and should only be used if you
         * can live with false positives. For example, <code>pattern=**\a</code>
         * and <code>str=b</code> will yield <code>true</code>.
         *
         * @param patDirs The tokenized pattern to match against. Must not be
         *                <code>null</code>.
         * @param strDirs The tokenized path to match. Must not be
         *                <code>null</code>.
         * @param isCaseSensitive Whether or not matching should be performed
         *                        case sensitively.
         *
         * @return whether or not a given path matches the start of a given
         * pattern up to the first "**".
         */
        public static function matchPatternStartVectors(patDirs:Vector.<String>, 
            strDirs:Vector.<String>,
            isCaseSensitive:Boolean):Boolean {
                var patIdxStart:int = 0;
                var patIdxEnd:int = patDirs.length - 1;
                var strIdxStart:int = 0;
                var strIdxEnd:int = strDirs.length - 1;
                
                // up to first '**'
                while (patIdxStart <= patIdxEnd && strIdxStart <= strIdxEnd) {
                    var patDir:String = patDirs[patIdxStart];
                    if (patDir == DEEP_TREE_MATCH) {
                        break;
                    }
                    if (!match(patDir, strDirs[strIdxStart], isCaseSensitive)) {
                        return false;
                    }
                    patIdxStart++;
                    strIdxStart++;
                }
                
                // CheckStyle:SimplifyBooleanReturnCheck OFF
                // Check turned off as the code needs the comments for the various
                // code paths.
                if (strIdxStart > strIdxEnd) {
                    // String is exhausted
                    return true;
                } else if (patIdxStart > patIdxEnd) {
                    // String not exhausted, but pattern is. Failure.
                    return false;
                } else {
                    // pattern now holds ** while string is not exhausted
                    // this will generate false positives but we can live with that.
                    return true;
                }
            }
        
        /**
         * Tests whether or not a given path matches a given pattern.
         *
         * If you need to call this method multiple times with the same
         * pattern you should rather use TokenizedPattern
         *
         * @see TokenizedPattern
         *
         * @param pattern The pattern to match against. Must not be
         *                <code>null</code>.
         * @param str     The path to match, as a String. Must not be
         *                <code>null</code>.
         * @param isCaseSensitive Whether or not matching should be performed
         *                        case sensitively.
         *
         * @return <code>true</code> if the pattern matches against the string,
         *         or <code>false</code> otherwise.
         */
        public static function matchPath(pattern:String, str:String,
            isCaseSensitive:Boolean = true):Boolean
        {
            var patDirs:Vector.<String> = tokenizePathAsArray(pattern);
            return matchPathVectors(patDirs, tokenizePathAsArray(str), isCaseSensitive);
        }
        
        /**
         * Core implementation of matchPath.  It is isolated so that it
         * can be called from TokenizedPattern.
         */
        public static function matchPathVectors(tokenizedPattern:Vector.<String>, 
            strDirs:Vector.<String>,
            isCaseSensitive:Boolean):Boolean 
        {
                var patIdxStart:int = 0;
                var patIdxEnd:int = tokenizedPattern.length - 1;
                var strIdxStart:int = 0;
                var strIdxEnd:int = strDirs.length - 1;
                
                // up to first '**'
                while (patIdxStart <= patIdxEnd && strIdxStart <= strIdxEnd) {
                    var patDir:String = tokenizedPattern[patIdxStart];
                    if (patDir == DEEP_TREE_MATCH) {
                        break;
                    }
                    if (!match(patDir, strDirs[strIdxStart], isCaseSensitive)) {
                        return false;
                    }
                    patIdxStart++;
                    strIdxStart++;
                }
                if (strIdxStart > strIdxEnd) {
                    // String is exhausted
                    for (i = patIdxStart; i <= patIdxEnd; i++) {
                        if (tokenizedPattern[i] != DEEP_TREE_MATCH) {
                            return false;
                        }
                    }
                    return true;
                } else {
                    if (patIdxStart > patIdxEnd) {
                        // String not exhausted, but pattern is. Failure.
                        return false;
                    }
                }
                
                // up to last '**'
                while (patIdxStart <= patIdxEnd && strIdxStart <= strIdxEnd) {
                    patDir = tokenizedPattern[patIdxEnd];
                    if (patDir == DEEP_TREE_MATCH) {
                        break;
                    }
                    if (!match(patDir, strDirs[strIdxEnd], isCaseSensitive)) {
                        return false;
                    }
                    patIdxEnd--;
                    strIdxEnd--;
                }
                if (strIdxStart > strIdxEnd) {
                    // String is exhausted
                    for (i = patIdxStart; i <= patIdxEnd; i++) {
                        if (!tokenizedPattern[i] == DEEP_TREE_MATCH) {
                            return false;
                        }
                    }
                    return true;
                }
                
                while (patIdxStart != patIdxEnd && strIdxStart <= strIdxEnd) {
                    var patIdxTmp:int = -1;
                    for (i = patIdxStart + 1; i <= patIdxEnd; i++) {
                        if (tokenizedPattern[i] ==  DEEP_TREE_MATCH) {
                            patIdxTmp = i;
                            break;
                        }
                    }
                    if (patIdxTmp == patIdxStart + 1) {
                        // '**/**' situation, so skip one
                        patIdxStart++;
                        continue;
                    }
                    // Find the pattern between padIdxStart & padIdxTmp in str between
                    // strIdxStart & strIdxEnd
                    var patLength:int = (patIdxTmp - patIdxStart - 1);
                    var strLength:int = (strIdxEnd - strIdxStart + 1);
                    var foundIdx:int = -1;
                    strLoop:
                    for (i = 0; i <= strLength - patLength; i++) {
                        for (var j:int = 0; j < patLength; j++) {
                            var subPat:String = tokenizedPattern[patIdxStart + j + 1];
                            var subStr:String = strDirs[strIdxStart + i + j];
                            if (!match(subPat, subStr, isCaseSensitive)) {
                                continue strLoop;
                            }
                        }
                        
                        foundIdx = strIdxStart + i;
                        break;
                    }
                    
                    if (foundIdx == -1) {
                        return false;
                    }
                    
                    patIdxStart = patIdxTmp;
                    strIdxStart = foundIdx + patLength;
                }
                
                for (var i:int = patIdxStart; i <= patIdxEnd; i++) {
                    if (!tokenizedPattern[i] == DEEP_TREE_MATCH) {
                        return false;
                    }
                }
                
                return true;
            }
        
        /**
         * Tests whether or not a string matches against a pattern.
         * The pattern may contain two special characters:<br>
         * '*' means zero or more characters<br>
         * '?' means one and only one character
         *
         * @param pattern The pattern to match against.
         *                Must not be <code>null</code>.
         * @param str     The string which must be matched against the pattern.
         *                Must not be <code>null</code>.
         * @param caseSensitive Whether or not matching should be performed
         *                        case sensitively.
         *
         *
         * @return <code>true</code> if the string matches against the pattern,
         *         or <code>false</code> otherwise.
         */
        public static function match(pattern:String, str:String,
            caseSensitive:Boolean = true):Boolean 
        {
                var patArr:Vector.<String> = Vector.<String>(pattern.split(""));
                var strArr:Vector.<String> = Vector.<String>(str.split(""));
                var patIdxStart:int = 0;
                var patIdxEnd:int = patArr.length - 1;
                var strIdxStart:int = 0;
                var strIdxEnd:int = strArr.length - 1;
                var ch:String;
                
                var containsStar:Boolean = false;
                for (var i:int = 0; i < patArr.length; i++) {
                    if (patArr[i] == '*') {
                        containsStar = true;
                        break;
                    }
                }
                
                if (!containsStar) {
                    // No '*'s, so we make a shortcut
                    if (patIdxEnd != strIdxEnd) {
                        return false; // Pattern and string do not have the same size
                    }
                    for (i = 0; i <= patIdxEnd; i++) {
                        ch = patArr[i];
                        if (ch != '?') {
                            if (different(caseSensitive, ch, strArr[i])) {
                                return false; // Character mismatch
                            }
                        }
                    }
                    return true; // String matches against pattern
                }
                
                if (patIdxEnd == 0) {
                    return true; // Pattern contains only '*', which matches anything
                }
                
                // Process characters before first star
                while (true) {
                    ch = patArr[patIdxStart];
                    if (ch == '*' || strIdxStart > strIdxEnd) {
                        break;
                    }
                    if (ch != '?') {
                        if (different(caseSensitive, ch, strArr[strIdxStart])) {
                            return false; // Character mismatch
                        }
                    }
                    patIdxStart++;
                    strIdxStart++;
                }
                if (strIdxStart > strIdxEnd) {
                    // All characters in the string are used. Check if only '*'s are
                    // left in the pattern. If so, we succeeded. Otherwise failure.
                    return allStars(patArr, patIdxStart, patIdxEnd);
                }
                
                // Process characters after last star
                while (true) {
                    ch = patArr[patIdxEnd];
                    if (ch == '*' || strIdxStart > strIdxEnd) {
                        break;
                    }
                    if (ch != '?') {
                        if (different(caseSensitive, ch, strArr[strIdxEnd])) {
                            return false; // Character mismatch
                        }
                    }
                    patIdxEnd--;
                    strIdxEnd--;
                }
                if (strIdxStart > strIdxEnd) {
                    // All characters in the string are used. Check if only '*'s are
                    // left in the pattern. If so, we succeeded. Otherwise failure.
                    return allStars(patArr, patIdxStart, patIdxEnd);
                }
                
                // process pattern between stars. padIdxStart and patIdxEnd point
                // always to a '*'.
                while (patIdxStart != patIdxEnd && strIdxStart <= strIdxEnd) {
                    var patIdxTmp:int = -1;
                    for (i = patIdxStart + 1; i <= patIdxEnd; i++) {
                        if (patArr[i] == '*') {
                            patIdxTmp = i;
                            break;
                        }
                    }
                    if (patIdxTmp == patIdxStart + 1) {
                        // Two stars next to each other, skip the first one.
                        patIdxStart++;
                        continue;
                    }
                    // Find the pattern between padIdxStart & padIdxTmp in str between
                    // strIdxStart & strIdxEnd
                    var patLength:int = (patIdxTmp - patIdxStart - 1);
                    var strLength:int = (strIdxEnd - strIdxStart + 1);
                    var foundIdx:int = -1;
                    strLoop:
                    for (i  = 0; i <= strLength - patLength; i++) {
                        for (var j:int = 0; j < patLength; j++) {
                            ch = patArr[patIdxStart + j + 1];
                            if (ch != '?') {
                                if (different(caseSensitive, ch,
                                    strArr[strIdxStart + i + j])) {
                                    continue strLoop;
                                }
                            }
                        }
                        
                        foundIdx = strIdxStart + i;
                        break;
                    }
                    
                    if (foundIdx == -1) {
                        return false;
                    }
                    
                    patIdxStart = patIdxTmp;
                    strIdxStart = foundIdx + patLength;
                }
                
                // All characters in the string are used. Check if only '*'s are left
                // in the pattern. If so, we succeeded. Otherwise failure.
                return allStars(patArr, patIdxStart, patIdxEnd);
            }
        
        private static function allStars(chars:Vector.<String>, start:int, end:int):Boolean 
        {
            for (var i:int = start; i <= end; ++i) {
                if (chars[i] != '*') {
                    return false;
                }
            }
            return true;
        }
        
        private static function different(
            caseSensitive:Boolean, ch:String, other:String):Boolean 
        {
                return caseSensitive
                ? ch != other
                    : ch.toUpperCase() != other.toUpperCase();
        }
                    
            /**
             * Breaks a path up into a Vector of path elements, tokenizing on
             *
             * @param path Path to tokenize. Must not be <code>null</code>.
             * @param separator the separator against which to tokenize.
             *
             * @return a Vector of path elements from the tokenized path
             * @since Ant 1.6
             */
            public static function tokenizePath(path:String, 
                         separator:String = null):Vector.<String>  
            {
                if (separator == null)
                    separator = File.separator;
                
                var ret:Vector.<String> = new Vector.<String>();
                if (FileUtils.isAbsolutePath(path)) {
                    var s:Vector.<String> = FILE_UTILS.dissect(path);
                    ret.push(s[0]);
                    path = s[1];
                }
                var st:StringTokenizer = new StringTokenizer(path, separator);
                while (st.hasMoreTokens()) {
                    ret.push(st.nextToken());
                }
                return ret;
            }
                
                /**
                 * Same as {@link #tokenizePath tokenizePath} but hopefully faster.
                 */
                /*package*/public static function tokenizePathAsArray(path:String):Vector.<String> 
                {
                    var root:String = null;
                    if (FileUtils.isAbsolutePath(path)) {
                        var s:Vector.<String> = FILE_UTILS.dissect(path);
                        root = s[0];
                        path = s[1];
                    }
                    var sep:String = File.separator;
                    var start:int = 0;
                    var len:int = path.length;
                    var count:int = 0;
                    for (var pos:int = 0; pos < len; pos++) {
                        if (path.charAt(pos) == sep) {
                            if (pos != start) {
                                count++;
                            }
                            start = pos + 1;
                        }
                    }
                    if (len != start) {
                        count++;
                    }
                    var l:Vector.<String> = Vector.<String>(new Array(count + ((root == null) ? 0 : 1)));
                    
                    if (root != null) {
                        l[0] = root;
                        count = 1;
                    } else {
                        count = 0;
                    }
                    start = 0;
                    for (pos = 0; pos < len; pos++) {
                        if (path.charAt(pos) == sep) {
                            if (pos != start) {
                                var tok:String = path.substring(start, pos);
                                l[count++] = tok;
                            }
                            start = pos + 1;
                        }
                    }
                    if (len != start) {
                        tok = path.substring(start);
                        l[count/*++*/] = tok;
                    }
                    return l;
                }
        
        /**
         * Returns dependency information on these two files. If src has been
         * modified later than target, it returns true. If target doesn't exist,
         * it likewise returns true. Otherwise, target is newer than src and
         * is not out of date, thus the method returns false. It also returns
         * false if the src file doesn't even exist, since how could the
         * target then be out of date.
         *
         * @param src the original file
         * @param target the file being compared against
         * @param granularity the amount in seconds of slack we will give in
         *        determining out of dateness
         * @return whether the target is out of date
         */
        private static function isOutOfDateFile(src:File, target:File, granularity:int):Boolean {
            if (!src.exists) {
                return false;
            }
            if (!target.exists) {
                return true;
            }
            if ((src.modificationDate.time - granularity) > target.modificationDate.time) {
                return true;
            }
            return false;
        }
        
        /**
         * Returns dependency information on these two resources. If src has been
         * modified later than target, it returns true. If target doesn't exist,
         * it likewise returns true. Otherwise, target is newer than src and
         * is not out of date, thus the method returns false. It also returns
         * false if the src file doesn't even exist, since how could the
         * target then be out of date.
         *
         * @param src the original resource
         * @param target the resource being compared against
         * @param granularity the int amount in seconds of slack we will give in
         *        determining out of dateness
         * @return whether the target is out of date
         */
        public static function isOutOfDate(src:Object, target:Object,
            granularity:int):Boolean {
                if (src is File)
                    return isOutOfDateFile(src as File, target as File, granularity);
                return isOutOfDateResource(src as Resource, target as Resource, granularity);
            }
        
        /**
         * Returns dependency information on these two resources. If src has been
         * modified later than target, it returns true. If target doesn't exist,
         * it likewise returns true. Otherwise, target is newer than src and
         * is not out of date, thus the method returns false. It also returns
         * false if the src file doesn't even exist, since how could the
         * target then be out of date.
         *
         * @param src the original resource
         * @param target the resource being compared against
         * @param granularity the long amount in seconds of slack we will give in
         *        determining out of dateness
         * @return whether the target is out of date
         */
        private static function isOutOfDateResource(src:Resource, target:Resource,
                                           granularity:int):Boolean {
            var sourceLastModified:Number = src.getLastModified();
            var targetLastModified:Number = target.getLastModified();
            return src.isExists()
                && (sourceLastModified == Resource.UNKNOWN_DATETIME
                    || targetLastModified == Resource.UNKNOWN_DATETIME
                    || (sourceLastModified - granularity) > targetLastModified);
        }
        
        /**
         * "Flattens" a string by removing all whitespace (space, tab, linefeed,
         * carriage return, and formfeed). This uses StringTokenizer and the
         * default set of tokens as documented in the single argument constructor.
         *
         * @param input a String to remove all whitespace.
         * @return a String that has had all whitespace removed.
         */
        public static function removeWhitespace(input:String):String {
            var result:String = "";
            if (input != null) {
                var st:StringTokenizer = new StringTokenizer(input);
                while (st.hasMoreTokens()) {
                    result += st.nextToken();
                }
            }
            return result;
        }
        
        /**
         * Tests if a string contains stars or question marks
         * @param input a String which one wants to test for containing wildcard
         * @return true if the string contains at least a star or a question mark
         */
        public static function hasWildcards(input:String):Boolean {
            return (input.indexOf('*') != -1 || input.indexOf('?') != -1);
        }
        
        /**
         * removes from a pattern all tokens to the right containing wildcards
         * @param input the input string
         * @return the leftmost part of the pattern without wildcards
         */
        public static function rtrimWildcardTokens(input:String):String {
            return new TokenizedPattern(input).rtrimWildcardTokens().toString();
        }
    }
}
