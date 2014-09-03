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
	import com.adobe.linguistics.spelling.core.env.InternalConstants;
	public final class StringUtils
	{
		
	    public static function isWhiteSpace( ch:Number ):Boolean {
	    	// '\r' || '\n' || '\f' || '\t' || ' ' 
	    	
	    	return ch == 32 || 
	    	ch == 32 || 
	    	ch == 32 || 
	    	ch == 32 || 
	    	ch == 32; 
	    }
	    public static function isWhiteSpace2( ch:String ):Boolean {
	    	// '\r' || '\n' || '\f' || '\t' || ' ' 
	    	
	    	return ch == '\r' || 
	    	ch == '\n' || 
	    	ch == '\f' || 
	    	ch == '\t' || 
	    	ch == ' '; 
	    }
    
	    public static function trim( original:String ):String {
	    	var i:int;
	    	var start:int=0, end:int=original.length;
	    	for ( i=0; (i< original.length) && isWhiteSpace(original.charCodeAt(i)) ; ++i ) {
	    		start++;
	    	}
	    	for ( i=end-1; (i>=0) && isWhiteSpace(original.charCodeAt(i)) ; --i) {
	    		end--;
	    	}
	    	return original.substring(start,end);
	    }
	    
		/*
		 * Deprecated function for now...
		 * History: 
		 *          A pre-version of implementation for error detection. After I optimized the code for performance,
		 *          I drop this function by that time, but you know performance meassuring is a tricky problem... 
		 * ToDo: Need a revisit when we implementing complex-affix support and compound-word support.
		 */
	    public static function trim2( original:String ):String {

	      var characters:Array = original.split( "" );
	      for ( var i:int = 0; i < characters.length; i++ ) {
	        if ( isWhiteSpace2( characters[i] ) ) {
	          characters.splice( i, 1 );
	          i--;
	        } else {
	          break;
	        }
	      }
	      for ( i = characters.length-1; i >= 0; i-- ) {
	      	if (isWhiteSpace2( characters[i] )) {
	      		characters.splice( i, 1 );
	      	}else {
	      		break;
	      	}
	      }
	      return characters.join("");
	    }
	    
	    /*
	     * ideally, this function shouldn't be here, we should always get a word without any ill-formed character. 
	     * ToDo, will create a normalization class in next release....
	     * Need revisit this function.
	     */
	    public static var curlyQuotePattern:RegExp = /[‘’]/;
	    public static function normalize( value:String ):String {
	    	var result:String;
	    	if ( (value.indexOf("‘") == -1) && (value.indexOf("’") == -1) ) return value;
	    	result = value.replace(curlyQuotePattern,"'");
	    	return result;
	    	
	    }
	    
		public static function reverseString(str:String):String {
			var sTmp:String="";
			for ( var i:int= str.length -1 ; i >=0 ; i-- ) 
				sTmp+=str.charAt(i);
			return sTmp;
		}
		
	    public static function sort(str:String, descending:Boolean= false):String {
	    	if ( (str==null) || (str.length<=1) ) 
	    		return str;
	    	var chars:Array = str.split("");
	    	if ( descending )
	    		chars.sort(Array.DESCENDING);
	    	else
	    		chars.sort();
	    	return chars.join("");	
	    }

		public static function removeIgnoredChars(word:String, ignoreChars:String ) :String {
			if ( ignoreChars == null || word == null ) return word;
			for ( var i:int = 0; i< ignoreChars.length ; ++i ) {
				word.split(ignoreChars[i]).join("");
			}
			return word;
		}

		public static function makeInitCap(word:String):String {
			return word.charAt(0).toLocaleUpperCase() + word.substr(1);
		}

		/*
		 * Deprecated function for now...
		 * History: 
		 *          A pre-version of implementation for error detection. After I optimized the code for performance,
		 *          I drop this function by that time, but you know performance meassuring is a tricky problem... 
		 * ToDo: Need a revisit when we implementing complex-affix support and compound-word support.
		 */
	    public static function getCapType1(word:String):int {
			// now determine the capitalization type of the first nl letters
			var ncap:int = 0;
			var nneutral:int = 0;
			var firstcap:int = 0;
			// Potential improvment 1:
			// It could be updated to user gslib StringUtils class in the future( after we have argo player 10.1 public). It is better for locale correction.
			// at that time, we should consider about german language sharp SS -> beta case... the only case for changing the string length.
			// Potential improvement 2:
			// Using a hard code mapping table to convert the string to lowercase or uppercase. It is better for perfermance...
			
			if ( word == null || word=="" ) return InternalConstants.NOCAP;

			var lowerStr:String = word.toLocaleLowerCase();
			var upperStr:String = word.toLocaleUpperCase();

			for ( var i:int = 0; i < word.length; ++i ) {
				if ( upperStr.charCodeAt(i) == lowerStr.charCodeAt(i) ) 
					nneutral++;
				else {
					if ( word.charCodeAt(i) == upperStr.charCodeAt(i) )
						ncap++;
				}
			}
			
			if (ncap) {
				if ( word.charCodeAt(0) == upperStr.charCodeAt(0) && upperStr.charCodeAt(0) != lowerStr.charCodeAt(0) )
					firstcap = 1;
			}

			// now finally set the captype
			if (ncap == 0) {
				return InternalConstants.NOCAP;
			} else if ((ncap == 1) && firstcap) {
				return InternalConstants.INITCAP;
			} else if ((ncap == word.length) || ((ncap + nneutral) == word.length)) {
				return InternalConstants.ALLCAP;
			} else if ((ncap > 1) && firstcap) {
				return InternalConstants.HUHINITCAP;
			}
			return InternalConstants.HUHCAP;			
	    }

	    public static function getCapType(word:String):int {
			// now determine the capitalization type of the first nl letters
			var ncap:int = 0;
			var nneutral:int = 0;
			var firstcap:int = 0;
			// Potential improvment 1:
			// It could be updated to user gslib StringUtils class in the future( after we have argo player 10.1 public). It is better for locale correction.
			// at that time, we should consider about german language sharp SS -> beta case... the only case for changing the string length.
			// Potential improvement 2:
			// Using a hard code mapping table to convert the string to lowercase or uppercase. It is better for perfermance...
			
			if ( word == null || word=="" ) return InternalConstants.NOCAP;
			var lowerStr:String = word.toLocaleLowerCase();
			var upperStr:String = word.toLocaleUpperCase();
			//trying to find if non word characters are present
			/*var nonWordCharRegex:RegExp = /\b\w+\b/;
			var resNonWord:Array = word.match( nonWordCharRegex);
			if(word==resNonWord[0]) then return 
			trace("the word: "+resNonWord[0]);
			trace("cosdfasdfnd: "+(word==resNonWord[0])+" Word "+word);*/
			//var testWord:String= word;
			
			//var nonWordIndex:int= word.search(containsNonWordCharRegex);
			//trace("**NonwordIndex : "+nonWordIndex+" Word: "+word);
			//if(nonWordIndex!=-1) 
			
			if ( word == lowerStr ) return InternalConstants.NOCAP;
			if ( word == upperStr ) return InternalConstants.ALLCAP;
			if ( upperStr == lowerStr ) return InternalConstants.NOCAP;
			if ( word.charCodeAt(0) == upperStr.charCodeAt(0) && upperStr.charCodeAt(0) != lowerStr.charCodeAt(0) ) {
				ncap = 1;
				for ( var i:int = 1; i < word.length; ++i ) {
					if ( word.charCodeAt(i) == upperStr.charCodeAt(i) && upperStr.charCodeAt(i) != lowerStr.charCodeAt(i) ) {
						ncap++;
						break;
					}
				}
				if ( ncap == 1 )
					return InternalConstants.INITCAP;
				else 
					return InternalConstants.HUHINITCAP;
			}else {
		    	return InternalConstants.HUHCAP;
			}
	
	    }
	    
		/*
		 * Deprecated function for now...
		 * History: 
		 *          A pre-version of implementation for error correction. After I optimized the code for performance,
		 *          I drop this function by that time, but you know performance meassuring is a tricky problem... 
		 * ToDo: Need a revisit when we implementing complex-affix support and compound-word support.
		 */
	    static public function lcs1(a:String, b:String):String {
	    	var aSub:String = a.substr(0,a.length-1);
	    	var bSub:String = b.substr(0, b.length -1 );
	    	if ( a.length == 0 || b.length == 0 ) {
	    		return "";
	    	}else if ( a.charAt(a.length-1) == b.charAt(b.length-1) ) {
	    		return lcs1(aSub,bSub) + a.charAt(a.length-1);
	    	}else {
	    		var x:String = lcs1(a,bSub);
	    		var y:String = lcs1(aSub,b);
	    		return (x.length > y.length) ? x: y;
	    	}
	    }

		/*
		 * Longest common subsequence problem
		 * From Wikipedia, the free encyclopedia
		 * Jump to: navigation, search
		 * Not to be confused with longest common substring problem.
		 * The longest common subsequence (LCS) problem is to find the longest subsequence 
		 * common to all sequences in a set of sequences (often just two). It is a classic computer 
		 * science problem, the basis of diff (a file comparison program that outputs the differences 
		 * between two files), and has applications in bioinformatics.
		 * 
		 * URL: http://en.wikipedia.org/wiki/Longest_common_subsequence_problem
		 */
		static public function lcs(a:String, b:String):String {
			var lengths:Array = new Array(a.length+1);
			var i:int,j:int, x:int,y:int;
			for ( i = 0 ; i< a.length+1; ++i ) {
				lengths[i] = new Array(b.length+1);
				for ( j=0; j< b.length+1; ++j) 
					lengths[i][j]=0;
			}
			// row 0 and column 0 are initialized to 0 already
			for ( i=0;i< a.length; ++i ) 
				for( j=0;j<b.length; ++j)
					if ( a.charAt(i) == b.charAt(j) )
						lengths[i+1][j+1] = lengths[i][j] + 1;
					else
						 lengths[i+1][j+1] = Math.max(lengths[i+1][j], lengths[i][j+1]);
			// read the substring out from the matrix
			var res:String="";
			for ( x = a.length,y=b.length; x!=0 && y!=0; ) {
				if (lengths[x][y] == lengths[x-1][y])
					x--;
				else if ( lengths[x][y] == lengths[x][y-1] )
					y--;
				else {
					res +=a.charAt(x-1);
					x--;
					y--;
				}
			}
			return res.split("").reverse().join("");
		}

	    
	    static public function lcslen( a:String, b:String) :int {
	    	return lcs(a,b).length;
	    } 
	    
	    static public function commonCharacterPositions( a:String, b:String, refObj:RefObject):int {
			var num:int = 0, i:int;
			var diff:int = 0;
			var diffpos:Array = new Array(2);
			refObj.ref  = 0;
	    	b = b.toLocaleLowerCase();
	    	for ( i =0; (i < a.length) && ( i<b.length); ++i ) {
	    		if ( a.charAt(i) == b.charAt(i) ) {
	    			num++;
	    		}else {
	    			if ( diff < 2) diffpos[diff] = i;
	    			diff++;
	    		}
	    	}
	    	if ( (diff == 2) && ( i=(a.length-1) ) && ( i==(b.length-1)) && (a.charCodeAt(diffpos[0]) == b.charCodeAt(diffpos[1])) && ( a.charCodeAt( diffpos[1]) == b.charCodeAt(diffpos[0]) ))
	    		refObj.ref = 1;
	    	
	    	return num;
	    }
	    
		/*
		* To find if the Numbers are present in the word
		* 
		* returns true if hasNumber else returns false
		*/
		public static function getHasNumber(word:String):Boolean {
			var i:int;
			for ( i=0 ; i < word.length ; ++i ) {
				if ( (word.charCodeAt(i) <= 57 ) && ( word.charCodeAt(i) >= 48) ) { // '0' to '9'
					return true;
				}
			}
			return false;
		}
	}
}


