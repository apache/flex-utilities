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
import java.util.Iterator;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.logging.Logger;

import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.nodes.IAttribute;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IConstant;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.nodes.INode;
import com.adobe.ac.pmd.nodes.IPackage;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.NodeKind;
import com.adobe.ac.utils.StackTraceUtils;

/**
 * Abstract class for AST-based rule Extends this class if your rule is only
 * detectable in an AS script block, which can be converted into an Abstract
 * Syntax Tree. Then you will be able to either use the visitor pattern, or to
 * iterate from the package node, in order to find your violation(s).
 * 
 * @author xagnetti
 */
public abstract class AbstractAstFlexRule extends AbstractFlexRule implements IFlexAstRule
{
   /**
    *
    */
   protected enum FunctionType
   {
      GETTER, NORMAL, SETTER
   }

   /**
    *
    */
   protected enum VariableOrConstant
   {
      CONSTANT, VARIABLE
   }

   /**
    *
    */
   protected enum VariableScope
   {
      IN_CLASS, IN_FUNCTION
   }

   private interface ExpressionVisitor
   {
      void visitExpression( final IParserNode ast );
   }

   private static final Logger LOGGER = Logger.getLogger( AbstractAstFlexRule.class.getName() );

   /**
    * @param functionNode
    * @return
    */
   /**
    * @param functionNode
    * @return
    */
   protected static IParserNode getNameFromFunctionDeclaration( final IParserNode functionNode )
   {
      IParserNode nameChild = null;

      for ( final IParserNode child : functionNode.getChildren() )
      {
         if ( child.is( NodeKind.NAME ) )
         {
            nameChild = child;
            break;
         }
      }
      return nameChild;
   }

   /**
    * @param fieldNode
    * @return
    */
   protected static IParserNode getTypeFromFieldDeclaration( final IParserNode fieldNode )
   {
      return fieldNode.getChild( 0 ).getChild( 1 );
   }

   private final List< IFlexViolation > violations;

