////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package com.adobe.ac.pmd.services.translators
{
   import com.adobe.ac.pmd.model.Property;

   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;

   public class PropertyTranslator
   {
      public static function deserializeProperties( xmlList : XMLList ) : ListCollectionView
      {
         var properties : ListCollectionView = new ArrayCollection();

         for( var childIndex : int = 0; childIndex < xmlList.length(); childIndex++ )
         {
            var propertyXml : XML = xmlList[ childIndex ];
            var property : Property = new Property(); // NO PMD AvoidInstanciationInLoop

            property.name = propertyXml.@name;
            property.value = propertyXml.children()[ 0 ].toString();
            properties.addItem( property );
         }
         return properties;
      }
   }
}