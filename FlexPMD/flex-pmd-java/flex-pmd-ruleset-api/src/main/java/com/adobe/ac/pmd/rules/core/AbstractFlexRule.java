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

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Logger;
import java.util.regex.Pattern;

import net.sourceforge.pmd.CommonAbstractRule;
import net.sourceforge.pmd.PropertyDescriptor;
import net.sourceforge.pmd.RuleContext;
import net.sourceforge.pmd.properties.IntegerProperty;
import net.sourceforge.pmd.rules.regex.RegexHelper;

import org.apache.commons.lang.StringUtils;

import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.nodes.IPackage;
import com.adobe.ac.pmd.rules.core.thresholded.IThresholdedRule;

/**
 * Abstract FlexPMD rule. Extends this class if you want to find violations at a
 * very low level. Otherwise extends AbstractAstFlexRule, or
 * AbstractRegexpBasedRule.
 * 
 * @author xagnetti
 */
public abstract class AbstractFlexRule extends CommonAbstractRule implements IFlexRule
{
   protected static final String    MAXIMUM            = "maximum";
   protected static final String    MINIMUM            = "minimum";
   private static final String      AS3_COMMENT_TOKEN  = "//";
   private static final Logger      LOGGER             = Logger.getLogger( AbstractFlexRule.class.getName() );
   private static final String      MXML_COMMENT_TOKEN = "<!--";
   private IFlexFile                currentFile;
   private IPackage                 currentPackageNode;
   private Set< String >            excludes;
   private Map< String, IFlexFile > filesInSourcePath;

   /**
    * 
    */
   public AbstractFlexRule()
   {
      super();

      setDefaultPriority();
   }

   /**
    * not used in FlexPMD
    */
   public final void apply( final List< ? > astCompilationUnits,
                            final RuleContext ctx )
   {
   }

