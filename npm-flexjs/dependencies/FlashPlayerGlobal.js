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
var prompt = require('prompt');

var constants = require('../dependencies/Constants');

var FlashPlayerGlobal = module.exports = Object.create(events.EventEmitter.prototype);

var flashPlayerGlobalURL = 'http://download.macromedia.com/get/flashplayer/updaters/19/';
var fileNameFlashPlayerGlobal = 'playerglobal19_0.swc';
var flashPlayerGlobalPromptText = "\
    Apache Flex SDK uses the Adobe Flash Player's playerglobal.swc to build Adobe Flash applications.\n\
    \n\
    The playerglobal.swc file is subject to and governed by the\n\
    Adobe Flex SDK License Agreement specified here:\n\
    http://www.adobe.com/products/eulas/pdfs/adobe_flex_software_development_kit-combined-20110916_0930.pdf,\n\
    By downloading, modifying, distributing, using and/or accessing the playerglobal.swc file\n\
    you agree to the terms and conditions of the applicable end user license agreement.\n\
    \n\
    In addition to the Adobe license terms, you also agree to be bound by the third-party terms specified here:\n\
    http://www.adobe.com/products/eula/third_party/.\n\
    Adobe recommends that you review these third-party terms.\n\
    \n\
    This license is not compatible with the Apache v2 license.\n\
    Do you want to download and install the playerglobal.swc? (y/n)";

FlashPlayerGlobal.promptForFlashPlayerGlobal = function()
{
    var schema = {
        properties: {
            accept: {
                description: flashPlayerGlobalPromptText.cyan,
                pattern: /^[YNyn\s]{1}$/,
                message: 'Please respond with either y or n'.red,
                required: true
            }
        }
    };
    prompt.start();
    prompt.get(schema, function (err, result) {
        if(result.accept.toLowerCase() == 'y')
        {
            FlashPlayerGlobal.downloadFlashPlayerGlobal();
        }
    });
};

FlashPlayerGlobal.downloadFlashPlayerGlobal = function()
{
    console.log('Downloading Adobe FlashPlayerGlobal.swc ');
    request
        .get(flashPlayerGlobalURL + fileNameFlashPlayerGlobal)
        .pipe(fs.createWriteStream(constants.DOWNLOADS_FOLDER + fileNameFlashPlayerGlobal)
            .on('finish', function(){
                console.log('FlashPlayerGlobal download complete');
                FlashPlayerGlobal.emit('complete');
            })
    );
};

FlashPlayerGlobal.install = function()
{
    FlashPlayerGlobal.promptForFlashPlayerGlobal();
};