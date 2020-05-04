typedef SmallInt = Int;
typedef SmallIntArray = Array<SmallInt>; // TODO: can be optimized later for JS here (UInt32Array for example)


class SmallIntChunks {
	
	// save for multiplication is 15 Bit per SmallInt on all platforms
/*	static public inline var BITSIZE:Int = 7;
	static public inline var UPPESTBIT:Int = 0x80;
	static public inline var BITMASK:Int = 0x7F;
*/		
	static public inline var BITSIZE:Int = 15;
	static public inline var UPPESTBIT:Int = 0x8000;
	static public inline var BITMASK:Int = 0x7FFF;
		
	//static public inline var BITSIZE:Int = 31;
	//static public inline var UPPEST:Int = 0x80000000;
	//static public inline var MASK:Int = 0x7FFFFFFF;

	var chunks:SmallIntArray;
	var isNegative:Bool = false;
	
	// for splitting only start/end is changing for each part
	public var start:Int = 0;
	public var end:Int = 0;
	
	// on need: number how much zero-chunks would be right (1 -> like ^0x8000)
	//public var exp:Int = 0; 
	
	public var length(get, never):Int;
	inline function get_length():Int return end-start;
	
	
	public inline function new() {
		chunks = new SmallIntArray();
	}
		
	public inline function clone():SmallIntChunks {
		var smallIntChunks = new SmallIntChunks();
		for (v in this.chunks) smallIntChunks.add(v); // TODO: only start to end ?
		return smallIntChunks;
	}
	
	// TODO
/*	public inline function split(size:Int):SmallIntChunks {
		// TODO
		return smallIntChunks;
	}
*/	
/*	
	// Multiplikaiton helper
	public inline function join3(a:SmallIntChunks, b:SmallIntChunks, c:SmallIntChunks):SmallIntChunks {
		// TODO
		return smallIntChunks;
	}
*/	
	public inline function get(i:Int):SmallInt {
		return chunks[i];
	}
	
	public inline function set(i:Int, v:SmallInt) {
		chunks[i] = v;
	}
	
	public inline function add(v:SmallInt) {
		chunks.push(v);
		end++;
	}
	
	// ---------- From/ToInteger -------------------

	public static inline function CreateFromSmallInt(i:SmallInt):SmallIntChunks {
		var smallIntChunks = new SmallIntChunks();
		if (i < 0) {
			smallIntChunks.isNegative = true;
			i = -i;
		}
		while (i != 0) {
			smallIntChunks.add(i & BITMASK);
			i = i >> BITSIZE;
		}
		return smallIntChunks;
	}

	public inline function toSmallInt():SmallInt {
		if (length == 0) return 0;
		// TODO: fill dependent of what is native Int-bitsize
		else if (length > 1) throw('Error, BigInt is to Big for $BITSIZE bit Int');
		else return (isNegative) ? -get(0) : get(0);
	}
	
	// ---------- From/To String -------------------

	static var regexSpaces = ~/\s+/g;
	static var regexBinary = ~/^0b0*/;
	static var regexOctal = ~/^0o0*/;
	static var regexHex = ~/^0x0*/;
	static var regexSign = ~/^-/;
	
	public static function CreateFromString(s:String):SmallIntChunks {
		
		var smallIntChunks = new SmallIntChunks();
		
		// make lowercase and parse out all spaces
		s = regexSpaces.replace(s.toLowerCase(), "");
		
		// check sign
		if (regexSign.match(s)) {
			s = regexSign.replace(s, "");
			smallIntChunks.isNegative = true;
		}
		
		if (regexBinary.match(s)) return smallIntChunks.fromBinaryString(regexBinary.replace(s, ""));
		else if (regexHex.match(s)) return smallIntChunks.fromHexString(regexHex.replace(s, ""));
		else if (regexOctal.match(s)) return smallIntChunks.fromBaseString(regexOctal.replace(s, ""), 8);
		else return smallIntChunks.fromBaseString(s);		
	}
	
	public inline function toString():String {
		
		//return toBaseString();
		
		// only binary and hexadecimal dummy output yet
		//return toBinaryString();
		return toHexString();		
	}
	
