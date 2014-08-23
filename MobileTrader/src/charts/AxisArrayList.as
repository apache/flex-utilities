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
package charts
{
	import mx.collections.ArrayList;
    
    public class AxisArrayList extends ArrayList
    {
        private var _max:Number = 100;
        public function get max():Number
        {
            return _max;
        }
        public function set max(value:Number):void
        {
            _max = value;
            update();
        }
        
        private var _min:Number = 0;
        public function get min():Number
        {
            return _min;
        }
        public function set min(value:Number):void
        {
            _min = value;
            update();
        }
        
        private var _step:Number = 10;
        public function get step():Number
        {
            return _step;
        }
        public function set step(value:Number):void
        {
            _step = value;
            update();
        }
        
        private function update():void
        {
            var arr:Array = [];
            var i:Number;
            if (step > 0)
            {
                for (i = min; i <= max; i += step)
                {
                    arr.push(i);
                }
            }
            else
            {
                for (i = max; i >= min; i += step)
                {
                    arr.push(i);
                }
            }
            source = arr;
        }
        
    }
}
