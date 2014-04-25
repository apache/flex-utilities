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
import java.util.Map;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;

import net.sourceforge.pmd.PropertyDescriptor;

import org.w3c.dom.Document;

import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.rules.core.AbstractXpathRelatedRule;
import com.adobe.ac.pmd.rules.core.ViolationPosition;
import com.adobe.ac.pmd.rules.core.ViolationPriority;
import com.adobe.ac.pmd.rules.core.thresholded.IThresholdedRule;

/**
 * @author xagnetti
 */
public class TooManyStatesInMxmlRule extends AbstractXpathRelatedRule implements IThresholdedRule
{
   private Double statesNb = 0.0;

   /*
    * (non-Javadoc)
    * @seecom.adobe.ac.pmd.rules.core.thresholded.IThresholdedRule#
    * getActualValueForTheCurrentViolation()
    */
   public int getActualValueForTheCurrentViolation()
   {
      return statesNb.intValue();
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.thresholded.IThresholdedRule#getDefaultThreshold
    * ()
    */
   public int getDefaultThreshold()
   {
      return 5;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.thresholded.IThresholdedRule#getThreshold()
    */
   public int getThreshold()
   {
      return getIntProperty( propertyDescriptorFor( getThresholdName() ) );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.thresholded.IThresholdedRule#getThresholdName
    * ()
    */
   public final String getThresholdName()
   {
      return MAXIMUM;
   }

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
      return ViolationPriority.NORMAL;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractXpathRelatedRule#getXPathExpression()
    */
   @Override
   protected String getXPathExpression()
   {
      return "count(//mx:states/*)";
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
      statesNb = ( Double ) evaluate( doc,
                                      xPath );

      if ( statesNb >= getThreshold() )
      {
         xPath.evaluate( "//mx:states/*",
                         doc,
                         XPathConstants.NODESET );

         addViolation( violations,
                       ViolationPosition.create( 1,
                                                 1,
                                                 0,
                                                 0 ),
                       String.valueOf( getActualValueForTheCurrentViolation() ) );
      }
   }

   /*
    * (non-Javadoc)
    * @see net.sourceforge.pmd.CommonAbstractRule#propertiesByName()
    */
   @Override
   protected final Map< String, PropertyDescriptor > propertiesByName()
   {
      return getThresholdedRuleProperties( this );
   }
}
