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
package com.adobe.ac.pmd.services.rulesets
{
   import com.adobe.ac.pmd.services.MyServiceLocator;
   import com.adobe.cairngorm.business.ServiceLocator;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.FileReference;
   
   import mx.rpc.Fault;
   import mx.rpc.IResponder;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   import mx.rpc.http.HTTPService;

   public class RulesetDelegate
   {
	   private var _responder : IResponder;
	   private var _fileReference : FileReference;
	   
	   public function RulesetDelegate()
	   {
	   }

	   public function getRuleset( responder : IResponder, ref : String ) : void
      {
         rulesetService.url = MyServiceLocator.RULESETS_PREFIX + ref;
         rulesetService.send().addResponder( responder );
      }

	  public function getRootRuleset( responder : IResponder ) : void
	  {
		  rootRulesetService.send().addResponder( responder );
	  }
	  
	  public function getCustomRuleset( responder : IResponder ) : void
	  {
		  _responder = responder;
		  _fileReference = new FileReference();
		  _fileReference.addEventListener( Event.SELECT, onRulesetSelected );
		  _fileReference.addEventListener( Event.COMPLETE, onRulesetLoaded );
		  _fileReference.addEventListener( IOErrorEvent.IO_ERROR, onIoError );
		  _fileReference.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
		  _fileReference.browse();
	  }
	  
	  private function onIoError( event : IOErrorEvent ) : void
	  {
		  _responder.fault( new FaultEvent( FaultEvent.FAULT, false, false, new Fault( "", event.text ) ) );	  
	  }
	  
	  private function onSecurityError( event : SecurityError ) : void
	  {
		  _responder.fault( new FaultEvent( FaultEvent.FAULT, false, false, new Fault( event.errorID.toString(), event.message ) ) );	  
	  }

	  private function onRulesetSelected( event : Event ) : void
	  {
		  _fileReference.load();
	  }
	  
	  private function onRulesetLoaded( event : Event ) : void
	  {
		  _responder.result( new ResultEvent( ResultEvent.RESULT, false, false, new XML( FileReference( event.target ).data.toString() ) ) );
	  }

      private function get rootRulesetService() : HTTPService
      {
         return MyServiceLocator( ServiceLocator.getInstance() ).rootRulesetService;
      }

      private function get rulesetService() : HTTPService
      {
         return MyServiceLocator( ServiceLocator.getInstance() ).rulesetService;
      }
   }
}