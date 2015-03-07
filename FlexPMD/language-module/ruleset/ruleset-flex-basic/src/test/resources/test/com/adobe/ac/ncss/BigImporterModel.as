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
package com.adobe.ac
{
   import com.adobe.ac.lala;
   import com.adobe.ac.ncss.lala;
   import mx.controls.ComboBox;
   import com.foo.frontendview.vo.PersonVO;
   import lala;

   import lala;

   import lala;
   import lala;
   import lala;
   import lala;
   import lala;

   import lala;

   import lala;
   import lala;
   import lala;
   import lala;

   public class BigModel   
   {
      public function BigModel()
      {    
         dispatchEvent( new Event( "pointlessEvent" ) );     
         return;
      }

      public function foo( param1 : Number, param2 : Number, param3 : Number, param4 : Number, param5 : DataGridColumn ) : void
      {
         var iParam1 : int = param1;
      }

       public function updateIteration(iteration:IterationVO) : void
       {
          iteration.cascadeDatesChanges();
          try {
             AnthologyModel.getInstance().projectModel.iterationDataModel.commit();
          } 
          catch(error:Error) {
             trace("Error while persisting the edited iteration to the database");
             trace(error.message);
          }
       }    

       public function createTestsForStory( story:StoryVO, responder:IResponder ):void
       {
         for each ( var test:CustomerTestVO in story.customerTests ) {
           createTest( test );
         }
         var token:AsyncToken = dataService.commit();
         if ( responder && token ) {
           token.addResponder( responder );
         }
       }         
   }
}