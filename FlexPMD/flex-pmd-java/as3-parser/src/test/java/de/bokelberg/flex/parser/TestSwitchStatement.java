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

import org.junit.Test;

import com.adobe.ac.pmd.parser.exceptions.TokenException;

public class TestSwitchStatement extends AbstractStatementTest
{
   @Test
   public void testFullFeatured() throws TokenException
   {
      assertStatement( "1",
                       "switch( x ){ case 1 : trace('one'); break; default : trace('unknown'); }",
                       "<switch line=\"1\"><condition line=\"1\">"
                             + "<primary line=\"1\">x</primary>" + "</condition><cases line=\"1\">"
                             + "<case line=\"1\"><primary line=\"1\">1</primary>"
                             + "<switch-block line=\"1\"><call line=\"1\">"
                             + "<primary line=\"1\">trace</primary><arguments line=\"1\">"
                             + "<primary line=\"1\">'one'</primary></arguments>"
                             + "</call><primary line=\"1\">break</primary>"
                             + "</switch-block></case><case line=\"1\">" + "<default line=\"1\">"
                             + "default</default><switch-block line=\"1\">"
                             + "<call line=\"1\"><primary line=\"1\">trace" + "</primary>"
                             + "<arguments line=\"1\">" + "<primary line=\"1\">'unknown'</primary>"
                             + "</arguments></call></switch-block></case></cases></switch>" );
      assertStatement( "1",
                       "switch( x ){ case 1 : break; default:}",
                       "<switch line=\"1\"><condition line=\"1\"><primary line=\"1\""
                             + ">x</primary></condition><cases line=\"1\"><case line=\"1\""
                             + "><primary line=\"1\">1</primary><switch-block line=\"1\""
                             + "><primary line=\"1\">break</primary></switch-block></case>"
                             + "<case line=\"1\"><default line=\"1\">default</default>"
                             + "<switch-block line=\"1\"></switch-block></case></cases></switch>" );

   }
}
