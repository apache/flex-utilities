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
package com.adobe.ac.pmd.model
{
   import com.adobe.ac.model.IDomainModel;
   
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;

   public class Rule extends EventDispatcher implements IDomainModel // NO PMD BindableClass TooManyFields
   {
	   public static const NAME_CHANGE : String = "nameChange";
	   public static const DELETED_CHANGE : String = "deleteChange";

      public var since : String;
	  [Bindable]
      public var message : String;
	  [Bindable]
      public var examples : String;
	  [Bindable]
      public var description : String;
	  [Bindable]
      public var properties : ListCollectionView = new ArrayCollection();
	  [Bindable]
      public var priority : ViolationPriority;
	  [Bindable]
      public var ruleset : Ruleset;

	  private var _deleted : Boolean = false;
      private var _name : String;

      public function Rule()
      {
      	ruleset = new Ruleset();
      }

      [Bindable( "nameChange" )]
      public function get name() : String
      {
         return _name;
      }

      public function set name( value : String ) : void
      {
         _name = value;
         dispatchEvent( new Event( NAME_CHANGE ) );
      }

      [Bindable( "nameChange" )]
      public function get shortName() : String
      {
         return name.substr( name.lastIndexOf( "." ) + 1 );
      }
	  
	  [Bindable( "deleteChange" )]
	  public function get deleted() : Boolean
	  {
		  return _deleted;
	  }

	  public function remove() : void
	  {
		  _deleted = true;
		  dispatchEvent( new Event( DELETED_CHANGE ) );
	  }

	  public function unDelete() : void
	  {
		  _deleted = false;
		  dispatchEvent( new Event( DELETED_CHANGE ) );
	  }
	}
}