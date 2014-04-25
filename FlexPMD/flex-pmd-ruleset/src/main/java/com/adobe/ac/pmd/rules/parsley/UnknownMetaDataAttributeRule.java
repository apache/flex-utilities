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

import java.util.List;

import com.adobe.ac.pmd.nodes.IMetaData;
import com.adobe.ac.pmd.nodes.IMetaDataListHolder;
import com.adobe.ac.pmd.nodes.MetaData;
import com.adobe.ac.pmd.rules.core.AbstractFlexMetaDataRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;
import com.adobe.ac.pmd.rules.parsley.utils.MetaDataTag;
import com.adobe.ac.pmd.rules.parsley.utils.ParsleyMetaData;

/**
 * @author xagnetti
 */
public final class UnknownMetaDataAttributeRule extends AbstractFlexMetaDataRule
{
   /*
    * (non-Javadoc)
    * @seecom.adobe.ac.pmd.rules.core.AbstractFlexMetaDataRule#
    * findViolationsFromMetaDataList(com.adobe.ac.pmd.nodes.IMetaDataListHolder)
    */
   @Override
   protected void findViolationsFromMetaDataList( final IMetaDataListHolder holder )
   {
      final List< IMetaData > items = holder.getMetaData( MetaData.OTHER );

      if ( items == null )
      {
         return;
      }

      for ( final IMetaData metaData : items )
      {
         final MetaDataTag tag = ParsleyMetaData.getTag( metaData.getName() );

         if ( tag != null )
         {
            final List< String > known = tag.getAttributes();
            final List< String > actual = metaData.getAttributeNames();

            for ( final String actualAttribute : actual )
            {
               if ( !known.contains( actualAttribute ) )
               {
                  addViolation( metaData,
                                actualAttribute );
               }
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
      return ViolationPriority.HIGH;
   }
}