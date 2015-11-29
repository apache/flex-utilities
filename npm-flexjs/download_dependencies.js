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

'use strict';

var fs = require('fs');
var constants = require('./dependencies/Constants');
var adobeair = require('./dependencies/AdobeAIR');
var flashplayerglobal = require('./dependencies/FlashPlayerGlobal');
var apacheFlexJS = require('./dependencies/ApacheFlexJS');
var apacheFalcon = require('./dependencies/ApacheFalcon');
var swfObject = require('./dependencies/SWFObject');

function createDownloadsDirectory()
{
    //Create downloads directory if it does not exist already
    try
    {
        fs.mkdirSync(constants.DOWNLOADS_FOLDER);
    }
    catch(e)
    {
        if ( e.code != 'EEXIST' ) throw e;
    }
}

function handleFlashPlayerGlobalComplete(event)
{
    adobeair.on('complete', handleAdobeAIRComplete);
    adobeair.install();
}

function handleAdobeAIRComplete(event)
{
    apacheFlexJS.on('complete', handleApacheFlexJSComplete);
    apacheFlexJS.install();
}

function handleApacheFlexJSComplete(event)
{
    apacheFalcon.on('complete', handleApacheFalconComplete);
    apacheFalcon.install();
}

function handleApacheFalconComplete(event)
{
    swfObject.on('complete', handleSwfObjectComplete);
    swfObject.install();
}

function handleSwfObjectComplete(event)
{
    allDownloadsComplete();
}

function allDownloadsComplete()
{
    console.log('Completed all downloads');
}

createDownloadsDirectory();
flashplayerglobal.on('complete', handleFlashPlayerGlobalComplete);
flashplayerglobal.install();