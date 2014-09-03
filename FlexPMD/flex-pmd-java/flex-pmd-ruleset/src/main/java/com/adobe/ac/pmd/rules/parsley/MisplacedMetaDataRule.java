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

import com.adobe.ac.pmd.nodes.IAttribute;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.nodes.IMetaData;
import com.adobe.ac.pmd.nodes.IMetaDataListHolder;
import com.adobe.ac.pmd.nodes.MetaData;
import com.adobe.ac.pmd.rules.core.AbstractFlexMetaDataRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;
import com.adobe.ac.pmd.rules.parsley.utils.MetaDataTag;
import com.adobe.ac.pmd.rules.parsley.utils.ParsleyMetaData;
import com.adobe.ac.pmd.rules.parsley.utils.MetaDataTag.Location;

/**
 * @author xagnetti
 */
public final class MisplacedMetaDataRule extends AbstractFlexMetaDataRule
{
   /*
    * (non-Javadoc)
    * @seecom.adobe.ac.pmd.rules.core.AbstractFlexMetaDataRule#
    * findViolationsFromAttributeMetaData(com.adobe.ac.pmd.nodes.IAttribute)
    */
   @Override
   protected void findViolationsFromAttributeMetaData( final IAttribute attribute )
   {
      findDisallowedMetaData( attribute,
                              MetaDataTag.Location.ATTRIBUTE );
   }

   /*
    * (non-Javadoc)
    * @seecom.adobe.ac.pmd.rules.core.AbstractFlexMetaDataRule#
    * findViolationsFromClassMetaData(com.adobe.ac.pmd.nodes.IClass)
    */
   @Override
   protected void findViolationsFromClassMetaData( final IClass classNode )
   {
      findDisallowedMetaData( classNode,
                              MetaDataTag.Location.CLASS_DECLARATION );
   }

   /*
    * (non-Javadoc)
    * @seecom.adobe.ac.pmd.rules.core.AbstractFlexMetaDataRule#
    * findViolationsFromFunctionMetaData(com.adobe.ac.pmd.nodes.IFunction)
    */
   @Override
   protected void findViolationsFromFunctionMetaData( final IFunction function )
   {
      findDisallowedMetaData( function,
                              MetaDataTag.Location.FUNCTION );
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

   private void findDisallowedMetaData( final IMetaDataListHolder holder,
                                        final Location location )
   {
      final List< String > tags = getDisallowedTags( location );
      final List< IMetaData > otherMetadata = holder.getMetaData( MetaData.OTHER );

      if ( otherMetadata == null )
      {
         return;
      }

      for ( final IMetaData metaData : otherMetadata )
      {
         if ( tags.contains( metaData.getName() ) )
         {
            addViolation( metaData,
                          metaData.getName() );
         }
      }
   }

   private List< String > getDisallowedTags( final Location location )
   {
      final List< String > tags = new ArrayList< String >();

      for ( final MetaDataTag tag : ParsleyMetaData.ALL_TAGS )
      {
         if ( !tag.getPlacedOn().contains( location ) )
         {
            tags.add( tag.getName() );
         }
      }

      return tags;
   }
}