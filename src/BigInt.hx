import haxe.ds.IntMap;

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
		for (v in this.chunks) smallIntChunks.add(v); // TODO: only start to end
		return smallIntChunks;
	}
	
	// TODO
/*	public inline function split(size:Int):SmallIntChunks {
		// TODO
		return smallIntChunks;
	}
*/	
/*	public inline function join3(a:SmallIntChunks, b:SmallIntChunks, c:SmallIntChunks):SmallIntChunks {
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
	
	public static inline function CreateFromSmallInt(i:SmallInt):SmallIntChunks {
		var smallIntChunks = new SmallIntChunks();
		smallIntChunks.add(i);
		smallIntChunks.isNegative = (i < 0) ? true : false;
		return smallIntChunks;
	}

	public inline function toSmallInt():SmallInt {
		if (length == 0) return 0;
		else if (length > 1) throw("Error, BigInt is to Big for one Int");
		else return (isNegative) ? -get(0) : get(0);
	}	
	
	
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
	
	
	inline function fromHexString(s:String):SmallIntChunks {
		
		var i = s.length;
		var bit:Int = 1;
		var chunk:Int = 0;
		
		while (i > 0) {
			switch (s.charAt(--i)) {
				case "0":
				case "1": chunk += 1  * bit;  // TODO: refactor later
				case "2": chunk += 2  * bit;
				case "3": chunk += 3  * bit;
				case "4": chunk += 4  * bit;
				case "5": chunk += 5  * bit;
				case "6": chunk += 6  * bit;
				case "7": chunk += 7  * bit;
				case "8": chunk += 8  * bit;
				case "9": chunk += 9  * bit;
				case "a": chunk += 10 * bit;
				case "b": chunk += 11 * bit;
				case "c": chunk += 12 * bit;
				case "d": chunk += 13 * bit;
				case "e": chunk += 14 * bit;
				case "f": chunk += 15 * bit;
				default: throw('Error, hexadecimal string can only contain "0123456789abcdef"');
			}
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
	
	
	static var regexSpaces = ~/\s+/g;
	static var regexBinary = ~/^0b0*/;
	//static var regexOctal = ~/^0o0*/;
	static var regexHex = ~/^0x0*/;
	static var regexSign = ~/^-?/;
	public static function CreateFromString(s:String):SmallIntChunks {
		
		var smallIntChunks = new SmallIntChunks();
		
		// make lowercase and parse out all spaces
		s = regexSpaces.replace(s.toLowerCase(), "");
		
		// check sign
		s = regexSign.replace(s, ""); //trace(regexSign.matched(0));
		smallIntChunks.isNegative = (regexSign.matched(0) == "-") ? true : false;
		
		if (regexBinary.match(s)) return smallIntChunks.fromBinaryString(regexBinary.replace(s, ""));
		else if (regexHex.match(s)) return smallIntChunks.fromHexString(regexHex.replace(s, ""));
		//else if (regexOctal.match(s)) return smallIntChunks.fromOctString(regexOctal.replace(s, ""));
		//else return smallIntChunks.fromTenBaseString(s);
		else throw ("Only supported Binary and Hex stringinput yet");
		
		//TODO parsing any base
		
	}

	
	public inline function toBinaryString(spacing:Bool = true):String {
		// traverse
		var s = "";
		var chunk:SmallInt;
		var bit:Int;
		var j:Int = 0;
		for (i in start...end) { // TODO: iterator !
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
	
	
	public inline function toString():String {
		
		// only binary yet
		return toBinaryString();

		
		// traverse
		//var s = "";
		
		//for (i in start...end) {
		//	stringAdd(s, get(i));
		//}
		
		//return s;
	}
/*	static inline function stringAdd(s:String, a:Int):String {
		
		// TODO
		// zifferlaenge von a holen und auf die max-laenge weteitern
		// analog wie bei addAtPosition
		
		return s;
	}
*/	
}

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
		for (i in rhs.start...rhs.end) {  // TODO: iterator !
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