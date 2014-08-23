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
package qs.utils
{
	import mx.core.IFactory;
	import mx.core.UIComponent;
	import flash.display.DisplayObject;
	import mx.events.IndexChangedEvent;
	import flash.utils.Dictionary;


public class AssociativeInstanceCache
{
	public function AssociativeInstanceCache():void
	{
	}
	
	
	private var _factory:IFactory;
	
	public var createCallback:Function;
	public var assignCallback:Function;
	public var releaseCallback:Function;	
	public var destroyCallback:Function;
	
	private var _instances:Array = [];
	private var _associations:Dictionary;
	private var _oldAssociations:Dictionary;
	private var _reserve:Array = [];


	public var destroyUnusedInstances:Boolean = false;
	
	public static function showInstance(i:DisplayObject,idx:int):void
	{
		i.visible = true;
	}
	public static function hideInstance(i:DisplayObject):void
	{
		i.visible = false
	}
	public static function removeInstance(i:DisplayObject):void
	{
		i.parent.removeChild(i);
	}
	public function get factory():IFactory {return _factory;}
	public function set factory(value:IFactory):void
	{
		if(value == _factory)
			return;
		_factory = value;
		destroyAllInstances();
	}
	
	public function get instances():Array
	{
		return _instances;
	}
	
	public function destroyAllInstances():void
	{
		var i:int;
		for(var aKey:* in _associations)
		{
			var inst:* = _associations[aKey];
			if(releaseCallback != null)
				releaseCallback(inst);
			if(destroyCallback != null)
				destroyCallback(inst);
		}
		for(i = 0;i<_reserve.length;i++)
		{
			if(destroyCallback != null)
				destroyCallback(_reserve[i]);
		}
		_reserve = [];
		_associations = new Dictionary(true);
	}
	

	public function beginAssociation():void
	{	
		_oldAssociations = _associations;
		_associations = new Dictionary(true);
	}
	public function endAssociation():void
	{
		for(var aKey:* in _oldAssociations)
		{
			var inst:* = _oldAssociations[aKey];
			if (destroyUnusedInstances)
			{
				if (destroyCallback != null)
					destroyCallback(inst);									
			}
			else
			{
				if (releaseCallback != null)
					releaseCallback(inst);					
				_reserve.push(inst);
			}
		}
		_oldAssociations = null;
	}
	
	public function associate(key:*):*
	{
		var instance:* = _oldAssociations[key];
		if(instance != null)
		{
			delete _oldAssociations[key];		
		}
		else
		{
			if(_reserve.length > 0)
			{
				instance = _reserve.pop();
				if(assignCallback != null)
					assignCallback(instance);				
			}
			else
			{
				instance = _factory.newInstance();
				if(createCallback != null)
					createCallback(instance);
				if(assignCallback != null)
					assignCallback(instance);
			}
		}
		_associations[key] = instance;
		return instance;
	}
}
	
}