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

import java.util.List;
import java.util.Map;

import com.adobe.ac.pmd.parser.IParserNode;

/**
 * Node representing a Function It contains the function name, its parameters,
 * its return type, its modifiers, its metadata
 * 
 * @author xagnetti
 */
public interface IFunction extends IVisible, IMetaDataListHolder, INamableNode, IAsDocHolder, ICommentHolder
{
   /**
    * Finds recursively a statement in the function body from a list of names
    * 
    * @param primaryNames statement name
    * @return corresponding node
    */
   List< IParserNode > findPrimaryStatementInBody( final String[] primaryNames );

   /**
    * Finds recursively a statement in the function body from its name
    * 
    * @param primaryName statement name
    * @return corresponding node
    */
   List< IParserNode > findPrimaryStatementsInBody( final String primaryName );

   /**
    * @return
    */
   IParserNode getBody();

   /**
    * @return
    */
   int getCyclomaticComplexity();

   /**
    * @return
    */
   Map< String, IParserNode > getLocalVariables();

   /**
    * @return
    */
   List< IParameter > getParameters();

   /**
    * @return
    */
   IIdentifierNode getReturnType();

   /**
    * @return
    */
   int getStatementNbInBody();

   /**
    * @return Extracts the super call node (if any) from the function content
    *         block
    */
   IParserNode getSuperCall();

   boolean isEventHandler();

   /**
    * @return
    */
   boolean isGetter();

   /**
    * @return
    */
   boolean isOverriden();

   /**
    * @return
    */
   boolean isSetter();
}