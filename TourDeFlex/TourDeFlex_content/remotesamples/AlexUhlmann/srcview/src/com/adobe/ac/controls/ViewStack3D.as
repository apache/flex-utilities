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
package com.adobe.ac.controls
{
	import com.adobe.ac.mxeffects.Distortion;
	import com.adobe.ac.mxeffects.DistortionConstants;
	
	import flash.display.DisplayObject;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class ViewStack3D extends Canvas
	{
		private var distortions : Array = new Array();
		
		public function ViewStack3D()
		{
			addEventListener( FlexEvent.CREATION_COMPLETE, initDistortions );
		}
		
		private function initDistortions( event : FlexEvent ) : void
		{			
			for( var i : int; i < numChildren; i++ )
			{
				var child : UIComponent = UIComponent( getChildAt( i ) );
				initialiseBounds( child );
				
				var distort : Distortion = new Distortion( child );
				distort.smooth = true;
				distort.openDoor( 40, DistortionConstants.LEFT );
				distortions.push( distort );
			}
		}
		
		override protected function createChildren() : void
		{
			super.createChildren();
			for( var i : int; i < numChildren; i++ )
			{
				var child : UIComponent = UIComponent( getChildAt( i ) );
				child.x += i * 25;
				child.y += i * 20;				
			}	
		}
		
		public function tilt( percentage : Number ) : void
		{
			var len : Number = distortions.length;
			for( var i : int; i < len; i++ )
			{
				var distort : Distortion = distortions[ i ];
				distort.openDoor( percentage, DistortionConstants.LEFT );
			}
		}
		
		private function initialiseBounds( texture : UIComponent ) : void
		{		
			var firstChild : DisplayObject = DisplayObject( getChildAt( 0 ) );
			texture.setActualSize( firstChild.width, firstChild.height );
			texture.validateNow();		
		}
	}
}