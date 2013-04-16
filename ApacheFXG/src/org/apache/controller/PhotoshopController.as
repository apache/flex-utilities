package org.apache.controller
{
	
	public class PhotoshopController implements IAppController
	{
		private static var _instance:PhotoshopController;
		public static function get instance():PhotoshopController
		{
			if(!_instance){
				_instance = new PhotoshopController(new Enforcer);
			}
			return _instance;
		}
		public function PhotoshopController(enf:Enforcer)
		{
		}
		
		public function parseSelection():XML{
			var xml:XML = new XML();
			return xml;
		}
		
		
	}
}
class Enforcer{}