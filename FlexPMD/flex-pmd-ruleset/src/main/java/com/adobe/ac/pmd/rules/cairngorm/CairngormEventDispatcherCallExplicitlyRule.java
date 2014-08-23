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

import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.rules.core.AbstractPrimaryAstRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class CairngormEventDispatcherCallExplicitlyRule extends AbstractPrimaryAstRule // NO_UCD
{
   private static final String ADD_EVENT_LISTENER_MESSAGE = "The Cairngorm event is listened directly. "
                                                                + "The Controller is then avoided, and "
                                                                + "the MVC pattern is broken.";
   private static final String DISPATCH_EVENT             = "dispatchEvent";
   private static final String DISPATCH_EVENT_MESSAGE     = "Use cairngormEvent.dispatch instead";
   private static final String EVENT_DISPATCHER           = "CairngormEventDispatcher";

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractPrimaryAstRule#addViolation(com.adobe
    * .ac.pmd.parser.IParserNode, com.adobe.ac.pmd.nodes.IFunction)
    */
   @Override
   protected void addViolation( final IParserNode statement,
                                final IFunction function )
   {
      final String violationLine = getCurrentFile().getLineAt( statement.getLine() );
      final String messageToAppend = violationLine.contains( DISPATCH_EVENT ) ? ADD_EVENT_LISTENER_MESSAGE
                                                                             : DISPATCH_EVENT_MESSAGE;

      addViolation( statement,
                    messageToAppend );
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

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractPrimaryAstRule#getFirstPrimaryToFind()
    */
   @Override
   protected String getFirstPrimaryToFind()
   {
      return EVENT_DISPATCHER;
   }
}
