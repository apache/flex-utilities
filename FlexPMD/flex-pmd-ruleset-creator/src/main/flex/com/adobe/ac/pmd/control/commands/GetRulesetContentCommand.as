////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package com.adobe.ac.pmd.control.commands
{
   import com.adobe.ac.pmd.api.IGetRulesetContent;
   import com.adobe.ac.pmd.control.events.GetRulesetContentEvent;
   import com.adobe.ac.pmd.model.Ruleset;
   import com.adobe.ac.pmd.services.rulesets.RulesetDelegate;
   import com.adobe.ac.pmd.services.translators.RulesetTranslator;
   import com.adobe.cairngorm.commands.ICommand;
   import com.adobe.cairngorm.control.CairngormEvent;

   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.IResponder;
   import mx.rpc.events.ResultEvent;

   public class GetRulesetContentCommand implements ICommand, IResponder
   {
      private static const LOG : ILogger = 
         Log.getLogger( "com.adobe.ac.pmd.control.commands.GetRulesetContentCommand" );

      private var invoker : IGetRulesetContent;

      public function GetRulesetContentCommand()
      {
      }

      public function execute( event : CairngormEvent ) : void
      {
         invoker = GetRulesetContentEvent( event ).invoker;
         new RulesetDelegate().getRuleset( this, GetRulesetContentEvent( event ).ref );
      }

      public function result( data : Object ) : void // NO PMD
      {
         var xml : XML = ResultEvent( data ).result as XML;
         var ruleset : Ruleset = RulesetTranslator.deserialize( xml );

		 trace( "received " + ruleset.name + " length " + ruleset.rules.length );
         invoker.onReceiveRulesetContent( ruleset );
      }

      public function fault( info : Object ) : void // NO PMD
      {
         LOG.error( info.toString() );
      }
   }
}