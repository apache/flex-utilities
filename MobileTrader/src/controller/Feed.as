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
/** 
 * Christophe Coenraets, http://coenraets.org
 */
package controller
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import model.Stock;
	import mx.collections.ArrayCollection;

	public class Feed
	{
		protected var index:int = 0;
		
		protected var updateOrder:Array = [6,4,1,7,0,3,2,5]; // used to simulated randomness of updates
		
		protected var timer:Timer;
		
		protected var stockMap:Dictionary;
		
		[Bindable]
		public var stockList:ArrayCollection;
		
		public function Feed()
		{
			stockMap = new Dictionary();
			stockList = new ArrayCollection();
			
			stockList.addItem(new Stock("XOM", 81.39));
			stockList.addItem(new Stock("WMT", 51.47));
			stockList.addItem(new Stock("CVX", 102.93));
			stockList.addItem(new Stock("AIG", 36.01));
			stockList.addItem(new Stock("IBM", 155.49));
			stockList.addItem(new Stock("SAP", 57.53));
			stockList.addItem(new Stock("MOT", 41.50));
			stockList.addItem(new Stock("MCD", 73));
			
			var stockCount:int = stockList.length;
			
			for (var k:int = 0; k < stockCount; k++)
			{
				var s:Stock = stockList.getItemAt(k) as Stock;
				s.open = s.last;
				s.high = s.last;
				s.low = s.last;
				s.change = 0;
				stockMap[s.symbol] = s;
			}
			
			// Simulate history for the last 2 minutes			
			for (var i:int=0; i < 120 ; i++)
			{
				for (var j:int=0 ; j<stockCount ; j++)
				{
					simulateChange(stockList.getItemAt(j) as Stock, false);
				}
			}		
			timer = new Timer(1000 / 8, 0);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		public function subscribe():void
		{
			if (!timer.running) 
			{
				timer.start();
			}
		}
		
		public function unsubscribe():void
		{
			if (timer.running) 
			{
				timer.stop();
			}
		}

		protected function timerHandler(event:TimerEvent):void
		{
			if (index >= stockList.length) index = 0;
			simulateChange(stockList.getItemAt(updateOrder[index]) as Stock, true);
			index++;
		}
		
		protected function simulateChange(stock:Stock, removeFirst:Boolean = true):void
		{
			var maxChange:Number = stock.open * 0.005;
			var change:Number = maxChange - Math.random() * maxChange * 2;
			
			change = change == 0 ? 0.01 : change;
			
			var newValue:Number = stock.last + change;
			
			if (newValue > stock.open * 1.15 || newValue < stock.open * 0.85)
			{
				change = -change;
				newValue = stock.last + change;
			}
			
			stock.change = change;
			stock.last = newValue;
			
			if (stock.last > stock.high)
			{
				stock.high = stock.last;
			}
			else if (stock.last < stock.low || stock.low == 0)
			{
				stock.low = stock.last;
			}
			
			if (!stock.history)
			{
				stock.history = new ArrayCollection();
			}
			if (removeFirst)
			{
				stock.history.removeItemAt(0);
			}
			stock.history.addItem({high: stock.high, low: stock.low, open: stock.open, last: stock.last});
		}
		
	}
}