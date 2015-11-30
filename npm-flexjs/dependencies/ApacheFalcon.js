/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */


var request = require('request');
var fs = require('fs');
var events = require('events');
var unzip = require('unzip');

var constants = require('../dependencies/Constants');
var duc = require('../dependencies/DownloadUncompressAndCopy');

var ApacheFalcon = module.exports = Object.create(events.EventEmitter.prototype);

//Falcon
var pathToFalconBinary = 'flex/falcon/0.5.0/binaries/';
var fileNameFalconBinary = 'apache-flex-falconjx-0.5.0-bin.zip';
var falconCompilerLibFolder = 'falcon/compiler/lib/';

//Antlr
var antlrURL = 'http://search.maven.org/remotecontent?filepath=org/antlr/antlr-complete/3.5.2/antlr-complete-3.5.2.jar';
var localFileNameAntlr = 'antlr.jar';

var apacheCommonsURL = 'http://archive.apache.org/dist/commons/cli/binaries/';
var fileNameApacheCommons = 'commons-cli-1.2-bin.zip';
var localFileNameApacheCommons = 'commons-cli.jar';

var falconDependencies = [
    {
        url:'http://search.maven.org/remotecontent?filepath=org/antlr/antlr-complete/3.5.2/',
        remoteFileName:'antlr-complete-3.5.2.jar',
        destinationPath:constants.DOWNLOADS_FOLDER + falconCompilerLibFolder,
        destinationFileName:'antlr.jar',
        unzip:false
    },
    {
        url:'http://archive.apache.org/dist/commons/cli/binaries/',
        remoteFileName:'commons-cli-1.2-bin.zip',
        destinationPath:constants.DOWNLOADS_FOLDER,
        destinationFileName:'',
        pathOfFileToBeCopiedFrom:constants.DOWNLOADS_FOLDER + 'commons-cli-1.2/commons-cli-1.2.jar',
        pathOfFileToBeCopiedTo:constants.DOWNLOADS_FOLDER + falconCompilerLibFolder + 'commons-cli.jar',
        unzip:true
    },
    {
        url:'http://archive.apache.org/dist/commons/io/binaries/',
        remoteFileName:'commons-io-2.4-bin.zip',
        destinationPath:constants.DOWNLOADS_FOLDER,
        destinationFileName:'',
        pathOfFileToBeCopiedFrom:constants.DOWNLOADS_FOLDER + 'commons-io-2.4/commons-io-2.4.jar',
        pathOfFileToBeCopiedTo:constants.DOWNLOADS_FOLDER + falconCompilerLibFolder + 'commons-io.jar',
        unzip:true
    }
];

ApacheFalcon.handleFalconMirrorsResponse = function (error, response, body)
{
    if (!error && response.statusCode == 200)
    {
        var mirrors = JSON.parse(body);
        var falconPreferredDownloadURL = mirrors.preferred + pathToFalconBinary + fileNameFalconBinary;
        console.log('Downloading Apache Falcon');
        request
            .get(falconPreferredDownloadURL)
            .pipe(fs.createWriteStream(constants.DOWNLOADS_FOLDER + fileNameFalconBinary)
                .on('finish', function(){
                    console.log('Apache Falcon download complete');
                    ApacheFalcon.extract();
                })
        );
    }
};

ApacheFalcon.extract = function()
{
    console.log('Extracting Apache Falcon');
    fs.createReadStream(constants.DOWNLOADS_FOLDER + fileNameFalconBinary)
        .pipe(unzip.Extract({ path: constants.DOWNLOADS_FOLDER + 'falcon'})
            .on('finish', function(){
                console.log('Apache Falcon extraction complete');
                ApacheFalcon.prepareForFalconDependencies();
            })
    );
};

ApacheFalcon.prepareForFalconDependencies = function()
{
    //Create lib directory if it does not exist already
    try
    {
        fs.mkdirSync(constants.DOWNLOADS_FOLDER + falconCompilerLibFolder);
    }
    catch(e)
    {
        if ( e.code != 'EEXIST' ) throw e;
    }
    ApacheFalcon.downloadDependencies();
};

var currentStep = -1;

ApacheFalcon.downloadDependencies = function()
{
    ApacheFalcon.downloadNextDependency();
};

ApacheFalcon.downloadNextDependency = function()
{
    currentStep += 1;

    if(currentStep >= falconDependencies.length)
    {
        ApacheFalcon.dependenciesComplete();
    }
    else
    {
        duc.on("downloadComplete", handleDependencyInstallComplete);
        duc.install(falconDependencies[currentStep]);
    }
};

function handleDependencyInstallComplete(event)
{
    ApacheFalcon.downloadNextDependency();
}

ApacheFalcon.dependenciesComplete = function()
{
    ApacheFalcon.falconInstallComplete();
};

ApacheFalcon.falconInstallComplete = function()
{
    ApacheFalcon.emit('complete');
};

ApacheFalcon.install = function()
{
    request(constants.APACHE_MIRROR_RESOLVER_URL + pathToFalconBinary + fileNameFalconBinary + '?' + constants.REQUEST_JSON_PARAM, ApacheFalcon.handleFalconMirrorsResponse);
};