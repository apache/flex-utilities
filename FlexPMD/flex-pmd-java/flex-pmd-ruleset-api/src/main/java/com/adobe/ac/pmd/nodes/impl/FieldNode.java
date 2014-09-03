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

import com.adobe.ac.pmd.nodes.IField;
import com.adobe.ac.pmd.nodes.Modifier;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.NodeKind;

/**
 * Base class for AttributeNode and for ConstantNode
 * 
 * @author xagnetti
 */
class FieldNode extends VariableNode implements IField
{
   private IParserNode asDocs;

   /**
    * @param rootNode
    */
   protected FieldNode( final IParserNode rootNode )
   {
      super( rootNode );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.impl.VariableNode#compute()
    */
   @Override
   public FieldNode compute()
   {
      super.compute();

      if ( getInternalNode().numChildren() != 0 )
      {
         for ( final IParserNode child : getInternalNode().getChildren() )
         {
            if ( child.is( NodeKind.MOD_LIST ) )
            {
               computeModifierList( this,
                                    child );
            }
            else if ( child.is( NodeKind.AS_DOC ) )
            {
               asDocs = child;
            }
         }
      }
      return this;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IAsDocHolder#getAsDoc()
    */
   public IParserNode getAsDoc()
   {
      return asDocs;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IVisible#isPublic()
    */
   public boolean isPublic()
   {
      return is( Modifier.PUBLIC );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IField#isStatic()
    */
   public boolean isStatic()
   {
      return is( Modifier.STATIC );
   }
}
