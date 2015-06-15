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
    import org.apache.flex.ant.tags.filesetClasses.exceptions.IllegalStateException;
    
    /**
     * Ported from org.apache.tools.ant.types.selector.TokenizedPattern.java on 12/3/13. 
     * Provides reusable path pattern matching.  PathPattern is preferable
     * to equivalent SelectorUtils methods if you need to execute multiple
     * matching with the same pattern because here the pattern itself will
     * be parsed only once.
     * @see SelectorUtils#matchPath(String, String)
     * @see SelectorUtils#matchPath(String, String, boolean)
     * @since 1.8.0
     */
    public class TokenizedPattern {
        
        /**
         * Instance that holds no tokens at all.
         */
        public static const EMPTY_PATTERN:TokenizedPattern =
            new TokenizedPattern("").init("", new Vector.<String>());
        
        private var pattern:String;
        private var tokenizedPattern:Vector.<String>;
        
        /**
         * Initialize the PathPattern by parsing it.
         * @param pattern The pattern to match against. Must not be
         *                <code>null</code>.
         */
        public function TokenizedPattern(pattern:String) {
            init(pattern, SelectorUtils.tokenizePathAsArray(pattern));
        }
        
        public function init(pattern:String, tokens:Vector.<String>):TokenizedPattern {
            this.pattern = pattern;
            this.tokenizedPattern = tokens;
            return this;
        }
        
        /**
         * Tests whether or not a given path matches a given pattern.
         *
         * @param path    The path to match, as a String. Must not be
         *                <code>null</code>.
         * @param isCaseSensitive Whether or not matching should be performed
         *                        case sensitively.
         *
         * @return <code>true</code> if the pattern matches against the string,
         *         or <code>false</code> otherwise.
         */
        public function matchPath(path:TokenizedPath, isCaseSensitive:Boolean):Boolean {
            return SelectorUtils.matchPathVectors(tokenizedPattern, path.getTokens(),
                isCaseSensitive);
        }
        
        /**
         * Tests whether or not this pattern matches the start of
         * a path.
         */
        public function matchStartOf(path:TokenizedPath,
            caseSensitive:Boolean):Boolean {
                return SelectorUtils.matchPatternStartVectors(tokenizedPattern,
                    path.getTokens(), caseSensitive);
            }
        
        /**
         * @return The pattern String
         */
        public function toString():String {
            return pattern;
        }
        
        public function getPattern():String {
            return pattern;
        }
        
        /**
         * true if the original patterns are equal.
         */
        public function equals(o:Object):Boolean {
            return o is TokenizedPattern
            && pattern == TokenizedPattern(o).pattern;
        }
        
        /**
         * The depth (or length) of a pattern.
         */
        public function depth():int {
            return tokenizedPattern.length;
        }
        
        /**
         * Does the tokenized pattern contain the given string?
         */
        public function containsPattern(pat:String):Boolean {
            for (var i:int = 0; i < tokenizedPattern.length; i++) {
                if (tokenizedPattern[i] == pat) {
                    return true;
                }
            }
            return false;
        }
        
        /**
         * Returns a new TokenizedPath where all tokens of this pattern to
         * the right containing wildcards have been removed
         * @return the leftmost part of the pattern without wildcards
         */
        public function rtrimWildcardTokens():TokenizedPath {
            var sb:String = "";
            var newLen:int = 0;
            for (; newLen < tokenizedPattern.length; newLen++) {
                if (SelectorUtils.hasWildcards(tokenizedPattern[newLen])) {
                    break;
                }
                if (newLen > 0
                    && sb.charAt(sb.length - 1) != File.separator) {
                    sb += File.separator;
                }
                sb += tokenizedPattern[newLen];
            }
            if (newLen == 0) {
                return TokenizedPath.EMPTY_PATH;
            }
            var newPats:Vector.<String> = tokenizedPattern.slice(0, newLen);
            return new TokenizedPath("").init(sb, newPats);
        }
        
        /**
         * true if the last token equals the given string.
         */
        public function endsWith(s:String):Boolean {
            return tokenizedPattern.length > 0
                && tokenizedPattern[tokenizedPattern.length - 1] ==  s;
        }
        
        /**
         * Returns a new pattern without the last token of this pattern.
         */
        public function withoutLastToken():TokenizedPattern {
            if (tokenizedPattern.length == 0) {
                throw new IllegalStateException("cant strip a token from nothing");
            } else if (tokenizedPattern.length == 1) {
                return EMPTY_PATTERN;
            } else {
                var toStrip:String = tokenizedPattern[tokenizedPattern.length - 1];
                var index:int = pattern.lastIndexOf(toStrip);
                var tokens:Vector.<String> = tokenizedPattern.slice(0, tokenizedPattern.length - 1);
                return new TokenizedPattern("").init(pattern.substring(0, index), tokens);
            }
        }
    }
}