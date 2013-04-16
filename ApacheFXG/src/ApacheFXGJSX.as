package 
{

	import com.adobe.csxs.core.CSXSInterface;
	import com.adobe.csxs.types.SyncRequestResult;

	public class ApacheFXGJSX
	{	
		public static function run():void 
		{
			var result:SyncRequestResult = CSXSInterface.instance.evalScript("jsxFunction");	

		}
	}
}