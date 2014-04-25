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
package
{
	import flash.display.Sprite;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.EditManager;
	
	import com.adobe.linguistics.spelling.SpellUIForTLF;
	
	public class SquigglyTLFExample extends Sprite
	{
		public function SquigglyTLFExample()
		{
			var markup:XML = <TextFlow xmlns='http://ns.adobe.com/textLayout/2008'><p><span>I know &nbsp;</span><span fontStyle='italic'>Enlish</span><span>. Use the context menu to see the suggestions of the missbelled word.</span></p></TextFlow>;
			var textFlow:TextFlow = TextConverter.importToFlow(markup, TextConverter.TEXT_LAYOUT_FORMAT);
			textFlow.flowComposer.addController(new ContainerController(this, 500, 600));
			textFlow.flowComposer.updateAllControllers();
			
			textFlow.interactionManager = new EditManager();
			
			SpellUIForTLF.enableSpelling(textFlow, "en_US");
		}
	}
}