   /**
    * 
    */
   public AbstractAstFlexRule()
   {
      super();

      violations = new ArrayList< IFlexViolation >();
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractFlexRule#isConcernedByTheCurrentFile
    * ()
    */
   @Override
   public boolean isConcernedByTheCurrentFile()
   {
      return true;
   }

   /**
    * @param function
    * @return the added violation positioned on the given function node
    */
   protected final IFlexViolation addViolation( final IFunction function )
   {
      final IParserNode name = getNameFromFunctionDeclaration( function.getInternalNode() );

      return addViolation( name,
                           name,
                           name.getStringValue() );
   }

   /**
    * @param function
    * @param messageToReplace
    * @return
    */
   protected final IFlexViolation addViolation( final IFunction function,
                                                final String messageToReplace )
   {
      final IParserNode name = getNameFromFunctionDeclaration( function.getInternalNode() );

      return addViolation( name,
                           name,
                           messageToReplace );
   }

   /**
    * @param violatingNode
    * @return the added violation replacing the threshold value in the message
    *         if any.
    */
   protected final IFlexViolation addViolation( final INode violatingNode )
   {
      return addViolation( violatingNode.getInternalNode(),
                           violatingNode.getInternalNode() );
   }

   /**
    * @param violatingNode
    * @return the added violation replacing the threshold value in the message
    *         if any.
    */
   protected final IFlexViolation addViolation( final INode violatingNode,
                                                final String... messageToReplace )
   {
      return addViolation( violatingNode.getInternalNode(),
                           violatingNode.getInternalNode(),
                           messageToReplace );
   }

   /**
    * @param violatingNode
    * @param endNode
    * @return the added violation replacing the threshold value in the message
    *         if any.
    */
   protected final IFlexViolation addViolation( final IParserNode violatingNode )
   {
      return addViolation( violatingNode,
                           violatingNode );
   }

   /**
    * @param beginningNode
    * @param endNode
    * @param messageToReplace
    * @return the add violation replacing the {0} token by the specified message
    */
   protected final IFlexViolation addViolation( final IParserNode beginningNode,
                                                final IParserNode endNode,
                                                final String... messageToReplace )
   {
      if ( isAlreadyViolationAdded( beginningNode ) )
      {
         return null;
      }
      final IFlexViolation violation = addViolation( ViolationPosition.create( beginningNode.getLine(),
                                                                               endNode.getLine(),
                                                                               beginningNode.getColumn(),
                                                                               endNode.getColumn() ) );

      for ( int i = 0; i < messageToReplace.length; i++ )
      {
         violation.replacePlaceholderInMessage( messageToReplace[ i ],
                                                i );
      }

      return violation;
   }

   /**
    * @param violatingNode
    * @param endNode
    * @param messageToReplace
    * @return the add violation replacing the {0} token by the specified message
    */
   protected final IFlexViolation addViolation( final IParserNode violatingNode,
                                                final String... messageToReplace )
   {
      return addViolation( violatingNode,
                           violatingNode,
                           messageToReplace );
   }

   /**
    * @param violationPosition
    * @return the added violation positioned at the given position
    */
   protected final IFlexViolation addViolation( final ViolationPosition violationPosition )
   {
      return addViolation( violations,
                           violationPosition );
   }

   /**
    * find the violations list from the given class node
    * 
    * @param classNode
    */
   protected void findViolations( final IClass classNode )
   {
      findViolationsFromAttributes( classNode.getAttributes() );
      findViolationsFromConstants( classNode.getConstants() );
      findViolations( classNode.getFunctions() );
      if ( classNode.getConstructor() != null )
      {
         findViolationsFromConstructor( classNode.getConstructor() );
      }
   }

   /**
    * find violations in every function in a class
    * 
    * @param function
    */
   protected void findViolations( final IFunction function )
   {
   }

   /**
    * Override this method if you need to find violations from the package ( or
    * any subsequent node like class or function)
    * 
    * @param packageNode
    */
   protected void findViolations( final IPackage packageNode )
   {
      final IClass classNode = packageNode.getClassNode();

      if ( classNode != null )
      {
         findViolations( classNode );
      }
   }

   /**
    * find the violations list from the given functions list
    * 
    * @param functions
    */
   protected void findViolations( final List< IFunction > functions )
   {
      for ( final IFunction function : functions )
      {
         findViolations( function );
      }
   }

   /**
    * find the violations list from the given class variables list
    * 
    * @param variables
    */
   protected void findViolationsFromAttributes( final List< IAttribute > variables )
   {
   }

   /**
    * find the violations list from the given class constants list
    * 
    * @param constants
    */
   protected void findViolationsFromConstants( final List< IConstant > constants )
   {
   }

   /**
    * find the violations list from the given class constructor node
    * 
    * @param constructor
    */
   protected void findViolationsFromConstructor( final IFunction constructor )
   {
   }

   /**
    * Find violations in the current file
    */
   @Override
   protected final List< IFlexViolation > findViolationsInCurrentFile()
   {
      try
      {
         if ( getCurrentPackageNode() != null )
         {
            visitCompilationUnit( getCurrentPackageNode().getInternalNode() );
            findViolations( getCurrentPackageNode() );
         }
      }
      catch ( final Exception e )
      {
         LOGGER.warning( "on "
               + getCurrentFile().getFilePath() );
         LOGGER.warning( StackTraceUtils.print( e ) );
      }
      final List< IFlexViolation > copy = new ArrayList< IFlexViolation >( violations );

      violations.clear();

      return copy;
   }

   /**
    * @param statementNode
    */
   protected void visitAs( final IParserNode statementNode )
   {
   }

   /**
    * @param catchNode
    */
   protected void visitCatch( final IParserNode catchNode )
   {
      visitNameTypeInit( catchNode.getChild( 0 ) );
      visitBlock( catchNode.getChild( 1 ) );
   }

   /**
    * @param classNode
    */
   protected void visitClass( final IParserNode classNode )
   {
      IParserNode content = null;
      for ( final IParserNode node : classNode.getChildren() )
      {
         if ( node.is( NodeKind.CONTENT ) )
         {
            content = node;
            break;
         }
      }
      visitClassContent( content );
   }

   /**
    * Visit the condition of a if, while, ...
    * 
    * @param condition
    */
   protected void visitCondition( final IParserNode condition )
   {
      visitExpression( condition );
   }

   /**
    * @param doNode
    */
   protected void visitDo( final IParserNode doNode )
   {
      visitBlock( doNode.getChild( 0 ) );
      visitCondition( doNode.getChild( 1 ) );
   }

   /**
    * @param ifNode
    */
   protected void visitElse( final IParserNode ifNode )
   {
      visitBlock( ifNode.getChild( 2 ) );
   }

   /**
    * Visit empty statement
    * 
    * @param statementNode
    */
   protected void visitEmptyStatetement( final IParserNode statementNode )
   {
   }

   /**
    * @param finallyNode
    */
   protected void visitFinally( final IParserNode finallyNode )
   {
      if ( isNodeNavigable( finallyNode ) )
      {
         visitBlock( finallyNode.getChild( 0 ) );
      }
   }

   /**
    * @param forNode
    */
   protected void visitFor( final IParserNode forNode )
   {
      visitBlock( forNode.getChild( 3 ) );
   }

   /**
    * @param foreachNode
    */
   protected void visitForEach( final IParserNode foreachNode )
   {
      visitBlock( foreachNode.getChild( 2 ) );
   }

   /**
    * @param functionNode
    * @param type
    */
   protected void visitFunction( final IParserNode functionNode,
                                 final FunctionType type )
   {
      final Iterator< IParserNode > iterator = functionNode.getChildren().iterator();
      IParserNode currentNode = iterator.next();

      while ( currentNode.is( NodeKind.META_LIST )
            || currentNode.is( NodeKind.MOD_LIST ) || currentNode.is( NodeKind.AS_DOC )
            || currentNode.is( NodeKind.MULTI_LINE_COMMENT ) )
      {
         currentNode = iterator.next();
      }
      currentNode = iterator.next();
      visitParameters( currentNode );
      currentNode = iterator.next();
      visitFunctionReturnType( currentNode );
      try
      {
         // Intrinsic functions in AS2
         currentNode = iterator.next();
         visitFunctionBody( currentNode );
      }
      catch ( final NoSuchElementException e )
      {
      }
   }

   /**
    * @param functionReturnTypeNode
    */
   protected void visitFunctionReturnType( final IParserNode functionReturnTypeNode )
   {
      visitBlock( functionReturnTypeNode );
   }

   /**
    * @param ifNode
    */
   protected void visitIf( final IParserNode ifNode )
   {
      visitCondition( ifNode.getChild( 0 ) );
      visitThen( ifNode );
      if ( ifNode.numChildren() == 3 )
      {
         visitElse( ifNode );
      }
   }

   /**
    * @param interfaceNode
    */
   protected void visitInterface( final IParserNode interfaceNode )
   {
   }

   /**
    * @param methodCallNode
    */
   protected void visitMethodCall( final IParserNode methodCallNode )
   {
      final Iterator< IParserNode > iterator = methodCallNode.getChildren().iterator();
      visitExpression( iterator.next() );
      do
      {
         visitExpressionList( iterator.next() );
      }
      while ( iterator.hasNext() );
   }

   /**
    * @param newExpression
    */
   protected void visitNewExpression( final IParserNode newExpression )
   {
      visitExpression( newExpression.getChild( 0 ) );
      visitExpressionList( newExpression.getChild( 1 ) );
   }

   protected void visitOperator( final IParserNode statementNode )
   {
   }

   /**
    * @param functionParametersNode
    */
   protected void visitParameters( final IParserNode functionParametersNode )
   {
      if ( isNodeNavigable( functionParametersNode ) )
      {
         for ( final IParserNode node2 : functionParametersNode.getChildren() )
         {
            visitNameTypeInit( node2.getChild( 0 ) );
         }
      }
   }

   protected void visitRelationalExpression( final IParserNode ast )
   {
      visitExpression( ast,
                       NodeKind.RELATION,
                       new ExpressionVisitor()
                       {
                          public void visitExpression( final IParserNode ast )
                          {
                             visitShiftExpression( ast );
                          }
                       } );
   }

   /**
    * @param ast
    */
   protected void visitReturn( final IParserNode ast )
   {
      if ( isNodeNavigable( ast ) )
      {
         visitExpression( ast.getChild( 0 ) );
      }
   }

   /**
    * @param statementNode
    */
   protected void visitStatement( final IParserNode statementNode )
   {
      switch ( statementNode.getId() )
      {
      case OP:
         visitOperator( statementNode );
         break;
      case AS:
         visitAs( statementNode );
         break;
      case RETURN:
         visitReturn( statementNode );
         break;
      case IF:
         visitIf( statementNode );
         break;
      case FOR:
         visitFor( statementNode );
         break;
      case FOREACH:
         visitForEach( statementNode );
         break;
      case DO:
         visitDo( statementNode );
         break;
      case WHILE:
         visitWhile( statementNode );
         break;
      case SWITCH:
         visitSwitch( statementNode );
         break;
      case TRY:
         visitTry( statementNode );
         break;
      case CATCH:
         visitCatch( statementNode );
         break;
      case FINALLY:
         visitFinally( statementNode );
         break;
      case STMT_EMPTY:
         visitEmptyStatetement( statementNode );
         break;
      case LEFT_CURLY_BRACKET:
         visitBlock( statementNode );
         break;
      default:
         visitExpressionList( statementNode );
      }
   }

   /**
    * @param switchNode
    */
   protected void visitSwitch( final IParserNode switchNode )
   {
      final Iterator< IParserNode > iterator = switchNode.getChildren().iterator();

      visitExpression( iterator.next() );

      final IParserNode cases = iterator.next();

      for ( final IParserNode caseNode : cases.getChildren() )
      {
         final IParserNode child = caseNode.getChild( 0 );

         if ( child.is( NodeKind.DEFAULT ) )
         {
            visitSwitchDefaultCase( caseNode.getChild( 1 ) );
         }
         else
         {
            visitSwitchCase( caseNode.getChild( 1 ) );
            visitExpression( child );
         }
      }
   }

   /**
    * @param switchCaseNode
    */
   protected void visitSwitchCase( final IParserNode switchCaseNode )
   {
      visitBlock( switchCaseNode );
   }

   /**
    * @param defaultCaseNode
    */
   protected void visitSwitchDefaultCase( final IParserNode defaultCaseNode )
   {
      visitBlock( defaultCaseNode );
   }

   /**
    * @param ifNode
    */
   protected void visitThen( final IParserNode ifNode )
   {
      visitBlock( ifNode.getChild( 1 ) );
   }

   /**
    * @param ast
    */
   protected void visitTry( final IParserNode ast )
   {
      visitBlock( ast.getChild( 0 ) );
   }

   /**
    * @param node
    */
   protected void visitVariableInitialization( final IParserNode node )
   {
      visitExpression( node );
   }

   /**
    * @param variableNode
    * @param varOrConst
    * @param scope
    */
   protected void visitVarOrConstList( final IParserNode variableNode,
                                       final VariableOrConstant varOrConst,
                                       final VariableScope scope )
   {
      final Iterator< IParserNode > iterator = variableNode.getChildren().iterator();

      IParserNode node = iterator.next();
      while ( node.is( NodeKind.META_LIST )
            || node.is( NodeKind.MOD_LIST ) )
      {
         node = iterator.next();
      }
      while ( node != null )
      {
         visitNameTypeInit( node );
         node = iterator.hasNext() ? iterator.next()
                                  : null;
      }
   }

   /**
    * @param whileNode
    */
   protected void visitWhile( final IParserNode whileNode )
   {
      visitCondition( whileNode.getChild( 0 ) );
      visitBlock( whileNode.getChild( 1 ) );
   }

   private boolean isAlreadyViolationAdded( final IParserNode nodeToBeAdded )
   {
      for ( final IFlexViolation violation : violations )
      {
         if ( violation.getBeginLine() == nodeToBeAdded.getLine()
               && violation.getBeginColumn() == nodeToBeAdded.getColumn() )
         {
            return true;
         }
      }
      return false;
   }

   private boolean isNodeNavigable( final IParserNode node )
   {
      return node != null
            && node.numChildren() != 0;
   }

   private void visitAdditiveExpression( final IParserNode ast )
   {
      visitExpression( ast,
                       NodeKind.ADD,
                       new ExpressionVisitor()
                       {
                          public void visitExpression( final IParserNode ast )
                          {
                             visitMultiplicativeExpression( ast );
                          }
                       } );
   }

   private void visitAndExpression( final IParserNode ast )
   {
      visitExpression( ast,
                       NodeKind.AND,
                       new ExpressionVisitor()
                       {
                          public void visitExpression( final IParserNode ast )
                          {
                             visitBitwiseOrExpression( ast );
                          }
                       } );
   }

   private void visitArrayAccessor( final IParserNode ast )
   {
      final Iterator< IParserNode > iterator = ast.getChildren().iterator();
      visitExpression( iterator.next() );
      do
      {
         visitExpression( iterator.next() );
      }
      while ( iterator.hasNext() );
   }

   private void visitBitwiseAndExpression( final IParserNode ast )
   {
      visitExpression( ast,
                       NodeKind.B_AND,
                       new ExpressionVisitor()
                       {
                          public void visitExpression( final IParserNode ast )
                          {
                             visitEqualityExpression( ast );
                          }
                       } );
   }

   private void visitBitwiseOrExpression( final IParserNode ast )
   {
      visitExpression( ast,
                       NodeKind.B_OR,
                       new ExpressionVisitor()
                       {
                          public void visitExpression( final IParserNode ast )
                          {
                             visitBitwiseXorExpression( ast );
                          }
                       } );
   }

   private void visitBitwiseXorExpression( final IParserNode ast )
   {
      visitExpression( ast,
                       NodeKind.B_XOR,
                       new ExpressionVisitor()
                       {
                          public void visitExpression( final IParserNode ast )
                          {
                             visitBitwiseAndExpression( ast );
                          }
                       } );
   }

   private void visitBlock( final IParserNode ast )
   {
      if ( isNodeNavigable( ast ) )
      {
         for ( final IParserNode node : ast.getChildren() )
         {
            visitStatement( node );
         }
      }
      else if ( ast != null )
      {
         visitStatement( ast );
      }
   }

   private void visitClassContent( final IParserNode ast )
   {
      if ( isNodeNavigable( ast ) )
      {
         for ( final IParserNode node : ast.getChildren() )
         {
            if ( node.is( NodeKind.VAR_LIST ) )
            {
               visitVarOrConstList( node,
                                    VariableOrConstant.VARIABLE,
                                    VariableScope.IN_CLASS );
            }
            else if ( node.is( NodeKind.CONST_LIST ) )
            {
               visitVarOrConstList( node,
                                    VariableOrConstant.CONSTANT,
                                    VariableScope.IN_CLASS );
            }
         }
         for ( final IParserNode node : ast.getChildren() )
         {
            if ( node.is( NodeKind.FUNCTION ) )
            {
               visitFunction( node,
                              FunctionType.NORMAL );
            }
            else if ( node.is( NodeKind.SET ) )
            {
               visitFunction( node,
                              FunctionType.SETTER );
            }
            else if ( node.is( NodeKind.GET ) )
            {
               visitFunction( node,
                              FunctionType.GETTER );
            }
         }
      }
   }

   private void visitCompilationUnit( final IParserNode ast )
   {
      for ( final IParserNode node : ast.getChildren() )
      {
         if ( node.is( NodeKind.PACKAGE )
               && node.numChildren() >= 2 )
         {
            visitPackageContent( node.getChild( 1 ) );
         }
         if ( !node.is( NodeKind.PACKAGE )
               && node.numChildren() > 0 )
         {
            visitPackageContent( node );
         }
      }
   }

   private void visitConditionalExpression( final IParserNode ast )
   {
      if ( ast != null )
      {
         if ( ast.is( NodeKind.CONDITIONAL ) )
         {
            final Iterator< IParserNode > iterator = ast.getChildren().iterator();
            final IParserNode node = iterator.next();

            visitOrExpression( node );

            while ( iterator.hasNext() )
            {
               visitExpression( iterator.next() );
               visitExpression( iterator.next() );
            }
         }
         else
         {
            visitOrExpression( ast );
         }
      }
   }

   private void visitEqualityExpression( final IParserNode ast )
   {
      visitExpression( ast,
                       NodeKind.EQUALITY,
                       new ExpressionVisitor()
                       {
                          public void visitExpression( final IParserNode ast )
                          {
                             visitRelationalExpression( ast );
                          }
                       } );
   }

   private void visitExpression( final IParserNode ast )
   {
      visitExpression( ast,
                       NodeKind.ASSIGN,
                       new ExpressionVisitor()
                       {
                          public void visitExpression( final IParserNode ast )
                          {
                             visitConditionalExpression( ast );
                          }
                       } );
   }

   private void visitExpression( final IParserNode ast,
                                 final NodeKind kind,
                                 final ExpressionVisitor visitor )
   {
      if ( ast.is( kind ) )
      {
         final Iterator< IParserNode > iterator = ast.getChildren().iterator();
         final IParserNode node = iterator.next();

         visitor.visitExpression( node );

         while ( iterator.hasNext() )
         {
            iterator.next();
            visitor.visitExpression( iterator.next() );
         }
      }
      else
      {
         visitor.visitExpression( ast );
      }
   }

   private void visitExpressionList( final IParserNode ast )
   {
      if ( isNodeNavigable( ast ) )
      {
         for ( final IParserNode node : ast.getChildren() )
         {
            visitExpression( node );
         }
      }
   }

   private void visitFunctionBody( final IParserNode node )
   {
      visitBlock( node );
   }

   private void visitMultiplicativeExpression( final IParserNode ast )
   {
      visitExpression( ast,
                       NodeKind.MULTIPLICATION,
                       new ExpressionVisitor()
                       {
                          public void visitExpression( final IParserNode ast )
                          {
                             visitUnaryExpression( ast );
                          }
                       } );
   }

   private void visitNameTypeInit( final IParserNode ast )
   {
      if ( ast != null
            && ast.numChildren() != 0 )
      {
         final Iterator< IParserNode > iterator = ast.getChildren().iterator();
         IParserNode node;

         iterator.next();
         iterator.next();

         if ( iterator.hasNext() )
         {
            node = iterator.next();
            visitVariableInitialization( node );
         }
      }
   }

   private void visitObjectInitialization( final IParserNode ast )
   {
      if ( isNodeNavigable( ast ) )
      {
         for ( final IParserNode node : ast.getChildren() )
         {
            visitExpression( node.getChild( 1 ) );
         }
      }
   }

   private void visitOrExpression( final IParserNode ast )
   {
      visitExpression( ast,
                       NodeKind.OR,
                       new ExpressionVisitor()
                       {
                          public void visitExpression( final IParserNode ast )
                          {
                             visitAndExpression( ast );
                          }
                       } );
   }

   private void visitPackageContent( final IParserNode ast )
   {
      if ( isNodeNavigable( ast ) )
      {
         for ( final IParserNode node : ast.getChildren() )
         {
            if ( node.is( NodeKind.CLASS ) )
            {
               visitClass( node );
            }
            else if ( node.is( NodeKind.INTERFACE ) )
            {
               visitInterface( node );
            }
         }
      }
   }

   private void visitPrimaryExpression( final IParserNode ast )
   {
      if ( ast.is( NodeKind.NEW ) )
      {
         visitNewExpression( ast );
      }
      else if ( ast.numChildren() != 0
            && ast.is( NodeKind.ARRAY ) )
      {
         visitExpressionList( ast );
      }
      else if ( ast.is( NodeKind.OBJECT ) )
      {
         visitObjectInitialization( ast );
      }
      else if ( ast.is( NodeKind.E4X_ATTR ) )
      {
         final IParserNode node = ast.getChild( 0 );

         if ( !node.is( NodeKind.NAME )
               && !node.is( NodeKind.STAR ) )
         {
            visitExpression( node );
         }
      }
      else
      {
         visitExpressionList( ast );
      }
   }

   private void visitShiftExpression( final IParserNode ast )
   {
      visitExpression( ast,
                       NodeKind.SHIFT,
                       new ExpressionVisitor()
                       {
                          public void visitExpression( final IParserNode ast )
                          {
                             visitAdditiveExpression( ast );
                          }
                       } );
   }

   private void visitUnaryExpression( final IParserNode ast )
   {
      switch ( ast.getId() )
      {
      case PRE_INC:
      case PRE_DEC:
      case MINUS:
      case PLUS:
         visitUnaryExpression( ast.getChild( 0 ) );
         break;
      default:
         visitUnaryExpressionNotPlusMinus( ast );
      }
   }

   private void visitUnaryExpressionNotPlusMinus( final IParserNode ast )
   {
      switch ( ast.getId() )
      {
      case DELETE:
      case VOID:
      case TYPEOF:
      case NOT:
      case B_NOT:
         visitExpression( ast.getChild( 0 ) );
         break;
      default:
         visitUnaryPostfixExpression( ast );
      }
   }

   private void visitUnaryPostfixExpression( final IParserNode ast )
   {
      switch ( ast.getId() )
      {
      case ARRAY_ACCESSOR:
         visitArrayAccessor( ast );
         break;
      case DOT:
      case E4X_FILTER:
         visitExpression( ast.getChild( 0 ) );
         visitExpression( ast.getChild( 1 ) );
         break;
      case POST_INC:
      case POST_DEC:
         visitPrimaryExpression( ast.getChild( 0 ) );
         break;
      case CALL:
         visitMethodCall( ast );
         break;
      case E4X_STAR:
         visitExpression( ast.getChild( 0 ) );
         break;
      default:
         visitPrimaryExpression( ast );
         break;
      }
   }
}
