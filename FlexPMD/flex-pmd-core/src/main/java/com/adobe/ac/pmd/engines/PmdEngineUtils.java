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
package com.adobe.ac.pmd.engines;

import java.text.MessageFormat;
import java.util.List;
import java.util.Map.Entry;

import com.adobe.ac.pmd.FlexPmdViolations;
import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

public final class PmdEngineUtils
{
   public static String findFirstViolationError( final FlexPmdViolations violations )
   {
      final StringBuffer buffer = new StringBuffer();
      final String message = "An error violation has been found on the file {0} at "
            + "line {1}, with the rule \"{2}\": {3}";
      final MessageFormat form = new MessageFormat( message );

      for ( final Entry< IFlexFile, List< IFlexViolation >> violatedFile : violations.getViolations()
                                                                                     .entrySet() )
      {
         for ( final IFlexViolation violation : violatedFile.getValue() )
         {
            if ( violation.getRule().getPriority() == Integer.parseInt( ViolationPriority.HIGH.toString() ) )
            {
               final String[] formatArgument = computeArgumentFormat( violation );
               buffer.append( form.format( formatArgument ) );
               buffer.append( '\n' );
            }
         }
      }
      return buffer.toString();
   }

   private static String[] computeArgumentFormat( final IFlexViolation violation )
   {
      final String[] formatArgument = new String[]
      { violation.getFilename(),
                  String.valueOf( violation.getBeginLine() ),
                  violation.getRule().getRuleClass(),
                  violation.getRuleMessage() };
      return formatArgument;
   }

   private PmdEngineUtils()
   {
   }
}
