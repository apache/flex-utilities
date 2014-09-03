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
package com.adobe.ac.pmd.rules.core;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.files.IAs3File;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.files.IMxmlFile;
import com.adobe.ac.pmd.nodes.IPackage;
import com.adobe.ac.pmd.nodes.impl.NodeFactory;
import com.adobe.ac.pmd.parser.IAS3Parser;
import com.adobe.ac.pmd.parser.exceptions.TokenException;

import de.bokelberg.flex.parser.AS3Parser;

public abstract class AbstractAstFlexRuleTest extends AbstractFlexRuleTest
{
   @Override
   protected List< IFlexViolation > processFile( final String resourcePath ) throws IOException,
                                                                            TokenException
   {
      if ( !getIgnoreFiles().contains( resourcePath ) )
      {
         final IAS3Parser parser = new AS3Parser();
         final IFlexFile file = getTestFiles().get( resourcePath );

         IPackage rootNode = null;

         if ( file == null )
         {
            throw new IOException( resourcePath
                  + " is not found" );
         }
         if ( file instanceof IAs3File )
         {
            rootNode = NodeFactory.createPackage( parser.buildAst( file.getFilePath() ) );
         }
         else
         {
            rootNode = NodeFactory.createPackage( parser.buildAst( file.getFilePath(),
                                                                   ( ( IMxmlFile ) file ).getScriptBlock() ) );
         }
         return getRule().processFile( file,
                                       rootNode,
                                       getTestFiles() );
      }
      return new ArrayList< IFlexViolation >();
   }
}
