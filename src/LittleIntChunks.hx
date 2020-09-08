package;

/**
 * underlaying class of BigInt-abstract
 * to store integers into array of little chunks
 * 
 * by Sylvio Sell, Rostock 2020
 * 
 */

typedef LittleInt = Int;
typedef LittleIntArray = Array<LittleInt>; // TODO: can be optimized later for JS here (UInt32Array for example)

@:access(BigInt)
class LittleIntChunks {
	
	// chunksize need to be Little enough to multiplicate 2 LittleInts without leaving range
	
	// TODO: use a haxe-define for easy switch with conditional compiling here
	
	// for testing
	//static public inline var BITSIZE:Int = 7;
	//static public inline var UPPESTBIT:Int = 0x80;
	//static public inline var BITMASK:Int = 0x7F;
		
	// save for multiplication is 15 Bit per LittleInt on all platforms
	
	#if bigint64 // if LittleInt is native 64 Bit Integer:
		static public inline var BITSIZE:Int = 31;
		static public inline var UPPESTBIT:Int = 0x80000000;
		static public inline var BITMASK:Int = 0x7FFFFFFF;

	#else // if LittleInt is native 32 Bit Integer (neko):
		static public inline var BITSIZE:Int = 15;
		static public inline var UPPESTBIT:Int = 0x8000;
		static public inline var BITMASK:Int = 0x7FFF;
	#end
	
	// --------------------------------------------------------------------
	
	var chunks:LittleIntArray;
	public var isNegative:Bool = false;
	
	// for splitting only start/end is changing for each part
	var start:Int = 0;
	var end:Int = 0;
	
	public var length(get, never):Int;
	inline function get_length():Int return end - start;
	
	
	public inline function new(chunks:LittleIntArray = null) {
		if (chunks != null)	this.chunks = chunks;
		else this.chunks = new LittleIntArray();
	}
		
	public inline function copy():LittleIntChunks {
		var littleIntChunks = new LittleIntChunks();
		for (i in 0...length) littleIntChunks.push(get(i));
		littleIntChunks.isNegative = isNegative;
		return littleIntChunks;
	}
	
	public inline function negCopy():LittleIntChunks {
		var littleIntChunks = new LittleIntChunks();
		for (i in 0...length) littleIntChunks.push(get(i));
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
		return chunks[start + i];
	}
	
	public inline function set(i:Int, v:LittleInt) {
		chunks[start + i] = v;
	}
	
	public inline function push(v:LittleInt) {
		end++;
		chunks.push(v);
	}
	
	public inline function pop():LittleInt {
		end--;
		return chunks.pop();
	}
	
	public inline function unshift(v:LittleInt) {		
		end++;			
		chunks.unshift(v);
	}
	
