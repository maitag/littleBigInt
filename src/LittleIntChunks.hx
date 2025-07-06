package;
import haxe.io.Bytes;

/**
 * underlaying class of BigInt-abstract
 * to store integers into array of little chunks
 * 
 * by Sylvio Sell, Rostock 2020
 * 
 */

typedef LittleInt = Int; // TODO: could be also Int64 (needs some fixes at place where only used Int yet!)

@:access(BigInt)
class LittleIntChunks {
	
	// chunksize need to be Little enough to multiplicate 2 LittleInts without leaving range
	// so save for multiplication is 15 Bit per LittleInt on all platforms
	
	#if bigint64 // if LittleInt is native 64 Bit Integer <- TODO !!!!
		static public inline var BITSIZE:Int = 31;
		static public inline var UPPESTBIT:Int = 0x80000000;
		static public inline var BITMASK:Int = 0x7FFFFFFF;
	
	#else // if LittleInt is native 32 Bit Integer:
		
		static public inline var BITSIZE:Int = 15;
		static public inline var UPPESTBIT:Int = 0x8000;
		static public inline var BITMASK:Int = 0x7FFF;
		// for js there can't be used 26 bits here
		// because interpreter will convert all float64 at each binary-op into 32bit
		
/*		// for testing purpose
		static public inline var BITSIZE:Int = 7;
		static public inline var UPPESTBIT:Int = 0x80;
		static public inline var BITMASK:Int = 0x7F;
*/		
	#end
	
	// --------------------------------------------------------------------
	
	var chunks:Chunks<LittleInt>;
	public var isNegative:Bool = false;
	
	// for splitting only start/end is changing for each part
	var start:Int = 0;
	var end:Int = 0;
	
	public var length(get, never):Int;
	inline function get_length():Int return end - start;
	
	
	public inline function new(chunks:Chunks<LittleInt> = null) {
		if (chunks != null)	this.chunks = chunks;
		else this.chunks = new Chunks<LittleInt>();
	}
		
	public inline function copy():LittleIntChunks {
		var littleIntChunks = new LittleIntChunks(chunks.slice(start, end));
		littleIntChunks.end = end - start;

		littleIntChunks.isNegative = isNegative;
		return littleIntChunks;
	}
	
	public inline function negCopy():LittleIntChunks {
		var littleIntChunks = new LittleIntChunks(chunks.slice(start, end));
		littleIntChunks.end = end - start;

		littleIntChunks.isNegative = ! isNegative;
		return littleIntChunks;
	}
	
	public inline function clone():LittleIntChunks {
		var littleIntChunks = new LittleIntChunks(chunks);
		littleIntChunks.start = start;
		littleIntChunks.end = end;
		littleIntChunks.isNegative = isNegative;
		return littleIntChunks;
	}
	
	public inline function negClone():LittleIntChunks {
		var littleIntChunks = new LittleIntChunks(chunks);
		littleIntChunks.start = start;
		littleIntChunks.end = end;
		littleIntChunks.isNegative = ! isNegative;
		return littleIntChunks;
	}
		
	public inline function splitHigh(e:Int):LittleIntChunks {
		var littleIntChunks = new LittleIntChunks(chunks);
		if (e >= length) return null;
		littleIntChunks.start = start + e;
		littleIntChunks.end = end;
		return littleIntChunks;
	}
	
	public inline function splitLow(e:Int):LittleIntChunks {
		var i = 0;
		if (start + e > end) e = end - start;
		while (i < e && get(i) == 0) i++;
		if (i == e) return null;
		else {
			var littleIntChunks = new LittleIntChunks(chunks);
			littleIntChunks.start = start;
			littleIntChunks.end = start + e;
			return littleIntChunks;
		}
	}
	
	public inline function get(i:Int):LittleInt {
		return chunks.get(start + i);
	}
	
	public inline function set(i:Int, v:LittleInt) {
		chunks.set(start + i, v);
	}
	
	public inline function push(v:LittleInt) {
		chunks.push(end++, v);
	}
	
	public inline function pop():LittleInt {
		return chunks.pop(--end);
	}
	
	public inline function unshift(v:LittleInt) {
		chunks.unshift(++end, v);
	}
	
	public inline function truncateZeroChunks(remove:Bool) {
		if (this == null) return;

		var i = (remove) ? length : end;
		
		while ( --i >= 0) {
			if (get(i) == 0) {
				if (remove) pop() else end--;
			}
			else break;
		}
	}
	
	// ---------- From/ToInteger -------------------
	
