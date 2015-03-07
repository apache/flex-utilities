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
package com.adobe.cairngorm.work
{
   import flash.events.Event;

   /**
    * An event that occurs while processing a work-item.
    */  
   public class WorkEvent extends Event
   {
      //------------------------------------------------------------------------
      //
      //  Constants
      //
      //------------------------------------------------------------------------
      
      //-------------------------------
      //  Event Types : IWorkItem
      //-------------------------------

      public static const WORK_START    : String = "workStart";
      public static const WORK_COMPLETE : String = "workComplete";
      public static const WORK_FAULT    : String = "workFault";

      //-------------------------------
      //  Event Types : IWorkFlow
      //-------------------------------

      public static const WORK_PROGRESS : String = "workProgress";
      public static const CHILD_START    : String = "childStart";
      public static const CHILD_COMPLETE : String = "childComplete";
      public static const CHILD_FAULT    : String = "childFault";
      
      //------------------------------------------------------------------------
      //
      //  Constructor
      //
      //------------------------------------------------------------------------

      public function WorkEvent(
         type : String, 
         workItem : IWorkItem )
      {
         super( type );
         _workItem = workItem;
      }

      //------------------------------------------------------------------------
      //
      //  Static Factory Methods
      //
      //------------------------------------------------------------------------
      
      //-------------------------------
      //  Event Types : IWorkItem
      //-------------------------------

      public static function createStartEvent( 
         workItem : IWorkItem ) : WorkEvent
      {
         return new WorkEvent( WORK_START, workItem );
      }

      public static function createCompleteEvent( 
         workItem : IWorkItem ) : WorkEvent
      {
         return new WorkEvent( WORK_COMPLETE, workItem );
      }

      public static function createFaultEvent( 
         workItem : IWorkItem, 
         message : String = null ) : WorkEvent
      {
         var event : WorkEvent = new WorkEvent( WORK_FAULT, workItem );
         event._message = message;
         return event;
      }

      //-------------------------------
      //  Event Types : IWorkFlow
      //-------------------------------

      public static function createProgressEvent( 
         workItem : IWorkItem, 
         processed : uint,
         size : uint ) : WorkEvent
      {
         var event : WorkEvent = new WorkEvent( WORK_PROGRESS, workItem );
         event._processed = processed;
         event._size = size;
         return event;
      }

      public static function createChildStartEvent( 
         workItem : IWorkItem ) : WorkEvent
      {
         return new WorkEvent( CHILD_START, workItem );
      }

      public static function createChildCompleteEvent( 
         workItem : IWorkItem ) : WorkEvent
      {
         return new WorkEvent( CHILD_COMPLETE, workItem );
      }

      public static function createChildFaultEvent( 
         workItem : IWorkItem, 
         message : String = null ) : WorkEvent
      {
         var event : WorkEvent = new WorkEvent( CHILD_FAULT, workItem );
         event._message = message;
         return event;
      }

      //------------------------------------------------------------------------
      //
      //  Properties
      //
      //------------------------------------------------------------------------
      
      //-------------------------------
      //  workItem
      //-------------------------------
      
      private var _workItem : IWorkItem;
      
      /**
       * The work-item that the event applies to.
       */ 
      public function get workItem() : IWorkItem
      {
         return _workItem;
      }
      
      //-------------------------------
      //  processed
      //-------------------------------

      private var _processed : uint;
      
      public function get processed() :  uint
      {
         return _processed;
      }
      
      //-------------------------------
      //  size
      //-------------------------------

      private var _size : uint;
      
      public function get size() :  uint
      {
         return _size;
      }
      
      //-------------------------------
      //  message
      //-------------------------------

      private var _message : String;
      
      /**
       * The message desribing the cause of a workFault event.
       */ 
      public function get message() :  String
      {
         return _message;
      }
      
      //------------------------------------------------------------------------
      //
      //  Overrides : Event
      //
      //------------------------------------------------------------------------
      
      override public function clone() : Event
      {
         var event : WorkEvent = new WorkEvent( type, _workItem );
         
         event._message = _message;
         event._processed = _processed;
         event._size = _size;
         
         return event;
      }
   }
}