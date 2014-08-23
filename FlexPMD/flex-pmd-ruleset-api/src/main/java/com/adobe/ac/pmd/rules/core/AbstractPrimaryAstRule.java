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
package com.adobe.ac.pmd.rules.core;

import java.util.List;

import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.parser.IParserNode;

/**
 * Abstract rule which find a primary (or a couple of primaries) in a body
 * function.
 * 
 * @author xagnetti
 */
public abstract class AbstractPrimaryAstRule extends AbstractAstFlexRule
{
   /**
    * @param statement
    * @param function
    */
   protected abstract void addViolation( IParserNode statement,
                                         IFunction function );

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IFunction)
    */
   @Override
   protected final void findViolations( final IFunction function )
   {
      final List< IParserNode > firstStatements = function.findPrimaryStatementsInBody( getFirstPrimaryToFind() );
      if ( !firstStatements.isEmpty() )
      {
         for ( final IParserNode firstStatement : firstStatements )
         {
            if ( getSecondPrimaryToFind() == null )
            {
               addViolation( firstStatement,
                             function );
            }
            else
            {
               final List< IParserNode > secondStatements = function.findPrimaryStatementsInBody( getSecondPrimaryToFind() );
               if ( !secondStatements.isEmpty() )
               {
                  for ( final IParserNode secondStatement : secondStatements )
                  {
                     addViolation( secondStatement,
                                   function );
                  }
               }
            }
         }
      }
   }

   /**
    * @return
    */
   protected abstract String getFirstPrimaryToFind();

   /**
    * @return
    */
   protected String getSecondPrimaryToFind()
   {
      return null;
   }
}