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
package com.adobe.ac.pmd.nodes.impl;

import com.adobe.ac.pmd.nodes.IParameter;
import com.adobe.ac.pmd.parser.IParserNode;

/**
 * @author xagnetti
 */
final class FormalNode extends VariableNode implements IParameter
{
   /**
    * @param node
    * @return
    */
   static FormalNode create( final IParserNode node )
   {
      return new FormalNode( node ).compute();
   }

   /**
    * @param node
    */
   private FormalNode( final IParserNode node )
   {
      super( node );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.impl.VariableNode#compute()
    */
   @Override
   public FormalNode compute()
   {
      return ( FormalNode ) super.compute();
   }
}
