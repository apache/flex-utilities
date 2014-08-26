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

import com.adobe.ac.pmd.nodes.asdoc.impl.ClassAsDocNode;
import com.adobe.ac.pmd.nodes.asdoc.impl.FunctionAsDocNode;
import com.adobe.ac.pmd.nodes.asdoc.impl.ParameterAsDocNode;

/**
 * @author xagnetti
 */
public final class AsDocUtils
{
   /**
    * @param doc
    * @return
    */
   public static ClassAsDocNode computeClassDoc( final String doc )
   {
      return new ClassAsDocNode( doc );
   }

   /**
    * @param doc
    * @return
    */
   public static FunctionAsDocNode computeFunctionDoc( final String doc )
   {
      return new FunctionAsDocNode( doc );
   }

   /**
    * @param nameToBeSet
    * @param descriptionToBeSet
    * @return
    */
   public static ParameterAsDocNode computeParameterDoc( final String nameToBeSet,
                                                         final String descriptionToBeSet )
   {
      return new ParameterAsDocNode( nameToBeSet, descriptionToBeSet );
   }

   private AsDocUtils()
   {
   }
}
