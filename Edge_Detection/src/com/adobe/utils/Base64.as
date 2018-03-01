/*
* Licensed under the MIT License
* 
* Copyright (c) 2010 Kay Kreuning
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
* 
* http://code.google.com/p/as3hyvesapi
*/
package com.adobe.utils
{
	import flash.utils.ByteArray;
	
	/**
	 * Utility class to encode and decode using the Base64 algorithm.
	 * Based on the excellent 'Base64 Optimized as3 lib' by jpauclair
	 * (see: http://jpauclair.net/2010/01/09/base64-optimized-as3-lib/).
	 * 
	 * @author Kay Kreuning
	 */
	public final class Base64
	{
		/**
		 * Encodes the specified <code>String</code> into a Base64 encoded <code>String</code>.
		 * 
		 * @param str string to encode
		 * @return Base64 encoded string
		 */
		public static function encode(str:String):String
		{
			var data:ByteArray = new ByteArray();
			data.writeUTFBytes(str);
			
			return encodeBytes(data);
		}
		
		/**
		 * Turns the specified string into a big endian compatible string and encodes that into a Base64 encoded string.
		 * 
		 * @param str string to encode
		 * @return Base64 encoded string
		 */
		public static function encodeBigEndian(str:String):String
		{
			str.replace(/\s:|/gm, "");
			
			var data:ByteArray = new ByteArray();
			
			if (str.length & 1 == 1) str = "0" + str;
			
			for (var i:int = 0; i < str.length; i += 2)
			{
				data[int(i * .5)] = parseInt(str.substr(i, 2), 16);
			}
			
			return encodeBytes(data);
		}
		
		/**
		 * Encoded the given <code>ByteArray</code> into a Base64 encoded string.
		 * 
		 * @param data <code>ByteArray</code> to encode
		 * @return Base64 encoded string
		 */
		public static function encodeBytes(data:ByteArray):String
		{
			var out:ByteArray = new ByteArray();
			
			out.length = (2 + data.length - ((data.length + 2) % 3)) * 4 / 3;
			
			var i:int = 0,
				r:int = data.length % 3,
				length:int = data.length - r,
				c:int;
			
			while (i < length)
			{
				c = data[i++] << 16 | data[i++] << 8 | data[i++];
				c = (encodeChars[c >>> 18] << 24) | (encodeChars[c >>> 12 & 0x3F] << 16) | (encodeChars[c >>> 6 & 0x3F] << 8) | encodeChars[c & 0x3F];
				out.writeInt(c);
			}
			
			if (r == 1)
			{
				c = data[i];
				c = (encodeChars[c >>> 2] << 24) | (encodeChars[(c & 0x03) << 4] << 16) | 61 << 8 | 61;
				out.writeInt(c);
			}
			else if (r == 2)
			{
				c = data[i++] << 8 | data[i];
				c = (encodeChars[c >>> 10] << 24) | (encodeChars[c >>> 4 & 0x3F] << 16) | (encodeChars[(c & 0x0F) << 2] << 8) | 61;
				out.writeInt(c);
			}
			
			out.position = 0;
			return out.readUTFBytes(out.length);
		}
		
		/**
		 * Decode a Base64 string into an UTF string.
		 * 
		 * @param str Base64 encoded string to decode
		 * @return decoded string
		 */
		public static function decoderToString(str:String):String
		{
			var data:ByteArray = decode(str);
			data.position = 0;
			
			return data.readUTFBytes(data.length);
		}
		
		/**
		 * Decode a Base64 string into a <code>ByteArray</code>.
		 * 
		 * @param str Base64 encoded string to decode
		 * @return decoded <code>ByteArray</code>
		 */
		public static function decode(str:String):ByteArray
		{
			var c1:int,
				c2:int,
				c3:int,
				c4:int,
				i:int = 0,
				length:int = str.length,
				out:ByteArray = new ByteArray(),
				byteString:ByteArray = new ByteArray();
			
			byteString.writeUTFBytes(str);
			
			while (i < length)
			{
				// c1
				do {
					c1 = decodeChars[byteString[i++]]
				} while (i < length && c1 == -1);
				if (c1 == -1) break;
				
				// c2
				do {
					c2 = decodeChars[byteString[i++]];
				} while (c2 == -1);
				if (c2 == -1) break;
				
				out.writeByte((c1 << 2) | ((c2 & 0x30) >> 4));
				
				// c3
				do {
					c3 = byteString[i++];
					if (c3 == 61) return out;
					
					c3 = decodeChars[c3];
				} while (i < length && c3 == -1);
				if (c3 == -1) break;
				
				out.writeByte(((c2 & 0x0F) << 4) | ((c3 & 0x3C) >> 2));
				
				// c4
				do {
					c4 = byteString[i++];
					if (c4 == 61) return out;
					
					c4 = decodeChars[c4];
				} while (i < length && c4 == -1);
				if (c4 == -1) break;
				
				out.writeByte(((c3 & 0x03) << 6) | c4);
			}
			
			return out;
		}
		
		private static const encodeChars:Array = [
			65, 66, 67, 68, 69, 70, 71, 72,
			73, 74, 75, 76, 77, 78, 79, 80,
			81, 82, 83, 84, 85, 86, 87, 88,
			89, 90, 97, 98, 99, 100, 101, 102,
			103, 104, 105, 106, 107, 108, 109, 110,
			111, 112, 113, 114, 115, 116, 117, 118,
			119, 120, 121, 122, 48, 49, 50, 51,
			52, 53, 54, 55, 56, 57, 43, 47
		];
		
		private static const decodeChars:Array = [
			-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
			-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
			-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,
			52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,
			-1,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
			15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1,
			-1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
			41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1
			-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
			-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
			-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
			-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
			-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
			-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
			-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
			-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
		];
	}
}