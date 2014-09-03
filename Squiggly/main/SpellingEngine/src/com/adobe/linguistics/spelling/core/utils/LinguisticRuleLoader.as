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
	import flash.utils.ByteArray;

	public class LinguisticRuleLoader extends EventDispatcher
	{
		private var _attrMgr:LinguisticRule;
		private var _rulePath:String;
		private var snp:SimpleNumberParser = new SimpleNumberParser();
		
		private var unrecognizedLines:int = 0;

		
		//setup logger for sending message.
		private var className:String = flash.utils.getQualifiedClassName(this).split("::").join(".");
		private var logger:ILogger = Log.getLogger( className );

		public function LinguisticRuleLoader()
		{
			init();
		}
		
		private function init():void {
			_attrMgr = null;
			_rulePath = null ;
			unrecognizedLines = 0;
			
		}

		public function load(ruleURL:String):void {
			if ( ruleURL == null) {
				throw new IllegalOperationError("Linguistics rule load function received an invalid URL.");
			}
			if ( this._attrMgr ) {
				logger.warn("You already did call the load function muliti-times, The orginal linguistic data will be overiden." );
				init();
			}
			_rulePath = ruleURL;
			var request:URLRequest = new URLRequest( _rulePath );
			var dloader:DictionaryLoader = new DictionaryLoader(request);
			dloader.addEventListener(Event.COMPLETE,loadRuleComplete);
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

		public function get linguisticRule():LinguisticRule {
			return _attrMgr;
		}

		private function loadRuleComplete(evt:Event):void {
			_attrMgr = new LinguisticRule();
			if( !_attrMgr ) {
				logger.fatal("Rule File[{0}] Operation[parsing]:Could not locate memory for Linguistic Rule", this._rulePath  );
				return;
			}
			var bytes:ByteArray = evt.target.data;
			detectEncoding(bytes);
			bytes.position = 0;
			parseRule(bytes);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function parseRule(bytes:ByteArray):void {
			
			var str:String = 	bytes.readMultiByte(bytes.length, _attrMgr.encoding);
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
			var lineContentArr:Array = str.split("\n");
			
			//bof of parsing the text.
			if( (lineContentArr== null) || (lineContentArr.length== 1) ) {
				logger.fatal("Rule File[{0}] Operation[parsing] has nothing in the file.", this._rulePath  );
				return;
			}
			/* remove byte order mark */
			if ( lineContentArr[0].match(new RegExp("^\xEF\xBB\xBF[.]+$") ) ) lineContentArr[0]=lineContentArr[0].substr(3);

			var lineContent:String;
			var res:int;
			for( var line:int = 0; line<lineContentArr.length; ) {
				lineContent= lineContentArr[line];
				
				
				if ( parseAttribute( lineContent, line ) ) {
					++line;
					continue;
				}
				//parsing for AF rule make aliasf table before loading alias rules
				if( (res=parseAliasf(lineContent, lineContentArr, line) ) !=0){
					++line;
					line+=res;
					continue;
				}
					
				if ( (res=parseAffix(lineContent, lineContentArr, line)) != 0 ) {
					line++;
					line += res;
					continue;
				}
				
				
				if ( (res=parseReplaceTable(lineContent, lineContentArr,line)) !=0 ) {
					line++;
					line += res;
					continue;
				}
				if ( (res=parseMapTable(lineContent, lineContentArr, line) ) != 0 ) {
					line++;
					line += res;
					continue;
				}
/*				//Parse phone table
				if ( (res=parsePhoneTable(lineContent, lineContentArr,line)) !=0 ) {
					line++;
					line += res;
					continue;
				}
*/				/*parse for ICONV/OCONV field*/
				if ((res=parseConvTable(lineContent, lineContentArr,line)) !=0 ) {
					line++;
					line+=res;
					continue;
				}
				
				/*parse for BREAK rule*/
				if ((res=parseBreakTable(lineContent, lineContentArr,line)) !=0 ) {
					line++;
					line+=res;
					continue;
				}
				
				if ( !isCommentOrEmpty( lineContent ) ) {
					line++;
					unrecognizedLines++;
					logger.warn("Rule File[{0}] Operation[parsing] Line Number:{1}, Content:{2}",this._rulePath , (line+1).toString(),lineContent );
					continue;
				}
				line++;
			}
			//eof of parsing the text.
			logger.info("Rule File[{0}] Operation[parsing] Total Lines:{1}, Unrecognized Lines:{2}", this._rulePath ,lineContentArr.length.toString(), unrecognizedLines.toString() );
			
		}

		private function detectEncoding(bytes:ByteArray):void {
			var str:String = 	bytes.readUTFBytes(bytes.length);
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
			var lineContentArr:Array = str.split("\n");
			
			//bof of parsing the text.
			if(lineContentArr== null ) {
				logger.fatal("Rule File[{0}] Operation[parsing] has nothing in the file.", this._rulePath  );
				return;
			}
			/* remove byte order mark */
			if ( lineContentArr[0].match(new RegExp("^\xEF\xBB\xBF[.]+$") ) ) lineContentArr[0]=lineContentArr[0].substr(3);

			var lineContent:String;
			var res:int;
			for( var line:int = 0; line<lineContentArr.length; ) {
				lineContent= lineContentArr[line];
				if ( parseEncoding( lineContent, line ) ) {
					break;
				}
				++line;
			}
			//eof of parsing the text.
			if( _attrMgr.encoding == null ) {
				logger.fatal("Rule File[{0}] Operation[parsing] Error[no encoding specified] in file.",this._rulePath );
				_attrMgr.encoding= InternalConstants.DEFAULTENCODING;
			}
			
		}
		
		private function parseEncoding(lineContent:String, lineNumber:int):Boolean {
			var result:String;
			/* parse in the name of the character set used by the .dict and .aff */
			if ( (result=parseStringAttribute("SET",lineContent)) != null ){
				if ( _attrMgr.encoding != null ) {
					//"error: line xxx: multiple definitions"
					logger.error("Rule File[{0}] Operation[parsing] Error[multiple definitions] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}else{ 
					result = getEncodingByString( result );
					if ( result == "" ) {
						logger.fatal("Rule File[{0}] Operation[parsing] Error[unsupported encoding] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent);
						result = InternalConstants.DEFAULTENCODING;
					}
					_attrMgr.encoding = result;
				}
				return true;
			}
			return false;
		}


		private function parseMapTable( lineContent:String, lineContentArray:Array, lineNumber:int ) :int {
			var res:int = 0;
			if ( !testKeyString("MAP",lineContent)  )
				return res;
			var seperatorPattern:RegExp = /[\t ]+/;
			if ( _attrMgr.mapFilterTable.length != 0 ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[multiple definitions] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			/*
			MAP number_of_map_definitions
			MAP string_of_related_chars
				We can define language-dependent information on characters that should be considered related (ie. nearer than other chars not in the set) in the affix file (.aff) by a character map table. With this table, Hunspell can suggest the right forms for words, which incorrectly choose the wrong letter from a related set more than once in a word. 
			For example a possible mapping could be for the German umlauted ü versus the regular u; the word Frühstück really should be written with umlauted u's and not regular ones
			MAP 1
			MAP uü
			word support in spell checking (forbidding generated compound words, if they are also simple words with typical fault). 
			*/
			var strArr:Array = lineContent.split(seperatorPattern);
			if ( strArr == null || strArr.length < 2 ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			var numberOfEntries:int = snp.parse(strArr[1]); 
			var parsedLines:int = 0;
			lineNumber++;
			while( lineNumber < lineContentArray.length && parsedLines<numberOfEntries ) {
				lineContent = lineContentArray[lineNumber];
				lineNumber++;
				parsedLines++;
				strArr = lineContent.split(seperatorPattern);
				if ( strArr == null || (strArr.length < 2) ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				if ( strArr[0]!="MAP" ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				var mapString:String =strArr[1];
				/* special handling for the rule file include mixed-case mapping string:
					MAP 5
					MAP aáAÁ
					MAP eéEÉ
					MAP iíIÍ
					MAP oóOÓ
					MAP uúüUÚÜ
				*/
				var capaType:int = StringUtils.getCapType(mapString);
				if ( capaType == InternalConstants.ALLCAP ||  capaType == InternalConstants.NOCAP ) {
					_attrMgr.addMapFilter(mapString);
				}else {
					var upperStr:String="";
					var lowerStr:String=""; 
					for ( var i:int=0;i< mapString.length;++i ) {
						if ( mapString.charAt(i) != mapString.charAt(i).toLocaleUpperCase() ) {
							lowerStr+=mapString.charAt(i);
						}else {
							upperStr+=mapString.charAt(i);
						}
					}
					_attrMgr.addMapFilter(upperStr);
					_attrMgr.addMapFilter(lowerStr);
				}
			}
			if ( parsedLines != numberOfEntries ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			return (numberOfEntries);
			
		}
		
		private function parseReplaceTable( lineContent:String, lineContentArray:Array, lineNumber:int ) :int {
			var res:int = 0;
			if ( !testKeyString("REP",lineContent)  )
				return res;
			var seperatorPattern:RegExp = /[\t ]+/;
			if ( _attrMgr.simpleFilterTable.length != 0 ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			/*
			REP number_of_replacement_definitions
			REP what replacement
			    We can define language-dependent phonetic information in the affix file (.aff) by a replacement table. 
			    First REP is the header of this table and one or more REP data line are following it. With this table, 
			    Hunspell can suggest the right forms for the typical faults of spelling when the incorrect form differs 
			    by more, than 1 letter from the right form. For example a possible English replacement table definition 
			    to handle misspelled consonants: 
			REP 8
			REP f ph
			REP ph f
			REP f gh
			REP gh f
			REP j dg
			REP dg j
			REP k ch
			REP ch k
			Replacement table is also usable in robust morphological analysis (accepting bad forms) or stricter compound 
			word support in spell checking (forbidding generated compound words, if they are also simple words with typical fault). 
			*/
			var strArr:Array = lineContent.split(seperatorPattern);
			if ( strArr == null || strArr.length != 2 ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			var numberOfEntries:int = snp.parse(strArr[1]); 
			var parsedLines:int = 0;
			lineNumber++;
			while( lineNumber < lineContentArray.length && parsedLines<numberOfEntries ) {
				lineContent = lineContentArray[lineNumber];
				lineNumber++;
				parsedLines++;
				strArr = lineContent.split(seperatorPattern);
				if ( strArr == null || (strArr.length != 3) ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				if ( strArr[0]!="REP" ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				var matchString:String =strArr[1];
				var replacement:String =strArr[2];
				_attrMgr.addSimpleFilter(matchString,replacement);
			}
			if ( parsedLines != numberOfEntries ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			return (numberOfEntries);
		}
		
		/*---------parse phone table
		Param: Line content, lince content array, and line number
		Return: number of parsed lines
		*/
/*		private function parsePhoneTable( lineContent:String, lineContentArray:Array, lineNumber:int ) :int {
			var res:int = 0;
			if ( !testKeyString("PHONE",lineContent)  )
				return res;
			var seperatorPattern:RegExp = /[\t ]+/;
			if ( _attrMgr.phoneTable ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			
			PHONE number_of_phone_definitions
			PHONE what replacement
			PHONE uses a table-driven phonetic transcription algorithm borrowed from Aspell. It is useful for
			languages with not pronunciation based orthography. You can add a full alphabet conversion and
			other rules for conversion of special letter sequences. For detailed documentation see
			http://aspell.net/man-html/Phonetic-Code.html. Note: Multibyte UTF-8 characters have not
			worked with bracket expression yet. Dash expression has signed bytes and not UTF-8 characters
			yet.
			
			var strArr:Array = lineContent.split(seperatorPattern);
			if ( strArr == null || strArr.length != 2 ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			var numberOfEntries:int = snp.parse(strArr[1]); 
			var parsedLines:int = 0;
			lineNumber++;
			//now parse the remaining lines
			while( lineNumber < lineContentArray.length && parsedLines<numberOfEntries ) {
				lineContent = lineContentArray[lineNumber];
				lineNumber++;
				parsedLines++;
				strArr = lineContent.split(seperatorPattern);
				if ( strArr == null || (strArr.length != 3) ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				if ( strArr[0]!="PHONE" ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				var matchString:String =strArr[1];
				var replacement:String =strArr[2];
				_attrMgr.phoneTable.addPhoneticFilter(matchString,replacement);//TODO: edit this
			}
			if ( parsedLines != numberOfEntries ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			return (numberOfEntries);
		}
*/		//---------parse phone table ends----//
		
		//---------parse conv table starts
		private function parseConvTable( lineContent:String, lineContentArray:Array, lineNumber:int ) :int {
			var res:int = 0;
			var ioflag:Boolean;
			var convTable:Array;
			if(testKeyString("ICONV",lineContent)!=false){
			//do for iconvtable	
			ioflag=true;
			convTable=_attrMgr.iconvFilterTable;
			}
			else if(testKeyString("OCONV",lineContent)!=false){
			//do for oconvtable
			ioflag=false;
			convTable=_attrMgr.oconvFilterTable;
			}
			else return res;
			
			var seperatorPattern:RegExp = /[\t ]+/;
			if ( (!convTable)||(convTable && convTable.length != 0 )) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			/*ICONV number_of_ICONV_definitions
			ICONV pattern pattern2
			Define input conversion table.
			OCONV number_of_OCONV_definitions
			OCONV pattern pattern2
			Define output conversion table.
			*/
			var strArr:Array = lineContent.split(seperatorPattern);
			if ( strArr == null || strArr.length != 2 ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			var numberOfEntries:int = snp.parse(strArr[1]); 
			var parsedLines:int = 0;
			lineNumber++;
			while( lineNumber < lineContentArray.length && parsedLines<numberOfEntries ) {
				lineContent = lineContentArray[lineNumber];
				lineNumber++;
				parsedLines++;
				strArr = lineContent.split(seperatorPattern);
				if ( strArr == null || (strArr.length != 3) ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				if ( strArr[0]!="REP" ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				var matchString:String =strArr[1];
				var replacement:String =strArr[2];
				_attrMgr.addConvFilter(matchString,replacement,ioflag);//todo
			}
			if ( parsedLines != numberOfEntries ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			return (numberOfEntries);
		}
		//--parse Convtable ends
		//--parse BreakTable starts
		private function parseBreakTable( lineContent:String, lineContentArray:Array, lineNumber:int ) :int {
			var res:int = 0;
			if( !testKeyString("BREAK",lineContent) )
				return res;
			
			var seperatorPattern:RegExp = /[\t ]+/;
			if ( _attrMgr && _attrMgr.breakTable && _attrMgr.breakTable.length != 0 ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			/*
			BREAK number_of_break_definitions
			BREAK character_or_character_sequence
			Define new break points for breaking words and checking word parts separately. Use ˆ and $ to
			delete characters at end and start of the word. Rationale: useful for compounding with joining
			character or strings (for example, hyphen in English and German or hyphen and n-dash in Hungarian).
			Dashes are often bad break points for tokenization, because compounds with dashes may
			contain not valid parts, too.) With BREAK, Hunspell can check both side of these compounds,
			breaking the words at dashes and n-dashes:
			BREAK 2
			BREAK -
			BREAK -- # n-dash
			*/
			var strArr:Array = lineContent.split(seperatorPattern);
			if ( strArr == null || strArr.length != 2 ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			var numberOfEntries:int = snp.parse(strArr[1]); 
			var parsedLines:int = 0;
			lineNumber++;
			while( lineNumber < lineContentArray.length && parsedLines<numberOfEntries ) {
				lineContent = lineContentArray[lineNumber];
				lineNumber++;
				parsedLines++;
				strArr = lineContent.split(seperatorPattern);
				if ( strArr == null || (strArr.length != 2) ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				if ( strArr[0]!="BREAK" ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
			if(_attrMgr.breakTable)	_attrMgr.breakTable.push(strArr[1]);
			}
			if ( parsedLines != numberOfEntries ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			return (numberOfEntries);
		}
		//--parse Breaktable Endas
		
		private function parseAffix(lineContent:String, lineContentArray:Array, lineNumber:int ) : int {
			var res:int = 0;
			if ( !testKeyString("PFX",lineContent) && !testKeyString("SFX",lineContent) )
				return res;
			var seperatorPattern:RegExp = /[\t ]+/;
			var slashInsidePattern:RegExp = /^(.+)\/(.+)$/
			
			var resStrArr:Array;
			
			/* 
			Affix classes are signed with affix flags. The first line of an affix class definition is the header. The fields of an affix class header:
			(0) Option name (PFX or SFX)
			(1) Flag (name of the affix class)
			(2) Cross product (permission to combine prefixes and suffixes). Possible values: Y (yes) or N (no)
			(3) Line count of the following rules. 
			*/
			var strArr:Array = lineContent.split( seperatorPattern );
			if ( strArr == null || strArr.length < 4 ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			// piece 1 - is type of affix
			var atype:int = (strArr[0]=="PFX") ? 0 : 1;
			 // piece 2 - is affix char
			var aflag:int = decodeFlag( strArr[1], this._attrMgr.flagMode );
			// piece 3 - is cross product indicator 
			var aPermission:Boolean = (strArr[2]=="Y") ? true : false;
			// piece 4 - is number of affentries
			var numberOfEntries:int = snp.parse(strArr[3]); 
			var stripStr:String;
			var affixStr:String;
			var conditionsStr:String;
			var morphStr:String;
			var conditionPattern:RegExp;
			var contclass:String;
			
			if ( numberOfEntries == 0 ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			
			var parsedLines:int = 0;
			lineNumber++;
			while( lineNumber < lineContentArray.length && parsedLines<numberOfEntries ) {
				var warnFlag:Boolean = false;
				lineContent = lineContentArray[lineNumber];
				lineNumber++;
				parsedLines++;
				/*
				Fields of an affix rules:
				(0) Option name
				(1) Flag
				(2) stripping characters from beginning (at prefix rules) or end (at suffix rules) of the word
				(3) affix (optionally with flags of continuation classes, separated by a slash)
				(4) condition.
				Zero stripping or affix are indicated by zero. Zero condition is indicated by dot. Condition is a simplified, regular expression-like pattern, which must be met before the affix can be applied. (Dot signs an arbitrary character. Characters in braces sign an arbitrary character from the character subset. Dash hasn’t got special meaning, but circumflex (^) next the first brace sets the complementer character set.)
				(5) Optional morphological fields separated by spaces or tabulators. 				
				*/
				strArr = lineContent.split(seperatorPattern);
				if ( strArr == null || (strArr.length < 5) ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				// piece 1 - is type of affix
				var aatype:int = (strArr[0]=="PFX") ? 0 : 1;
				if ( aatype != atype ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				 // piece 2 - is affix char
				var aaflag:int = decodeFlag( strArr[1],this._attrMgr.flagMode );
				if ( aaflag != aflag ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				// piece 3 - is string to strip or 0 for null 
				stripStr = strArr[2];
				if ( stripStr == "0" ) stripStr="";
				
				/*complex affix bof*/
				if ( (resStrArr=stripStr.match(slashInsidePattern)) != null ) {
					stripStr = resStrArr[1];
					warnFlag = true;
					logger.warn("Rule File[{0}] Operation[parsing] Warn[complex affix] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				/*complex affix eof*/
				
				// piece 4 - is affix string or 0 for null
				/*complex affix bof*/
				if (strArr[3] && (resStrArr=strArr[3].match(slashInsidePattern)) != null ) //if contclass in Affix Rules
				{
					if(this._attrMgr && this._attrMgr.aliasfTable && this._attrMgr.aliasfTable.length>0)//if AF rule 
					{
						affixStr = resStrArr[1];
						contclass=this._attrMgr.aliasfTable[parseInt(resStrArr[2],10)-1];
					}
					else// If not AF rule
					{
						affixStr =resStrArr[1];
						contclass=decodeFlags(resStrArr[2],this._attrMgr.flagMode);
						
					}
					
					this._attrMgr.haveContClass=true;
					
					for(var i:int=0;i<contclass.length; i++ )//record the possible contclass in possible contclass array
						this._attrMgr.contClasses[contclass.charCodeAt(i)]=true;
				}
				else
				{
					affixStr=strArr[3];
					contclass=null;
				}
				if ( affixStr == "0" ) affixStr="";
				if ( _attrMgr.ignoredChars != null ) StringUtils.removeIgnoredChars(affixStr, _attrMgr.ignoredChars );
				/*complex affix eof*/


				
				// piece 5 - is the conditions descriptions
				conditionsStr = strArr[4];
				if ( conditionsStr.length == 0 ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				
				//piece 6  morph information... ToDo....
				morphStr = (strArr.length == 6) ? strArr[5]: "";
			/*if(contclass && affixStr=="lit")	
				for(var c:int=0;c<contclass.length;c++){
				if(_attrMgr.flagMode== InternalConstants.FLAG_LONG)
					trace(" contclasslong   "+c+"           " + String.fromCharCode(contclass.charCodeAt(c)>>8)+String.fromCharCode(contclass.charCodeAt(c)-((contclass.charCodeAt(c)>>8)<<8)));
				else
					trace(" contclassnormal   "+c+"           " + contclass[c]);
			}*/
				_attrMgr.addAffixEntry( aflag, stripStr, affixStr, conditionsStr, morphStr, aPermission, atype, contclass );
				
			}
			if ( parsedLines != numberOfEntries ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			
			return (numberOfEntries);
		}
		
		//-------parseAliasf
		private function parseAliasf(lineContent:String, lineContentArray:Array, lineNumber:int ) : int {
			var res:int = 0;
			if ( !testKeyString("AF",lineContent))
				return res;
			var seperatorPattern:RegExp = /[\t ]+/;
			var slashInsidePattern:RegExp = /^(.+)\/(.+)$/
			
			var resStrArr:Array;
			
			/* 
			AF number_of_flag_vector_aliases
			AF flag_vector
			Hunspell can substitute affix flag sets with ordinal numbers in affix rules ( compression, see
			makealias tool). First example with  compression:
			3
			hello
			try/1
			work/2
			AF definitions in the affix file:
			SET UTF-8
			TRY esianrtolcdugmphbyfvkwzESIANRTOLCDUGMPHBYFVKWZ’
			AF 2
			AF A
			AF AB
			It is equivalent of the following dic file:
			3
			hello
			try/A
			work/AB
			*/
			var strArr:Array = lineContent.split(seperatorPattern);
			if ( strArr == null || strArr.length != 2 ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			var numberOfEntries:int = snp.parse(strArr[1]); 
			var parsedLines:int = 0;
			lineNumber++;
			while( lineNumber < lineContentArray.length && parsedLines<numberOfEntries ) {
				lineContent = lineContentArray[lineNumber];
				lineNumber++;
				parsedLines++;
				strArr = lineContent.split(seperatorPattern);
				if ( strArr == null || (strArr.length != 2) ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				if ( strArr[0]!="AF" ) {
					logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
				}
				//Decode Flags and store as long numbers. In normal case without AF rule we do this step later. Here we are decoding and storing the flags.
				var flags:String=decodeFlags(strArr[1],this._attrMgr.flagMode);
				_attrMgr.aliasfTable.push(flags);
			}
			if ( parsedLines != numberOfEntries ) {
				logger.error("Rule File[{0}] Operation[parsing] Error[corrupt data] Line Number:{1}, Content:{2}",this._rulePath , (lineNumber+1).toString(),lineContent );
			}
			return (numberOfEntries);
		}
		//--------parseAliasf
		//------decodeflags
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
						logger.error("Dictionary File[{0}] Operation[parsing] Error[decoding error] target flags:{1}",this._rulePath , flags );
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
							logger.error("Dictionary File[{0}] Operation[parsing] Error[decoding error] target flags:{1}",this._rulePath , flags );
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
//-----------decode flags ends
		
		
		private function decodeFlag( flagString:String, flag_mode:int=InternalConstants.FLAG_CHAR  ) : int {
			var s:int;
			var i:int;
			switch ( flag_mode ) {
				case InternalConstants.FLAG_LONG:
					if ( flagString.length != 2 ) {
						logger.error("Rule File[{0}] Operation[decodeFlag] Error[Unknown Flags] The length of flag id {1} is not equal 2.",this._rulePath , flagString);
					}
					s = ( flagString.charCodeAt(0) << 8) + flagString.charCodeAt(1);
					break;
				case InternalConstants.FLAG_NUM:
					i = snp.parse(flagString);
					if (i >= InternalConstants.DEFAULTFLAGS) {
						logger.error("Rule File[{0}] Operation[decodeFlag] Error[Unknown Flags] flag id {1} is too large (max: {2})",this._rulePath , i.toString(),InternalConstants.DEFAULTFLAGS.toString() );
					}
					s = i;
					break;
				case InternalConstants.FLAG_UNI: // utf-8
				default:
					s = flagString.charCodeAt(0);
			}
			return s;
		}

		private function parseFlagMode(lineContent:String, lineNumber:int):Boolean {
			var result:String;
			/* parse in the name of the character set used by the .dict and .aff */
			if ( (result=parseStringAttribute("FLAG",lineContent)) != null ){
	            if (result == "long") _attrMgr.flagMode = InternalConstants.FLAG_LONG;
	            if (result == "num") _attrMgr.flagMode = InternalConstants.FLAG_NUM;
	            if (result == "UTF-8") _attrMgr.flagMode = InternalConstants.FLAG_UNI;
	            if ( result == "char" ) _attrMgr.flagMode = InternalConstants.FLAG_CHAR;
				return true;
			}
			return false;
		}


		private function parseAttribute(lineContent:String, lineNumber:int):Boolean {
			var result:String;
			
			/* parse in the name of the character set used by the .dict and .aff */
			if ( parseFlagMode(lineContent,lineNumber) ){
				return true;
			}
			
			 /* parse in the keyboard string */
			if ( (result=parseStringAttribute("KEY",lineContent)) != null ){
				_attrMgr.keyString = result;
				return true;
			}
			
			/* parse in the try string */
			if ( (result=parseStringAttribute("TRY",lineContent)) != null ){
				if ( _attrMgr.tryString != null ) {
					//"error: line %d: multiple definitions\n"
					throw new ContentError(ErrorTable.CONTENTPARSINGERROR_MSG,ErrorTable.CONTENTPARSINGERROR_ID); 
				}else _attrMgr.tryString = result;
				return true;
			}
			
			/* parse in the name of the character set used by the .dict and .aff */
			if ( (result=parseStringAttribute("SET",lineContent)) != null ){
				return true;
			}
			
			/* parse in the noSuggest flag */
			if ( (result=parseStringAttribute("NOSUGGEST",lineContent)) != null ){
			//	_attrMgr.noSuggest = result.charCodeAt(0); //Depreceated old function, had to be changed for supporting FLAG_LONG
				_attrMgr.noSuggest = decodeFlag(result, this._attrMgr.flagMode);

				return true;
			}
			
			/* parse in the flag used by forbidden words */
			if ( (result=parseStringAttribute("FORBIDDENWORD",lineContent)) != null ){
				//_attrMgr.forbiddenWord = result.charCodeAt(0);//Depreceated old function, had to be changed for supporting FLAG_LONG
				_attrMgr.forbiddenWord = decodeFlag(result, this._attrMgr.flagMode);

				return true;
			}

			 /* parse in the ignored characters (for example, Arabic optional diacretics charachters */
			if ( (result=parseStringAttribute("IGNORE",lineContent)) != null ){
				if ( _attrMgr.ignoredChars != null ) {
					//"error: line %d: multiple definitions\n"
					throw new ContentError(ErrorTable.CONTENTPARSINGERROR_MSG,ErrorTable.CONTENTPARSINGERROR_ID); 
				}else _attrMgr.ignoredChars = result;
				return true;
			}

			/* parse in the extra word characters */
			if ( (result=parseStringAttribute("WORDCHARS",lineContent)) != null ){
				if ( _attrMgr.wordChars != null ) {
					//"error: line %d: multiple definitions\n"
					throw new ContentError(ErrorTable.CONTENTPARSINGERROR_MSG,ErrorTable.CONTENTPARSINGERROR_ID); 
				}else _attrMgr.wordChars = result;
				return true;
			}
			
			/* parse in the language for language specific codes */
			if ( (result=parseStringAttribute("LANG",lineContent)) != null ){
				if ( _attrMgr.languageCode != null ) {
					//"error: line %d: multiple definitions\n"
					throw new ContentError(ErrorTable.CONTENTPARSINGERROR_MSG,ErrorTable.CONTENTPARSINGERROR_ID); 
				}else {
					_attrMgr.languageCode = result;
					//langnum = get_lang_num(lang);
				}
				return true;
			}
			
			/* parse in the version */
			if ( (result=parseStringAttribute("VERSION",lineContent)) != null ){
				_attrMgr.version = result;
				return true;
			}

			if ( (result=parseStringAttribute("MAXNGRAMSUGS",lineContent)) != null ){
				_attrMgr.maxNgramSuggestions = snp.parse(result);
				return true;
			}
			
			if ( testKeyString("NOSPLITSUGS",lineContent) ) {
				_attrMgr.nosplitSuggestions = 1;
			}
			
			if ( testKeyString("SUGSWITHDOTS",lineContent) ) {
				_attrMgr.suggestionsWithDots = 1;
			}
			
			if ( testKeyString("FULLSTRIP",lineContent) ) {
				_attrMgr.fullStrip = 1;
			}
			/* parse in the noSuggest flag */
			if ( (result=parseStringAttribute("KEEPCASE",lineContent)) != null ){
				//_attrMgr.keepCase = result.charCodeAt(0);//Depreceated old function, had to be changed for supporting FLAG_LONG
				_attrMgr.keepCase = decodeFlag(result, this._attrMgr.flagMode);
				return true;
			}
			
			/*parse in the CIRCUMFIX flag*/
			if ( (result=parseStringAttribute("CIRCUMFIX",lineContent)) != null ){
			//	_attrMgr.circumfix =result.charCodeAt(0);//Depreceated old function, had to be changed for supporting FLAG_LONG
				_attrMgr.circumfix =decodeFlag(result, this._attrMgr.flagMode);
				return true;
			}
			/*parse in the NEEDAFFIX flag*/
			if ( (result=parseStringAttribute("NEEDAFFIX",lineContent)) != null ){
				//_attrMgr.needAffix = result.charCodeAt(0); ////Depreceated old function, had to be changed for supporting FLAG_LONG
				_attrMgr.needAffix = decodeFlag(result, this._attrMgr.flagMode);
				return true;
			}
			
		return false;
		}
		
		private function parseStringAttribute(key:String, lineContent:String):String {
			if ( lineContent == null || key == null ) return null;
			var keyPattern:RegExp = new RegExp("^"+key+"[\\t ]+(.+)$");
			var parseArr:Array;
			if ( (parseArr=lineContent.match(keyPattern)) != null ) {
				return parseArr[1];
			}		
			return null;
		}
		
		private function testKeyString(key:String,lineContent:String):Boolean {
			if ( key == null ) return false;
			var keyPattern:RegExp = new RegExp("^"+key+".*$");
			return keyPattern.test( lineContent );
		}

		private function isCommentOrEmpty(lineContent:String):Boolean{
			var str:String = lineContent;
			str = StringUtils.trim( lineContent);
			if ( str == "" ) return true;
			if ( testKeyString("#",str) ) return true;
			return false;
		}

		private function getEncodingByString(key:String):String {
			var result:String = "";
			var keyEncodingTable:Object = {"UTF-8":"utf-8", "ISO8859-1":"iso-8859-1","ISO8859-2":"iso-8859-2","ISO8859-3":"iso-8859-3",
			"ISO8859-4":"iso-8859-4","ISO8859-5":"iso-8859-5","ISO8859-6":"iso-8859-6","ISO8859-7":"iso-8859-7","ISO8859-8":"iso-8859-8",
			"ISO8859-9":"iso-8859-9", "ISO8859-15":"iso-8859-15", "KOI8-R":"koi8-r", "KOI8-U":"koi8-u", "microsoft-cp1251":"windows-1251", 
			"ISCII-DEVANAGARI":"x-iscii-de"};
			var unsupportedTable:Object = {"ISO8859-10":"", "ISO8859-13":""};
			if ( key == null ) return InternalConstants.DEFAULTENCODING;
			
			if ( keyEncodingTable[key] == undefined || keyEncodingTable[key] == "" ) return result;
			result = keyEncodingTable[key];
			
			return result;
		}

	}
}