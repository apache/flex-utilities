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
	import flashx.textLayout.elements.BreakElement;
	import flashx.textLayout.elements.ParagraphElement;
	
	public class BugDemo
	{
		public function BugDemo()
		{
			var paragraph : ParagraphElement = new ParagraphElement();
			paragraph.addChild(new BreakElement());
			var iii : int = 0; // NO PMD AlertShow
			var iiii : int = 0; // NO PMD AlertShowRule
			var iiiii : int = 0; // NO PMD com.adobe.ac.pmd.rules.maintanability.AlertShow
			var iiiiii : int = 0; // NO PMD com.adobe.ac.pmd.rules.maintanability.AlertShowRule
			
			for (var i:int = 0; i < 2; i++)
          		for (var j:int = 0; j < 2; j++)
					blabla; 
		}

	}
}