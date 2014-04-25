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
package com.adobe.ac.pmd.parser;

import java.util.List;

/**
 * @author xagnetti
 */
public interface IParserNode
{
   /**
    * @return the cyclomatic complexity of the current node
    */
   int computeCyclomaticComplexity();

   /**
    * @param type
    * @return count recursivly the number of children which are of type "type"
    */
   int countNodeFromType( final NodeKind type );

   /**
    * @param names
    * @return the list of IParserNode which names is contained in the given
    *         names array
    */
   List< IParserNode > findPrimaryStatementsFromNameInChildren( final String[] names );

   /**
    * @param index
    * @return the indexth child
    */
   IParserNode getChild( final int index );

   /**
    * @return the entire list of chilren
    */
   List< IParserNode > getChildren();

   /**
    * @return node's column
    */
   int getColumn();

   /**
    * @return node's type
    */
   NodeKind getId();

   /**
    * @return the node's last child
    */
   IParserNode getLastChild();

   /**
    * @return nodes's line
    */
   int getLine();

   /**
    * @return node's string value
    */
   String getStringValue();

   /**
    * @param expectedType
    * @return true if the node's type is identical to the given name
    */
   boolean is( final NodeKind expectedType ); // NOPMD

   /**
    * @return the children number
    */
   int numChildren();
}