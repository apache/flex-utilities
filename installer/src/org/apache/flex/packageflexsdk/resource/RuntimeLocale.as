////////////////////////////////////////////////////////////////////////////////
//
// Licensed to the Apache Software Foundation (ASF) under one or more
// contributor license agreements. See the NOTICE file distributed with
// this work for additional information regarding copyright ownership.
// The ASF licenses this file to You under the Apache License, Version 2.0
// (the "License"); you may not use this file except in compliance with
// the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////


package org.apache.flex.packageflexsdk.resource
{

import mx.resources.IResourceManager;
import mx.resources.ResourceBundle;
import mx.resources.ResourceManager;

public class RuntimeLocale
{
	
	//--------------------------------------------------------------------------
	//
	// Class constants
	//
	//--------------------------------------------------------------------------
	
	public static const EL_GR:String = "el_GR";
	public static const EN_AU:String = "en_AU";
	public static const EN_GB:String = "en_GB";
	public static const EN_US:String = "en_US";
	public static const ES_ES:String = "es_ES";
	public static const NL_NL:String = "nl_NL";
	public static const PT_BR:String = "pt_BR";
	
	//--------------------------------------------------------------------------
	//
	// Class properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	// instance
	//----------------------------------
	
	private static var _instance:RuntimeLocale;
	
	public static function get instance():RuntimeLocale
	{
		if (!_instance)
			_instance = new RuntimeLocale(new SE());
		
		return _instance;
	}
	
	//--------------------------------------------------------------------------
	//
	// Constructor
	//
	//--------------------------------------------------------------------------
	
	public function RuntimeLocale(se:SE) { }
	
	//--------------------------------------------------------------------------
	//
	// Methods
	//
	//--------------------------------------------------------------------------
	
	private var _initialized:Boolean;
	
	private var _resourceManager:IResourceManager;
	
	//--------------------------------------------------------------------------
	//
	// Methods
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	// installResources
	//----------------------------------
	
	public function installResources():void
	{
		if (!_initialized)
		{
			_resourceManager = ResourceManager.getInstance();
			
			install_el_GR();
			install_en_AU();
			install_en_GB();
			install_en_US();
			install_es_ES();
			install_nl_NL();
			install_pt_BR();
			
			_initialized = true;
		}
	}
	
	//----------------------------------
	// install_el_GR
	//----------------------------------
	
	private function install_el_GR():void
	{
		var locale:String = EL_GR;
		var resource:ResourceBundle = new ResourceBundle(locale, ViewResourceConstants.BUNDLE_NAME);
		
		var content:Object = resource.content;
		content["BTN_LABEL_BROWSE"]="Αναζήτηση";
		content["BTN_LABEL_CLOSE"]="Έξοδος";
		content["BTN_LABEL_INSTALL"]="Εγκατάσταση";
		content["BTN_LABEL_INSTALL_LOG"]="αρχείο καταγραφής εγκατάστασης";
		content["ERROR_CONFIG_XML_LOAD"]="Πρόεκυψε σφάλμα στην προσπάθεια φόρτωσης του αρχείου ρυθμίσεων XML:";
		content["ERROR_INVALID_AIR_SDK_URL_MAC"]="Άκυρο Adobe AIR SDK URL για Mac στο αρχείο ρυθμίσεων";
		content["ERROR_INVALID_AIR_SDK_URL_WINDOWS"]="Άκυρο Adobe AIR SDK URL για Windows στο αρχείο ρυθμίσεων";
		content["ERROR_INVALID_FLASH_PLAYER_SWC_URL"]="Άκυρο Flash Player swc URL στο αρχείο ρυθμίσεων";
		content["ERROR_INVALID_FLEX_SDK_DIRECTORY"]="Έχετε επιλέξει άκυρο κατάλογο για το Flex SDK ";
		content["ERROR_INVALID_SDK_URL"]="Ακυρο Apache Flex SDK URL στο αρχείο ρυθμίσεων.";
		content["ERROR_NATIVE_PROCESS_ERROR"]="Λάθος στο Native Process Δεν είναι δυνατή η αποσυμπίεση (untar) του Adobe AIR SDK";
		content["ERROR_NATIVE_PROCESS_NOT_SUPPORTED"]="Native Process δεν υποστηρίζεται. Δεν είναι δυνατή η αποσυμπίεση(untar)του Adobe AIR SDK";
		content["ERROR_UNABLE_TO_COPY_FILE"]="Δεν είναι δυνατή η αντιγραφή του αρχείου ";
		content["ERROR_UNABLE_TO_CREATE_TEMP_DIRECTORY"]="Δεν είναι δυνατή η δημιουργία προσωρινού καταλόγου";
		content["ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY"]="Δεν είναι δυνατή η εκκαθάριση των προσωρινών καταλόγων εγκατάστασης";
		content["ERROR_UNABLE_TO_DOWNLOAD_AIR_SDK"]="Δεν είναι δυνατή η λήψη του Adobe AIR Runtime Kit";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLASH_PLAYER_SWC"]="Δεν είναι δυνατή η λήψη του Flash Player swc";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLEX_SDK"]="Δεν είναι δυνατή η λήψη του Apache Flex SDK";
		content["ERROR_UNABLE_TO_INSTALL_CONFIG_FILES"]="Δεν είναι δυνατή η εγκατάσταση των αρχείων ρυθμίσεων";
		content["ERROR_UNSUPPORTED_OPERATING_SYSTEM"]="Δεν υποστηρίζεται το λειτουργικό σύστημα";
		content["INFO_ABORT_INSTALLATION"]="Ματαίωση εγκατάστασης";
		content["INFO_APP_INVOKED"]="Κλήση με λειτουργία γραμμής εντολών με τα ακόλουθα ορίσματα:";
		content["INFO_CREATING_FLEX_HOME"]="Δημιουργία αρχικού καταλόγου για Apache Flex";
		content["INFO_CREATING_TEMP_DIR"]="Δημιουργία προσωρινού καταλόγου";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_MAC"]="Λήψη Adobe AIR Runtime Kit για Mac από:";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_WINDOWS"]="Λήψη Adobe AIR Runtime Kit για Windows από:";
		content["INFO_DOWNLOADING_FLEX_SDK"]="Λήψη Apache Flex SDK από:";
		content["INFO_DOWNLOADED"]="Η λήψη ολοκληρώθηκε";
		content["INFO_ENTER_VALID_FLEX_SDK_PATH"]="Παρακαλώ εισάγετε μια έγκυρη διαδρομή καταλόγου για το the Flex SDK";
		content["INFO_FINISHED_UNTARING"]="Η αποσυμπίεση τελείωσε:";
		content["INFO_FINISHED_UNZIPPING"]="Η αποσυμπίεση τελείωσε:";
		content["INFO_INSTALLATION_COMPLETE"]="Η εγκατάσταση ολοκληρώθηκε.";
		content["INFO_INSTALLING_CONFIG_FILES"]="Εγκατάσταση αρχείων ρυθμίσεων για frameworks ρυθμισμένα για χρήση IDE";
		content["INFO_INSTALLING_PLAYERGLOBAL_SWC"]="Εγκατάσταση Adobe Flash Player playerglobal.swc από:";
		content["INFO_INVOKED_GUI_MODE"]="Κλήση με λειτουργία γραφικού περιβάλλοντος";
		content["INFO_SELECT_DIRECTORY"]="Επιλέξτε ένα κατάλογο";
		content["INFO_UNZIPPING"]="Ααποσυμπίεση: ";
		content["SELECT_PATH_PROMPT"]="Πληκτρολογήστε η επιλέξτε μια έγκυρη διαδρομή για το Flex SDK";
		content["STEP_CREATE_DIRECTORIES"]="Δημιουργία Καταλόγων";
		content["STEP_DOWNLOAD_AIR_RUNTIME_KIT"]="Λήψη Adobe AIR Runtime Kit";
		content["STEP_DOWNLOAD_FLASHPLAYER_SWC"]="Λήψη Flash Player swc";
		content["STEP_DOWNLOAD_FLEX_SDK"]="Λήψη Apache Flex SDK";
		content["STEP_INSTALL_CONFIG_FILES"]="Εγκατάσταση αρχείων ρυθμίσεων του Framework";
		content["STEP_UNZIP_AIR_RUNTIME_KIT"]="Ααποσυμπίεση Adobe AIR Runtime Kit";
		content["STEP_UNZIP_FLEX_SDK"]="Ααποσυμπίεση Apache Flex SDK";
		
		
		_resourceManager.addResourceBundle(resource);
	}
	
	//----------------------------------
	// install_en_AU
	//----------------------------------
	
	private function install_en_AU():void
	{
		var locale:String = EN_AU;
		var resource:ResourceBundle = new ResourceBundle(locale, ViewResourceConstants.BUNDLE_NAME);
		
		var content:Object = resource.content;
		content["BTN_LABEL_BROWSE"]="BROWSE";
		content["BTN_LABEL_CLOSE"]="CLOSE";
		content["BTN_LABEL_INSTALL"]="INSTALL";
		content["BTN_LABEL_INSTALL_LOG"]="INSTALL LOG";
		content["ERROR_CONFIG_XML_LOAD"]="Error while trying to load XML configuration file: ";
		content["ERROR_INVALID_AIR_SDK_URL_MAC"]="Adobe AIR SDK URL for Mac invalid in configuration file";
		content["ERROR_INVALID_AIR_SDK_URL_WINDOWS"]="Adobe AIR SDK URL for Windows invalid in configuration file";
		content["ERROR_INVALID_FLASH_PLAYER_SWC_URL"]="Flash Player swc URL invalid in configuration file";
		content["ERROR_INVALID_FLEX_SDK_DIRECTORY"]="Invalid Flex SDK directory selected";
		content["ERROR_INVALID_SDK_URL"]="Apache Flex SDK URL invalid in configuration file";
		content["ERROR_NATIVE_PROCESS_ERROR"]="Native Process error unable to untar Adobe AIR SDK";
		content["ERROR_NATIVE_PROCESS_NOT_SUPPORTED"]="Native Process not supported. Unable to untar Adobe AIR SDK";
		content["ERROR_UNABLE_TO_COPY_FILE"]="Unable to copy file ";
		content["ERROR_UNABLE_TO_CREATE_TEMP_DIRECTORY"]="Unable to create temporary directory";
		content["ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY"]="Unable to clean up temporary installation directories";
		content["ERROR_UNABLE_TO_DOWNLOAD_AIR_SDK"]="Unable to download Adobe AIR Runtime Kit";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLASH_PLAYER_SWC"]="Unable to download Flash Player swc";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLEX_SDK"]="Unable to download Apache Flex SDK";
		content["ERROR_UNABLE_TO_INSTALL_CONFIG_FILES"]="Unable to install configuration files";
		content["ERROR_UNSUPPORTED_OPERATING_SYSTEM"]="Unsupported operating system";
		content["INFO_ABORT_INSTALLATION"]="Aborting Installation";
		content["INFO_APP_INVOKED"]="Invoked in command line mode with the following arguments: ";
		content["INFO_CREATING_FLEX_HOME"]="Creating Apache Flex home";
		content["INFO_CREATING_TEMP_DIR"]="Creating temporary directory";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_MAC"]="Downloading Adobe AIR Runtime Kit for Mac from: ";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_WINDOWS"]="Downloading Adobe AIR Runtime Kit for Windows from: ";
		content["INFO_DOWNLOADING_FLEX_SDK"]="Downloading Apache Flex SDK from: ";
		content["INFO_DOWNLOADED"]="Download complete ";
		content["INFO_ENTER_VALID_FLEX_SDK_PATH"]="Please enter valid directory path for the Flex SDK";
		content["INFO_FINISHED_UNTARING"]="Finished untaring: ";
		content["INFO_FINISHED_UNZIPPING"]="Finished unzipping: ";
		content["INFO_INSTALLATION_COMPLETE"]="Installation complete.";
		content["INFO_INSTALLING_CONFIG_FILES"]="Installing frameworks configuration files configured for use with an IDE";
		content["INFO_INSTALLING_PLAYERGLOBAL_SWC"]="Installing Adobe Flash Player playerglobal.swc from: ";
		content["INFO_INVOKED_GUI_MODE"]="invoked in GUI mode";
		content["INFO_SELECT_DIRECTORY"]="Select a directory";
		content["INFO_UNZIPPING"]="Unzipping: ";
		content["SELECT_PATH_PROMPT"]="Enter Flex SDK path or browse to select a path";
		content["STEP_CREATE_DIRECTORIES"]="Create Directories";
		content["STEP_DOWNLOAD_AIR_RUNTIME_KIT"]="Download Adobe AIR Runtime Kit";
		content["STEP_DOWNLOAD_FLASHPLAYER_SWC"]="Download Flash Player swc";
		content["STEP_DOWNLOAD_FLEX_SDK"]="Download Apache Flex SDK";
		content["STEP_INSTALL_CONFIG_FILES"]="Install Framework Configuration Files";
		content["STEP_UNZIP_AIR_RUNTIME_KIT"]="Unzip Adobe AIR Runtime Kit";
		content["STEP_UNZIP_FLEX_SDK"]="Unzip Apache Flex SDK";
		
		_resourceManager.addResourceBundle(resource);
	}
	
	//----------------------------------
	// install_en_GB
	//----------------------------------
	
	private function install_en_GB():void
	{
		var locale:String = EN_GB;
		var resource:ResourceBundle = new ResourceBundle(locale, ViewResourceConstants.BUNDLE_NAME);
		
		var content:Object = resource.content;
		content["BTN_LABEL_BROWSE"]="BROWSE";
		content["BTN_LABEL_CLOSE"]="CLOSE";
		content["BTN_LABEL_INSTALL"]="INSTALL";
		content["BTN_LABEL_INSTALL_LOG"]="INSTALL LOG";
		content["ERROR_CONFIG_XML_LOAD"]="Error while trying to load XML configuration file: ";
		content["ERROR_INVALID_AIR_SDK_URL_MAC"]="Adobe AIR SDK URL for Mac invalid in configuration file";
		content["ERROR_INVALID_AIR_SDK_URL_WINDOWS"]="Adobe AIR SDK URL for Windows invalid in configuration file";
		content["ERROR_INVALID_FLASH_PLAYER_SWC_URL"]="Flash Player swc URL invalid in configuration file";
		content["ERROR_INVALID_FLEX_SDK_DIRECTORY"]="Invalid Flex SDK directory selected";
		content["ERROR_INVALID_SDK_URL"]="Apache Flex SDK URL invalid in configuration file";
		content["ERROR_NATIVE_PROCESS_ERROR"]="Native Process error unable to untar Adobe AIR SDK";
		content["ERROR_NATIVE_PROCESS_NOT_SUPPORTED"]="Native Process not supported. Unable to untar Adobe AIR SDK";
		content["ERROR_UNABLE_TO_COPY_FILE"]="Unable to copy file ";
		content["ERROR_UNABLE_TO_CREATE_TEMP_DIRECTORY"]="Unable to create temporary directory";
		content["ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY"]="Unable to clean up temporary installation directories";
		content["ERROR_UNABLE_TO_DOWNLOAD_AIR_SDK"]="Unable to download Adobe AIR Runtime Kit";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLASH_PLAYER_SWC"]="Unable to download Flash Player swc";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLEX_SDK"]="Unable to download Apache Flex SDK";
		content["ERROR_UNABLE_TO_INSTALL_CONFIG_FILES"]="Unable to install configuration files";
		content["ERROR_UNSUPPORTED_OPERATING_SYSTEM"]="Unsupported operating system";
		content["INFO_ABORT_INSTALLATION"]="Aborting Installation";
		content["INFO_APP_INVOKED"]="Invoked in command line mode with the following arguments: ";
		content["INFO_CREATING_FLEX_HOME"]="Creating Apache Flex home";
		content["INFO_CREATING_TEMP_DIR"]="Creating temporary directory";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_MAC"]="Downloading Adobe AIR Runtime Kit for Mac from: ";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_WINDOWS"]="Downloading Adobe AIR Runtime Kit for Windows from: ";
		content["INFO_DOWNLOADING_FLEX_SDK"]="Downloading Apache Flex SDK from: ";
		content["INFO_DOWNLOADED"]="Download complete ";
		content["INFO_ENTER_VALID_FLEX_SDK_PATH"]="Please enter valid directory path for the Flex SDK";
		content["INFO_FINISHED_UNTARING"]="Finished untaring: ";
		content["INFO_FINISHED_UNZIPPING"]="Finished unzipping: ";
		content["INFO_INSTALLATION_COMPLETE"]="Installation complete.";
		content["INFO_INSTALLING_CONFIG_FILES"]="Installing frameworks configuration files configured for use with an IDE";
		content["INFO_INSTALLING_PLAYERGLOBAL_SWC"]="Installing Adobe Flash Player playerglobal.swc from: ";
		content["INFO_INVOKED_GUI_MODE"]="invoked in GUI mode";
		content["INFO_SELECT_DIRECTORY"]="Select a directory";
		content["INFO_UNZIPPING"]="Unzipping: ";
		content["SELECT_PATH_PROMPT"]="Enter Flex SDK path or browse to select a path";
		content["STEP_CREATE_DIRECTORIES"]="Create Directories";
		content["STEP_DOWNLOAD_AIR_RUNTIME_KIT"]="Download Adobe AIR Runtime Kit";
		content["STEP_DOWNLOAD_FLASHPLAYER_SWC"]="Download Flash Player swc";
		content["STEP_DOWNLOAD_FLEX_SDK"]="Download Apache Flex SDK";
		content["STEP_INSTALL_CONFIG_FILES"]="Install Framework Configuration Files";
		content["STEP_UNZIP_AIR_RUNTIME_KIT"]="Unzip Adobe AIR Runtime Kit";
		content["STEP_UNZIP_FLEX_SDK"]="Unzip Apache Flex SDK";
		
		_resourceManager.addResourceBundle(resource);
	}
	
	//----------------------------------
	// install_en_US
	//----------------------------------
	
	private function install_en_US():void
	{
		var locale:String = EN_US;
		var resource:ResourceBundle = new ResourceBundle(locale, ViewResourceConstants.BUNDLE_NAME);
		
		var content:Object = resource.content;
		content["ASK_BLAZEDS"]="Apache Flex can optionally integrate with Adobe BlazeDS. This feature requires flex-messaging-common.jar from the Adobe Flex SDK. The Adobe SDK license agreement for Adobe Flex 4.6 applies to this jar. This license is not compatible with the Apache V2 license. Do you want to install this jar from the Adobe Flex SDK?"
		content["ASK_FONTSWF"]="Apache Flex can optionally integrate with Adobe's embedded font support. This feature requires a few font jars from the Adobe Flex SDK. The Adobe SDK license agreement for Adobe Flex 4.6 applies to these jars. This license is not compatible with the Apache V2 license. Do you want to install these jars from the Adobe Flex SDK?";
		content["ASK_OSMF"]="The Open Source Media Framework (OSMF) used by the video components is licensed under the Mozilla Public License Version 1.1.  Do you want to install the Open Source Media Framework (OSMF)?";
		content["ASK_TLF"]="The Adobe Text Layout Framework (TLF) used by the Spark text components is licensed under the Mozilla Public License Version 1.1.  Do you want to install the Adobe Text Layout Framework (TLF)?";
		content["ASK_APACHE_FLEX"]="The Apache License V2 applies to the Apache Flex SDK.  Do you want to install the Apache Flex SDK?";
		content["ASK_ADOBE_AIR_SDK"]="The Adobe SDK license agreement applies to the Adobe AIR SDK.  Do you want to install the Adobe AIR SDK?";
		content["ASK_ADOBE_FLASH_PLAYER_GLOBAL_SWC"]="The Adobe SDK license agreement applies to the Adobe Flash Player playerglobal.swc.  Do you want to install the Adobe Flash Player playerglobal.swc?";
		content["ASK_SWFOBJECT"]="The MIT License (MIT) applies to the SWFObject utility.  Do you want to install the SWFObject utility?";
		content["BTN_LABEL_ADOBE_LICENSE"]="SHOW ADOBE LICENSE";
		content["BTN_LABEL_BROWSE"]="BROWSE";
		content["BTN_LABEL_CLOSE"]="CLOSE";
		content["BTN_LABEL_INSTALL"]="INSTALL";
		content["BTN_LABEL_INSTALL_LOG"]="INSTALL LOG";
		content["BTN_LABEL_MPL_LICENSE"]="SHOW MPL LICENSE";
		content["BTN_LABEL_NEXT"]="NEXT";
		content["BTN_DISCLAIMER"]="Disclaimer";
		content["BTN_LABEL_OPEN_APACHE_FLEX_FOLDER"]="OPEN APACHE FLEX FOLDER";
		content["ERROR_CONFIG_XML_LOAD"]="Error while trying to load XML configuration file: ";
		content["ERROR_DIR_NOT_EMPTY"]="The selected directory is not empty";
		content["ERROR_INVALID_AIR_SDK_URL_MAC"]="Adobe AIR SDK URL for Mac invalid in configuration file";
		content["ERROR_INVALID_AIR_SDK_URL_WINDOWS"]="Adobe AIR SDK URL for Windows invalid in configuration file";
		content["ERROR_INVALID_FLASH_PLAYER_SWC_URL"]="Flash Player swc URL invalid in configuration file";
		content["ERROR_INVALID_FLEX_SDK_DIRECTORY"]="Invalid Flex SDK directory selected";
		content["ERROR_INVALID_SDK_URL"]="Apache Flex SDK URL invalid in configuration file";
		content["ERROR_MIRROR_FETCH"]="Error while trying to fetch a mirror for downloading the Apache Flex SDK binaries: ";
		content["ERROR_NATIVE_PROCESS_ERROR"]="Native Process error unable to untar Adobe AIR SDK";
		content["ERROR_NATIVE_PROCESS_NOT_SUPPORTED"]="Native Process not supported. Unable to untar Adobe AIR SDK";
		content["ERROR_UNABLE_TO_COPY_FILE"]="Unable to copy file ";
		content["ERROR_UNABLE_TO_CREATE_TEMP_DIRECTORY"]="Unable to create temporary directory";
		content["ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY"]="Unable to clean up temporary installation directories";
		content["ERROR_UNABLE_TO_DOWNLOAD_AIR_SDK"]="Unable to download Adobe AIR Runtime Kit";
		content["ERROR_UNABLE_TO_DOWNLOAD_FILE"]="Unable to download {0}";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLASH_PLAYER_SWC"]="Unable to download Flash Player swc";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLEX_SDK"]="Unable to download Apache Flex SDK";
		content["ERROR_UNABLE_TO_INSTALL_CONFIG_FILES"]="Unable to install configuration files";
		content["ERROR_UNABLE_TO_UNZIP"]="Unable to unzip file: ";
		content["ERROR_UNABLE_TO_DOWNLOAD_SWF_OBJECT"]="Unable to download SWFObject";
		content["ERROR_UNSUPPORTED_OPERATING_SYSTEM"]="Unsupported operating system";
		content["ERROR_VERIFY_FLEX_SDK"]="The Apache Flex SDK MD5 Signature of the downloaded files does not match the reference value. The file is invalid, installation is aborted.";
		content["FETCH_GEO_IP"]="Trying to fetch the user's country code from the GeoIP service...";
		content["FETCH_GEO_IP_DONE"]="Fetched the user's country code from the GeoIP service.";
		content["FETCH_GEO_IP_ERROR"]="An error occurred while fetching the user's country code from the GeoIP service.";
		content["FETCH_MIRROR_CGI"]="Trying to fetch the SDK download mirror URL from the CGI...";
		content["FETCH_MIRROR_CGI_DONE"]="Fetched the SDK download mirror URL from the CGI.";
		content["FETCH_MIRROR_CGI_ERROR"]="Could not fetch the SDK download mirror URL from the CGI. Going to try the GeoIP route.";
		content["FETCH_MIRROR_LIST"]="Trying to fetch the mirror list from Apache.org...";
		content["FETCH_MIRROR_LIST_DONE"]="Fetched the mirror list from Apache.org.";
		content["FETCH_MIRROR_LIST_PARSED"]="Parsed the mirror list using the country code and got this domain: ";
		content["INFO_ABORT_INSTALLATION"]="Installation aborted";
		content["INFO_APP_INVOKED"]="Invoked in command line mode with the following arguments: ";
		content["INFO_CREATING_FLEX_HOME"]="Creating Apache Flex home";
		content["INFO_CREATING_TEMP_DIR"]="Creating temporary directory";
		content["INFO_CURRENT_LANGUAGE"]="Select Language";
		content["INFO_DOWNLOADING_ADOBE_FLEX_SDK"]="Downloading Adobe Flex SDK from: ";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_MAC"]="Downloading Adobe AIR Runtime Kit for Mac from: ";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_WINDOWS"]="Downloading Adobe AIR Runtime Kit for Windows from: ";
		content["INFO_DOWNLOADING_FILE_FROM"]="Downloading {0} from: {1}";
		content["INFO_DOWNLOADING_FLEX_SDK"]="Downloading Apache Flex SDK from: ";
		content["INFO_DOWNLOADED"]="Download complete ";
		content["INFO_ENTER_VALID_FLEX_SDK_PATH"]="Please enter valid directory path for the Flex SDK";
		content["INFO_FINISHED_UNTARING"]="Finished untaring: ";
		content["INFO_FINISHED_UNZIPPING"]="Finished uncompressing: ";
		content["INFO_INSTALLATION_COMPLETE"]="Installation complete";
		content["INFO_INSTALLING"]="Installing...";
		content["INFO_INSTALLING_CONFIG_FILES"]="Installing frameworks configuration files configured for use with an IDE";
		content["INFO_INSTALLING_PLAYERGLOBAL_SWC"]="Installing Adobe Flash Player playerglobal.swc from: ";
		content["INFO_INVOKED_GUI_MODE"]="invoked in GUI mode";
		content["INFO_LICENSE_AGREEMENTS"]="License Agreements";
		content["INFO_NEED_TO_READ_AND_AGREE_TO_LICENSE"]="This installer will download software from multiple sites with various license agreements. Please click on each item on the left, read the license and confirm that you agree to the terms of each license.";
		content["INFO_SELECT_DIRECTORY"]="Select the directory where you want to install the Flex SDK";
		content["INFO_SELECT_DIRECTORY_INSTALL"]="Select installation directory";
		content["INFO_UNZIPPING"]="Uncompressing: ";
		content["INFO_VERIFY_FLEX_SDK_DONE"]="The Apache Flex SDK MD5 Signature of the downloaded files matches the reference. The file is valid.";
		content["INFO_WINDOW_TITLE"]="Install Apache Flex SDK for use with Adobe Flash Builder";
		content["INSTALL_AGREE"] = "I Agree, Install"
		content["INSTALL_AGREE_ALL"] = "I agree to all options and licenses, Install"
		content["INSTALL_DISAGREE"] = "I Disagree, Don't Install"
		content["SELECT_PATH_PROMPT"]="Where do you want to install the Apache Flex SDK?";
		content["STEP_CREATE_DIRECTORIES"]="Create Directories";
		content["STEP_REQUIRED_INSTALL_APACHE_FLEX_SDK"]="Apache Flex SDK (Required)";
		content["STEP_REQUIRED_INSTALL_ADOBE_AIR_SDK"]="Adobe AIR SDK (Required)";
		content["STEP_REQUIRED_INSTALL_FLASH_PLAYER_GLOBAL_SWC"]="Adobe Flash Player playerglobal.swc (Required)";
		content["STEP_REQUIRED_INSTALL_SWFOBJECT"]="SWFObject (Required)";
		content["STEP_INSTALL_CONFIG_FILES"]="Install Framework Configuration Files";
		content["STEP_REQUIRED_INSTALL_OSMF"]="OSMF (Required)";
		content["STEP_REQUIRED_INSTALL_TLF"]="Adobe Text Layout Framework (Required)";
		content["STEP_OPTIONAL_INSTALL_BLAZEDS"]="BlazeDS (Optional)";
		content["STEP_OPTIONAL_INSTALL_FONTSWF"]="Adobe Embedded Font Libraries and Utilities (Optional)";
		content["STEP_REQUIRED_UNZIP_AIR_RUNTIME_KIT"]="Uncompress Adobe AIR Runtime Kit";
		content["STEP_UNZIP_AIR_RUNTIME_KIT"]="Uncompress Adobe AIR Runtime Kit";
		content["STEP_UNZIP_FLEX_SDK"]="Uncompress Apache Flex SDK";
		content["STEP_VERIFY_FLEX_SDK"]="Verifying Apache Flex SDK MD5 Signature";
		content["LICENSE_APACHE_V2"]="Apache V2 License";
		content["LICENSE_URL_APACHE_V2"]="http://www.apache.org/licenses/LICENSE-2.0.html";
		content["LICENSE_ADOBE_SDK"]="Adobe Flex SDK License";
		content["LICENSE_URL_ADOBE_SDK"]="http://www.adobe.com/products/eulas/pdfs/adobe_flex_software_development_kit-combined-20110916_0930.pdf";
		content["LICENSE_ADOBE_AIR_SDK"]="Adobe AIR SDK License";
		content["LICENSE_URL_ADOBE_AIR_SDK"]="http://www.adobe.com/products/air/sdk-eula.html";
		content["LICENSE_SWFOBJECT"]="MIT License";
		content["LICENSE_URL_SWFOBJECT"]="http://opensource.org/licenses/mit-license.php";
		content["LICENSE_OSMF"]="Mozilla Public License Version 1.1";
		content["LICENSE_URL_OSMF"]="http://www.mozilla.org/MPL/";
		content["LICENSE_TLF"]="Mozilla Public License Version 1.1";
		content["LICENSE_URL_TLF"]="http://www.mozilla.org/MPL/";
		content["LICENSE_FONTSWF"]="Adobe Flex SDK License";
		content["LICENSE_URL_FONTSWF"]="http://www.adobe.com/products/eulas/pdfs/adobe_flex_software_development_kit-combined-20110916_0930.pdf";
		content["LICENSE_BLAZEDS"]="Adobe Flex SDK License";
		content["LICENSE_URL_BLAZEDS"]="http://www.adobe.com/products/eulas/pdfs/adobe_flex_software_development_kit-combined-20110916_0930.pdf";
		
		_resourceManager.addResourceBundle(resource);
	}

	//----------------------------------
	// install_es_ES
	//----------------------------------
	
	private function install_es_ES():void
	{
		var locale:String = ES_ES;
		var resource:ResourceBundle = new ResourceBundle(locale, ViewResourceConstants.BUNDLE_NAME);
		
		var content:Object = resource.content;
		content["ASK_BLAZEDS"]="Apache Flex puede integrarse de manera opcional con Adobe BlazeDS. Esta característica necesita flex-messaging-common.jar del SDK de Adobe Flex. Este archivo se ofrecen bajo los términos de la licencia de Adobe SDK para Adobe Flex 4.6. Esta licencia no es compatibla con la licencia Apache V2. ¿Quieres instalar este archivo desde el SDK de Adobe Flex?";
		content["ASK_FONTSWF"]="Apache Flex puede integrarse de manera opcional con el soporte para fuentes embebidas de Adobe. Esta característica necesita algunos ficheros de fuentes del SDK de Adobe Flex. Estos archivos se ofrecen bajo los términos de la licencia de Adobe SDK para Adobe Flex 4.6. Esta licencia no es compatibla con la licencia Apache V2. ¿Quieres instalar estos archivos desde el SDK de Adobe Flex?";
		content["ASK_OSMF"]="Open Source Media Framework (OSMF), utilizado en los componentes de video, se ofrece bajo los términos de la Mozilla Public License Version 1.1. ¿Quieres instalar Open Source Media Framework (OSMF)?";
		content["ASK_TLF"]="Adobe Text Layout Framework (TLF), utilizados por los compoentes de texto de Spark se ofrece bajo los términos de la Mozilla Public License Version 1.1. ¿Quieres instalar Adobe Text Layout Framework (TLF)?";
		content["ASK_APACHE_FLEX"]="Apache Flex SDK se ofrece bajo los términos de la licencia Apache License V2. ¿Quieres instalar Apache Flex SDK?";
		content["ASK_ADOBE_AIR_SDK"]="Adobe AIR SDK se ofrece bajo los térmios de la licencia de Adobe SDK. ¿Quieres instalar Adobe AIR SDK?";
		content["ASK_ADOBE_FLASH_PLAYER_GLOBAL_SWC"]="Adobe Flash Player playerglobal.swc se ofrece bajo los términos de la licencia de Adobe SDK. ¿Quieres instalar Adobe Flash Player playerglobal.swc?";
		content["ASK_SWFOBJECT"]="SWFObject se ofrece bajo licencia MIT (MIT). ¿Quieres instalar SWFObject?";
		content["BTN_LABEL_ADOBE_LICENSE"]="VER LICENCIA DE ADOBE";
		content["BTN_LABEL_BROWSE"]="EXAMINAR";
		content["BTN_LABEL_CLOSE"]="CERRAR";
		content["BTN_LABEL_INSTALL"]="INSTALAR";
		content["BTN_LABEL_INSTALL_LOG"]="DETALLES DE INSTALACIÓN";
		content["BTN_LABEL_MPL_LICENSE"]="VER LICENCIA MPL";
		content["BTN_LABEL_NEXT"]="SIGUIENTE";
		content["BTN_DISCLAIMER"]="Aviso legal";
		content["BTN_LABEL_OPEN_APACHE_FLEX_FOLDER"]="MOSTRAR UBICACIÓN DE APACHE FLEX";
		content["ERROR_CONFIG_XML_LOAD"]="Se produjo un error al intentar leer el archivo de configuración: ";
		content["ERROR_DIR_NOT_EMPTY"]="El directorio seleccionado no está vacío";
		content["ERROR_INVALID_AIR_SDK_URL_MAC"]="URL del SDK de Adobe AIR para Mac incorrecta en el archivo de configuración";
		content["ERROR_INVALID_AIR_SDK_URL_WINDOWS"]="URL del SDK de Adobe AIR para Windows incorrecta en el archivo de configuración";
		content["ERROR_INVALID_FLASH_PLAYER_SWC_URL"]="URL del swc de Flash Player incorrecta en el archivo de configuración";
		content["ERROR_INVALID_FLEX_SDK_DIRECTORY"]="El directorio seleccionado para el SDK de Apache Flex no es válido";
		content["ERROR_INVALID_SDK_URL"]="URL del SDK Apache Flex incorrecta en el archivo de configuración";
		content["ERROR_MIRROR_FETCH"]="Error al intentar obtener un enlace para la descarga de los archivos binarios del SDK de Apache Flex: ";
		content["ERROR_NATIVE_PROCESS_ERROR"]="Error en Proceso Nativo. No se pudo descomprimir Adobe AIR SDK";
		content["ERROR_NATIVE_PROCESS_NOT_SUPPORTED"]="Proceso Nativo no soportado. No se pudo descomprimir Adobe AIR SDK";
		content["ERROR_UNABLE_TO_COPY_FILE"]="No se pudo copiar el archivo ";
		content["ERROR_UNABLE_TO_CREATE_TEMP_DIRECTORY"]="No se pudo crear el directorio temporal";
		content["ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY"]="No se pudo eliminar los directorios temporales de la instalación";
		content["ERROR_UNABLE_TO_DOWNLOAD_AIR_SDK"]="No se pudo descargar Adobe AIR Runtime Kit";
		content["ERROR_UNABLE_TO_DOWNLOAD_FILE"]="No se pudo descargar {0}";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLASH_PLAYER_SWC"]="No se pudo descargar Flash Player swc";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLEX_SDK"]="No se pudo descargar el SDK de Apache Flex";
		content["ERROR_UNABLE_TO_INSTALL_CONFIG_FILES"]="No se pudo instalar los ficheros de configuración";
		content["ERROR_UNABLE_TO_UNZIP"]="No se pudo descomprimir el archivo: ";
		content["ERROR_UNABLE_TO_DOWNLOAD_SWF_OBJECT"]="No se pudo descargar SWFObject";
		content["ERROR_UNSUPPORTED_OPERATING_SYSTEM"]="Sistema Operativo no soportado";
		content["ERROR_VERIFY_FLEX_SDK"]="La firma MD5 de Apache Flex SDK en los archivos descargados no coincide con la original. El archivo es inválido. Instalación cancelada.";
		content["FETCH_GEO_IP"]="Intentando obtener el código de país del usuario desde el servicio GeoIP...";
		content["FETCH_GEO_IP_DONE"]="Se obtuvo el código de país del usuario desde el servicio GeoIP.";
		content["FETCH_GEO_IP_ERROR"]="Ocurrió un error al intentar obtener el código de país del usuario del servicio GeoIP.";
		content["FETCH_MIRROR_CGI"]="Intentando obtener la url de descargas del SDK desde el CGI...";
		content["FETCH_MIRROR_CGI_DONE"]="Se obtuvo la url de descargas del SDK desde el CGI.";
		content["FETCH_MIRROR_CGI_ERROR"]="No se pudo obtener la url de descarga del SDK del CGI. Intentando la ruta GeoIP.";
		content["FETCH_MIRROR_LIST"]="Intenando obtener la lista de réplicas desde Apache.org...";
		content["FETCH_MIRROR_LIST_DONE"]="Lista de réplicas obtenida de Apache.org.";
		content["FETCH_MIRROR_LIST_PARSED"]="Lista de réplicas parseada utilizando el código de país. Se obtuvo el siguiente dominio: ";
		content["INFO_ABORT_INSTALLATION"]="Instalación cancelada";
		content["INFO_APP_INVOKED"]="Ejecutado en modo línea de comando con los siguientes argumentos: ";
		content["INFO_CREATING_FLEX_HOME"]="Creando directorio para Apache Flex";
		content["INFO_CREATING_TEMP_DIR"]="Creando directorio temporal";
		content["INFO_CURRENT_LANGUAGE"]="Elige un idioma";
		content["INFO_DOWNLOADING_ADOBE_FLEX_SDK"]="Descargando Adobe Flex SDK desde: ";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_MAC"]="Descargando Adobe AIR Runtime Kit para Mac desde: ";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_WINDOWS"]="Descargando Adobe AIR Runtime Kit para Windows desde: ";
		content["INFO_DOWNLOADING_FILE_FROM"]="Descargando {0} desde: {1}";
		content["INFO_DOWNLOADING_FLEX_SDK"]="Descargando SDK de Apache Flex desde: ";
		content["INFO_DOWNLOADED"]="Descarga finalizada ";
		content["INFO_ENTER_VALID_FLEX_SDK_PATH"]="Introduce una ruta válida para el SDK de Flex, por favor.";
		content["INFO_FINISHED_UNTARING"]="Descompresión finalizada: ";
		content["INFO_FINISHED_UNZIPPING"]="Descompresión finalizada: ";
		content["INFO_INSTALLATION_COMPLETE"]="Instalación finalizada";
		content["INFO_INSTALLING"]="Instalando...";
		content["INFO_INSTALLING_CONFIG_FILES"]="Instalando archivos de configuración para la interacción con IDEs";
		content["INFO_INSTALLING_PLAYERGLOBAL_SWC"]="Instalando Adobe Flash Player playerglobal.swc desde: ";
		content["INFO_INVOKED_GUI_MODE"]="ejecutado en modo gráfico";
		content["INFO_LICENSE_AGREEMENTS"]="Términos de la licencia";
		content["INFO_NEED_TO_READ_AND_AGREE_TO_LICENSE"]="Este instalador necesita descargar software de múltiples ubicaciones y con diferentes acuerdos de licencia. Por favor, selecciona cada uno de los elementos de la izquierda, lee los términos de la licencia y confirma que estás de acuerdo con ellos.";
		content["INFO_SELECT_DIRECTORY"]="Selecciona el directorio donde quieres instalar Flex SDK";
		content["INFO_SELECT_DIRECTORY_INSTALL"]="Selecciona el directorio de instalación";
		content["INFO_UNZIPPING"]="Descomprimiendo: ";
		content["INFO_VERIFY_FLEX_SDK_DONE"]="La firma MD5 de Apache Flex SDK en los archivos descargados coincide con la original. El archivo es válido.";
		content["INFO_WINDOW_TITLE"]="Instalar Apache Flex SDK para su uso con Adobe Flash Builder";
		content["INSTALL_AGREE"] = "Acepto, Instalar"
		content["INSTALL_AGREE_ALL"] = "Acepto todas las opciones y licencias, Instalar"
		content["INSTALL_DISAGREE"] = "No estoy de acuerdo, Cancelar"
		content["SELECT_PATH_PROMPT"]="¿Dónde quieres instalar el SDK de Apache Flex?";
		content["STEP_CREATE_DIRECTORIES"]="Crear directorios";
		content["STEP_REQUIRED_INSTALL_APACHE_FLEX_SDK"]="Apache Flex SDK (Necesario)";
		content["STEP_REQUIRED_INSTALL_ADOBE_AIR_SDK"]="Adobe AIR SDK (Necesario)";
		content["STEP_REQUIRED_INSTALL_FLASH_PLAYER_GLOBAL_SWC"]="Adobe Flash Player playerglobal.swc (Necesario)";
		content["STEP_REQUIRED_INSTALL_SWFOBJECT"]="SWFObject (Necesario)";
		content["STEP_INSTALL_CONFIG_FILES"]="Instalar ficheros de coniguración";
		content["STEP_REQUIRED_INSTALL_OSMF"]="OSMF (Necesario)";
		content["STEP_REQUIRED_INSTALL_TLF"]="Adobe Text Layout Framework (Necesario)";
		content["STEP_OPTIONAL_INSTALL_BLAZEDS"]="BlazeDS (Opcional)";
		content["STEP_OPTIONAL_INSTALL_FONTSWF"]="Adobe Embedded Font Libraries and Utilities (Opcional)";
		content["STEP_REQUIRED_UNZIP_AIR_RUNTIME_KIT"]="Descomprimir Adobe AIR Runtime Kit";
		content["STEP_UNZIP_AIR_RUNTIME_KIT"]="Descomprimir Adobe AIR Runtime Kit";
		content["STEP_UNZIP_FLEX_SDK"]="Descomprimir Apache Flex SDK";
		content["STEP_VERIFY_FLEX_SDK"]="Verificando MD5 de Apache Flex SDK";
		content["LICENSE_APACHE_V2"]="Licencia de Apache V2";
		content["LICENSE_ADOBE_SDK"]="Licencia de Adobe Flex SDK";
		content["LICENSE_ADOBE_AIR_SDK"]="Licencia de Adobe AIR SDK";
		content["LICENSE_SWFOBJECT"]="Licencia MIT";
		content["LICENSE_OSMF"]="Licencia Pública de Mozilla Versión 1.1";
		content["LICENSE_TLF"]="Licencia Pública de Mozilla Versión 1.1";
		content["LICENSE_FONTSWF"]="Licencia de Adobe Flex SDK";
		content["LICENSE_BLAZEDS"]="Licencia de Adobe Flex SDK";
		
		_resourceManager.addResourceBundle(resource);
	}
	
	//----------------------------------
	// install_nl_NL
	//----------------------------------
	
	private function install_nl_NL():void
	{
		var locale:String = NL_NL;
		var resource:ResourceBundle = new ResourceBundle(locale, ViewResourceConstants.BUNDLE_NAME);
		
		var content:Object = resource.content;
		content["BTN_LABEL_BROWSE"]="BLADER";
		content["BTN_LABEL_CLOSE"]="SLUITEN";
		content["BTN_LABEL_INSTALL"]="INSTALLEREN";
		content["BTN_LABEL_INSTALL_LOG"]="TOON LOG";
		content["BTN_LABEL_MPL_LICENSE"]="TOON MPL LICENSE";
		content["BTN_LABEL_NEXT"]="VERDER";
		content["ERROR_CONFIG_XML_LOAD"]="Fout tijdens het laden van het XML configuratie bestand: ";
		content["ERROR_INVALID_AIR_SDK_URL_MAC"]="Adobe AIR SDK URL voor Mac is ongeldig in configuratie bestand";
		content["ERROR_INVALID_AIR_SDK_URL_WINDOWS"]="Adobe AIR SDK URL voor Windows is ongeldig in configuratie bestand";
		content["ERROR_INVALID_FLASH_PLAYER_SWC_URL"]="Flash Player swc URL is ongeldig in configuratie bestand";
		content["ERROR_INVALID_FLEX_SDK_DIRECTORY"]="Invalid Flex SDK directory selected";
		content["ERROR_INVALID_SDK_URL"]="Apache Flex SDK URL ongeldig in configuratie bestand";
		content["ERROR_NATIVE_PROCESS_ERROR"]="Native Process fout kan Adobe AIR SDK niet uitpakken";
		content["ERROR_NATIVE_PROCESS_NOT_SUPPORTED"]="Native Process niet ondersteund. Kan Adobe AIR SDK niet uitpakken";
		content["ERROR_UNABLE_TO_COPY_FILE"]="Kan bestand niet kopieeren ";
		content["ERROR_UNABLE_TO_CREATE_TEMP_DIRECTORY"]="Unable to create temporary directory";
		content["ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY"]="Opruimen van tijdelijke installatie bestanden mislukt";
		content["ERROR_UNABLE_TO_DOWNLOAD_AIR_SDK"]="Downloaden Adobe AIR Runtime Kit mislukt";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLASH_PLAYER_SWC"]="Downloaden Flash Player swc mislukt";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLEX_SDK"]="Downloaden Apache Flex SDK mislukt";
		content["ERROR_UNABLE_TO_INSTALL_CONFIG_FILES"]="Unable to install configuration files";
		content["ERROR_UNSUPPORTED_OPERATING_SYSTEM"]="Besturingsysteem is niet ondersteund";
		content["INFO_ABORT_INSTALLATION"]="Installatie wordt afgebroken";
		content["INFO_APP_INVOKED"]="Opgestart in command line modus met de volgende argumenten: ";
		content["INFO_CREATING_FLEX_HOME"]="Maakt flex home aan";
		content["INFO_CREATING_TEMP_DIR"]="Maakt tijdelijke map aan";
		content["INFO_CURRENT_LANGUAGE"]="Kies een taal";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_MAC"]="Adobe AIR Runtime Kit voor Mac wordt gedownload van: ";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_WINDOWS"]="Adobe AIR Runtime Kit voor Windows wordt gedownload van: ";
		content["INFO_DOWNLOADING_FLEX_SDK"]="Apache Flex SDK wordt gedownload van: ";
		content["INFO_DOWNLOADED"]="Gedownload ";
		content["INFO_ENTER_VALID_FLEX_SDK_PATH"]="Geef een geldig Flex SDK pad in";
		content["INFO_FINISHED_UNTARING"]="Klaar met uitpakken:";
		content["INFO_FINISHED_UNZIPPING"]="Klaar met uitpakken: ";
		content["INFO_INSTALLATION_COMPLETE"]="Installatie gereed.";
		content["INFO_INSTALLING_CONFIG_FILES"]="Framework configuratie bestanden voor gebruik met IDE worden geinstalleerd";
		content["INFO_INSTALLING_PLAYERGLOBAL_SWC"]="Adobe Flash Player playerglobal.swc wordt geinstalleerd van:";
		content["INFO_INVOKED_GUI_MODE"]="Opgestart in visuele modus";
		content["INFO_LICENSE_AGREEMENTS"]="Licentie Overeenkomsten";
		content["INFO_SELECT_DIRECTORY"]="Kies een map";
		content["INFO_SELECT_DIRECTORY_INSTALL"]="Kies de installatie map";
		content["INFO_UNZIPPING"]="Uitpakken: ";
		content["INFO_WINDOW_TITLE"]="Installeer Apache Flex SDK voor gebruik in Adobe Flash Builder";
		content["SELECT_PATH_PROMPT"]="Geef Flex SDK pad in of blader naar het pad";
		content["STEP_CREATE_DIRECTORIES"]="Mappen aanmaken";
		content["STEP_DOWNLOAD_AIR_RUNTIME_KIT"]="Adobe AIR Runtime Kit Downloaden";
		content["STEP_DOWNLOAD_FLASHPLAYER_SWC"]="Flash Player swc Downloaden";
		content["STEP_DOWNLOAD_FLEX_SDK"]="Apache Flex SDK Downloaden";
		content["STEP_INSTALL_CONFIG_FILES"]="Framework Configuratie Bestanden Installeren";
		content["STEP_UNZIP_AIR_RUNTIME_KIT"]="Adobe AIR Runtime Kit Uitpakken";
		content["STEP_UNZIP_FLEX_SDK"]="Apache Flex SDK uitpakken";
		
		_resourceManager.addResourceBundle(resource);
	}
	
	//----------------------------------
	// install_pt_BR
	//----------------------------------
	
	private function install_pt_BR():void
	{
		var locale:String = PT_BR;
		var resource:ResourceBundle = new ResourceBundle(locale, ViewResourceConstants.BUNDLE_NAME);
		
		var content:Object = resource.content;
		content["ASK_BLAZEDS"]="Apache Flex pode, opcionalmente, integrar-se com Adobe BlazeDS. Esta integração requer flex-messaging-common.jar do Adobe Flex SDK, que esta sob o contrato de licença do Adobe SDK para Adobe Flex 4.6. Esta licença não é compatível com a licença Apache V2. Você quer instalar este jar a partir do Adobe Flex SDK?";
		content["ASK_FONTSWF"]="Apache Flex pode, opcionalmente, integrar-se com o suporte de fontes embutidas da Adobe. Este recurso requer alguns jars do Adobe Flex SDK, que estão sob o contrato de licença do Adobe Flex 4.6. Esta licença não é compatível com a licença Apache V2. Você quer instalar estes jars a partir do Adobe Flex SDK?";
		content["ASK_OSMF"]="O Open Source Media Framework (OSMF) utilizado pelos componentes de video está sob a licença Mozilla Public License Version 1.1.";
		content["ASK_TLF"]="O Adobe Text Layout Framework (TLF) utilizado pelos componentes de texto Spark está sob a licença Mozilla Public License Version 1.1.";
		content["BTN_LABEL_ADOBE_LICENSE"]="LICENÇA ADOBE";
		content["BTN_LABEL_BROWSE"]="SELEC.";
		content["BTN_LABEL_CLOSE"]="FECHAR";
		content["BTN_LABEL_INSTALL"]="INSTALAR";
		content["BTN_LABEL_INSTALL_LOG"]="LOG";
		content["BTN_LABEL_MPL_LICENSE"]="LICENÇA MPL";
		content["BTN_LABEL_NEXT"]="PROX.";
		content["BTN_DISCLAIMER"]="Disclaimer";
		content["BTN_LABEL_OPEN_APACHE_FLEX_FOLDER"]="ABRIR DIRETÓRIO APACHE FLEX";	
		content["ERROR_CONFIG_XML_LOAD"]="Erro ao tentar carregar o arquivo XML de configuração: ";
		content["ERROR_DIR_NOT_EMPTY"]="O diretório selecionado não está vazio";
		content["ERROR_INVALID_AIR_SDK_URL_MAC"]="URL inválida no arquivo de configuração para Adobe AIR SDK para Mac";
		content["ERROR_INVALID_AIR_SDK_URL_WINDOWS"]="URL inválida no arquivo de configuração para Adobe AIR SDK para Windows";
		content["ERROR_INVALID_FLASH_PLAYER_SWC_URL"]="URL inválida no arquivo de configuração para o Flash Player swc";
		content["ERROR_INVALID_FLEX_SDK_DIRECTORY"]="Diretório selecionado para Flex SDK inválido";
		content["ERROR_INVALID_SDK_URL"]="URL do Apache Flex SDK inválida no arquivo de configuração";
		content["ERROR_MIRROR_FETCH"]="Erro ao tentar encontrar um local para download do Apache Flex SDK (binário): ";
		content["ERROR_NATIVE_PROCESS_ERROR"]="Erro de processo nativo para descompactar Adobe AIR SDK";
		content["ERROR_NATIVE_PROCESS_NOT_SUPPORTED"]="Processo Nativo não suportado. Não foi possível descompactar Adobe AIR SDK";
		content["ERROR_UNABLE_TO_COPY_FILE"]="Não foi possível copiar o arquivo ";
		content["ERROR_UNABLE_TO_CREATE_TEMP_DIRECTORY"]="Não foi possível criar o diretório temporário";
		content["ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY"]="Não foi possível limpar os diretórios temporários"
		content["ERROR_UNABLE_TO_DOWNLOAD_AIR_SDK"]="Não foi possível efetuar o download do Adobe AIR Runtime Kit";
		content["ERROR_UNABLE_TO_DOWNLOAD_FILE"]="Não foi possível efetuar o download {0}";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLASH_PLAYER_SWC"]="Não foi possível efetuar o download do Flash Player swc";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLEX_SDK"]="Não foi possível efetuar o download do Apache Flex SDK";
		content["ERROR_UNABLE_TO_INSTALL_CONFIG_FILES"]="Não foi possível instalar os arquivos de configuração";
		content["ERROR_UNABLE_TO_UNZIP"]="Não foi possível descompart o arquivo: ";
		content["ERROR_UNABLE_TO_DOWNLOAD_SWF_OBJECT"]="Não foi possível efetuar o download do SWFObject";
		content["ERROR_UNSUPPORTED_OPERATING_SYSTEM"]="Sistema operacional não suportado";
		content["ERROR_VERIFY_FLEX_SDK"]="A assinatura MD5 do download efetuado do Apache Flex SDK não corresponde com o valor de referência. O arquivo é inválido, instalação abortada.";
		content["FETCH_GEO_IP"]="Tentando buscar o código do país do usuário usando o serviço GeoIP ...";
		content["FETCH_GEO_IP_DONE"]="Buscado o código do país do usuário no serviço GeoIP.";
		content["FETCH_GEO_IP_ERROR"]="Ocorreu um erro ao buscar o código de país do usuário no serviço GeoIP.";
		content["FETCH_MIRROR_CGI"]="Tentando buscar o espelhada da URL de download do SDK a partir do CGI ...";
		content["FETCH_MIRROR_CGI_DONE"]="Buscado o espelho da URL de download do SDK a partir do CGI.";
		content["FETCH_MIRROR_CGI_ERROR"]="Não foi possível obter o download do SDK da URL espelho pelo CGI. Vamos tentar a rota GeoIP.";
		content["FETCH_MIRROR_LIST"]="Tentando buscar a lista de espelho da Apache.org...";
		content["FETCH_MIRROR_LIST_DONE"]="Buscar a lista de espelhos de Apache.org";
		content["FETCH_MIRROR_LIST_PARSED"]="Analisada a lista de espelhos usando o código de país e escolhi este domínio: ";
		content["INFO_ABORT_INSTALLATION"]="Instalação abortada";
		content["INFO_APP_INVOKED"]="Chamado em modo de linha de comando com os seguintes argumentos: ";
		content["INFO_CREATING_FLEX_HOME"]="Criando diretório do Apache Flex";
		content["INFO_CREATING_TEMP_DIR"]="Criando diretório temporário";
		content["INFO_CURRENT_LANGUAGE"]="Selecionar linguagem";
		content["INFO_DOWNLOADING_ADOBE_FLEX_SDK"]="Efetuando download do Adobe Flex SDK a partir de: ";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_MAC"]="Efetuando download do Adobe AIR Runtime Kit for Mac a partir de: ";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_WINDOWS"]="Efetuando download do Adobe AIR Runtime Kit for Windows a partir de: ";
		content["INFO_DOWNLOADING_FILE_FROM"]="Efetuando download {0} de: {1}";
		content["INFO_DOWNLOADING_FLEX_SDK"]="Efetuando download do Apache Flex SDK a partir de: ";
		content["INFO_DOWNLOADED"]="Download finalizado ";
		content["INFO_ENTER_VALID_FLEX_SDK_PATH"]="Por favor, informe um diretório válido para instalação do Apache Flex SDK";
		content["INFO_FINISHED_UNTARING"]="Untar finalizado: ";
		content["INFO_FINISHED_UNZIPPING"]="Descompactação finalizada: ";
		content["INFO_INSTALLATION_COMPLETE"]="Instalação finalizada";//
		content["INFO_INSTALLING"]="Instalando...";
		content["INFO_INSTALLING_CONFIG_FILES"]="Instalando arquivos de configuração dos frameworks para utilização com a IDE";
		content["INFO_INSTALLING_PLAYERGLOBAL_SWC"]="Instalando Adobe Flash Player playerglobal.swc a partir de: ";
		content["INFO_INVOKED_GUI_MODE"]="chamado em modo GUI";
		content["INFO_LICENSE_AGREEMENTS"]="Contrato de Licença";
		content["INFO_NEED_TO_READ_AND_AGREE_TO_LICENSE"]="Esses componentes possuem acordos de licença diferentes da licença Apache. Por favor, clique em cada item da esquerda, leia a licença e confirme que você concorda com os termos de cada licença.";
		content["INFO_SELECT_DIRECTORY"]="Selecione o diretório que você deseja instalar o Apache Flex SDK";
		content["INFO_SELECT_DIRECTORY_INSTALL"]="Selecione o diretório de instalação";
		content["INFO_UNZIPPING"]="Descompactando: ";
		content["INFO_VERIFY_FLEX_SDK_DONE"]="A assinatura MD5 do download efetuado do Apache Flex SDK MD5 são válidas com sua referência. O arquivo é válido.";
		content["INFO_WINDOW_TITLE"]="Instalação do Apache Flex SDK para utilização no Adobe Flash Builder";
		content["INSTALL_AGREE"] = "Eu concordo, instalar"
		content["INSTALL_DISAGREE"] = "Não concordo, não instale"
		content["SELECT_PATH_PROMPT"]="Aonde você deseja instalar o Apache Flex SDK?";
		content["STEP_CREATE_DIRECTORIES"]="Criar diretórios";
		content["STEP_DOWNLOAD_AIR_RUNTIME_KIT"]="Download Adobe AIR Runtime Kit";
		content["STEP_DOWNLOAD_FLASHPLAYER_SWC"]="Download Flash Player swc";
		content["STEP_DOWNLOAD_FLEX_SDK"]="Download Apache Flex SDK";
		content["STEP_INSTALL_CONFIG_FILES"]="Instalando arquivos de configuração do Framework";
		content["STEP_INSTALL_SWF_OBJECT"]="Download SWFObject";
		content["STEP_OPTIONAL_INSTALL_BLAZEDS"]="BlazeDS (Opcional)";
		content["STEP_OPTIONAL_INSTALL_FONTSWF"]="Adobe Embedded Font Libraries and Utilities (Opcional)";
		content["STEP_OPTIONAL_INSTALL_OSMF"]="OSMF (Obrigatório)";
		content["STEP_OPTIONAL_INSTALL_TLF"]="Adobe Text Layout Framework (Obrigatório)";
		content["STEP_UNZIP_AIR_RUNTIME_KIT"]="Descompactando Adobe AIR Runtime Kit";
		content["STEP_UNZIP_FLEX_SDK"]="Descompactando Apache Flex SDK";
		content["STEP_VERIFY_FLEX_SDK"]="Verificação da assinatura MD5 - Apache Flex SDK";
		
		_resourceManager.addResourceBundle(resource);
	}
	
}
}

class SE {}