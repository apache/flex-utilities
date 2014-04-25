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
package com.adobe.ac.pmd.rules.unused;

import java.util.LinkedHashMap;

import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.KeyWords;
import com.adobe.ac.pmd.parser.NodeKind;
import com.adobe.ac.pmd.rules.core.ViolationPriority;
import com.adobe.ac.pmd.rules.parsley.utils.ParsleyMetaData;
import com.adobe.ac.pmd.rules.parsley.utils.MetaDataTag.Location;

/**
 * @author xagnetti
 */
public class UnusedParameterRule extends AbstractUnusedVariableRule
{
   private static final String DATA_GRID_COLUMN         = "DataGridColumn";
   private static final String FAULT_FUNCTION_NAME      = "fault";
   private static final String RESPONDER_INTERFACE_NAME = "Responder";
   private static final String RESULT_FUNCTION_NAME     = "result";

   private static String computeFunctionName( final IParserNode functionAst )
   {
      String functionName = "";
      for ( final IParserNode node : functionAst.getChildren() )
      {
         if ( node.is( NodeKind.NAME ) )
         {
            functionName = node.getStringValue();
            break;
         }
      }
      return functionName;
   }

   private static boolean isClassImplementingIResponder( final IParserNode currentClass2 )
   {
      for ( final IParserNode node : currentClass2.getChildren() )
      {
         if ( node.is( NodeKind.IMPLEMENTS_LIST ) )
         {
            for ( final IParserNode implementation : node.getChildren() )
            {
               if ( implementation.getStringValue() != null
                     && implementation.getStringValue().contains( RESPONDER_INTERFACE_NAME ) )
               {
                  return true;
               }
            }
         }
      }
      return false;
   }

   private static boolean isResponderImplementation( final IParserNode currentClass,
                                                     final IParserNode functionAst )
   {
      if ( !isClassImplementingIResponder( currentClass ) )
      {
         return false;
      }
      final String functionName = computeFunctionName( functionAst );

      return RESULT_FUNCTION_NAME.compareTo( functionName ) == 0
            || FAULT_FUNCTION_NAME.compareTo( functionName ) == 0;
   }

   private IParserNode currentClass;

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#getDefaultPriority()
    */
   @Override
   protected final ViolationPriority getDefaultPriority()
   {
      return ViolationPriority.NORMAL;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitClass(com.adobe.ac
    * .pmd.parser.IParserNode)
    */
   @Override
   protected final void visitClass( final IParserNode classNode )
   {
      currentClass = classNode;
      super.visitClass( classNode );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitFunction(com.adobe
    * .ac.pmd.parser.IParserNode,
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule.FunctionType)
    */
   @Override
   protected final void visitFunction( final IParserNode functionAst,
                                       final FunctionType type )
   {
      setVariablesUnused( new LinkedHashMap< String, IParserNode >() );
      final boolean isOverriden = isFunctionOverriden( functionAst );

      if ( !isOverriden
            && !isResponderImplementation( currentClass,
                                           functionAst ) && !isParsleyFunction( functionAst ) )
      {
         super.visitFunction( functionAst,
                              type );

         if ( !functionIsEventHandler( functionAst ) )
         {
            for ( final String variableName : getVariablesUnused().keySet() )
            {
               final IParserNode variable = getVariablesUnused().get( variableName );

               addViolation( variable,
                             variable,
                             variableName );
            }
         }
      }
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitParameters(com.adobe
    * .ac.pmd.parser.IParserNode)
    */
   @Override
   protected final void visitParameters( final IParserNode ast )
   {
      super.visitParameters( ast );

      if ( ast.numChildren() != 0 )
      {
         for ( final IParserNode parameterNode : ast.getChildren() )
         {
            if ( !isParameterAnEvent( parameterNode )
                  && parameterNode.numChildren() > 0
                  && parameterNode.getChild( 0 ).numChildren() > 1
                  && parameterNode.getChild( 0 ).getChild( 1 ).getStringValue().compareTo( DATA_GRID_COLUMN ) != 0 )
            {
               addVariable( parameterNode.getChild( 0 ).getChild( 0 ).getStringValue(),
                            parameterNode );
            }
         }
      }
   }

   private String extractFunctionName( final IParserNode ast )
   {
      if ( ast.numChildren() != 0 )
      {
         for ( final IParserNode node : ast.getChildren() )
         {
            if ( node.is( NodeKind.NAME ) )
            {
               return node.getStringValue();
            }
         }
      }
      return "";
   }

   private boolean functionIsEventHandler( final IParserNode ast )
   {
      final String functionName = extractFunctionName( ast );

      return functionName.startsWith( "on" )
            || functionName.startsWith( "handle" ) || functionName.endsWith( "handler" );
   }

   private boolean isFunctionOverriden( final IParserNode ast )
   {
      for ( final IParserNode child : ast.getChildren() )
      {
         if ( child.is( NodeKind.MOD_LIST ) )
         {
            for ( final IParserNode mod : child.getChildren() )
            {
               if ( mod.getStringValue().equals( KeyWords.OVERRIDE.toString() ) )
               {
                  return true;
               }
            }
         }
      }
      return false;
   }

   private boolean isParameterAnEvent( final IParserNode parameterNode )
   {
      final IParserNode parameterType = getTypeFromFieldDeclaration( parameterNode );

      return parameterType != null
            && parameterType.getStringValue() != null && parameterType.getStringValue().contains( "Event" );
   }

   private boolean isParsleyFunction( final IParserNode functionAst )
   {
      for ( final IParserNode child : functionAst.getChildren() )
      {
         if ( child.is( NodeKind.META_LIST ) )
         {
            for ( final IParserNode metaDataChild : child.getChildren() )
            {
               if ( metaDataChild.getStringValue() != null
                     && ParsleyMetaData.getPossibleMetaDataFromLocation( Location.FUNCTION )
                                       .containsKey( metaDataChild.getStringValue() ) )
               {
                  return true;
               }
            }
         }
      }
      return false;
   }
}
