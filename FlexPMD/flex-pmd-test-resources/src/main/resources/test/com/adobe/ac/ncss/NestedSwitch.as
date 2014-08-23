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
package view {

	public class NestedPanel extends UIComponent 
	{
		protected function currentStateChangeHandler(e:StateChangeEvent):void {
			switch (e.newState) {
				case STATE_PRODUCTS_IN_COMPARE	:
					hideCloseButton();
					height = 230;
					borderBreakPointX = BORDER_BREAK_POINT.x;
					borderBreakPointY = BORDER_BREAK_POINT.y;
					drawCompareBackground();
					switch (e.oldState) {
						case "" :
							createPlaceHolders();
							createPlaceHolderLabels();
						break;
						case STATE_COMPARE_VIEW	:
							if (productsInCompare.length < 3) {
								drawPlaceHolder(PLACEHOLDER_COORDS[2] as Point);
								lastPlaceholderLabel = createPlaceHolderLabel(PLACEHOLDER_COORDS[2] as Point);
							}
							showCompareButton();
						break;
					}
				break;
				case STATE_COMPARE_VIEW	:
					if (productsInCompare.length < 3)
						removeChild(lastPlaceholderLabel);
					hideCompareButton();
					showCloseButton();
					createCompareInfoView();
				break;
				default :
					height = 40;
					drawDefaultBackground();
				break;
			}
		}
	}
}