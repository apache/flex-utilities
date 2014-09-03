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
package com.adobe.ac.pmd.view.model
{
    import com.adobe.ac.model.IPresentationModel;
    import com.adobe.ac.pmd.model.CharacterPosition;
    import com.adobe.ac.pmd.model.Violation;
    import com.adobe.ac.pmd.model.ViolationPriority;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.utils.ByteArray;
    
    import mx.collections.ArrayCollection;
    import mx.core.Application;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.mxml.HTTPService;

    [Event( name="violationsLoaded", type = "flash.events.Event" )]

    public class UploadModel extends EventDispatcher implements IPresentationModel
    {
        public static const VIOLATIONS_LOADED : String = "violationsLoaded";

        [ArrayElementType( "flash.net.FileFilter" )]
        private static const FILTERS : Array = [ new FileFilter( "Pmd results file", "pmd.xml" ) ];

        [Bindable]
        public var violations : ArrayCollection;

        private var fileReference : FileReference;

        public function UploadModel()
        {
            super();
        }

        public function tryToLoadFromParameters() : void
        {
            var report : String = Application.application.parameters.report;

            if ( report != "" )
            {
                var request : HTTPService = new HTTPService();
                
                request.useProxy = false;
                request.url = report;
                request.showBusyCursor = true;
                request.resultFormat = "xml";
                request.addEventListener( ResultEvent.RESULT, onDonwloadResult );
                request.send();
            }
        }

        public function load() : void
        {
            fileReference = new FileReference();
            fileReference.browse( FILTERS );
            fileReference.addEventListener( Event.SELECT, onSelect );
        }

        public function deserializeViolations( violationsXml : XML ) : ArrayCollection
        {
            var newViolations : ArrayCollection = new ArrayCollection();

            for each ( var fileXml : XML in violationsXml.file )
            {
                for each ( var violationXml : XML in fileXml.violation )
                {
                    newViolations.addItem( deserializeViolation( violationXml, fileXml.@name ) );
                }
            }
            return newViolations;
        }

        private function deserializeViolation( violationXml : XML, filePath : String ) : Violation
        {
        	var beginPosition : CharacterPosition = new CharacterPosition( 
        													violationXml.@beginline, 
        													violationXml.@begincolumn );
        	var endPosition : CharacterPosition = new CharacterPosition( 
        													violationXml.@endline, 
        													violationXml.@endcolumn );
            var violation : Violation = new Violation( beginPosition, endPosition, filePath );

            violation.rule.name = violationXml.@rule;
            violation.rule.ruleset.name = violationXml.@ruleset
            violation.rule.priority = ViolationPriority.create( violationXml.@priority );
            violation.rule.message = violationXml.toString();

            return violation;
        }

        private function onDonwloadResult( e : ResultEvent ) : void
        {
        	violations = deserializeViolations( new XML( e.result ) );

            dispatchEvent( new Event( VIOLATIONS_LOADED ) )
        }
        
        private function onSelect( e : Event ) : void
        {
            fileReference.addEventListener( Event.COMPLETE, onLoadComplete );
            fileReference.load();
        }

        private function onLoadComplete( e : Event ) : void
        {
            var data : ByteArray = fileReference.data;
            var xml : XML = new XML( data.readUTFBytes( data.bytesAvailable ) );

            violations = deserializeViolations( xml );

            dispatchEvent( new Event( VIOLATIONS_LOADED ) )
        }
    }
}