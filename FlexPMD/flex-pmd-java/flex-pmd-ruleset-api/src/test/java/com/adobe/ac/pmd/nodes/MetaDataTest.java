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

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class MetaDataTest
{
   @Test
   public void testCreate()
   {
      assertEquals( MetaData.BINDABLE.toString(),
                    MetaData.create( MetaData.BINDABLE.toString() ).toString() );

      assertEquals( MetaData.ARRAY_ELEMENT_TYPE.toString(),
                    MetaData.create( MetaData.ARRAY_ELEMENT_TYPE.toString() ).toString() );

      assertEquals( MetaData.BEFORE.toString(),
                    MetaData.create( MetaData.BEFORE.toString() ).toString() );

      assertEquals( MetaData.EMBED.toString(),
                    MetaData.create( MetaData.EMBED.toString() ).toString() );

      assertEquals( MetaData.EVENT.toString(),
                    MetaData.create( MetaData.EVENT.toString() ).toString() );

      assertEquals( MetaData.TEST.toString(),
                    MetaData.create( MetaData.TEST.toString() ).toString() );

      final String unknownMetaData = "Unknown";
      final MetaData other = MetaData.create( unknownMetaData );

      assertEquals( MetaData.OTHER,
                    other );

      assertEquals( unknownMetaData,
                    other.toString() );
   }
}
