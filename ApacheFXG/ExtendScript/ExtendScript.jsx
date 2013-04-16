
gIsMac = File.fs == "Macintosh";
kAppVersion = parseFloat(app.version);

org_apache_utils = {};
org_apache_fxg_panel = {};

org_apache_utils.GetNativePath = function(uri){
	
	try{
		var file = File(uri);
		if(gIsMac){return file.absoluteURI}
		return file.fsName;
	}catch(err){
		return "";
	}
}
org_apache_utils.GetFile = function(title) {
	var fileName = "";
	var file = File.openDialog(title);
	if(file){
		if(gIsMac){
			fileName = file.absoluteURI;
		} else {
			fileName = file.fsName;
		}
	}
	return fileName;
}
org_apache_utils.GetFolder = function(title,sourceFolder){
	if(sourceFolder){
		try{
			var folder = Folder(sourceFolder).selectDlg(title);
		}catch(err){sourceFolder = ""}
	}
	if(!sourceFolder){
		var folderName = "";
		var folder = Folder.selectDialog(title);
	}
	if(folder){
		if(gIsMac){
			folderName = folder.absoluteURI;
		} else {
			folderName = folder.fsName;
		}
	}
	return folderName;
}
org_apache_utils.GetSaveFile = function(title){
	var fileName = "";
	var file = File.saveDialog(title);
	if(file){
		if(gIsMac){
			fileName = file.absoluteURI;
		} else {
			fileName = file.fsName;
		}
	}
	return fileName;

}
org_apache_fxg_panel.GetPluginDataFolder = function(){
	var userData = Folder.userData;
	return userData + "/Apache/FXG";
}


org_apache_utils.GetTempFolder = function(){
	var temp = Folder.temp;
	if(gIsMac){
		return temp.absoluteURI;
	} else {
		return temp.fsName;
	}
}