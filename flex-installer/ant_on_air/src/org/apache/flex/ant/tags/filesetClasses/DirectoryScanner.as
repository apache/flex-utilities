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
    import flash.utils.Dictionary;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.filesetClasses.Resource;
    import org.apache.flex.ant.tags.filesetClasses.SelectorUtils;
    import org.apache.flex.ant.tags.filesetClasses.exceptions.BuildException;
    import org.apache.flex.ant.tags.filesetClasses.exceptions.IOException;
    import org.apache.flex.ant.tags.filesetClasses.exceptions.IllegalStateException;
    
    /**
     * Ported from org.apache.tools.ant.DirectoryScanner.java on 12/3/13.
     * Class for scanning a directory for files/directories which match certain
     * criteria.
     * <p>
     * These criteria consist of selectors and patterns which have been specified.
     * With the selectors you can select which files you want to have included.
     * Files which are not selected are excluded. With patterns you can include
     * or exclude files based on their filename.
     * <p>
     * The idea is simple. A given directory is recursively scanned for all files
     * and directories. Each file/directory is matched against a set of selectors,
     * including special support for matching against filenames with include and
     * and exclude patterns. Only files/directories which match at least one
     * pattern of the include pattern list or other file selector, and don't match
     * any pattern of the exclude pattern list or fail to match against a required
     * selector will be placed in the list of files/directories found.
     * <p>
     * When no list of include patterns is supplied, "**" will be used, which
     * means that everything will be matched. When no list of exclude patterns is
     * supplied, an empty list is used, such that nothing will be excluded. When
     * no selectors are supplied, none are applied.
     * <p>
     * The filename pattern matching is done as follows:
     * The name to be matched is split up in path segments. A path segment is the
     * name of a directory or file, which is bounded by
     * <code>File.separator</code> ('/' under UNIX, '\' under Windows).
     * For example, "abc/def/ghi/xyz.java" is split up in the segments "abc",
     * "def","ghi" and "xyz.java".
     * The same is done for the pattern against which should be matched.
     * <p>
     * The segments of the name and the pattern are then matched against each
     * other. When '**' is used for a path segment in the pattern, it matches
     * zero or more path segments of the name.
     * <p>
     * There is a special case regarding the use of <code>File.separator</code>s
     * at the beginning of the pattern and the string to match:<br>
     * When a pattern starts with a <code>File.separator</code>, the string
     * to match must also start with a <code>File.separator</code>.
     * When a pattern does not start with a <code>File.separator</code>, the
     * string to match may not start with a <code>File.separator</code>.
     * When one of these rules is not obeyed, the string will not
     * match.
     * <p>
     * When a name path segment is matched against a pattern path segment, the
     * following special characters can be used:<br>
     * '*' matches zero or more characters<br>
     * '?' matches one character.
     * <p>
     * Examples:
     * <p>
     * "**\*.class" matches all .class files/dirs in a directory tree.
     * <p>
     * "test\a??.java" matches all files/dirs which start with an 'a', then two
     * more characters and then ".java", in a directory called test.
     * <p>
     * "**" matches everything in a directory tree.
     * <p>
     * "**\test\**\XYZ*" matches all files/dirs which start with "XYZ" and where
     * there is a parent directory called test (e.g. "abc\test\def\ghi\XYZ123").
     * <p>
     * Case sensitivity may be turned off if necessary. By default, it is
     * turned on.
     * <p>
     * Example of usage:
     * <pre>
     *   String[] includes = {"**\\*.class"};
     *   String[] excludes = {"modules\\*\\**"};
     *   ds.setIncludes(includes);
     *   ds.setExcludes(excludes);
     *   ds.setBasedir(new File("test"));
     *   ds.setCaseSensitive(true);
     *   ds.scan();
     *
     *   System.out.println("FILES:");
     *   String[] files = ds.getIncludedFiles();
     *   for (int i = 0; i < files.length; i++) {
     *     System.out.println(files[i]);
     *   }
     * </pre>
     * This will scan a directory called test for .class files, but excludes all
     * files in all proper subdirectories of a directory called "modules"
     *
     */
    public class DirectoryScanner
    /* implements FileScanner, SelectorScanner, ResourceFactory*/ {
        
        /**
         * Patterns which should be excluded by default.
         *
         * <p>Note that you can now add patterns to the list of default
         * excludes.  Added patterns will not become part of this array
         * that has only been kept around for backwards compatibility
         * reasons.</p>
         *
         * @deprecated since 1.6.x.
         *             Use the {@link #getDefaultExcludes getDefaultExcludes}
         *             method instead.
         */
        protected static const DEFAULTEXCLUDES:Vector.<String> = Vector.<String>([
            // Miscellaneous typical temporary files
            SelectorUtils.DEEP_TREE_MATCH + "/*~",
            SelectorUtils.DEEP_TREE_MATCH + "/#*#",
            SelectorUtils.DEEP_TREE_MATCH + "/.#*",
            SelectorUtils.DEEP_TREE_MATCH + "/%*%",
            SelectorUtils.DEEP_TREE_MATCH + "/._*",
            
            // CVS
            SelectorUtils.DEEP_TREE_MATCH + "/CVS",
            SelectorUtils.DEEP_TREE_MATCH + "/CVS/" + SelectorUtils.DEEP_TREE_MATCH,
            SelectorUtils.DEEP_TREE_MATCH + "/.cvsignore",
            
            // SCCS
            SelectorUtils.DEEP_TREE_MATCH + "/SCCS",
            SelectorUtils.DEEP_TREE_MATCH + "/SCCS/" + SelectorUtils.DEEP_TREE_MATCH,
            
            // Visual SourceSafe
            SelectorUtils.DEEP_TREE_MATCH + "/vssver.scc",
            
            // Subversion
            SelectorUtils.DEEP_TREE_MATCH + "/.svn",
            SelectorUtils.DEEP_TREE_MATCH + "/.svn/" + SelectorUtils.DEEP_TREE_MATCH,
            
            // Git
            SelectorUtils.DEEP_TREE_MATCH + "/.git",
            SelectorUtils.DEEP_TREE_MATCH + "/.git/" + SelectorUtils.DEEP_TREE_MATCH,
            SelectorUtils.DEEP_TREE_MATCH + "/.gitattributes",
            SelectorUtils.DEEP_TREE_MATCH + "/.gitignore",
            SelectorUtils.DEEP_TREE_MATCH + "/.gitmodules",
            
            // Mercurial
            SelectorUtils.DEEP_TREE_MATCH + "/.hg",
            SelectorUtils.DEEP_TREE_MATCH + "/.hg/" + SelectorUtils.DEEP_TREE_MATCH,
            SelectorUtils.DEEP_TREE_MATCH + "/.hgignore",
            SelectorUtils.DEEP_TREE_MATCH + "/.hgsub",
            SelectorUtils.DEEP_TREE_MATCH + "/.hgsubstate",
            SelectorUtils.DEEP_TREE_MATCH + "/.hgtags",
            
            // Bazaar
            SelectorUtils.DEEP_TREE_MATCH + "/.bzr",
            SelectorUtils.DEEP_TREE_MATCH + "/.bzr/" + SelectorUtils.DEEP_TREE_MATCH,
            SelectorUtils.DEEP_TREE_MATCH + "/.bzrignore",
            
            // Mac
            SelectorUtils.DEEP_TREE_MATCH + "/.DS_Store"
        ]);
        
        /**
         * default value for {@link #maxLevelsOfSymlinks maxLevelsOfSymlinks}
         * @since Ant 1.8.0
         */
        public static const MAX_LEVELS_OF_SYMLINKS:int = 5;
        /**
         * The end of the exception message if something that should be
         * there doesn't exist.
         */
        public static const DOES_NOT_EXIST_POSTFIX:String = " does not exist.";
        
        /** Helper. */
        private static const FILE_UTILS:FileUtils = FileUtils.getFileUtils();
        
        /**
         * Patterns which should be excluded by default.
         *
         * @see #addDefaultExcludes()
         */
        private static const defaultExcludes:Vector.<String> = resetDefaultExcludes();
        
        // CheckStyle:VisibilityModifier OFF - bc
        
        /** The base directory to be scanned. */
        protected var basedir:File;
        
        /** The patterns for the files to be included. */
        protected var includes:Vector.<String>;
        
        /** The patterns for the files to be excluded. */
        protected var excludes:Vector.<String>;
        
        /** Selectors that will filter which files are in our candidate list. */
        protected var selectors:Vector.<FileSelector> = null;
        
        /**
         * The files which matched at least one include and no excludes
         * and were selected.
         */
        protected var filesIncluded:Vector.<String>;
        
        /** The files which did not match any includes or selectors. */
        protected var filesNotIncluded:Vector.<String>;
        
        /**
         * The files which matched at least one include and at least
         * one exclude.
         */
        protected var filesExcluded:Vector.<String>;
        
        /**
         * The directories which matched at least one include and no excludes
         * and were selected.
         */
        protected var dirsIncluded:Vector.<String>;
        
        /** The directories which were found and did not match any includes. */
        protected var dirsNotIncluded:Vector.<String>;
        
        /**
         * The directories which matched at least one include and at least one
         * exclude.
         */
        protected var dirsExcluded:Vector.<String>;
        
        /**
         * The files which matched at least one include and no excludes and
         * which a selector discarded.
         */
        protected var filesDeselected:Vector.<String>;
        
        /**
         * The directories which matched at least one include and no excludes
         * but which a selector discarded.
         */
        protected var dirsDeselected:Vector.<String>;
        
        /** Whether or not our results were built by a slow scan. */
        protected var haveSlowResults:Boolean = false;
        
        /**
         * Whether or not the file system should be treated as a case sensitive
         * one.
         */
        protected var _isCaseSensitive:Boolean = true;
        
        /**
         * Whether a missing base directory is an error.
         * @since Ant 1.7.1
         */
        protected var errorOnMissingDir:Boolean = true;
        
        /**
         * Whether or not symbolic links should be followed.
         *
         * @since Ant 1.5
         */
        private var followSymlinks:Boolean = true;
        
        /** Whether or not everything tested so far has been included. */
        protected var everythingIncluded:Boolean = true;
        
        // CheckStyle:VisibilityModifier ON
        
        /**
         * List of all scanned directories.
         *
         * @since Ant 1.6
         */
        private var scannedDirs:Vector.<String> = new Vector.<String>();
        
        /**
         * Map of all include patterns that are full file names and don't
         * contain any wildcards.
         *
         * <p>Maps pattern string to TokenizedPath.</p>
         *
         * <p>If this instance is not case sensitive, the file names get
         * turned to upper case.</p>
         *
         * <p>Gets lazily initialized on the first invocation of
         * isIncluded or isExcluded and cleared at the end of the scan
         * method (cleared in clearCaches, actually).</p>
         *
         * @since Ant 1.8.0
         */
        private var includeNonPatterns:Object = {}; //new HashMap<String, TokenizedPath>();
        
        /**
         * Map of all exclude patterns that are full file names and don't
         * contain any wildcards.
         *
         * <p>Maps pattern string to TokenizedPath.</p>
         *
         * <p>If this instance is not case sensitive, the file names get
         * turned to upper case.</p>
         *
         * <p>Gets lazily initialized on the first invocation of
         * isIncluded or isExcluded and cleared at the end of the scan
         * method (cleared in clearCaches, actually).</p>
         *
         * @since Ant 1.8.0
         */
        private var excludeNonPatterns:Object = {}; //new HashMap<String, TokenizedPath>();
        
        /**
         * Array of all include patterns that contain wildcards.
         *
         * <p>Gets lazily initialized on the first invocation of
         * isIncluded or isExcluded and cleared at the end of the scan
         * method (cleared in clearCaches, actually).</p>
         */
        private var includePatterns:Vector.<TokenizedPattern>;
        
        /**
         * Array of all exclude patterns that contain wildcards.
         *
         * <p>Gets lazily initialized on the first invocation of
         * isIncluded or isExcluded and cleared at the end of the scan
         * method (cleared in clearCaches, actually).</p>
         */
        private var excludePatterns:Vector.<TokenizedPattern>;
        
        /**
         * Have the non-pattern sets and pattern arrays for in- and
         * excludes been initialized?
         *
         * @since Ant 1.6.3
         */
        private var areNonPatternSetsReady:Boolean = false;
        
        /**
         * Scanning flag.
         *
         * @since Ant 1.6.3
         */
        private var scanning:Boolean = false;
        
        /**
         * Scanning lock.
         *
         * @since Ant 1.6.3
         */
        private var scanLock:Object = new Object();
        
        /**
         * Slow scanning flag.
         *
         * @since Ant 1.6.3
         */
        private var slowScanning:Boolean = false;
        
        /**
         * Slow scanning lock.
         *
         * @since Ant 1.6.3
         */
        private var slowScanLock:Object = new Object();
        
        /**
         * Exception thrown during scan.
         *
         * @since Ant 1.6.3
         */
        private var illegal:IllegalStateException = null;
        
        /**
         * The maximum number of times a symbolic link may be followed
         * during a scan.
         *
         * @since Ant 1.8.0
         */
        private var maxLevelsOfSymlinks:int = MAX_LEVELS_OF_SYMLINKS;
        
        
        /**
         * Absolute paths of all symlinks that haven't been followed but
         * would have been if followsymlinks had been true or
         * maxLevelsOfSymlinks had been higher.
         *
         * @since Ant 1.8.0
         */
        private var notFollowedSymlinks:Vector.<String> = new Vector.<String>();
        
        /**
         * Sole constructor.
         */
        public function DirectoryScanner() {
        }
        
        /**
         * Test whether or not a given path matches the start of a given
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
        protected static function matchPatternStart(pattern:String, str:String,
                                                    isCaseSensitive:Boolean = true):Boolean {
            return SelectorUtils.matchPatternStart(pattern, str, isCaseSensitive);
        }
        
        /**
         * Test whether or not a given path matches a given pattern.
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
        protected static function matchPath(pattern:String, str:String,
                                            isCaseSensitive:Boolean = true):Boolean {
            return SelectorUtils.matchPath(pattern, str, isCaseSensitive);
        }
        
        /**
         * Test whether or not a string matches against a pattern.
         * The pattern may contain two special characters:<br>
         * '*' means zero or more characters<br>
         * '?' means one and only one character
         *
         * @param pattern The pattern to match against.
         *                Must not be <code>null</code>.
         * @param str     The string which must be matched against the pattern.
         *                Must not be <code>null</code>.
         * @param isCaseSensitive Whether or not matching should be performed
         *                        case sensitively.
         *
         *
         * @return <code>true</code> if the string matches against the pattern,
         *         or <code>false</code> otherwise.
         */
        protected static function match(pattern:String, str:String,
                                        isCaseSensitive:Boolean = true):Boolean{
            return SelectorUtils.match(pattern, str, isCaseSensitive);
        }
        
        
        /**
         * Get the list of patterns that should be excluded by default.
         *
         * @return An array of <code>String</code> based on the current
         *         contents of the <code>defaultExcludes</code>
         *         <code>Set</code>.
         *
         * @since Ant 1.6
         */
        public static function getDefaultExcludes():Vector.<String> {
            return defaultExcludes.slice();
        }
        
        /**
         * Add a pattern to the default excludes unless it is already a
         * default exclude.
         *
         * @param s   A string to add as an exclude pattern.
         * @return    <code>true</code> if the string was added;
         *            <code>false</code> if it already existed.
         *
         * @since Ant 1.6
         */
        public static function addDefaultExclude(s:String):Boolean {
            if (defaultExcludes.indexOf(s) == -1)
            {
                defaultExcludes.push(s);
                return true;
            }
            return false;
        }
        
        /**
         * Remove a string if it is a default exclude.
         *
         * @param s   The string to attempt to remove.
         * @return    <code>true</code> if <code>s</code> was a default
         *            exclude (and thus was removed);
         *            <code>false</code> if <code>s</code> was not
         *            in the default excludes list to begin with.
         *
         * @since Ant 1.6
         */
        public static function removeDefaultExclude(s:String):Boolean {
            var index:int = defaultExcludes.indexOf(s);
            if (index == -1)
                return false;
            defaultExcludes.splice(index, 1);
            return true;
        }
        
        /**
         * Go back to the hardwired default exclude patterns.
         *
         * @since Ant 1.6
         */
        public static function resetDefaultExcludes():Vector.<String> {
            var arr:Vector.<String> = defaultExcludes;
            if (!arr)
                arr = new Vector.<String>();
            arr.length = 0;
            for (var i:int = 0; i < DEFAULTEXCLUDES.length; i++) {
                arr.push(DEFAULTEXCLUDES[i]);
            }
            return arr;
        }
        
        /**
         * Set the base directory to be scanned. This is the directory which is
         * scanned recursively. All '/' and '\' characters are replaced by
         * <code>File.separatorChar</code>, so the separator used need not match
         * <code>File.separatorChar</code>.
         *
         * @param basedir The base directory to scan.
         */
        public function setBasedir(basedir:Object):void {
            if (basedir is File)
                setBasedirFile(basedir as File);
            else
                setBasedirFile(basedir == null ? null
                    : new File(basedir.replace('/', File.separator).replace(
                        '\\', File.separator)));
        }
        
        /**
         * Set the base directory to be scanned. This is the directory which is
         * scanned recursively.
         *
         * @param basedir The base directory for scanning.
         */
        public function setBasedirFile(basedir:File):void {
            this.basedir = basedir;
        }
        
        /**
         * Return the base directory to be scanned.
         * This is the directory which is scanned recursively.
         *
         * @return the base directory to be scanned.
         */
        public function getBasedir():File {
            return basedir;
        }
        
        /**
         * Find out whether include exclude patterns are matched in a
         * case sensitive way.
         * @return whether or not the scanning is case sensitive.
         * @since Ant 1.6
         */
        public function isCaseSensitive():Boolean {
            return _isCaseSensitive;
        }
        
        /**
         * Set whether or not include and exclude patterns are matched
         * in a case sensitive way.
         *
         * @param isCaseSensitive whether or not the file system should be
         *                        regarded as a case sensitive one.
         */
        public function setCaseSensitive(isCaseSensitive:Boolean):void {
            _isCaseSensitive = isCaseSensitive;
        }
        
        /**
         * Sets whether or not a missing base directory is an error
         *
         * @param errorOnMissingDir whether or not a missing base directory
         *                        is an error
         * @since Ant 1.7.1
         */
        public function setErrorOnMissingDir(errorOnMissingDir:Boolean):void {
            this.errorOnMissingDir = errorOnMissingDir;
        }
        
        /**
         * Get whether or not a DirectoryScanner follows symbolic links.
         *
         * @return flag indicating whether symbolic links should be followed.
         *
         * @since Ant 1.6
         */
        public function isFollowSymlinks():Boolean {
            return followSymlinks;
        }
        
        /**
         * Set whether or not symbolic links should be followed.
         *
         * @param followSymlinks whether or not symbolic links should be followed.
         */
        public function setFollowSymlinks(followSymlinks:Boolean):void {
            this.followSymlinks = followSymlinks;
        }
        
        /**
         * The maximum number of times a symbolic link may be followed
         * during a scan.
         *
         * @since Ant 1.8.0
         */
        public function setMaxLevelsOfSymlinks(max:int):void {
            maxLevelsOfSymlinks = max;
        }
        
        /**
         * Set the list of include patterns to use. All '/' and '\' characters
         * are replaced by <code>File.separator</code>, so the separator used
         * need not match <code>File.separator</code>.
         * <p>
         * When a pattern ends with a '/' or '\', "**" is appended.
         *
         * @param includes A list of include patterns.
         *                 May be <code>null</code>, indicating that all files
         *                 should be included. If a non-<code>null</code>
         *                 list is given, all elements must be
         *                 non-<code>null</code>.
         */
        public function setIncludes(includes:Vector.<String>):void {
            if (includes == null) {
                this.includes = null;
            } else {
                this.includes = new Vector.<String>(includes.length);
                for (var i:int = 0; i < includes.length; i++) {
                    this.includes[i] = normalizePattern(includes[i]);
                }
            }
        }
        
        /**
         * Set the list of exclude patterns to use. All '/' and '\' characters
         * are replaced by <code>File.separator</code>, so the separator used
         * need not match <code>File.separator</code>.
         * <p>
         * When a pattern ends with a '/' or '\', "**" is appended.
         *
         * @param excludes A list of exclude patterns.
         *                 May be <code>null</code>, indicating that no files
         *                 should be excluded. If a non-<code>null</code> list is
         *                 given, all elements must be non-<code>null</code>.
         */
        public function setExcludes(excludes:Vector.<String>):void {
            if (excludes == null) {
                this.excludes = null;
            } else {
                this.excludes = new Vector.<String>(excludes.length);
                for (var i:int = 0; i < excludes.length; i++) {
                    this.excludes[i] = normalizePattern(excludes[i]);
                }
            }
        }
        
        /**
         * Add to the list of exclude patterns to use. All '/' and '\'
         * characters are replaced by <code>File.separator</code>, so
         * the separator used need not match <code>File.separator</code>.
         * <p>
         * When a pattern ends with a '/' or '\', "**" is appended.
         *
         * @param excludes A list of exclude patterns.
         *                 May be <code>null</code>, in which case the
         *                 exclude patterns don't get changed at all.
         *
         * @since Ant 1.6.3
         */
        public function addExcludes(excludes:Vector.<String>):void {
            if (excludes != null && excludes.length > 0) {
                if (this.excludes != null && this.excludes.length > 0) {
                    var tmp:Vector.<String> = this.excludes.slice();
                    for (var i:int = 0; i < excludes.length; i++) {
                        tmp.push(
                            normalizePattern(excludes[i]));
                    }
                    this.excludes = tmp;
                } else {
                    setExcludes(excludes);
                }
            }
        }
        
        /**
         * All '/' and '\' characters are replaced by
         * <code>File.separator</code>, so the separator used need not
         * match <code>File.separator</code>.
         *
         * <p> When a pattern ends with a '/' or '\', "**" is appended.
         *
         * @since Ant 1.6.3
         */
        private function normalizePattern(p:String):String {
            var pattern:String = p.replace(/\//g, File.separator)
                .replace(/\\/g, File.separator);
            if (pattern.charAt(pattern.length - 1) == File.separator) {
                pattern += SelectorUtils.DEEP_TREE_MATCH;
            }
            return pattern;
        }
        
        /**
         * Set the selectors that will select the filelist.
         *
         * @param selectors specifies the selectors to be invoked on a scan.
         */
        public function setSelectors(selectors:Vector.<FileSelector>):void {
            this.selectors = selectors;
        }
        
        /**
         * Return whether or not the scanner has included all the files or
         * directories it has come across so far.
         *
         * @return <code>true</code> if all files and directories which have
         *         been found so far have been included.
         */
        public function isEverythingIncluded():Boolean {
            return everythingIncluded;
        }
        
        /**
         * Scan for files which match at least one include pattern and don't match
         * any exclude patterns. If there are selectors then the files must pass
         * muster there, as well.  Scans under basedir, if set; otherwise the
         * include patterns without leading wildcards specify the absolute paths of
         * the files that may be included.
         *
         * @exception IllegalStateException if the base directory was set
         *            incorrectly (i.e. if it doesn't exist or isn't a directory).
         */
        public function scan():void 
        {
            var savedBase:File = basedir;
            try {
                illegal = null;
                clearResults();
                
                // set in/excludes to reasonable defaults if needed:
                var nullIncludes:Boolean = (includes == null);
                includes = nullIncludes
                    ? Vector.<String>([SelectorUtils.DEEP_TREE_MATCH]) : includes;
                var nullExcludes:Boolean = (excludes == null);
                excludes = nullExcludes ? new Vector.<String>(0) : excludes;
                
                if (basedir != null && !followSymlinks
                    && basedir.isSymbolicLink) {
                    notFollowedSymlinks.push(basedir.nativePath);
                    basedir = null;
                }
                
                if (basedir == null) {
                    // if no basedir and no includes, nothing to do:
                    if (nullIncludes) {
                        return;
                    }
                } else {
                    if (!basedir.exists) {
                        if (errorOnMissingDir) {
                            illegal = new IllegalStateException("basedir "
                                + basedir
                                + DOES_NOT_EXIST_POSTFIX);
                        } else {
                            // Nothing to do - basedir does not exist
                            return;
                        }
                    } else if (!basedir.isDirectory) {
                        illegal = new IllegalStateException("basedir "
                            + basedir
                            + " is not a"
                            + " directory.");
                    }
                    if (illegal != null) {
                        throw illegal;
                    }
                }
                if (isIncludedPath(TokenizedPath.EMPTY_PATH)) {
                    if (!isExcludedPath(TokenizedPath.EMPTY_PATH)) {
                        if (isSelected("", basedir)) {
                            dirsIncluded.push("");
                        } else {
                            dirsDeselected.push("");
                        }
                    } else {
                        dirsExcluded.push("");
                    }
                } else {
                    dirsNotIncluded.push("");
                }
                checkIncludePatterns();
                clearCaches();
                includes = nullIncludes ? null : includes;
                excludes = nullExcludes ? null : excludes;
            } catch (ex:IOException) {
                throw new BuildException(ex.message);
            } catch (e:Error) {
                throw new BuildException(e.message);
            } finally {
                basedir = savedBase;
            }
        }
        
        /**
         * This routine is actually checking all the include patterns in
         * order to avoid scanning everything under base dir.
         * @since Ant 1.6
         */
        private function checkIncludePatterns():void 
        {
            ensureNonPatternSetsReady();
            var newroots:Dictionary = new Dictionary();
            
            // put in the newroots map the include patterns without
            // wildcard tokens
            for (var i:int = 0; i < includePatterns.length; i++) {
                var pattern:String = includePatterns[i].toString();
                if (!shouldSkipPattern(pattern)) {
                    newroots[includePatterns[i].rtrimWildcardTokens()] =
                        pattern;
                }
            }
            for (var p:String in includeNonPatterns) {
                pattern = p;
                if (!shouldSkipPattern(pattern)) {
                    newroots[includeNonPatterns[pattern]] = pattern;
                }
            }
            
            if (newroots.hasOwnProperty(TokenizedPath.EMPTY_PATH)
                && basedir != null) {
                // we are going to scan everything anyway
                scandir(basedir, "", true);
            } else {
                var canonBase:File = null;
                if (basedir != null) {
                    try {
                        canonBase = new File(basedir.nativePath);
                        canonBase.canonicalize();
                    } catch (ex:IOException) {
                        throw new BuildException(ex.message);
                    }
                }
                // only scan directories that can include matched files or
                // directories
                for (var entry:Object in newroots) {
                    var currentPath:TokenizedPath;
                    currentPath = entry as TokenizedPath;
                    var currentelement:String = currentPath.toString();
                    if (basedir == null
                        && !FileUtils.isAbsolutePath(currentelement)) {
                        continue;
                    }
                    var myfile:File = new File(basedir.nativePath + File.separator + currentelement);
                    
                    if (myfile.exists) {
                        // may be on a case insensitive file system.  We want
                        // the results to show what's really on the disk, so
                        // we need to double check.
                        try {
                            var myCanonFile:File = new File(myfile.nativePath);
                            myCanonFile.canonicalize();
                            var path:String = (basedir == null)
                                ? myCanonFile.nativePath
                                : FILE_UTILS.removeLeadingPath(canonBase,
                                    myCanonFile);
                            if (path != currentelement) {
                                myfile = currentPath.findFile(basedir, true);
                                if (myfile != null && basedir != null) {
                                    currentelement = FILE_UTILS.removeLeadingPath(
                                        basedir, myfile);
                                    if (!currentPath.toString()
                                        == currentelement) {
                                        currentPath =
                                            new TokenizedPath(currentelement);
                                    }
                                }
                            }
                        } catch (ex:IOException) {
                            throw new BuildException(ex.message);
                        }
                    }
                    
                    if ((myfile == null || !myfile.exists) && !isCaseSensitive()) {
                        var f:File = currentPath.findFile(basedir, false);
                        if (f != null && f.exists) {
                            // adapt currentelement to the case we've
                            // actually found
                            currentelement = (basedir == null)
                                ? f.nativePath
                                : FILE_UTILS.removeLeadingPath(basedir, f);
                            myfile = f;
                            currentPath = new TokenizedPath(currentelement);
                        }
                    }
                    
                    if (myfile != null && myfile.exists) {
                        if (!followSymlinks && currentPath.isSymlink(basedir)) {
                            if (!isExcludedPath(currentPath)) {
                                notFollowedSymlinks.push(myfile.nativePath);
                            }
                            continue;
                        }
                        if (myfile.isDirectory) {
                            if (isIncludedPath(currentPath)
                                && currentelement.length > 0) {
                                accountForIncludedDir(currentPath, myfile, true);
                            }  else {
                                scandirTokenizedPath(myfile, currentPath, true);
                            }
                        } else {
                            var originalpattern:String;
                            originalpattern = newroots[entry] as String;
                            var included:Boolean = isCaseSensitive()
                                ? originalpattern == currentelement
                                : originalpattern.toUpperCase() == currentelement.toUpperCase();
                            if (included) {
                                accountForIncludedFile(currentPath, myfile);
                            }
                        }
                    }
                }
            }
        }
        
        /**
         * true if the pattern specifies a relative path without basedir
         * or an absolute path not inside basedir.
         *
         * @since Ant 1.8.0
         */
        private function shouldSkipPattern(pattern:String):Boolean {
            if (FileUtils.isAbsolutePath(pattern)) {
                //skip abs. paths not under basedir, if set:
                if (basedir != null
                    && !SelectorUtils.matchPatternStart(pattern,
                        basedir.nativePath,
                        isCaseSensitive())) {
                    return true;
                }
            } else if (basedir == null) {
                //skip non-abs. paths if basedir == null:
                return true;
            }
            return false;
        }
        
        /**
         * Clear the result caches for a scan.
         */
        protected function clearResults():void {
            filesIncluded    = new Vector.<String>();
            filesNotIncluded = new Vector.<String>();
            filesExcluded    = new Vector.<String>();
            filesDeselected  = new Vector.<String>();
            dirsIncluded     = new Vector.<String>();
            dirsNotIncluded  = new Vector.<String>();
            dirsExcluded     = new Vector.<String>();
            dirsDeselected   = new Vector.<String>();
            everythingIncluded = (basedir != null);
            scannedDirs.length = 0;
            notFollowedSymlinks.length = 0;
        }
        
        /**
         * Top level invocation for a slow scan. A slow scan builds up a full
         * list of excluded/included files/directories, whereas a fast scan
         * will only have full results for included files, as it ignores
         * directories which can't possibly hold any included files/directories.
         * <p>
         * Returns immediately if a slow scan has already been completed.
         */
        protected function slowScan():void 
        {
            try {
                // set in/excludes to reasonable defaults if needed:
                var nullIncludes:Boolean = (includes == null);
                includes = nullIncludes
                    ? Vector.<String>([SelectorUtils.DEEP_TREE_MATCH]) : includes;
                var nullExcludes:Boolean = (excludes == null);
                excludes = nullExcludes ? new Vector.<String>(0) : excludes;
                
                var excl:Vector.<String> = dirsExcluded.slice();
                
                var notIncl:Vector.<String> = dirsNotIncluded.slice();
                
                ensureNonPatternSetsReady();
                
                processSlowScan(excl);
                processSlowScan(notIncl);
                clearCaches();
                includes = nullIncludes ? null : includes;
                excludes = nullExcludes ? null : excludes;
            } finally {
                haveSlowResults = true;
                slowScanning = false;
                slowScanLock.notifyAll();
            }
        }
        
        private function processSlowScan(arr:Vector.<String>):void {
            for (var i:int = 0; i < arr.length; i++) {
                var path:TokenizedPath  = new TokenizedPath(arr[i]);
                if (!couldHoldIncludedPath(path) || contentsExcluded(path)) {
                    scandirTokenizedPath(new File(basedir.nativePath + File.separator + arr[i]), path, false);
                }
            }
        }
        
        /**
         * Scan the given directory for files and directories. Found files and
         * directories are placed in their respective collections, based on the
         * matching of includes, excludes, and the selectors.  When a directory
         * is found, it is scanned recursively.
         *
         * @param dir   The directory to scan. Must not be <code>null</code>.
         * @param vpath The path relative to the base directory (needed to
         *              prevent problems with an absolute path when using
         *              dir). Must not be <code>null</code>.
         * @param fast  Whether or not this call is part of a fast scan.
         *
         * @see #filesIncluded
         * @see #filesNotIncluded
         * @see #filesExcluded
         * @see #dirsIncluded
         * @see #dirsNotIncluded
         * @see #dirsExcluded
         * @see #slowScan
         */
        protected function scandir(dir:File, vpath:String, fast:Boolean):void {
            scandirTokenizedPath(dir, new TokenizedPath(vpath), fast);
        }
        
        /**
         * Scan the given directory for files and directories. Found files and
         * directories are placed in their respective collections, based on the
         * matching of includes, excludes, and the selectors.  When a directory
         * is found, it is scanned recursively.
         *
         * @param dir   The directory to scan. Must not be <code>null</code>.
         * @param path The path relative to the base directory (needed to
         *              prevent problems with an absolute path when using
         *              dir). Must not be <code>null</code>.
         * @param fast  Whether or not this call is part of a fast scan.
         *
         * @see #filesIncluded
         * @see #filesNotIncluded
         * @see #filesExcluded
         * @see #dirsIncluded
         * @see #dirsNotIncluded
         * @see #dirsExcluded
         * @see #slowScan
         */
        private function scandirTokenizedPath(dir:File, path:TokenizedPath, fast:Boolean):void {
            if (dir == null) {
                throw new BuildException("dir must not be null.");
            }
            else if (!dir.exists) {
                throw new BuildException(dir + DOES_NOT_EXIST_POSTFIX);
            } else if (!dir.isDirectory) {
                throw new BuildException(dir + " is not a directory.");
            }
            try {
                var arr:Array = dir.getDirectoryListing();                
            } catch (e:Error) {
                throw new BuildException("IO error scanning directory '"
                    + dir.nativePath + "'");
            }
            var arr2:Array = [];
            for each (var f:File in arr)
            arr2.push(f.name);
            var newfiles:Vector.<String> = Vector.<String>(arr2);
            _scandir(dir, path, fast, newfiles, new Vector.<String>());
        }
        
        private function _scandir(dir:File, path:TokenizedPath, fast:Boolean,
                                  newfiles:Vector.<String>, directoryNamesFollowed:Vector.<String>):void {
            var vpath:String = path.toString();
            if (vpath.length > 0 && vpath.charAt(vpath.length - 1) != File.separator) {
                vpath += File.separator;
            }
            
            // avoid double scanning of directories, can only happen in fast mode
            if (fast && hasBeenScanned(vpath)) {
                return;
            }
            if (!followSymlinks) {
                var noLinks:Vector.<String> = new Vector.<String>();
                for (i = 0; i < newfiles.length; i++) {
                    try {
                        if (new File(dir + File.separator + newfiles[i]).isSymbolicLink) {
                            var name:String = vpath + newfiles[i];
                            var file:File = new File(dir.nativePath + File.separator + newfiles[i]);
                            (file.isDirectory
                                ? dirsExcluded : filesExcluded).push(name);
                            if (!isExcluded(name)) {
                                notFollowedSymlinks.push(file.nativePath);
                            }
                        } else {
                            noLinks.push(newfiles[i]);
                        }
                    } catch (ioe:IOException) {
                        var msg:String = "IOException caught while checking "
                            + "for links, couldn't get canonical path!";
                        // will be caught and redirected to Ant's logging system
                        Ant.currentAnt.output(msg);
                        noLinks.push(newfiles[i]);
                    }
                }
                newfiles = noLinks.slice();
            } else {
                directoryNamesFollowed.unshift(dir.nativePath);
            }
            
            for (var i:int = 0; i < newfiles.length; i++) {
                name = vpath + newfiles[i];
                var newPath:TokenizedPath = new TokenizedPath("").initAsChild(path, newfiles[i]);
                file = new File(dir.nativePath + File.separator + newfiles[i]);
                var arr:Array = null;
                var arr2:Array = [];
                var children:Vector.<String> = null;
                if (file.isDirectory)
                {
                    arr = file.getDirectoryListing();
                    for each (var f:File in arr)
                    arr2.push(f.name);
                    children = Vector.<String>(arr2);
                }
                if (children == null || (children.length == 0 && !file.isDirectory)) {
                    if (isIncludedPath(newPath)) {
                        accountForIncludedFile(newPath, file);
                    } else {
                        everythingIncluded = false;
                        filesNotIncluded.push(name);
                    }
                } else { // dir
                    
                    if (followSymlinks
                        && causesIllegalSymlinkLoop(newfiles[i], dir,
                            directoryNamesFollowed)) {
                        // will be caught and redirected to Ant's logging system
                        Ant.currentAnt.output("skipping symbolic link "
                            + file.nativePath
                            + " -- too many levels of symbolic"
                            + " links.");
                        notFollowedSymlinks.push(file.nativePath);
                        continue;
                    }
                    
                    if (isIncludedPath(newPath)) {
                        accountForIncludedDir(newPath, file, fast, children,
                            directoryNamesFollowed);
                    } else {
                        everythingIncluded = false;
                        dirsNotIncluded.push(name);
                        if (fast && couldHoldIncludedPath(newPath)
                            && !contentsExcluded(newPath)) {
                            _scandir(file, newPath, fast, children,
                                directoryNamesFollowed);
                        }
                    }
                    if (!fast) {
                        _scandir(file, newPath, fast, children, directoryNamesFollowed);
                    }
                }
            }
            
            if (followSymlinks) {
                directoryNamesFollowed.shift();
            }
        }
        
        /**
         * Process included file.
         * @param name  path of the file relative to the directory of the FileSet.
         * @param file  included File.
         */
        private function accountForIncludedFile(name:TokenizedPath, file:File):void {
            processIncluded(name, file, filesIncluded, filesExcluded,
                filesDeselected);
        }
        
        /**
         * Process included directory.
         * @param name path of the directory relative to the directory of
         *             the FileSet.
         * @param file directory as File.
         * @param fast whether to perform fast scans.
         */
        private function accountForIncludedDir(name:TokenizedPath,
                                               file:File, fast:Boolean,
                                               children:Vector.<String> = null,
                                               directoryNamesFollowed:Vector.<String> = null):void {
            processIncluded(name, file, dirsIncluded, dirsExcluded, dirsDeselected);
            if (fast && couldHoldIncludedPath(name) && !contentsExcluded(name)) {
                if (directoryNamesFollowed == null)
                    directoryNamesFollowed = new Vector.<String>();
                if (children == null)
                {
                    var listing:Array = file.getDirectoryListing();
                    var nameList:Array = [];
                    for each (var f:File in listing)
                    nameList.push(f.name);
                    children = Vector.<String>(nameList);
                }
                _scandir(file, name, fast, children, directoryNamesFollowed);
            }
        }
        
        private function processIncluded(path:TokenizedPath,
                                         file:File, inc:Vector.<String>, exc:Vector.<String>,
                                         des:Vector.<String>):void {
            var name:String = path.toString();
            if (inc.indexOf(name) != -1 || 
                exc.indexOf(name) != -1 || 
                des.indexOf(name) != -1) {
                return;
            }
            
            var included:Boolean = false;
            if (isExcludedPath(path)) {
                exc.push(name);
            } else if (isSelected(name, file)) {
                included = true;
                inc.push(name);
            } else {
                des.push(name);
            }
            everythingIncluded = everythingIncluded || included;
        }
        
        /**
         * Test whether or not a name matches against at least one include
         * pattern.
         *
         * @param name The name to match. Must not be <code>null</code>.
         * @return <code>true</code> when the name matches against at least one
         *         include pattern, or <code>false</code> otherwise.
         */
        protected function isIncluded(name:String):Boolean {
            return isIncludedPath(new TokenizedPath(name));
        }
        
        /**
         * Test whether or not a name matches against at least one include
         * pattern.
         *
         * @param name The name to match. Must not be <code>null</code>.
         * @return <code>true</code> when the name matches against at least one
         *         include pattern, or <code>false</code> otherwise.
         */
        private function isIncludedPath(path:TokenizedPath):Boolean {
            ensureNonPatternSetsReady();
            
            if (isCaseSensitive()
                ? includeNonPatterns.hasOwnProperty(path.toString())
                : includeNonPatterns.hasOwnProperty(path.toString().toUpperCase())) {
                return true;
            }
            for (var i:int = 0; i < includePatterns.length; i++) {
                if (includePatterns[i].matchPath(path, isCaseSensitive())) {
                    return true;
                }
            }
            return false;
        }
        
        /**
         * Test whether or not a name matches the start of at least one include
         * pattern.
         *
         * @param name The name to match. Must not be <code>null</code>.
         * @return <code>true</code> when the name matches against the start of at
         *         least one include pattern, or <code>false</code> otherwise.
         */
        protected function couldHoldIncluded(name:String):Boolean {
            return couldHoldIncludedPath(new TokenizedPath(name));
        }
        
        /**
         * Test whether or not a name matches the start of at least one include
         * pattern.
         *
         * @param tokenizedName The name to match. Must not be <code>null</code>.
         * @return <code>true</code> when the name matches against the start of at
         *         least one include pattern, or <code>false</code> otherwise.
         */
        private function couldHoldIncludedPath(tokenizedName:TokenizedPath):Boolean {
            for (var i:int = 0; i < includePatterns.length; i++) {
                if (couldHoldIncludedWithIncludes(tokenizedName, includePatterns[i])) {
                    return true;
                }
            }
            for each (var iter:TokenizedPath in includeNonPatterns) {
                if (couldHoldIncludedWithIncludes(tokenizedName,
                    iter.toPattern())) {
                    return true;
                }
            }
            return false;
        }
        
        /**
         * Test whether or not a name matches the start of the given
         * include pattern.
         *
         * @param tokenizedName The name to match. Must not be <code>null</code>.
         * @return <code>true</code> when the name matches against the start of the
         *         include pattern, or <code>false</code> otherwise.
         */
        private function couldHoldIncludedWithIncludes(tokenizedName:TokenizedPath,
                                                       tokenizedInclude:TokenizedPattern):Boolean {
            return tokenizedInclude.matchStartOf(tokenizedName, isCaseSensitive())
                && isMorePowerfulThanExcludes(tokenizedName.toString())
                && isDeeper(tokenizedInclude, tokenizedName);
        }
        
        /**
         * Verify that a pattern specifies files deeper
         * than the level of the specified file.
         * @param pattern the pattern to check.
         * @param name the name to check.
         * @return whether the pattern is deeper than the name.
         * @since Ant 1.6.3
         */
        private function isDeeper(pattern:TokenizedPattern, name:TokenizedPath):Boolean {
            return pattern.containsPattern(SelectorUtils.DEEP_TREE_MATCH)
                || pattern.depth() > name.depth();
        }
        
        /**
         *  Find out whether one particular include pattern is more powerful
         *  than all the excludes.
         *  Note:  the power comparison is based on the length of the include pattern
         *  and of the exclude patterns without the wildcards.
         *  Ideally the comparison should be done based on the depth
         *  of the match; that is to say how many file separators have been matched
         *  before the first ** or the end of the pattern.
         *
         *  IMPORTANT : this function should return false "with care".
         *
         *  @param name the relative path to test.
         *  @return true if there is no exclude pattern more powerful than
         *  this include pattern.
         *  @since Ant 1.6
         */
        private function isMorePowerfulThanExcludes(name:String):Boolean {
            const soughtexclude:String  =
                name + File.separator + SelectorUtils.DEEP_TREE_MATCH;
            for (var counter:int = 0; counter < excludePatterns.length; counter++) {
                if (excludePatterns[counter].toString() == soughtexclude)  {
                    return false;
                }
            }
            return true;
        }
        
        /**
         * Test whether all contents of the specified directory must be excluded.
         * @param path the path to check.
         * @return whether all the specified directory's contents are excluded.
         */
        /* package */ private function contentsExcluded(path:TokenizedPath):Boolean {
            for (var i:int = 0; i < excludePatterns.length; i++) {
                if (excludePatterns[i].endsWith(SelectorUtils.DEEP_TREE_MATCH)
                    && excludePatterns[i].withoutLastToken()
                    .matchPath(path, isCaseSensitive())) {
                    return true;
                }
            }
            return false;
        }
        
        /**
         * Test whether or not a name matches against at least one exclude
         * pattern.
         *
         * @param name The name to match. Must not be <code>null</code>.
         * @return <code>true</code> when the name matches against at least one
         *         exclude pattern, or <code>false</code> otherwise.
         */
        protected function isExcluded(name:String):Boolean {
            return isExcludedPath(new TokenizedPath(name));
        }
        
        /**
         * Test whether or not a name matches against at least one exclude
         * pattern.
         *
         * @param name The name to match. Must not be <code>null</code>.
         * @return <code>true</code> when the name matches against at least one
         *         exclude pattern, or <code>false</code> otherwise.
         */
        private function isExcludedPath(name:TokenizedPath):Boolean {
            ensureNonPatternSetsReady();
            
            if (isCaseSensitive()
                ? excludeNonPatterns.hasOwnProperty(name.toString())
                : excludeNonPatterns.hasOwnProperty(name.toString().toUpperCase())) {
                return true;
            }
            for (var i:int = 0; i < excludePatterns.length; i++) {
                if (excludePatterns[i].matchPath(name, isCaseSensitive())) {
                    return true;
                }
            }
            return false;
        }
        
        /**
         * Test whether a file should be selected.
         *
         * @param name the filename to check for selecting.
         * @param file the java.io.File object for this filename.
         * @return <code>false</code> when the selectors says that the file
         *         should not be selected, <code>true</code> otherwise.
         */
        protected function isSelected(name:String, file:File):Boolean {
            if (selectors != null) {
                for (var i:int = 0; i < selectors.length; i++) {
                    if (!selectors[i].isSelected(basedir, name, file)) {
                        return false;
                    }
                }
            }
            return true;
        }
        
        /**
         * Return the names of the files which matched at least one of the
         * include patterns and none of the exclude patterns.
         * The names are relative to the base directory.
         *
         * @return the names of the files which matched at least one of the
         *         include patterns and none of the exclude patterns.
         */
        public function getIncludedFiles():Vector.<String> {
            var files:Vector.<String>;
            files = filesIncluded.slice();
            files.sort(0);
            return files;
        }
        
        /**
         * Return the count of included files.
         * @return <code>int</code>.
         * @since Ant 1.6.3
         */
        public function getIncludedFilesCount():int {
            if (filesIncluded == null) {
                throw new IllegalStateException("Must call scan() first");
            }
            return filesIncluded.length;
        }
        
        /**
         * Return the names of the files which matched none of the include
         * patterns. The names are relative to the base directory. This involves
         * performing a slow scan if one has not already been completed.
         *
         * @return the names of the files which matched none of the include
         *         patterns.
         *
         * @see #slowScan
         */
        public function getNotIncludedFiles():Vector.<String> {
            slowScan();
            var files:Vector.<String> = filesNotIncluded.slice();
            return files;
        }
        
        /**
         * Return the names of the files which matched at least one of the
         * include patterns and at least one of the exclude patterns.
         * The names are relative to the base directory. This involves
         * performing a slow scan if one has not already been completed.
         *
         * @return the names of the files which matched at least one of the
         *         include patterns and at least one of the exclude patterns.
         *
         * @see #slowScan
         */
        public function getExcludedFiles():Vector.<String> {
            slowScan();
            var files:Vector.<String> = filesExcluded.slice();
            return files;
        }
        
        /**
         * <p>Return the names of the files which were selected out and
         * therefore not ultimately included.</p>
         *
         * <p>The names are relative to the base directory. This involves
         * performing a slow scan if one has not already been completed.</p>
         *
         * @return the names of the files which were deselected.
         *
         * @see #slowScan
         */
        public function getDeselectedFiles():Vector.<String> {
            slowScan();
            var files:Vector.<String> = filesDeselected.slice();
            return files;
        }
        
        /**
         * Return the names of the directories which matched at least one of the
         * include patterns and none of the exclude patterns.
         * The names are relative to the base directory.
         *
         * @return the names of the directories which matched at least one of the
         * include patterns and none of the exclude patterns.
         */
        public function getIncludedDirectories():Vector.<String> {
            var directories:Vector.<String>;
            directories = dirsIncluded.slice();
            directories.sort(0);
            return directories;
        }
        
        /**
         * Return the count of included directories.
         * @return <code>int</code>.
         * @since Ant 1.6.3
         */
        public function getIncludedDirsCount():int {
            if (dirsIncluded == null) {
                throw new IllegalStateException("Must call scan() first");
            }
            return dirsIncluded.length;
        }
        
        /**
         * Return the names of the directories which matched none of the include
         * patterns. The names are relative to the base directory. This involves
         * performing a slow scan if one has not already been completed.
         *
         * @return the names of the directories which matched none of the include
         * patterns.
         *
         * @see #slowScan
         */
        public function getNotIncludedDirectories():Vector.<String> {
            slowScan();
            var directories:Vector.<String> = dirsNotIncluded.slice();
            return directories;
        }
        
        /**
         * Return the names of the directories which matched at least one of the
         * include patterns and at least one of the exclude patterns.
         * The names are relative to the base directory. This involves
         * performing a slow scan if one has not already been completed.
         *
         * @return the names of the directories which matched at least one of the
         * include patterns and at least one of the exclude patterns.
         *
         * @see #slowScan
         */
        public function getExcludedDirectories():Vector.<String> {
            slowScan();
            var directories:Vector.<String> = dirsExcluded.slice();
            return directories;
        }
        
        /**
         * <p>Return the names of the directories which were selected out and
         * therefore not ultimately included.</p>
         *
         * <p>The names are relative to the base directory. This involves
         * performing a slow scan if one has not already been completed.</p>
         *
         * @return the names of the directories which were deselected.
         *
         * @see #slowScan
         */
        public function getDeselectedDirectories():Vector.<String> {
            slowScan();
            var directories:Vector.<String> = dirsDeselected.slice();
            return directories;
        }
        
        /**
         * Absolute paths of all symbolic links that haven't been followed
         * but would have been followed had followsymlinks been true or
         * maxLevelsOfSymlinks been bigger.
         *
         * @since Ant 1.8.0
         */
        public function getNotFollowedSymlinks():Vector.<String> {
            var links:Vector.<String>;
            links = notFollowedSymlinks.slice();
            links.sort(0);
            return links;
        }
        
        /**
         * Add default exclusions to the current exclusions set.
         */
        public function addDefaultExcludes():void 
        {
            var excludesLength:int = excludes == null ? 0 : excludes.length;
            var newExcludes:Vector.<String>;
            var defaultExcludesTemp:Vector.<String> = getDefaultExcludes();
            newExcludes = defaultExcludesTemp.slice();
            for (var i:int = 0; i < defaultExcludesTemp.length; i++) {
                newExcludes.push(
                    defaultExcludesTemp[i].replace(/\//g, File.separator)
                    .replace(/\\/g, File.separator));
            }
            excludes = newExcludes;
        }
        
        /**
         * Get the named resource.
         * @param name path name of the file relative to the dir attribute.
         *
         * @return the resource with the given name.
         * @since Ant 1.5.2
         */
        public function getResource(name:String):Resource {
            return new FileResource(basedir, name);
        }
        
        /**
         * Has the directory with the given path relative to the base
         * directory already been scanned?
         *
         * <p>Registers the given directory as scanned as a side effect.</p>
         *
         * @since Ant 1.6
         */
        private function hasBeenScanned(vpath:String):Boolean {
            return !scannedDirs.push(vpath);
        }
        
        /**
         * This method is of interest for testing purposes.  The returned
         * Set is live and should not be modified.
         * @return the Set of relative directory names that have been scanned.
         */
        /* package-private */private function getScannedDirs():Vector.<String> {
            return scannedDirs;
        }
        
        /**
         * Clear internal caches.
         *
         * @since Ant 1.6
         */
        private function clearCaches():void {
            includeNonPatterns = {};
            excludeNonPatterns = {};
            includePatterns = null;
            excludePatterns = null;
            areNonPatternSetsReady = false;
        }
        
        /**
         * Ensure that the in|exclude &quot;patterns&quot;
         * have been properly divided up.
         *
         * @since Ant 1.6.3
         */
        /* package */private function ensureNonPatternSetsReady():void {
            if (!areNonPatternSetsReady) {
                includePatterns = fillNonPatternSet(includeNonPatterns, includes);
                excludePatterns = fillNonPatternSet(excludeNonPatterns, excludes);
                areNonPatternSetsReady = true;
            }
        }
        
        /**
         * Add all patterns that are not real patterns (do not contain
         * wildcards) to the set and returns the real patterns.
         *
         * @param map Map to populate.
         * @param patterns String[] of patterns.
         * @since Ant 1.8.0
         */
        private function fillNonPatternSet(map:Object, patterns:Vector.<String>):Vector.<TokenizedPattern> {
            var al:Vector.<TokenizedPattern> = new Vector.<TokenizedPattern>();
            for (var i:int = 0; i < patterns.length; i++) {
                if (!SelectorUtils.hasWildcards(patterns[i])) {
                    var s:String = isCaseSensitive()
                        ? patterns[i] : patterns[i].toUpperCase();
                    map[s] = new TokenizedPath(s);
                } else {
                    al.push(new TokenizedPattern(patterns[i]));
                }
            }
            return al;
        }
        
        /**
         * Would following the given directory cause a loop of symbolic
         * links deeper than allowed?
         *
         * <p>Can only happen if the given directory has been seen at
         * least more often than allowed during the current scan and it is
         * a symbolic link and enough other occurences of the same name
         * higher up are symbolic links that point to the same place.</p>
         *
         * @since Ant 1.8.0
         */
        private function causesIllegalSymlinkLoop(dirName:String, parent:File,
                                                  directoryNamesFollowed:Vector.<String>):Boolean {
            try {
                if (directoryNamesFollowed.length >= maxLevelsOfSymlinks
                    && CollectionUtils.frequency(directoryNamesFollowed, dirName)
                    >= maxLevelsOfSymlinks
                    && new File(parent.nativePath + File.separator + dirName).isSymbolicLink) {
                    
                    var files:Vector.<String> = new Vector.<String>();
                    var f:File = FILE_UTILS.resolveFile(parent, dirName);
                    f.canonicalize();
                    var target:String = f.nativePath;
                    files.push(target);
                    
                    var relPath:String = "";
                    for each (var dir:String in directoryNamesFollowed) {
                        relPath += "../";
                        if (dirName == dir) {
                            f = FILE_UTILS.resolveFile(parent, relPath + dir);
                            f.canonicalize();
                            files.push(f.nativePath);
                            if (files.length > maxLevelsOfSymlinks
                                && CollectionUtils.frequency(files, target)
                                > maxLevelsOfSymlinks) {
                                return true;
                            }
                        }
                    }
                    
                }
                return false;
            } catch (ex:IOException) {
                throw new BuildException("Caught error while checking for"
                    + " symbolic links" + ex.message);
            }
            return false;
        }
        
    }
}