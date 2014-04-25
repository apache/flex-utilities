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
   public class BigModel   
   {
      public function BigModel()
      {         
      }

      public function foo() : void
      {
          switch(event.type){
             case GoogleSearchPanel.LAUNCH_GOOGLE_WEB_SEARCH:
                googleResquest.url = "";
                toto();
                break;
             case GoogleSearchPanel.LAUNCH_GOOGLE_IMAGE_SEARCH:                   
                googleResquest.url = "";
                vfdvfdvfd;
                vfdvdfvgfnbrn;
                break;
             case GoogleSearchPanel.LAUNCH_GOOGLE_NEWS_SEARCH:
                googleResquest.url = "";
                switch (e.oldState) {
                  case STATE_COMPARE_VIEW :
                     createPlaceHolders();
                     createPlaceHolderLabels();
                  break;
                  case STATE_COMPARE_VIEW :
                     if (productsInCompare.length < 3) {
                        drawPlaceHolder(PLACEHOLDER_COORDS[2] as Point);
                        lastPlaceholderLabel = createPlaceHolderLabel(PLACEHOLDER_COORDS[2] as Point);
                     }
                     showCompareButton();
                  break;
               }
                break;                     
          }
          testCase.setTestResult( this );

         var protectedTestCase : Protectable = Protectable( new ProtectedStartTestCase( testCase ) );

         var startOK : Boolean = doProtected( testCase, protectedTestCase );

         if ( startOK )
         {
              doContinue( testCase );
         }
         else
         {
             endTest( testCase );             
         }
         var startOK : Boolean = doProtected( testCase, protectedTestCase );

         if ( startOK )
         {
              doContinue( testCase );
         }
         else
         {
             endTest( testCase );             
         }         
         switch(event.type){
             case GoogleSearchPanel.LAUNCH_GOOGLE_WEB_SEARCH:
                googleResquest.url = "";
                break;
             case GoogleSearchPanel.LAUNCH_GOOGLE_IMAGE_SEARCH:                   
                googleResquest.url = "";
                break;
             case GoogleSearchPanel.LAUNCH_GOOGLE_IMAGE_SEARCH2:                   
                googleResquest.url = "";
                break;
             default:
         }
      }
	  
	  public function fooBar() : void
	  {
		  try
		  {
			  var illl : int = 0;
			  do
			  {
				  illl++;
				  ;
			  }while(illl<10)
		  }
		  catch( e : Error )
		  {
			  {
			  	Message.show("");
			  }
		  }
		  finally
		  {
			  trace("");
		  }
		  
		  do
		  {
		  } while( i < 5 );
		  
		  switch(event.type){
			  case GoogleSearchPanel.LAUNCH_GOOGLE_WEB_SEARCH:
				  googleResquest.url = "";
			  case GoogleSearchPanel.LAUNCH_GOOGLE_IMAGE_SEARCH:                   
			  case GoogleSearchPanel.LAUNCH_GOOGLE_IMAGE_SEARCH2:                   
				  googleResquest.url = "";
				  break;
			  default:
				  return;
		  }
	  }
   }
}