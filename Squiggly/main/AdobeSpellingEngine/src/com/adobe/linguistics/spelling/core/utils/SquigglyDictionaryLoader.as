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


package com.adobe.linguistics.spelling.core.utils
{
	import com.adobe.linguistics.spelling.core.LinguisticRule;
	import com.adobe.linguistics.spelling.core.SquigglyDictionary;
	import com.adobe.linguistics.spelling.core.env.InternalConstants;
	import com.adobe.linguistics.spelling.core.error.*;
	import com.adobe.linguistics.spelling.core.logging.*;
	
	import flash.errors.IllegalOperationError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.*;
	public class SquigglyDictionaryLoader extends EventDispatcher
	{
		private var _dict:SquigglyDictionary;
		private var _dictionaryPath:String;
		private var _attrMgr:LinguisticRule;


		private var snp:SimpleNumberParser = new SimpleNumberParser();

		//setup logger for sending message.
		private var className:String = flash.utils.getQualifiedClassName(this).split("::").join(".");
		private var logger:ILogger = Log.getLogger( className );
		//vars shifted up
        private var wordList:Array;
		private var dp:String;//description;
		private var ts:String;
		private var ap:String;
		private var flags:String;
		
		private var dpPattern1:RegExp; 	//patterns to split rule line into fileds according to new morphological field separator
		private var dpPattern2:RegExp;	//patterns to split rule line into fileds according to old morphological field separator
		private var tsPattern1:RegExp;	//extracts the affix string
		private var strArr:Array;
		private var lineContent:String;
		private var totalPart:int;
		private var delay:int;
		//vars shifted up
		
		//variables added to accomodate property
		private var _enableDictionarySplit:Boolean;
		private var _wordsPerDictionarySplit:int;
		
		public function SquigglyDictionaryLoader()
		{
			_dict = null;
			_dictionaryPath = null;
			_attrMgr = null;
			dpPattern1= /^(.+)[ \t]+.{2}:(.+)$/ ; 	//patterns to split rule line into fileds according to new morphological field separator
			dpPattern2= /^(.+)[\t]{1}(.+)$/ ; 		//patterns to split rule line into fileds according to old morphological field separator
			tsPattern1= /^(.*[^\\])\/(.+)$/ ; 
			delay=InternalConstants.DICT_LOAD_DELAY; //the timeout period between two parts 10 ms
		}
		
		public function set linguisticRule(value:LinguisticRule):void {
			this._attrMgr = value;
		}
		
		public function get linguisticRule():LinguisticRule {
			return this._attrMgr;
		}
		
		public function load(dictionaryURL:String,enableDictionarySplit:Boolean,wordsPerDictionarySplit:int):void {
			if ( dictionaryURL == null ) {
				throw new IllegalOperationError("load function did not receive two valid URLs.");
			}
			_dictionaryPath = dictionaryURL;
			_enableDictionarySplit=enableDictionarySplit;
			_wordsPerDictionarySplit=wordsPerDictionarySplit;
			var request:URLRequest = new URLRequest( _dictionaryPath );
			var dloader:DictionaryLoader = new DictionaryLoader(request);
			dloader.addEventListener(Event.COMPLETE,loadDictionaryComplete);
			dloader.addEventListener(IOErrorEvent.IO_ERROR,handleError);
			dloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleError);
			
		}

		//Private method to dispatch an error event.
		private function handleError(evt:Event):void {
			bounceEvent(evt);
		}
		private function bounceEvent(evt:Event):void {
			dispatchEvent(evt.clone());
		}


		public function get squigglyDictionary():SquigglyDictionary {
			return  _dict;
		}
		
		private function loadDictionaryComplete(evt:Event):void {
			_dict = new SquigglyDictionary(_attrMgr);

			var bytes:ByteArray = evt.target.data;
			//trace("load complete handler: "+getTimer()+" "+bytes.bytesAvailable);
			var charSet:String;
			if ( _attrMgr ) {
				charSet = _attrMgr.encoding;
			}else {
				charSet = InternalConstants.DEFAULTENCODING;
			}
			var str:String = 	bytes.readMultiByte(bytes.length, charSet);
			//trace("Bytes read at: "+getTimer());

			/*
			In DOS, a line break is a single '\n'.
			In Unix, a line break is the sequence '\r\n'.
			In MAC, a line break is a single '\r'.
			Correct me if I'm wrong.
			so step 1:
			replace "\r\n" with "\n"
			step 2:
			replace "\r" with "\n";
			finally ,we get "\n" line seperator.
			*/
			str=str.split("\r\n").join("\n");
			str=str.split("\r").join("\n");
			wordList= str.split("\n");
			//bof of parsing the text.
			//trace("Wordlist length: "+wordList.length);
			if(wordList== null ) {
				logger.error("Dictionary File[{0}] Operation[parsing] Error[corrupt data]",this._dictionaryPath);
			}
			if(wordList.length== 1){
				logger.error("Dictionary File[{0}] Operation[parsing] Error[corrupt data]",this._dictionaryPath );
//				logger.error("Dictionary File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			} 
			//fix for 	Bug #: 	2855795 now if greater load to a max of wordList.length
			if(wordList.length<this._wordsPerDictionarySplit){
				this._wordsPerDictionarySplit=wordList.length;				
			}
			
			/* remove byte order mark */
			if ( wordList[0].match(new RegExp("^\xEF\xBB\xBF[.]+$") ) ) wordList[0]=wordList[0].substr(3);
			var snp:SimpleNumberParser = new SimpleNumberParser();
			/* get the table size */
			var tablesize:int = snp.parse(wordList[0]);
			if (tablesize == 0) throw new ContentError(ErrorTable.CONTENTPARSINGERROR_MSG,ErrorTable.CONTENTPARSINGERROR_ID);
			
			//trace("Before parsing: "+getTimer());
			
			if(this._enableDictionarySplit ){
				setTimeout(loadWithTimeouts,1,1);//go to loadWithTimeouts
			}
			else
			{	
				setTimeout(loadWithoutTimeouts,1,1);//directly go to finish. This will cause words to load from 1 to wordList.length
			}
			
		}
	
		private function loadWithTimeouts(part:int):void	{
			for( var line:int = part; line<part+(this._wordsPerDictionarySplit)-1; ++line) { 
				lineContent = wordList[line];
				/* : is the new morphological field separator */
				if ( (strArr = lineContent.match(dpPattern1)) != null ) {
					dp=strArr[2];
					ts = strArr[1];
				/* tabulator is the old morphological field separator */
				}else if ( (strArr = lineContent.match(dpPattern2)) != null ) {
					ts = strArr[1];
					dp=strArr[2];
				}else {
					ts = lineContent;//so ts has the word and dp has morphological desc
					dp = null;
				}
				
				ts= StringUtils.trim(ts);
				if( dp != null ) dp= StringUtils.trim(dp);
				// eof: split each line into word and morphological description

				// bof:split each line into word and affix char strings
				/*
				"\/" signs slash in words (not affix separator)
				"/" at beginning of the line is word character (not affix separator)
				*/
				if ( (strArr = ts.match(tsPattern1))!= null ) {
					ap = strArr[2]; 
					ts = strArr[1];
					ts = ts.split('\\/').join('/');	/* replace "\/" with "/" */
					if(_attrMgr){
						if(_attrMgr.aliasfTable && _attrMgr.aliasfTable.length>0)
						{ 
						flags=_attrMgr.aliasfTable[parseInt(ap,10)-1];
						}
						else
						{
						flags = decodeFlags( ap, _attrMgr.flagMode);
						}
					}
/*	
// Todo, will remove this comments after we have complex-affix support and compound-word support.
            if (aliasf) {
                int index = atoi(ap + 1);
                al = get_aliasf(index, &flags, dict);
                if (!al) {
                    HUNSPELL_WARNING(stderr, "error: line %d: bad flag vector alias\n", dict->getlinenum());
                    *ap = '\0';
                }
            } else {
                al = decode_flags(&flags, ap + 1, dict);
                flag_qsort(flags, 0, al);
            }
*/
				}else {
					ap=null;
					flags=null;
				}
				// eof:split each line into word and affix char strings
				//trace(line+" WORD:"+ts);
				_dict.addWord( ts, flags, dp );			
		}
				
				if(line+(this._wordsPerDictionarySplit)>=wordList.length)//Last part reached.
				{
					setTimeout(loadWithoutTimeouts,delay,line);//the last part left which is less than wordsPerDictionarySplit is loaded w/o Timeouts
				}
				else
				{
				setTimeout(loadWithTimeouts,delay, line);//get delay of 10 ms
				}
			// } //loop ends
			//eof of parsing the text.
			//function ends here
		}
		
		/* Squiggly function to end Asynchronous looping
		*
		*
		*/
		private function loadWithoutTimeouts(line:int):void
		{
			for( ; line<wordList.length; ++line) {
				
				// bof: split each line into word and morphological description 
				lineContent = wordList[line];
				/* : is the new morphological field separator */
				if ( (strArr = lineContent.match(dpPattern1)) != null ) {
					dp=strArr[2];
					ts = strArr[1];
					/* tabulator is the old morphological field separator */
				}else if ( (strArr = lineContent.match(dpPattern2)) != null ) {
					ts = strArr[1];
					dp=strArr[2];
				}else {
					ts = lineContent;
					dp = null;
				}
				ts= StringUtils.trim(ts);
				if( dp != null ) dp= StringUtils.trim(dp);
				// eof: split each line into word and morphological description
				
				// bof:split each line into word and affix char strings
				/*
				"\/" signs slash in words (not affix separator)
				"/" at beginning of the line is word character (not affix separator)
				*/
				if ( (strArr = ts.match(tsPattern1))!= null ) {
					ap = strArr[2]; 
					ts = strArr[1];
					ts = ts.split('\\/').join('/');	/* replace "\/" with "/" */
					if(_attrMgr)
					{
						if(_attrMgr.aliasfTable && _attrMgr.aliasfTable.length>0)
						{
						flags=_attrMgr.aliasfTable[parseInt(ap,10)-1];
						}
						else
						{
						flags = decodeFlags( ap, _attrMgr.flagMode);
						}
					}
					/*
					// Todo, will remove this comments after we have complex-affix support and compound-word support.
					if (aliasf) {
					int index = atoi(ap + 1);
					al = get_aliasf(index, &flags, dict);
					if (!al) {
					HUNSPELL_WARNING(stderr, "error: line %d: bad flag vector alias\n", dict->getlinenum());
					*ap = '\0';
					}
					} else {
					al = decode_flags(&flags, ap + 1, dict);
					flag_qsort(flags, 0, al);
					}
					*/
				}else {
					ap=null;
					flags=null;
				}
				// eof:split each line into word and affix char strings
				//trace("WORD2:"+ts);
				_dict.addWord( ts, flags, dp );			
			}
			//trace("After Parsing: "+getTimer());
			logger.info("Dictionary File[{0}] Operation[parsing] Total Lines:{1}, Unrecognized Lines:{2}", this._dictionaryPath ,wordList.length.toString(), 0  );
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		

		/*
		 * Squiggly is using utf16 by default...
		 * for utf8 string conversion,we need extra work later.
		 * we might also need a better toString() fuction for Flag_long and flag_num mode.
		 */
		private function decodeFlags(flags:String, flagMode:int):String {
			var result:String="";
			var i:int;
			switch ( flagMode )  {
				case InternalConstants.FLAG_LONG:
				if ( (flags.length)%2 == 1 ) {
					logger.error("Dictionary File[{0}] Operation[parsing] Error[decoding error] target flags:{1}",this._dictionaryPath , flags );
					throw new ContentError(ErrorTable.CONTENTPARSINGERROR_MSG,ErrorTable.CONTENTPARSINGERROR_ID);
				}
				var len:int = flags.length/2;
				for ( i = 0; i< len; ++i ) {
					result +=  String.fromCharCode( ((flags.charCodeAt((i * 2))) << 8) + (flags.charCodeAt((i * 2 + 1))) );
				}
				break;
				case InternalConstants.FLAG_NUM:
				var strArr:Array = flags.split(",");
				for ( i = 0;i< strArr.length;++i) {
					var num:Number = snp.parse(strArr[i]);
					if ( num >= InternalConstants.DEFAULTFLAGS ) {
						logger.error("Dictionary File[{0}] Operation[parsing] Error[decoding error] target flags:{1}",this._dictionaryPath , flags );
					}
					result += String.fromCharCode(num);
				}
				break;
				case InternalConstants.FLAG_UNI:
				result = flags;
				break;
				default:
				result = flags;
				break;
			}
			return result;
		}


	}
}