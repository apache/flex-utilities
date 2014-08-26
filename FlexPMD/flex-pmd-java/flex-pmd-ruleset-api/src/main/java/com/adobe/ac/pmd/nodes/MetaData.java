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
package com.adobe.ac.pmd.nodes;

/**
 * @author xagnetti
 */
public enum MetaData
{
   ARRAY_ELEMENT_TYPE("ArrayElementType"),
   BEFORE("Before"),
   BINDABLE("Bindable"),
   DEFAULT_PROPERTY("DefaultProperty"),
   DEPRECATED("Deprecated"),
   EFFECT("Effect"),
   EMBED("Embed"),
   EVENT("Event"),
   EXCLUDE("Exclude"),
   EXCLUDE_CLASS("Exclude"),
   ICON_FILE("IconFile"),
   INSPECTABLE("Inspectable"),
   INSTANCE_TYPE("InstanceType"),
   NON_COMITTING_CHANGE_EVENT("NonCommittingChangeEvent"),
   OTHER("Other"),
   REMOTE_CLASS("RemoteClass"),
   STYLE("Style"),
   TEST("Test"),
   TRANSIENT("Transient");

   /**
    * @param metaDataName
    * @return
    */
   public static MetaData create( final String metaDataName )
   {
      MetaData metaData = null;

      for ( final MetaData currentMetadata : values() )
      {
         if ( currentMetadata.toString().compareTo( metaDataName ) == 0 )
         {
            metaData = currentMetadata;
            break;
         }
      }
      if ( metaData == null )
      {
         metaData = MetaData.OTHER;
         metaData.name = metaDataName;
      }

      return metaData;
   }

   private String name;

   private MetaData( final String nameToBeSet )
   {
      name = nameToBeSet;
   }

   /*
    * (non-Javadoc)
    * @see java.lang.Enum#toString()
    */
   @Override
   public String toString()
   {
      return name;
   }
}
