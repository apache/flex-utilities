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
package com.adobe.ac.pmd.files;

import java.util.Set;

/**
 * @author xagnetti
 */
public interface IFlexFile
{
   /**
    * @param stringToLookup
    * @param linesToBeIgnored
    * @return
    */
   boolean contains( final String stringToLookup,
                     final Set< Integer > linesToBeIgnored );

   /**
    * @return
    */
   String getClassName();

   /**
    * @return the token for comment closing
    */
   String getCommentClosingTag();

   /**
    * @return the token for comment opening
    */
   String getCommentOpeningTag();

   /**
    * @return java.io.File name
    */
   String getFilename();

   /**
    * @return java.io.File absolute path
    */
   String getFilePath();

   /**
    * @return
    */
   String getFullyQualifiedName();

   /**
    * @param lineIndex
    * @return
    */
   String getLineAt( int lineIndex );

   /**
    * @return
    */
   int getLinesNb();

   /**
    * @return
    */
   String getPackageName();

   /**
    * @return the token for one line comment
    */
   String getSingleLineComment();

   /**
    * @return true if the file is a main MXML file
    */
   boolean isMainApplication();

   /**
    * @return true if the file is a MXML file
    */
   boolean isMxml();
}