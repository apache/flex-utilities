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

package org.apache.flex.packageflexsdk.resource
{

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.flash_proxy;

import mx.collections.ArrayCollection;
import mx.events.PropertyChangeEvent;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

[Bindable(event="propertyChange")]
public dynamic class ViewResourceConstants extends Proxy implements IEventDispatcher
{
	
	//--------------------------------------------------------------------------
	//
	//    Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const BUNDLE_NAME:String = "resourceStrings";
	
	public static const DEFAULT_LANGUAGE:String = RuntimeLocale.EN_US;
	
	//--------------------------------------------------------------------------
	//
	//    Class properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    instance
	//----------------------------------
	
	private static var _instance:ViewResourceConstants;
	
	public static function get instance():ViewResourceConstants
	{
		if (!_instance)
			_instance = new ViewResourceConstants(new SE());
		
		return _instance;
	}
	
	//----------------------------------
	//    supportedLanguages
	//----------------------------------
	
	public static function get supportedLanguages():ArrayCollection
	{
		var result:ArrayCollection = new ArrayCollection();

		result.addItem({label: "Deutsch ", data: RuntimeLocale.DE_DE});
		result.addItem({label: "English (US)", data: RuntimeLocale.EN_US});
		result.addItem({label: "English (AU)", data: RuntimeLocale.EN_AU});
		result.addItem({label: "English (GB)", data: RuntimeLocale.EN_GB});
		result.addItem({label: "Español (ES)", data: RuntimeLocale.ES_ES});
		result.addItem({label: "Français", data: RuntimeLocale.FR_FR});
		result.addItem({label: "Greek", data: RuntimeLocale.EL_GR});
		result.addItem({label: "Nederlands", data: RuntimeLocale.NL_NL});
		result.addItem({label: "Português", data: RuntimeLocale.PT_BR});
		
		return result;
	}
	
	//--------------------------------------------------------------------------
	//
	//    Constructor
	//
	//--------------------------------------------------------------------------
	
	public function ViewResourceConstants(se:SE) 
	{
		_eventDispatcher = new EventDispatcher();
		
		RuntimeLocale.instance.installResources();
	}
		
	//--------------------------------------------------------------------------
	//
	//    Variables
	//
	//--------------------------------------------------------------------------
	
	private var _content:Dictionary;
	
	private var _eventDispatcher:EventDispatcher;
	
	private var _resourceManager:IResourceManager = ResourceManager.getInstance();;
	
	//--------------------------------------------------------------------------
	//
	//    Methods
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    addEventListener
	//----------------------------------
	
	public function addEventListener(type:String, listener:Function, 
									 useCapture:Boolean = false, priority:int = 0, 
									 useWeakReference:Boolean = false):void
	{
		_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	//----------------------------------
	//    dispatchEvent
	//----------------------------------
	
	public function dispatchEvent(event:Event):Boolean
	{
		return _eventDispatcher.dispatchEvent(event);
	}
	
	//----------------------------------
	//    getProperty
	//----------------------------------
	
	override flash_proxy function getProperty(name:*):*
	{
		if (!_content[name])
		{
			var errorString:String = "The key was not found in the resource strings (key: '" + name + "').";
			
			trace(errorString);
			
			throw new Error(errorString);
		}
		
		return _content[name];
	}
	
	//----------------------------------
	//    hasEventListener
	//----------------------------------
	
	public function hasEventListener(type:String):Boolean
	{
		return _eventDispatcher.hasEventListener(type);
	}
	
	//----------------------------------
	//    removeEventListener
	//----------------------------------
	
	public function removeEventListener(type:String, listener:Function, 
										useCapture:Boolean = false):void
	{
		_eventDispatcher.removeEventListener(type, listener, useCapture);
	}
	
	//----------------------------------
	//    update
	//----------------------------------
	
	public function update(event:Event = null):void
	{
		_content = new Dictionary();
		
		var messageStringsContentDefault:Object;
		var messageStringsContentLocalized:Object;
		
		var n:int = _resourceManager.localeChain.length;
		messageStringsContentDefault = 
				_resourceManager.getResourceBundle(_resourceManager.localeChain[n - 1], BUNDLE_NAME).content;
		
		if (n > 1)
			messageStringsContentLocalized = 
				_resourceManager.getResourceBundle(_resourceManager.localeChain[0], BUNDLE_NAME).content;
		
		var useLocalizedString:Boolean;
		var event:Event;
		for (var key:String in messageStringsContentDefault)
		{
			useLocalizedString = messageStringsContentLocalized && 
				messageStringsContentLocalized[key] &&
				messageStringsContentLocalized[key] != "";
			
			_content[key] = (useLocalizedString) ? 
				messageStringsContentLocalized[key] : messageStringsContentDefault[key];
			
			event = PropertyChangeEvent.createUpdateEvent(this, key, "", _content[key]);
			dispatchEvent(event);
		}
	}
	
	//----------------------------------
	//    willTrigger
	//----------------------------------
	
	public function willTrigger(type:String):Boolean
	{
		return _eventDispatcher.willTrigger(type);
	}
		
}
}

class SE {}