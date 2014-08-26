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
package de.bokelberg.flex.parser;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;

import org.junit.Test;

import com.adobe.ac.pmd.files.impl.FileUtils;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.exceptions.TokenException;

public class TestAS3Parser extends AbstractAs3ParserTest
{
   @Test
   public void testBuildAst() throws IOException,
                             URISyntaxException,
                             TokenException
   {
      asp.buildAst( getClass().getResource( "/examples/unformatted/IContext.as" ).toURI().getPath() );
      asp.buildAst( getClass().getResource( "/examples/FlexPMD115.as" ).toURI().getPath() );
      asp.buildAst( getClass().getResource( "/examples/JPEGEncoder.as" ).toURI().getPath() );
      asp.buildAst( getClass().getResource( "/examples/JPEGEncoder2.as" ).toURI().getPath() );
      asp.buildAst( getClass().getResource( "/examples/FisheyeBase.as" ).toURI().getPath() );
      asp.buildAst( getClass().getResource( "/examples/FlexPMD98.as" ).toURI().getPath() );
      asp.buildAst( getClass().getResource( "/examples/FlexPMD195.as" ).toURI().getPath() );
      final String titlePath = getClass().getResource( "/examples/unformatted/Title.as" ).toURI().getPath();

      asp.buildAst( titlePath );
      asp.buildAst( titlePath,
                    FileUtils.readLines( new File( titlePath ) ) );
   }

   @Test
   public void testBuildAst_AS2() throws IOException,
                                 URISyntaxException,
                                 TokenException
   {
      asp.buildAst( getClass().getResource( "/examples/toAS2/src/fw/data/request/ResultListener.as" )
                              .toURI()
                              .getPath() );

      // Remark: file was missing.
      //asp.buildAst( getClass().getResource( "/examples/toAS2/src/epg/StateExit_AS2.as" ).toURI().getPath() );
   }

   @Test
   public void testBuildAst2() throws IOException,
                              TokenException,
                              URISyntaxException
   {
      final IParserNode flexPmd62 = asp.buildAst( getClass().getResource( "/examples/FlexPMD62.as" )
                                                            .toURI()
                                                            .getPath() );

      assertEquals( "com.test.testy.ui.components",
                    flexPmd62.getChild( 0 ).getChild( 0 ).getStringValue() );

   }
}
