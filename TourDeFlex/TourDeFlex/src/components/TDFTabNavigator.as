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
package components
{	
	import mx.containers.TabNavigator; 
	
	/**
	 * Currently there is a known bug within flex that prevents you from simply setting the selectedIndex 
	 * once all the children are added. This class should be used to avoid the issue. 
	 **/
	
	public class TDFTabNavigator extends TabNavigator
	{
		public function TDFTabNavigator()
		{
			super();
		} 
		override protected function commitSelectedIndex(newIndex:int):void
		{
			super.commitSelectedIndex(newIndex);
			if(tabBar.numChildren > 0)
			{
				tabBar.selectedIndex = newIndex;
			}
		}
	}
}