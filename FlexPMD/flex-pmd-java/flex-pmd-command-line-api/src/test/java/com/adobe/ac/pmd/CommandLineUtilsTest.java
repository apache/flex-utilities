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
package com.adobe.ac.pmd;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

import com.martiansoftware.jsap.JSAP;
import com.martiansoftware.jsap.JSAPException;

public class CommandLineUtilsTest
{
   @Test
   public void testComputeSourceList()
   {
      assertEquals( 3,
                    CommandLineUtils.computeSourceList( "lala,toto,tyty" ).size() );
      assertNull( CommandLineUtils.computeSourceList( "lala" ) );
   }

   @Test
   public void testRegisterParameter() throws JSAPException
   {
      final JSAP jsap = new JSAP();

      CommandLineUtils.registerParameter( jsap,
                                          new ICommandLineOptions()
                                          {
                                             @Override
                                             public String toString()
                                             {
                                                return "name";
                                             }
                                          },
                                          true );

      assertTrue( jsap.getByShortFlag( 'n' ) != null );
      assertNull( jsap.getByShortFlag( 'm' ) );
   }

}
