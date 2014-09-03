/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.adobe.ac.pmd.rules.event;

import java.util.List;

import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class EventMissingCloneFunctionRule extends AbstractEventRelatedRule
{
   private IClass classNode = null;

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.event.AbstractEventRelatedRule#findViolations(com
    * .adobe.ac.pmd.nodes.IClass)
    */
   @Override
   protected final void findViolations( final IClass classNodeToBeSet )
   {
      classNode = classNodeToBeSet;
      if ( "Event".equals( classNode.getExtensionName() ) )
      {
         super.findViolations( classNode );
      }
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(java.util
    * .List)
    */
   @Override
   protected final void findViolations( final List< IFunction > functions )
   {
      boolean cloneFound = false;

      for ( final IFunction functionNode : functions )
      {
         if ( "clone".equals( functionNode.getName() ) )
         {
            cloneFound = true;
            break;
         }
      }
      if ( !cloneFound )
      {
         addViolation( classNode );
      }
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#getDefaultPriority()
    */
   @Override
   protected final ViolationPriority getDefaultPriority()
   {
      return ViolationPriority.HIGH;
   }
}
