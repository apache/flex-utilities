'use strict';

var request = require('request');
var fs = require('fs');
var prompt = require('prompt');

var apacheMirrorsCGI = 'http://www.apache.org/dyn/mirrors/mirrors.cgi/';

//FlexJS
var pathToFlexJSBinary = 'flex/flexjs/0.5.0/binaries/';
var fileNameFlexJSBinary = 'apache-flex-flexjs-0.5.0-bin.zip';

//Falcon
var pathToFalconBinary = 'flex/falcon/0.5.0/binaries/';
var fileNameFalconBinary = 'apache-flex-falconjx-0.5.0-bin.zip';

//Adobe AIR
var AdobeAIRURL = 'http://airdownload.adobe.com/air/win/download/20.0/';
var fileNameAdobeAIR = 'AdobeAIRSDK.zip';

//Flash Player Global

var requestJSON = 'asjson=true';

var createDownloadsDirectory = function()
{
    try {
        fs.mkdirSync('downloads');
    } catch(e) {
        if ( e.code != 'EEXIST' ) throw e;
    }
}

var handleFlexJSMirrorsResponse = function (error, response, body)
{
    if (!error && response.statusCode == 200)
    {
        var mirrors = JSON.parse(body);
        var flexJSPreferredDownloadURL = mirrors.preferred + pathToFlexJSBinary + fileNameFlexJSBinary;
        //Download FlexJS
        //request(this.flexJSPreferredDownloadURL, handleFlexJSBinaryResponse);
        request
            .get(flexJSPreferredDownloadURL)
            .on('response', function(response) {
            })
            .pipe(fs.createWriteStream('downloads//' + fileNameFlexJSBinary));
    }

};

var handleFalconMirrorsResponse = function (error, response, body)
{
    if (!error && response.statusCode == 200)
    {
        var mirrors = JSON.parse(body);
        var falconPreferredDownloadURL = mirrors.preferred + pathToFalconBinary + fileNameFalconBinary;
        //Download Falcon
        request
            .get(falconPreferredDownloadURL)
            .on('response', function(response) {
            })
            .pipe(fs.createWriteStream('downloads//' + fileNameFalconBinary));
    }

};

var promptForAdobeAIR = function()
{
    var schema = {
        properties: {
            accept: {
                description: "Do you accept Adobe's license?",
                pattern: /^[YNyn\s]{1}$/,
                message: 'Please respond with either y or n',
                required: true
            }
        }
    };
    prompt.start();
    prompt.get(schema, function (err, result) {
        console.log('  accept?: ' + result.accept);
    });
};

createDownloadsDirectory();
request(apacheMirrorsCGI + pathToFlexJSBinary + fileNameFlexJSBinary + '?' + requestJSON, handleFlexJSMirrorsResponse);
request(apacheMirrorsCGI + pathToFalconBinary + fileNameFalconBinary + '?' + requestJSON, handleFalconMirrorsResponse);
promptForAdobeAIR();
//promptForFlashPlayerGlobal();

//Download Adobe AIR

//Download Flash Player Global