	// ------ Parsing String from Number to a defined Base ------------
	
	inline function fromBaseString(s:String, base:Int = 10):SmallIntChunks {
		
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
	
	inline function fromBinaryString(s:String):SmallIntChunks {
		
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
				add(chunk);
				bit = 1;
				chunk = 0;
			}
		}
		
		if (bit > 1) add(chunk);
		return this;
	}
	
	public inline function toBinaryString(spacing:Bool = true):String {
		
		var s = "";
		var chunk:SmallInt;
		var bit:Int;
		var j:Int = 0;
		
		for (i in start...end) {
			chunk = get(i);
			bit = 1;
			while (bit < UPPESTBIT) {
				s = (((bit & chunk) == 0) ? "0" : "1") + ((j++ % 8 == 0 && spacing) ? " " : "") + s;
				bit = bit << 1;
			}
		}
		
		for (i in 0...(8 - j % 8)) s = "0" + s;
		
		return ((isNegative) ? "-" : "") + ((spacing) ? ~/^(0+\s)+/.replace(s, "") :  ~/^0+/.replace(s, ""));
	}
	
	
	// ---------- Parsing Hexadecimal String -------------------
	
	static var hexaChars = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
	
	inline function fromHexString(s:String):SmallIntChunks {
		
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
				add(chunk & BITMASK);
				
				if (bit == UPPESTBIT) bit = 1;
				else if (bit == UPPESTBIT << 1) bit = 1 << 1;
				else if (bit == UPPESTBIT << 2) bit = 1 << 2;
				else bit = 1 << 3;
				
				chunk = chunk >> BITSIZE;
			}
		}
		
		if (chunk != 0) add(chunk);
		return this;
	}
	
	public inline function toHexString(spacing:Bool = true):String {
		
		var s = "";
		var chunk:SmallInt = 0;
		var restBits:Int = 0;
		var j:Int = 0;
		
		for (i in start...end) {
			chunk = (get(i) << restBits) + chunk;
			while (BITSIZE + restBits >= 4) {
				s = hexaChars[chunk & 0x0F] + ((j++ % 4 == 0 && spacing) ? " " : "") + s;
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

		if (j % 4 != 0) for (i in 0...(4 - j % 4)) s = "0" + s;
		
		return ((isNegative) ? "-" : "") + ((spacing) ? ~/^(0+\s)+/.replace(s, "") :  ~/^0+/.replace(s, ""));
	}
	
	

}


// -----------------------------------------------------------------
// ----------------------------  BigInt ----------------------------
// -----------------------------------------------------------------

abstract BigInt(SmallIntChunks) {
	
	inline function new(SmallIntChunks:SmallIntChunks) {
		this = SmallIntChunks;
	}
	
	public var length(get, never):Int;
	inline function get_length():Int return this.length;
	var start(get, never):Int;
	inline function get_start():Int return this.start;
	var end(get, never):Int;
	inline function get_end():Int return this.end;
	
	inline function get(i:Int):SmallInt return this.get(i);
	
	@:from static public function fromInt(i:SmallInt):BigInt {
		return new BigInt( SmallIntChunks.CreateFromSmallInt(i) );
	}

	@:from static public function fromString(s:String):BigInt {
		return new BigInt( SmallIntChunks.CreateFromString(s) );
	}

	@:to public function toString():String return this.toString();	
	@:to public function toInt():Int       return this.toSmallInt();
	
	
	@:op(A + B)
	public function add(rhs:BigInt):BigInt {
		
		// TODO: check sign
		
		var result = this.clone();
		for (i in rhs.start...rhs.end) {
			addAtPosition(rhs.get(i), i, result);
		}
		return new BigInt(result);
	}
	
	static inline function addAtPosition(a:SmallInt, position:Int, result:SmallIntChunks):Void {
		for (i in position...result.length) {
			var x:Int = result.get(i);
			x += a;
			if (x & SmallIntChunks.UPPESTBIT == 0) {
				result.set(i, x);
				a = 0;
				break; 
			}
			result.set(i, x & SmallIntChunks.BITMASK);
			a = 1;
		}
		if (a > 0) result.add(a);
	}
	
	
	
}