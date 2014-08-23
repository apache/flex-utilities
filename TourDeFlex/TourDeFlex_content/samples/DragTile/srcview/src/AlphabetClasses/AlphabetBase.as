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

package AlphabetClasses
{
import mx.core.Application;
import flash.utils.Timer;
import flash.events.TimerEvent;
import qs.controls.DragTile;
import mx.core.UIComponent;
import flash.utils.getTimer;

public class AlphabetBase extends mx.core.Application
{
	[Bindable] public var items:Array;
	[Bindable] protected var startTime:Number;
	[Bindable] protected var runningTime:Number;
	[Bindable] protected var itemsRemaining:Number;
	[Bindable] protected var itemsCorrect:Number;			
	private var _timer:Timer;
	
	public var dragTile:DragTile;
	public var runningUI:UIComponent;
	public var completeUI:UIComponent;
	
	public function AlphabetBase():void
	{
		var items:Array = [];
		var A:int = ("A").charCodeAt(0);
					
		for(var i:int=0;i<26;i++)
		{
			items.push( String.fromCharCode(A + i) );
		}
		this.items = items;
		
		_timer = new Timer(100);
		_timer.addEventListener(TimerEvent.TIMER,updateTime);
	}
	
	protected function initTrial():void
	{
		for(var i:int = items.length - 1;i>= 0;i--)
		{
			var newIdx:int = Math.round(Math.random()*i);
			var tmp:Object = items[i];
			items[i] = items[newIdx];
			items[newIdx] = tmp;
		}
	
		dragTile.dataProvider = items;	
		startTime = getTimer();
		runningUI.visible = true;
		completeUI.visible = false;
		itemsRemaining = items.length;
		itemsCorrect = 0;
		
		_timer.reset();
		_timer.start();
	}
	protected function updateTime(e:TimerEvent):void
	{
		runningTime = Math.floor((getTimer() - startTime)/100)/10;
	}
	protected function checkComplete():void
	{
		var prevVal:String;
		var goodCount:int = 0;
		var badCount:int = 0;
		var A:int = ("A").charCodeAt(0);
		for(var i:int = 0;i<items.length;i++)
		{
			if(items[i].charCodeAt(0) - A == i)		
				goodCount++;
			else
				badCount++;						
		}
		if(badCount == 0)
		{
			completeUI.visible = true;
			_timer.stop();
		}
		itemsRemaining = badCount;
		itemsCorrect = goodCount;
	}
	
}
}
