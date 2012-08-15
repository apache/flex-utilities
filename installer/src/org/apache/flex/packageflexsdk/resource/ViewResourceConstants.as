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

package org.apache.flex.packageflexsdk.resource
{
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	public final class ViewResourceConstants
	{
		public static const URL_APACHE_FLEX:String = "http://incubator.apache.org/flex/";
		public static const URL_CONFIG_XML:String = "http://people.apache.org/~bigosmallm/installapacheflex/ApacheFlexConfig.xml";
		/*
			I'm not entirely sure (as IANAL), but on http://www.hostip.info/faq.html
			I see this: "Hostip.info is an open project ... contributed by the 
			community as part of an ongoing open-source effort." Not a license 
			per se, but I guess it'll have to do :-)
		*/
		public static const URL_FETCH_GEO_IP:String = "http://api.hostip.info/country.php";
		public static const URL_FETCH_MIRROR_LIST:String = "http://www.apache.org/mirrors/mirrors.list";
		public static const URL_FETCH_MIRROR_CGI:String = "http://incubator.apache.org/flex/single-mirror-url.cgi";
		
		private static var _instance:ViewResourceConstants;

		private var _STEP_VERIFY_FLEX_SDK:String;
		
		private var _ERROR_VERIFY_FLEX_SDK:String;
		private var _ERROR_MIRROR_FETCH:String;
		
		private var _FETCH_GEO_IP:String;
		private var _FETCH_GEO_IP_DONE:String;
		private var _FETCH_GEO_IP_ERROR:String;
		private var _FETCH_MIRROR_CGI:String;
		private var _FETCH_MIRROR_CGI_DONE:String;
		private var _FETCH_MIRROR_CGI_ERROR:String;
		private var _FETCH_MIRROR_LIST:String;
		private var _FETCH_MIRROR_LIST_DONE:String;
		private var _FETCH_MIRROR_LIST_PARSED:String;
		
		private var _INFO_VERIFY_FLEX_SDK_DONE:String;
		
		//Labels
		private var _INSTALL_BTN_LABEL:String;
		private var _SELECT_PATH_PROMPT:String;
		private var _BROWSE_BTN_LABEL:String;
		private var _INSTALL_LOG_BTN_LABEL:String;
		private var _CLOSE_BTN_LABEL:String;
		private var _NEXT_BTN_LABEL:String;
		private var _MPL_LICENSE_BTN_LABEL:String;
		private var _ADOBE_LICENSE_BTN_LABEL:String;
		private var _OPEN_APACHE_FLEX_FOLDER_BTN_LABEL:String;

		//Log messages
		private var _ERROR_CONFIG_XML_LOAD:String;
		private var _ERROR_INVALID_SDK_URL:String;
		private var _ERROR_INVALID_AIR_SDK_URL_WINDOWS:String;
		private var _ERROR_INVALID_AIR_SDK_URL_MAC:String;
		private var _ERROR_INVALID_FLASH_PLAYER_SWC_URL:String;
		private var _ERROR_UNSUPPORTED_OPERATING_SYSTEM:String;
		private var _INFO_APP_INVOKED:String;
		private var _INFO_ENTER_VALID_FLEX_SDK_PATH:String;
		private var _INFO_INVOKED_GUI_MODE:String;
		private var _INFO_SELECT_DIRECTORY:String;
		private var _INFO_CREATING_FLEX_HOME:String;
		private var _INFO_CREATING_TEMP_DIR:String;
		private var _INFO_DOWNLOADING_APACHE_FLEX_SDK:String;
		private var _INFO_UNZIPPING:String;
		private var _INFO_FINISHED_UNZIPPING:String;
		private var _INFO_DOWLOADING_AIR_RUNTIME_KIT_WINDOWS:String;
		private var _INFO_DOWLOADING_AIR_RUNTIME_KIT_MAC:String;
		private var _ERROR_NATIVE_PROCESS_NOT_SUPPORTED:String;
		private var _ERROR_NATIVE_PROCESS_ERROR:String;
		private var _INFO_FINISHED_UNTARING:String;
		private var _INFO_INSTALLING_PLAYERGLOBAL_SWC:String;
		private var _INFO_INSTALLING_CONFIG_FILES:String;
		private var _INFO_INSTALLATION_COMPLETE:String;
		private var _ERROR_UNABLE_TO_COPY_FILE:String;
		private var _INFO_DOWNLOADED:String;
		private var _ERROR_UNABLE_TO_DOWNLOAD_FLEX_SDK:String;
		private var _ERROR_UNABLE_TO_DOWNLOAD_AIR_SDK:String;
		private var _ERROR_UNABLE_TO_DOWNLOAD_FLASH_PLAYER_SWC:String;
		private var _INFO_ABORT_INSTALLATION:String;
		private var _ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY:String;
		private var _ERROR_UNABLE_TO_CREATE_TEMP_DIRECTORY:String;
		private var _ERROR_INVALID_FLEX_SDK_DIRECTORY:String;
		private var _ERROR_UNABLE_TO_INSTALL_CONFIG_FILES:String;
		private var _INFO_DOWNLOADING_ADOBE_FLEX_SDK:String;
		private var _ERROR_UNABLE_TO_DOWNLOAD_FILE:String;
		private var _ERROR_UNABLE_TO_UNZIP:String;
		private var _INFO_DOWNLOADING_FILE_FROM:String;
		private var _INFO_NEED_TO_READ_AND_AGREE_TO_LICENSE:String;
		private var _INFO_INSTALLING:String;
		private var _ERROR_DIRECTORY_NOT_EMPTY:String;
		
		//URLs
		private var _APACHE_FLEX_URL:String;
		private var _CONFIG_URL:String;
		
		//STEPS
		private var _STEP_CREATE_DIRECTORIES:String;
		private var _STEP_DOWNLOAD_FLEX_SDK:String;
		private var _STEP_UNZIP_FLEX_SDK:String;
		private var _STEP_DOWNLOAD_AIR_RUNTIME_KIT:String;
		private var _STEP_UNZIP_AIR_RUNTIME_KIT:String;
		private var _STEP_DOWNLOAD_FLASHPLAYER_SWC:String;
		private var _STEP_INSTALL_CONFIG_FILES:String;
		private var _STEP_OPTIONAL_INSTALL_FONTSWF:String;
		private var _STEP_OPTIONAL_INSTALL_BLAZEDS:String;
		private var _STEP_OPTIONAL_INSTALL_TLF:String;
		private var _STEP_OPTIONAL_INSTALL_OSMF:String;
		
		//PROMPTS
		private var _ASK_OSMF:String;
		private var _ASK_BLAZEDS:String;
		private var _ASK_TLF:String;
		private var _ASK_FONTSWF:String;
		private var _INSTALL:String;
		private var _DONT_INSTALL:String;
		
		
		private var _iResourceManager:IResourceManager;
		
		public function ViewResourceConstants(enforcer:SingletonEnforcer)
		{
			if (enforcer != null && !(enforcer is SingletonEnforcer))
			{
				throw new Error( "Invalid Singleton access. Please use ViewResourceManager.getInstance() instead." );
			}
			
			_iResourceManager = ResourceManager.getInstance();
			_iResourceManager.addEventListener(Event.CHANGE , resourceLocale_Handler);
			populateStrings();
		}
		
		public static function getInstance():ViewResourceConstants
		{
			if (_instance == null)
			{
				_instance = new ViewResourceConstants(new SingletonEnforcer());	
			}
			
			return _instance;
		}
		
		protected function resourceLocale_Handler(event:Event):void
		{
			populateStrings();
		}
		
		private function populateStrings():void
		{
			_ERROR_VERIFY_FLEX_SDK = _iResourceManager.getString("messagestrings","ERROR_VERIFY_FLEX_SDK");
			_ERROR_MIRROR_FETCH = _iResourceManager.getString("messagestrings","ERROR_MIRROR_FETCH");
			
			_FETCH_GEO_IP = _iResourceManager.getString("messagestrings","FETCH_GEO_IP");
			_FETCH_GEO_IP_DONE = _iResourceManager.getString("messagestrings","FETCH_GEO_IP_DONE");
			_FETCH_GEO_IP_ERROR = _iResourceManager.getString("messagestrings","FETCH_GEO_IP_ERROR");
			_FETCH_MIRROR_CGI = _iResourceManager.getString("messagestrings","FETCH_MIRROR_CGI");
			_FETCH_MIRROR_CGI_DONE = _iResourceManager.getString("messagestrings","FETCH_MIRROR_CGI_DONE");
			_FETCH_MIRROR_CGI_ERROR = _iResourceManager.getString("messagestrings","FETCH_MIRROR_CGI_ERROR");
			_FETCH_MIRROR_LIST = _iResourceManager.getString("messagestrings","FETCH_MIRROR_LIST");
			_FETCH_MIRROR_LIST_DONE = _iResourceManager.getString("messagestrings","FETCH_MIRROR_LIST_DONE");
			_FETCH_MIRROR_LIST_PARSED = _iResourceManager.getString("messagestrings","FETCH_MIRROR_LIST_PARSED");
			
			_INFO_VERIFY_FLEX_SDK_DONE = _iResourceManager.getString("messagestrings","INFO_VERIFY_FLEX_SDK_DONE");
			
			_STEP_VERIFY_FLEX_SDK = _iResourceManager.getString("messagestrings","STEP_VERIFY_FLEX_SDK");
			
			_INSTALL_BTN_LABEL = _iResourceManager.getString("messagestrings","install_btn_label");
			_SELECT_PATH_PROMPT = _iResourceManager.getString("messagestrings","select_path_prompt");
			_BROWSE_BTN_LABEL = _iResourceManager.getString("messagestrings","browse_btn_label");
			_INSTALL_LOG_BTN_LABEL = _iResourceManager.getString("messagestrings","install_log_btn_label");
			_CLOSE_BTN_LABEL = _iResourceManager.getString("messagestrings","close_btn_label");
			_NEXT_BTN_LABEL = ResourceManager.getInstance().getString("messagestrings","next_btn_label");
			_MPL_LICENSE_BTN_LABEL = ResourceManager.getInstance().getString("messagestrings","show_mpl_license_btn_label");
			_ADOBE_LICENSE_BTN_LABEL = ResourceManager.getInstance().getString("messagestrings","show_adobe_license_btn_label");
			_OPEN_APACHE_FLEX_FOLDER_BTN_LABEL = ResourceManager.getInstance().getString("messagestrings","open_apache_flex_folder_btn_label");
			
			_APACHE_FLEX_URL = _iResourceManager.getString("messagestrings","apache_flex_url");
			_CONFIG_URL = _iResourceManager.getString("messagestrings","config_url");

			_ERROR_CONFIG_XML_LOAD = _iResourceManager.getString("messagestrings","error_config_xml_load");
			_ERROR_INVALID_SDK_URL = _iResourceManager.getString("messagestrings","error_invalid_sdk_url");
			_ERROR_INVALID_AIR_SDK_URL_WINDOWS = _iResourceManager.getString("messagestrings","error_invalid_air_sdk_url_windows");
			_ERROR_INVALID_AIR_SDK_URL_MAC = _iResourceManager.getString("messagestrings","error_invalid_air_sdk_url_mac");
			_ERROR_INVALID_FLASH_PLAYER_SWC_URL = _iResourceManager.getString("messagestrings","error_invalid_flash_player_swc_url"); 
			_INFO_APP_INVOKED = _iResourceManager.getString("messagestrings","info_app_invoked");
			_ERROR_UNSUPPORTED_OPERATING_SYSTEM = _iResourceManager.getString("messagestrings","error_unsupported_operating_system");
			_INFO_ENTER_VALID_FLEX_SDK_PATH = _iResourceManager.getString("messagestrings","info_enter_valid_flex_sdk_path");
			_INFO_INVOKED_GUI_MODE = _iResourceManager.getString("messagestrings","info_invoked_gui_mode");
			_INFO_SELECT_DIRECTORY = _iResourceManager.getString("messagestrings","info_select_directory");
			_INFO_CREATING_FLEX_HOME = _iResourceManager.getString("messagestrings","info_creating_flex_home");
			_INFO_CREATING_TEMP_DIR = _iResourceManager.getString("messagestrings","info_creating_temp_dir");
			_INFO_DOWNLOADING_APACHE_FLEX_SDK = _iResourceManager.getString("messagestrings","info_dowloading_flex_sdk");
			_INFO_UNZIPPING = _iResourceManager.getString("messagestrings","info_unzipping");
			_INFO_FINISHED_UNZIPPING = _iResourceManager.getString("messagestrings","info_unzipping");
			_INFO_DOWLOADING_AIR_RUNTIME_KIT_WINDOWS = _iResourceManager.getString("messagestrings","info_dowloading_air_runtime_kit_windows");
			_INFO_DOWLOADING_AIR_RUNTIME_KIT_MAC = _iResourceManager.getString("messagestrings","info_dowloading_air_runtime_kit_mac");
			_ERROR_NATIVE_PROCESS_NOT_SUPPORTED = _iResourceManager.getString("messagestrings","error_native_process_not_supported");
			_ERROR_NATIVE_PROCESS_ERROR = _iResourceManager.getString("messagestrings","error_native_process_error");
			_INFO_FINISHED_UNTARING = _iResourceManager.getString("messagestrings","info_finished_untaring");
			_INFO_INSTALLING_PLAYERGLOBAL_SWC = _iResourceManager.getString("messagestrings","info_installing_playerglobal_swc");
			_INFO_INSTALLING_CONFIG_FILES = _iResourceManager.getString("messagestrings","info_installing_config_files");
			_INFO_INSTALLATION_COMPLETE = _iResourceManager.getString("messagestrings","info_installation_complete");
			_ERROR_UNABLE_TO_COPY_FILE = _iResourceManager.getString("messagestrings","error_unable_to_copy_file");
			_INFO_DOWNLOADED = _iResourceManager.getString("messagestrings","info_downloaded");
			_ERROR_UNABLE_TO_DOWNLOAD_FLEX_SDK = _iResourceManager.getString("messagestrings","error_unable_to_download_flex_sdk");
			_ERROR_UNABLE_TO_DOWNLOAD_AIR_SDK = _iResourceManager.getString("messagestrings","error_unable_to_download_air_sdk");
			_ERROR_UNABLE_TO_DOWNLOAD_FLASH_PLAYER_SWC = _iResourceManager.getString("messagestrings","error_unable_to_download_flash_player_swc");
			_INFO_ABORT_INSTALLATION = _iResourceManager.getString("messagestrings","info_abort_installation");
			_ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY = _iResourceManager.getString("messagestrings","error_unable_to_delete_temp_directory");
			_ERROR_UNABLE_TO_CREATE_TEMP_DIRECTORY = _iResourceManager.getString("messagestrings","error_unable_to_create_temp_directory");
			_ERROR_INVALID_FLEX_SDK_DIRECTORY = _iResourceManager.getString("messagestrings","error_invalid_flex_sdk_directory");
			_ERROR_UNABLE_TO_INSTALL_CONFIG_FILES = _iResourceManager.getString("messagestrings","error_unable_to_install_config_files");
			_INFO_DOWNLOADING_FILE_FROM = _iResourceManager.getString("messagestrings","info_dowloading_file_from");
			_ERROR_UNABLE_TO_DOWNLOAD_FILE = _iResourceManager.getString("messagestrings","error_unable_to_download_file");
			_ERROR_UNABLE_TO_UNZIP = _iResourceManager.getString("messagestrings","error_unable_to_unzip");
			_INFO_NEED_TO_READ_AND_AGREE_TO_LICENSE = _iResourceManager.getString("messagestrings","info_need_to_read_and_agree_to_license");
			_INFO_INSTALLING = _iResourceManager.getString("messagestrings","info_installing");
			_ERROR_DIRECTORY_NOT_EMPTY = _iResourceManager.getString("messagestrings","error_dir_not_empty");
			
			_STEP_CREATE_DIRECTORIES = _iResourceManager.getString("messagestrings","step_create_directories");
			_STEP_DOWNLOAD_FLEX_SDK = _iResourceManager.getString("messagestrings","step_download_flex_sdk");
			_STEP_UNZIP_FLEX_SDK = _iResourceManager.getString("messagestrings","step_unzip_flex_sdk");
			_STEP_DOWNLOAD_AIR_RUNTIME_KIT = _iResourceManager.getString("messagestrings","step_download_air_runtime_kit");
			_STEP_UNZIP_AIR_RUNTIME_KIT = _iResourceManager.getString("messagestrings","step_unzip_air_runtime_kit");
			_STEP_DOWNLOAD_FLASHPLAYER_SWC = _iResourceManager.getString("messagestrings","step_download_flashplayer_swc");
			_STEP_INSTALL_CONFIG_FILES = _iResourceManager.getString("messagestrings","step_install_config_files");
			_STEP_OPTIONAL_INSTALL_FONTSWF = _iResourceManager.getString("messagestrings","step_optional_install_FontSwf");
			_STEP_OPTIONAL_INSTALL_BLAZEDS = _iResourceManager.getString("messagestrings","step_optional_install_BlazeDS");
			_STEP_OPTIONAL_INSTALL_TLF = _iResourceManager.getString("messagestrings","step_optional_install_TLF");
			_STEP_OPTIONAL_INSTALL_OSMF = _iResourceManager.getString("messagestrings","step_optional_install_OSMF");
			
			_ASK_BLAZEDS = _iResourceManager.getString("messagestrings","ask_blazeds");
			_ASK_FONTSWF = _iResourceManager.getString("messagestrings","ask_fontswf");
			_ASK_OSMF = _iResourceManager.getString("messagestrings","ask_osmf");
			_ASK_TLF = _iResourceManager.getString("messagestrings","ask_tlf");
			_INSTALL = _iResourceManager.getString("messagestrings","install");
			_DONT_INSTALL = _iResourceManager.getString("messagestrings","dont_install");
			
		}
		
		public function get STEP_VERIFY_FLEX_SDK():String
		{
			return _STEP_VERIFY_FLEX_SDK;
		}
		
		public function get ERROR_VERIFY_FLEX_SDK():String
		{
			return _ERROR_VERIFY_FLEX_SDK;
		}
		
		public function get ERROR_MIRROR_FETCH():String
		{
			return _ERROR_MIRROR_FETCH;
		}
		
		public function get FETCH_GEO_IP():String
		{
			return _FETCH_GEO_IP;
		}
		
		public function get FETCH_GEO_IP_DONE():String
		{
			return _FETCH_GEO_IP_DONE;
		}
		
		public function get FETCH_GEO_IP_ERROR():String
		{
			return _FETCH_GEO_IP_ERROR;
		}
		
		public function get FETCH_MIRROR_CGI():String
		{
			return _FETCH_MIRROR_CGI;
		}
		
		public function get FETCH_MIRROR_CGI_DONE():String
		{
			return _FETCH_MIRROR_CGI_DONE;
		}
		
		public function get FETCH_MIRROR_CGI_ERROR():String
		{
			return _FETCH_MIRROR_CGI_ERROR;
		}
		
		public function get FETCH_MIRROR_LIST():String
		{
			return _FETCH_MIRROR_LIST;
		}
		
		public function get FETCH_MIRROR_LIST_DONE():String
		{
			return _FETCH_MIRROR_LIST_DONE;
		}
		
		public function get FETCH_MIRROR_LIST_PARSED():String
		{
			return _FETCH_MIRROR_LIST_PARSED;
		}
		
		public function get INFO_VERIFY_FLEX_SDK_DONE():String
		{
			return _INFO_VERIFY_FLEX_SDK_DONE;
		}
		
		public function get STEP_UNZIP_FLEX_SDK():String
		{
			return _STEP_UNZIP_FLEX_SDK;
		}
		
		public function get INFO_DOWNLOADED():String
		{
			return _INFO_DOWNLOADED;
		}

		public function get ERROR_UNABLE_TO_COPY_FILE():String
		{
			return _ERROR_UNABLE_TO_COPY_FILE;
		}

		public function get INFO_INSTALLATION_COMPLETE():String
		{
			return _INFO_INSTALLATION_COMPLETE;
		}

		public function get INFO_INSTALLING_CONFIG_FILES():String
		{
			return _INFO_INSTALLING_CONFIG_FILES;
		}

		public function get INFO_INSTALLING_PLAYERGLOBAL_SWC():String
		{
			return _INFO_INSTALLING_PLAYERGLOBAL_SWC;
		}

		public function get INFO_FINISHED_UNTARING():String
		{
			return _INFO_FINISHED_UNTARING;
		}

		public function get ERROR_NATIVE_PROCESS_ERROR():String
		{
			return _ERROR_NATIVE_PROCESS_ERROR;
		}

		public function get ERROR_NATIVE_PROCESS_NOT_SUPPORTED():String
		{
			return _ERROR_NATIVE_PROCESS_NOT_SUPPORTED;
		}

		public function get INFO_DOWLOADING_AIR_RUNTIME_KIT_MAC():String
		{
			return _INFO_DOWLOADING_AIR_RUNTIME_KIT_MAC;
		}

		public function get INFO_DOWLOADING_AIR_RUNTIME_KIT_WINDOWS():String
		{
			return _INFO_DOWLOADING_AIR_RUNTIME_KIT_WINDOWS;
		}

		public function get INFO_FINISHED_UNZIPPING():String
		{
			return _INFO_FINISHED_UNZIPPING;
		}

		public function get INFO_UNZIPPING():String
		{
			return _INFO_UNZIPPING;
		}

		public function get INFO_DOWNLOADING_APACHE_FLEX_SDK():String
		{
			return _INFO_DOWNLOADING_APACHE_FLEX_SDK;
		}

		public function get INFO_CREATING_TEMP_DIR():String
		{
			return _INFO_CREATING_TEMP_DIR;
		}

		public function get INFO_CREATING_FLEX_HOME():String
		{
			return _INFO_CREATING_FLEX_HOME;
		}

		public function get INFO_SELECT_DIRECTORY():String
		{
			return _INFO_SELECT_DIRECTORY;
		}

		public function get INFO_INVOKED_GUI_MODE():String
		{
			return _INFO_INVOKED_GUI_MODE;
		}

		public function get INFO_ENTER_VALID_FLEX_SDK_PATH():String
		{
			return _INFO_ENTER_VALID_FLEX_SDK_PATH;
		}

		public function get ERROR_UNSUPPORTED_OPERATING_SYSTEM():String
		{
			return _ERROR_UNSUPPORTED_OPERATING_SYSTEM;
		}

		public function get ERROR_INVALID_AIR_SDK_URL_WINDOWS():String
		{
			return _ERROR_INVALID_AIR_SDK_URL_WINDOWS;
		}

		public function get CONFIG_URL():String
		{
			return _CONFIG_URL;
		}

		public function get APACHE_FLEX_URL():String
		{
			return _APACHE_FLEX_URL;
		}

		public function get INFO_APP_INVOKED():String
		{
			return _INFO_APP_INVOKED;
		}

		public function get ERROR_INVALID_FLASH_PLAYER_SWC_URL():String
		{
			return _ERROR_INVALID_FLASH_PLAYER_SWC_URL;
		}

		public function get ERROR_INVALID_AIR_SDK_URL_MAC():String
		{
			return _ERROR_INVALID_AIR_SDK_URL_MAC;
		}

		public function get ERROR_INVALID_SDK_URL():String
		{
			return _ERROR_INVALID_SDK_URL;
		}

		public function get ERROR_CONFIG_XML_LOAD():String
		{
			return _ERROR_CONFIG_XML_LOAD;
		}

		public function get CLOSE_BTN_LABEL():String
		{
			return _CLOSE_BTN_LABEL;
		}

		public function get INSTALL_LOG_BTN_LABEL():String
		{
			return _INSTALL_LOG_BTN_LABEL;
		}

		public function get BROWSE_BTN_LABEL():String
		{
			return _BROWSE_BTN_LABEL;
		}

		public function get SELECT_PATH_PROMPT():String
		{
			return _SELECT_PATH_PROMPT;
		}

		public function get INSTALL_BTN_LABEL():String
		{
			return _INSTALL_BTN_LABEL;
		}

		public function get STEP_CREATE_DIRECTORIES():String
		{
			return _STEP_CREATE_DIRECTORIES;
		}

		public function get STEP_DOWNLOAD_FLEX_SDK():String
		{
			return _STEP_DOWNLOAD_FLEX_SDK;
		}

		public function get STEP_DOWNLOAD_AIR_RUNTIME_KIT():String
		{
			return _STEP_DOWNLOAD_AIR_RUNTIME_KIT;
		}

		public function get STEP_UNZIP_AIR_RUNTIME_KIT():String
		{
			return _STEP_UNZIP_AIR_RUNTIME_KIT;
		}

		public function get STEP_DOWNLOAD_FLASHPLAYER_SWC():String
		{
			return _STEP_DOWNLOAD_FLASHPLAYER_SWC;
		}

		public function get STEP_INSTALL_CONFIG_FILES():String
		{
			return _STEP_INSTALL_CONFIG_FILES;
		}

		public function get ERROR_UNABLE_TO_DOWNLOAD_FLEX_SDK():String
		{
			return _ERROR_UNABLE_TO_DOWNLOAD_FLEX_SDK;
		}

		public function get ERROR_UNABLE_TO_DOWNLOAD_AIR_SDK():String
		{
			return _ERROR_UNABLE_TO_DOWNLOAD_AIR_SDK;
		}

		public function get ERROR_UNABLE_TO_DOWNLOAD_FLASH_PLAYER_SWC():String
		{
			return _ERROR_UNABLE_TO_DOWNLOAD_FLASH_PLAYER_SWC;
		}

		public function get INFO_ABORT_INSTALLATION():String
		{
			return _INFO_ABORT_INSTALLATION;
		}

		public function get ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY():String
		{
			return _ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY;
		}

		public function get ERROR_UNABLE_TO_CREATE_TEMP_DIRECTORY():String
		{
			return _ERROR_UNABLE_TO_CREATE_TEMP_DIRECTORY;
		}

		public function get ERROR_INVALID_FLEX_SDK_DIRECTORY():String
		{
			return _ERROR_INVALID_FLEX_SDK_DIRECTORY;
		}

		public function get ERROR_UNABLE_TO_INSTALL_CONFIG_FILES():String
		{
			return _ERROR_UNABLE_TO_INSTALL_CONFIG_FILES;
		}

		public function get NEXT_BTN_LABEL():String
		{
			return _NEXT_BTN_LABEL;
		}

		public function get ASK_OSMF():String
		{
			return _ASK_OSMF;
		}

		public function get ASK_BLAZEDS():String
		{
			return _ASK_BLAZEDS;
		}

		public function get ASK_TLF():String
		{
			return _ASK_TLF;
		}

		public function get ASK_FONTSWF():String
		{
			return _ASK_FONTSWF;
		}

		public function get INSTALL():String
		{
			return _INSTALL;
		}

		public function get DONT_INSTALL():String
		{
			return _DONT_INSTALL;
		}

		public function get STEP_OPTIONAL_INSTALL_FONTSWF():String
		{
			return _STEP_OPTIONAL_INSTALL_FONTSWF;
		}

		public function get STEP_OPTIONAL_INSTALL_BLAZEDS():String
		{
			return _STEP_OPTIONAL_INSTALL_BLAZEDS;
		}

		public function get STEP_OPTIONAL_INSTALL_TLF():String
		{
			return _STEP_OPTIONAL_INSTALL_TLF;
		}

		public function get STEP_OPTIONAL_INSTALL_OSMF():String
		{
			return _STEP_OPTIONAL_INSTALL_OSMF;
		}

		public function get INFO_DOWNLOADING_ADOBE_FLEX_SDK():String
		{
			return _INFO_DOWNLOADING_ADOBE_FLEX_SDK;
		}

		public function get ERROR_UNABLE_TO_DOWNLOAD_FILE():String
		{
			return _ERROR_UNABLE_TO_DOWNLOAD_FILE;
		}

		public function get ERROR_UNABLE_TO_UNZIP():String
		{
			return _ERROR_UNABLE_TO_UNZIP;
		}

		public function get INFO_DOWNLOADING_FILE_FROM():String
		{
			return _INFO_DOWNLOADING_FILE_FROM;
		}

		public function get INFO_NEED_TO_READ_AND_AGREE_TO_LICENSE():String
		{
			return _INFO_NEED_TO_READ_AND_AGREE_TO_LICENSE;
		}

		public function get MPL_LICENSE_BTN_LABEL():String
		{
			return _MPL_LICENSE_BTN_LABEL;
		}

		public function get ADOBE_LICENSE_BTN_LABEL():String
		{
			return _ADOBE_LICENSE_BTN_LABEL;
		}

		public function get INFO_INSTALLING():String
		{
			return _INFO_INSTALLING;
		}

		public function get OPEN_APACHE_FLEX_FOLDER_BTN_LABEL():String
		{
			return _OPEN_APACHE_FLEX_FOLDER_BTN_LABEL;
		}

		public function get ERROR_DIRECTORY_NOT_EMPTY():String
		{
			return _ERROR_DIRECTORY_NOT_EMPTY;
		}

	
	}
}

class SingletonEnforcer{}