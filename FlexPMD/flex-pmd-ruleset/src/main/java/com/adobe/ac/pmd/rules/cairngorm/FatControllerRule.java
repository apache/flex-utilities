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
package com.adobe.ac.pmd.rules.cairngorm;

import java.util.List;

import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IPackage;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class FatControllerRule extends AbstractAstFlexRule // NO_UCD
{
   private static final int DEFAULT_THRESHOLD = 5;

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#isConcernedByTheCurrentFile
    * ()
    */
   @Override
   public final boolean isConcernedByTheCurrentFile()
   {
      return getCurrentFile().getClassName().endsWith( "Controller.as" );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IPackage)
    */
   @Override
   protected final void findViolations( final IPackage packageNode )
   {
      final IClass classNode = packageNode.getClassNode();

      if ( classNode != null )
      {
         final int commandsCount = computeCommandsCountInImport( packageNode.getImports() );
         final int methodsCount = classNode.getFunctions().size();

         if ( methodsCount > 0
               && commandsCount
                     / methodsCount > DEFAULT_THRESHOLD )
         {
            addViolation( classNode );
         }
      }
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#getDefaultPriority()
    */
   @Override
   protected final ViolationPriority getDefaultPriority()
   {
      return ViolationPriority.NORMAL;
   }

   private int computeCommandsCountInImport( final List< IParserNode > imports )
   {
      int commandImport = 0;

      if ( imports != null )
      {
         for ( final IParserNode importNode : imports )
         {
            if ( importNode.getStringValue().endsWith( "Command" ) )
            {
               commandImport++;
            }
         }
      }
      return commandImport;
   }
}
