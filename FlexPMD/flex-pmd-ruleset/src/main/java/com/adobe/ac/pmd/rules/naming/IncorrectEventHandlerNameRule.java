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
package com.adobe.ac.pmd.rules.naming;

import java.util.LinkedHashMap;
import java.util.Map;

import net.sourceforge.pmd.PropertyDescriptor;
import net.sourceforge.pmd.properties.StringProperty;

import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

public class IncorrectEventHandlerNameRule extends AbstractAstFlexRule
{
   private static final String DEFAULT_PREFIX = "on";
   private static final String DEFAULT_SUFFIX = "";
   private static final String PREFIX_NAME    = "prefix";
   private static final String SUFFIX_NAME    = "suffix";
   private final String        prefix;
   private final String        suffix;

   public IncorrectEventHandlerNameRule()
   {
      super();
      prefix = getStringProperty( propertyDescriptorFor( PREFIX_NAME ) );
      suffix = getStringProperty( propertyDescriptorFor( SUFFIX_NAME ) );
   }

   @Override
   protected void findViolations( final IFunction function )
   {
      if ( function.isEventHandler()
            && !( function.getName().startsWith( prefix ) && function.getName().endsWith( suffix ) ) )
      {
         final IParserNode name = getNameFromFunctionDeclaration( function.getInternalNode() );

         addViolation( name,
                       name.getStringValue(),
                       prefix,
                       suffix );
      }
   }

   @Override
   protected ViolationPriority getDefaultPriority()
   {
      return ViolationPriority.LOW;
   }

   @Override
   protected final Map< String, PropertyDescriptor > propertiesByName()
   {
      final Map< String, PropertyDescriptor > properties = new LinkedHashMap< String, PropertyDescriptor >();

      properties.put( PREFIX_NAME,
                      new StringProperty( PREFIX_NAME, "", DEFAULT_PREFIX, properties.size() ) );
      properties.put( SUFFIX_NAME,
                      new StringProperty( SUFFIX_NAME, "", DEFAULT_SUFFIX, properties.size() ) );

      return properties;
   }
}
