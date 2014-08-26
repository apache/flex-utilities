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
package com.adobe.ac.pmd.rules.event;

import java.util.List;
import java.util.Map;

import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IMetaData;
import com.adobe.ac.pmd.nodes.MetaData;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class UnboundTypeInMetadataRule extends AbstractAstFlexRule
{
   private static final String TYPE = "type";

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IClass)
    */
   @Override
   protected final void findViolations( final IClass classNode )
   {
      final List< IMetaData > eventMetaDatas = classNode.getMetaData( MetaData.EVENT );

      if ( eventMetaDatas != null )
      {
         findViolationsInMetaDataNode( eventMetaDatas,
                                       getFilesInSourcePath() );
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

   private void findViolationsInMetaDataNode( final List< IMetaData > eventMetaDatas,
                                              final Map< String, IFlexFile > files )
   {
      for ( final IMetaData metaData : eventMetaDatas )
      {
         if ( metaData.getProperty( TYPE ).length > 0 )
         {
            final String type = metaData.getProperty( TYPE )[ 0 ];

            if ( !files.containsKey( type
                  + ".as" )
                  && !type.startsWith( "mx." ) && !type.startsWith( "flash." ) )
            {
               addViolation( metaData,
                             type );
            }
         }
      }
   }
}
