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
    import flash.system.ApplicationDomain;
    import flash.utils.getQualifiedClassName;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.Project;
    import org.apache.flex.ant.tags.filesetClasses.exceptions.BuildException;
    
    /**
     * Ported from org.apache.tools.ant.types.DataType.java on 12/3/13 
     * Base class for those classes that can appear inside the build file
     * as stand alone data types.
     *
     * <p>This class handles the common description attribute and provides
     * a default implementation for reference handling and checking for
     * circular references that is appropriate for types that can not be
     * nested inside elements of the same type (i.e. &lt;patternset&gt;
     * but not &lt;path&gt;).</p>
     *
     */
    public class DataType 
    {
        // CheckStyle:VisibilityModifier OFF
        
        /**
         * Value to the refid attribute.
         *
         * @deprecated since 1.7.
         *             The user should not be directly referencing
         *             variable. Please use {@link #getRefid} instead.
         */
        protected var ref:Reference;
        
        /**
         * Are we sure we don't hold circular references?
         *
         * <p>Subclasses are responsible for setting this value to false
         * if we'd need to investigate this condition (usually because a
         * child element has been added that is a subclass of
         * DataType).</p>
         *
         * @deprecated since 1.7.
         *             The user should not be directly referencing
         *             variable. Please use {@link #setChecked} or
         *             {@link #isChecked} instead.
         */
        protected var checked:Boolean = true;
        // CheckStyle:VisibilityModifier ON
        
        /**
         * Has the refid attribute of this element been set?
         * @return true if the refid attribute has been set
         */
        public function isReference():Boolean  
        {
            return ref != null;
        }
        
        /**
         * Set the value of the refid attribute.
         *
         * <p>Subclasses may need to check whether any other attributes
         * have been set as well or child elements have been created and
         * thus override this method. if they do the must call
         * <code>super.setRefid</code>.</p>
         * @param ref the reference to use
         */
        public function setRefid(ref:Reference):void
        {
            this.ref = ref;
            checked = false;
        }
        
        /**
         * Gets as descriptive as possible a name used for this datatype instance.
         * @return <code>String</code> name.
         */
        protected function getDataTypeName():String
        {
            return "DataType";
        }
                
        /**
         * Check to see whether any DataType we hold references to is
         * included in the Stack (which holds all DataType instances that
         * directly or indirectly reference this instance, including this
         * instance itself).
         *
         * <p>If one is included, throw a BuildException created by {@link
         * #circularReference circularReference}.</p>
         *
         * <p>This implementation is appropriate only for a DataType that
         * cannot hold other DataTypes as children.</p>
         *
         * <p>The general contract of this method is that it shouldn't do
         * anything if {@link #checked <code>checked</code>} is true and
         * set it to true on exit.</p>
         * @param stack the stack of references to check.
         * @param project the project to use to dereference the references.
         * @throws BuildException on error.
         */
        protected function dieOnCircularReference(stack:Vector.<String> = null, project:Project = null):void
        {
            if (!project)
                project = Ant.currentAnt.project;
            
            if (!stack)
                stack = new Vector.<String>();
            
            if (checked || !isReference()) {
                return;
            }
            var o:Object = ref.getReferencedObject(project);
            
            if (o is DataType) {                
                if (stack.indexOf(o) != -1) {
                    throw circularReference();
                } else {
                    stack.push(o);
                    DataType(o).dieOnCircularReference(Vector.<String>([id]), project);
                    stack.pop();
                }
            }
            checked = true;
        }
        
        /**
         * Allow DataTypes outside org.apache.tools.ant.types to indirectly call
         * dieOnCircularReference on nested DataTypes.
         * @param dt the DataType to check.
         * @param stk the stack of references to check.
         * @param p the project to use to dereference the references.
         * @throws BuildException on error.
         * @since Ant 1.7
         */
        public static function invokeCircularReferenceCheck(dt:DataType, stk:Vector.<String>,
             p:Project):void 
        {
                dt.dieOnCircularReference(stk, p);
        }
        
        /**
         * Allow DataTypes outside org.apache.tools.ant.types to indirectly call
         * dieOnCircularReference on nested DataTypes.
         *
         * <p>Pushes dt on the stack, runs dieOnCircularReference and pops
         * it again.</p>
         * @param dt the DataType to check.
         * @param stk the stack of references to check.
         * @param p the project to use to dereference the references.
         * @throws BuildException on error.
         * @since Ant 1.8.0
         */
        public static function pushAndInvokeCircularReferenceCheck(dt:DataType,
            stk:Vector.<String>,
            p:Project):void 
        {
                stk.push(dt);
                dt.dieOnCircularReference(stk, p);
                stk.pop();
        }
        
        /**
         * Performs the check for circular references and returns the
         * referenced object.
         * @param p the Ant Project instance against which to resolve references.
         * @return the dereferenced object.
         * @throws BuildException if the reference is invalid (circular ref, wrong class, etc).
         * @since Ant 1.7
         */
        protected function getCheckedRef(p:Project = null):Object 
        {
            if (!p)
                p = Ant.currentAnt.project;
            return getCheckedRefActual(Class(ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(this))), 
                    getDataTypeName(), p);
        }

        /**
         * Performs the check for circular references and returns the
         * referenced object.  This version allows the fallback Project instance to be specified.
         * @param requiredClass the class that this reference should be a subclass of.
         * @param dataTypeName  the name of the datatype that the reference should be
         *                      (error message use only).
         * @param project       the fallback Project instance for dereferencing.
         * @return the dereferenced object.
         * @throws BuildException if the reference is invalid (circular ref, wrong class, etc),
         *                        or if <code>project</code> is <code>null</code>.
         * @since Ant 1.7
         */
        protected function getCheckedRefActual(requiredClass:Class,
            dataTypeName:String, project:Project):Object {
                if (project == null) {
                    throw new BuildException("No Project specified");
                }
                dieOnCircularReference(null, project);
                var o:Object = ref.getReferencedObject(project);
                var oClass:Class = ApplicationDomain.currentDomain.getDefinition(getQualifiedClassName(o)) as Class;
                if (!(requiredClass is oClass)) {
                    Ant.log("Class " + oClass + " is not a subclass of " + requiredClass,
                        Project.MSG_VERBOSE);
                    var msg:String = ref.getRefId() + " doesn\'t denote a " + dataTypeName;
                    throw new BuildException(msg);
                }
                return o;
            }

        /**
         * Creates an exception that indicates that refid has to be the
         * only attribute if it is set.
         * @return the exception to throw
         */
        protected function tooManyAttributes():BuildException 
        {
            return new BuildException("You must not specify more than one "
                + "attribute when using refid");
        }
        
        /**
         * Creates an exception that indicates that this XML element must
         * not have child elements if the refid attribute is set.
         * @return the exception to throw
         */
        protected function noChildrenAllowed():BuildException 
        {
            return new BuildException("You must not specify nested elements "
                + "when using refid");
        }
        
        /**
         * Creates an exception that indicates the user has generated a
         * loop of data types referencing each other.
         * @return the exception to throw
         */
        protected function circularReference():BuildException
        {
            return new BuildException("This data type contains a circular "
                + "reference.");
        }
        
        /**
         * The flag that is used to indicate that circular references have been checked.
         * @return true if circular references have been checked
         */
        protected function isChecked():Boolean 
        {
            return checked;
        }
        
        /**
         * Set the flag that is used to indicate that circular references have been checked.
         * @param checked if true, if circular references have been checked
         */
        protected function setChecked(checked:Boolean):void 
        {
            this.checked = checked;
        }
        
        /**
         * get the reference set on this object
         * @return the reference or null
         */
        public function getRefid():Reference 
        {
            return ref;
        }
        
        /**
         * check that it is ok to set attributes, i.e that no reference is defined
         * @since Ant 1.6
         * @throws BuildException if not allowed
         */
        protected function checkAttributesAllowed():void  
        {
            if (isReference()) {
                throw tooManyAttributes();
            }
        }
        
        /**
         * check that it is ok to add children, i.e that no reference is defined
         * @since Ant 1.6
         * @throws BuildException if not allowed
         */
        protected function checkChildrenAllowed():void 
        {
            if (isReference()) {
                throw noChildrenAllowed();
            }
        }
        
        /**
         * Basic DataType toString().
         * @return this DataType formatted as a String.
         */
        public function toString():String {
            var d:String = getDescription();
            return d == null ? getDataTypeName() : getDataTypeName() + " " + d;
        }
        
        /**
         * Basic description
         */
        public function getDescription():String
        {
            return null;
        }
        
        public var id:String;
    }
}   
