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

import org.apache.commons.lang.StringUtils;

import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IField;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class BadCairngormEventNameFormatRule extends AbstractAstFlexRule // NO_UCD
{
   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#isConcernedByTheCurrentFile
    * ()
    */
   @Override
   public final boolean isConcernedByTheCurrentFile()
   {
      return getCurrentFile().getClassName().endsWith( "Event.as" );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IClass)
    */
   @Override
   protected final void findViolations( final IClass classNode )
   {
      if ( isExtendedClassCairngormEvent( classNode ) )
      {
         final String eventName = extractEventName( classNode );

         if ( StringUtils.isEmpty( eventName )
               || !eventName.contains( "." ) )
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

   private String extractEventName( final IClass classNode )
   {
      String eventName = "";

      for ( final IField constantNode : classNode.getConstants() )
      {
         if ( constantNode.getName().startsWith( "EVENT" ) )
         {
            eventName = extractEventNameFromConstant( constantNode.getInitializationExpression()
                                                                  .getInternalNode() );
         }
      }
      if ( StringUtils.isEmpty( eventName )
            && classNode.getConstructor() != null )
      {
         eventName = extractEventNameFromConstructor( classNode.getConstructor() );
      }
      return eventName;
   }

   private String extractEventNameFromConstant( final IParserNode initExpressionNode )
   {
      return initExpressionNode.getChild( 0 ).getStringValue();
   }

   private String extractEventNameFromConstructor( final IFunction constructor )
   {
      String eventName = "";
      final IParserNode superCall = constructor.getSuperCall();

      if ( superCall != null )
      {
         eventName = superCall.getChild( 1 ).getChild( 0 ).getStringValue();
      }
      return eventName;
   }

   private boolean isExtendedClassCairngormEvent( final IClass classNode )
   {
      return classNode.getExtensionName() != null
            && classNode.getExtensionName().contains( "Cairngorm" )
            && classNode.getExtensionName().contains( "Event" );
   }
}
