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
package classes
{
	import mx.controls.Image;
	import mx.controls.treeClasses.TreeItemRenderer;
	import mx.controls.treeClasses.TreeListData;

	public class ObjectTreeItemRenderer extends TreeItemRenderer
	{
		protected var iconImage:Image;
		private var imageWidth:Number	= 18;
		private var imageHeight:Number	= 18;
		private var imageToLabelMargin:Number = 2;
		
		public function ObjectTreeItemRenderer()
		{
			super();
		}
		
		override protected function createChildren():void
		{	
			iconImage = new Image();	
			iconImage.width = imageWidth;
			iconImage.height = imageHeight;
			addChild(iconImage);	
	
			super.createChildren();
		} 
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(super.data)
			{
				if(!TreeListData(super.listData).hasChildren)
				{
					iconImage.x = super.label.x - imageWidth - imageToLabelMargin;
					
					var tmp:XMLList = new XMLList(TreeListData(super.listData).item);					
					var iconPath:String = tmp.@iconPath.toString();
					if(tmp.@localIconPath.toString().length > 0)
						iconPath = tmp.@localIconPath;
						
					if(iconPath.length > 0)
					{
						if(hasFullPath(iconPath)) {
							if (Config.IS_ONLINE) {
								iconImage.source = iconPath;
							} else {
								iconImage.source = Config.TREE_NO_ICON;
							}
						}
						else
							iconImage.source = Config.LOCAL_OBJECTS_ROOT_PATH + iconPath;
					}
					else
					{
						iconImage.source = Config.TREE_NO_ICON;
					}										
				}
				else
				{
					iconImage.source = null;
				}
			}
		}
		
		private function hasFullPath(path:String):Boolean
		{
			if(path.indexOf("//") >= 0 || path.indexOf(":") >= 0)
				return true;
			else
				return false;
		}
		
	}
}