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

package org.apache.flex.crypto
{
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import flash.utils.IDataInput;

    /**
     * Perform MD5 hash of an input stream in chunks. This class was
     * originally com.adobe.crypto.MD5Stream.as but was almost totally
     * re-written to improve performance.
     * This class processes data in
     * chunks. Usage: create an instance, call
     * update(data) repeatedly for multiples of 64-byte 
     * chunks and finally complete()
     * which will return the md5 hash.
     */      
    public class MD5Stream
    {

        // initialize the md buffers
        private var a:int = 1732584193;
        private var b:int = -271733879;
        private var c:int = -1732584194;
        private var d:int = 271733878;
        
        // variables to store previous values
        private var aa:int;
        private var bb:int;
        private var cc:int;
        private var dd:int;        
        
        public function MD5Stream()
        {
            
        }
               
        
        /**
         * Pass in chunks of the input data with update(), call
         * complete() with an optional chunk which will return the
         * final hash. Equivalent to the way
         * java.security.MessageDigest works.
         *
         * @param input The IDataInput
         * @param totalLength The total number of bytes in the IDataInput
         * @return A string containing the hash value
         * @langversion ActionScript 3.0
         * @playerversion Flash 8.5
         * @tiptext
         */
        public function complete(input:IDataInput, totalLength:int):String
        {
            var bytesLeft:int = input.bytesAvailable;
            if (bytesLeft > 0)
                hashChunks(input, Math.floor(bytesLeft / 64) * 64);
            
            var finalChunk:ByteArray;
            finalChunk = new ByteArray();
            finalChunk.endian = Endian.LITTLE_ENDIAN;
            
            var used:int = bytesLeft & 0x3f;
            if (used > 0)
            {
                input.readBytes(finalChunk, 0, used);
                finalChunk.position = finalChunk.length;
            }
            finalChunk.writeByte(0x80);
            used++;

            var free:int = 64 - used;
            if (free < 8)
            {
                for (var i:int = used; i < 64; i++)
                {
                    finalChunk.writeByte(0);
                }
                used = 0;
                free = 64;
            }
            free -= 8;
            for (i = 0; i < free; i++)
            {
                finalChunk.writeByte(0);
            }
            finalChunk.writeInt(totalLength << 3);
            finalChunk.writeInt(0);

            finalChunk.position = 0;
            hashChunks(finalChunk, finalChunk.length);
            
            const zeros:String = "00000000";
            var res:String = "";
            var piece:uint = flip(a)
            var part:String = piece.toString(16);
            if (part.length < 8)
                res += zeros.substr(part.length);
            res += part;
            piece = flip(b);
            part = piece.toString(16);
            if (part.length < 8)
                res += zeros.substr(part.length);
            res += part;
            piece = flip(c);
            part = piece.toString(16);
            if (part.length < 8)
                res += zeros.substr(part.length);
            res += part;
            piece = flip(d);
            part = piece.toString(16);
            if (part.length < 8)
                res += zeros.substr(part.length);
            res += part;
            
            resetFields();
            
            return res;
        }

        private function flip(a:int):uint
        {
            var v24:uint = uint(a & 0xff) << 24;
            var v16:uint = uint(a >> 8 & 0xff) << 16;
            var v8:uint = uint(a >> 16 & 0xff) << 8;
            var v:uint = uint(a >> 24 & 0xff);
            v += v24 + v16 + v8;
            return v;
        }
        
        /**
         * Pass in chunks of the input data with update(), call
         * complete() with an optional chunk which will return the
         * final hash. Equivalent to the way
         * java.security.MessageDigest works.
         *
         * @param input The bytearray chunk to perform the hash on
         * @langversion ActionScript 3.0
         * @playerversion Flash 8.5
         * @tiptext
         */        
        public function update(input:IDataInput, length:int):void
        {
            hashChunks(input, length);
        }

        /**
         * Re-initialize this instance for use to perform hashing on
         * another input stream. This is called automatically by
         * complete().
         *
         * @langversion ActionScript 3.0
         * @playerversion Flash 8.5
         * @tiptext
         */               
        public function resetFields():void
        {            
            // initialize the md buffers
            a = 1732584193;
            b = -271733879;
            c = -1732584194;
            d = 271733878;
            
            // variables to store previous values
            aa = 0;
            bb = 0;
            cc = 0;
            dd = 0;
        }
        
        
        private function hashChunks(input:IDataInput, len:int):void
        {            
            var arr00:int;
            var arr01:int;
            var arr02:int;
            var arr03:int;
            var arr04:int;
            var arr05:int;
            var arr06:int;
            var arr07:int;
            var arr08:int;
            var arr09:int;
            var arr10:int;
            var arr11:int;
            var arr12:int;
            var arr13:int;
            var arr14:int;
            var arr15:int;
            
            var a:int = this.a;
            var b:int = this.b;
            var c:int = this.c;
            var d:int = this.d;
            var aa:int = this.aa;
            var bb:int = this.bb;
            var cc:int = this.cc;
            var dd:int = this.dd;
            
            
            input.endian = Endian.LITTLE_ENDIAN;
            for ( var i:int = 0; i < len ; i += 64) 
            {            	
                arr00 = input.readInt();
                arr01 = input.readInt();
                arr02 = input.readInt();
                arr03 = input.readInt();
                arr04 = input.readInt();
                arr05 = input.readInt();
                arr06 = input.readInt();
                arr07 = input.readInt();
                arr08 = input.readInt();
                arr09 = input.readInt();
                arr10 = input.readInt();
                arr11 = input.readInt();
                arr12 = input.readInt();
                arr13 = input.readInt();
                arr14 = input.readInt();
                arr15 = input.readInt();
                
                // save previous values
                aa = a;
                bb = b;
                cc = c;
                dd = d;                         
                
                var tmp:int;
                
                // Round 1
                // f = ( x & y ) | ( (~x) & z )
                // a + int( func( b, c, d ) ) + x + t
                //a = ff( a, b, c, d, arr00,  7, -680876936 );     // 1
                tmp = a + ( ( b & c) | ( (~b) & d ) ) + arr00 + -680876936;
                a = ( ( tmp << 7 ) | ( tmp >>> 25 ) ) + b;
                //d = ff( d, a, b, c, arr01, 12, -389564586 );     // 2
                tmp = d + ( ( a & b) | ( (~a) & c ) ) + arr01 + -389564586;
                d = ( ( tmp << 12) | ( tmp >>> 20 ) ) + a;
                //c = ff( c, d, a, b, arr02, 17, 606105819 );      // 3
                tmp = c + ( ( d & a) | ( (~d) & b ) ) + arr02 + 606105819;
                c = ( ( tmp << 17) | ( tmp >>> 15 ) ) + d;
                //b = ff( b, c, d, a, arr03, 22, -1044525330 );    // 4
                tmp = b + ( ( c & d) | ( (~c) & a ) ) + arr03 + -1044525330;
                b = ( ( tmp << 22) | ( tmp >>> 10 ) ) + c;
                //a = ff( a, b, c, d, arr04,  7, -176418897 );     // 5
                tmp = a + ( ( b & c) | ( (~b) & d ) ) + arr04 + -176418897;
                a = ( ( tmp << 7 ) | ( tmp >>> 25 ) ) + b;
                //d = ff( d, a, b, c, arr05, 12, 1200080426 );     // 6
                tmp = d + ( ( a & b) | ( (~a) & c ) ) + arr05 + 1200080426;
                d = ( ( tmp << 12) | ( tmp >>> 20 ) ) + a;
                //c = ff( c, d, a, b, arr06, 17, -1473231341 );    // 7
                tmp = c + ( ( d & a) | ( (~d) & b ) ) + arr06 + -1473231341;
                c = ( ( tmp << 17) | ( tmp >>> 15 ) ) + d;
                //b = ff( b, c, d, a, arr07, 22, -45705983 );      // 8
                tmp = b + ( ( c & d) | ( (~c) & a ) ) + arr07 + -45705983;
                b = ( ( tmp << 22) | ( tmp >>> 10 ) ) + c;
                //a = ff( a, b, c, d, arr08,  7, 1770035416 );     // 9
                tmp = a + ( ( b & c) | ( (~b) & d ) ) + arr08 + 1770035416;
                a = ( ( tmp << 7 ) | ( tmp >>> 25 ) ) + b;
                //d = ff( d, a, b, c, arr09, 12, -1958414417 );    // 10
                tmp = d + ( ( a & b) | ( (~a) & c ) ) + arr09 + -1958414417;
                d = ( ( tmp << 12) | ( tmp >>> 20 ) ) + a;
                //c = ff( c, d, a, b, arr10, 17, -42063 );         // 11
                tmp = c + ( ( d & a) | ( (~d) & b ) ) + arr10 + -42063;
                c = ( ( tmp << 17) | ( tmp >>> 15 ) ) + d;
                //b = ff( b, c, d, a, arr11, 22, -1990404162 );    // 12
                tmp = b + ( ( c & d) | ( (~c) & a ) ) + arr11 + -1990404162;
                b = ( ( tmp << 22) | ( tmp >>> 10 ) ) + c;
                //a = ff( a, b, c, d, arr12,  7, 1804603682 );     // 13
                tmp = a + ( ( b & c) | ( (~b) & d ) ) + arr12 + 1804603682;
                a = ( ( tmp << 7 ) | ( tmp >>> 25 ) ) + b;
                //d = ff( d, a, b, c, arr13, 12, -40341101 );      // 14
                tmp = d + ( ( a & b) | ( (~a) & c ) ) + arr13 + -40341101;
                d = ( ( tmp << 12) | ( tmp >>> 20 ) ) + a;
                //c = ff( c, d, a, b, arr14, 17, -1502002290 );    // 15
                tmp = c + ( ( d & a) | ( (~d) & b ) ) + arr14 + -1502002290;
                c = ( ( tmp << 17) | ( tmp >>> 15 ) ) + d;
                //b = ff( b, c, d, a, arr15, 22, 1236535329 );     // 16
                tmp = b + ( ( c & d) | ( (~c) & a ) ) + arr15 + 1236535329;
                b = ( ( tmp << 22) | ( tmp >>> 10 ) ) + c;
                
                // Round 2
                // g = ( x & z ) | ( y & (~z) )
                //a = gg( a, b, c, d, arr01,  5, -165796510 );     // 17
                tmp = a + ( ( b & d) | ( c & (~d) ) ) + arr01 + -165796510;
                a = ( ( tmp << 5 ) | ( tmp >>> 27 ) ) + b;                    
                //d = gg( d, a, b, c, arr06,  9, -1069501632 );    // 18
                tmp = d + ( ( a & c) | ( b & (~c) ) ) + arr06 + -1069501632;
                d = ( ( tmp << 9 ) | ( tmp >>> 23 ) ) + a;
                //c = gg( c, d, a, b, arr11, 14, 643717713 );      // 19
                tmp = c + ( ( d & b) | ( a & (~b) ) ) + arr11 + 643717713;
                c = ( ( tmp << 14) | ( tmp >>> 18) ) + d;
                //b = gg( b, c, d, a, arr00, 20, -373897302 );     // 20
                tmp = b + ( ( c & a) | ( d & (~a) ) ) + arr00 + -373897302;
                b = ( ( tmp << 20) | ( tmp >>> 12) ) + c;
                //a = gg( a, b, c, d, arr05,  5, -701558691 );     // 21
                tmp = a + ( ( b & d) | ( c & (~d) ) ) + arr05 + -701558691;
                a = ( ( tmp << 5 ) | ( tmp >>> 27 ) ) + b;                    
                //d = gg( d, a, b, c, arr10,  9, 38016083 );       // 22
                tmp = d + ( ( a & c) | ( b & (~c) ) ) + arr10 + 38016083;
                d = ( ( tmp << 9 ) | ( tmp >>> 23 ) ) + a;
                //c = gg( c, d, a, b, arr15, 14, -660478335 );     // 23
                tmp = c + ( ( d & b) | ( a & (~b) ) ) + arr15 + -660478335;
                c = ( ( tmp << 14) | ( tmp >>> 18) ) + d;
                //b = gg( b, c, d, a, arr04, 20, -405537848 );     // 24
                tmp = b + ( ( c & a) | ( d & (~a) ) ) + arr04 + -405537848;
                b = ( ( tmp << 20) | ( tmp >>> 12) ) + c;
                //a = gg( a, b, c, d, arr09,  5, 568446438 );      // 25
                tmp = a + ( ( b & d) | ( c & (~d) ) ) + arr09 + 568446438;
                a = ( ( tmp << 5 ) | ( tmp >>> 27 ) ) + b;                    
                //d = gg( d, a, b, c, arr14,  9, -1019803690 );    // 26
                tmp = d + ( ( a & c) | ( b & (~c) ) ) + arr14 + -1019803690 ;
                d = ( ( tmp << 9 ) | ( tmp >>> 23 ) ) + a;
                //c = gg( c, d, a, b, arr03, 14, -187363961 );     // 27
                tmp = c + ( ( d & b) | ( a & (~b) ) ) + arr03 + -187363961;
                c = ( ( tmp << 14) | ( tmp >>> 18) ) + d;
                //b = gg( b, c, d, a, arr08, 20, 1163531501 );     // 28
                tmp = b + ( ( c & a) | ( d & (~a) ) ) + arr08 + 1163531501;
                b = ( ( tmp << 20) | ( tmp >>> 12) ) + c;
                //a = gg( a, b, c, d, arr13,  5, -1444681467 );    // 29
                tmp = a + ( ( b & d) | ( c & (~d) ) ) + arr13 + -1444681467;
                a = ( ( tmp << 5 ) | ( tmp >>> 27 ) ) + b;                    
                //d = gg( d, a, b, c, arr02,  9, -51403784 );      // 30
                tmp = d + ( ( a & c) | ( b & (~c) ) ) + arr02 + -51403784 ;
                d = ( ( tmp << 9 ) | ( tmp >>> 23 ) ) + a;
                //c = gg( c, d, a, b, arr07, 14, 1735328473 );     // 31
                tmp = c + ( ( d & b) | ( a & (~b) ) ) + arr07 + 1735328473;
                c = ( ( tmp << 14) | ( tmp >>> 18) ) + d;
                //b = gg( b, c, d, a, arr12, 20, -1926607734 );    // 32
                tmp = b + ( ( c & a) | ( d & (~a) ) ) + arr12 + -1926607734;
                b = ( ( tmp << 20) | ( tmp >>> 12) ) + c;
                
                // Round 3
                // h = x ^ y ^ z
                //a = hh( a, b, c, d, arr05,  4, -378558 );        // 33
                tmp = a + ( b ^ c ^ d ) + arr05 + -378558;
                a = ( ( tmp << 4 ) | ( tmp >>> 28 ) ) + b;                    
                //d = hh( d, a, b, c, arr08, 11, -2022574463 );    // 34
                tmp = d + ( a ^ b ^ c ) + arr08 + -2022574463;
                d = ( ( tmp << 11 ) | ( tmp >>> 21 ) ) + a;                    
                //c = hh( c, d, a, b, arr11, 16, 1839030562 );     // 35
                tmp = c + ( d ^ a ^ b ) + arr11 + 1839030562;
                c = ( ( tmp << 16 ) | ( tmp >>> 16 ) ) + d;                    
                //b = hh( b, c, d, a, arr14, 23, -35309556 );      // 36
                tmp = b + ( c ^ d ^ a ) + arr14 + -35309556;
                b = ( ( tmp << 23 ) | ( tmp >>> 9 ) ) + c;                    
                //a = hh( a, b, c, d, arr01,  4, -1530992060 );    // 37
                tmp = a + ( b ^ c ^ d ) + arr01 + -1530992060;
                a = ( ( tmp << 4 ) | ( tmp >>> 28 ) ) + b;                    
                //d = hh( d, a, b, c, arr04, 11, 1272893353 );     // 38
                tmp = d + ( a ^ b ^ c ) + arr04 + 1272893353;
                d = ( ( tmp << 11 ) | ( tmp >>> 21 ) ) + a;                    
                //c = hh( c, d, a, b, arr07, 16, -155497632 );     // 39
                tmp = c + ( d ^ a ^ b ) + arr07 + -155497632;
                c = ( ( tmp << 16 ) | ( tmp >>> 16 ) ) + d;                    
                //b = hh( b, c, d, a, arr10, 23, -1094730640 );    // 40
                tmp = b + ( c ^ d ^ a ) + arr10 + -1094730640;
                b = ( ( tmp << 23 ) | ( tmp >>> 9 ) ) + c;                    
                //a = hh( a, b, c, d, arr13,  4, 681279174 );      // 41
                tmp = a + ( b ^ c ^ d ) + arr13 + 681279174;
                a = ( ( tmp << 4 ) | ( tmp >>> 28 ) ) + b;                    
                //d = hh( d, a, b, c, arr00, 11, -358537222 );     // 42
                tmp = d + ( a ^ b ^ c ) + arr00 + -358537222;
                d = ( ( tmp << 11 ) | ( tmp >>> 21 ) ) + a;                    
                //c = hh( c, d, a, b, arr03, 16, -722521979 );     // 43
                tmp = c + ( d ^ a ^ b ) + arr03 + -722521979;
                c = ( ( tmp << 16 ) | ( tmp >>> 16 ) ) + d;                    
                //b = hh( b, c, d, a, arr06, 23, 76029189 );       // 44
                tmp = b + ( c ^ d ^ a ) + arr06 + 76029189;
                b = ( ( tmp << 23 ) | ( tmp >>> 9 ) ) + c;                    
                //a = hh( a, b, c, d, arr09,  4, -640364487 );     // 45
                tmp = a + ( b ^ c ^ d ) + arr09 + -640364487;
                a = ( ( tmp << 4 ) | ( tmp >>> 28 ) ) + b;                    
                //d = hh( d, a, b, c, arr12, 11, -421815835 );     // 46
                tmp = d + ( a ^ b ^ c ) + arr12 + -421815835;
                d = ( ( tmp << 11 ) | ( tmp >>> 21 ) ) + a;                    
                //c = hh( c, d, a, b, arr15, 16, 530742520 );      // 47
                tmp = c + ( d ^ a ^ b ) + arr15 + 530742520;
                c = ( ( tmp << 16 ) | ( tmp >>> 16 ) ) + d;                    
                //b = hh( b, c, d, a, arr02, 23, -995338651 );     // 48
                tmp = b + ( c ^ d ^ a ) + arr02 + -995338651;
                b = ( ( tmp << 23 ) | ( tmp >>> 9 ) ) + c;                    
                
                // Round 4
                // i = y ^ ( x | (~z) )
                //a = ii( a, b, c, d, arr00,  6, -198630844 );     // 49
                tmp = a + ( c ^ ( b | (~d ) ) ) + arr00 + -198630844;
                a = ( ( tmp << 6 ) | ( tmp >>> 26 ) ) + b;                    
                //d = ii( d, a, b, c, arr07, 10, 1126891415 );     // 50
                tmp = d + ( b ^ ( a | (~c ) ) ) + arr07 + 1126891415;
                d = ( ( tmp << 10) | ( tmp >>> 22 ) ) + a;                    
                //c = ii( c, d, a, b, arr14, 15, -1416354905 );    // 51
                tmp = c + ( a ^ ( d | (~b ) ) ) + arr14 + -1416354905;
                c = ( ( tmp << 15) | ( tmp >>> 17 ) ) + d;                    
                //b = ii( b, c, d, a, arr05, 21, -57434055 );      // 52
                tmp = b + ( d ^ ( c | (~a ) ) ) + arr05 + -57434055;
                b = ( ( tmp << 21) | ( tmp >>> 11 ) ) + c;                    
                //a = ii( a, b, c, d, arr12,  6, 1700485571 );     // 53
                tmp = a + ( c ^ ( b | (~d ) ) ) + arr12 + 1700485571;
                a = ( ( tmp << 6 ) | ( tmp >>> 26 ) ) + b;                    
                //d = ii( d, a, b, c, arr03, 10, -1894986606 );    // 54
                tmp = d + ( b ^ ( a | (~c ) ) ) + arr03 + -1894986606;
                d = ( ( tmp << 10) | ( tmp >>> 22 ) ) + a;                    
                //c = ii( c, d, a, b, arr10, 15, -1051523 );       // 55
                tmp = c + ( a ^ ( d | (~b ) ) ) + arr10 + -1051523;
                c = ( ( tmp << 15) | ( tmp >>> 17 ) ) + d;                    
                //b = ii( b, c, d, a, arr01, 21, -2054922799 );    // 56
                tmp = b + ( d ^ ( c | (~a ) ) ) + arr01 + -2054922799;
                b = ( ( tmp << 21) | ( tmp >>> 11 ) ) + c;                    
                //a = ii( a, b, c, d, arr08,  6, 1873313359 );     // 57
                tmp = a + ( c ^ ( b | (~d ) ) ) + arr08 + 1873313359;
                a = ( ( tmp << 6 ) | ( tmp >>> 26 ) ) + b;                    
                //d = ii( d, a, b, c, arr15, 10, -30611744 );      // 58
                tmp = d + ( b ^ ( a | (~c ) ) ) + arr15 + -30611744;
                d = ( ( tmp << 10) | ( tmp >>> 22 ) ) + a;                    
                //c = ii( c, d, a, b, arr06, 15, -1560198380 );    // 59
                tmp = c + ( a ^ ( d | (~b ) ) ) + arr06 + -1560198380;
                c = ( ( tmp << 15) | ( tmp >>> 17 ) ) + d;                    
                //b = ii( b, c, d, a, arr13, 21, 1309151649 );     // 60
                tmp = b + ( d ^ ( c | (~a ) ) ) + arr13 + 1309151649;
                b = ( ( tmp << 21) | ( tmp >>> 11 ) ) + c;                    
                //a = ii( a, b, c, d, arr04,  6, -145523070 );     // 61
                tmp = a + ( c ^ ( b | (~d ) ) ) + arr04 + -145523070;
                a = ( ( tmp << 6 ) | ( tmp >>> 26 ) ) + b;                    
                //d = ii( d, a, b, c, arr11, 10, -1120210379 );    // 62
                tmp = d + ( b ^ ( a | (~c ) ) ) + arr11 + -1120210379;
                d = ( ( tmp << 10) | ( tmp >>> 22 ) ) + a;                    
                //c = ii( c, d, a, b, arr02, 15, 718787259 );      // 63
                tmp = c + ( a ^ ( d | (~b ) ) ) + arr02 + 718787259;
                c = ( ( tmp << 15) | ( tmp >>> 17 ) ) + d;                    
                //b = ii( b, c, d, a, arr09, 21, -343485551 );     // 64
                tmp = b + ( d ^ ( c | (~a ) ) ) + arr09 + -343485551;
                b = ( ( tmp << 21) | ( tmp >>> 11 ) ) + c;                    
                
                a += aa;
                b += bb;
                c += cc;
                d += dd;
                
            }
            this.aa = aa;
            this.bb = bb;
            this.cc = cc;
            this.dd = dd;
            this.a = a;
            this.b = b;
            this.c = c;
            this.d = d;
            
        }       
    }
}