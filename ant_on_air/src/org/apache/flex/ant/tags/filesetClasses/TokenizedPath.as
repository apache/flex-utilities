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
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.filesetClasses.FileUtils;
    import org.apache.flex.ant.tags.filesetClasses.exceptions.BuildException;
    import org.apache.flex.ant.tags.filesetClasses.exceptions.IOException;
    
    /**
     * Ported from org.apache.tools.ant.types.selectors.TokenizedPath.java on 12/3/13;
     * Container for a path that has been split into its components.
     * @since 1.8.0
     */
    public class TokenizedPath {
        
        /**
         * Instance that holds no tokens at all.
         */
        public static const EMPTY_PATH:TokenizedPath =
            new TokenizedPath("").init("", new Vector.<String>());
        
        /** Helper. */
        private static const FILE_UTILS:FileUtils = FileUtils.getFileUtils();
        /** Helper. */
        /** iterations for case-sensitive scanning. */
        private static const CS_SCAN_ONLY:Vector.<Boolean> = new Vector.<Boolean>([true]);
        /** iterations for non-case-sensitive scanning. */
        private static const CS_THEN_NON_CS:Vector.<Boolean> = new Vector.<Boolean>([true, false]);
        
        private var path:String;
        private var tokenizedPath:Vector.<String>;
        
        /**
         * Initialize the TokenizedPath by parsing it. 
         * @param path The path to tokenize. Must not be
         *                <code>null</code>.
         */
        public function TokenizedPath(path:String) {
            init(path, SelectorUtils.tokenizePathAsArray(path));
        }
        
        /**
         * Creates a new path as a child of another path.
         *
         * @param parent the parent path
         * @param child the child, must not contain the file separator
         */
        public function initAsChild(parent:TokenizedPath, child:String):TokenizedPath {
            if (parent.path.length > 0
                && parent.path.charAt(parent.path.length - 1)
                != File.separator) {
                path = parent.path + File.separator + child;
            } else {
                path = parent.path + child;
            }
            tokenizedPath = parent.tokenizedPath.slice();
            tokenizedPath.push(child);
            return this;
        }
        
        /* package */ public function init(path:String, tokens:Vector.<String>):TokenizedPath {
            this.path = path;
            this.tokenizedPath = tokens;
            return this;
        }
        
        /**
         * @return The original path String
         */
        public function toString():String {
            return path;
        }
        
        /**
         * The depth (or length) of a path.
         */
        public function depth():int {
            return tokenizedPath.length;
        }
        
        /* package */ public function getTokens():Vector.<String> {
            return tokenizedPath;
        }
        
        /**
         * From <code>base</code> traverse the filesystem in order to find
         * a file that matches the given name.
         *
         * @param base base File (dir).
         * @param cs whether to scan case-sensitively.
         * @return File object that points to the file in question or null.
         */
        public function findFile(base:File, cs:Boolean):File {
            var tokens:Vector.<String> = tokenizedPath;
            if (FileUtils.isAbsolutePath(path)) {
                if (base == null) {
                    var s:Vector.<String> = FILE_UTILS.dissect(path);
                    base = new File(s[0]);
                    tokens = SelectorUtils.tokenizePathAsArray(s[1]);
                } else {
                    var f:File = FILE_UTILS.normalize(path);
                    var n:String = FILE_UTILS.removeLeadingPath(base, f);
                    if (n == f.nativePath) {
                        //removing base from path yields no change; path
                        //not child of base
                        return null;
                    }
                    tokens = SelectorUtils.tokenizePathAsArray(n);
                }
            }
            return TokenizedPath.findFile(base, tokens, cs);
        }
        

        /**
         * Do we have to traverse a symlink when trying to reach path from
         * basedir?
         * @param base base File (dir).
         */
        public function isSymlink(base:File):Boolean {
            for (var i:int = 0; i < tokenizedPath.length; i++) {
                try {
                    if ((base != null
                        && new File(base.nativePath + File.separator + tokenizedPath[i]).isSymbolicLink)
                        ||
                        (base == null
                            && new File(tokenizedPath[i]).isSymbolicLink)
                    ) {
                        return true;
                    }
                    base = new File(base + File.separator + tokenizedPath[i]);
                } catch (ioe:IOException) {
                    var msg:String = "IOException caught while checking "
                        + "for links, couldn't get canonical path!";
                    // will be caught and redirected to Ant's logging system
                    Ant.currentAnt.output(msg);
                }
            }
            return false;
        }
        
        /**
         * true if the original paths are equal.
         */
        public function equals(o:Object):Boolean {
            return o is TokenizedPath
            && path == TokenizedPath(o).path;
        }

        /**
         * From <code>base</code> traverse the filesystem in order to find
         * a file that matches the given stack of names.
         *
         * @param base base File (dir) - must not be null.
         * @param pathElements array of path elements (dirs...file).
         * @param cs whether to scan case-sensitively.
         * @return File object that points to the file in question or null.
         */
        private static function findFile(base:File, pathElements:Vector.<String>,
            cs:Boolean):File {
                for (var current:int = 0; current < pathElements.length; current++) {
                    if (!base.isDirectory) {
                        return null;
                    }
                    var arr:Array = base.getDirectoryListing();
                    var arr2:Array = [];
                    for each (var f:File in arr)
                    arr2.push(f.nativePath);
                    var files:Vector.<String> = Vector.<String>(arr2);
                    if (files == null) {
                        throw new BuildException("IO error scanning directory "
                            + base.nativePath);
                    }
                    var found:Boolean = false;
                    var matchCase:Vector.<Boolean> = cs ? CS_SCAN_ONLY : CS_THEN_NON_CS;
                    for (var i:int = 0; !found && i < matchCase.length; i++) {
                        for (var j:int = 0; !found && j < files.length; j++) {
                            if (matchCase[i]
                                ? files[j] == pathElements[current]
                                : files[j].toUpperCase() == pathElements[current].toUpperCase()) {
                                base = new File(base.nativePath + File.separator + files[j]);
                                found = true;
                            }
                        }
                    }
                    if (!found) {
                        return null;
                    }
                }
                return pathElements.length == 0 && !base.isDirectory ? null : base;
            }

        /**
         * Creates a TokenizedPattern from the same tokens that make up
         * this path.
         */
        public function toPattern():TokenizedPattern {
            return new TokenizedPattern(path).init(path, tokenizedPath); 
        }
        
    }
}