	public static inline function createFromLittleInt(i:LittleInt):LittleIntChunks {
		
		if (i == 0) return null;
		var littleIntChunks = new LittleIntChunks();
		if (i < 0) {
			littleIntChunks.isNegative = true;
			//if (i == -i) throw('Error, Integer length at maximum'); // TODO: same for UInt
			i = -i;
		}
		while (i != 0) {
			littleIntChunks.push(i & BITMASK);
			i = i >>> BITSIZE;
		}
		return littleIntChunks;
	}
	
	public inline function toLittleInt():LittleInt {
		
		if (length == 0) return 0;
		else {
			var littleInt:LittleInt = 0;
			var tmp:LittleInt = 0;
			for (i in 0...length) {
				tmp = get(i);
				// TODO : BIG INT 6 4 (^_^)
				if ( ((tmp << (i * BITSIZE)) >> (i * BITSIZE)) != tmp )
					throw('Error, BigInt with ${BITSIZE*(length-1)+IntUtil.bitsize(tmp)} bits is to big for native Integer length');
				
				littleInt += (tmp << (i * BITSIZE));
			}
			return (isNegative) ? -littleInt : littleInt;
		}
	}
	
	// ---------- From/To String -------------------
	
	static var regexSpaces = ~/\s+/g;
	static var regexLeadingZeros = ~/^0*/g;
	static var regexLeadingZeroBlocks = ~/^(0+\s)+/g;
	static var regexBinary = ~/^0b/;
	static var regexOctal = ~/^0o/;
	static var regexHex = ~/^0x/;
	static var regexSign = ~/^-/;
	static var regexForbiddenDigitChars = ~/\s|-/g;
	
	public static function createFromBaseString(s:String, base:Null<Int> = null, digitChars:Null<String> = null):BigInt {
		
		s = regexSpaces.replace(s, "");	// parse out all spaces	
		if (digitChars == null) s = s.toLowerCase();
		
		// check sign
		var neg = false;
		if (regexSign.match(s)) {
			s = regexSign.replace(s, "");
			neg = true;
		}
		
		if (base != null) return fromBaseString(s, base, digitChars, neg);
		else {
			if (regexBinary.match(s)) return fromBinaryString(regexBinary.replace(s, ""), neg);
			else if (regexHex.match(s)) return fromHexString(regexHex.replace(s, ""), neg);
			else if (regexOctal.match(s)) return fromBaseString(regexOctal.replace(s, ""), 8, digitChars, neg);
			else return fromBaseString(s, 10, digitChars, neg);
		}
	}
	
	public static inline function getStringOfZeros(amount:Int, zeroDigitChar:String = "0"):String {
		return [for (i in 0...amount) zeroDigitChar].join("");
	}
	
	// ------ Parsing String from Number to a defined Base ------------
	static inline function fromBaseString(s:String, base:Int = 10, digitChars:Null<String>, neg:Bool):BigInt {
		
		if (base < 2)  throw('Error, base $base need to be greater or equal 2');
		
		if (digitChars == null) {
			digitChars = hexaChars;
			s = regexLeadingZeros.replace(s, "");
		}
		else
		{
			if (digitChars.length < 2) throw('Error, the string for the digits needs to contain at least 2 chars');
			if (regexForbiddenDigitChars.match(digitChars)) throw("Error, the string for the digits should not contain spacing or '-' chars");
			s = new EReg("^" + digitChars.charAt(0) + "*", "g").replace(s, "");
		}
		
		if (s.length == 0) return null; // all was filled by zero
		
		if (base > digitChars.length) throw('Error, base $base for numberstring is to great. Max value can be ${digitChars.length}');
		
		var i = s.length;
		var b:BigInt = 1;
		var value:BigInt = 0;
		var offset:Int;
		
		while (i > 0) {
			offset = digitChars.indexOf(s.charAt(--i));
			if (offset == -1 || offset >= base) throw('Error, base $base string can only contain "${digitChars}"');
			value = BigInt._add(value, BigInt.mulLittle(b, offset));
			b = b * base;
			//b = BigInt.mulLittle(b, base); // for only 7 bitsize base can't be more then 128 here
		}
		return (neg) ? value.setNegative() : value;
	}
	
