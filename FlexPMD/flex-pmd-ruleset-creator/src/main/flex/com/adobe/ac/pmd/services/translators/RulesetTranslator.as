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
package com.adobe.ac.pmd.services.translators
{
    import com.adobe.ac.pmd.model.Rule;
    import com.adobe.ac.pmd.model.Ruleset;
    import com.adobe.ac.pmd.model.RootRuleset;

    public class RulesetTranslator
    {
        public static function deserialize( xml : XML ) : Ruleset
        {
            var ruleset : Ruleset = new Ruleset();
            var children : XMLList = xml.children();

            ruleset.name = xml.@name;

            for ( var i : int = 1; i < children.length(); i++ )
            {
                var ruleXml : XML = children[ i ];

                var rule : Rule = RuleTranslator.deserialize( ruleXml );

                rule.ruleset = ruleset;
                ruleset.rules.addItem( rule );
                ruleset.isRef = false;
            }

            return ruleset;
        }

        public static function serializeRootRuleset( ruleset : Ruleset ) : XML
        {
            var xmlString : String = "<ruleset name=\"" + ruleset.name + "\"" + "xmlns=\"http://pmd.sf.net/ruleset/1.0.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"" +
                "xsi:schemaLocation=\"http://pmd.sf.net/ruleset/1.0.0 http://pmd.sf.net/ruleset_xml_schema.xsd\"" + "xsi:noNamespaceSchemaLocation=\"http://pmd.sf.net/ruleset_xml_schema.xsd\">" +
                "<description>" + ( ruleset.description ? ruleset.description : "" ) + "</description>";

            for each ( var rule : Rule in ruleset.rules )
            {
                xmlString += RuleTranslator.serialize( rule ).toXMLString();
            }
            xmlString += "</ruleset>";

            return XML( xmlString );
        }
    }
}