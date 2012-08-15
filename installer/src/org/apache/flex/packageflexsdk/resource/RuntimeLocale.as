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
	import mx.collections.ArrayCollection;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceBundle;
	import mx.resources.ResourceManager;

	public class RuntimeLocale
	{
		
		private var _supportedLanguage:ArrayCollection;
		
		public function get supportedLanguage():ArrayCollection
		{
			return _supportedLanguage;
		}
		public function set supportedLanguage(value:ArrayCollection):void
		{
			_supportedLanguage = value;
		}	
		
		
		private var _defaultLanguage:String;

		public function get defaultLanguage():String
		{
			return _defaultLanguage;
		}

		public function set defaultLanguage(value:String):void
		{
			_defaultLanguage = value;
		}
		
		
		public function RuntimeLocale()
		{
			_defaultLanguage = "en_US";
			_supportedLanguage = new ArrayCollection;
			_supportedLanguage.addItem({label:"English(United States)", data:"en_US"});
			_supportedLanguage.addItem({label:"English(United Kingdom)", data:"en_GB"});
			_supportedLanguage.addItem({label:"English(Australia)", data:"en_AU"});
			_supportedLanguage.addItem({label:"Dutch", data:"nl_NL"});
			_supportedLanguage.addItem({label:"Greek", data:"el_GR"});
			
			installResourcers_en_US();
			installResourcers_el_GR();
			installResourcers_en_AU();
			installResourcers_el_GR();
			installResourcers_nl_NL();
		}
		public function enumerateBundles():void 
		{
			trace ("");
			trace ("");
			var _resourceManager:IResourceManager = ResourceManager.getInstance();
			var bundleName:String = "messagestrings";
			{
				var bundle:ResourceBundle = ResourceBundle(_resourceManager.getResourceBundle("en_US", bundleName));
				for (var key:String in bundle.content) 
				{
					trace ('_resource.content["' + key +'"]=' + '"' +bundle.content[key]+'";');
				}
			}
		}

		protected function installResourcers_en_US():void
		{
			var _resourceManager:IResourceManager = ResourceManager.getInstance();
			var _resource:ResourceBundle = new ResourceBundle("en_US", "messagestrings");
			
			_resource.content["ERROR_VERIFY_FLEX_SDK"]="The Apache Flex SDK MD5 Signature of the downloaded files doesn not match the reference value. The file is invalid, installation is aborted.";
			_resource.content["ERROR_MIRROR_FETCH"]="Error while trying to fetch a mirror for downloading the Apache Flex SDK binaries: ";
	
			_resource.content["FETCH_GEO_IP"]="Trying to fetch the user's country code from the GeoIP service...";
			_resource.content["FETCH_GEO_IP_DONE"]="Fetched the user's country code from the GeoIP service.";
			_resource.content["FETCH_GEO_IP_ERROR"]="An error occurred while fetching the user's country code from the GeoIP service.";
			_resource.content["FETCH_MIRROR_CGI"]="Trying to fetch the SDK download mirror URL from the CGI...";
			_resource.content["FETCH_MIRROR_CGI_DONE"]="Fetched the SDK download mirror URL from the CGI.";
			_resource.content["FETCH_MIRROR_CGI_ERROR"]="Could not fetch the SDK download mirror URL from the CGI. Going to try the GeoIP route.";
			_resource.content["FETCH_MIRROR_LIST"]="Trying to fetch the mirror list from Apache.org...";
			_resource.content["FETCH_MIRROR_LIST_DONE"]="Fetched the mirror list from Apache.org.";
			_resource.content["FETCH_MIRROR_LIST_PARSED"]="Parsed the mirror list using the country code and got this domain: ";

			_resource.content["INFO_VERIFY_FLEX_SDK_DONE"]="The Apache Flex SDK MD5 Signature of the downloaded files matches the reference. The file is valid.";
			
			_resource.content["STEP_VERIFY_FLEX_SDK"]="Verifying Apache Flex SDK MD5 Signature";
			
			_resource.content["browse_btn_label"]="BROWSE";
			_resource.content["install_log_btn_label"]="INSTALL LOG";
			_resource.content["install_btn_label"]="INSTALL";
			_resource.content["close_btn_label"]="CLOSE";
			_resource.content["select_path_prompt"]="Where do you want to install the Apache Flex SDK?";
			_resource.content["next_btn_label"]="NEXT";
			_resource.content["show_mpl_license_btn_label"]="SHOW MPL LICENSE";
			_resource.content["show_adobe_license_btn_label"]="SHOW ADOBE LICENSE";
			_resource.content["open_apache_flex_folder_btn_label"]="OPEN APACHE FLEX FOLDER";

			_resource.content["info_dowloading_air_runtime_kit_mac"]="Downloading Adobe AIR Runtime Kit for Mac from: ";
			_resource.content["info_finished_untaring"]="Finished untaring: ";
			_resource.content["info_dowloading_air_runtime_kit_windows"]="Downloading Adobe AIR Runtime Kit for Windows from: ";
			_resource.content["info_invoked_gui_mode"]="invoked in GUI mode";
			_resource.content["info_enter_valid_flex_sdk_path"]="Please enter valid directory path for the Flex SDK";
			_resource.content["info_select_directory"]="Select the directory where you want to install the Flex SDK";
			_resource.content["info_app_invoked"]="Invoked in command line mode with the following arguments: ";
			_resource.content["info_downloaded"]="Download complete ";
			_resource.content["info_abort_installation"]="Installation aborted";
			_resource.content["info_unzipping"]="Uncompressing: ";
			_resource.content["info_installing_playerglobal_swc"]="Installing Adobe Flash Player playerglobal.swc from: ";
			_resource.content["info_installing_config_files"]="Installing frameworks configuration files configured for use with an IDE";
			_resource.content["info_creating_temp_dir"]="Creating temporary directory";
			_resource.content["info_installation_complete"]="Installation complete";
			_resource.content["info_finished_unzipping"]="Finished uncompressing: ";
			_resource.content["info_dowloading_flex_sdk"]="Downloading Apache Flex SDK from: ";
			_resource.content["info_dowloading_adobe_flex_sdk"]="Downloading Adobe Flex SDK from: ";
			_resource.content["info_dowloading_file_from"]="Downloading {0} from: {1}";
			_resource.content["info_need_to_read_and_agree_to_license"]="These components have license agrements other than the Apache License.  " +
																		"Please click on each item on the left, read the license and confirm that you agree " +
																		"to the terms of each license.";
			_resource.content["info_installing"]="Installing...";
			
			_resource.content["error_unable_to_copy_file"]="Unable to copy file ";
			_resource.content["error_config_xml_load"]="Error while trying to load XML configuration file: ";
			_resource.content["error_unable_to_download_flash_player_swc"]="Unable to download Flash Player swc";
			_resource.content["error_unable_to_delete_temp_directory"]="Unable to clean up temporary installation directories";
			_resource.content["error_unable_to_download_air_sdk"]="Unable to download Adobe AIR Runtime Kit";
			_resource.content["error_invalid_flash_player_swc_url"]="Flash Player swc URL invalid in configuration file";
			_resource.content["error_unsupported_operating_system"]="Unsupported operating system";
			_resource.content["error_invalid_sdk_url"]="Apache Flex SDK URL invalid in configuration file";
			_resource.content["error_invalid_air_sdk_url_mac"]="Adobe AIR SDK URL for Mac invalid in configuration file";
			_resource.content["info_creating_flex_home"]="Creating Apache Flex home";
			_resource.content["error_native_process_error"]="Native Process error unable to untar Adobe AIR SDK";
			_resource.content["error_invalid_air_sdk_url_windows"]="Adobe AIR SDK URL for Windows invalid in configuration file";
			_resource.content["error_unable_to_download_flex_sdk"]="Unable to download Apache Flex SDK";
			_resource.content["error_native_process_not_supported"]="Native Process not supported.  Unable to untar Adobe AIR SDK";
			_resource.content["error_unable_to_create_temp_directory"]="Unable to create temporary directory";
			_resource.content["error_invalid_flex_sdk_directory"]="Invalid Flex SDK directory selected";
			_resource.content["error_unable_to_install_config_files"]="Unable to install configuration files";
			_resource.content["error_unable_to_download_file"]="Unable to download {0}";
			_resource.content["error_unable_to_unzip"]="Unable to unzip file: ";
			_resource.content["error_dir_not_empty"]="The selected directory is not empty";
			
			
			_resource.content["config_url"]="http://people.apache.org/~bigosmallm/installapacheflex/ApacheFlexConfig.xml";
			_resource.content["apache_flex_url"]="http://incubator.apache.org/flex/";
			_resource.content["adobe_flex_sdk_license_url"]="http://www.adobe.com/products/eulas/pdfs/adobe_flex_software_development_kit-combined-20110916_0930.pdf"

			_resource.content["step_download_air_runtime_kit"]="Download Adobe AIR Runtime Kit";
			_resource.content["step_unzip_air_runtime_kit"]="Uncompress Adobe AIR Runtime Kit";
			_resource.content["step_unzip_flex_sdk"]="Uncompress Apache Flex SDK";
			_resource.content["step_download_flashplayer_swc"]="Download Flash Player swc";
			_resource.content["step_download_flex_sdk"]="Download Apache Flex SDK";
			_resource.content["step_install_config_files"]="Install Framework Configuration Files";
			_resource.content["step_create_directories"]="Create Directories";
			_resource.content["step_optional_install_FontSwf"]="Adobe Fontswf Utility (Optional)";
			_resource.content["step_optional_install_BlazeDS"]="BlazeDS (Optional)";
			_resource.content["step_optional_install_TLF"]="Adobe Text Layout Framework (Required)";
			_resource.content["step_optional_install_OSMF"]="OSMF (Required)";
			
			//Optional install prompts
			_resource.content["install"] = "I Agree, Install"
			_resource.content["dont_install"] = "I Disagree, Don't Install"
			_resource.content["ask_osmf"]="The Open Source Media Framework (OSMF) used by the video components is licensed under the Mozilla Public License Version 1.1.";
			_resource.content["ask_tlf"]="The Adobe Text Layout Framework (TLF) used by the Spark text components is licensed under the Mozilla Public License Version 1.1.";
			_resource.content["ask_fontswf"]="Apache Flex can optionally integrate with Adobe's embedded font support.  " +
											"This feature requires a few font jars from the Adobe Flex SDK.  " +
											"The Adobe SDK license agreement for Adobe Flex 4.6 applies to these jars.  " +
											"This license is not compatible with the Apache v2 license.  " +
											"Do you want to install these jars from the Adobe Flex SDK?";

			_resource.content["ask_blazeds"]="Apache Flex can optionally integrate with Adobe BlazeDS.  " +
												"This feature requires flex-messaging-common.jar from the Adobe Flex SDK.  " +
												"The Adobe SDK license agreement for Adobe Flex 4.6 applies to this jar.  " +
												"This license is not compatible with the Apache v2 license.  " +
												"Do you want to install this jar from the Adobe Flex SDK?"
			
			_resourceManager.addResourceBundle(_resource);
			_resourceManager.update();
		}
		
		protected function installResourcers_el_GR():void
		{
			var _resourceManager:IResourceManager = ResourceManager.getInstance();
			var _resource:ResourceBundle = new ResourceBundle("el_GR", "messagestrings");

			_resource.content["browse_btn_label"]="Αναζήτηση";
			_resource.content["install_log_btn_label"]="αρχείο καταγραφής εγκατάστασης";
			_resource.content["install_btn_label"]="Εγκατάσταση";
			_resource.content["close_btn_label"]="Έξοδος";
			_resource.content["select_path_prompt"]="Πληκτρολογήστε η επιλέξτε μια έγκυρη διαδρομή για το Flex SDK";
			
			_resource.content["info_dowloading_air_runtime_kit_mac"]="Λήψη Adobe AIR Runtime Kit για Mac από:";
			_resource.content["info_finished_untaring"]="Η αποσυμπίεση τελείωσε:";
			_resource.content["info_dowloading_air_runtime_kit_windows"]="Λήψη Adobe AIR Runtime Kit για Windows από:";
			_resource.content["info_invoked_gui_mode"]="Κλήση με λειτουργία γραφικού περιβάλλοντος";
			_resource.content["info_enter_valid_flex_sdk_path"]="Παρακαλώ εισάγετε μια έγκυρη διαδρομή καταλόγου για το the Flex SDK";
			_resource.content["info_installing_playerglobal_swc"]="Εγκατάσταση Adobe Flash Player playerglobal.swc από:";
			_resource.content["info_installation_complete"]="Η εγκατάσταση ολοκληρώθηκε.";
			_resource.content["info_creating_temp_dir"]="Δημιουργία προσωρινού καταλόγου";
			_resource.content["info_dowloading_flex_sdk"]="Λήψη Apache Flex SDK από:";
			_resource.content["info_creating_flex_home"]="Δημιουργία αρχικού καταλόγου για Apache Flex";
			_resource.content["info_finished_unzipping"]="Η αποσυμπίεση τελείωσε:";
			_resource.content["info_downloaded"]="Η λήψη ολοκληρώθηκε";
			_resource.content["info_select_directory"]="Επιλέξτε ένα κατάλογο";
			_resource.content["info_app_invoked"]="Κλήση με λειτουργία γραμμής εντολών με τα ακόλουθα ορίσματα:";
			_resource.content["info_abort_installation"]="Ματαίωση εγκατάστασης";
			_resource.content["info_installing_config_files"]="Εγκατάσταση αρχείων ρυθμίσεων για  frameworks ρυθμισμένα για χρήση IDE";
			_resource.content["info_unzipping"]="Ααποσυμπίεση: ";
			
			_resource.content["error_unable_to_download_flash_player_swc"]="Δεν είναι δυνατή η λήψη του Flash Player swc";
			_resource.content["error_native_process_error"]="Λάθος στο Native Process Δεν είναι δυνατή η αποσυμπίεση (untar) του Adobe AIR SDK";
			_resource.content["error_unsupported_operating_system"]="Δεν υποστηρίζεται το λειτουργικό σύστημα";
			_resource.content["error_invalid_air_sdk_url_mac"]="Άκυρο Adobe AIR SDK URL για Mac στο αρχείο ρυθμίσεων";
			_resource.content["error_invalid_sdk_url"]="Ακυρο Apache Flex SDK URL στο αρχείο ρυθμίσεων.";
			_resource.content["error_unable_to_download_flex_sdk"]="Δεν είναι δυνατή η λήψη του Apache Flex SDK";
			_resource.content["error_native_process_not_supported"]="Native Process δεν υποστηρίζεται.  Δεν είναι δυνατή η αποσυμπίεση(untar)του Adobe AIR SDK";
			_resource.content["error_invalid_air_sdk_url_windows"]="Άκυρο Adobe AIR SDK URL για Windows στο αρχείο ρυθμίσεων";
			_resource.content["error_invalid_flash_player_swc_url"]="Άκυρο Flash Player swc URL στο αρχείο ρυθμίσεων";
			_resource.content["error_config_xml_load"]="Πρόεκυψε σφάλμα στην προσπάθεια φόρτωσης του αρχείου ρυθμίσεων XML:";
			_resource.content["error_unable_to_delete_temp_directory"]="Δεν είναι δυνατή η εκκαθάριση των προσωρινών καταλόγων εγκατάστασης";
			_resource.content["error_unable_to_copy_file"]="Δεν είναι δυνατή η αντιγραφή του αρχείου ";
			_resource.content["error_unable_to_download_air_sdk"]="Δεν είναι δυνατή η λήψη του Adobe AIR Runtime Kit";
			_resource.content["error_unable_to_create_temp_directory"]="Δεν είναι δυνατή η δημιουργία προσωρινού καταλόγου";
			_resource.content["error_invalid_flex_sdk_directory"]="Έχετε επιλέξει άκυρο κατάλογο για το Flex SDK ";
			_resource.content["error_unable_to_install_config_files"]="Δεν είναι δυνατή η εγκατάσταση των αρχείων ρυθμίσεων";
			
			
			_resource.content["apache_flex_url"]="http://incubator.apache.org/flex/";
			_resource.content["config_url"]="ApacheFlexConfig.xml";
			
			_resource.content["step_download_flashplayer_swc"]="Λήψη Flash Player swc";
			_resource.content["step_download_flex_sdk"]="Λήψη Apache Flex SDK";
			_resource.content["step_download_air_runtime_kit"]="Λήψη Adobe AIR Runtime Kit";
			_resource.content["step_install_config_files"]="Εγκατάσταση αρχείων ρυθμίσεων του Framework";
			_resource.content["step_create_directories"]="Δημιουργία Καταλόγων";
			_resource.content["step_unzip_flex_sdk"]="Ααποσυμπίεση Apache Flex SDK";
			_resource.content["step_unzip_air_runtime_kit"]="Ααποσυμπίεση Adobe AIR Runtime Kit";
			
			
			_resourceManager.addResourceBundle(_resource);
			_resourceManager.update();
			
		}
		
		protected function installResourcers_nl_NL():void
		{
			var _resourceManager:IResourceManager = ResourceManager.getInstance();
			var _resource:ResourceBundle = new ResourceBundle("nl_NL", "messagestrings");

			_resource.content["browse_btn_label"]="Bladeren...";
			_resource.content["install_log_btn_label"]="Installatie Log";
			_resource.content["install_btn_label"]="Installeren";
			_resource.content["close_btn_label"]="Sluiten";
			_resource.content["select_path_prompt"]="Geef Flex SDK pad in of blader naar het pad";
			
			_resource.content["info_installation_complete"]="Installatie gereed.";
			_resource.content["info_creating_temp_dir"]="Maakt tijdelijke map aan";
			_resource.content["info_installing_config_files"]="Framework configuratie bestanden voor gebruik met IDE worden geinstalleerd";
			_resource.content["info_dowloading_air_runtime_kit_mac"]="Adobe AIR Runtime Kit voor Mac wordt gedownload van: ";
			_resource.content["info_dowloading_flex_sdk"]="Apache Flex SDK wordt gedownload van: ";
			_resource.content["info_creating_flex_home"]="Maakt flex home aan";
			_resource.content["info_finished_untaring"]="Klaar met uitpakken:";
			_resource.content["info_dowloading_air_runtime_kit_windows"]="Adobe AIR Runtime Kit voor Windows wordt gedownload van: ";
			_resource.content["info_downloaded"]="Gedownload ";
			_resource.content["info_enter_valid_flex_sdk_path"]="Geef een geldig Flex SDK pad in";
			_resource.content["info_finished_unzipping"]="Klaar met uitpakken: ";
			_resource.content["info_select_directory"]="Kies een map";
			_resource.content["info_unzipping"]="Uitpakken: ";
			_resource.content["info_app_invoked"]="Opgestart in command line modus met de volgende argumenten: ";
			_resource.content["info_installing_playerglobal_swc"]="Adobe Flash Player playerglobal.swc wordt geinstalleerd van:";
			_resource.content["info_invoked_gui_mode"]="Opgestart in visuele modus";
			
			_resource.content["error_unable_to_copy_file"]="Kan bestand niet kopieeren ";
			_resource.content["error_config_xml_load"]="Fout tijdens het laden van het XML configuratie bestand: ";
			_resource.content["error_native_process_error"]="Native Process fout kan Adobe AIR SDK niet uitpakken";
			_resource.content["error_unsupported_operating_system"]="Besturingsysteem is niet ondersteund";
			_resource.content["error_invalid_air_sdk_url_mac"]="Adobe AIR SDK URL voor Mac is ongeldig in configuratie bestand";
			_resource.content["error_invalid_sdk_url"]="Apache Flex SDK URL ongeldig in configuratie bestand";
			_resource.content["error_native_process_not_supported"]="Native Process niet ondersteund.  Kan Adobe AIR SDK niet uitpakken";
			_resource.content["error_invalid_air_sdk_url_windows"]="Adobe AIR SDK URL voor Windows is ongeldig in configuratie bestand";
			_resource.content["error_invalid_flash_player_swc_url"]="Flash Player swc URL is ongeldig in configuratie bestand";
			_resource.content["error_unable_to_download_flex_sdk"]="Downloaden Apache Flex SDK mislukt";
			_resource.content["error_unable_to_download_air_sdk"]="Downloaden Adobe AIR Runtime Kit mislukt";
			_resource.content["error_unable_to_download_flash_player_swc"]="Downloaden Flash Player swc mislukt";
			_resource.content["info_abort_installation"]="Installatie wordt afgebroken";
			_resource.content["error_unable_to_delete_temp_directory"]="Opruimen van tijdelijke installatie bestanden mislukt";
			_resource.content["error_unable_to_create_temp_directory"]="Unable to create temporary directory";
			_resource.content["error_invalid_flex_sdk_directory"]="Invalid Flex SDK directory selected";
			_resource.content["error_unable_to_install_config_files"]="Unable to install configuration files";

			
			_resource.content["config_url"]="ApacheFlexConfig.xml";
			_resource.content["apache_flex_url"]="http://incubator.apache.org/flex/";
			
			_resource.content["step_download_flex_sdk"]="Apache Flex SDK Downloaden";
			_resource.content["step_unzip_flex_sdk"]="Apache Flex SDK uitpakken";
			_resource.content["step_download_air_runtime_kit"]="Adobe AIR Runtime Kit Downloaden";
			_resource.content["step_unzip_air_runtime_kit"]="Adobe AIR Runtime Kit Uitpakken";
			_resource.content["step_download_flashplayer_swc"]="Flash Player swc Downloaden";
			_resource.content["step_install_config_files"]="Framework Configuratie Bestanden Installeren";
			_resource.content["step_create_directories"]="Mappen aanmaken";
			
			_resourceManager.addResourceBundle(_resource);
			_resourceManager.update();

		}
		protected function installResourcers_en_AU():void
		{
			var _resourceManager:IResourceManager = ResourceManager.getInstance();
			var _resource:ResourceBundle = new ResourceBundle("en_AU", "messagestrings");
			
			_resource.content["browse_btn_label"]="BROWSE";
			_resource.content["install_log_btn_label"]="INSTALL LOG";
			_resource.content["install_btn_label"]="INSTALL";
			_resource.content["close_btn_label"]="CLOSE";
			_resource.content["select_path_prompt"]="Enter Flex SDK path or browse to select a path";
			
			_resource.content["info_dowloading_air_runtime_kit_mac"]="Downloading Adobe AIR Runtime Kit for Mac from: ";
			_resource.content["info_finished_untaring"]="Finished untaring: ";
			_resource.content["info_dowloading_air_runtime_kit_windows"]="Downloading Adobe AIR Runtime Kit for Windows from: ";
			_resource.content["info_invoked_gui_mode"]="invoked in GUI mode";
			_resource.content["info_enter_valid_flex_sdk_path"]="Please enter valid directory path for the Flex SDK";
			_resource.content["info_select_directory"]="Select a directory";
			_resource.content["info_app_invoked"]="Invoked in command line mode with the following arguments: ";
			_resource.content["info_downloaded"]="Download complete ";
			_resource.content["info_abort_installation"]="Aborting Installation";
			_resource.content["info_unzipping"]="Unzipping: ";
			_resource.content["info_installing_playerglobal_swc"]="Installing Adobe Flash Player playerglobal.swc from: ";
			_resource.content["info_installing_config_files"]="Installing frameworks configuration files configured for use with an IDE";
			_resource.content["info_installation_complete"]="Installation complete.";
			_resource.content["info_creating_temp_dir"]="Creating temporary directory";
			_resource.content["info_creating_flex_home"]="Creating Apache Flex home";
			_resource.content["info_finished_unzipping"]="Finished unzipping: ";
			_resource.content["info_dowloading_flex_sdk"]="Downloading Apache Flex SDK from: ";

			_resource.content["error_unable_to_copy_file"]="Unable to copy file ";
			_resource.content["error_config_xml_load"]="Error while trying to load XML configuration file: ";
			_resource.content["error_unable_to_download_flash_player_swc"]="Unable to download Flash Player swc";
			_resource.content["error_unable_to_delete_temp_directory"]="Unable to clean up temporary installation directories";
			_resource.content["error_unable_to_download_air_sdk"]="Unable to download Adobe AIR Runtime Kit";
			_resource.content["error_invalid_flash_player_swc_url"]="Flash Player swc URL invalid in configuration file";
			_resource.content["error_unsupported_operating_system"]="Unsupported operating system";
			_resource.content["error_invalid_sdk_url"]="Apache Flex SDK URL invalid in configuration file";
			_resource.content["error_invalid_air_sdk_url_mac"]="Adobe AIR SDK URL for Mac invalid in configuration file";
			_resource.content["error_native_process_error"]="Native Process error unable to untar Adobe AIR SDK";
			_resource.content["error_invalid_air_sdk_url_windows"]="Adobe AIR SDK URL for Windows invalid in configuration file";
			_resource.content["error_unable_to_download_flex_sdk"]="Unable to download Apache Flex SDK";
			_resource.content["error_native_process_not_supported"]="Native Process not supported.  Unable to untar Adobe AIR SDK";
			_resource.content["error_unable_to_create_temp_directory"]="Unable to create temporary directory";
			_resource.content["error_invalid_flex_sdk_directory"]="Invalid Flex SDK directory selected";
			_resource.content["error_unable_to_install_config_files"]="Unable to install configuration files";

			_resource.content["config_url"]="ApacheFlexConfig.xml";
			_resource.content["apache_flex_url"]="http://incubator.apache.org/flex/";
			
			_resource.content["step_install_config_files"]="Install Framework Configuration Files";
			_resource.content["step_unzip_flex_sdk"]="Unzip Apache Flex SDK";
			_resource.content["step_unzip_air_runtime_kit"]="Unzip Adobe AIR Runtime Kit";
			_resource.content["step_download_flashplayer_swc"]="Download Flash Player swc";
			_resource.content["step_download_flex_sdk"]="Download Apache Flex SDK";
			_resource.content["step_download_air_runtime_kit"]="Download Adobe AIR Runtime Kit";
			_resource.content["step_create_directories"]="Create Directories";
			
			_resourceManager.addResourceBundle(_resource);
			_resourceManager.update();
		}
		
		protected function installResourcers_en_GB():void
		{
			var _resourceManager:IResourceManager = ResourceManager.getInstance();
			var _resource:ResourceBundle = new ResourceBundle("en_AU", "messagestrings");
			
			_resource.content["browse_btn_label"]="BROWSE";
			_resource.content["install_log_btn_label"]="INSTALL LOG";
			_resource.content["install_btn_label"]="INSTALL";
			_resource.content["close_btn_label"]="CLOSE";
			_resource.content["select_path_prompt"]="Enter Flex SDK path or browse to select a path";
			
			_resource.content["info_dowloading_air_runtime_kit_mac"]="Downloading Adobe AIR Runtime Kit for Mac from: ";
			_resource.content["info_finished_untaring"]="Finished untaring: ";
			_resource.content["info_dowloading_air_runtime_kit_windows"]="Downloading Adobe AIR Runtime Kit for Windows from: ";
			_resource.content["info_invoked_gui_mode"]="invoked in GUI mode";
			_resource.content["info_enter_valid_flex_sdk_path"]="Please enter valid directory path for the Flex SDK";
			_resource.content["info_select_directory"]="Select a directory";
			_resource.content["info_app_invoked"]="Invoked in command line mode with the following arguments: ";
			_resource.content["info_downloaded"]="Download complete ";
			_resource.content["info_abort_installation"]="Aborting Installation";
			_resource.content["info_unzipping"]="Unzipping: ";
			_resource.content["info_installing_playerglobal_swc"]="Installing Adobe Flash Player playerglobal.swc from: ";
			_resource.content["info_installing_config_files"]="Installing frameworks configuration files configured for use with an IDE";
			_resource.content["info_installation_complete"]="Installation complete.";
			_resource.content["info_creating_temp_dir"]="Creating temporary directory";
			_resource.content["info_creating_flex_home"]="Creating Apache Flex home";
			_resource.content["info_finished_unzipping"]="Finished unzipping: ";
			_resource.content["info_dowloading_flex_sdk"]="Downloading Apache Flex SDK from: ";

			_resource.content["error_unable_to_copy_file"]="Unable to copy file ";
			_resource.content["error_config_xml_load"]="Error while trying to load XML configuration file: ";
			_resource.content["step_unzip_flex_sdk"]="Unzip Apache Flex SDK";
			_resource.content["error_unable_to_download_flash_player_swc"]="Unable to download Flash Player swc";
			_resource.content["error_unable_to_delete_temp_directory"]="Unable to clean up temporary installation directories";
			_resource.content["error_unable_to_download_air_sdk"]="Unable to download Adobe AIR Runtime Kit";
			_resource.content["error_invalid_flash_player_swc_url"]="Flash Player swc URL invalid in configuration file";
			_resource.content["error_unsupported_operating_system"]="Unsupported operating system";
			_resource.content["error_invalid_sdk_url"]="Apache Flex SDK URL invalid in configuration file";
			_resource.content["error_invalid_air_sdk_url_mac"]="Adobe AIR SDK URL for Mac invalid in configuration file";
			_resource.content["error_native_process_error"]="Native Process error unable to untar Adobe AIR SDK";
			_resource.content["error_invalid_air_sdk_url_windows"]="Adobe AIR SDK URL for Windows invalid in configuration file";
			_resource.content["error_unable_to_download_flex_sdk"]="Unable to download Apache Flex SDK";
			_resource.content["error_native_process_not_supported"]="Native Process not supported.  Unable to untar Adobe AIR SDK";
			_resource.content["error_unable_to_create_temp_directory"]="Unable to create temporary directory";
			_resource.content["error_invalid_flex_sdk_directory"]="Invalid Flex SDK directory selected";
			_resource.content["error_unable_to_install_config_files"]="Unable to install configuration files";

			_resource.content["config_url"]="ApacheFlexConfig.xml";
			_resource.content["apache_flex_url"]="http://incubator.apache.org/flex/";
			
			_resource.content["step_unzip_air_runtime_kit"]="Unzip Adobe AIR Runtime Kit";
			_resource.content["step_install_config_files"]="Install Framework Configuration Files";
			_resource.content["step_download_flashplayer_swc"]="Download Flash Player swc";
			_resource.content["step_download_flex_sdk"]="Download Apache Flex SDK";
			_resource.content["step_download_air_runtime_kit"]="Download Adobe AIR Runtime Kit";
			_resource.content["step_create_directories"]="Create Directories";

			_resourceManager.addResourceBundle(_resource);
			_resourceManager.update();
		}

	}
}

