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
package com.adobe.ac.pmd.nodes.utils;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import com.adobe.ac.pmd.nodes.asdoc.impl.ClassAsDocNode;
import com.adobe.ac.pmd.nodes.asdoc.impl.FunctionAsDocNode;
import com.adobe.ac.pmd.nodes.asdoc.impl.ParameterAsDocNode;

public class AsDocUtilsTest
{
   @Test
   public void testComputeClassDoc()
   {
      final ClassAsDocNode emptyDoc = AsDocUtils.computeClassDoc( "" );

      assertEquals( "",
                    emptyDoc.getDescription() );

      AsDocUtils.computeClassDoc( "/** description \n        * description2\n @see mx.kjnerkjlef.btbt*/" );
   }

   @Test
   public void testComputeFunctionDoc()
   {
      final FunctionAsDocNode emptyDoc = AsDocUtils.computeFunctionDoc( "" );

      assertEquals( "",
                    emptyDoc.getDescription() );

      final FunctionAsDocNode functionDoc = AsDocUtils.computeFunctionDoc( "/** description \n        * description2\n @see mx.kjnerkjlef.btbt*/" );

      final ParameterAsDocNode parameter = AsDocUtils.computeParameterDoc( "name",
                                                                           "description" );
      functionDoc.addParameter( parameter );

      assertEquals( parameter,
                    functionDoc.getParameter( 0 ) );

      assertEquals( "name",
                    parameter.getName() );

      assertEquals( "description",
                    parameter.getDescription() );
   }
}
