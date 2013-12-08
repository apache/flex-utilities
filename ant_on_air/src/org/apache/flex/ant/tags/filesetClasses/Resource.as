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
    import flash.filesystem.FileStream;
    import org.apache.flex.ant.tags.filesetClasses.exceptions.UnsupportedOperationException;
    
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
    public class Resource extends DataType
    {
        
        /** Constant unknown size */
        public static const UNKNOWN_SIZE:int = -1;
        
        /** Constant unknown datetime for getLastModified */
        public static const UNKNOWN_DATETIME:int = 0;
                
        private var name:String;
        private var exists:Boolean = true;
        private var lastmodified:Number;
        private var directory:Boolean;
        private var _size:int;
        private var nameSet:Boolean;
        private var existsSet:Boolean;
        private var lastmodifiedSet:Boolean;
        private var directorySet:Boolean;
        private var sizeSet:Boolean;
        
        
        /**
         * Sets the name, lastmodified flag, exists flag, directory flag, and size.
         *
         * @param name relative path of the resource.  Expects
         * &quot;/&quot; to be used as the directory separator.
         * @param exists if true the resource exists
         * @param lastmodified the last modification time of the resource
         * @param directory    if true, this resource is a directory
         * @param size the size of this resource.
         */
        public function Resource(name:String, exists:Boolean  = false, lastmodified:Number = NaN, 
                            directory:Boolean = false, size:int = UNKNOWN_SIZE) {
            this.name = name;
            setName(name);
            setExists(exists);
            setLastModified(lastmodified);
            setDirectory(directory);
            setSize(size);
        }
        
        /**
         * Name attribute will contain the path of a file relative to the
         * root directory of its fileset or the recorded path of a zip
         * entry.
         *
         * <p>example for a file with fullpath /var/opt/adm/resource.txt
         * in a file set with root dir /var/opt it will be
         * adm/resource.txt.</p>
         *
         * <p>&quot;/&quot; will be used as the directory separator.</p>
         * @return the name of this resource.
         */
        public function getName():String  
        {
            return isReference() ? Resource(getCheckedRef()).getName() : name;
        }
        
        /**
         * Set the name of this Resource.
         * @param name relative path of the resource.  Expects
         * &quot;/&quot; to be used as the directory separator.
         */
        public function setName(name:String):void 
        {
            checkAttributesAllowed();
            this.name = name;
            nameSet = true;
        }
        
        /**
         * The exists attribute tells whether a resource exists.
         * @return true if this resource exists.
         */
        public function isExists():Boolean 
        {
            if (isReference()) {
                return Resource(getCheckedRef()).isExists();
            }
            //default true:
            return exists;
        }
        
        /**
         * Set the exists attribute.
         * @param exists if true, this resource exists.
         */
        public function setExists(exists:Boolean):void 
        {
            checkAttributesAllowed();
            this.exists = exists;
            existsSet = true;
        }
        
        /**
         * Tells the modification time in milliseconds since 01.01.1970 (the "epoch").
         *
         * @return the modification time, if that is meaningful
         *            (e.g. for a file resource which exists);
         *         0 if the resource does not exist, to mirror the behavior
         *         of {@link java.io.File#lastModified};
         *         or 0 if the notion of modification time is meaningless for this class
         *           of resource (e.g. an inline string)
         */
        public function getLastModified():Number
        {
            if (isReference()) {
                return Resource(getCheckedRef()).getLastModified();
            }
            if (!isExists() || !lastmodifiedSet) {
                return UNKNOWN_DATETIME;
            }
            var result:Number = lastmodified;
            return result < UNKNOWN_DATETIME ? UNKNOWN_DATETIME : result;
        }
        
        /**
         * Set the last modification attribute.
         * @param lastmodified the modification time in milliseconds since 01.01.1970.
         */
        public function setLastModified(lastmodified:Number):void 
        {
            checkAttributesAllowed();
            this.lastmodified = lastmodified;
            lastmodifiedSet = true;
        }
        
        /**
         * Tells if the resource is a directory.
         * @return boolean flag indicating if the resource is a directory.
         */
        public function isDirectory():Boolean 
        {
            if (isReference()) {
                return Resource(getCheckedRef()).isDirectory();
            }
            //default false:
            return directory;
        }
        
        /**
         * Set the directory attribute.
         * @param directory if true, this resource is a directory.
         */
        public function setDirectory(directory:Boolean):void
        {
            checkAttributesAllowed();
            this.directory = directory;
            directorySet = true;
        }
        
        /**
         * Set the size of this Resource.
         * @param size the size, as a long.
         * @since Ant 1.6.3
         */
        public function setSize(size:int):void 
        {
            checkAttributesAllowed();
            _size = size > UNKNOWN_SIZE ? size : UNKNOWN_SIZE;
            sizeSet = true;
        }
        
        /**
         * Get the size of this Resource.
         * @return the size, as a long, 0 if the Resource does not exist (for
         *         compatibility with java.io.File), or UNKNOWN_SIZE if not known.
         * @since Ant 1.6.3
         */
        public function getSize():int 
        {
            if (isReference()) {
                return Resource(getCheckedRef()).getSize();
            }
            return isExists()
            ? (sizeSet ? _size : UNKNOWN_SIZE)
                : 0;
        }
                
        /**
         * Delegates to a comparison of names.
         * @param other the object to compare to.
         * @return a negative integer, zero, or a positive integer as this Resource
         *         is less than, equal to, or greater than the specified Resource.
         * @since Ant 1.6
         */
        public function compareTo(other:Resource):int {
            if (isReference()) {
                return Resource(getCheckedRef()).compareTo(other);
            }
            return toString().localeCompare(other.toString());
        }
        
        /**
         * Implement basic Resource equality.
         * @param other the object to check against.
         * @return true if the specified Object is equal to this Resource.
         * @since Ant 1.7
         */
        public function equals(other:Object):Boolean {
            if (isReference()) {
                return getCheckedRef().equals(other);
            }
            return compareTo(Resource(other)) == 0;
        }
               
        /**
         * Get an InputStream for the Resource.
         * @return an InputStream containing this Resource's content.
         * @throws IOException if unable to provide the content of this
         *         Resource as a stream.
         * @throws UnsupportedOperationException if InputStreams are not
         *         supported for this Resource type.
         * @since Ant 1.7
         */
        public function getInputStream():FileStream
        {
            if (isReference()) {
                return Resource(getCheckedRef()).getInputStream();
            }
            throw new UnsupportedOperationException();
        }
        
        /**
         * Get an OutputStream for the Resource.
         * @return an OutputStream to which content can be written.
         * @throws IOException if unable to provide the content of this
         *         Resource as a stream.
         * @throws UnsupportedOperationException if OutputStreams are not
         *         supported for this Resource type.
         * @since Ant 1.7
         */
        public function getOutputStream():FileStream
        {
            if (isReference()) {
                return Resource(getCheckedRef()).getOutputStream();
            }
            throw new UnsupportedOperationException();
        }
        
        /**
         * Fulfill the ResourceCollection contract.
         * @return an Iterator of Resources.
         * @since Ant 1.7
         */
        public function iterator():Vector.<Resource> 
        {
            return isReference() ? Resource(getCheckedRef()).iterator()
            : Vector.<Resource>([this]);
        }
        
        /**
         * Fulfill the ResourceCollection contract.
         * @return the size of this ResourceCollection.
         * @since Ant 1.7
         */
        public function size():int {
            return isReference() ? Resource(getCheckedRef()).size() : 1;
        }
        
        /**
         * Fulfill the ResourceCollection contract.
         * @return whether this Resource is a FileProvider.
         * @since Ant 1.7
         */
        public function isFilesystemOnly():Boolean 
        {
            return (isReference() && Resource(getCheckedRef()).isFilesystemOnly())
            || this is FileProvider;
                }
        
        /**
         * Get the string representation of this Resource.
         * @return this Resource formatted as a String.
         * @since Ant 1.7
         */
        override public function toString():String 
        {
            if (isReference()) {
                return getCheckedRef().toString();
            }
            var n:String = getName();
            return n == null ? "(anonymous)" : n;
        }
        
        /**
         * Get a long String representation of this Resource.
         * This typically should be the value of <code>toString()</code>
         * prefixed by a type description.
         * @return this Resource formatted as a long String.
         * @since Ant 1.7
         */
        public function toLongString():String 
        {
            return isReference() ? Resource(getCheckedRef()).toLongString()
            : getDataTypeName() + " \"" + toString() + '"';
        }
        
        /**
         * Overrides the base version.
         * @param r the Reference to set.
         */
        override public function setRefid(r:Reference):void 
        {
            if (nameSet
                || existsSet
                || lastmodifiedSet
                || directorySet
                || sizeSet) {
                throw tooManyAttributes();
            }
            super.setRefid(r);
        }
        
    }
}