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





package com.adobe.linguistics.spelling.utils
{
	[RemoteClass]
	public class WordList
	{
		private var _words:Array;
		private var _sorted:Boolean;  // TODO: Shouldn't be always sorted?

		public function WordList(wordsList:Array=null)
		{
			if(wordsList!=null) {
				_words=wordsList;	
			}else {
				_words=new Array();
			}
			
		}
		
		public function toArray():Array {
			return this._words;
		}

		public function set data(inData:Array):void {
			this._words = inData;
		}
		
		public function get data():Array {
			return this._words;
		}
		
		public function insert(value:String):Boolean {
			if( _words.length==0 ) {
				_words.push(value)
				return true;
			}
			var low:uint= 0;
			var high:uint= _words.length-1;
			var middle:uint= (low+high)/2;
			while (low<high) {
				if(_words[middle]<value) {
					low=middle+1;
				}else {
					high=middle;
				}
				middle= (low+high)/2;
			}
			if( (low <= _words.length-1) && (_words[low]!=value) ) {
				var pos:uint=_words[low]>value?low:low+1;
				_words.splice(pos,0,value);
				return true;
			}else {
				return false;
			}
			_words.push(value);
			return true;
		}
		
		public function remove(value:String):Boolean {
			var pos:int= lookup(value);
			if( pos!= -1 ) {
				_words.splice(pos,1);
				return true;
			}else {
				return false;
			}
		}
		
		//binary search to find the word.
		public function lookup(value:String):int {
			if(_words.length==0) {
				return -1;
			}
			var low:uint= 0;
			var high:uint= _words.length-1;
			var middle:uint= (low+high)/2;
			while (low<high) {
				if(_words[middle]<value) {
					low=middle+1;
				}else {
					high=middle;
				}
				middle= (low+high)/2;
			}
			if( (low <= _words.length-1) && (_words[low]==value) ) {
				return low;
			}else {
				return -1;
			}
			
		}
		
		public function mergeWordLists(list1:WordList,list2:WordList):WordList {
			return null;
		}

	}
}