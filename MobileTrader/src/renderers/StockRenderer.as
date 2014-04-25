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
package renderers
{
	import flashx.textLayout.formats.VerticalAlign;
	
	import mx.formatters.NumberFormatter;
	import mx.graphics.SolidColor;
	import mx.states.SetStyle;
	
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.LabelItemRenderer;
	import spark.primitives.Rect;

	public class StockRenderer extends LabelItemRenderer
	{
		public var hGroup:HGroup;
		public var symbolLabel:Label;
		public var openLabel:Label;
		public var lastLabel:Label;
		public var highLabel:Label;
		public var lowLabel:Label;
		public var chartIcon:Image;
		
		[Embed("assets/chart_icon.png")]
		private var chartIconClass:Class;
				
		protected var nf:NumberFormatter = new NumberFormatter();
		
		public function StockRenderer()
		{
			super();
			nf.precision = 2;
		}

		override public function set data(value:Object):void 
		{
			super.data = value;
			if (!value) return;
			symbolLabel.text = value.symbol;
			openLabel.text = nf.format(value.open);
			lastLabel.text = nf.format(value.last);
			if (value.change < 0)
				lastLabel.setStyle("color", 0xFF0000);
			else
				lastLabel.setStyle("color", 0x006600);
			highLabel.text = nf.format(value.high);
			lowLabel.text = nf.format(value.low);
		}
		
		override protected function createChildren():void {
			if (!hGroup) 
			{
				hGroup = new HGroup();
				hGroup.paddingLeft = 10;
				hGroup.paddingRight = 10;
				hGroup.verticalAlign = "middle";
				addChild(hGroup);
			}

			if (!symbolLabel) {
				symbolLabel = new Label();
				symbolLabel.percentWidth = 100;
				hGroup.addElement(symbolLabel);
			}
			if (!openLabel) {
				openLabel = new Label();
				openLabel.percentWidth = 100;
				openLabel.setStyle("textAlign", "right");
				hGroup.addElement(openLabel);
			}
			if (!lastLabel) {
				lastLabel = new Label();
				lastLabel.percentWidth = 100;
				lastLabel.setStyle("textAlign", "right");
				hGroup.addElement(lastLabel);
			}
			if (!highLabel) {
				highLabel = new Label();
				highLabel.percentWidth = 100;
				highLabel.setStyle("textAlign", "right");
				hGroup.addElement(highLabel);
			}
			if (!lowLabel) {
				lowLabel = new Label();
				lowLabel.percentWidth = 100;
				lowLabel.setStyle("textAlign", "right");
				hGroup.addElement(lowLabel);
			}
			if (!chartIcon) {
				chartIcon = new Image();
				chartIcon.source = chartIconClass;
				hGroup.addElement(chartIcon);
			}

			
		}
		
		// Override layoutContents() to lay out the HGroup container.
		override protected function layoutContents(unscaledWidth:Number, unscaledHeight:Number):void 
		{
			// Make sure our width/height is in the min/max for the label
			var childWidth:Number = unscaledWidth - 6;
			childWidth = Math.max(hGroup.getMinBoundsWidth(), Math.min(hGroup.getMaxBoundsWidth(), childWidth));
			var childHeight:Number = unscaledHeight - 10;
			childHeight = Math.max(hGroup.getMinBoundsHeight(), Math.min(hGroup.getMaxBoundsHeight(), childHeight));
			// Set the label's position and size
			hGroup.setLayoutBoundsSize(childWidth, childHeight);
			hGroup.setLayoutBoundsPosition(3, 5);
		}
	}
}