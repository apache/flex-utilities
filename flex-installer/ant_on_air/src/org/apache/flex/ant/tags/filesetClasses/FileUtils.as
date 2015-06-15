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
    import flash.system.Capabilities;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.filesetClasses.exceptions.BuildException;
    import org.apache.flex.ant.tags.filesetClasses.exceptions.IOException;
    
    /**
     * Ported from org.apache.tools.ant.util on 12/3/13.  File copying
     * was removed.  So was tempfile, newfile, readfully and contentEquals.
     * 
     * This class also encapsulates methods which allow Files to be
     * referred to using abstract path names which are translated to native
     * system file paths at runtime as well as copying files or setting
     * their last modification time.
     *
     */
    public class FileUtils {
        private static const PRIMARY_INSTANCE:FileUtils = new FileUtils();
                
        private static const ON_WINDOWS:Boolean = Capabilities.os.indexOf("Win") != -1;
        private static const ON_DOS:Boolean = Capabilities.os.indexOf("Win") != -1;
                
        /**
         * The granularity of timestamps under Unix.
         */
        public static const UNIX_FILE_TIMESTAMP_GRANULARITY:int = 1000;
        
        /**
         * The granularity of timestamps under the NT File System.
         * NTFS has a granularity of 100 nanoseconds, which is less
         * than 1 millisecond, so we round this up to 1 millisecond.
         */
        public static const NTFS_FILE_TIMESTAMP_GRANULARITY:int = 1;
                
        /**
         * Method to retrieve The FileUtils, which is shared by all users of this
         * method.
         * @return an instance of FileUtils.
         * @since Ant 1.6.3
         */
        public static function getFileUtils():FileUtils {
            return PRIMARY_INSTANCE;
        }
        
        /**
         * Empty constructor.
         */
        public function FileUtils() {
        }
        
        /**
         * Get the URL for a file taking into account # characters.
         *
         * @param file the file whose URL representation is required.
         * @return The FileURL value.
         * @throws MalformedURLException if the URL representation cannot be
         *      formed.
        public URL getFileURL(File file) throws MalformedURLException {
            return new URL(file.toURI().toASCIIString());
        }
         */
                
        /**
         * Calls File.setLastModified(long time). Originally written to
         * to dynamically bind to that call on Java1.2+.
         *
         * @param file the file whose modified time is to be set
         * @param time the time to which the last modified time is to be set.
         *             if this is -1, the current time is used.
         */
        public function setFileLastModified(file:File, time:Number):void {
            throw new Error("not supported in AIR");
        }
        
        /**
         * Interpret the filename as a file relative to the given file
         * unless the filename already represents an absolute filename.
         * Differs from <code>new File(file, filename)</code> in that
         * the resulting File's path will always be a normalized,
         * absolute pathname.  Also, if it is determined that
         * <code>filename</code> is context-relative, <code>file</code>
         * will be discarded and the reference will be resolved using
         * available context/state information about the filesystem.
         *
         * @param file the "reference" file for relative paths. This
         * instance must be an absolute file and must not contain
         * &quot;./&quot; or &quot;../&quot; sequences (same for \ instead
         * of /).  If it is null, this call is equivalent to
         * <code>new java.io.File(filename).getAbsoluteFile()</code>.
         *
         * @param filename a file name.
         *
         * @return an absolute file.
         * @throws java.lang.NullPointerException if filename is null.
         */
        public function resolveFile(file:File, filename:String):File {
            if (!isAbsolutePath(filename)) {
                var sep:String = File.separator;
                filename = filename.replace(/\//g, sep).replace(/\\/g, sep);
                if (isContextRelativePath(filename)) {
                    file = null;
                    // on cygwin, our current directory can be a UNC;
                    // assume user.dir is absolute or all hell breaks loose...
                    var udir:String = File.userDirectory.nativePath;
                    if (filename.charAt(0) == sep && udir.charAt(0) == sep) {
                        filename = dissect(udir)[0] + filename.substring(1);
                    }
                }
                filename = new File(file.nativePath + File.separator + filename).nativePath;
            }
            return normalize(filename);
        }
        
        /**
         * On DOS and NetWare, the evaluation of certain file
         * specifications is context-dependent.  These are filenames
         * beginning with a single separator (relative to current root directory)
         * and filenames with a drive specification and no intervening separator
         * (relative to current directory of the specified root).
         * @param filename the filename to evaluate.
         * @return true if the filename is relative to system context.
         * @throws java.lang.NullPointerException if filename is null.
         * @since Ant 1.7
         */
        public static function isContextRelativePath(filename:String):Boolean {
            if (!ON_DOS || filename.length == 0) {
                return false;
            }
            var sep:String = File.separator;
            filename = filename.replace(/\//g, sep).replace(/\\/g, sep);
            var c:String = filename.charAt(0);
            var len:int = filename.length;
            return (c == sep && (len == 1 || filename.charAt(1) != sep))
            || (Character.isLetter(c) && len > 1
                && filename.indexOf(':') == 1
                && (len == 2 || filename.charAt(2) != sep));
        }
        
                
        /**
         * Verifies that the specified filename represents an absolute path.
         * Differs from new java.io.File("filename").isAbsolute() in that a path
         * beginning with a double file separator--signifying a Windows UNC--must
         * at minimum match "\\a\b" to be considered an absolute path.
         * @param filename the filename to be checked.
         * @return true if the filename represents an absolute path.
         * @throws java.lang.NullPointerException if filename is null.
         * @since Ant 1.6.3
         */
        public static function isAbsolutePath(filename:String):Boolean {
            var len:int = filename.length;
            if (len == 0) {
                return false;
            }
            var sep:String = File.separator;
            filename = filename.replace(/\//g, sep).replace(/\\/g, sep);
            var c:String = filename.charAt(0);
            if (!ON_DOS)
                return (c == sep);
            
            if (c == sep) {
                // CheckStyle:MagicNumber OFF
                if (!(ON_DOS && len > 4 && filename.charAt(1) == sep)) {
                    return false;
                }
                // CheckStyle:MagicNumber ON
                var nextsep:int = filename.indexOf(sep, 2);
                return nextsep > 2 && nextsep + 1 < len;
            }
            var colon:int = filename.indexOf(':');
            return (Character.isLetter(c) && colon == 1
                && filename.length > 2 && filename.charAt(2) == sep);
        }
        
        /**
         * Translate a path into its native (platform specific) format.
         * <p>
         * This method uses PathTokenizer to separate the input path
         * into its components. This handles DOS style paths in a relatively
         * sensible way. The file separators are then converted to their platform
         * specific versions.
         *
         * @param toProcess The path to be translated.
         *                  May be <code>null</code>.
         *
         * @return the native version of the specified path or
         *         an empty string if the path is <code>null</code> or empty.
         *
         * @since ant 1.7
         * @see PathTokenizer
         */
        public static function translatePath(toProcess:String):String {
            if (toProcess == null || toProcess.length == 0) {
                return "";
            }
            var path:String = "";
            var tokenizer:PathTokenizer = new PathTokenizer(toProcess);
            while (tokenizer.hasMoreTokens()) {
                var pathComponent:String = tokenizer.nextToken();
                pathComponent = pathComponent.replace(/\//g, File.separator);
                pathComponent = pathComponent.replace(/\\/g, File.separator);
                if (path.length != 0) {
                    path += File.separator;
                }
                path += pathComponent;
            }
            return path;
        }
        
        /**
         * &quot;Normalize&quot; the given absolute path.
         *
         * <p>This includes:
         * <ul>
         *   <li>Uppercase the drive letter if there is one.</li>
         *   <li>Remove redundant slashes after the drive spec.</li>
         *   <li>Resolve all ./, .\, ../ and ..\ sequences.</li>
         *   <li>DOS style paths that start with a drive letter will have
         *     \ as the separator.</li>
         * </ul>
         * Unlike {@link File#getCanonicalPath()} this method
         * specifically does not resolve symbolic links.
         *
         * @param path the path to be normalized.
         * @return the normalized version of the path.
         *
         * @throws java.lang.NullPointerException if path is null.
         */
        public function normalize(path:String):File {
            var s:Array = new Array();
            var dissect:Vector.<String> = dissect(path);
            s.push(dissect[0]);
            
            var tok:StringTokenizer = new StringTokenizer(dissect[1], File.separator);
            while (tok.hasMoreTokens()) {
                var thisToken:String = tok.nextToken();
                if ("." == thisToken) {
                    continue;
                }
                if (".." == thisToken) {
                    if (s.length < 2) {
                        // Cannot resolve it, so skip it.
                        return new File(path);
                    }
                    s.pop();
                } else { // plain component
                    s.push(thisToken);
                }
            }
            var sb:String = "";
            var size:int = s.length;
            for (var i:int = 0; i < size; i++) {
                if (i > 1) {
                    // not before the filesystem root and not after it, since root
                    // already contains one
                    sb += File.separator;
                }
                sb += s[i];
            }
            return new File(sb);
        }
        
        /**
         * Dissect the specified absolute path.
         * @param path the path to dissect.
         * @return String[] {root, remaining path}.
         * @throws java.lang.NullPointerException if path is null.
         * @since Ant 1.7
         */
        public function dissect(path:String):Vector.<String> {
            var sep:String = File.separator;
            path = path.replace(/\//g, sep).replace(/\\/g, sep);
            
            // make sure we are dealing with an absolute path
            if (!isAbsolutePath(path)) {
                throw new BuildException(path + " is not an absolute path");
            }
            var root:String = null;
            var colon:int = path.indexOf(':');
            if (colon > 0 && ON_DOS) {
                
                var next:int = colon + 1;
                root = path.substring(0, next);
                var ca:Vector.<String> = Vector.<String>(path.split(""));
                root += sep;
                //remove the initial separator; the root has it.
                next = (ca[next] == sep) ? next + 1 : next;
                
                var sbPath:String = "";
                // Eliminate consecutive slashes after the drive spec:
                for (var i:int = next; i < ca.length; i++) {
                    if (ca[i] != sep || ca[i - 1] != sep) {
                        sbPath += ca[i];
                    }
                }
                path = sbPath;
            } else if (path.length > 1 && path.charAt(1) == sep) {
                // UNC drive
                var nextsep:int = path.indexOf(sep, 2);
                nextsep = path.indexOf(sep, nextsep + 1);
                root = (nextsep > 2) ? path.substring(0, nextsep + 1) : path;
                path = path.substring(root.length);
            } else {
                root = File.separator;
                path = path.substring(1);
            }
            return Vector.<String>([root, path]);
        }
        
       
        /**
         * This was originally an emulation of {@link File#getParentFile} for JDK 1.1, but it is now
         * implemented using that method (Ant 1.6.3 onwards).
         *
         * @param f the file whose parent is required.
         * @return the given file's parent, or null if the file does not have a parent.
         * @since 1.10
         * @deprecated since 1.7. Just use {@link File#getParentFile} directly.
         */
        public function getParentFile(f:File):File {
            return (f == null) ? null : f.parent;
        }
        
        /**
         * Checks whether a given file is a symbolic link.
         *
         * <p>It doesn't really test for symbolic links but whether the
         * canonical and absolute paths of the file are identical--this
         * may lead to false positives on some platforms.</p>
         *
         * @param parent the parent directory of the file to test
         * @param name the name of the file to test.
         *
         * @return true if the file is a symbolic link.
         * @throws IOException on error.
         * @since Ant 1.5
         * @deprecated use SymbolicLinkUtils instead
         */
        public function isSymbolicLink(parent:File, name:String):Boolean
        {
            if (parent == null) {
                return new File(name).isSymbolicLink;
            }
            return new File(parent.nativePath + File.separator + name).isSymbolicLink;
        }
        
        /**
         * Removes a leading path from a second path.
         *
         * @param leading The leading path, must not be null, must be absolute.
         * @param path The path to remove from, must not be null, must be absolute.
         *
         * @return path's normalized absolute if it doesn't start with
         * leading; path's path with leading's path removed otherwise.
         *
         * @since Ant 1.5
         */
        public function removeLeadingPath(leading:File, path:File):String {
            var l:String = normalize(leading.nativePath).nativePath;
            var p:String = normalize(path.nativePath).nativePath;
            if (l == p) {
                return "";
            }
            // ensure that l ends with a /
            // so we never think /foo was a parent directory of /foobar
            if (l.charAt(l.length - 1) != File.separator) {
                l += File.separator;
            }
            return (p.indexOf(l) == 0) ? p.substring(l.length) : p;
        }
        
        /**
         * Learn whether one path "leads" another.
         * @param leading The leading path, must not be null, must be absolute.
         * @param path The path to remove from, must not be null, must be absolute.
         * @return true if path starts with leading; false otherwise.
         * @since Ant 1.7
         */
        public function isLeadingPath(leading:File, path:File):Boolean {
            var l:String = normalize(leading.nativePath).nativePath;
            var p:String = normalize(path.nativePath).nativePath;
            if (l == p) {
                return true;
            }
            // ensure that l ends with a /
            // so we never think /foo was a parent directory of /foobar
            if (l.charAt(l.length - 1) != File.separator) {
                l += File.separator;
            }
            return p.indexOf(l) == 0;
        }
        
        /**
         * Compares two filenames.
         *
         * <p>Unlike java.io.File#equals this method will try to compare
         * the absolute paths and &quot;normalize&quot; the filenames
         * before comparing them.</p>
         *
         * @param f1 the file whose name is to be compared.
         * @param f2 the other file whose name is to be compared.
         *
         * @return true if the file are for the same file.
         *
         * @since Ant 1.5.3
         */
        public function fileNameEquals(f1:File, f2:File):Boolean {
            return normalize(f1.nativePath).nativePath ==
                normalize(f2.nativePath).nativePath;
        }
        
        /**
         * Are the two File instances pointing to the same object on the
         * file system?
         * @since Ant 1.8.2
         */
        public function areSame(f1:File, f2:File):Boolean {
            if (f1 == null && f2 == null) {
                return true;
            }
            if (f1 == null || f2 == null) {
                return false;
            }
            var f1Normalized:File = normalize(f1.nativePath);
            var f2Normalized:File = normalize(f2.nativePath);
            if (f1Normalized.nativePath == f2Normalized.nativePath)
                return true;
            f1Normalized.canonicalize();
            f2Normalized.canonicalize();
            return f1Normalized.nativePath == f2Normalized.nativePath;
        }
        
        /**
         * Renames a file, even if that involves crossing file system boundaries.
         *
         * <p>This will remove <code>to</code> (if it exists), ensure that
         * <code>to</code>'s parent directory exists and move
         * <code>from</code>, which involves deleting <code>from</code> as
         * well.</p>
         *
         * @param from the file to move.
         * @param to the new file name.
         *
         * @throws IOException if anything bad happens during this
         * process.  Note that <code>to</code> may have been deleted
         * already when this happens.
         *
         * @since Ant 1.6
         */
        public function rename(from:File, to:File):void {
            // identical logic lives in Move.renameFile():
            from.canonicalize()
            from = normalize(from.nativePath);
            to = normalize(to.nativePath);
            if (!from.exists) {
                Ant.currentAnt.output("Cannot rename nonexistent file " + from);
                return;
            }
            if (from.nativePath == to.nativePath) {
                Ant.currentAnt.output("Rename of " + from + " to " + to + " is a no-op.");
                return;
            }
            if (to.exists)
                to.deleteFile();
            if (to.exists && !(areSame(from, to))) {
                throw new IOException("Failed to delete " + to + " while trying to rename " + from);
            }
            var parent:File = to.parent;
            if (parent != null && !parent.exists && !parent.createDirectory()) {
                throw new IOException("Failed to create directory " + parent
                    + " while trying to rename " + from);
            }
            if (!from.moveTo(to)) {
                from.copyTo(to);
                from.deleteFile();
                if (from.exists) {
                    throw new IOException("Failed to delete " + from + " while trying to rename it.");
                }
            }
        }
        
        /**
         * Get the granularity of file timestamps. The choice is made based on OS, which is
         * incorrect--it should really be by filesystem. We do not have an easy way to probe for file
         * systems, however, so this heuristic gives us a decent default.
         *
         * @return the difference, in milliseconds, which two file timestamps must have in order for the
         *         two files to be considered to have different timestamps.
         */
        public function getFileTimestampGranularity():Number {
            if (ON_WINDOWS) {
                return NTFS_FILE_TIMESTAMP_GRANULARITY;
            }
            return UNIX_FILE_TIMESTAMP_GRANULARITY;
        }
        
        
        /**
         * Returns true if the source is older than the dest.
         * If the dest file does not exist, then the test returns false; it is
         * implicitly not up do date.
         * @param source source file (should be the older).
         * @param dest dest file (should be the newer).
         * @param granularity an offset added to the source time.
         * @return true if the source is older than the dest after accounting
         *              for granularity.
         * @since Ant 1.6.3
         */
        public function isUpToDate(source:File, dest:File, granularity:Object = null):Boolean {
            if (granularity == null)
                granularity = getFileTimestampGranularity();
            //do a check for the destination file existing
            if (!dest.exists) {
                //if it does not, then the file is not up to date.
                return false;
            }
            var sourceTime:Date = source.modificationDate;
            var destTime:Date = dest.modificationDate;
            return isUpToDateDate(sourceTime.time, destTime.time, granularity as Number);
        }
        
        /**
         * Compare two timestamps for being up to date using
         * the specified granularity.
         *
         * @param sourceTime timestamp of source file.
         * @param destTime timestamp of dest file.
         * @param granularity os/filesys granularity.
         * @return true if the dest file is considered up to date.
         */
        public function isUpToDateDate(sourceTime:Number, destTime:Number, granularity:Number = NaN):Boolean {
            if (isNaN(granularity))
                granularity = getFileTimestampGranularity();
            return destTime != -1 && destTime >= sourceTime + granularity;
        }
                
        
        /**
         * Calculates the relative path between two files.
         * <p>
         * Implementation note:<br/> This function may throw an IOException if an I/O error occurs
         * because its use of the canonical pathname may require filesystem queries.
         * </p>
         *
         * @param fromFile the <code>File</code> to calculate the path from
         * @param toFile the <code>File</code> to calculate the path to
         * @return the relative path between the files
         * @throws Exception for undocumented reasons
         * @see File#getCanonicalPath()
         *
         * @since Ant 1.7
         */
        public static function getRelativePath(fromFile:File, toFile:File):String {
            fromFile.canonicalize();
            toFile.canonicalize();
            var fromPath:String = fromFile.nativePath;
            var toPath:String = toFile.nativePath;
            
            // build the path stack info to compare
            var fromPathStack:Vector.<String> = getPathStack(fromPath);
            var toPathStack:Vector.<String> = getPathStack(toPath);
            
            if (0 < toPathStack.length && 0 < fromPathStack.length) {
                if (!fromPathStack[0] == toPathStack[0]) {
                    // not the same device (would be "" on Linux/Unix)
                    
                    return getPath(toPathStack);
                }
            } else {
                // no comparison possible
                return getPath(toPathStack);
            }
            
            var minLength:int = Math.min(fromPathStack.length, toPathStack.length);
            var same:int = 1; // Used outside the for loop
            
            // get index of parts which are equal
            for (;
                same < minLength && fromPathStack[same] == toPathStack[same];
                same++) {
                // Do nothing
            }
            
            var relativePathStack:Vector.<String> = new Vector.<String>();
            
            // if "from" part is longer, fill it up with ".."
            // to reach path which is equal to both paths
            for (var i:int = same; i < fromPathStack.length; i++) {
                relativePathStack.push("..");
            }
            
            // fill it up path with parts which were not equal
            for (i = same; i < toPathStack.length; i++) {
                relativePathStack.push(toPathStack[i]);
            }
            
            return getPath(relativePathStack);
        }
        
        /**
         * Gets all names of the path as an array of <code>String</code>s.
         *
         * @param path to get names from
         * @return <code>String</code>s, never <code>null</code>
         *
         * @since Ant 1.7
         */
        public static function getPathStack(path:String):Vector.<String> {
            var normalizedPath:String = path.replace(new RegExp(File.separator, "g"), '/');
            
            return Vector.<String>(normalizedPath.split("/"));
        }
        
        /**
         * Gets path from a <code>List</code> of <code>String</code>s.
         *
         * @param pathStack <code>List</code> of <code>String</code>s to be concated as a path.
         * @param separatorChar <code>char</code> to be used as separator between names in path
         * @return <code>String</code>, never <code>null</code>
         *
         * @since Ant 1.7
         */
        public static function getPath(pathStack:Vector.<String>, separatorChar:String = "/"):String {
            var buffer:String = ""
            
            if (pathStack.length) {
                buffer += pathStack.shift();
            }
            while (pathStack.length) {
                buffer += separatorChar;
                buffer += pathStack.shift();
            }
            return buffer;
        }
        
    }
}