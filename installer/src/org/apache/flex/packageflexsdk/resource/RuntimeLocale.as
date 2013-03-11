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
	public static const FR_FR:String = "fr_FR";
	public static const DE_DE:String = "de_DE";

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
			install_fr_FR();
            install_de_DE();
			
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
		content["BTN_LABEL_BROWSE"]="Α�?ΑΖΗΤΗΣΗ";
		content["BTN_LABEL_CLOSE"]="ΕΞΟΔΟΣ";
		content["BTN_LABEL_INSTALL"]="ΕΓΚΑΤΑΣΤΑΣΗ";
		content["BTN_LABEL_INSTALL_LOG"]="ΑΡΧΕΙΟ ΚΑΤΑΓΡΑΦΗΣ ΕΓΚΑΤΑΣΤΑΣΗΣ";
		content["BTN_LABEL_NEXT"]="ΕΠΟΜΕ�?Ο";
		content["BTN_LABEL_OPEN_APACHE_FLEX_FOLDER"]="Α�?ΟΙΓΜΑ ΦΑΚΕΛΟΥ APACHE FLEX";
		content["ERROR_CONFIG_XML_LOAD"]="Π�?όεκυψε σφάλμα κατά την π�?οσπάθεια φό�?τωσης του α�?χείου �?υθμίσεων XML:";
		content["ERROR_DIR_NOT_EMPTY"]="Ο κατάλογος που επιλέξατε δεν είναι άδειος";
		content["ERROR_INVALID_AIR_SDK_URL_MAC"]="Λανθασμένο Adobe AIR SDK URL για Mac στο α�?χείο �?υθμίσεων";
		content["ERROR_INVALID_AIR_SDK_URL_WINDOWS"]="Λανθασμένο Adobe AIR SDK URL για Windows στο α�?χείο �?υθμίσεων";
		content["ERROR_INVALID_FLASH_PLAYER_SWC_URL"]="Λανθασμένο Flash Player swc URL στο α�?χείο �?υθμίσεων";
		content["ERROR_INVALID_FLEX_SDK_DIRECTORY"]="Έχετε επιλέξει μη έγκυ�?ο κατάλογο για το Flex SDK ";
		content["ERROR_INVALID_SDK_URL"]="Λανθασμένο Apache Flex SDK URL στο α�?χείο �?υθμίσεων.";
		content["ERROR_NATIVE_PROCESS_ERROR"]="Σφάλμα κατά την εκτέλεση Native Process.  Δεν είναι δυνατή η αποσυμπίεση (untar) του Adobe AIR SDK";
		content["ERROR_NATIVE_PROCESS_NOT_SUPPORTED"]="Δεν υπά�?χει υποστή�?ιξη Native Process. Δεν είναι δυνατή η αποσυμπίεση(untar)του Adobe AIR SDK";
		content["ERROR_UNABLE_TO_COPY_FILE"]="Δεν είναι δυνατή η αντιγ�?αφή του α�?χείου ";
		content["ERROR_UNABLE_TO_CREATE_TEMP_DIRECTORY"]="Δεν είναι δυνατή η δημιου�?γία π�?οσω�?ινο�? καταλόγου";
		content["ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY"]="Δεν είναι δυνατή η εκκαθά�?ιση των π�?οσω�?ινών καταλόγων εγκατάστασης";
		content["ERROR_UNABLE_TO_DOWNLOAD_AIR_SDK"]="Δεν είναι δυνατή η λήψη του Adobe AIR Runtime Kit";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLASH_PLAYER_SWC"]="Δεν είναι δυνατή η λήψη του Flash Player swc";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLEX_SDK"]="Δεν είναι δυνατή η λήψη του Apache Flex SDK";
		content["ERROR_UNABLE_TO_INSTALL_CONFIG_FILES"]="Δεν είναι δυνατή η εγκατάσταση των α�?χείων �?υθμίσεων";
		content["ERROR_UNSUPPORTED_OPERATING_SYSTEM"]="Δεν υποστη�?ίζεται το λειτου�?γικό σ�?στημα";
		content["INFO_ABORT_INSTALLATION"]="Η εγκατάσταση ματαιώθηκε";
		content["INFO_APP_INVOKED"]="Κλήση με λειτου�?γία γ�?αμμής εντολών με τα ακόλουθα ο�?ίσματα:";
		content["INFO_CREATING_FLEX_HOME"]="Δημιου�?γία α�?χικο�? καταλόγου για το Apache Flex";
		content["INFO_CREATING_TEMP_DIR"]="Δημιου�?γία π�?οσω�?ινο�? καταλόγου";
		content["INFO_CURRENT_LANGUAGE"]="Επιλέξτε Γλώσσα";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_MAC"]="Γίνεται λήψη του Adobe AIR Runtime Kit για Mac από:";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_WINDOWS"]="Γίνεται λήψη του Adobe AIR Runtime Kit για Windows από:";
		content["INFO_DOWNLOADING_FLEX_SDK"]="Γίνεται λήψη του Apache Flex SDK από:";
		content["INFO_DOWNLOADED"]="Η λήψη ολοκλη�?ώθηκε";
		content["INFO_ENTER_VALID_FLEX_SDK_PATH"]="Πα�?ακαλώ εισάγετε μια έγκυ�?η διαδ�?ομή καταλόγου για το Flex SDK";
		content["INFO_FINISHED_UNTARING"]="Η αποσυμπίεση τελείωσε:";
		content["INFO_FINISHED_UNZIPPING"]="Η αποσυμπίεση τελείωσε:";
		content["INFO_INSTALLATION_COMPLETE"]="Η εγκατάσταση ολοκλη�?ώθηκε.";
		content["INFO_INSTALLING"]="Εγκατάσταση...";
		content["INFO_INSTALLING_CONFIG_FILES"]="Γίνεται εγκατάσταση των α�?χείων �?υθμίσεων του framework που έχουν �?υθμιστεί για χ�?ήση με IDE";
		content["INFO_INSTALLING_PLAYERGLOBAL_SWC"]="Γίνεται εγκατάσταση του Adobe Flash Player playerglobal.swc από:";
		content["INFO_INVOKED_GUI_MODE"]="Κλήση με λειτου�?γία γ�?αφικο�? πε�?ιβάλλοντος";
		content["INFO_SELECT_DIRECTORY"]="Επιλέξτε τον κατάλογο στον οποίο θέλετε να εγκαταστήσετε το Flex SDK";
		content["INFO_SELECT_DIRECTORY_INSTALL"]="Επιλέξτε τον κατάλογο εγκατάστασης";
		content["INFO_UNZIPPING"]="Αποσυμπίεση: ";
		content["SELECT_PATH_PROMPT"]="Πληκτ�?ολογήστε η επιλέξτε μια έγκυ�?η διαδ�?ομή για το Flex SDK";
		content["STEP_CREATE_DIRECTORIES"]="Δημιου�?γία Καταλόγων";
		content["STEP_DOWNLOAD_AIR_RUNTIME_KIT"]="Λήψη Adobe AIR Runtime Kit";
		content["STEP_DOWNLOAD_FLASHPLAYER_SWC"]="Λήψη Flash Player swc";
		content["STEP_DOWNLOAD_FLEX_SDK"]="Λήψη Apache Flex SDK";
		content["STEP_INSTALL_CONFIG_FILES"]="Εγκατάσταση των α�?χείων �?υθμίσεων του Framework";
		content["STEP_UNZIP_AIR_RUNTIME_KIT"]="Αποσυμπίεση του Adobe AIR Runtime Kit";
		content["STEP_UNZIP_FLEX_SDK"]="Αποσυμπίεση του Apache Flex SDK";
		content["ASK_BLAZEDS"]="Το Apache Flex μπο�?εί π�?οαι�?ετικά να χ�?ησιμοποιήσει το Adobe BlazeDS. Η λειτου�?γία αυτή απαιτεί το α�?χείο flex-messaging-common.jar που β�?ίσκεται στο Adobe Flex SDK. Για το α�?χείο αυτό ισχ�?ει η συμφωνία χ�?ήσης της άδειας Adobe SDK για το Adobe Flex 4.6. Η άδεια αυτή δεν είναι συμβατή με την άδεια χ�?ήσης Apache V2. Θέλετε να εγκαταστήσετε το α�?χείο αυτά απο το Adobe Flex SDK;";
		content["ASK_FONTSWF"]="Το Apache Flex μπο�?εί π�?οαι�?ετικά να χ�?ησιμοποιήσει την υποστή�?ιξη που πα�?έχει η Adobe για ενσωματωμένες γ�?αματοσει�?ές. Η λειτου�?γία αυτή απαιτεί κάποια jar α�?χεία που υπά�?χουν στο Adobe Flex SDK. Για τα α�?χεία αυτά ισχ�?ει η συμφωνία χ�?ήσης της άδειας Adobe SDK για το Adobe Flex 4.6. Η άδεια αυτή δεν είναι συμβατή με την άδεια χ�?ήσης Apache V2. Θέλετε να εγκαταστήσετε τα α�?χεία αυτά απο το Adobe Flex SDK;";
		content["ASK_OSMF"]="Για το Open Source Media Framework (OSMF) που χ�?ησιμοποιείται απο τα αντικείμενα video ισχ�?ει η συμφωνία χ�?ήσης του Mozilla Public License Version 1.1. Θέλετε να εγκαταστήσετε το  Για το Open Source Media Framework (OSMF);";
		content["ASK_TLF"]="Για το Adobe Text Layout Framework (TLF) που χ�?ησιμοποιείται απο τα αντικείμενα κειμένου ισχ�?ει η συμφωνία χ�?ήσης Mozilla Public License Version 1.1. Θέλετε να εγκαταστήσετε το Adobe Text Layout Framework (TLF);";
		content["ASK_APACHE_FLEX"]="Για το Apache Flex SDK ισχ�?ει η συμφωνία χ�?ήσης του Apache License V2. Θέλετε να εγκαταστήσετε το Apache Flex SDK;";
		content["ASK_ADOBE_AIR_SDK"]="Για το Adobe AIR SDK ισχ�?ει η συμφωνία χ�?ήσης του Adobe SDK License. Θέλετε να εγκαταστήσετε το Adobe AIR SDK;";
		content["ASK_ADOBE_FLASH_PLAYER_GLOBAL_SWC"]="Για το Adobe Flash Player playerglobal.swc ισχ�?ει η συμφωνία χ�?ήσης του Adobe SDK License. Θέλετε να εγκαταστήσετε το Adobe Flash Player playerglobal.swc;";
		content["ASK_SWFOBJECT"]="Για το SWFObject ισχ�?ει η συμφωνία χ�?ήσης του MIT License (MIT). Θέλετε να εγκαταστήσετε το SWFObject;";
		content["BTN_LABEL_ADOBE_LICENSE"]="ΠΡΟΒΟΛΗ ADOBE LICENSE";
		content["BTN_LABEL_MPL_LICENSE"]="ΠΡΟΒΟΛΗ MPL LICENSE";
		content["BTN_DISCLAIMER"]="Αποποίηση Ευθυνών";
		content["ERROR_MIRROR_FETCH"]="Σφάλμα κατα τη διά�?κεια ανάκτησης μιας σελίδας για την λήψη των α�?χείων του Apache Flex SDK";
		content["ERROR_UNABLE_TO_DOWNLOAD_FILE"]="Αδυνατη λήψη του {0}";
		content["ERROR_UNABLE_TO_UNZIP"]="Δεν μπο�?εί να γίνει αποσυμπίεση του α�?χείου:";
		content["ERROR_UNABLE_TO_DOWNLOAD_SWF_OBJECT"]="Δεν μπο�?εί να γίνει λήψη του SWFObject";
		content["ERROR_VERIFY_FLEX_SDK"]="Η επαλήθευση των ληφθέντων α�?χείων απέτυχε. Η εγκατάσταση σταμάτησε.";
		content["FETCH_GEO_IP"]="Π�?οσπάθεια λήψης της χώ�?ας διαμονής του χ�?ήστη με χ�?ήση της υπη�?εσίας GeoIP...";
		content["FETCH_GEO_IP_DONE"]="'Εγινε λήψη της χώ�?ας διαμονής του χ�?ήστη απο την υπη�?εσία GeoIP.";
		content["FETCH_GEO_IP_ERROR"]="Σφάλμα κατα τη λήψη της χώ�?ας διαμονής του χ�?ήστη από την υπη�?εσία GeoIP...";
		content["FETCH_MIRROR_CGI"]="Π�?οσπάθεια ανάκτησης διαθέσιμης σελίδας λήψης απο CGI...";
		content["FETCH_MIRROR_CGI_DONE"]="Έγινε ανάκτηση διαθέσιμης σελίδας λήψης απο CGI.";
		content["FETCH_MIRROR_CGI_ERROR"]="Αποτυχία ανάκτησης διαθέσιμης σελίδας λήψης απο CGI.";
		content["FETCH_MIRROR_LIST"]="Γίνεται π�?οσπάθεια ανάκτησης της λίστας διαθέσιμων σελίδων απο Apache.org...";
		content["FETCH_MIRROR_LIST_DONE"]="Έγινε λήψη των διαθέσιμων σελίδων από Apache.org";
		content["FETCH_MIRROR_LIST_PARSED"]="Έγινε επεξε�?γασία των σελίδων χ�?ησιμοποιώντας τον κωδικό χώ�?ας και π�?οέκυψε ο ιστότοπος:";
		content["INFO_DOWNLOADING_ADOBE_FLEX_SDK"]="Γίνεται λήψη του Adobe Flex SDK από:";
		content["INFO_DOWNLOADING_FILE_FROM"]="Γίνεται λήψη του {0}  από: {1}";
		content["INFO_LICENSE_AGREEMENTS"]="Άδειες χ�?ήσης";
		content["INFO_NEED_TO_READ_AND_AGREE_TO_LICENSE"]="Η εφα�?μογή θα κάνει λήψη λογισμικο�? απο πολλαπλές ιστοσελίδες με διαφο�?ετικές άδειες χ�?ήσης. Πα�?ακαλώ επιλέξτε κάθε εγγ�?αφή απο την λίστα α�?ιστε�?ά, διαβάστε την άδεια χ�?ήσης και βεβαιώθείτε πως συμφωνείτε με τους ό�?ους της κάθε άδειας.";
		content["INFO_VERIFY_FLEX_SDK_DONE"]="Η επαλήθευση των ληφθέντων α�?χείων είναι επιτυχής.";
		content["INFO_WINDOW_TITLE"]="Εγκατάσταση του Apache Flex SDK {0} για χ�?ήση με το Adobe Flash Builder";
		content["INSTALL_AGREE"]="Συμφωνώ, να γίνει εγκατάσταση";
		content["INSTALL_AGREE_ALL"]="Συμφωνώ με όλες τις άδειες χ�?ήσης και τις επιλογές. �?α γίνει εγκατάσταση.";
		content["INSTALL_DISAGREE"]="Δεν συμφωνώ. �?α μην γίνει εγκατάσταση.";
		content["STEP_REQUIRED_INSTALL_APACHE_FLEX_SDK"]="Apache Flex SDK (Απαιτο�?μενο)";
		content["STEP_REQUIRED_INSTALL_ADOBE_AIR_SDK"]="Adobe AIR SDK (Απαιτο�?μενο)";
		content["STEP_REQUIRED_INSTALL_FLASH_PLAYER_GLOBAL_SWC"]="Adobe Flash Player playerglobal.swc (Απαιτο�?μενο)";
		content["STEP_REQUIRED_INSTALL_SWFOBJECT"]="SWFObject (Απαιτο�?μενο)";
		content["STEP_REQUIRED_INSTALL_OSMF"]="OSMF (Απαιτο�?μενο)";
		content["STEP_REQUIRED_INSTALL_TLF"]="Adobe Text Layout Framework (Απαιτο�?μενο)";
		content["STEP_OPTIONAL_INSTALL_BLAZEDS"]="BlazeDS (Π�?οαι�?ετικό)";
		content["STEP_OPTIONAL_INSTALL_FONTSWF"]="Adobe Embedded Font Libraries and Utilities (Π�?οαι�?ετικό)";
		content["STEP_REQUIRED_UNZIP_AIR_RUNTIME_KIT"]="Αποσυμπίεση του Adobe AIR Runtime Kit";
		content["STEP_VERIFY_FLEX_SDK"]="Γίνεται επαλήθευση του Apache Flex SDK MD5 Signature";
		content["LICENSE_APACHE_V2"]="";
		content["LICENSE_URL_APACHE_V2"]="";
		content["LICENSE_ADOBE_SDK"]="'Αδεια χ�?ήσης Adobe Flex SDK";
		content["LICENSE_URL_ADOBE_SDK"]="";
		content["LICENSE_ADOBE_AIR_SDK"]="'Αδεια χ�?ήσης Adobe AIR SDK";
		content["LICENSE_URL_ADOBE_AIR_SDK"]="";
		content["LICENSE_SWFOBJECT"]="";
		content["LICENSE_URL_SWFOBJECT"]="";
		content["LICENSE_OSMF"]="";
		content["LICENSE_URL_OSMF"]="";
		content["LICENSE_TLF"]="";
		content["LICENSE_URL_TLF"]="";
		content["LICENSE_FONTSWF"]="'Αδεια χ�?ήσης Adobe Flex SDK";
		content["LICENSE_URL_FONTSWF"]="";
		content["LICENSE_BLAZEDS"]="'Αδεια χ�?ήσης Adobe Flex SDK";
		content["LICENSE_URL_BLAZEDS"]="";
        content["INFO_TRACKING"] = "Information about your use of this application\nis being collected using HTTP requests.";


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
		content["ASK_BLAZEDS"]="Apache Flex can optionally integrate with Adobe BlazeDS. This feature requires flex-messaging-common.jar from the Adobe Flex SDK. The Adobe SDK license agreement for Adobe Flex 4.6 applies to this jar. This license is not compatible with the Apache V2 license. Do you want to install this jar from the Adobe Flex SDK?";
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
		content["INFO_NEED_TO_READ_AND_AGREE_TO_LICENSE"]="This installer will download software from multiple sites with various license agreements. Please click on each item on the left, read the license and confirm that you agree to the terms of each license by checking the checkbox next to it.";
		content["INFO_SELECT_DIRECTORY"]="Select the directory where you want to install the Flex SDK";
		content["INFO_SELECT_DIRECTORY_INSTALL"]="Select installation directory";
		content["INFO_UNZIPPING"]="Uncompressing: ";
		content["INFO_VERIFY_FLEX_SDK_DONE"]="The Apache Flex SDK MD5 Signature of the downloaded files matches the reference. The file is valid.";
		content["INFO_WINDOW_TITLE"]="Install Apache Flex SDK {0} for use with your IDE";
		content["INSTALL_AGREE"] = "I Agree, Install";
		content["INSTALL_AGREE_ALL"] = "I agree to all options and licenses, Install";
		content["INSTALL_DISAGREE"] = "I Disagree, Don't Install";
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
		content["INFO_TRACKING"]="Information about your use of this application is being collected using HTTP requests.";

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
		content["INFO_WINDOW_TITLE"]="Instalar Apache Flex SDK {0} para su uso con Adobe Flash Builder";
		content["INSTALL_AGREE"] = "Acepto, Instalar";
		content["INSTALL_AGREE_ALL"] = "Acepto todas las opciones y licencias, Instalar";
		content["INSTALL_DISAGREE"] = "No estoy de acuerdo, Cancelar";
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
        content["INFO_TRACKING"] = "Information about your use of this application\nis being collected using HTTP requests.";

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
		content["ASK_BLAZEDS"]="Apache Flex kan optioneel integreren met Adobe BlazeDS. Deze feature vereist flex-messaging-common.jar uit de Adobe Flex SDK. De Adobe SDK licentie overeenkomst voor Adobe Flex 4.6 geldt voor deze jar. Deze licentie is niet compatibel met de Apache V2 licentie. Wilt u deze jar uit de Adobe Flex SDK installeren?";
		content["ASK_FONTSWF"]="Apache Flex kan optioneel integreren met Adobe's embedded font support. Deze feature vereist een aantal font jars uit de Adobe Flex SDK. De Adobe SDK licentie overeenkomst voor Adobe Flex 4.6 geldt voor deze jars. Deze licentie is niet compatibel met de Apache V2 licentie. Wilt u deze jars uit de Adobe Flex SDK installeren?";
		content["ASK_OSMF"]="Het Open Source Media Framework (OSMF) dat gebruikt wordt door de video componenten is gelicenseerd onder de Mozilla Public License Versie 1.1. Wilt u het Open Source Media Framework (OSMF) installeren?";
		content["ASK_TLF"]="Het Adobe Text Layout Framework (TLF) dat gebruikt wordt door de Spark tekst componenten zijn gelicenseerd onder de Mozilla Public License Versie 1.1. Wilt u het Adobe Text Layout Framework (TLF) installeren?";
		content["ASK_APACHE_FLEX"]="De Apache License V2 geldt voor de Apache Flex SDK. Wilt u de Apache Flex SDK installeren?";
		content["ASK_ADOBE_AIR_SDK"]="De Adobe SDK licentie overeenkomst geldt voor de Adobe AIR SDK. Wilt u de Adobe AIR SDK installeren?";
		content["ASK_ADOBE_FLASH_PLAYER_GLOBAL_SWC"]="De Adobe SDK licentie overeenkomst geldt voor de Adobe Flash Player playerglobal.swc. Wilt u de Adobe Flash Player playerglobal.swc installeren?";
		content["ASK_SWFOBJECT"]="De MIT License (MIT) geldt voor de SWFObject utility. Wilt u de SWFObject utility installeren?";
		content["BTN_LABEL_ADOBE_LICENSE"]="TOON ADOBE LICENTIE";
		content["BTN_LABEL_BROWSE"]="BLADER";
		content["BTN_LABEL_CLOSE"]="SLUITEN";
		content["BTN_LABEL_INSTALL"]="INSTALLEREN";
		content["BTN_LABEL_INSTALL_LOG"]="TOON LOG";
		content["BTN_LABEL_MPL_LICENSE"]="TOON MPL LICENSE";
		content["BTN_LABEL_NEXT"]="VERDER";
		content["BTN_DISCLAIMER"]="Disclaimer";
		content["BTN_LABEL_OPEN_APACHE_FLEX_FOLDER"]="OPEN APACHE FLEX MAP";
		content["ERROR_CONFIG_XML_LOAD"]="Fout tijdens het laden van het XML configuratie bestand: ";
		content["ERROR_DIR_NOT_EMPTY"]="De geselecteerde map is niet leeg";
		content["ERROR_INVALID_AIR_SDK_URL_MAC"]="Adobe AIR SDK URL voor Mac is ongeldig in configuratie bestand";
		content["ERROR_INVALID_AIR_SDK_URL_WINDOWS"]="Adobe AIR SDK URL voor Windows is ongeldig in configuratie bestand";
		content["ERROR_INVALID_FLASH_PLAYER_SWC_URL"]="Flash Player swc URL is ongeldig in configuratie bestand";
		content["ERROR_INVALID_FLEX_SDK_DIRECTORY"]="Ongeldige Flex SDK map geselecteerd";
		content["ERROR_INVALID_SDK_URL"]="Apache Flex SDK URL ongeldig in configuratie bestand";
		content["ERROR_MIRROR_FETCH"]="Fout tijdens het ophalen van een mirror site voor de Apache Flex SDK binaire bestanden: ";
		content["ERROR_NATIVE_PROCESS_ERROR"]="Native Process fout kan Adobe AIR SDK niet uitpakken";
		content["ERROR_NATIVE_PROCESS_NOT_SUPPORTED"]="Native Process niet ondersteund. Kan Adobe AIR SDK niet uitpakken";
		content["ERROR_UNABLE_TO_COPY_FILE"]="Kan bestand niet kopieeren ";
		content["ERROR_UNABLE_TO_CREATE_TEMP_DIRECTORY"]="Kon geen tijdelijke map aanmaken";
		content["ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY"]="Opruimen van tijdelijke installatie bestanden mislukt";
		content["ERROR_UNABLE_TO_DOWNLOAD_AIR_SDK"]="Downloaden Adobe AIR Runtime Kit mislukt";
		content["ERROR_UNABLE_TO_DOWNLOAD_FILE"]="Kon bestand {0} niet downloaden";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLASH_PLAYER_SWC"]="Downloaden Flash Player swc mislukt";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLEX_SDK"]="Downloaden Apache Flex SDK mislukt";
		content["ERROR_UNABLE_TO_INSTALL_CONFIG_FILES"]="Kon configuratie bestanden niet installeren";
		content["ERROR_UNABLE_TO_UNZIP"]="Kon dit bestand niet uitpakken: ";
		content["ERROR_UNABLE_TO_DOWNLOAD_SWF_OBJECT"]="Kon SWFObject niet downloaden";
		content["ERROR_UNSUPPORTED_OPERATING_SYSTEM"]="Besturingsysteem is niet ondersteund";
		content["ERROR_VERIFY_FLEX_SDK"]="Het Apache Flex SDK MD5 signatuur van de gedownloade bestanden komt niet overeen met de referentie waarde. Het bestand is ongeldig, de installatie wordt afgebroken.";
		content["FETCH_GEO_IP"]="Bezig de landcode van de huidige gebruiker op te halen via de GeoIP dienst...";
		content["FETCH_GEO_IP_DONE"]="De landcode van de huidige gebruiker is opgehaald via de GeoIP dienst.";
		content["FETCH_GEO_IP_ERROR"]="Er is een fout opgetreden tijdens het ophalen van de landcode voor de huidige gebruiker via GeoIP dienst.";
		content["FETCH_MIRROR_CGI"]="Bezig de SDK download mirror URL op te halen via de CGI...";
		content["FETCH_MIRROR_CGI_DONE"]="SDK download mirror URL is opgehaald via de CGI.";
		content["FETCH_MIRROR_CGI_ERROR"]="Kon de SDK download mirror URL niet ophalen via de CGI. Nu trachten via de GeoIP dienst.";
		content["FETCH_MIRROR_LIST"]="Bezig de mirror lijst op te halen van Apache.org...";
		content["FETCH_MIRROR_LIST_DONE"]="Mirror lijst is opgehaald van Apache.org.";
		content["FETCH_MIRROR_LIST_PARSED"]="Mirror lijst is geparsed met behulp van de landcode en dit domein is ervoor gevonden: ";
		content["INFO_ABORT_INSTALLATION"]="Installatie wordt afgebroken";
		content["INFO_APP_INVOKED"]="Opgestart in command line modus met de volgende argumenten: ";
		content["INFO_CREATING_FLEX_HOME"]="Maakt Apache Flex home aan";
		content["INFO_CREATING_TEMP_DIR"]="Maakt tijdelijke map aan";
		content["INFO_CURRENT_LANGUAGE"]="Kies een taal";
		content["INFO_DOWNLOADING_ADOBE_FLEX_SDK"]="Adobe Flex SDK wordt gedownload van: ";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_MAC"]="Adobe AIR Runtime Kit voor Mac wordt gedownload van: ";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_WINDOWS"]="Adobe AIR Runtime Kit voor Windows wordt gedownload van: ";
		content["INFO_DOWNLOADING_FILE_FROM"]="{0} wordt gedownload van: {1}";
		content["INFO_DOWNLOADING_FLEX_SDK"]="Apache Flex SDK wordt gedownload van: ";
		content["INFO_DOWNLOADED"]="Gedownload ";
		content["INFO_ENTER_VALID_FLEX_SDK_PATH"]="Geef een geldig Flex SDK pad in";
		content["INFO_FINISHED_UNTARING"]="Klaar met tar uitpakken:";
		content["INFO_FINISHED_UNZIPPING"]="Klaar met zip uitpakken: ";
		content["INFO_INSTALLATION_COMPLETE"]="Installatie gereed.";
		content["INFO_INSTALLING"]="Installeren...";
		content["INFO_INSTALLING_CONFIG_FILES"]="Framework configuratie bestanden voor gebruik met IDE worden geinstalleerd";
		content["INFO_INSTALLING_PLAYERGLOBAL_SWC"]="Adobe Flash Player playerglobal.swc wordt geinstalleerd van:";
		content["INFO_INVOKED_GUI_MODE"]="Opgestart in visuele modus";
		content["INFO_LICENSE_AGREEMENTS"]="Licentie Overeenkomsten";
		content["INFO_NEED_TO_READ_AND_AGREE_TO_LICENSE"]="Dit installatie bestand zal software downloaden van verschillende sites met verschillende licenties. U wordt verzocht om op ieder onderdeel in de linkerkolom te klikken en te bevestigen dat u akkoord gaat met de bijbehorende licentie overeenkomst.";
		content["INFO_SELECT_DIRECTORY"]="Kies een map";
		content["INFO_SELECT_DIRECTORY_INSTALL"]="Kies de installatie map";
		content["INFO_UNZIPPING"]="Uitpakken: ";
		content["INFO_VERIFY_FLEX_SDK_DONE"]="Het Apache Flex SDK MD5 signatuur van de gedownloade bestanden komt overeen met de referentie. Het bestand is geldig.";
		content["INFO_WINDOW_TITLE"]="Installeer Apache Flex SDK {0} voor gebruik in Adobe Flash Builder";
		content["INSTALL_AGREE"] = "Ik ga akkoord, installeer";
		content["INSTALL_AGREE_ALL"] = "Ik ga akkoord met alle opties en licenties, installeer";
		content["INSTALL_DISAGREE"] = "Ik ga niet akkoord, installeer niet";
		content["SELECT_PATH_PROMPT"]="Geef Flex SDK pad in of blader naar het pad";
		content["STEP_CREATE_DIRECTORIES"]="Mappen aanmaken";
		content["STEP_REQUIRED_INSTALL_APACHE_FLEX_SDK"]="Apache Flex SDK (Verplicht)";
		content["STEP_REQUIRED_INSTALL_ADOBE_AIR_SDK"]="Adobe AIR SDK (Verplicht)";
		content["STEP_REQUIRED_INSTALL_FLASH_PLAYER_GLOBAL_SWC"]="Adobe Flash Player playerglobal.swc (Verplicht)";
		content["STEP_REQUIRED_INSTALL_SWFOBJECT"]="SWFObject (Verplicht)";
		content["STEP_INSTALL_CONFIG_FILES"]="Framework Configuratie Bestanden Installeren";
		content["STEP_REQUIRED_INSTALL_OSMF"]="OSMF (Verplicht)";
		content["STEP_REQUIRED_INSTALL_TLF"]="Adobe Text Layout Framework (Verplicht)";
		content["STEP_OPTIONAL_INSTALL_BLAZEDS"]="BlazeDS (Optioneel)";
		content["STEP_OPTIONAL_INSTALL_FONTSWF"]="Adobe Embedded Font Libraries en Utilities (Optioneel)";
		content["STEP_REQUIRED_UNZIP_AIR_RUNTIME_KIT"]="Adobe AIR Runtime Kit uitpakken";
		content["STEP_UNZIP_AIR_RUNTIME_KIT"]="Adobe AIR Runtime Kit Uitpakken";
		content["STEP_UNZIP_FLEX_SDK"]="Apache Flex SDK uitpakken";
		content["STEP_VERIFY_FLEX_SDK"]="Verifieër Apache Flex SDK MD5 signatuur";
		content["LICENSE_APACHE_V2"]="Apache V2 Licentie";
		content["LICENSE_ADOBE_SDK"]="Adobe Flex SDK Licentie";
		content["LICENSE_ADOBE_AIR_SDK"]="Adobe AIR SDK Licentie";
		content["LICENSE_SWFOBJECT"]="MIT Licentie";
		content["LICENSE_OSMF"]="Mozilla Public License Versie 1.1";
		content["LICENSE_TLF"]="Mozilla Public License Versie 1.1";
		content["LICENSE_FONTSWF"]="Adobe Flex SDK Licentie";
		content["LICENSE_BLAZEDS"]="Adobe Flex SDK Licentie";
		content["LICENSE_URL_APACHE_V2"]="http://www.apache.org/licenses/LICENSE-2.0.html";
		content["LICENSE_URL_ADOBE_SDK"]="http://www.adobe.com/products/eulas/pdfs/adobe_flex_software_development_kit-combined-20110916_0930.pdf";
		content["LICENSE_URL_ADOBE_AIR_SDK"]="http://www.adobe.com/products/air/sdk-eula.html";
		content["LICENSE_URL_SWFOBJECT"]="http://opensource.org/licenses/mit-license.php";
		content["LICENSE_URL_OSMF"]="http://www.mozilla.org/MPL/";
		content["LICENSE_URL_TLF"]="http://www.mozilla.org/MPL/";
		content["LICENSE_URL_FONTSWF"]="http://www.adobe.com/products/eulas/pdfs/adobe_flex_software_development_kit-combined-20110916_0930.pdf";
		content["LICENSE_URL_BLAZEDS"]="http://www.adobe.com/products/eulas/pdfs/adobe_flex_software_development_kit-combined-20110916_0930.pdf";
		content["INFO_TRACKING"]="Informatie over uw gebruik van deze applicatie wordt verzameld via HTTP verzoeken.";

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
		content["ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY"]="Não foi possível limpar os diretórios temporários";
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
		content["INFO_WINDOW_TITLE"]="Instalação do Apache Flex SDK {0} para utilização no Adobe Flash Builder";
		content["INSTALL_AGREE"] = "Eu concordo, instalar";
		content["INSTALL_DISAGREE"] = "Não concordo, não instale";
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

	//----------------------------------
	// install_fr_FR
	//----------------------------------

	private function install_fr_FR():void
	{
		var locale:String = FR_FR;
		var resource:ResourceBundle = new ResourceBundle(locale, ViewResourceConstants.BUNDLE_NAME);

		var content:Object = resource.content;
		content["ASK_BLAZEDS"]="Apache Flex peut éventuellement s'intégrer à Adobe BlazeDS. Cette fonctionalité nécessite flex-messaging-common.jar du SDK Adobe Flex. L'accord de licence Adobe SDK pour Adobe Flex 4.6 s'applique à ce jar. Cette licence n'est pas compatible avec la licence Apache V2. Voulez-vous installer ce jar à partir du SDK Adobe Flex?";
		content["ASK_FONTSWF"]="Apache Flex peut éventuellement s'intégrer avec le support de polices embarquées Adobe (Adobe's embedded font support). Cette fonctionalité nécessite quelques jars de polices du SDK Adobe Flex. L'accord de licence Adobe SDK pour Adobe Flex 4.6 s'applique à ces jarres. Cette licence n'est pas compatible avec la licence Apache V2. Voulez-vous installer ces jars à partir du SDK Adobe Flex?";
		content["ASK_OSMF"]="L'Open Source Media Framework (OSMF) utilisé par les composants vidéo est sous la licence Mozilla Public License Version 1.1. Voulez-vous installer le Open Source Media Framework (OSMF)?";
		content["ASK_TLF"]="Le Text Layout Framework Adobe (TLF) utilisé par les composants de texte Spark est sous licence Mozilla Public License Version 1.1. Voulez-vous installer le logiciel Adobe Text Layout Framework (TLF)?";
		content["ASK_APACHE_FLEX"]="La licence Apache V2 s'applique au SDK Apache Flex. Voulez-vous installer le SDK Apache Flex?";
		content["ASK_ADOBE_AIR_SDK"]="L'accord de licence SDK Adobe s'applique au SDK Adobe AIR. Voulez-vous installer le SDK Adobe AIR?";
		content["ASK_ADOBE_FLASH_PLAYER_GLOBAL_SWC"]="L'accord de licence SDK Adobe s'applique au Adobe Flash Player playerglobal.swc. Voulez-vous installer le logiciel Adobe Flash Player playerglobal.swc?";
		content["ASK_SWFOBJECT"]="La licence MIT (MIT) s'applique à l'utilitaire SWFObject. Voulez-vous installer l'utilitaire SWFObject?";
		content["BTN_LABEL_ADOBE_LICENSE"]="AFFICHER LA LICENCE ADOBE";
		content["BTN_LABEL_BROWSE"]="PARCOURIR";
		content["BTN_LABEL_CLOSE"]="FERMER";
		content["BTN_LABEL_INSTALL"]="INSTALLER";
		content["BTN_LABEL_INSTALL_LOG"]="JOURNAL D'INSTALLATION";
		content["BTN_LABEL_MPL_LICENSE"]="AFFICHER LA LICENCE MPL";
		content["BTN_LABEL_NEXT"]="SUIVANT";
		content["BTN_DISCLAIMER"]="Disclaimer";
		content["BTN_LABEL_OPEN_APACHE_FLEX_FOLDER"]="OUVRIR LE DOSSIER APACHE FLEX";
		content["ERROR_CONFIG_XML_LOAD"]="Erreur lors du chargement du fichier de configuration XML: ";
		content["ERROR_DIR_NOT_EMPTY"]="Le répertoire sélectionné n'est pas vide";
		content["ERROR_INVALID_AIR_SDK_URL_MAC"]="L'URL pour Mac du Adobe AIR SDK non valide dans le fichier de configuration";
		content["ERROR_INVALID_AIR_SDK_URL_WINDOWS"]="L'URL pour Windows du Adobe AIR SDK non valide dans le fichier de configuration";
		content["ERROR_INVALID_FLASH_PLAYER_SWC_URL"]="Flash Player swc URL non valide dans le fichier de configuration";
		content["ERROR_INVALID_FLEX_SDK_DIRECTORY"]="Le répertoire sélectionné du SDK Flex est invalide";
		content["ERROR_INVALID_SDK_URL"]="Apache Flex SDK URL non valide dans le fichier de configuration";
		content["ERROR_MIRROR_FETCH"]="Erreur lors de la tentative de récupération d'un miroir pour télécharger les binaires du SDK Apache Flex:";
		content["ERROR_NATIVE_PROCESS_ERROR"]="Erreur du Processus natif - incapable de décompresser Adobe AIR SDK";
		content["ERROR_NATIVE_PROCESS_NOT_SUPPORTED"]="Processus Natif pas pris en charge. Impossible de décompresser Adobe AIR SDK";
		content["ERROR_UNABLE_TO_COPY_FILE"]="Impossible de copier le fichier ";
		content["ERROR_UNABLE_TO_CREATE_TEMP_DIRECTORY"]="Impossible de créer un répertoire temporaire";
		content["ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY"]="Impossible de nettoyer les répertoires d'installation temporaires";
		content["ERROR_UNABLE_TO_DOWNLOAD_AIR_SDK"]="Impossible de télécharger Adobe AIR Runtime Kit";
		content["ERROR_UNABLE_TO_DOWNLOAD_FILE"]="Impossible de télécharger {0}";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLASH_PLAYER_SWC"]="Impossible de télécharger Flash Player swc";
		content["ERROR_UNABLE_TO_DOWNLOAD_FLEX_SDK"]="Impossible de télécharger Apache Flex SDK";
		content["ERROR_UNABLE_TO_INSTALL_CONFIG_FILES"]="Impossible d'installer les fichiers de configuration";
		content["ERROR_UNABLE_TO_UNZIP"]="Impossible de décompresser le fichier: ";
		content["ERROR_UNABLE_TO_DOWNLOAD_SWF_OBJECT"]="Impossible de télécharger SWFObject";
		content["ERROR_UNSUPPORTED_OPERATING_SYSTEM"]="Système d'exploitation non pris en charge";
		content["ERROR_VERIFY_FLEX_SDK"]="La Signature MD5 des fichiers téléchargés du SDK Apache Flex ne correspond pas à la valeur de référence. Le fichier n'est pas valide, l'installation est interrompue.";
		content["FETCH_GEO_IP"]="Essai de récupération du code du pays de l'utilisateur à partir du service GeoIP ...";
		content["FETCH_GEO_IP_DONE"]="Le code du pays de l'utilisateur à été récupéré à partir du service GeoIP.";
		content["FETCH_GEO_IP_ERROR"]="Une erreur s'est produite lors de la récupération du code pays de l'utilisateur à partir du service GeoIP.";
		content["FETCH_MIRROR_CGI"]="Essais de récupération de l'URL de téléchargement du SDK à partir du CGI ...";
		content["FETCH_MIRROR_CGI_DONE"]="L'URL de téléchargement du SDK à été récupéré à partir du CGI.";
		content["FETCH_MIRROR_CGI_ERROR"]="Impossible de récupérer l'URL de téléchargement du SDK à partir du CGI. S'aprête à essayer la route GeoIP.";
		content["FETCH_MIRROR_LIST"]="Essai de récupération de la liste des miroirs de Apache.org ...";
		content["FETCH_MIRROR_LIST_DONE"]="La liste des miroirs à été récupéré depuis Apache.org.";
		content["FETCH_MIRROR_LIST_PARSED"]="La liste des miroirs à été analisé et le code du pays de ce domaine à été obtenu: ";
		content["INFO_ABORT_INSTALLATION"]="Installation interrompue";
		content["INFO_APP_INVOKED"]="Invoqué en mode ligne de commande avec les arguments suivants: ";
		content["INFO_CREATING_FLEX_HOME"]="Creation du dossier racine d'Apache Flex";
		content["INFO_CREATING_TEMP_DIR"]="Création du répertoire temporaire";
		content["INFO_CURRENT_LANGUAGE"]="Sélectionnez la langue";
		content["INFO_DOWNLOADING_ADOBE_FLEX_SDK"]="Téléchargement d'Adobe Flex SDK à partir de: ";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_MAC"]="Téléchargement d'Adobe AIR Runtime Kit pour Mac à partir de: ";
		content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_WINDOWS"]="Téléchargement d'Adobe AIR Runtime Kit pour Windows à partir de: ";
		content["INFO_DOWNLOADING_FILE_FROM"]="Téléchargement {0} de: {1}";
		content["INFO_DOWNLOADING_FLEX_SDK"]="Téléchargement d'Apache Flex SDK à partir de: ";
		content["INFO_DOWNLOADED"]="Téléchargement terminé ";
		content["INFO_ENTER_VALID_FLEX_SDK_PATH"]="S'il vous plaît entrez un chemin de répertoire valide pour le SDK Flex";
		content["INFO_FINISHED_UNTARING"]="Décompression de l'archive terminée: ";
		content["INFO_FINISHED_UNZIPPING"]="Décompression terminée:";
		content["INFO_INSTALLATION_COMPLETE"]="Installation terminée";
		content["INFO_INSTALLING"]="Installation ...";
		content["INFO_INSTALLING_CONFIG_FILES"]="Installation des fichiers de configuration du framework configurés pour être utilisés avec un IDE";
		content["INFO_INSTALLING_PLAYERGLOBAL_SWC"]="Installation d'Adobe Flash Player playerglobal.swc à partir de: ";
		content["INFO_INVOKED_GUI_MODE"]="invoqué en mode graphique";
		content["INFO_LICENSE_AGREEMENTS"]="Contrats de licences";
		content["INFO_NEED_TO_READ_AND_AGREE_TO_LICENSE"]="Ce programme d'installation va télécharger le logiciel à partir de plusieurs sites avec des accords de licence différents. S'il vous plaît, cliquez sur chaque élément sur la gauche, lisez la licence et confirmez que vous acceptez ses termes.";
		content["INFO_SELECT_DIRECTORY"]="Sélectionnez le répertoire où vous souhaitez installer le SDK Flex";
		content["INFO_SELECT_DIRECTORY_INSTALL"]="Sélectionnez le répertoire d'installation";
		content["INFO_UNZIPPING"]="Décompression: ";
		content["INFO_VERIFY_FLEX_SDK_DONE"]="La Signature MD5 des fichiers téléchargés pour le SDK Apache Flex correspond à la référence. Le fichier est valide.";
		content["INFO_WINDOW_TITLE"]="Installer Apache Flex SDK {0} à utiliser avec votre IDE";
		content["INSTALL_AGREE"] = "Je suis d'accord, Installer";
		content["INSTALL_AGREE_ALL"] = "Je suis d'accord pour toutes les options et les licences, installer";
		content["INSTALL_DISAGREE"] = "Je suis en désaccord, Ne pas installer";
		content["SELECT_PATH_PROMPT"]="Où voulez-vous installer le SDK Flex Apache?";
		content["STEP_CREATE_DIRECTORIES"]="Créer les répertoires";
		content["STEP_REQUIRED_INSTALL_APACHE_FLEX_SDK"]="Apache Flex SDK (Requis)";
		content["STEP_REQUIRED_INSTALL_ADOBE_AIR_SDK"]="Adobe AIR SDK (Requis)";
		content["STEP_REQUIRED_INSTALL_FLASH_PLAYER_GLOBAL_SWC"]="Adobe Flash Player playerglobal.swc (Requis)";
		content["STEP_REQUIRED_INSTALL_SWFOBJECT"]="SWFObject (Requis)";
		content["STEP_INSTALL_CONFIG_FILES"]="Installer les fichiers de configuration du framework";
		content["STEP_REQUIRED_INSTALL_OSMF"]="OSMF (Requis)";
		content["STEP_REQUIRED_INSTALL_TLF"]="Adobe Text Layout Framework (Requis)";
		content["STEP_OPTIONAL_INSTALL_BLAZEDS"]="BlazeDS (facultatif)";
		content["STEP_OPTIONAL_INSTALL_FONTSWF"]="Bibliothèques Adobe Font embarqués et utilitaires (facultatif)";
		content["STEP_REQUIRED_UNZIP_AIR_RUNTIME_KIT"]="Décompresser Adobe AIR Runtime Kit";
		content["STEP_UNZIP_AIR_RUNTIME_KIT"]="Décompresser Adobe AIR Runtime Kit";
		content["STEP_UNZIP_FLEX_SDK"]="Décompresser Apache Flex SDK";
		content["STEP_VERIFY_FLEX_SDK"]="Vérification de la Signature Apache Flex SDK MD5";
		content["LICENSE_APACHE_V2"]="Licence Apache v2";
		content["LICENSE_URL_APACHE_V2"]="http://www.apache.org/licenses/LICENSE-2.0.html";
		content["LICENSE_ADOBE_SDK"]="Licence Adobe Flex SDK";
		content["LICENSE_URL_ADOBE_SDK"]="http://www.adobe.com/products/eulas/pdfs/adobe_flex_software_development_kit-combined-20110916_0930.pdf";
		content["LICENSE_ADOBE_AIR_SDK"]="Licence Adobe AIR SDK";
		content["LICENSE_URL_ADOBE_AIR_SDK"]="http://www.adobe.com/products/air/sdk-eula.html";
		content["LICENSE_SWFOBJECT"]="Licence MIT";
		content["LICENSE_URL_SWFOBJECT"]="http://opensource.org/licenses/mit-license.php";
		content["LICENSE_OSMF"]="Licence Mozilla Public Version 1.1";
		content["LICENSE_URL_OSMF"]="http://www.mozilla.org/MPL/";
		content["LICENSE_TLF"]="Licence Mozilla Public Version 1.1";
		content["LICENSE_URL_TLF"]="http://www.mozilla.org/MPL/";
		content["LICENSE_FONTSWF"]="Licence Adobe Flex SDK";
		content["LICENSE_URL_FONTSWF"]="http://www.adobe.com/products/eulas/pdfs/adobe_flex_software_development_kit-combined-20110916_0930.pdf";
		content["LICENSE_BLAZEDS"]="Licence Adobe Flex SDK";
		content["LICENSE_URL_BLAZEDS"]="http://www.adobe.com/products/eulas/pdfs/adobe_flex_software_development_kit-combined-20110916_0930.pdf";
        content["INFO_TRACKING"]="Les informations concernant votre utilisation de cette application\nvont être collectées en utilisant des requêtes HTTP";

		_resourceManager.addResourceBundle(resource);
	}

    //----------------------------------
    // install_de_DE
    //----------------------------------

    private function install_de_DE():void
    {
        var locale:String = DE_DE;
        var resource:ResourceBundle = new ResourceBundle(locale, ViewResourceConstants.BUNDLE_NAME);



        var content:Object = resource.content;
        content["ASK_BLAZEDS"]="Apache Flex kann optional Adobe BlazeDS einbinden. Dieses Feature benötigt flex-messaging-common.jar aus dem Adobe Flex SDK. Die Adobe SDK Lizenzvereinbarung für Adobe Flex 4.6 gilt für diese Jar-Datei. Diese Lizenz ist nicht mit der Apache V2 Lizenz vereinbar. Möchten Sie diese Jar-Datei aus dem Adobe Flex SDK installieren?";
        content["ASK_FONTSWF"]="Apache Flex kann optional das Feature \"Einbetten von Schriftarten\" einbinden. Dieses Feature benötigt verschieden Schriftarten Jar-Dateien aus dem Adobe Flex SDK. Die Adobe SDK Lizenzvereinbarung für Adobe Flex 4.6 gilt für diese Jar-Dateien. Diese Lizenz ist nicht mit der Apache V2 Lizenz vereinbar. Möchten Sie diese Jar-Dateien aus dem Adobe Flex SDK installieren?";
        content["ASK_OSMF"]="Das Open Source Media Framework (OSMF) welches von den Videokomponenten verwendet wird ist unter der Mozilla Public License Version 1.1 lizensiert. Möchten Sie das Open Source Media Framework (OSMF) jetzt installieren?";
        content["ASK_TLF"]="Das Adobe Text Layout Framework (TLF) welches von den Spark Textkomponeten verwendet wird ist unter der Mozilla Public License Version 1.1 lizensiert.  Möchten Sie das Adobe Text Layout Framework (TLF) jetzt installieren?";
        content["ASK_APACHE_FLEX"]="Das Apache Flex SDK verwendet die Apache License V2. Möchten Sie jetzt das Apache Flex SDK installieren?";
        content["ASK_ADOBE_AIR_SDK"]="Das Adobe AIR SDK verwendet die Adobe SDK Lizenzvereinbarung. Möchten SIe jetzt das Adobe AIR SDK installieren?";
        content["ASK_ADOBE_FLASH_PLAYER_GLOBAL_SWC"]="Die Adobe Flash Player playerglobal.swc verwendet die Adobe SDK Lizenzvereinbarung. Möchten SIe jetzt die Adobe Flash Player playerglobal.swc installieren?";
        content["ASK_SWFOBJECT"]="Das SWFObject utility verwendet die MIT License (MIT).  Möchten SIe jetzt das SWFObject utility installieren?";
        content["BTN_LABEL_ADOBE_LICENSE"]="ADOBE LIZENZ ANZEIGEN";
        content["BTN_LABEL_BROWSE"]="ÖFFNEN";
        content["BTN_LABEL_CLOSE"]="SCHLIEßEN";
        content["BTN_LABEL_INSTALL"]="INSTALLIEREN";
        content["BTN_LABEL_INSTALL_LOG"]="PROTOKOLL ANZEIGEN";
        content["BTN_LABEL_MPL_LICENSE"]="MPL LIZENZ ANZEIGEN";
        content["BTN_LABEL_NEXT"]="WEITER";
        content["BTN_DISCLAIMER"]="Haftungsausschluss";
        content["BTN_LABEL_OPEN_APACHE_FLEX_FOLDER"]="APACHE FLEX ORDNER ÖFFNEN";
        content["ERROR_CONFIG_XML_LOAD"]="Fehler beim Laden der XML Konfigurationsdatei: ";
        content["ERROR_DIR_NOT_EMPTY"]="Das ausgewählte Verzeichnis ist nicht leer";
        content["ERROR_INVALID_AIR_SDK_URL_MAC"]="Adobe AIR SDK URL für Mac in Konfigurationsdatei ungültig";
        content["ERROR_INVALID_AIR_SDK_URL_WINDOWS"]="Adobe AIR SDK URL für Windows in Konfigurationsdatei ungültig";
        content["ERROR_INVALID_FLASH_PLAYER_SWC_URL"]="Flash Player swc URL in Konfigurationsdatei ungültig";
        content["ERROR_INVALID_FLEX_SDK_DIRECTORY"]="Ungültiges Flex SDK Verzeichnis ausgewählt";
        content["ERROR_INVALID_SDK_URL"]="Apache Flex SDK URL in Konfigurationsdatei ungültig";
        content["ERROR_MIRROR_FETCH"]="Fehler beim ermitteln eines mirrors für den Download der Apache Flex SDK Binaries: ";
        content["ERROR_NATIVE_PROCESS_ERROR"]="Native Process Fehler Kann Adobe AIR SDK nicht entpacken";
        content["ERROR_NATIVE_PROCESS_NOT_SUPPORTED"]="Native Process nicht unterstützt. Kann Adobe AIR SDK nicht entpacken";
        content["ERROR_UNABLE_TO_COPY_FILE"]="Kopieren von Datei fehlgeschlagen";
        content["ERROR_UNABLE_TO_CREATE_TEMP_DIRECTORY"]="Erstellen von Temp Verzeichnis fehlgeschlagen";
        content["ERROR_UNABLE_TO_DELETE_TEMP_DIRECTORY"]="Löschen von Temp Verzeichnis fehlgeschlagen";
        content["ERROR_UNABLE_TO_DOWNLOAD_AIR_SDK"]="Download von Adobe AIR Runtime Kit fehlgeschlagen";
        content["ERROR_UNABLE_TO_DOWNLOAD_FILE"]="Downlod fehlgeschlagen von Datei: {0}";
        content["ERROR_UNABLE_TO_DOWNLOAD_FLASH_PLAYER_SWC"]="Download von Flash Player swc fehlgeschlagen";
        content["ERROR_UNABLE_TO_DOWNLOAD_FLEX_SDK"]="Download von Apache Flex SDK fehlgeschlagen";
        content["ERROR_UNABLE_TO_INSTALL_CONFIG_FILES"]="Installation von Konfigurationsdatei fehlgeschlagen";
        content["ERROR_UNABLE_TO_UNZIP"]="Entpacken von Datei fehlgeschlagen: ";
        content["ERROR_UNABLE_TO_DOWNLOAD_SWF_OBJECT"]="Download von SWFObject fehlgeschlagen";
        content["ERROR_UNSUPPORTED_OPERATING_SYSTEM"]="Nicht unterstütztes Betriebssystem";
        content["ERROR_VERIFY_FLEX_SDK"]="Die Signatur der heruntergeladenen Dateien stimmt nicht mit der Apache Flex SDK MD5 Signatur überein. Dateien sind fehlerhaft. Installation wird abgebrochen.";
        content["FETCH_GEO_IP"]="Versuche Länderkennung des Benutzer über GeoIP Service zu identifizieren...";
        content["FETCH_GEO_IP_DONE"]="Länderkennung erfolgreich über GeoIP Service identifiziert.";
        content["FETCH_GEO_IP_ERROR"]="Identifizierung von Länderkennung über GeoIP Service fehlgeschlagen";
        content["FETCH_MIRROR_CGI"]="Versuche mirror URL für APACHE Flex SDK  über CGI-Skript zu ermitteln...";
        content["FETCH_MIRROR_CGI_DONE"]="Ermitteln von mirror URL über CGI-Skript erfolgreich.";
        content["FETCH_MIRROR_CGI_ERROR"]="Ermitteln von mirror URL über CGI-Skript fehlgeschlagen.";
        content["FETCH_MIRROR_LIST"]="Versuche mirror Liste von Apache.org zu laden...";
        content["FETCH_MIRROR_LIST_DONE"]="Laden von mirror Liste von Apache.org erfolgreich.";
        content["FETCH_MIRROR_LIST_PARSED"]="mirror Liste verarbeitet und unter Verwendung der Länderkennung folgende Domain ermittelt: ";
        content["INFO_ABORT_INSTALLATION"]="Installation abgebrochen";
        content["INFO_APP_INVOKED"]="Kommandozeilenmodus gestartet verwendete Argumente: ";
        content["INFO_CREATING_FLEX_HOME"]="Erstelle Apache Flex home";
        content["INFO_CREATING_TEMP_DIR"]="Erstelle Temp Verzeichnis";
        content["INFO_CURRENT_LANGUAGE"]="Sprache wählen";
        content["INFO_DOWNLOADING_ADOBE_FLEX_SDK"]="Lade Adobe Flex SDK von: ";
        content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_MAC"]="Lade Adobe AIR Runtime Kit für Mac von: ";
        content["INFO_DOWNLOADING_AIR_RUNTIME_KIT_WINDOWS"]="Lade Adobe AIR Runtime Kit für Windows von: ";
        content["INFO_DOWNLOADING_FILE_FROM"]="Lade {0} von: {1} herunter";
        content["INFO_DOWNLOADING_FLEX_SDK"]="Lade Apache Flex SDK von: ";
        content["INFO_DOWNLOADED"]="Download abgeschlossen ";
        content["INFO_ENTER_VALID_FLEX_SDK_PATH"]="Bitte geben Sie einen gültigen Pfad für das FLex SDK ein";
        content["INFO_FINISHED_UNTARING"]="untar abgeschlossen: ";
        content["INFO_FINISHED_UNZIPPING"]="entpacken abgeschlossen: ";
        content["INFO_INSTALLATION_COMPLETE"]="Installation abgeschlossen";
        content["INFO_INSTALLING"]="Installiere...";
        content["INFO_INSTALLING_CONFIG_FILES"]="Installiere Framework Konfigurationsdateien für die Verwendung mit einer IDE";
        content["INFO_INSTALLING_PLAYERGLOBAL_SWC"]="Installiere Adobe Flash Player playerglobal.swc von: ";
        content["INFO_INVOKED_GUI_MODE"]="GUI modus gestartet";
        content["INFO_LICENSE_AGREEMENTS"]="Lizenzvereinbarung";
        content["INFO_NEED_TO_READ_AND_AGREE_TO_LICENSE"]="Dieser Installer wird Software von unterschiedlichen Seiten mit unterschiedlichen Lizenzen herunterladen. Bitte wählen Sie jedes Element auf der linken Seite aus, lesen Sie die jeweiligen Lizenzvereinbarungen und bestätigen Sie mit einem Häkchen, dass Sie den jeweiligen Bedingungen zustimmen.";
        content["INFO_SELECT_DIRECTORY"]="Wählen Sie das Verzeichnis in dem Sie das Flex SDK installieren wollen";
        content["INFO_SELECT_DIRECTORY_INSTALL"]="Installationsverzeichnis wählen";
        content["INFO_UNZIPPING"]="Entpacke: ";
        content["INFO_VERIFY_FLEX_SDK_DONE"]="Die Signatur der heruntergeladenen Dateien stimm mit der Apache Flex SDK MD5 Signature überein. Die Datei ist gültig.";
        content["INFO_WINDOW_TITLE"]="Installiere Apache Flex SDK {0} für die Verwendung mit Adobe Flash Builder";
        content["INSTALL_AGREE"] = "Ich Stimme zu, Installation Starten";
        content["INSTALL_AGREE_ALL"] = "Ich Stimme allen Optionen und Lizenzen zu, Installation starten";
        content["INSTALL_DISAGREE"] = "Ich Stimme nicht zu, nicht installieren";
        content["SELECT_PATH_PROMPT"]="In welches Verzeichnis soll das Apache Flex SDK installiert werden?";
        content["STEP_CREATE_DIRECTORIES"]="Erstelle Verzeichnisse";
        content["STEP_REQUIRED_INSTALL_APACHE_FLEX_SDK"]="Apache Flex SDK (Benötigt)";
        content["STEP_REQUIRED_INSTALL_ADOBE_AIR_SDK"]="Adobe AIR SDK (Benötigt)";
        content["STEP_REQUIRED_INSTALL_FLASH_PLAYER_GLOBAL_SWC"]="Adobe Flash Player playerglobal.swc (Benötigt)";
        content["STEP_REQUIRED_INSTALL_SWFOBJECT"]="SWFObject (Benötigt)";
        content["STEP_INSTALL_CONFIG_FILES"]="Installiere Framework Konfigurationsdateien";
        content["STEP_REQUIRED_INSTALL_OSMF"]="OSMF (Benötigt)";
        content["STEP_REQUIRED_INSTALL_TLF"]="Adobe Text Layout Framework (Benötigt)";
        content["STEP_OPTIONAL_INSTALL_BLAZEDS"]="BlazeDS (Optional)";
        content["STEP_OPTIONAL_INSTALL_FONTSWF"]="Adobe Bibliothek zur Einbettung von Schriften (Optional)";
        content["STEP_REQUIRED_UNZIP_AIR_RUNTIME_KIT"]="Entpacke Adobe AIR Runtime Kit";
        content["STEP_UNZIP_AIR_RUNTIME_KIT"]="Entpacke Adobe AIR Runtime Kit";
        content["STEP_UNZIP_FLEX_SDK"]="Entpacke Apache Flex SDK";
        content["STEP_VERIFY_FLEX_SDK"]="Verifiziere Apache Flex SDK MD5 Signature";
        content["LICENSE_APACHE_V2"]="Apache V2 Lizenz";
        content["LICENSE_URL_APACHE_V2"]="http://www.apache.org/licenses/LICENSE-2.0.html";
        content["LICENSE_ADOBE_SDK"]="Adobe Flex SDK Lizenzvereinbarung";
        content["LICENSE_URL_ADOBE_SDK"]="http://www.adobe.com/products/eulas/pdfs/adobe_flex_software_development_kit-combined-20110916_0930.pdf";
        content["LICENSE_ADOBE_AIR_SDK"]="Adobe AIR SDK Lizenzvereinbarung";
        content["LICENSE_URL_ADOBE_AIR_SDK"]="http://www.adobe.com/products/air/sdk-eula.html";
        content["LICENSE_SWFOBJECT"]="MIT Lizenz";
        content["LICENSE_URL_SWFOBJECT"]="http://opensource.org/licenses/mit-license.php";
        content["LICENSE_OSMF"]="Mozilla Public License Version 1.1";
        content["LICENSE_URL_OSMF"]="http://www.mozilla.org/MPL/";
        content["LICENSE_TLF"]="Mozilla Public License Version 1.1";
        content["LICENSE_URL_TLF"]="http://www.mozilla.org/MPL/";
        content["LICENSE_FONTSWF"]="Adobe Flex SDK Lizenzvereinbarung";
        content["LICENSE_URL_FONTSWF"]="http://www.adobe.com/products/eulas/pdfs/adobe_flex_software_development_kit-combined-20110916_0930.pdf";
        content["LICENSE_BLAZEDS"]="Adobe Flex SDK Lizenzvereinbarung";
        content["LICENSE_URL_BLAZEDS"]="http://www.adobe.com/products/eulas/pdfs/adobe_flex_software_development_kit-combined-20110916_0930.pdf";
        content["INFO_TRACKING"]="Es werden Informationen über die Nutzung dieser \n Anwendung per HTTP-Request gesammelt.";

        _resourceManager.addResourceBundle(resource);
    }


}
}

class SE {}