package org.apache.controller
{
	
	public class FireworksController implements IAppController
	{
		private static var _instance:FireworksController;
		public static function get instance():FireworksController
		{
			if(!_instance){
				_instance = new FireworksController(new Enforcer);
			}
			return _instance;
		}
		public function FireworksController(enf:Enforcer)
		{
		}
		
		public function parseSelection():XML{
			var xml:XML = new XML();
			return xml;
		}
		
		
	}
}
class Enforcer{}