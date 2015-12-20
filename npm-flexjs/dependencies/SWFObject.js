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

var SWFObject = module.exports = Object.create(events.EventEmitter.prototype);

//SWFObject
//var swfObjectURL = 'https://github.com/swfobject/swfobject/archive/2.2.zip';
var swfObjectURL = 'https://swfobject.googlecode.com/files/';
var fileNameSwfObject = 'swfobject_2_2.zip';

SWFObject.downloadSwfObject = function()
{
    console.log('Downloading SWFObject');
    request
        .get(swfObjectURL)
        .pipe(fs.createWriteStream(constants.DOWNLOADS_FOLDER + fileNameSwfObject)
            .on('finish', function(){
                console.log('SWFObject download complete');
                SWFObject.emit('complete');
            })
    );
};

SWFObject.install = function()
{
    SWFObject.downloadSwfObject();
};