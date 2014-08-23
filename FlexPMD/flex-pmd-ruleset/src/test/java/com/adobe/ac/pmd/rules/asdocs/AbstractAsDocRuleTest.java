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
package com.adobe.ac.pmd.rules.asdocs;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.logging.Logger;

import net.sourceforge.pmd.PMDException;

import com.adobe.ac.pmd.files.impl.FileUtils;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRuleTest;

public abstract class AbstractAsDocRuleTest extends AbstractAstFlexRuleTest
{
   protected static final Logger LOGGER      = Logger.getLogger( AbstractAsDocRuleTest.class.getName() );
   protected static final String TEST_FOLDER = "/asDocs";

   public AbstractAsDocRuleTest()
   {
      super();

      final URL resource = this.getClass().getResource( "/test"
            + TEST_FOLDER );

      if ( resource != null )
      {
         try
         {
            setTestFiles( FileUtils.computeFilesList( new File( resource.toURI().getPath() ),
                                                      null,
                                                      "",
                                                      null ) );
         }
         catch ( final PMDException e )
         {
            LOGGER.warning( e.getLocalizedMessage() );
         }
         catch ( final URISyntaxException e )
         {
            LOGGER.warning( e.getLocalizedMessage() );
         }
      }
   }

   @Override
   protected File getTestDirectory() // NO_UCD
   {
      return new File( super.getTestDirectory().getAbsolutePath()
            + TEST_FOLDER );
   }
}