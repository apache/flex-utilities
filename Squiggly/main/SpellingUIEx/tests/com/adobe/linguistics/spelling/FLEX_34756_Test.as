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
    import com.adobe.linguistics.spelling.framework.SpellingService;
    import com.adobe.linguistics.spelling.framework.ui.IHighlighter;

    import flash.events.Event;
    import flash.events.IEventDispatcher;

    import flashx.textLayout.edit.EditManager;
    import flashx.textLayout.elements.FlowElement;
    import flashx.textLayout.elements.ParagraphElement;
    import flashx.textLayout.elements.SpanElement;

    import mockolate.nice;
    import mockolate.prepare;
    import mockolate.received;
    import mockolate.stub;

    import org.flexunit.assertThat;
    import org.flexunit.asserts.assertTrue;
    import org.flexunit.async.Async;
    import org.fluint.uiImpersonation.UIImpersonator;

    import spark.components.RichEditableText;

    public class FLEX_34756_Test {
        private static var _textField:RichEditableText;
        private static var _sut:SpellUI;
        private static const TEXT_WITH_SPELLING_ERROR:String = "helloo";
        private static const DICT:String = "en_GB";

        [Before(async, timeout=5000)]
        public function setUp():void
        {
            _textField = new RichEditableText();
            UIImpersonator.addChild(_textField);
            _textField.text = TEXT_WITH_SPELLING_ERROR;

            var mockolateDispatcher:IEventDispatcher = prepare(IHighlighter, SpellingService);
            mockolateDispatcher.addEventListener(Event.COMPLETE, Async.asyncHandler(this, onSetUpComplete, 5000, null, null));
        }

        private static function onSetUpComplete(event:Event, passThroughData:Object):void
        {
            SpellUIForTest.sparkHighlighter = nice(IHighlighter);
            SpellUIForTest.spellingService = nice(SpellingService, "spellingService", [DICT]);

            _sut = new SpellUIForTest(_textField, DICT);
        }

        [After]
        public function tearDown():void
        {
            UIImpersonator.removeAllChildren();
            _textField = null;
            _sut = null;
        }

        [Test(async, timeout=2500)]
        public function make_sure_it_doesnt_run_a_spelling_job_on_damaged_text_flow():void
        {
            //when
            stub(SpellUIForTest.spellingService).method("init").dispatches(new Event(Event.COMPLETE));
            SpellUI.enableSpelling(_textField, "en_GB");
            SpellUIForTest.eventDispatcher.addEventListener(Event.COMPLETE, Async.asyncHandler(this, onDictionaryLoadComplete, 1500, null, null));
        }

        private function onDictionaryLoadComplete(event:Event, passThroughData:Object):void
        {
            //given
            damageTextFlow();

            //when
            _sut.doSpellingJob();

            //then
            //doSpellingJob() is also called once after the dictionary finishes loading, hence 'atMost(1)' below
            assertThat(SpellUIForTest.sparkHighlighter, received().method("clearSquiggles").atMost(1));
            assertThat(SpellUIForTest.spellingService, received().method("checkWord").never());
        }

        private function damageTextFlow():void
        {
            var editManager:EditManager = _textField.textFlow.interactionManager as EditManager;
            var firstLine:FlowElement = editManager.textFlow.findLeaf(0);
            var paragraph:ParagraphElement = firstLine.getParagraph();
            var span:SpanElement = new SpanElement();
            span.text = "  •  ";
            paragraph.addChildAt(0, span);

            assertTrue(_textField.textFlow.flowComposer.isDamaged(_textField.textFlow.textLength));
        }
    }
}

import com.adobe.linguistics.spelling.SpellUI;
import com.adobe.linguistics.spelling.framework.SpellingService;
import com.adobe.linguistics.spelling.framework.ui.HaloHighlighter;
import com.adobe.linguistics.spelling.framework.ui.IHighlighter;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;

class SpellUIForTest extends SpellUI
{
    public static var sparkHighlighter:IHighlighter;
    public static var spellingService:SpellingService;
    public static var eventDispatcher:IEventDispatcher = new EventDispatcher();
    private static var _timer:Timer = new Timer(100, 1);

    public function SpellUIForTest(textModel:*, lang:String)
    {
        _timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
        super(textModel, lang);
    }

    private function onTimer(event:TimerEvent):void
    {
        eventDispatcher.dispatchEvent(new Event(Event.COMPLETE));
    }

    override protected function createHighlighter(isHaloComoponent:Boolean, parent:*):IHighlighter
    {
        //we're not dispatching the complete event just yet because this function is called before
        //some extra processing is done after the dictionary is loaded. See SpellUI.addContextMenu()
        _timer.stop();
        _timer.reset();
        _timer.start();

        return isHaloComoponent ? new HaloHighlighter(parent) : sparkHighlighter;
    }

    override protected function createSpellingService(dictionaryName:String):SpellingService
    {
        return spellingService;
    }

}
