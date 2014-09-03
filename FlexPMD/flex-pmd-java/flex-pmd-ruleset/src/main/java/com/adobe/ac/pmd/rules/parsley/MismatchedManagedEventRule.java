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
package com.adobe.ac.pmd.rules.parsley;

import java.util.ArrayList;
import java.util.List;

import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IMetaData;
import com.adobe.ac.pmd.nodes.MetaData;
import com.adobe.ac.pmd.rules.core.AbstractFlexMetaDataRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;
import com.adobe.ac.pmd.rules.parsley.utils.ParsleyMetaData;

/**
 * @author xagnetti
 */
public final class MismatchedManagedEventRule extends AbstractFlexMetaDataRule
{
   /*
    * (non-Javadoc)
    * @seecom.adobe.ac.pmd.rules.core.AbstractFlexMetaDataRule#
    * findViolationsFromClassMetaData(com.adobe.ac.pmd.nodes.IClass)
    */
   @Override
   protected void findViolationsFromClassMetaData( final IClass classNode )
   {
      final List< IMetaData > managedEvents = ParsleyMetaData.MANAGED_EVENTS.getMetaDataList( classNode );

      final List< String > eventTypes = getEventTypes( classNode );

      for ( final IMetaData data : managedEvents )
      {
         final List< String > types = data.getPropertyAsList( "names" );

         for ( final String type : types )
         {
            if ( !eventTypes.contains( type ) )
            {
               addViolation( data,
                             type );
            }
         }
      }
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#getDefaultPriority()
    */
   @Override
   protected ViolationPriority getDefaultPriority()
   {
      return ViolationPriority.NORMAL;
   }

   private List< String > getEventTypes( final IClass classNode )
   {
      final ArrayList< String > types = new ArrayList< String >();

      for ( final IMetaData data : classNode.getMetaData( MetaData.EVENT ) )
      {
         final String[] name = data.getProperty( "name" );
         final String eventName = name.length == 0 ? data.getDefaultValue()
                                                  : name[ 0 ];

         types.add( eventName );
      }

      return types;
   }
}