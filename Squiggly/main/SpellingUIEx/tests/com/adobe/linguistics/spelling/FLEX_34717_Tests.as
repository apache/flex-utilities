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

package com.adobe.linguistics.spelling {
    import com.adobe.linguistics.spelling.SpellUI;

    import mx.controls.TextArea;

    import org.flexunit.asserts.assertTrue;
    import org.fluint.uiImpersonation.UIImpersonator;

    public class FLEX_34717_Tests {
        private var _input:TextArea;

        [Before]
        public function setUp():void
        {
            _input = new TextArea();
        }

        [After]
        public function tearDown():void
        {
            _input = null;
        }

        [Test]
        public function test_immediate_disable_after_enable():void
        {
            //given
            UIImpersonator.addElement(_input);

            //when
            SpellUI.enableSpelling(_input, "en_US");
            SpellUI.disableSpelling(_input);

            //then
            assertTrue("If the unit test reaches this point, it means no RTE was thrown, which means the bug is not present", true);
        }
    }
}
