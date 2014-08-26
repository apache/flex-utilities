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
    import com.adobe.ac.pmd.model.Property;
    import com.adobe.ac.pmd.model.Rule;
    import com.adobe.ac.pmd.model.ViolationPriority;

    public class RuleTranslator
    {
        private static const INDENT : String = "        ";

        public static function deserialize( ruleXml : XML ) : Rule
        {
            var rule : Rule = new Rule();

            rule.since = ruleXml.@since;
            rule.name = ruleXml.attribute( "class" );
            rule.message = ruleXml.@message;

            for ( var childIndex : int = 0; childIndex < ruleXml.children().length(); childIndex++ )
            {
                var child : XML = ruleXml.children()[ childIndex ];
                var name : String = child.name().toString().replace( child.namespace() + "::", "" );

                deserializeChildren( rule, name, child.children() );
            }

            return rule;
        }

        public static function serialize( rule : Rule ) : XML
        {
            var xmlString : String = "<rule since=\"" + rule.since + "\" class=\"" + rule.name + "\" message=\"" + rule.message +
                "\">";

            xmlString += "<description>" + ( rule.description ? rule.description : "" ) + "</description>";
            xmlString += "<priority>" + ( rule.priority ? rule.priority.level : ViolationPriority.WARNING.level ) + "</priority>";

            if ( rule.properties.length > 0 )
            {
                xmlString += "<properties>";

                for each ( var property : Property in rule.properties )
                {
                    xmlString += "<property name=\"" + property.name + "\">";
                    xmlString += "<value>" + property.value + "</value>";
                    xmlString += "</property>";
                }
                xmlString += "</properties>";
            }

            if ( rule.examples )
            {
                xmlString += "<example><![CDATA[" + rule.examples + "]]></example>";
            }
            xmlString += "</rule>";
            return XML( xmlString );
        }

        private static function deserializeChildren( rule : Rule, propertyName : String, value : XMLList ) : void
        {
            switch ( propertyName )
            {
                case "priority":
                    rule.priority = ViolationPriority.create( Number( value.toString() ) );
                    break;
                case "description":
                    rule.description = value.toString();
                    break;
                case "properties":
                    rule.properties = PropertyTranslator.deserializeProperties( value );
                    break;
                case "example":
                    rule.examples = value.toString();
                    break;
                default:
                    break;
            }
        }
    }
}
