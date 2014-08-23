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
package com.adobe.ac.pmd.rules.architecture;

import org.apache.commons.lang.StringUtils;

import com.adobe.ac.pmd.nodes.IPackage;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class UseInternalClassOutsideApiClass extends AbstractAstFlexRule
{
   private static final String API_PACKAGE_NAME      = "api";
   private static final String INTERNAL_PACKAGE_NAME = "restricted";
   private static final String PACKAGE_SEPARATOR     = ".";

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IPackage)
    */
   @Override
   protected final void findViolations( final IPackage packageNode )
   {
      final String packageName = packageNode.getName();
      final boolean isApiClass = isApiClass( packageName );
      final boolean isInternalClass = isInternalClass( packageName );
      String functionAreaName = null;

      if ( isApiClass
            || isInternalClass )
      {
         functionAreaName = extractFunctionalArea( packageName,
                                                   false );
      }
      for ( final IParserNode importNode : packageNode.getImports() )
      {
         final String importName = importNode.getStringValue();
         final String importFunctionalArea = extractFunctionalArea( importName,
                                                                    true );

         if ( doesLineContainPackageReference( importName,
                                               INTERNAL_PACKAGE_NAME )
               && ( functionAreaName == null || !functionAreaName.equals( importFunctionalArea ) ) )
         {
            addViolation( importNode,
                          importName,
                          importFunctionalArea );
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
      return ViolationPriority.HIGH;
   }

   private boolean doesLineContainPackageReference( final String line,
                                                    final String packageName )
   {
      return line.contains( PACKAGE_SEPARATOR
            + packageName );
   }

   private String extractFunctionalArea( final String packageName,
                                         final boolean isInImport )
   {
      if ( packageName.contains( INTERNAL_PACKAGE_NAME ) )
      {
         return extractFunctionArea( packageName,
                                     INTERNAL_PACKAGE_NAME,
                                     isInImport );
      }
      return extractFunctionArea( packageName,
                                  API_PACKAGE_NAME,
                                  isInImport );
   }

   private String extractFunctionArea( final String packageName,
                                       final String visibilityPackageName,
                                       final boolean isInImport )
   {
      return StringUtils.substringAfterLast( StringUtils.substringBeforeLast( packageName,
                                                                              PACKAGE_SEPARATOR
                                                                                    + visibilityPackageName
                                                                                    + ( isInImport ? PACKAGE_SEPARATOR
                                                                                                  : "" ) ),
                                             PACKAGE_SEPARATOR );
   }

   private boolean isApiClass( final String packageName )
   {
      return doesLineContainPackageReference( packageName,
                                              API_PACKAGE_NAME );
   }

   private boolean isInternalClass( final String packageName )
   {
      return doesLineContainPackageReference( packageName,
                                              INTERNAL_PACKAGE_NAME );
   }
}
