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
    import flash.system.Capabilities;
    
    import mx.utils.StringUtil;
    
        /**
         * Ported from org.apache.tools.ant.PathTokenizer.java on 12/3/13. 
         * A Path tokenizer takes a path and returns the components that make up
         * that path.
         *
         * The path can use path separators of either ':' or ';' and file separators
         * of either '/' or '\'.
         *
         */
        public class PathTokenizer {
            /**
             * A tokenizer to break the string up based on the ':' or ';' separators.
             */
            private var tokenizer:StringTokenizer;
            
            /**
             * A String which stores any path components which have been read ahead
             * due to DOS filesystem compensation.
             */
            private var lookahead:String = null;
            
            /**
             * Flag to indicate whether or not we are running on a platform with a
             * DOS style filesystem
             */
            private var dosStyleFilesystem:Boolean;
            
            /**
             * Constructs a path tokenizer for the specified path.
             *
             * @param path The path to tokenize. Must not be <code>null</code>.
             */
            public function PathTokenizer(path:String) {
                // on Windows and Unix, we can ignore delimiters and still have
                // enough information to tokenize correctly.
                tokenizer = new StringTokenizer(path, ":;", false);
                dosStyleFilesystem = Capabilities.os.indexOf("Win") != -1;
            }
            
            /**
             * Tests if there are more path elements available from this tokenizer's
             * path. If this method returns <code>true</code>, then a subsequent call
             * to nextToken will successfully return a token.
             *
             * @return <code>true</code> if and only if there is at least one token
             * in the string after the current position; <code>false</code> otherwise.
             */
            public function hasMoreTokens():Boolean {
                if (lookahead != null) {
                    return true;
                }
                
                return tokenizer.hasMoreTokens();
            }
            
            /**
             * Returns the next path element from this tokenizer.
             *
             * @return the next path element from this tokenizer.
             *
             * @exception NoSuchElementException if there are no more elements in this
             *            tokenizer's path.
             */
            public function nextToken():String {
                var token:String = null;
                if (lookahead != null) {
                    token = lookahead;
                    lookahead = null;
                } else {
                    token = StringUtil.trim(tokenizer.nextToken());
                }
                
                if (token.length == 1 && Character.isLetter(token.charAt(0))
                    && dosStyleFilesystem
                    && tokenizer.hasMoreTokens()) {
                    // we are on a dos style system so this path could be a drive
                    // spec. We look at the next token
                    var nextToken:String = StringUtil.trim(tokenizer.nextToken());
                    if (nextToken.indexOf("\\") == 0 || nextToken.indexOf("/") == 0) {
                        // we know we are on a DOS style platform and the next path
                        // starts with a slash or backslash, so we know this is a
                        // drive spec
                        token += ":" + nextToken;
                    } else {
                        // store the token just read for next time
                        lookahead = nextToken;
                    }
                }
                return token;
            }
        }
        

}