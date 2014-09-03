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
package com.adobe.ac.pmd.rules.parsley.utils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.adobe.ac.pmd.nodes.IMetaData;
import com.adobe.ac.pmd.nodes.IMetaDataListHolder;
import com.adobe.ac.pmd.nodes.MetaData;

/**
 * @author xagnetti
 */
public final class MetaDataTag
{
   /**
    * @author xagnetti
    */
   public enum Location
   {
      ATTRIBUTE, CLASS_DECLARATION, FUNCTION
   };

   private final String[]   attributes;

   private final String     name;

   private final Location[] placedOn;

   /**
    * @param nameToBeSet
    * @param attributesToBeSet
    * @param placedOnToBeSet
    */
   public MetaDataTag( final String nameToBeSet,
                       final String[] attributesToBeSet,
                       final Location[] placedOnToBeSet )
   {
      name = nameToBeSet;
      attributes = attributesToBeSet;
      placedOn = placedOnToBeSet;
   }

   /**
    * @return
    */
   public List< String > getAttributes()
   {
      return Arrays.asList( attributes );
   }

   /**
    * @param holder
    * @return
    */
   public List< IMetaData > getMetaDataList( final IMetaDataListHolder holder )
   {
      final List< IMetaData > list = new ArrayList< IMetaData >();

      for ( final IMetaData metaData : holder.getMetaData( MetaData.OTHER ) )
      {
         if ( metaData.getName().equals( name ) )
         {
            list.add( metaData );
         }
      }

      return list;
   }

   /**
    * @return
    */
   public String getName()
   {
      return name;
   }

   /**
    * @return
    */
   public List< Location > getPlacedOn()
   {
      return Arrays.asList( placedOn );
   }
}