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
package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.text.*;
	import flash.utils.*;
	
	/**
	 *   An app to test function call performance
	 *   @author Jackson Dunstan
	 */
	public class FunctionPerformanceTest extends Base implements IInterface
	{
		private function privateFunction(): void {}
		protected function protectedFunction(): void {}
		internal function internalFunction(): void {}
		public function publicFunction(): void {}
		
		private function get privateGetFunction(): int { return 0; }
		protected function get protectedGetFunction(): int { return 0; }
		internal function get internalGetFunction(): int { return 0; }
		public function get publicGetFunction(): int { return 0; }
		
		private function set privateSetFunction(val:int): void {}
		protected function set protectedSetFunction(val:int): void {}
		internal function set internalSetFunction(val:int): void {}
		public function set publicSetFunction(val:int): void {}
		
		private static function staticPrivateFunction(): void {}
		protected static function staticProtectedFunction(): void {}
		internal static function staticInternalFunction(): void {}
		public static function staticPublicFunction(): void {}
		
		override protected function overrideProtectedFunction(): void {}
		override internal function overrideInternalFunction(): void {}
		override public function overridePublicFunction(): void {}
		
		final private function finalPrivateFunction(): void {}
		final protected function finalProtectedFunction(): void {}
		final internal function finalInternalFunction(): void {}
		final public function finalPublicFunction(): void {}
		
		final override protected function finalOverrideProtectedFunction(): void {}
		final override internal function finalOverrideInternalFunction(): void {}
		final override public function finalOverridePublicFunction(): void {}
		
		public function interfaceFunction(): void {}
		
		private var __logger:TextField; 
		
		/**
		 *   Application entry point
		 */
		public function FunctionPerformanceTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			__logger = new TextField();
			__logger.autoSize = TextFieldAutoSize.LEFT;
			addChild(__logger);
			
			addEventListener(Event.ENTER_FRAME, testDynamicFunctions);
		}
		
		private function testDynamicFunctions(ev:Event): void
		{
			var beforeTime:int;
			var i:int;
			const NUM_ITERATIONS:int = 10000000;
			
			function localFunction(): void {}
			var functionVarFunction:Function = function(): void {}
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				plainFunction();
			}
			log("Plain: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				localFunction();
			}
			log("Local: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				functionVarFunction();
			}
			log("Function var: " + (getTimer()-beforeTime));
			
			log("");
			
			removeEventListener(Event.ENTER_FRAME, testDynamicFunctions);
			addEventListener(Event.ENTER_FRAME, testMethods);
		}
		
		private function testMethods(ev:Event): void
		{
			var beforeTime:int;
			var i:int;
			const NUM_ITERATIONS:int = 10000000;
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				privateFunction();
			}
			log("Private: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				protectedFunction();
			}
			log("Protected: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				internalFunction();
			}
			log("Internal: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				publicFunction();
			}
			log("Public: " + (getTimer()-beforeTime));
			
			log("");
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				this.privateFunction();
			}
			log("this.Private: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				this.protectedFunction();
			}
			log("this.Protected: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				this.internalFunction();
			}
			log("this.Internal: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				this.publicFunction();
			}
			log("this.Public: " + (getTimer()-beforeTime));
			
			log("");
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				staticPrivateFunction();
			}
			log("Static private: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				staticProtectedFunction();
			}
			log("Static protected: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				staticInternalFunction();
			}
			log("Static internal: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				staticPublicFunction();
			}
			log("Static public: " + (getTimer()-beforeTime));
			
			log("");
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				overrideProtectedFunction();
			}
			log("Override protected: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				overrideInternalFunction();
			}
			log("Override internal: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				overridePublicFunction();
			}
			log("Override public: " + (getTimer()-beforeTime));
			
			log("");
			
			removeEventListener(Event.ENTER_FRAME, testMethods);
			addEventListener(Event.ENTER_FRAME, testSupersAndInterfaces);
		}
		
		private function testSupersAndInterfaces(ev:Event): void
		{
			var beforeTime:int;
			var i:int;
			const NUM_ITERATIONS:int = 10000000;
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				super.overrideProtectedFunction();
			}
			log("Super protected: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				super.overrideInternalFunction();
			}
			log("Super internal: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				super.overridePublicFunction();
			}
			log("Super public: " + (getTimer()-beforeTime));
			
			log("");
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				interfaceFunction();
			}
			log("Interface direct: " + (getTimer()-beforeTime));
			
			var inter:IInterface = this;
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				inter.interfaceFunction();
			}
			log("Interface via interface: " + (getTimer()-beforeTime));
			
			var clazz:FunctionPerformanceTest = this;
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				clazz.interfaceFunction();
			}
			log("Interface via class: " + (getTimer()-beforeTime));
			
			log("");
			
			removeEventListener(Event.ENTER_FRAME, testSupersAndInterfaces);
			addEventListener(Event.ENTER_FRAME, testGettersAndSetters);
		}
		
		private function testGettersAndSetters(ev:Event): void
		{
			var beforeTime:int;
			var i:int;
			const NUM_ITERATIONS:int = 10000000;
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				privateGetFunction;
			}
			log("Private Get: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				protectedGetFunction;
			}
			log("Protected Get: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				internalGetFunction;
			}
			log("Internal Get: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				publicGetFunction;
			}
			log("Public Get: " + (getTimer()-beforeTime));
			
			log("");
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				privateSetFunction = 0;
			}
			log("Private Set: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				protectedSetFunction = 0;
			}
			log("Protected Set: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				internalSetFunction = 0;
			}
			log("Internal Set: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				publicSetFunction = 0;
			}
			log("Public Set: " + (getTimer()-beforeTime));
			
			log("");
			
			removeEventListener(Event.ENTER_FRAME, testGettersAndSetters);
			addEventListener(Event.ENTER_FRAME, testFinals);
		}
		
		private function testFinals(ev:Event): void
		{
			var beforeTime:int;
			var i:int;
			const NUM_ITERATIONS:int = 10000000;
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				finalPrivateFunction();
			}
			log("Final Private: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				finalProtectedFunction();
			}
			log("Final Protected: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				finalInternalFunction();
			}
			log("Final Internal: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				finalPublicFunction();
			}
			log("Final Public: " + (getTimer()-beforeTime));
			
			log("");
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				finalOverrideProtectedFunction();
			}
			log("Final Override protected: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				finalOverrideInternalFunction();
			}
			log("Final Override internal: " + (getTimer()-beforeTime));
			
			beforeTime = getTimer();
			for (i = 0; i < NUM_ITERATIONS; ++i)
			{
				finalOverridePublicFunction();
			}
			log("Final Override public: " + (getTimer()-beforeTime));
			
			removeEventListener(Event.ENTER_FRAME, testFinals);
		}
		
		private function log(msg:*): void
		{
			__logger.appendText(msg + "\n");
		}
	}
}
function plainFunction(): void {}
interface IInterface
{
	function interfaceFunction(): void;
}