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


class LittleIntChunks {
	
	// chunksize need to be Little enough to multiplicate 2 LittleInts without leaving range
	
	// TODO: use a haxe-define for easy switch with conditional compiling here
	
	// for testing
	//static public inline var BITSIZE:Int = 7;
	//static public inline var UPPESTBIT:Int = 0x80;
	//static public inline var BITMASK:Int = 0x7F;
		
	// save for multiplication is 15 Bit per LittleInt on all platforms
	
	// if LittleInt is native 32 Bit Integer (neko):
	static public inline var BITSIZE:Int = 15;
	static public inline var UPPESTBIT:Int = 0x8000;
	static public inline var BITMASK:Int = 0x7FFF;
	
	// if LittleInt is native 64 Bit Integer:
	//static public inline var BITSIZE:Int = 31;
	//static public inline var UPPEST:Int = 0x80000000;
	//static public inline var MASK:Int = 0x7FFFFFFF;

	
	// --------------------------------------------------------------------
	
	var chunks:LittleIntArray;
	public var isNegative:Bool = false;
	
	// for splitting only start/end is changing for each part
	var start:Int = 0;
	var end:Int = 0;
	
	// on need: number how much zero-chunks would be right (1 -> like ^0x8000)
	//public var exp:Int = 0; 
	
	public var length(get, never):Int;
	inline function get_length():Int return end - start;
	
	public var isZero(get, never):Bool;
	inline function get_isZero():Bool return (length == 0);
	
	
	public inline function new() {
		chunks = new LittleIntArray();
	}
		
	public inline function clone():LittleIntChunks {
		var littleIntChunks = new LittleIntChunks();
		for (i in 0...length) littleIntChunks.push(get(i));
		return littleIntChunks;
	}
	
	// TODO
/*	public inline function split(size:Int):LittleIntChunks {
		// TODO
		return LittleIntChunks;
	}
*/	
/*	
	// Multiplikaiton helper
	public inline function join3(a:LittleIntChunks, b:LittleIntChunks, c:LittleIntChunks):LittleIntChunks {
		// TODO
		return LittleIntChunks;
	}
*/	
	public inline function get(i:Int):LittleInt {
		return chunks[start + i];
	}
	
	public inline function set(i:Int, v:LittleInt) {
		chunks[start + i] = v;
	}
	
	public inline function push(v:LittleInt) {
		chunks.push(v);
		end++;
	}
	
	public inline function pop():LittleInt {
		end--;
		return chunks.pop();
	}
	
	public inline function truncateZeroChunks(remove:Bool = false) {
		var i = length;
		while ( --i >= 0) {
			if (get(i) == 0) {
				if (remove) pop();
				else end--;
			}
			else i = 0;
		}
	}
	
	// ---------- From/ToInteger -------------------

	public static inline function createFromLittleInt(i:LittleInt):LittleIntChunks {
		var littleIntChunks = new LittleIntChunks();
		if (i < 0) {
			littleIntChunks.isNegative = true;
			i = -i;
		}
		while (i != 0) {
			littleIntChunks.push(i & BITMASK);
			i = i >> BITSIZE;
		}
		return littleIntChunks;
	}

	public inline function toLittleInt():LittleInt {
		if (length == 0) return 0;
		// TODO: fill dependent of what is native Int-bitsize
		else if (length > 1) throw('Error, BigInt is to Big for $BITSIZE bit Int');
		else return (isNegative) ? -get(0) : get(0);
	}
	
	// ---------- From/To String -------------------

	static var regexSpaces = ~/\s+/g;
	static var regexLeadingZeros = ~/^0*/g;
	static var regexBinary = ~/^0b/;
	static var regexOctal = ~/^0o/;
	static var regexHex = ~/^0x/;
	static var regexSign = ~/^-/;
	