	public function toBaseString(base:Int = 10, digitChars:Null<String> = null, spacing:Int = 0, leadingZeros:Bool = true):String {
		
		if (base < 2)  throw('Error, base $base need to be greater or equal 2');
		
		var zeroDigitChar = "0";
		
		if (digitChars == null) {
			digitChars = hexaChars;
		}
		else {
			if (digitChars.length < 2) throw('Error, the string for the digits needs to contain at least 2 chars');
			if (regexForbiddenDigitChars.match(digitChars)) throw("Error, the string for the digits should not contain spacing or '-' chars");
			zeroDigitChar = digitChars.charAt(0);
		}
		
		if (base > digitChars.length) throw('Error, base $base for numberstring is to great. Max value can be ${digitChars.length}');
		
		var s = "";
		var a = new BigInt(this).clone().setPositive();
		var j:Int = 0;
		var ret:{quotient:BigInt, remainder:BigInt};
		
		while (a != null) {
			ret = BigInt.divMod(a, base);
			a = ret.quotient;
			if (spacing > 0) {
				s = ((j != 0 && j % spacing == 0) ? " " : "") + s;
				j++;
			}
			s = digitChars.charAt(ret.remainder.toInt()) + s;
		}
		
		if (leadingZeros && spacing > 0) {
			if (j % spacing != 0) s = getStringOfZeros(spacing - j % spacing, zeroDigitChar) + s;
			s = new EReg("^("+zeroDigitChar+"+\\s)+","g").replace(s, "");
		}
		else {
			s = new EReg("^("+zeroDigitChar+"+\\s)+","g").replace(s, "");
			s = new EReg("^"+zeroDigitChar+"*","g").replace(s, "");
		}
		
		return ((isNegative) ? "-" : "") + s;
	}
	
	// ---------- fast parsing Binary String -------------------
	
	static public inline function fromBinaryString(s:String, neg:Bool):BigInt {
		
		s = regexLeadingZeros.replace(s, "");
		if (s.length == 0) return null; // all was filled by zero		
		
		var littleIntChunks = new LittleIntChunks();
		littleIntChunks.isNegative = neg;
		var i = s.length;
		var bit:Int = 1;
		var chunk:LittleInt = 0;
		
		while (i > 0) {
			switch (s.charAt(--i)) {
				case "0":
				case "1": chunk += bit;
				default: throw('Error, binary string can only contain "0" or "1"');
			}
			bit = bit << 1;
			if (bit == UPPESTBIT) {
				littleIntChunks.push(chunk);
				bit = 1;
				chunk = 0;
			}
		}
		
		if (bit > 1) littleIntChunks.push(chunk);
		return new BigInt(littleIntChunks);
	}
	
	public inline function toBinaryString(spacing:Int = 0, leadingZeros:Bool = true):String {
		
		var s = "";
		var chunk:LittleInt;
		var bit:Int;
		var j:Int = 0;
		
		for (i in 0...length) {
			chunk = get(i);
			bit = 1;
			while (bit < UPPESTBIT) {
				if (spacing > 0) s = ((j % spacing == 0 && spacing>0 && j != 0) ? " " : "") + s;
				s = (((bit & chunk) == 0) ? "0" : "1") + s;
				j++;
				bit = bit << 1;
			}
		}
		
		if (leadingZeros && spacing > 0) {
			if (j % spacing != 0) s = getStringOfZeros(spacing - j % spacing) + s;
			s = regexLeadingZeroBlocks.replace(s, "");
		}
		else {
			s = regexLeadingZeroBlocks.replace(s, "");
			s = regexLeadingZeros.replace(s, "");
		}
		
		return ((isNegative) ? "-" : "") + s;
	}
	
	
	// ---------- fast parsing Hexadecimal String -------------------
	
	static var hexaChars:String = "0123456789abcdef";
	
	static public inline function fromHexString(s:String, neg:Bool):BigInt {
		
		s = regexLeadingZeros.replace(s, "");
		if (s.length == 0) return null; // all was filled by zero
		
		var littleIntChunks = new LittleIntChunks();
		littleIntChunks.isNegative = neg;
		var i = s.length;
		var bit:Int = 1;
		var chunk:LittleInt = 0;
		var offset:Int;
		
		while (i > 0) {
			offset = hexaChars.indexOf(s.charAt(--i));
			if (offset == -1) throw('Error, hexadecimal string can only contain "${hexaChars}"');
			chunk += offset * bit;
			bit = bit << 4;
			if (bit >= UPPESTBIT) {
				littleIntChunks.push(chunk & BITMASK);
				
				if (bit == UPPESTBIT) bit = 1;
				else if (bit == UPPESTBIT << 1) bit = 1 << 1;
				else if (bit == UPPESTBIT << 2) bit = 1 << 2;
				else bit = 1 << 3;
				
				chunk = chunk >> BITSIZE;
			}
		}
		// TODO: chunk can be greater then BITSIZE here also ?
		if (chunk != 0) littleIntChunks.push(chunk);
		return new BigInt(littleIntChunks);
	}
	
