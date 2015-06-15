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
    import org.apache.flex.ant.tags.Project;
    import org.apache.flex.ant.tags.filesetClasses.exceptions.BuildException;

    /**
     * Ported from org.apache.tools.ant.types.Reference.java on 12/3/13. 
     * Class to hold a reference to another object in the project.
     *
     */
    public class Reference {
    
        private var refid:String;
        private var project:Project;
    
        /**
         * Create a reference to a named ID in a particular project.
         * @param p the project this reference is associated with
         * @param id the name of this reference
         * @since Ant 1.6.3
         */
        public function Reference(p:Project, id:String) {
            setRefId(id);
            setProject(p);
        }
    
        /**
         * Set the reference id. Should not normally be necessary;
         * use {@link Reference#Reference(Project, String)}.
         * @param id the reference id to use
         */
        public function setRefId(id:String):void {
            refid = id;
        }
    
        /**
         * Get the reference id of this reference.
         * @return the reference id
         */
        public function getRefId():String {
            return refid;
        }
    
        /**
         * Set the associated project. Should not normally be necessary;
         * use {@link Reference#Reference(Project,String)}.
         * @param p the project to use
         * @since Ant 1.6.3
         */
        public function setProject(p:Project):void {
            this.project = p;
        }
    
        /**
         * Get the associated project, if any; may be null.
         * @return the associated project
         * @since Ant 1.6.3
         */
        public function getProject():Project {
            return project;
        }
    
        /**
         * Resolve the reference, using the associated project if
         * it set, otherwise use the passed in project.
         * @param fallback the fallback project to use if the project attribute of
         *                 reference is not set.
         * @return the dereferenced object.
         * @throws BuildException if the reference cannot be dereferenced.
         */
        public function getReferencedObject(fallback:Project = null):Object {
            if (refid == null) {
                throw new BuildException("No reference specified");
            }
            if (fallback == null)
            {
                if (project == null) {
                    throw new BuildException("No project set on reference to " + refid);
                }
            }    
            
            var o:Object = project == null ? fallback.getReference(refid) : project.getReference(refid);
            if (o == null) {
                throw new BuildException("Reference " + refid + " not found.");
            }
            return o;
        }
    }
}