	public static function createFromString(s:String):LittleIntChunks {
		
		var littleIntChunks = new LittleIntChunks();
		
		// make lowercase and parse out all spaces
		s = regexSpaces.replace(s.toLowerCase(), "");
		
		// check sign
		if (regexSign.match(s)) {
			s = regexSign.replace(s, "");
			littleIntChunks.isNegative = true;
		}
		
		if (regexBinary.match(s)) 
			littleIntChunks.fromBinaryString(regexLeadingZeros.replace(regexBinary.replace(s, ""), ""));
		else if (regexHex.match(s))
			littleIntChunks.fromHexString(regexLeadingZeros.replace(regexHex.replace(s, ""), ""));
		else if (regexOctal.match(s)) 
			return littleIntChunks.fromBaseString(regexLeadingZeros.replace(regexOctal.replace(s, ""), ""), 8);
		else littleIntChunks.fromBaseString(regexLeadingZeros.replace(s, ""));
		
		if (littleIntChunks.isZero) littleIntChunks.isNegative = false;
		return littleIntChunks;
	}
	
	public inline function toString():String {
		
		//return toBaseString();
		
		// only binary and hexadecimal dummy output yet
		//return toBinaryString();
		return toHexString();		
	}
	
	// ------ Parsing String from Number to a defined Base ------------
	
	inline function fromBaseString(s:String, base:Int = 10):LittleIntChunks {
		
		// TODO: parsing any base needs bigint multiplication first

		throw ("Only supported Binary and Hex stringinput yet");
		return null;
	}
	
	inline function toBaseString(base:Int = 10):String {
		
		// TODO:
		//   split bigint like:  a*10^3 + b*10^2 + c*10^1 + d*10^0
		//   -> needs divMod
		
		return "not yet";
	}
	
	// ---------- Parsing Binary String -------------------
	
	public inline function fromBinaryString(s:String):LittleIntChunks {
		
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
				push(chunk);
				bit = 1;
				chunk = 0;
			}
		}
		
		if (bit > 1) push(chunk);
		return this;
	}
	
	public inline function toBinaryString(spacing:Bool = true):String {
		
		if (isZero) {
			return ((spacing) ? [for (i in 0...8) "0"].join("") : "0");
		}
		
		var s = "";
		var chunk:LittleInt;
		var bit:Int;
		var j:Int = 0;
		
		for (i in 0...length) {
			chunk = get(i);
			bit = 1;
			while (bit < UPPESTBIT) {
				s = (((bit & chunk) == 0) ? "0" : "1") + ((j % 8 == 0 && spacing && j != 0) ? " " : "") + s;
				j++;
				bit = bit << 1;
			}
		}
		if (spacing) {
			if (j % 8 != 0) for (i in 0...(8 - j % 8)) s = "0" + s;
		}
		else s = regexLeadingZeros.replace(s, "");
		
		return ((isNegative) ? "-" : "") + ((spacing) ? ~/^(0+\s)+/.replace(s, "") :  ~/^0+/.replace(s, ""));
	}
	
	
	// ---------- Parsing Hexadecimal String -------------------
	
	static var hexaChars = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
	
	public inline function fromHexString(s:String):LittleIntChunks {
		
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
				push(chunk & BITMASK);
				
				if (bit == UPPESTBIT) bit = 1;
				else if (bit == UPPESTBIT << 1) bit = 1 << 1;
				else if (bit == UPPESTBIT << 2) bit = 1 << 2;
				else bit = 1 << 3;
				
				chunk = chunk >> BITSIZE;
			}
		}
		
		if (chunk != 0) push(chunk);
		return this;
	}
	
	public function toHexString(spacing:Bool = true):String {
		
		if (isZero) {
			return ((spacing) ? [for (i in 0...4) "0"].join("") : "0");
		}
		
		var s = "";
		var chunk:LittleInt = 0;
		var restBits:Int = 0;
		var j:Int = 0;
		
		for (i in 0...length) {
			chunk = (get(i) << restBits) + chunk;
			while (BITSIZE + restBits >= 4) {
				s = hexaChars[chunk & 0x0F] + ((j++ % 4 == 0 && spacing && i != 0) ? " " : "") + s;
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
		
		if (restBits > 0) s = hexaChars[chunk & 0x0F] + ((j++ % 4 == 0 && spacing) ? " " : "") + s;

		if (spacing && j % 4 != 0) for (i in 0...(4 - j % 4)) s = "0" + s;
		
		return ((isNegative) ? "-" : "") + ((spacing) ? ~/^(0+\s)+/.replace(s, "") :  ~/^0+/.replace(s, ""));
	}
	
	

}
