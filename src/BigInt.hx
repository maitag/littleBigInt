typedef SmallInt = Int;
typedef SmallIntArray = Array<SmallInt>; // TODO: can be optimized later for JS here (UInt32Array for example)


class SmallIntChunks {
	
	// save for multiplication is 15 Bit per SmallInt on all platforms
	static public inline var BITSIZE:Int = 7;
	static public inline var UPPESTBIT:Int = 0x80;
	static public inline var BITMASK:Int = 0x7F;
		
/*	static public inline var BITSIZE:Int = 15;
	static public inline var UPPESTBIT:Int = 0x8000;
	static public inline var BITMASK:Int = 0x7FFF;
*/		
	//static public inline var BITSIZE:Int = 31;
	//static public inline var UPPEST:Int = 0x80000000;
	//static public inline var MASK:Int = 0x7FFFFFFF;

	var chunks:SmallIntArray;
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
		chunks = new SmallIntArray();
	}
		
	public inline function clone():SmallIntChunks {
		var smallIntChunks = new SmallIntChunks();
		for (i in 0...length) smallIntChunks.push(get(i));
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
		return chunks[start + i];
	}
	
	public inline function set(i:Int, v:SmallInt) {
		chunks[start + i] = v;
	}
	
	public inline function push(v:SmallInt) {
		chunks.push(v);
		end++;
	}
	
	public inline function pop():SmallInt {
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

	public static inline function createFromSmallInt(i:SmallInt):SmallIntChunks {
		var smallIntChunks = new SmallIntChunks();
		if (i < 0) {
			smallIntChunks.isNegative = true;
			i = -i;
		}
		while (i != 0) {
			smallIntChunks.push(i & BITMASK);
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
	
	public static function createFromString(s:String):SmallIntChunks {
		
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
	
	public inline function fromBinaryString(s:String):SmallIntChunks {
		
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
		
		if (length == 0) {
			return ((spacing) ? [for (i in 0...8) "0"].join("") : "0");
		}
		
		var s = "";
		var chunk:SmallInt;
		var bit:Int;
		var j:Int = 0;
		
		for (i in 0...length) {
			chunk = get(i);
			bit = 1;
			while (bit < UPPESTBIT) {
				s = (((bit & chunk) == 0) ? "0" : "1") + ((j++ % 8 == 0 && spacing) ? " " : "") + s;
				bit = bit << 1;
			}
		}
		
		if (spacing) for (i in 0...(8 - j % 8)) s = "0" + s;
		
		return ((isNegative) ? "-" : "") + ((spacing) ? ~/^(0+\s)+/.replace(s, "") :  ~/^0+/.replace(s, ""));
	}
	
	
	// ---------- Parsing Hexadecimal String -------------------
	
	static var hexaChars = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
	
	public inline function fromHexString(s:String):SmallIntChunks {
		
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
		
		if (length == 0) {
			return ((spacing) ? [for (i in 0...4) "0"].join("") : "0");
		}
		
		var s = "";
		var chunk:SmallInt = 0;
		var restBits:Int = 0;
		var j:Int = 0;
		
		for (i in 0...length) {
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

		if (spacing && j % 4 != 0) for (i in 0...(4 - j % 4)) s = "0" + s;
		
		return ((isNegative) ? "-" : "") + ((spacing) ? ~/^(0+\s)+/.replace(s, "") :  ~/^0+/.replace(s, ""));
	}
	
	

}


// -----------------------------------------------------------------
// ----------------------------  BigInt ----------------------------
// -----------------------------------------------------------------
abstract BigInt(SmallIntChunks) from SmallIntChunks {
	
	inline function new(SmallIntChunks:SmallIntChunks) {
		this = SmallIntChunks;
	}
	
	public var isNegative(get, never):Bool;
	inline function get_isNegative():Bool return this.isNegative;
	
	public var length(get, never):Int;
	inline function get_length():Int return this.length;
	
	public var isZero(get, never):Bool;
	inline function get_isZero():Bool return this.isZero;

	inline function get(i:Int):SmallInt return this.get(i);
	inline function set(i:Int, v:Int) this.set(i,v);
	inline function push(v:SmallInt) this.push(v);
	
	inline function truncateZeroChunks(remove:Bool = false) this.truncateZeroChunks(remove);
	
	inline function negate() this.isNegative = ! this.isNegative;
	//inline function setNegative() this.isNegative = true;
	
	inline function clone():BigInt return new BigInt(this.clone());

	@:from static public function fromInt(i:SmallInt):BigInt {
		return new BigInt( SmallIntChunks.createFromSmallInt(i) );
	}

	@:from static public function fromString(s:String):BigInt {
		return new BigInt( SmallIntChunks.createFromString(s) );
	}

	@:to public function toString():String return this.toString();	
	@:to public function toInt():Int       return this.toSmallInt();
	
	
	// ------- addition -----------
	
	@:op(A + B)
	function add(b:BigInt):BigInt {
		if (isNegative) {
			if (b.isNegative) return - _add(this, b);
			else return _subtract(b, this);
		}
		else {
			if (b.isNegative) return _subtract(this, b);
			else return _add(this, b);
		}
	}
	
	static inline function _add(a:BigInt, b:BigInt):BigInt {
		if (a.length > b.length) return __add(a.clone(), b);
		else return __add(b.clone(), a);
	}
	
	static inline function __add(a:BigInt, b:BigInt):BigInt {
		for (position in 0...b.length) {
			addAtPosition(a, b.get(position), position);
		}
		return a;
	}
	
	static inline function addAtPosition(a:BigInt, v:SmallInt, position:Int):Void {
		for (i in position...a.length) {
			var x:Int = a.get(i) + v;
			if (x & SmallIntChunks.UPPESTBIT == 0) {
				a.set(i, x);
				v = 0;
				break; 
			}
			a.set(i, x & SmallIntChunks.BITMASK);
			v = 1;
		}
		if (v > 0) a.push(v);
	}
	
	// ------- subtraction -----------
	
	@:op(A - B)
	function subtract(b:BigInt):BigInt {
		if (isNegative) {
			if (b.isNegative) return - _subtract(b, this);
			else return - _add(this, b);
		}
		else {
			if (b.isNegative) return _add(this, b);
			else return _subtract(this, b);
		}
	}

	static inline function _subtract(a:BigInt, b:BigInt):BigInt {
		if (a > b) return __subtract(a.clone(), b);
		else {
			var v = __subtract(b.clone(), a); // can contain zero chunks
			v.truncateZeroChunks();
			return -v;
		}
	}

	static inline function __subtract(a:BigInt, b:BigInt):BigInt {
		for (position in 0...b.length) {
			subtractAtPosition(a, b.get(position), position);
		}
		return a;
	}

	static inline function subtractAtPosition(a:BigInt, v:SmallInt, position:Int):Void {		
		for (i in position...a.length) {
			var x:Int = a.get(i);
			if (x >= v) {
				a.set(i, x - v);
				v = 0;
				break; 
			}
			a.set(i, x + SmallIntChunks.UPPESTBIT - v);
			v = 1;
		}
	}
	
	// ------- negation -----------

	@:op(- B)
	inline function negation():BigInt {
		negate();
		return this;
	}
	
	// ------- comparing -----------

	@:op(A > B)
	function greater(b:BigInt):Bool {
		if (length > b.length) return true;
		else if (length < b.length) return false;
		else {
			for (i in 0...length) {
				if (get(length-i-1) > b.get(length-i-1)) return true;
				else if (get(length-i-1) < b.get(length-i-1)) return false;
			}
			return false;
		}
	}
	
	@:op(A >= B)
	function greaterOrEqual(b:BigInt):Bool {
		if (length > b.length) return true;
		else if (length < b.length) return false;
		else {
			for (i in 0...length) {
				if (get(length-i-1) > b.get(length-i-1)) return true;
				else if (get(length-i-1) < b.get(length-i-1)) return false;
			}
			return true;
		}
	}
	
	@:op(A < B)
	function lesser(b:BigInt):Bool {
		if (length < b.length) return true;
		else if (length > b.length) return false;
		else {
			for (i in 0...length) {
				if (get(length-i-1) < b.get(length-i-1)) return true;
				else if (get(length-i-1) > b.get(length-i-1)) return false;
			}
			return false;
		}
	}
	
	@:op(A <= B)
	function lesserOrEqual(b:BigInt):Bool {
		if (length < b.length) return true;
		else if (length > b.length) return false;
		else {
			for (i in 0...length) {
				if (get(length-i-1) < b.get(length-i-1)) return true;
				else if (get(length-i-1) > b.get(length-i-1)) return false;
			}
			return true;
		}
	}
	
	@:op(A == B)
	function equal(b:BigInt):Bool {
		if (length < b.length) return false;
		else if (length > b.length) return false;
		else {
			for (i in 0...length) {
				if (get(length-i-1) != b.get(length-i-1)) return false;
			}
			return true;
		}
	}
	
	
}