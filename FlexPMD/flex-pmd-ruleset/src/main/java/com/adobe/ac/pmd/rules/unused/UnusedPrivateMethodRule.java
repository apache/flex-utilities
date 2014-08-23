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
package com.adobe.ac.pmd.rules.unused;

import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.adobe.ac.pmd.files.IAs3File;
import com.adobe.ac.pmd.nodes.IAttribute;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IConstant;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.nodes.IVariable;
import com.adobe.ac.pmd.nodes.Modifier;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class UnusedPrivateMethodRule extends AbstractAstFlexRule
{
   private Map< String, IFunction > privateFunctions = null;

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IClass)
    */
   @Override
   protected final void findViolations( final IClass classNode )
   {
      fillPrivateFunctions( classNode.getFunctions() );
      findUnusedFunction( classNode.getBlock() );

      super.findViolations( classNode );

      addViolations();
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
      super.findViolations( functions );

      for ( final IFunction function : functions )
      {
         findUnusedFunction( function.getBody() );
      }
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolationsFromAttributes
    * (java.util.List)
    */
   @Override
   protected void findViolationsFromAttributes( final List< IAttribute > variables )
   {
      super.findViolationsFromAttributes( variables );

      findViolationsFromVariables( variables );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolationsFromConstants
    * (java.util.List)
    */
   @Override
   protected void findViolationsFromConstants( final List< IConstant > constants )
   {
      super.findViolationsFromConstants( constants );

      findViolationsFromVariables( constants );
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

   private void addViolations()
   {
      final Set< Integer > ignoredLines = new HashSet< Integer >();

      for ( final String functionName : privateFunctions.keySet() )
      {
         final IFunction function = privateFunctions.get( functionName );
         ignoredLines.clear();
         ignoredLines.add( getNameFromFunctionDeclaration( function.getInternalNode() ).getLine() );

         if ( getCurrentFile() instanceof IAs3File
               || !getCurrentFile().contains( functionName,
                                              ignoredLines ) )
         {
            addViolation( function );
         }
      }
   }

   private void fillPrivateFunctions( final List< IFunction > functions )
   {
      privateFunctions = new LinkedHashMap< String, IFunction >();

      for ( final IFunction function : functions )
      {
         if ( function.is( Modifier.PRIVATE ) )
         {
            privateFunctions.put( function.getName(),
                                  function );
         }
      }
   }

   private void findUnusedFunction( final IParserNode body )
   {
      if ( body != null )
      {
         if ( body.getStringValue() != null )
         {
            for ( final String functionName : privateFunctions.keySet() )
            {
               if ( body.getStringValue().equals( functionName ) )
               {
                  privateFunctions.remove( functionName );
                  break;
               }
            }
         }
         if ( body.numChildren() != 0 )
         {
            for ( final IParserNode child : body.getChildren() )
            {
               findUnusedFunction( child );
            }
         }
      }
   }

   private void findViolationsFromVariables( final List< ? extends IVariable > variables )
   {
      for ( final IVariable constant : variables )
      {
         if ( constant.getInitializationExpression() != null )
         {
            findUnusedFunction( constant.getInitializationExpression().getInternalNode() );
         }
      }
   }
}
