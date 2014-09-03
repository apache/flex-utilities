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
package com.adobe.ac.pmd.metrics;

import static org.junit.Assert.assertEquals;

import java.io.File;
import java.util.ArrayList;

import org.junit.Test;

public class PackageMetricsTest
{
   private final PackageMetrics comAdobePackage;
   private final PackageMetrics emptyPackage;

   public PackageMetricsTest()
   {
      comAdobePackage = PackageMetrics.create( new ArrayList< File >(),
                                               "com.adobe.ac",
                                               2,
                                               3,
                                               4,
                                               5,
                                               1 );
      emptyPackage = PackageMetrics.create( new ArrayList< File >(),
                                            "",
                                            2,
                                            3,
                                            4,
                                            5,
                                            2 );
   }

   @Test
   public void testGetContreteXml()
   {
      assertEquals( "<functions>2</functions><classes>0</classes>",
                    comAdobePackage.getContreteXml() );
      assertEquals( "<functions>2</functions><classes>0</classes>",
                    emptyPackage.getContreteXml() );
   }

   @Test
   public void testToXmlString()
   {
      assertEquals( "<package><name>com.adobe.ac</name><ccn>0</ccn><ncss>5</ncss><javadocs>4</javadocs>"
                          + "<javadoc_lines>4</javadoc_lines><multi_comment_lines>5</multi_comment_lines>"
                          + "<single_comment_lines>0</single_comment_lines>"
                          + "<functions>2</functions><classes>0</classes></package>",
                    comAdobePackage.toXmlString() );
      assertEquals( "<package><name>.</name><ccn>0</ccn><ncss>6</ncss><javadocs>4</javadocs>"
                          + "<javadoc_lines>4</javadoc_lines><multi_comment_lines>5</multi_comment_lines>"
                          + "<single_comment_lines>0</single_comment_lines>"
                          + "<functions>2</functions><classes>0</classes></package>",
                    emptyPackage.toXmlString() );
   }
}