	public function toHexString(upperCase:Bool = true, spacing:Int = 0, leadingZeros:Bool = true):String {
		
		var s = "";
		var chunk:LittleInt = 0;
		var restBits:Int = 0;
		var j:Int = 0;
		
		for (i in 0...length) {
			chunk = (get(i) << restBits) + chunk;
			while (BITSIZE + restBits >= 4) {
				if (spacing > 0) {
					s = ((j != 0 && j % spacing == 0) ? " " : "") + s;
					j++;
				}
				s = hexaChars.charAt(chunk & 0x0F) + s;
				chunk = chunk >> 4;
				restBits -= 4;
			}
			restBits = BITSIZE + restBits;
			switch (restBits) {
				case 0: chunk = 0;
				case 1: chunk &= 1;
				case 2: chunk &= 3;
				default: chunk &= 7;
			}
		}
		
		if (restBits > 0 && chunk > 0) {
			if (spacing > 0) s = ((j++ % spacing == 0) ? " " : "") + s;
			s = hexaChars.charAt(chunk & 0x0F) + s;
		}
		
		if (leadingZeros && spacing > 0) {
			if (j % spacing != 0) s = getStringOfZeros(spacing - j % spacing) + s;
			s = regexLeadingZeroBlocks.replace(s, "");
		}
		else {
			s = regexLeadingZeroBlocks.replace(s, "");
			s = regexLeadingZeros.replace(s, "");
		}
		
		if (upperCase) s = s.toUpperCase();
		return ((isNegative) ? "-" : "") + s;
	}
	
	static public inline function fromBytes(b:Bytes):BigInt {
		
		if (b.length == 1 && b.get(0) == 0) return null;
		
		var littleIntChunks = new LittleIntChunks();
		
		var l:Int = b.length;
		if (b.get(l-1) == 0) {
			littleIntChunks.isNegative = true;
			l--;
		}
		var numBits:Int = (l - 1) * 8 + IntUtil.bitsize(b.get(l-1), 8);
		var numChunks:Int = Std.int((numBits - 1) / BITSIZE) + 1;
		
		for (i in 0...numChunks) {
			var v:Int = 0;
			var shift:Int = 0;
			for (a in mapFromBitPosition(i*BITSIZE , 8, BITSIZE, l)) {
				v |= (  (b.get(a.index) >>> a.offset) & ((1 << a.size)-1)  ) << shift;
				shift += a.size;
			}
			littleIntChunks.push(v);
		}
		
		return new BigInt(littleIntChunks);
	}
	
	public function toBytes():Bytes {
		
		var numBits:Int = (length - 1) * BITSIZE + IntUtil.bitsize(get(length-1));
		var numChunks:Int = Std.int((numBits - 1) / 8) + 1;
		
		var b:Bytes;
		if (isNegative) {
			b = Bytes.alloc(numChunks + 1);
			b.set(numChunks, 0);
		}
		else b = Bytes.alloc(numChunks);
		
		for (i in 0...numChunks) {
			var v:Int = 0;
			var shift:Int = 0;
			for (a in mapFromBitPosition(i*8 , BITSIZE, 8, length)) {
				v |= (  (get(a.index) >>> a.offset) & ((1 << a.size)-1)  ) << shift;
				shift += a.size;	
			}
			b.set(i, v);
		}
		
		return b;
	}
	
	
	// map bitsized-value from a bitposition
	static inline function mapFromBitPosition(fromBit:Int, fromBitsize:Int, toBitsize:Int, length:Int):Array<{index:Int, offset:Int, size:Int}> {
		var start = Std.int(fromBit/fromBitsize);
		var end = Std.int((fromBit+toBitsize) / fromBitsize);
		
		var startOffset:Int = fromBit - start * fromBitsize;
		var startSize:Int = fromBitsize - startOffset;
		var endSize:Int = (fromBit+toBitsize) - end * fromBitsize;
		
		var offset:Int;
		var size:Int;
		
		var ret = new Array<{index:Int, offset:Int, size:Int}>();
		
		for (i in start...end+1) {
		 	if (i == length) break;
		 	
			if (i == start && i == end) {
				offset = startOffset;
				size = endSize-offset;
			}
			else if (i == start) {
				offset = startOffset;
				size = startSize;
			}
		 	else if (i == end) {
				size = endSize;
				offset = 0;
			}
			else {
				size = fromBitsize;
				offset = 0;
			}
			
			ret.push({index:i, offset:offset, size:size});
		}
		return ret;
	}
	
}
