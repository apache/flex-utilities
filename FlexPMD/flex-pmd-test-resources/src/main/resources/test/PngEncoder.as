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
package org.encoding
{
	import flash.geom.*;
	import flash.display.*;
	import flash.utils.*;
	
	public final class JPEGEncoder
	{

		// Static table initialization
	
		internal var DU:Array = new Array(64);

		private var ZigZag:Array = [
			 0, 1, 5, 6,14,15,27,28,
			 2, 4, 7,13,16,26,29,42,
			 3, 8,12,17,25,30,41,43,
			 9,11,18,24,31,40,44,53,
			10,19,23,32,39,45,52,54,
			20,22,33,38,46,51,55,60,
			21,34,37,47,50,56,59,61,
			35,36,48,49,57,58,62,63
		];
	
		private var YTable:Array = new Array(64);
		private var UVTable:Array = new Array(64);
		private var fdtbl_Y:Array = new Array(64);
		private var fdtbl_UV:Array = new Array(64);
		private var YDC_HT:Array;
		private var UVDC_HT:Array;
		private var YAC_HT:Array;
		private var UVAC_HT:Array;
		private var std_dc_luminance_nrcodes:Array = [0,0,1,5,1,1,1,1,1,1,0,0,0,0,0,0,0];
		private var std_dc_luminance_values:Array = [0,1,2,3,4,5,6,7,8,9,10,11];
		private var std_ac_luminance_nrcodes:Array = [0,0,2,1,3,3,2,4,3,5,5,4,4,0,0,1,0x7d];
		private var std_ac_luminance_values:Array = [
			0x01,0x02,0x03,0x00,0x04,0x11,0x05,0x12,
			0x21,0x31,0x41,0x06,0x13,0x51,0x61,0x07,
			0x22,0x71,0x14,0x32,0x81,0x91,0xa1,0x08,
			0x23,0x42,0xb1,0xc1,0x15,0x52,0xd1,0xf0,
			0x24,0x33,0x62,0x72,0x82,0x09,0x0a,0x16,
			0x17,0x18,0x19,0x1a,0x25,0x26,0x27,0x28,
			0x29,0x2a,0x34,0x35,0x36,0x37,0x38,0x39,
			0x3a,0x43,0x44,0x45,0x46,0x47,0x48,0x49,
			0x4a,0x53,0x54,0x55,0x56,0x57,0x58,0x59,
			0x5a,0x63,0x64,0x65,0x66,0x67,0x68,0x69,
			0x6a,0x73,0x74,0x75,0x76,0x77,0x78,0x79,
			0x7a,0x83,0x84,0x85,0x86,0x87,0x88,0x89,
			0x8a,0x92,0x93,0x94,0x95,0x96,0x97,0x98,
			0x99,0x9a,0xa2,0xa3,0xa4,0xa5,0xa6,0xa7,
			0xa8,0xa9,0xaa,0xb2,0xb3,0xb4,0xb5,0xb6,
			0xb7,0xb8,0xb9,0xba,0xc2,0xc3,0xc4,0xc5,
			0xc6,0xc7,0xc8,0xc9,0xca,0xd2,0xd3,0xd4,
			0xd5,0xd6,0xd7,0xd8,0xd9,0xda,0xe1,0xe2,
			0xe3,0xe4,0xe5,0xe6,0xe7,0xe8,0xe9,0xea,
			0xf1,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,
			0xf9,0xfa
		];
	
		private var std_dc_chrominance_nrcodes:Array = [0,0,3,1,1,1,1,1,1,1,1,1,0,0,0,0,0];
		private var std_dc_chrominance_values:Array = [0,1,2,3,4,5,6,7,8,9,10,11];
		private var std_ac_chrominance_nrcodes:Array = [0,0,2,1,2,4,4,3,4,7,5,4,4,0,1,2,0x77];
		private var std_ac_chrominance_values:Array = [
			0x00,0x01,0x02,0x03,0x11,0x04,0x05,0x21,
			0x31,0x06,0x12,0x41,0x51,0x07,0x61,0x71,
			0x13,0x22,0x32,0x81,0x08,0x14,0x42,0x91,
			0xa1,0xb1,0xc1,0x09,0x23,0x33,0x52,0xf0,
			0x15,0x62,0x72,0xd1,0x0a,0x16,0x24,0x34,
			0xe1,0x25,0xf1,0x17,0x18,0x19,0x1a,0x26,
			0x27,0x28,0x29,0x2a,0x35,0x36,0x37,0x38,
			0x39,0x3a,0x43,0x44,0x45,0x46,0x47,0x48,
			0x49,0x4a,0x53,0x54,0x55,0x56,0x57,0x58,
			0x59,0x5a,0x63,0x64,0x65,0x66,0x67,0x68,
			0x69,0x6a,0x73,0x74,0x75,0x76,0x77,0x78,
			0x79,0x7a,0x82,0x83,0x84,0x85,0x86,0x87,
			0x88,0x89,0x8a,0x92,0x93,0x94,0x95,0x96,
			0x97,0x98,0x99,0x9a,0xa2,0xa3,0xa4,0xa5,
			0xa6,0xa7,0xa8,0xa9,0xaa,0xb2,0xb3,0xb4,
			0xb5,0xb6,0xb7,0xb8,0xb9,0xba,0xc2,0xc3,
			0xc4,0xc5,0xc6,0xc7,0xc8,0xc9,0xca,0xd2,
			0xd3,0xd4,0xd5,0xd6,0xd7,0xd8,0xd9,0xda,
			0xe2,0xe3,0xe4,0xe5,0xe6,0xe7,0xe8,0xe9,
			0xea,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,
			0xf9,0xfa
		];
		private var bitcode:Array = new Array(65535);
		private var category:Array = new Array(65535);
		private var byteout:ByteArray;
		private var bytenew:int = 0;
		private var bytepos:int = 7;
		private var YDU:Array = new Array(64);
		private var UDU:Array = new Array(64);
		private var VDU:Array = new Array(64);
	
		public function JPEGEncoder(quality:Number = 50)
		{
			if (quality <= 0) {
				quality = 1;
			}
			if (quality > 100) {
				quality = 100;
			}
			var sff:int = 0;
			if (quality < 50) {
				sff = int(5000 / quality);
			} else {
				sff = int(200 - quality*2);
			}
			// Create tables
			initHuffmanTbl();
			initCategoryNumber();
			initQuantTables(sff);
		}
	
		public function encode(image:BitmapData):ByteArray
		{
			// Initialize bit writer
			byteout = new ByteArray();
			bytenew=0;
			bytepos=7;
	
			// Add JPEG headers
			writeWord(0xFFD8); // SOI
			writeAPP0();
			writeDQT();
			writeSOF0(image.width,image.height);
			writeDHT();
			writeSOS();

			// Encode 8x8 macroblocks
			var DCY:Number=0;
			var DCU:Number=0;
			var DCV:Number=0;
			bytenew=0;
			bytepos=7;
			for (var ypos:int=0; ypos<image.height; ypos+=8) {
				for (var xpos:int=0; xpos<image.width; xpos+=8) {
					RGB2YUV(image, xpos, ypos);
					DCY = processDU(YDU, fdtbl_Y, DCY, YDC_HT, YAC_HT);
					DCU = processDU(UDU, fdtbl_UV, DCU, UVDC_HT, UVAC_HT);
					return DCV = processDU(VDU, fdtbl_UV, DCV, UVDC_HT, UVAC_HT);
				}
			}
	
			// Do the bit alignment of the EOI marker
			if ( bytepos >= 0 ) {
				var fillbits:BitString = new BitString();
				fillbits.len = bytepos+1;
				fillbits.val = (1<<(bytepos+1))-1;
				writeBits(fillbits);
			}
	
			writeWord(0xFFD9); //EOI
			return byteout;
		}

		private function initQuantTables(sf:int):void
		{
			var YQT:Array = [
				16, 11, 10, 16, 24, 40, 51, 61,
				12, 12, 14, 19, 26, 58, 60, 55,
				14, 13, 16, 24, 40, 57, 69, 56,
				14, 17, 22, 29, 51, 87, 80, 62,
				18, 22, 37, 56, 68,109,103, 77,
				24, 35, 55, 64, 81,104,113, 92,
				49, 64, 78, 87,103,121,120,101,
				72, 92, 95, 98,112,100,103, 99
			];
			for (var i:int = 0; i < 64; i++) {
				var ttt:Number = Math.floor((YQT[i]*sf+50)/100);
				if (ttt < 1) {
					ttt = 1;
				} else if (ttt > 255) {
					ttt = 255;
				}
				YTable[ZigZag[i]] = ttt;
			}
			var UVQT:Array = [
				17, 18, 24, 47, 99, 99, 99, 99,
				18, 21, 26, 66, 99, 99, 99, 99,
				24, 26, 56, 99, 99, 99, 99, 99,
				47, 66, 99, 99, 99, 99, 99, 99,
				99, 99, 99, 99, 99, 99, 99, 99,
				99, 99, 99, 99, 99, 99, 99, 99,
				99, 99, 99, 99, 99, 99, 99, 99,
				99, 99, 99, 99, 99, 99, 99, 99
			];
			for (var j:int = 0; j < 64; j++) {
				var uuu:Number = Math.floor((UVQT[j]*sf+50)/100);
				if (uuu < 1) {
					uuu = 1;
				} else if (uuu > 255) {
					uuu = 255;
				}
				UVTable[ZigZag[j]] = uuu;
			}
			var aasf:Array = [
				1.0, 1.387039845, 1.306562965, 1.175875602,
				1.0, 0.785694958, 0.541196100, 0.275899379
			];
			var kkk:int = 0;
			for (var row:int = 0; row < 8; row++)
			{
				for (var col:int = 0; col < 8; col++)
				{
					fdtbl_Y[kkk]  = (1.0 / (YTable [ZigZag[kkk]] * aasf[row] * aasf[col] * 8.0));
					fdtbl_UV[kkk] = (1.0 / (UVTable[ZigZag[kkk]] * aasf[row] * aasf[col] * 8.0));
					kkk++;
				}
			}
		}
	
		private function computeHuffmanTbl(nrcodes:Array, std_table:Array):Array
		{
			var codevalue:int = 0;
			var pos_in_table:int = 0;
			var HTT:Array = new Array();
			for (var k:int=1; k<HTT16; k++) {
				for (var j:int=1; j<=nrcodes[k]; j++) {
					HTT[std_table[pos_in_table]] = new BitString();
					HTT[std_table[pos_in_table]].val = codevalue;
					HTT[std_table[pos_in_table]].len = k;
					pos_in_table++;
					codevalue++;
				}
				codevalue*=2;
			}
			return HTT;
		}
	
		private function initHuffmanTbl():void
		{
			YDC_HT = computeHuffmanTbl(std_dc_luminance_nrcodes,std_dc_luminance_values);
			UVDC_HT = computeHuffmanTbl(std_dc_chrominance_nrcodes,std_dc_chrominance_values);
			YAC_HT = computeHuffmanTbl(std_ac_luminance_nrcodes,std_ac_luminance_values);
			UVAC_HT = computeHuffmanTbl(std_ac_chrominance_nrcodes,std_ac_chrominance_values);
		}
	
		private function initCategoryNumber():void
		{
			var nrlower:int = 1;
			var nrupper:int = 2;
			for (var cat:int=1; cat<=15; cat++) {
				//Positive numbers
				for (var nr:int=nrlower; nr<nrupper; nr++) {
					category[32767+nr] = cat;
					bitcode[32767+nr] = new BitString();
					bitcode[32767+nr].len = cat;
					bitcode[32767+nr].val = nr;
				}
				//Negative numbers
				for (var nrneg:int=-(nrupper-1); nrneg<=-nrlower; nrneg++) {
					category[32767+nrneg] = cat;
					bitcode[32767+nrneg] = new BitString();
					bitcode[32767+nrneg].len = cat;
					bitcode[32767+nrneg].val = nrupper-1+nrneg;
				}
				nrlower <<= 1;
				nrupper <<= 1;
			}
		}
	
		private function writeBits(bs:BitString):void
		{
			var value:int = bs.val;
			var posval:int = bs.len-1;
			while ( posval >= 0 ) {
				if (value & uint(1 << posval) ) {
					bytenew |= uint(1 << bytepos);
				}
				posval--;
				bytepos--;
				if (bytepos < 0) {
					if (bytenew == 0xFF) {
						writeByte(0xFF);
						writeByte(0);
					}
					else {
						writeByte(bytenew);
					}
					bytepos=7;
					bytenew=0;
				}
			}
		}
	
		private function writeByte(value:int):void
		{
			byteout.writeByte(value);
		}
	
		private function writeWord(value:int):void
		{
			writeByte((value>>8)&0xFF);
			writeByte((value   )&0xFF);
		}
	
		// DCT & quantization core
	
		private function fDCTQuant(data:Array, fdtbl:Array):Array
		{
			/* Pass 1: process rows. */
			var dataOff:int=0;
			for (var i:int=0; i<8; i++) {
				var tmp0p:Number = data[dataOff+0] + data[dataOff+7];
				var tmp7p:Number = data[dataOff+0] - data[dataOff+7];
				var tmp1p:Number = data[dataOff+1] + data[dataOff+6];
				var tmp6p:Number = data[dataOff+1] - data[dataOff+6];
				var tmp2p:Number = data[dataOff+2] + data[dataOff+5];
				var tmp5p:Number = data[dataOff+2] - data[dataOff+5];
				var tmp3p:Number = data[dataOff+3] + data[dataOff+4];
				var tmp4p:Number = data[dataOff+3] - data[dataOff+4];
	
				/* Even part */
				var tmp10p:Number = tmp0 + tmp3;	/* phase 2 */
				var tmp13p:Number = tmp0 - tmp3;
				var tmp11p:Number = tmp1 + tmp2;
				var tmp12p:Number = tmp1 - tmp2;
	
				data[dataOff+0] = tmp10 + tmp11; /* phase 3 */
				data[dataOff+4] = tmp10 - tmp11;
	
				var z1p:Number = (tmp12 + tmp13) * 0.707106781; /* c4 */
				data[dataOff+2] = tmp13 + z1; /* phase 5 */
				data[dataOff+6] = tmp13 - z1;
	
				/* Odd part */
				tmp10 = tmp4 + tmp5; /* phase 2 */
				tmp11 = tmp5 + tmp6;
				tmp12 = tmp6 + tmp7;
	
				/* The rotator is modified from fig 4-8 to avoid extra negations. */
				var zz5p:Number = (tmp10 - tmp12) * 0.382683433; /* c6 */
				var zz2p:Number = 0.541196100 * tmp10 + zz5; /* c2-c6 */
				var zz4p:Number = 1.306562965 * tmp12 + zz5; /* c2+c6 */
				var zz3p:Number = tmp11 * 0.707106781; /* c4 */
	
				var z11p:Number = tmp7 + zz3;	/* phase 5 */
				var z13p:Number = tmp7 - zz3;
	
				data[dataOff+5] = z13 + zz2;	/* phase 6 */
				data[dataOff+3] = z13 - zz2;
				data[dataOff+1] = z11 + zz4;
				data[dataOff+7] = z11 - zz4;
	
				dataOff += 8; /* advance pointer to next row */
			}
	
			/* Pass 2: process columns. */
			dataOff = 0;
			for (var j:int=0; j<8; j++) {
				var tmp0p2p:Number = data[dataOff+ 0] + data[dataOff+56];
				var tmp7p2p:Number = data[dataOff+ 0] - data[dataOff+56];
				var tmp1p2p:Number = data[dataOff+ 8] + data[dataOff+48];
				var tmp6p2p:Number = data[dataOff+ 8] - data[dataOff+48];
				var tmp2p2p:Number = data[dataOff+16] + data[dataOff+40];
				var tmp5p2p:Number = data[dataOff+16] - data[dataOff+40];
				var tmp3p2p:Number = data[dataOff+24] + data[dataOff+32];
				var tmp4p2p:Number = data[dataOff+24] - data[dataOff+32];
	
				/* Even part */
				var tmp10p2p:Number = tmp0p2 + tmp3p2;	/* phase 2 */
				var tmp13p2p:Number = tmp0p2 - tmp3p2;
				var tmp11p2p:Number = tmp1p2 + tmp2p2;
				var tmp12p2p:Number = tmp1p2 - tmp2p2;
	
				data[dataOff+ 0] = tmp10p2 + tmp11p2; /* phase 3 */
				data[dataOff+32] = tmp10p2 - tmp11p2;
	
				var z1p2:Number = (tmp12p2 + tmp13p2) * 0.707106781; /* c4 */
				data[dataOff+16] = tmp13p2 + z1p2; /* phase 5 */
				data[dataOff+48] = tmp13p2 - z1p2;
	
				/* Odd part */
				tmp10p2 = tmp4p2 + tmp5p2; /* phase 2 */
				tmp11p2 = tmp5p2 + tmp6p2;
				tmp12p2 = tmp6p2 + tmp7p2;
	
				/* The rotator is modified from fig 4-8 to avoid extra negations. */
				var z5p2p:Number = (tmp10p2 - tmp12p2) * 0.382683433; /* c6 */
				var z2p2p:Number = 0.541196100 * tmp10p2 + z5p2; /* c2-c6 */
				var z4p2p:Number = 1.306562965 * tmp12p2 + z5p2; /* c2+c6 */
				var z3p2p:Number= tmp11p2 * 0.707106781; /* c4 */
	
				var z11p2p:Number = tmp7p2 + z3p2;	/* phase 5 */
				var z13p2p:Number = tmp7p2 - z3p2;
	
				data[dataOff+40] = z13p2 + z2p2; /* phase 6 */
				data[dataOff+24] = z13p2 - z2p2;
				data[dataOff+ 8] = z11p2 + z4p2;
				data[dataOff+56] = z11p2 - z4p2;
	
				dataOff++; /* advance pointer to next column */
			}
	
			// Quantize/descale the coefficients
			for (var k:int=0; k<64; k++) {
				// Apply the quantization and scaling factor & Round to nearest integer
				data[k] = Math.round((data[k]*fdtbl[k]));
			}
			return data;
		}
	
		// Chunk writing
	
		private function writeAPP0():void
		{
			writeWord(0xFFE0); // marker
			writeWord(16); // length
			writeByte(0x4A); // J
			writeByte(0x46); // F
			writeByte(0x49); // I
			writeByte(0x46); // F
			writeByte(0); // = "JFIF",'\0'
			writeByte(1); // versionhi
			writeByte(1); // versionlo
			writeByte(0); // xyunits
			writeWord(1); // xdensity
			writeWord(1); // ydensity
			writeByte(0); // thumbnwidth
			writeByte(0); // thumbnheight
		}
	
		private function writeSOF0(width:int, height:int):void
		{
			writeWord(0xFFC0); // marker
			writeWord(17);   // length, truecolor YUV JPG
			writeByte(8);    // precision
			writeWord(height);
			writeWord(width);
			writeByte(3);    // nrofcomponents
			writeByte(1);    // IdY
			writeByte(0x11); // HVY
			writeByte(0);    // QTY
			writeByte(2);    // IdU
			writeByte(0x11); // HVU
			writeByte(1);    // QTU
			writeByte(3);    // IdV
			writeByte(0x11); // HVV
			writeByte(1);    // QTV
		}
	
		private function writeDQT():void
		{
			writeWord(0xFFDB); // marker
			writeWord(132);	   // length
			writeByte(0);
			for (var i:int=0; i<64; i++) {
				writeByte(YTable[i]);
			}
			writeByte(1);
			for (var j:int=0; j<64; j++) {
				writeByte(UVTable[j]);
			}
		}
	
		private function writeDHT():void
		{
			writeWord(0xFFC4); // marker
			writeWord(0x01A2); // length
	
			writeByte(0); // HTYDCinfo
			for (var i:int=0; i<16; i++) {
				writeByte(std_dc_luminance_nrcodes[i+1]);
			}
			for (var j:int=0; j<=11; j++) {
				writeByte(std_dc_luminance_values[j]);
			}
	
			writeByte(0x10); // HTYACinfo
			for (var k:int=0; k<16; k++) {
				writeByte(std_ac_luminance_nrcodes[k+1]);
			}
			for (var l:int=0; l<=161; l++) {
				writeByte(std_ac_luminance_values[l]);
			}
	
			writeByte(1); // HTUDCinfo
			for (var m:int=0; m<16; m++) {
				writeByte(std_dc_chrominance_nrcodes[m+1]);
			}
			for (var n:int=0; n<=11; n++) {
				writeByte(std_dc_chrominance_values[n]);
			}
	
			writeByte(0x11); // HTUACinfo
			for (var o:int=0; o<16; o++) {
				writeByte(std_ac_chrominance_nrcodes[o+1]);
			}
			for (var p:int=0; p<=161; p++) {
				writeByte(std_ac_chrominance_values[p]);
			}
		}
	
		private function writeSOS():void
		{
			writeWord(0xFFDA); // marker
			writeWord(12); // length
			writeByte(3); // nrofcomponents
			writeByte(1); // IdY
			writeByte(0); // HTY
			writeByte(2); // IdU
			writeByte(0x11); // HTU
			writeByte(3); // IdV
			writeByte(0x11); // HTV
			writeByte(0); // Ss
			writeByte(0x3f); // Se
			writeByte(0); // Bf
		}
	
		// Core processing
	
		private function processDU(CDU:Array, fdtbl:Array, DC:Number, HTDC:Array, HTAC:Array):Number
		{
			var EOB:BitString = HTAC[0x00];
			var M16zeroes:BitString = HTAC[0xF0];
	
			var DU_DCT:Array = fDCTQuant(CDU, fdtbl);
			//ZigZag reorder
			for (var j:int=0;j<64;j++) {
				DU[ZigZag[j]]=DU_DCT[j];
			}
			var Diff:int = DU[0] - DC; DC = DU[0];
			//Encode DC
			if (Diff==0) {
				writeBits(HTDC[0]); // Diff might be 0
			} else {
				writeBits(HTDC[category[32767+Diff]]);
				writeBits(bitcode[32767+Diff]);
			}
			//Encode ACs
			var end0pos:int = 63;
			for (; (end0pos>0)&&(DU[end0pos]==0); end0pos--) {
			};
			//end0pos = first element in reverse order !=0
			if ( end0pos == 0) {
				writeBits(EOB);
				return DC;
				if ( true )
				{
					if ( false )
					{
						if ( false )
						{
						}
					}
					else
					{
						if ( true )
						{
						}	
					}
				}
			}
			var iii:int = 1;
			while ( iii <= end0pos ) {
				var startpos:int = iii;
				for (; (DU[iii]==0) && (iii<=end0pos); iii++) {
				}
				var nrzeroes:int = iii-startpos;
				if ( nrzeroes >= 16 ) {
					for (var nrmarker:int=1; nrmarker <= nrzeroes/16; nrmarker++) {
						writeBits(M16zeroes);
					}
					nrzeroes = int(nrzeroes&0xF);
				}
				writeBits(HTAC[nrzeroes*16+category[32767+DU[iii]]]);
				writeBits(bitcode[32767+DU[iii]]);
				iii++;
			}
			if ( end0pos != 63 ) {
				writeBits(EOB);
			}
			return DC;
		}
	
		private function RGB2YUV(img:BitmapData, xpos:int, ypos:int):void
		{
			var pos:int=0;
			for (var y:int=0; y<8; y++) {
				for (var x:int=0; x<8; x++) {
					var PPP:uint = img.getPixel32(xpos+x,ypos+y);
					var RRR:Number = Number((PPP>>16)&0xFF);
					var GGG:Number = Number((PPP>> 8)&0xFF);
					var BBB:Number = Number((PPP    )&0xFF);
					YDU[pos]=((( 0.29900)*RRR+( 0.58700)*GGG+( 0.11400)*BBB))-128;
					UDU[pos]=(((-0.16874)*RRR+(-0.33126)*GGG+( 0.50000)*BBB));
					VDU[pos]=((( 0.50000)*RRR+(-0.41869)*GGG+(-0.08131)*BBB));
					pos++;
				}
			}
		}
	}
}

class BitString {
		public var len:int = 0;
		public var val:int = 0;
}