package org.apache.controller
{
	import com.adobe.csxs.core.CSXSInterface;
	import com.adobe.csxs.events.MenuClickEvent;
	import com.adobe.csxs.types.CSXSWindowType;
	import com.adobe.csxs.types.SyncRequestResult;
	
	import org.apache.view.windows.AboutWindow;

	public class FlyoutController
	{
		// Constants for menu item labels
		private const MENU_ABOUT:String = "About";
		private const MENU_ABOUT_ID:String = "ABOUT";
		
		private const PREFERENCES:String = "Preferences";
		private const PREFERENCES_ID:String = "Preferences";
		private const MENU_SEPARATOR:String = "---";
		
		public var flyoutMenuXML:XML =
			<Menu>
				<MenuItem Id={PREFERENCES_ID} Label={PREFERENCES}/>
				<MenuItem Label={MENU_SEPARATOR}/>
				<MenuItem Id={MENU_ABOUT_ID} Label={MENU_ABOUT}/>
			</Menu>

		private var jsxInterface:JSXInterface = JSXInterface.getInstance();
		private var app:ApacheFXG;
		public function FlyoutController(panel:ApacheFXG)
		{
			app = panel;
			initializeMenu();

		}
		
		/**
		 * Creates the menu item for this extension and registers an event listener. 
		 *
		 */
		private function initializeMenu():void
		{			
			CSXSInterface.instance.addEventListener(MenuClickEvent.FLYOUT_MENU_CLICK, menuClickHandler);
			var menuAdded:SyncRequestResult = CSXSInterface.instance.setPanelMenu(flyoutMenuXML);
			if(SyncRequestResult.COMPLETE != menuAdded.status)
			{
				trace("Failed to add menu...");	
			}
		}
		
		/**
		 * Event listener for the extension fly out menu.
		 */
		private function menuClickHandler(event:MenuClickEvent):void{
			var menuAdded:SyncRequestResult;
			switch (event.menuId)
			{
				case PREFERENCES_ID:
					break;
				case MENU_ABOUT_ID:
					
					openAboutWindow();
					//					jsxInterface.alert("Deposit Photos Panel\nDeveloped by In-Tools.com\n\u00A9 DepositPhotos Inc. 2013");
					//						appController.doAbout();
					break;
				
				default:
					jsxInterface.alert("Unknown Error!");
					//						appController.doDefault();
			}
		}
		private function openAboutWindow():void{
			var win:AboutWindow = new AboutWindow;
			win.type = CSXSWindowType.MODAL_DIALOG;
			win.open();
		}

	}
}