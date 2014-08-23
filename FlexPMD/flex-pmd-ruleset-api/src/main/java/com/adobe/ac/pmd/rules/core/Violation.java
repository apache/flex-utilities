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

import java.util.Formatter;

import org.apache.commons.lang.StringUtils;

import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.files.IFlexFile;

/**
 * @author xagnetti
 */
public final class Violation implements IFlexViolation
{
   public static final String RULESET_CREATOR_URL = "http://opensource.adobe.com/svn/opensource/"
                                                        + "flexpmd/bin/flex-pmd-ruleset-creator.html?rule=";
   private final int          beginColumn;
   private final int          beginLine;
   private int                endColumn;
   private final int          endLine;
   private final IFlexFile    file;
   private final IFlexRule    rule;
   private String             ruleMessage         = "";

   /**
    * @param position
    * @param violatedRule
    * @param violatedFile
    */
   public Violation( final ViolationPosition position,
                     final IFlexRule violatedRule,
                     final IFlexFile violatedFile )
   {
      beginLine = position.getBeginLine();
      endLine = position.getEndLine();
      beginColumn = position.getBeginColumn();
      endColumn = position.getEndColumn();
      rule = violatedRule;
      file = violatedFile;

      if ( violatedRule != null )
      {
         ruleMessage = violatedRule.getMessage() == null ? ""
                                                        : violatedRule.getMessage();
      }
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.IFlexViolation#appendToMessage(java.lang.String)
    */
   public void appendToMessage( final String messageToAppend )
   {
      ruleMessage += messageToAppend;
   }

   /*
    * (non-Javadoc)
    * @see java.lang.Comparable#compareTo(java.lang.Object)
    */
   public int compareTo( final IFlexViolation otherViolation ) // NO_UCD
   {
      int res;
      final int priorityOrder = getPrioriyOrder( otherViolation );

      if ( priorityOrder == 0 )
      {
         res = getLinePriority( otherViolation );
      }
      else
      {
         res = priorityOrder;
      }
      return res;
   }

   /*
    * (non-Javadoc)
    * @see net.sourceforge.pmd.IRuleViolation#getBeginColumn()
    */
   public int getBeginColumn()
   {
      return beginColumn;
   }

   /*
    * (non-Javadoc)
    * @see net.sourceforge.pmd.IRuleViolation#getBeginLine()
    */
   public int getBeginLine()
   {
      return beginLine;
   }

   /*
    * (non-Javadoc)
    * @see net.sourceforge.pmd.IRuleViolation#getClassName()
    */
   public String getClassName()
   {
      return "";
   }

   /*
    * (non-Javadoc)
    * @see net.sourceforge.pmd.IRuleViolation#getDescription()
    */
   public String getDescription()
   {
      return ruleMessage;
   }

   /*
    * (non-Javadoc)
    * @see net.sourceforge.pmd.IRuleViolation#getEndColumn()
    */
   public int getEndColumn()
   {
      return endColumn;
   }

   /*
    * (non-Javadoc)
    * @see net.sourceforge.pmd.IRuleViolation#getEndLine()
    */
   public int getEndLine()
   {
      return endLine;
   }

   /*
    * (non-Javadoc)
    * @see net.sourceforge.pmd.IRuleViolation#getFilename()
    */
   public String getFilename()
   {
      return file.getFullyQualifiedName();
   }

   /*
    * (non-Javadoc)
    * @see net.sourceforge.pmd.IRuleViolation#getMethodName()
    */
   public String getMethodName()
   {
      return "";
   }

   /*
    * (non-Javadoc)
    * @see net.sourceforge.pmd.IRuleViolation#getPackageName()
    */
   public String getPackageName()
   {
      return file.getPackageName();
   }

   /*
    * (non-Javadoc)
    * @see net.sourceforge.pmd.IRuleViolation#getRule()
    */
   public IFlexRule getRule()
   {
      return rule;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.IFlexViolation#getRuleMessage()
    */
   public String getRuleMessage()
   {
      return ruleMessage.endsWith( "." ) ? ruleMessage.substring( 0,
                                                                  ruleMessage.length() - 1 )
                                        : ruleMessage;
   }

   /*
    * (non-Javadoc)
    * @see net.sourceforge.pmd.IRuleViolation#getVariableName()
    */
   public String getVariableName()
   {
      return "";
   }

   /*
    * (non-Javadoc)
    * @see net.sourceforge.pmd.IRuleViolation#isSuppressed()
    */
   public boolean isSuppressed()
   {
      return false;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.IFlexViolation#replacePlaceholderInMessage(java.lang.
    * String, int)
    */
   public void replacePlaceholderInMessage( final String replacement,
                                            final int index )
   {
      ruleMessage = ruleMessage.replace( "{"
                                               + index + "}",
                                         replacement );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.IFlexViolation#setEndColumn(int)
    */
   public void setEndColumn( final int column )
   {
      endColumn = column;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.IFlexViolation#toXmlString(com.adobe.ac.pmd.files.IFlexFile
    * , java.lang.String)
    */
   public String toXmlString( final IFlexFile violatedFile,
                              final String ruleSetName )
   {
      final Formatter formatter = new Formatter();

      if ( rule != null )
      {
         final StringBuffer message = new StringBuffer( getRuleMessage() );

         formatter.format( "      <violation beginline=\"%d\" "
                                 + "endline=\"%d\" begincolumn=\"%d\" " + "endcolumn=\"%d\" rule=\"%s\" "
                                 + "ruleset=\"%s\" package=\"%s\" " + "class=\"%s\" externalInfoUrl=\"%s\" "
                                 + "priority=\"%s\">%s</violation>" + getNewLine(),
                           beginLine,
                           endLine,
                           beginColumn,
                           endColumn,
                           rule.getRuleName(),
                           ruleSetName,
                           violatedFile.getPackageName(),
                           violatedFile.getClassName(),
                           RULESET_CREATOR_URL
                                 + extractShortName( rule.getName() ),
                           rule.getPriority(),
                           message );
      }
      return formatter.toString();
   }

   /**
    * @return
    */
   String getNewLine()
   {
      return System.getProperty( "line.separator" );
   }

   private String extractShortName( final String name )
   {
      return StringUtils.substringAfterLast( name,
                                             "." );
   }

   private int getLinePriority( final IFlexViolation otherViolation )
   {
      int res;

      if ( beginLine > otherViolation.getBeginLine() )
      {
         res = 1;
      }
      else if ( beginLine < otherViolation.getBeginLine() )
      {
         res = -1;
      }
      else
      {
         res = 0;
      }

      return res;
   }

   private int getPrioriyOrder( final IFlexViolation otherViolation )
   {
      int res;

      if ( rule.getPriority() > otherViolation.getRule().getPriority() )
      {
         res = 1;
      }
      else if ( rule.getPriority() < otherViolation.getRule().getPriority() )
      {
         res = -1;
      }
      else
      {
         res = 0;
      }

      return res;
   }
}