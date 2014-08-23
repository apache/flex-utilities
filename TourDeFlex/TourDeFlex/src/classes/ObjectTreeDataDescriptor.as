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
	import mx.collections.ArrayCollection;
	import mx.collections.CursorBookmark;
	import mx.collections.ICollectionView;
	import mx.collections.IViewCursor;
	import mx.collections.XMLListCollection;
	import mx.controls.treeClasses.ITreeDataDescriptor;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	public class ObjectTreeDataDescriptor implements ITreeDataDescriptor
	{
		public function ObjectTreeDataDescriptor()
		{
		}

		public function getChildren(node:Object, model:Object=null):ICollectionView
		{
			try
			{		
				return new XMLListCollection(XMLList(node).children());
			}
			catch (e:Error)
			{
				trace("[Descriptor] exception checking for getChildren:" + e.toString());
			}
			return null;
		}
		
		// The isBranch method simply returns true if the node is an
		// Object with a children field.
		// It does not support empty branches, but does support null children
		// fields.
		public function isBranch(node:Object, model:Object=null):Boolean
		{
			try
			{
				if(node is Object)
				{
					if(node.children != null && XML(node).name().toString() != "Object")
						return true;
				}
			}
			catch (e:Error)
			{
				trace("[Descriptor] exception checking for isBranch");
			}
			
			return false;
		}
		
		// The hasChildren method Returns true if the
		// node actually has children. 
		public function hasChildren(node:Object, model:Object=null):Boolean
		{
			if(node == null) 
				return false;
			
			var children:ICollectionView = getChildren(node, model);
			
			try
			{
				if(children.length > 0)
					return true;
			}
			catch(e:Error)
			{
				trace("hasChildren: " + e.toString());
			}
			
			return false;
		}
		
		// The getData method simply returns the node as an Object.
		public function getData(node:Object, model:Object=null):Object
		{
			try
			{
				return node;
			}
			catch (e:Error)
			{
				trace("getData: " + e.toString());
			}
			
			return null;
		}
		
		// The addChildAt method does the following:
		// If the parent parameter is null or undefined, inserts
		// the child parameter as the first child of the model parameter.
		// If the parent parameter is an Object and has a children field,
		// adds the child parameter to it at the index parameter location.
		// It does not add a child to a terminal node if it does not have
		// a children field.
		public function addChildAt(parent:Object, child:Object, index:int, model:Object=null):Boolean
		{
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			event.kind = CollectionEventKind.ADD;
			event.items = [child];
			event.location = index;
			
			if (!parent)
			{
				var iterator:IViewCursor = model.createCursor();
				iterator.seek(CursorBookmark.FIRST, index);
				iterator.insert(child);
			}
			else if (parent is Object)
			{
				if (parent.children != null)
				{
					if(parent.children is ArrayCollection)
					{
						parent.children.addItemAt(child, index);
						if (model)
						{
							model.dispatchEvent(event);
							model.itemUpdated(parent);
						}
						return true;
					}
					else
					{
						parent.children.splice(index, 0, child);
						if(model)
							model.dispatchEvent(event);
						return true;
					}
				}
			}
			return false;
		}
		
		// The removeChildAt method does the following:
		// If the parent parameter is null or undefined,
		// removes the child at the specified index
		// in the model.
		// If the parent parameter is an Object and has a children field,
		// removes the child at the index parameter location in the parent.
		public function removeChildAt(parent:Object, child:Object, index:int, model:Object=null):Boolean
		{
			var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			event.kind = CollectionEventKind.REMOVE;
			event.items = [child];
			event.location = index;
		
			//handle top level where there is no parent
			if (!parent)
			{
				var iterator:IViewCursor = model.createCursor();
				iterator.seek(CursorBookmark.FIRST, index);
				iterator.remove();
				if (model)
						model.dispatchEvent(event);
				return true;
			}
			else if (parent is Object)
			{
				if (parent.children != undefined)
				{
					parent.children.splice(index, 1);
					if(model) 
						model.dispatchEvent(event);
					return true;
				}
			}
			return false;
		}

	}
}