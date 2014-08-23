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
package view.distortion
{
	import com.adobe.ac.mxeffects.Distortion;
	import com.adobe.ac.mxeffects.DistortionConstants;
	
	import mx.skins.halo.ButtonSkin;
	
	public class ButtonSkin3D extends ButtonSkin
	{
		override protected function updateDisplayList( w : Number, h : Number ) : void
		{
			super.updateDisplayList( w, h );
			
			var distortion : Distortion = new Distortion( this );
			distortion.smooth = true;
			distortion.buildMode = DistortionConstants.OVERWRITE;
			
			switch ( name )
			{
				case "upSkin":
					
					distortion.openDoor( 25, DistortionConstants.BOTTOM );
					
					break;
				
				case "overSkin":

					distortion.openDoor( 15, DistortionConstants.BOTTOM );
			}
		}		
	}
}