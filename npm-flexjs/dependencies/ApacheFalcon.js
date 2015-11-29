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

var constants = require('../dependencies/Constants');

var ApacheFalcon = module.exports = Object.create(events.EventEmitter.prototype);

//Falcon
var pathToFalconBinary = 'flex/falcon/0.5.0/binaries/';
var fileNameFalconBinary = 'apache-flex-falconjx-0.5.0-bin.zip';

ApacheFalcon.handleFalconMirrorsResponse = function (error, response, body)
{
    if (!error && response.statusCode == 200)
    {
        var mirrors = JSON.parse(body);
        var falconPreferredDownloadURL = mirrors.preferred + pathToFalconBinary + fileNameFalconBinary;
        console.log('Downloading Apache Falcon');
        request
            .get(falconPreferredDownloadURL)
            .pipe(fs.createWriteStream('downloads//' + fileNameFalconBinary)
                .on('finish', function(){
                    console.log('Apache Falcon download complete');
                    ApacheFalcon.emit('complete');
                })
        );
    }

};

ApacheFalcon.install = function()
{
    request(constants.APACHE_MIRROR_RESOLVER_URL + pathToFalconBinary + fileNameFalconBinary + '?' + constants.REQUEST_JSON_PARAM, ApacheFalcon.handleFalconMirrorsResponse);
};