   /**
    * @return Extracts the rulename from the qualified name of the underlying
    *         class
    */
   public final String getRuleName()
   {
      final String qualifiedClassName = this.getClass().getName();
      final String className = StringUtils.substringAfter( qualifiedClassName,
                                                           "." );

      return className.replace( "Rule",
                                "" );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.IFlexRule#processFile(com.adobe.ac.pmd.files
    * .IFlexFile, com.adobe.ac.pmd.nodes.IPackage, java.util.Map)
    */
   public final List< IFlexViolation > processFile( final IFlexFile file,
                                                    final IPackage packageNode,
                                                    final Map< String, IFlexFile > files )
   {
      List< IFlexViolation > violations = new ArrayList< IFlexViolation >();

      currentFile = file;
      filesInSourcePath = files;
      currentPackageNode = packageNode;

      if ( isConcernedByTheCurrentFile()
            && !isFileExcluded( file ) )
      {
         onRuleStart();
         violations = findViolationsInCurrentFile();
      }

      return violations;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.rules.core.IFlexRule#setExcludes(java.util.Set)
    */
   public void setExcludes( final Set< String > excludesToBeSet )
   {
      excludes = excludesToBeSet;
   }

   /**
    * @param violatedLine
    * @return
    */
   boolean isViolationIgnored( final String violatedLine )
   {
      final boolean containsNoPmd = lineContainsNoPmd( violatedLine,
                                                       MXML_COMMENT_TOKEN )
            || lineContainsNoPmd( violatedLine,
                                  AS3_COMMENT_TOKEN );

      if ( !containsNoPmd )
      {
         return false;
      }
      final String name = getRuleName().replaceAll( "Rule",
                                                    "" );
      final String ruleName = name.contains( "." ) ? StringUtils.substringAfterLast( name,
                                                                                     "." )
                                                  : name;
      final String strippedLine = computeStrippedLine( violatedLine );
      return strippedLineContainsNoPmdAndRuleName( MXML_COMMENT_TOKEN,
                                                   ruleName,
                                                   strippedLine )
            || strippedLineContainsNoPmdAndRuleName( AS3_COMMENT_TOKEN,
                                                     ruleName,
                                                     strippedLine );
   }

   /**
    * @param violations
    * @param position
    * @return
    */
   protected final IFlexViolation addViolation( final List< IFlexViolation > violations,
                                                final ViolationPosition position )
   {
      final IFlexViolation violation = new Violation( position, this, getCurrentFile() );
      final int beginLine = position.getBeginLine();

      prettyPrintMessage( violation );

      if ( beginLine == -1
            || beginLine == 0 )
      {
         violations.add( violation );
      }
      else if ( beginLine <= getCurrentFile().getLinesNb() )
      {
         if ( isViolationIgnored( getCurrentFile().getLineAt( beginLine ) ) )
         {
            LOGGER.info( getRuleName()
                  + " has been ignored in " + getCurrentFile().getFilename() + " (" + beginLine + ")" );
         }
         else
         {
            violations.add( violation );
         }
      }

      return violation;
   }

   protected final IFlexViolation addViolation( final List< IFlexViolation > violations,
                                                final ViolationPosition position,
                                                final String... messageToReplace )
   {
      final IFlexViolation violation = addViolation( violations,
                                                     position );

      for ( int i = 0; i < messageToReplace.length; i++ )
      {
         violation.replacePlaceholderInMessage( messageToReplace[ i ],
                                                i );
      }

      return violation;
   }

   /**
    * @return
    */
   protected abstract List< IFlexViolation > findViolationsInCurrentFile();

   /**
    * @return the current file under investigation
    */
   protected IFlexFile getCurrentFile()
   {
      return currentFile;
   }

   /**
    * @return
    */
   protected final IPackage getCurrentPackageNode()
   {
      return currentPackageNode;
   }

   /**
    * @return
    */
   protected abstract ViolationPriority getDefaultPriority();

   /**
    * @return
    */
   protected final Map< String, IFlexFile > getFilesInSourcePath()
   {
      return filesInSourcePath;
   }

   /**
    * @param rule
    * @return
    */
   protected final Map< String, PropertyDescriptor > getThresholdedRuleProperties( final IThresholdedRule rule )
   {
      final Map< String, PropertyDescriptor > properties = new LinkedHashMap< String, PropertyDescriptor >();

      properties.put( rule.getThresholdName(),
                      new IntegerProperty( rule.getThresholdName(),
                                           "",
                                           rule.getDefaultThreshold(),
                                           properties.size() ) );

      return properties;
   }

   /**
    * @return is this rule concerned by the current file
    */
   protected abstract boolean isConcernedByTheCurrentFile();

   /**
    * Called when the rule is started on the current file
    */
   protected void onRuleStart()
   {
   }

   private String computeStrippedLine( final String violatedLine )
   {
      final String comment_token = getCurrentFile().isMxml() ? MXML_COMMENT_TOKEN
                                                            : AS3_COMMENT_TOKEN;
      String strippedLine = violatedLine;

      if ( violatedLine.indexOf( comment_token
            + " N" ) > 0 )
      {
         strippedLine = StringUtils.strip( violatedLine.substring( violatedLine.indexOf( comment_token
               + " N" ) ) );
      }
      else if ( violatedLine.indexOf( comment_token
            + "N" ) > 0 )
      {
         strippedLine = StringUtils.strip( violatedLine.substring( violatedLine.indexOf( comment_token
               + "N" ) ) );
      }
      return strippedLine;
   }

   private boolean isFileExcluded( final IFlexFile file )
   {
      if ( excludes != null )
      {
         for ( final String exclusion : excludes )
         {
            final Pattern pattern = Pattern.compile( exclusion );

            if ( RegexHelper.isMatch( pattern,
                                      file.getFilePath() ) )
            {
               return true;
            }
         }
      }
      return false;
   }

   private boolean lineContainsNoPmd( final String violatedLine,
                                      final String comment_token )
   {
      return violatedLine.contains( comment_token
            + " No PMD" )
            || violatedLine.contains( comment_token
                  + " NO PMD" ) || violatedLine.contains( comment_token
                  + " NOPMD" ) || violatedLine.contains( comment_token
                  + "NOPMD" );
   }

   private void prettyPrintMessage( final IFlexViolation violation )
   {
      final int nbOfBraces = violation.getRuleMessage().split( "\\{" ).length - 1;

      if ( this instanceof IThresholdedRule )
      {
         final IThresholdedRule thresholdeRule = ( IThresholdedRule ) this;

         violation.replacePlaceholderInMessage( String.valueOf( thresholdeRule.getThreshold() ),
                                                nbOfBraces - 2 );
         violation.replacePlaceholderInMessage( String.valueOf( thresholdeRule.getActualValueForTheCurrentViolation() ),
                                                nbOfBraces - 1 );
      }
      if ( getDescription() != null )
      {
         violation.appendToMessage( ". " );
         violation.appendToMessage( getDescription() );
      }
   }

   private void setDefaultPriority()
   {
      setPriority( Integer.valueOf( getDefaultPriority().toString() ) );
   }

   private boolean strippedLineContainsNoPmdAndRuleName( final String comment_token,
                                                         final String ruleName,
                                                         final String strippedLine )
   {
      return strippedLine.endsWith( comment_token
            + " No PMD" )
            || strippedLine.endsWith( comment_token
                  + " NO PMD" ) || strippedLine.endsWith( comment_token
                  + " NOPMD" ) || strippedLine.endsWith( comment_token
                  + "NOPMD" ) || strippedLine.contains( ruleName );
   }
}
