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
package com.model
{
	import com.model.VO.ConfigVO;
	
	import de.polygonal.ds.HashMap;

	public class ConfigProxy extends MS2Proxy
	{
		public static const NAME:String = "configProxy";
		private static var configs:HashMap = new HashMap(MS2Proxy.HASHMAP_INITAL_SIZE);
		
		public function ConfigProxy(bar:Object=null)
		{
			super(ConfigProxy.NAME, bar);
		}
		
		public static function populateStub():void {
			Alert.show( "error" );
			ConfigProxy.insertConfig(new ConfigVO(118218, order, 9000001, "fr", "default.css", "", 9000001)); 
		}

		internal static function insertConfig(configVO:ConfigVO):void {
		   try
		   {
			   ConfigProxy.configs.remove(Number(configVO.idUser));
			}
			catch( e : Exception )
			{
			}
		}
	}
}
