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
    import org.apache.flex.ant.tags.filesetClasses.exceptions.BuildException;
    
    /**
     * Ported from org.apache.tools.ant.types.Resource.java on 12/3/13. 
     * Describes a "File-like" resource (File, ZipEntry, etc.).
     *
     * This class is meant to be used by classes needing to record path
     * and date/time information about a file, a zip entry or some similar
     * resource (URL, archive in a version control repository, ...).
     *
     * @since Ant 1.5.2
     * @see org.apache.tools.ant.types.resources.Touchable
     */
    public class FileResource extends Resource implements FileProvider
    {
        private static const FILE_UTILS:FileUtils = FileUtils.getFileUtils();

        private var file:File;
        private var baseDir:File;

        /**
         * Construct a new FileResource using the specified basedir and relative name.
         * @param b      the basedir as File.
         * @param name   the relative filename.
         */
        public function FileResource(b:File, name:String) {
            super(name);
            this.baseDir = b;
            this.file = FILE_UTILS.resolveFile(b, name);
        }

        /**
         * Set the File for this FileResource.
         * @param f the File to be represented.
         */
        public function setFile(f:File):void {
            checkAttributesAllowed();
            file = f;
            if (f != null && (getBaseDir() == null || !FILE_UTILS.isLeadingPath(getBaseDir(), f))) {
                setBaseDir(f.parent);
            }
        }
        
        /**
         * Get the file represented by this FileResource.
         * @return the File.
         */
        public function getFile():File {
            if (isReference()) {
                return FileResource(getCheckedRef()).getFile();
            }
            dieOnCircularReference();
                if (file == null) {
                    //try to resolve file set via basedir/name property setters:
                    var d:File = getBaseDir();
                    var n:String = super.getName();
                    if (n != null) {
                        setFile(FILE_UTILS.resolveFile(d, n));
                    }
                }
            return file;
        }
        
        /**
         * Set the basedir for this FileResource.
         * @param b the basedir as File.
         */
        public function setBaseDir(b:File):void {
            checkAttributesAllowed();
            baseDir = b;
        }
        
        /**
         * Return the basedir to which the name is relative.
         * @return the basedir as File.
         */
        public function getBaseDir():File {
            if (isReference()) {
                return FileResource(getCheckedRef()).getBaseDir();
            }
            dieOnCircularReference();
            return baseDir;
        }
        
        /**
         * Overrides the super version.
         * @param r the Reference to set.
         */
        override public function setRefid(r:Reference):void {
            if (file != null || baseDir != null) {
                throw tooManyAttributes();
            }
            super.setRefid(r);
        }
        
        /**
         * Get the name of this FileResource.  If the basedir is set,
         * the name will be relative to that.  Otherwise the basename
         * only will be returned.
         * @return the name of this resource.
         */
        override public function getName():String {
            if (isReference()) {
                return Resource(getCheckedRef()).getName();
            }
            var b:File = getBaseDir();
            return b == null ? getNotNullFile().name
                : FILE_UTILS.removeLeadingPath(b, getNotNullFile());
        }

        /**
         * Get the file represented by this FileResource, ensuring it is not null.
         * @return the not-null File.
         * @throws BuildException if file is null.
         */
        protected function getNotNullFile():File {
            if (getFile() == null) {
                throw new BuildException("file attribute is null!");
            }
            dieOnCircularReference();
            return getFile();
        }
        

    }
}