////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package com.adobe.ac.pmd.rules.style;

import java.util.ArrayList;
import java.util.List;

import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.files.IAs3File;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.files.IMxmlFile;
import com.adobe.ac.pmd.rules.core.AbstractFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPosition;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class CopyrightMissingRule extends AbstractFlexRule
{
   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractFlexRule#isConcernedByTheCurrentFile()
    */
   @Override
   public final boolean isConcernedByTheCurrentFile()
   {
      return true;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractFlexRule#findViolationsInCurrentFile()
    */
   @Override
   protected final List< IFlexViolation > findViolationsInCurrentFile()
   {
      final List< IFlexViolation > violations = new ArrayList< IFlexViolation >();
      final IFlexFile currentFile = getCurrentFile();

      if ( currentFile.getLinesNb() == 1 )
      {
         addViolation( violations );
      }
      else if ( currentFile.getLinesNb() > 1 )
      {
         final String commentOpeningTag = currentFile.getCommentOpeningTag();
         final String firstLine = currentFile.getLineAt( 1 );
         final String secondLine = currentFile.getLineAt( 2 );

         if ( !firstLine.startsWith( commentOpeningTag )
               && !( currentFile instanceof IMxmlFile && secondLine.contains( commentOpeningTag ) )
               && !( currentFile instanceof IAs3File && firstLine.contains( currentFile.getSingleLineComment() ) ) )
         {
            addViolation( violations );
         }
      }

      return violations;
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

   private void addViolation( final List< IFlexViolation > violations )
   {
      addViolation( violations,
                    new ViolationPosition( -1 ) );
   }
}
