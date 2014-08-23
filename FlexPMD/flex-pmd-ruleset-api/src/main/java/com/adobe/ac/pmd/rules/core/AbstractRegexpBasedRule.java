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

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.adobe.ac.pmd.IFlexViolation;

/**
 * @author xagnetti
 */
public abstract class AbstractRegexpBasedRule extends AbstractFlexRule
{
   private Pattern pattern;

   /**
    * 
    */
   public AbstractRegexpBasedRule()
   {
      super();
      compilePattern();
   }

   /**
    * 
    */
   public final void compilePattern()
   {
      pattern = Pattern.compile( getRegexp() );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractFlexRule#findViolationsInCurrentFile()
    */
   @Override
   public final List< IFlexViolation > findViolationsInCurrentFile()
   {
      final List< IFlexViolation > violations = new ArrayList< IFlexViolation >();

      if ( "".compareTo( getRegexp() ) != 0 )
      {
         for ( int i = 1; i <= getCurrentFile().getLinesNb(); i++ )
         {
            final String line = getCurrentFile().getLineAt( i );

            if ( isCurrentLineConcerned( line )
                  && doesCurrentLineMacthes( line ) && isViolationDetectedOnThisMatchingLine( line )
                  && !line.contains( "/*" ) && !line.contains( "//" ) )
            {
               addViolation( violations,
                             ViolationPosition.create( i,
                                                       i,
                                                       0,
                                                       line.length() ) );
            }
         }
      }
      return violations;
   }

   /**
    * @param line
    * @return
    */
   final boolean doesCurrentLineMacthes( final String line )
   {
      return getMatcher( line ).matches();
   }

   /**
    * @param line
    * @return
    */
   protected final Matcher getMatcher( final String line )
   {
      final Matcher matcher = pattern.matcher( line );

      return matcher;
   }

   /**
    * @return
    */
   protected abstract String getRegexp();

   protected boolean isCurrentLineConcerned( final String line )
   {
      return true;
   }

   /**
    * @param line
    * @return
    */
   protected abstract boolean isViolationDetectedOnThisMatchingLine( final String line );
}