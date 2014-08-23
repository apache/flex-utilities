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
package com.devgirl.runtracker.service
{
	import com.devgirl.runtracker.events.DeleteLocalEvent;
	import com.devgirl.runtracker.events.RunListResultEvent;
	import com.devgirl.runtracker.events.SaveLocalEvent;
	import com.devgirl.runtracker.vo.RunVO;
	
	import flash.data.SQLColumnSchema;
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLStatement;
	import flash.data.SQLTableSchema;
	import flash.errors.SQLError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	[Event(name=LOCAL_SAVE_FAIL,type="flash.events.Event")]
	[Event(name=LOCAL_DELETE_ALL_SUCCESS,type="flash.events.Event")]
	[Event(name="runListEvent",type="com.devgirl.runtracker.events.RunListResultEvent")]
	
	
	public class DBService extends EventDispatcher
	{
		private var runDB:SQLConnection;
		private var dbStatement:SQLStatement;
		private var currentRun:RunVO;
		private var lastUpdateRowId:int;
		
		[Bindable]
		private var runCollection:Array = new Array();
		
		public static const LOCAL_SAVE_FAIL:String = "localSaveFailed";
		public static const LOCAL_DELETE_ALL_SUCCESS:String = "deleteAllSuccess";
		
		
		public function DBService()
		{
			trace("DB Service init");
			var dbFile:File = File.applicationStorageDirectory.resolvePath("runtracker5.db");
			dbStatement = new SQLStatement();
			dbStatement.itemClass = RunVO;
			runDB = new SQLConnection();
			dbStatement.sqlConnection = runDB;
			runDB.addEventListener(SQLEvent.OPEN, onDatabaseOpen);
			runDB.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			runDB.open(dbFile);	
		}
		
		
		private function onDatabaseOpen(event:SQLEvent):void
		{
			dbStatement.text = "CREATE TABLE IF NOT EXISTS runtracker (run_id INTEGER PRIMARY KEY AUTOINCREMENT, runDate TEXT, " +
				"pace TEXT, miles REAL, notes TEXT)";
			dbStatement.addEventListener(SQLEvent.RESULT, handleOpenResult);
			dbStatement.addEventListener(SQLErrorEvent.ERROR, createError);			
			dbStatement.execute();
		}
		
		private function handleOpenResult(event:SQLEvent):void
		{
			var result:SQLResult = dbStatement.getResult();
			dbStatement.removeEventListener(SQLEvent.RESULT, handleOpenResult);
			dbStatement.removeEventListener(SQLErrorEvent.ERROR, createError);			

		}
		
		private function handleAlterResult(event:SQLEvent):void
		{
			// nothing to do here
			dbStatement.removeEventListener(SQLEvent.RESULT, handleAlterResult);			
			trace("New column added");
		}
				
		
		
		private function handleListResult(event:SQLEvent):void
		{
			var result:SQLResult = dbStatement.getResult();
			trace("Handling list result... " + result.data);
			if (result.data != null) {  
				this.runCollection = result.data;
				dispatchEvent(new RunListResultEvent(new ArrayCollection(this.runCollection)));
			}
		}
		
		private function handleSaveResult(event:SQLEvent):void
		{
			dbStatement.removeEventListener(SQLEvent.RESULT, handleSaveResult);
			dispatchEvent(new SaveLocalEvent(runDB.lastInsertRowID));
		}
		
		private function handleUpdateResult(event:SQLEvent):void
		{
			dispatchEvent(new SaveLocalEvent(lastUpdateRowId));
		}
		
		private function handleDeleteResult(event:SQLEvent):void
		{
			if (event.target.sqlConnection.totalChanges > 0)
				dispatchEvent(new DeleteLocalEvent(currentRun));
		}
		
		private function handleDeleteAllResult(event:SQLEvent):void
		{
			dispatchEvent(new Event(DBService.LOCAL_DELETE_ALL_SUCCESS));
		}
		
		public function getRuns():void
		{
			dbStatement = new SQLStatement();
			dbStatement.itemClass = RunVO;
			dbStatement.sqlConnection = runDB;
			trace("SQL " + dbStatement.itemClass);
			dbStatement.text = "SELECT * FROM runtracker";
			dbStatement.addEventListener(SQLEvent.RESULT, handleListResult);
			dbStatement.addEventListener(SQLErrorEvent.ERROR, createError);	
			dbStatement.execute();
		}
		
		public function saveLocal(runs:ArrayCollection):void
		{
			for each (var item:RunVO in runs)
			{
				addRun(item);
			}
		}
		
		public function updateRun(run:RunVO):void
		{
			var sql:String = "UPDATE runtracker SET date=:run_date, pace=:run_pace, miles=:run_miles, " +
							 "notes=:run_notes WHERE run_id=:run_runid";
			
			dbStatement = new SQLStatement();
			dbStatement.sqlConnection = runDB;
			dbStatement.text = sql;
			
			dbStatement.parameters[":run_date"] = run.runDate;
			dbStatement.parameters[":run_pace"] = run.pace;
			dbStatement.parameters[":run_miles"] = run.miles;
			dbStatement.parameters[":run_notes"] = run.notes;
			dbStatement.parameters[":run_runid"] = run.run_id;
			
			// Use the same save result listener as when we insert, same behavior needed in controller...
			dbStatement.addEventListener(SQLEvent.RESULT, handleUpdateResult);
			lastUpdateRowId = run.run_id;
			dbStatement.execute();
		}
		
		public function addRun(run:RunVO):void
		{
			var sql:String = "INSERT into runtracker(runDate,pace,miles,notes) VALUES " +
				"(?, ?, ?, ?)";
			dbStatement = new SQLStatement();
			dbStatement.sqlConnection = runDB;
			dbStatement.text = sql;
			
			dbStatement.parameters[0] = run.runDate;
			dbStatement.parameters[1] = run.pace;
			dbStatement.parameters[2] = run.miles;
			dbStatement.parameters[3] = run.notes;
			
			dbStatement.addEventListener(SQLEvent.RESULT, handleSaveResult);
			dbStatement.execute();
		}
		
		public function deleteRun(run:RunVO):void
		{
			var sqlDelete:String = "delete from runtracker where run_id='"+run.run_id+"';";
			dbStatement = new SQLStatement();
			dbStatement.sqlConnection = runDB;
			dbStatement.text = sqlDelete;
			dbStatement.addEventListener(SQLEvent.RESULT, handleDeleteResult);
			currentRun = run;
			dbStatement.execute();
		}
		
		public function deleteRuns(runList:ArrayCollection):void
		{
			var sqlDelete:String = "delete from runtracker";
			dbStatement = new SQLStatement();
			dbStatement.sqlConnection = runDB;
			dbStatement.text = sqlDelete;
			dbStatement.addEventListener(SQLEvent.RESULT, handleDeleteAllResult);
			dbStatement.execute();
		}
		
		private function errorHandler(error:SQLError):void
		{
			Alert.show("SQL Error occurred on operation: " + error.operation + " message " + error.message);
		}
		
		private function createError(event:SQLErrorEvent):void
		{
			dispatchEvent(new Event(DBService.LOCAL_SAVE_FAIL));
		}
	}
}