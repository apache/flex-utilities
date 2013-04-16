package org.apache.controller
{
	
	public class IllustratorController implements IAppController
	{
		private static var _instance:IllustratorController;
		public static function get instance():IllustratorController
		{
			if(!_instance){
				_instance = new IllustratorController(new Enforcer);
			}
			return _instance;
		}
		public function IllustratorController(enf:Enforcer)
		{
		}
		
		public function parseSelection():XML{
			var xml:XML = new XML();
			return xml;
		}
		
		
	}
}
class Enforcer{}