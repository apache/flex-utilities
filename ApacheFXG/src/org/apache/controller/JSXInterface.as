package org.apache.controller
{
	import com.adobe.csxs.core.CSXSInterface;
	import com.adobe.csxs.types.SyncRequestResult;
	
	import flash.external.HostObject;

	public class JSXInterface
	{
		private static var _instance:JSXInterface;
		public static function getInstance() : JSXInterface 
		{
			if (_instance == null)
			{
				_instance = new JSXInterface(new Enforcer);
			}
			return _instance;
		}
		
		[  Embed (source=  "ExtendScript/ExtendScript.jsx" , mimeType=  "application/octet-stream" )]
		private static var embeddedESClass:Class;
		
		public function JSXInterface(enf:Enforcer)
		{var a:HostObject
			_ip = HostObject.getRoot(HostObject.extensions[0]);
			_ip.eval( new embeddedESClass().toString());
		}
		private var _ip:HostObject;//interface proxy
		
		public function set interfaceProxy(ip:HostObject):void{
			_ip = ip;
		}
		public function alert(alertText:String):void{
			if(_ip){
				_ip.alert(alertText);
			} else {
				runScriptFunction("alert",alertText);
			}
		}
		public function confirm(confirmWhat:String):Boolean{
			if(_ip){
				return _ip.confirm(confirmWhat);
			} else {
				var result:Object = runScriptFunction("javaScriptConfirm",confirmWhat).result;
				return result == "true" ? true : false;
			}			
		}
		public function prompt(promptMessage:String,promptText:String):String{
			if(_ip){
				return _ip.prompt(promptMessage,promptText);
			} else {
				var result:String = runScriptFunction("javaScriptPrompt",promptMessage,promptText).result;
				return result;// == "true" ? true : false;
			}
		}
		
		public function eval(evalString:String):*{
			if(_ip){
				return _ip.eval(evalString);
			} else {
				trace(this);
				var result:String = runScriptFunction("javaScriptEval",evalString).result;
				return result;
			}			
			
		}
		public function escape(escapeString:String):*{
			if(_ip){
				return _ip.escape(escapeString);
			} else {
				var result:Object = runScriptFunction("escape",escapeString);
				return result == "true" ? true : false;
			}			
			
		}
		public function beep():void{
			if(_ip){
				_ip.beep();
			} else {
				//runScriptFunction("beep");
			}			
		}
		
		
		private function runScriptFunction(functionName:String,arg1:String="",arg2:String=""):Object{
			var result:SyncRequestResult = CSXSInterface.getInstance().evalScript(functionName,arg1,arg2);
			//			var strResult:String;
			if((SyncRequestResult.COMPLETE == result.status) && result.data)
			{
				return result.data;
				//				trace(strResult);  
			}
			return "";
		}
		
		public function getFilePathFromDialog(title:String,filter:String):String{
			var filePath:String = _ip.org_apache_utils.getFile(title,filter) as String;
			// com_printui_utils.GetFile(title,filter);
			return filePath;
		}
		public function getFolderPathFromDialog(title:String):String{
			var filePath:String = _ip.org_apache_utils.getFolder(title);
			// com_printui_utils.GetFile(title,filter);
			return filePath;
		}
		
		public function getTempFolderPath():String{
			return _ip.org_apache_utils.getTempFolder();
		}
		public function getStartupDiskName():String{
			return _ip.org_apache_utils.getStartupDiskName();
		}
		public function getNativePath(path:String):String{
			return _ip.org_apache_utils.getNativePath(path);
		}
		public function getFilePathForSave(title:String,filter:String=null):String{
			return _ip.org_apache_utils.getFileForSave(title,filter);
		}
		public function getPluginDataFolder():String{
			return _ip.org_apache_fxg_panel.GetPluginDataFolder();
		}
		
	}
}
class Enforcer{}