	public inline function truncateZeroChunks(remove:Bool) {		
		var i = length;
		while ( --i >= 0) {
			if (get(i) == 0) {
				if (remove) pop() else end--;
			}
			else i = 0;
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
				if ( (tmp << (i * BITSIZE)) >> (i * BITSIZE) != tmp )
					throw('Error, BigInt with ${BITSIZE*(length-1)+IntUtil.bitsize(tmp)} bits is to big for native Integer length');
				
				littleInt += (tmp << (i * BITSIZE));
			}
			return (isNegative) ? -littleInt : littleInt;
		}
	}
	
	// ---------- From/To String -------------------

	static var regexSpaces = ~/\s+/g;
	static var regexLeadingZeros = ~/^0*/g;
	static var regexBinary = ~/^0b/;
	static var regexOctal = ~/^0o/;
	static var regexHex = ~/^0x/;
	static var regexSign = ~/^-/;
	static var regexZero = ~/^-?(0b|0o|0x)?[0\s]*$/;
		
	public static function createFromBaseString(s:String, base:Null<Int> = null):BigInt {

		// make lowercase and parse out all spaces
		s = regexSpaces.replace(s.toLowerCase(), "");
		
		// checking zero
		if (regexZero.match(s)) return null;
		
		// check sign
		var neg = false;
		if (regexSign.match(s)) {
			s = regexSign.replace(s, "");
			neg = true;
		}
		
		if (base != null) {
			return fromBaseString(regexLeadingZeros.replace(s, ""), base, neg);
		}
		else {

			if (regexBinary.match(s)) 
				return fromBinaryString(regexLeadingZeros.replace(regexBinary.replace(s, ""), ""), neg);
			else if (regexHex.match(s))
				return fromHexString(regexLeadingZeros.replace(regexHex.replace(s, ""), ""), neg);
			else if (regexOctal.match(s)) 
				return fromBaseString(regexLeadingZeros.replace(regexOctal.replace(s, ""), ""), 8, neg);
			else
				return fromBaseString(regexLeadingZeros.replace(s, ""), 10, neg);
		}
	}
	
	public static inline function getStringOfZeros(amount:Int):String {
		return [for (i in 0...amount) "0"].join("");
	}
	
	// ------ Parsing String from Number to a defined Base ------------
	
	static inline function fromBaseString(s:String, base:Int = 10, neg:Bool):BigInt {
		
		// TODO: optional param for custom chars (only hexaChars yet)
		if (base < 2)  throw('Error, base $base need to be greater or equal 2');
		if (base > 16) throw('Error, base $base for string output is to great. Max value can be ${hexaChars.length}');

		var i = s.length;
		var b:BigInt = 1;
		var value:BigInt = 0;
		var offset:Int;
		
		while (i > 0) {
			offset = hexaChars.indexOf(s.charAt(--i));
			if (offset == -1 || offset >= base) throw('Error, base $base string can only contain "${hexaChars.join("")}"');
			value = value + BigInt.mulLittle(b, offset);
			b = b * base; 
		}
		return (neg) ? value.setNegative() : value;
	}
	
	public function toBaseString(base:Int = 10, spacing:Int = 0, leadingZeros:Bool = false):String {
		
		// TODO: optional param for custom chars (only hexaChars yet)
		if (base < 2)  throw('Error, base $base need to be greater or equal 2');
		if (base > 16) throw('Error, base $base for string output is to great. Max value can be ${hexaChars.length}');
		
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
			s = hexaChars[ret.remainder.toInt()] + s;			
		}
		
		if (leadingZeros && spacing > 0) {
			if (j % spacing != 0) s = getStringOfZeros(spacing - j % spacing) + s;
			s = ~/^(0+\s)+/.replace(s, "");
		}

		return ((isNegative) ? "-" : "") + s;
	}
	
	// ---------- fast parsing Binary String -------------------
	
	static public inline function fromBinaryString(s:String, neg:Bool):BigInt {
		
		var littleIntChunks = new LittleIntChunks();
		littleIntChunks.isNegative = neg;
		var i = s.length;
		var bit:Int = 1;
		var chunk:Int = 0;
		
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
			s = ~/^(0+\s)+/.replace(s, "");
		}
		else s = regexLeadingZeros.replace(s, "");
		
		return ((isNegative) ? "-" : "") + s;
	}
	
	
	// ---------- fast parsing Hexadecimal String -------------------
	
	static var hexaChars = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
	
	static public inline function fromHexString(s:String, neg:Bool):BigInt {
		
		var littleIntChunks = new LittleIntChunks();
		littleIntChunks.isNegative = neg;
		var i = s.length;
		var bit:Int = 1;
		var chunk:Int = 0;
		var offset:Int;
		
		while (i > 0) {
			offset = hexaChars.indexOf(s.charAt(--i));
			if (offset == -1) throw('Error, hexadecimal string can only contain "${hexaChars.join("")}"');
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
		
		if (chunk != 0) littleIntChunks.push(chunk);
		return new BigInt(littleIntChunks);
	}
	
	public function toHexString(spacing:Int = 0, leadingZeros:Bool = true):String {
		
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
				s = hexaChars[chunk & 0x0F] + s;
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
		
		if (restBits > 0) {
			if (spacing > 0) s = ((j++ % spacing == 0) ? " " : "") + s;
			s = hexaChars[chunk & 0x0F] + s;
		}

		if (leadingZeros && spacing > 0) {
			if (j % spacing != 0) s = getStringOfZeros(spacing - j % spacing) + s;
			s = ~/^(0+\s)+/.replace(s, "");
		}
		else s = regexLeadingZeros.replace(s, "");
		
		return ((isNegative) ? "-" : "") + s;
	}
		

}
