package org.apache.controller
{
	
	public class InDesignController implements IAppController
	{
		private static var _instance:InDesignController;
		public static function get instance():InDesignController
		{
			if(!_instance){
				_instance = new InDesignController(new Enforcer);
			}
			return _instance;
		}
		public function InDesignController(enf:Enforcer)
		{
		}
		
		public function parseSelection():XML{
			var xml:XML = new XML();
			return xml;
		}


	}
}
class Enforcer{}