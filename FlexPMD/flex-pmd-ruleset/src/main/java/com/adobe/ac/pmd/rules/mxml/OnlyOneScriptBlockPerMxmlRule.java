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
package com.adobe.ac.pmd.rules.mxml;

import java.util.List;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;

import org.w3c.dom.Document;

import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.rules.core.AbstractXpathRelatedRule;
import com.adobe.ac.pmd.rules.core.ViolationPosition;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class OnlyOneScriptBlockPerMxmlRule extends AbstractXpathRelatedRule
{
   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractXpathRelatedRule#evaluate(org.w3c.
    * dom.Document, javax.xml.xpath.XPath)
    */
   @Override
   protected Object evaluate( final Document doc,
                              final XPath xPath ) throws XPathExpressionException
   {
      return xPath.evaluate( getXPathExpression(),
                             doc,
                             XPathConstants.NUMBER );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#getDefaultPriority()
    */
   @Override
   protected ViolationPriority getDefaultPriority()
   {
      return ViolationPriority.HIGH;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractXpathRelatedRule#getXPathExpression()
    */
   @Override
   protected String getXPathExpression()
   {
      return "count(//mx:Script)";
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractXpathRelatedRule#onEvaluated(java.
    * util.List, org.w3c.dom.Document, javax.xml.xpath.XPath)
    */
   @Override
   protected void onEvaluated( final List< IFlexViolation > violations,
                               final Document doc,
                               final XPath xPath ) throws XPathExpressionException
   {
      final Double scriptNb = ( Double ) evaluate( doc,
                                                   xPath );

      if ( scriptNb >= 2 )
      {
         addViolation( violations,
                       ViolationPosition.create( 1,
                                                 1,
                                                 0,
                                                 0 ),
                       String.valueOf( scriptNb ) );
      }
   }
}
