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
package classes
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.collections.XMLListCollection;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	
	import plugin.Component; //HS
	
	public class ObjectData
	{		
		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		[Bindable] public var topLevelCategoriesXml:XMLList;		
		[Bindable] public var listXml:XMLListCollection;
		[Bindable] public var treeXml:XMLListCollection;
		[Bindable] public var featuredTreeXml:XMLListCollection;		
		[Bindable] public var searchTags:Array;
		private var objectXml:XML;
		private var selectedTopLevelCategory:String = "";
		private var previousSortType:String;

		//--------------------------------------------------------------------------
		//  Loading/setup
		//--------------------------------------------------------------------------		
		public function ObjectData()
		{		
			loadData();
		}
		
		public function loadData():void
		{
			var objectsUrl:String = Config.OBJECTS_URL;
			trace(objectsUrl);
			var updatableObjectFile:File = File.applicationStorageDirectory.resolvePath(Config.OBJECTS_FILE);
			var staticObjectFile:File = File.applicationDirectory.resolvePath(Config.OBJECTS_URL);
					
			if(Config.isAppFirstTimeRun() || !updatableObjectFile.exists)
				staticObjectFile.copyTo(updatableObjectFile, true);
		
			var loader:URLLoader = new URLLoader(new URLRequest("file://" + updatableObjectFile.nativePath));
			loader.addEventListener(Event.COMPLETE, objectsXmlLoaded);			
		}		
		
		private function objectsXmlLoaded(event:Event):void
		{
			trace("OBJECTS LOADED");
			var loader:URLLoader = URLLoader(event.target);
			objectXml = new XML(loader.data);
			
			loadSettings();
			loadCategoriesAndObjects()
			checkForNewObjectXml();
		}
		
		private function loadCategoriesAndObjects():void
		{
			Config.OBJECTS_FILE_VERSION = objectXml.@version;
			Config.OBJECTS_TOTAL = XMLList(objectXml..Object).length();
			
			var searchTagsLabels:Array = String(objectXml.@searchTags).split(",");
			var searchTagsTotals:Array = String(objectXml.@searchTagsTotals).split(",");
			var searchTagsCombined:Array = new Array();

			for(var i:int=0; i<searchTagsLabels.length; i++)
				searchTagsCombined.push([searchTagsLabels[i], searchTagsTotals[i]]);
				
			searchTags = searchTagsCombined;
											
			topLevelCategoriesXml = new XMLList(objectXml.children().@name);
			selectedTopLevelCategory = topLevelCategoriesXml[0];
			filterTopLevelCategory(selectedTopLevelCategory);	
		}

		//--------------------------------------------------------------------------
		//  Filtering
		//--------------------------------------------------------------------------		
		public function filterTopLevelCategory(category:String):void
		{
			selectedTopLevelCategory = category;
			listXml = new XMLListCollection(objectXml.Category.(@name == category)..Object);
			//treeXml = new XMLListCollection(XMLList(objectXml.Category.(@name == category)));
			treeXml = new XMLListCollection(XMLList(objectXml.Category));
		}
		
		public function filterList(filterText:String, onlyTags:Boolean = false):XMLList // HS
		{
			filterText = filterText.toLowerCase();
			var filterTextTerms:Array = filterText.split(" ");
			var filteredList:XMLList = new XMLList();
			
			//for each(var objectItem:XML in objectXml.Category.(@name == selectedTopLevelCategory)..Object)
			//for each(var objectItem:XML in objectXml..Object)
			
			var objectsToSearch:XML = objectXml.copy();
			delete objectsToSearch.Category.(@name == "Featured").*;
			
			for each(var objectItem:XML in objectsToSearch..Object)
			{
				var name:String = objectItem.@name.toLowerCase();
				var tags:String = objectItem.@tags.toLowerCase();
				var author:String = objectItem.@author.toLowerCase();
				
				for each(var term:String in filterTextTerms)
				{								
					var found:Boolean = false;
					if(onlyTags)
					{
						if(tags.indexOf(term) != -1)
							found = true;
					}
					else
					{
						if(name.indexOf(term) != -1 || author.indexOf(term) != -1 || tags.indexOf(term) != -1)
							found = true;
					}
					
					if(found)
					{
						filteredList += objectItem;
						break;					
					}					
				}
			}
			
			listXml = new XMLListCollection(filteredList);
			sort(previousSortType);
			return filteredList; //HS
		}

		public function sort(sortType:String = ObjectListSortTypes.ALPHABETICAL):void
		{
			previousSortType = sortType;
			var sortField:String = "@name";
			var descending:Boolean = false;
			var numeric:Boolean = false;
			
			switch(sortType)
			{
				case ObjectListSortTypes.ALPHABETICAL:
					sortField = "@name";
					break;
				case ObjectListSortTypes.MOST_RECENT:
					sortField = "@dateAdded";
					descending = true;
					break;
				case ObjectListSortTypes.MOST_POPULAR:
					sortField = "@viewCount";
					descending = true;
					numeric = true;
					break;
			}

			var sort:Sort = new Sort();
			sort.fields = [new SortField(sortField, true, descending, numeric)];
			listXml.sort = sort;
			listXml.refresh();
		}
			
		//--------------------------------------------------------------------------
		//  Settings / localization
		//--------------------------------------------------------------------------	
		private function loadSettings():void
		{			
			Config.PROGRAM_TITLE = objectXml.Settings.@title;
			Config.ABOUT_MENU_LIST = objectXml.Settings.AboutMenu.Item;
			Config.ABOUT_MENU_TITLE = objectXml.Settings.AboutMenu.@title;
			
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			Config.APP_VERSION = appXml.ns::version;					
		}		
		
		//--------------------------------------------------------------------------
		//  Checking for new objects.xml and updating it 
		//--------------------------------------------------------------------------		
		private function checkForNewObjectXml():void
		{
			var loader:URLLoader = new URLLoader(new URLRequest(Config.OBJECTS_UPDATER_URL));
			loader.addEventListener(Event.COMPLETE, objectsUpdaterXmlLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, objectsUpdaterXmlLoadedError);
		}
		
		private function objectsUpdaterXmlLoadedError(event:IOErrorEvent):void
		{
		}
				
		private function objectsUpdaterXmlLoaded(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var objectsUpdaterXml:XML = new XML(loader.data);
			
			var currentVersion:String = objectXml.@version;
			var onlineVersion:String = objectsUpdaterXml.version;
			var onlineVersionDescription:String = objectsUpdaterXml.description;
			
			if(onlineVersion > currentVersion) {
				downloadNewObjectXml(objectsUpdaterXml.url);
				if(onlineVersionDescription.length > 0) {
					// Only show notice if a description was provided, otherwise, silent install
					var myPattern:RegExp = /\r\n/g;  
					onlineVersionDescription = onlineVersionDescription.replace(myPattern,"\n");					
					Alert.show(onlineVersionDescription, "Samples Database Updated to Version " + onlineVersion);
				}
			}
		}
		
		private function downloadNewObjectXml(path:String):void
		{
			var loader:URLLoader = new URLLoader(new URLRequest(path));
			loader.addEventListener(Event.COMPLETE, updatedObjectsXmlLoaded);
			CursorManager.setBusyCursor();	
		}
		
		public function updatedObjectsXmlLoaded(event:Event):void
		{
			var file:File = File.applicationStorageDirectory;
			file = file.resolvePath(Config.OBJECTS_FILE);
			if(file.exists)
				file.deleteFile();

			var loader:URLLoader = URLLoader(event.target);

			objectXml = new XML(loader.data);	
			loadSettings();	
			loadCategoriesAndObjects();			

			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(objectXml.toXMLString());
			fileStream.close();	
			CursorManager.removeBusyCursor();	

		}			
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------	
		//------------------------------------------------------------------------
		// Convert the XML objects into Component objects so they map to the remote 
		// java object for easier processing by plug-in. HS
		//------------------------------------------------------------------------
		private function createComponentsFromXML(xmlList:XMLList):ArrayCollection 
		{	
			var objectsAsComponents:ArrayCollection = new ArrayCollection();
			for each(var object:XML in xmlList)
			{
				trace("Component name " + object.attribute("name") + " id " + object.attribute("id"));	
				var c:Component = new Component();
				c.id = object.attribute("id");
				c.name = object.attribute("name");	
				c.author = object.attribute("author");
				c.description = object.attribute("description");
				objectsAsComponents.addItem(c);	
			}
			return objectsAsComponents;
		}
		//-----------------------------------------------------
		// Find the matching components based on the search string
		// passed from the Eclipse plug-in and add them to an Array
		// Collection as component objects for return via Merapi. HS
		//-----------------------------------------------------
		public function getFilteredComponents(filter:String):ArrayCollection
		{
			// First setup the XML list based on the search string from the plugin
			var resultList:XMLList = filterList(filter);			
			var objectsAsComponents:ArrayCollection = createComponentsFromXML(resultList);
			return objectsAsComponents;
		}
		//-----------------------------------------------------
		// Fetch the list of featured components and convert them
		// to component objects and add them to the array collection
		// that will be returned to the eclipse plug-in. HS
		//-----------------------------------------------------
		public function getFeaturedComponents():ArrayCollection
		{
			// First setup the XML list based on the search string from the plugin
			// Featured Components are the first child in the object XML...

			var featXml:XML = objectXml.children()[0];
			trace("Top level categories: " + featXml + objectXml.contains("Category"));
			var featObjsList:XMLList = featXml.descendants("Object")
			var objectsAsComponents:ArrayCollection = createComponentsFromXML(featObjsList);			
			return objectsAsComponents;
			
		}
		//-----------------------------------------------------
		// Fetch the XML object for the id that was passed in
		// from the Eclipse plug-in so we can navigate to that
		// object for display. HS
		//-----------------------------------------------------
		public function getXMLForObjectId(matchId:String):XML {
			var objects:XMLList = XMLList(objectXml..Object);
			for each(var objectItem:XML in objects) {
				var id:String = objectItem.@id.toLowerCase();
				var name:String = objectItem.@name.toLowerCase();
				var tags:String = objectItem.@tags.toLowerCase();
				var author:String = objectItem.@author.toLowerCase();
				if (id == matchId) {
					trace("NAME: " + name + " id " + id);
					return objectItem;
				}
			}
			return null;
		}

	}
}