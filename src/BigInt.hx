package;

import LittleIntChunks;
import haxe.io.Bytes;

/**
 * pure Haxe BigInt implementation
 * 
 * by Sylvio Sell, Rostock 2020
 * 
 */

abstract BigInt(LittleIntChunks) from LittleIntChunks {
	
	inline function new(littleIntChunks:LittleIntChunks) this = littleIntChunks;
	
	inline function get(i:Int):LittleInt return this.get(i);
	inline function set(i:Int, v:LittleInt) this.set(i,v);
	inline function push(v:LittleInt) this.push(v);
	inline function unshift(v:LittleInt) this.unshift(v);

	inline function splitHigh(e:Int):BigInt return this.splitHigh(e);
	inline function splitLow(e:Int):BigInt return this.splitLow(e);

	inline function truncateZeroChunks(remove:Bool) this.truncateZeroChunks(remove);
	
	inline function setNegative():BigInt { this.isNegative = true; return this;}
	inline function setPositive():BigInt { this.isNegative = false; return this;}
	
	inline function copy():BigInt return new BigInt(this.copy());
	inline function negCopy():BigInt return new BigInt(this.negCopy());
	inline function clone():BigInt return new BigInt(this.clone());
	inline function negClone():BigInt return new BigInt(this.negClone());

    /**
        return true if this BigInt is negative signed
    **/
	public var isNegative(get, never):Bool;
	inline function get_isNegative():Bool return this.isNegative;
	
    /**
        return true if this BigInt is positive signed
    **/
	public var isPositive(get, never):Bool;
	inline function get_isPositive():Bool return !this.isNegative;
	
    /**
        return the number of chunks that is needed to store this BigInt
    **/
	public var length(get, never):Int;
	inline function get_length():Int return this.length;
	
    /**
        return true if this BigInt is 0 (same as null)
    **/
	public var isZero(get, never):Bool;
	inline function get_isZero():Bool return (this == null);

    /**
        Creates a new BigInt from an Integer

        @param  i  the Int value to create BigInt from
    **/
	@:from static public function fromInt(i:LittleInt):BigInt {
		return new BigInt(LittleIntChunks.createFromLittleInt(i));
	}
	
    /**
        Converts this BigInt into an Integer. If it's to long for native Integer-length it will throw an error.
    **/
	@:to public function toInt():LittleInt {
		if (this == null) return 0;
		return this.toLittleInt();
	}
	
    /**
        Creates a new BigInt from a String e.g. from a decimal like "1234567890".
		It also accepts a prefix to define numbers to another base e.g.:
		"0b 11001101" for binary, "0o 12345670" for octal or "0x ffaa 1234" for hexadecimal notation.
		For negative valued the "-" sign has to be written first e.g. "-0x FF".

        @param  s  the String that representing the number
    **/
	@:from static public function fromString(s:String):BigInt {
		return LittleIntChunks.createFromBaseString(s);
	}
	
    /**
        Converts this BigInt into a String (decimal notation).
    **/
	@:to public function toString():String {
		if (this == null) return "0";
		return this.toBaseString(10);	
	}	

    /**
        Creates a new BigInt from a String that contains a binary formated number, e.g. "01010111" or "- 1001 1011"

        @param  binaryString  the String that representing the number in binary format
    **/
	static public function fromBinaryString(binaryString:String):BigInt {
		return LittleIntChunks.createFromBaseString(binaryString, 2);
	}
	
    /**
        Creates a new BigInt from a String that contains a hexadecimal formated number, e.g. "FE0504C" or "-ff00 10ab"

        @param  hexString  the String that representing the number in hexadecimal format
    **/
	static public function fromHexString(hexString:String):BigInt {
		return LittleIntChunks.createFromBaseString(hexString, 16);
	}
	
    /**
        Creates a new BigInt from a String that contains a octal formated number, e.g. "070744" or "-77"

        @param  octalString  the String that representing the number in octal format
    **/
	static public function fromOctalString(octalString:String):BigInt {
		return LittleIntChunks.createFromBaseString(octalString, 8);
	}
	
    /**
        Creates a new BigInt from a String of numbers of a specific base

        @param  numberString  the String that representing the number
        @param  base  the base of numberformat, default is 10
    **/
	static public function fromBaseString(numberString:String, base:Int = 10):BigInt {
		return LittleIntChunks.createFromBaseString(numberString, base);
	}
	
	
    /**
        Converts this BigInt into a String (binary notation).
		
        @param  spacing  the amount of summarized digits before the separation by a space-char (default value of 0 disable spacing)
        @param  leadingZeros  fills up the first digits with zeros up to the spacing-amount (default is true)
    **/
	public function toBinaryString(spacing:Int = 0, leadingZeros:Bool = true):String {
		if (this == null) return (leadingZeros && spacing > 0) ? LittleIntChunks.getStringOfZeros(spacing) : "0";
		return this.toBinaryString(spacing, leadingZeros);	
	}	
	
    /**
        Converts this BigInt into a String (octal notation).
		
        @param  spacing  the amount of summarized digits before the separation by a space-char (default value of 0 disable spacing)
        @param  leadingZeros  fills up the first digits with zeros up to the spacing-amount (default is true)
    **/
	public function toOctalString(spacing:Int = 0, leadingZeros:Bool = true):String {
		if (this == null) return (leadingZeros && spacing > 0) ? LittleIntChunks.getStringOfZeros(spacing) : "0";
		return this.toBaseString(8, spacing, leadingZeros);	
	}	
	
    /**
        Converts this BigInt into a String (hexadecimal notation).
		
        @param  spacing  the amount of summarized digits before the separation by a space-char (default value of 0 disable spacing)
        @param  leadingZeros  fills up the first digits with zeros up to the spacing-amount (default is true)
    **/
	public function toHexString(spacing:Int = 0, leadingZeros:Bool = true):String {
		if (this == null) return (leadingZeros && spacing > 0) ? LittleIntChunks.getStringOfZeros(spacing) : "0";
		return this.toHexString(spacing, leadingZeros);	
	}
	
    /**
        Converts this BigInt into a String to a defined base.
		
        @param  spacing  the amount of summarized digits before the separation by a space-char (default value of 0 disable spacing)
        @param  leadingZeros  fills up the first digits with zeros up to the spacing-amount (default is true)
    **/
	public function toBaseString(base:Int = 10, spacing:Int = 0, leadingZeros:Bool = false):String {
		if (this == null) return (leadingZeros && spacing > 0) ? LittleIntChunks.getStringOfZeros(spacing) : "0";
		return this.toBaseString(base, spacing, leadingZeros);	
	}
	
	
    /**
        Creates a new BigInt from Bytes.

        @param  bytes  the Bytes that was stored by ".toBytes()"
    **/
	static public function fromBytes(bytes:Bytes):BigInt {
		return LittleIntChunks.fromBytes(bytes);
	}

    /**
        pack this BigInt into Bytes for efficiently storage.
    **/
	public function toBytes():Bytes {
		if (this == null) {
			var b = Bytes.alloc(1);
			b.set(0, 0);
			return b;
		}
		return this.toBytes();	
	}
	
	
	// --------------------------------------------------------------------
	// -------------------- abs -------------------------------------------
	// --------------------------------------------------------------------	
	
    /**
        returns a new BigInt of the absolute amount
    **/
	public function abs():BigInt {
		if (this == null) return null;
		if (isNegative) return negCopy();
		return copy();
	}
	

	// --------------------------------------------------------------------
	// -------------------- addition --------------------------------------
	// --------------------------------------------------------------------	
	
	@:op(A + B) function opAdd(b:BigInt):BigInt return _add(this, b);
	
/*	@:op(A += B) 
	public inline function add(b:BigInt):BigInt {
		// TODO without copying
		return this;
	}
*/	
	static inline function _add(a:BigInt, b:BigInt):BigInt {
		if (a == null) return (b == null) ? null : b.copy();
		if (b == null) return a.copy();
		if (a.isNegative) {
			if (b.isNegative) return __add(a, b).setNegative(); // -3 + -2
			return __subtract(b, a.negClone()); // -3 + 2
		}
		if (b.isNegative) return __subtract(a, b.negClone()); // 3 + -2
		return __add(a, b); // 3 + 2
	}
	
	static inline function __add(a:BigInt, b:BigInt):BigInt {
		if (a.length > b.length) return addLong(a.copy(), b);
		return addLong(b.copy(), a);
	}
	
	static inline function addLong(a:BigInt, b:BigInt):BigInt {
		for (position in 0...b.length) {
			addLittle(a, b.get(position), position);
		}
		return a;
	}
	
	static inline function addLittle(a:BigInt, v:LittleInt, position:Int):Void {
		var x:Int;
		for (i in position...a.length) {
			x = a.get(i) + v;
			if (x & LittleIntChunks.UPPESTBIT == 0) {
				a.set(i, x);
				v = 0;
				break; 
			}
			a.set(i, x & LittleIntChunks.BITMASK);
			v = 1;
		}
		if (v > 0) a.push(v);
	}
	
	// --------------------------------------------------------------------
	// -------------------- subtraction -----------------------------------
	// --------------------------------------------------------------------	
	
	@:op(A - B) function opSubtract(b:BigInt):BigInt return _subtract(this, b);

/*	@:op(A -= B) public inline function subtract(b:BigInt):BigInt {
		// TODO  without copying
		return this;
	}
*/	
	static inline function _subtract(a:BigInt, b:BigInt):BigInt {
		if (a == null) return (b == null) ? null : b.negCopy();
		if (b == null) return a.copy();
		if (a.isNegative) {
			if (b.isNegative) return __subtract(b.negClone(), a.negClone());// -3 - -2
			return __add(a, b).setNegative(); // -3 - 2
		}
		if (b.isNegative) return __add(a, b.negClone()); // 3 - -2
		return __subtract(a, b);  // 3 - 2
	}

	static inline function __subtract(a:BigInt, b:BigInt):BigInt {
		var v:BigInt;
		if (a > b) {
			v = subtractLong(a.copy(), b);
			v.truncateZeroChunks(false);
			return v;
		}
		
		v = subtractLong(b.copy(), a);
		v.truncateZeroChunks(false);
		return (v.length == 0) ? null : v.setNegative();		
	}

	static inline function subtractLong(a:BigInt, b:BigInt):BigInt {
		for (position in 0...b.length) {
			subtractLittle(a, b.get(position), position);
		}
		return a;
	}

	static inline function subtractLittle(a:BigInt, v:LittleInt, position:Int):Void {		
		for (i in position...a.length) {
			var x:Int = a.get(i);
			if (x >= v) {
				a.set(i, x - v);
				v = 0;
				break; 
			}
			a.set(i, x + LittleIntChunks.UPPESTBIT - v);
			v = 1;
		}
	}
	
	// ------- negation -----------

	@:op(- B)
	inline function negation():BigInt {
		if (this == null) return null;
		return this.negCopy();
	}
	
	
	// --------------------------------------------------------------------
	// -------------------- multiplication --------------------------------
	// --------------------------------------------------------------------	
	// (katatsuba: https://en.wikipedia.org/wiki/Karatsuba_algorithm) -----
	
	@:op(A * B)
	function opMulticplicate(b:BigInt):BigInt {
		if (this == null || b == null) return null;
		if (isNegative != b.isNegative) return mul(this, b).setNegative();
		return mul(this, b);
	}
	
	static inline function mulLittle(a:BigInt, v:LittleInt):BigInt {		
		if (v == 1) return a.copy();
		if (v < 0) v = -v;
		var x:Int = 0;
		var b = new BigInt(new LittleIntChunks());
		for (i in 0...a.length) {
			x = a.get(i) * v + x;
			b.push(x & LittleIntChunks.BITMASK);
			x = x >>> LittleIntChunks.BITSIZE;
		}
		if (x > 0) b.push(x);
		return(b);
	}
	
	static function mul(a:BigInt, b:BigInt):BigInt {		
		if (a == null || b == null) return null;
		if (a.length == 1) {
			if (b.length == 1) return fromInt(a.get(0) * b.get(0));
			return mulLittle(b, a.get(0));
		}
		if (b.length == 1) return mulLittle(a, b.get(0));
		
		var e = IntUtil.nextPowerOfTwo((a.length > b.length) ? a.length : b.length) >>> 1;
		
		var aHigh:BigInt = a.splitHigh(e);
		var aLow:BigInt = a.splitLow(e);
		var bHigh:BigInt = b.splitHigh(e);
		var bLow:BigInt = b.splitLow(e);
		
		var p1:BigInt = mul(aHigh, bHigh); 
		var p2:BigInt = mul(aLow , bLow);  
		
		return join(e, p1, mul(aHigh + aLow, bHigh + bLow) - (p1 + p2), p2 );
	}
	
	static inline function join(e:Int, a:BigInt, b:BigInt, c:BigInt):BigInt {		
		var littleIntChunks = new LittleIntChunks();
		
		if (c == null) for (i in 0...e) littleIntChunks.push(0);
		else
		{	for (i in 0...e) {
				if (i < c.length) littleIntChunks.push(c.get(i));
				else {
					if (b == null && a == null) break;
					littleIntChunks.push(0);
				}
			}
			if (c.length > e) b = b + c.splitHigh(e);
		}
		
		if (b == null) {
			if (a != null) for (i in 0...e) littleIntChunks.push(0);
		}
		else
		{	for (i in 0...e) {
				if (i < b.length) littleIntChunks.push(b.get(i));
				else {
					if (a == null) break;
					littleIntChunks.push(0);
				}
			}
			if (b.length > e) a = a + b.splitHigh(e);
		}
		
		if (a != null) for (i in 0...a.length) littleIntChunks.push(a.get(i));

		return littleIntChunks;
	}
	
	
	// --------------------------------------------------------------------
	// ---------------- division and modulo -------------------------------
	// --------------------------------------------------------------------	
	
	@:op(A / B)
	function opDivMod(b:BigInt):BigInt {
		return divMod(this, b).quotient;
	}
	
	@:op(A % B)
	function opModulo(b:BigInt):BigInt {
		return divMod(this, b).remainder;
	}
	
	// ------- division with remainder -----

	static inline public function divMod(a:BigInt, b:BigInt):{quotient:BigInt, remainder:BigInt} {			
		if (b == null) throw ("Error '/', divisor can't be 0");
		if (a == null) return { quotient:null, remainder:null }; // handle null
		if (b == 1) return { quotient:a.copy(), remainder:null }; // handle dividing by 1
		if (a == b) return { quotient:1, remainder:null }; // handle equal
		
		// handle in depend of signs
		var ret:{quotient:BigInt, remainder:BigInt};
		if (a.isNegative) {
			if (b.isNegative) {
				ret = _divMod(a.negClone(), b.negClone());
				if (ret.remainder != null) ret.remainder.setNegative();
			}
			else {
				ret = _divMod(a.negClone(), b);
				if (ret.quotient != null) ret.quotient.setNegative();
				if (ret.remainder != null) ret.remainder.setNegative();
			}
		}
		else {
			if (b.isNegative) {
				ret = _divMod(a, b.negClone());
				if (ret.quotient != null) ret.quotient.setNegative();
			}
			else ret = _divMod(a, b);
		}		
		return ret;
	}
	
	static inline function _divMod(a:BigInt, b:BigInt):{quotient:BigInt, remainder:BigInt} {		
		if (b.length <= 2) {
			if (a.length <= 2) return {
				quotient: fromInt( Std.int(a.toInt() / b.toInt() )), // TODO: optimized toInt() without bitsize-check!
				remainder:fromInt( Std.int(a.toInt() % b.toInt() ))  // TODO: optimized toInt() without bitsize-check!
			}
			if (b.length == 1) {
				if (b.get(0) == 1) return { quotient:a, remainder:null };
				return divModLittle(a, b.toInt()); // TODO: optimized toInt() without bitsize-check!
			}
			return divModLong(a, b);
		}
		return divModLong(a, b);
	}
	
	static inline function divModLittle(a:BigInt, v:LittleInt):{quotient:BigInt, remainder:BigInt} {		
		var i = a.length - 1;
		var x:LittleInt = (a.get(i) << LittleIntChunks.BITSIZE) | a.get(--i);
		var q:BigInt = Std.int( x / v );
		var r:LittleInt = Std.int( x % v );
		var c:Int;
		
		do {
			x = (r << LittleIntChunks.BITSIZE) | a.get(--i);			
			c = Std.int( x / v ); // <- can be 2 chunks
			if (c >= LittleIntChunks.UPPESTBIT) {
				q.unshift(c >>> LittleIntChunks.BITSIZE);
				q.unshift(c & LittleIntChunks.BITMASK);
			}
			else q.unshift(c);			
			r = Std.int( x % v );
		} while (i > 0);
		
		return { quotient:q, remainder:r };
	}
	
	
	// optimized to faster fetch only quotient and do without sign-check
	static inline function divFast(a:BigInt, v:LittleInt):BigInt {		
		if (a == null) return null; // handle null
		if (a == v) return 1; // handle equal
		if (v == 1) return a.copy(); // handle dividing by 1
		if (a.length <= 2) return Std.int(a.toInt() / v ); // TODO: optimized toInt() without bitsize-check!
		return divModLittle(a, v).quotient;
	}
	
	static function divModLong(a:BigInt, b:BigInt):{quotient:BigInt, remainder:BigInt} {		
		var e = b.length - 1;
		var r:BigInt;
		var x:LittleInt = b.get(e);
		var q:BigInt = divFast(a.splitHigh(e) , x);
		
		do {
			r = a - (q * b);
			if (r != null) {
				q.shiftOneBitLeft();
				q = q - divFast(r.splitHigh(e), x);
				q.shiftOneBitRight();
				r.setPositive();
			}			
		} while (r >= b);
		
		if (r != null) {
			r = a - (q * b );
			if (r.isNegative) {
				subtractLittle(q, 1, 0); //q = q - 1;
				r = r + b;
			}
		}
		return { quotient:q, remainder:r };
	}
	
	// --------------------------------------------------------------------
	// ---------------------- pow and powMod ------------------------------
	// --------------------------------------------------------------------
	public function pow(exponent:BigInt):BigInt {
		if (exponent < 0) throw ("Error 'powMod', exponent can't be negative");
		if (exponent == null) return 1;
		if (this == null) return null;
		
		if (length == 1 && get(0) == 1) return 1;
		if (exponent.length == 1 && exponent.get(0) == 1) return this.copy();
		
		var bit:Int;
		var e:Int;
		var maxBits:Int;

		var result:BigInt = 1;
		var base:BigInt = this; // need .copy() here?
		
		for (i in 0...exponent.length) {
			e = exponent.get(i);
			bit = 1;
			if (i == exponent.length - 1) maxBits = 1 << IntUtil.bitsize(e);
			else maxBits = LittleIntChunks.UPPESTBIT;
			while (bit < maxBits) {
				if (bit & e != 0) result = result * base;
				base = base * base;
				bit = bit << 1;
			}
		}
		return result;
	}
	
	public function powMod(exponent:BigInt, modulus:BigInt):BigInt {
		if (exponent < 0) throw ("Error 'powMod', exponent can't be negative");
		if (modulus == null) throw ("Error 'powMod', modulus can't be 0");
		if (modulus == 1) return null;
		
		if (exponent == null) return 1;
		if (this == null) return null;
		
		if (length == 1 && get(0) == 1) return 1;
		if (exponent.length == 1 && exponent.get(0) == 1) return divMod(this, modulus).remainder;
		
		var bit:Int;
		var e:Int;
		var maxBits:Int;

		var result:BigInt = 1;
		var base:BigInt = divMod(this, modulus).remainder;
		
		for (i in 0...exponent.length) {
			e = exponent.get(i);
			bit = 1;
			if (i == exponent.length - 1) maxBits = 1 << IntUtil.bitsize(e);
			else maxBits = LittleIntChunks.UPPESTBIT;
			while (bit < maxBits) {
				if (bit & e != 0) result = divMod(result * base, modulus).remainder;
				base = divMod(base * base, modulus).remainder;
				bit = bit << 1;
			}
		}
		return result;
	}
	
	// --------------------------------------------------------------------
	// -------------------- binary operations -----------------------------
	// --------------------------------------------------------------------
	
	public function shiftOneBitRight() {
		if (this != null) {
			var i:Int = length - 1;
			var v = get(i);
			var restBit:Bool = ((v & 1) > 0);
			v = v >>> 1;
			if (v != 0) set(i, v) else this.pop();
			while (i-- > 0) {
				v = get(i);
				if (restBit) v |= LittleIntChunks.UPPESTBIT;
				restBit = ((v & 1) > 0);
				set(i, v >>> 1);
			}
		}
	}
	
	public function shiftOneBitLeft() {
		if (this != null) {
			var v:LittleInt = 0;
			for (i in 0...length) {
				v = (get(i) << 1) | ((v & LittleIntChunks.UPPESTBIT > 0) ? 1 : 0) ;
				set(i, v & LittleIntChunks.BITMASK);
			}
			if (v & LittleIntChunks.UPPESTBIT > 0) push(1);
		}
	}
	
	@:op(A >>> B)
	function opShiftRightUnsigned(b:Int):BigInt {
		return opShiftRight(b);
	}
	
	@:op(A >> B)
	function opShiftRight(b:Int):BigInt {
		if (this == null) return null;
		if (b == 0) return this.copy();
		if (b < 0) return opShiftLeft(-b);

		var result:BigInt = new BigInt(new LittleIntChunks());
		var l:Int = Std.int(b / LittleIntChunks.BITSIZE);
		var r:Int = b - l * LittleIntChunks.BITSIZE;
		
		if (r == 0)
			for (i in l...length) result.push(get(i));
		else {
			var v:Int;
			var restBits:Int = 0;
			var i = length;
			while (i-- > l) {
				v = get(i);
				if (result.length > 0 || ((v >>> r) | restBits) > 0)
					result.unshift((v >>> r) | restBits);
				restBits = (v << (LittleIntChunks.BITSIZE - r)) & LittleIntChunks.BITMASK;
			}
		}
		
		if (result.length == 0) return null;		
		if (isNegative) result.setNegative();
		return result;
	}
	
	@:op(A << B)
	inline function opShiftLeft(b:Int):BigInt {
		if (this == null) return null;
		if (b == 0) return this.copy();
		if (b < 0) return opShiftRight(-b);
		
		var result:BigInt = new BigInt(new LittleIntChunks());
		var l:Int = Std.int(b / LittleIntChunks.BITSIZE);
		var r:Int = b - l * LittleIntChunks.BITSIZE;
		for (i in 0...l) result.push(0);
		if (r == 0)
			for (i in 0...length) result.push(get(i));
		else {
			var v:Int;
			var restBits:Int = 0;
			for (i in 0...length) {
				v = get(i);
				result.push( ((v << r) & LittleIntChunks.BITMASK) | restBits);
				restBits = v >>> (LittleIntChunks.BITSIZE - r);
			}
			if (restBits > 0) result.push(restBits);
		}
		if (isNegative) result.setNegative();
		return result;
	}
	
	@:op(A & B)
	function opAND(b:BigInt):BigInt {
		if (this == null || b == null) return null;

		var result:BigInt = null;
		var r:LittleInt;
		var i = (length < b.length) ? length : b.length;
		while (i-- > 0) {
			r = this.get(i) & b.get(i);
			if (result != null)
				result.unshift(r);
			else if (r != 0) {
				result = new BigInt(new LittleIntChunks());
				result.unshift(r);
			} 
		}
		if (this.isNegative && b.isNegative) result.setNegative();
		return result;
	}
	
	@:op(A | B)
	function opOR(b:BigInt):BigInt {
		if (this == null || b == null) return null;
		
		var result:BigInt = new BigInt(new LittleIntChunks());
		var l = (length < b.length) ? length : b.length;
		for (i in 0...l) {
			result.push(this.get(i) | b.get(i));
		}
		if (length < b.length)
			for (i in l...b.length) result.push(b.get(i));
		else if (length > b.length)
			for (i in l...length) result.push(this.get(i));
		
		if (this.isNegative || b.isNegative) result.setNegative();
		return result;
	}
	
	@:op(A ^ B)
	function opXOR(b:BigInt):BigInt {
		if (this == null || b == null) return null;
		
		var result:BigInt = new BigInt(new LittleIntChunks());
		var l = (length < b.length) ? length : b.length;
		for (i in 0...l) {
			result.push(this.get(i) ^ b.get(i));
		}
		if (length < b.length)
			for (i in l...b.length) result.push(b.get(i));
		else if (length > b.length)
			for (i in l...length) result.push(this.get(i));
		
		if (this.isNegative != b.isNegative) result.setNegative();
		return result;
	}
	
	// --------------------------------------------------------------------
	// -------------------- comparing -------------------------------------
	// --------------------------------------------------------------------

	@:op(A > B)
	function greater(b:BigInt):Bool {
		if (this == null) {
			if (b == null) return false;
			return (b.isNegative) ? true : false;
		}
		if (b == null) return (isNegative) ? false : true;
		if (isNegative != b.isNegative) return (isNegative) ? false : true;
		if (length > b.length) return (isNegative) ? false : true;
		if (length < b.length) return (isNegative) ? true : false;

		var i = length;
		while (i-- > 0) {
			if (get(i) > b.get(i)) return (isNegative) ? false : true;
			if (get(i) < b.get(i)) return (isNegative) ? true : false;
		}
		return false;
	}
	
	@:op(A >= B)
	function greaterOrEqual(b:BigInt):Bool {
		if (this == null) {
			if (b == null) return true;
			return (b.isNegative) ? true : false;
		}
		if (b == null) return (isNegative) ? false : true;
		if (isNegative != b.isNegative) return (isNegative) ? false : true;
		if (length > b.length) return (isNegative) ? false : true;
		if (length < b.length) return (isNegative) ? true : false;

		var i = length;
		while (i-- > 0) {
			if (get(i) > b.get(i)) return (isNegative) ? false : true;
			if (get(i) < b.get(i)) return (isNegative) ? true : false;
		}
		return true;		
	}
	
	@:op(A < B)
	function lesser(b:BigInt):Bool {
		if (this == null) {
			if (b == null) return false;
			return (b.isNegative) ? false : true;
		}
		if (b == null) return (isNegative) ? true : false;
		if (isNegative != b.isNegative) return (isNegative) ? true : false;
		if (length < b.length) return (isNegative) ? false : true;
		if (length > b.length) return (isNegative) ? true : false;

		var i = length;
		while (i-- > 0) {
			if (get(i) < b.get(i)) return (isNegative) ? false : true;
			if (get(i) > b.get(i)) return (isNegative) ? true : false;
		}
		return false;
	}
	
	@:op(A <= B)
	function lesserOrEqual(b:BigInt):Bool {
		if (this == null) {
			if (b == null) return true;
			return (b.isNegative) ? false : true;
		}
		if (b == null) return (isNegative) ? true : false;
		if (isNegative != b.isNegative) return (isNegative) ? true : false;
		if (length < b.length) return (isNegative) ? false : true;
		if (length > b.length) return (isNegative) ? true : false;

		var i = length;
		while (i-- > 0) {
			if (get(i) < b.get(i)) return (isNegative) ? false : true;
			if (get(i) > b.get(i)) return (isNegative) ? true : false;
		}
		return true;
	}
	
	@:op(A == B)
	function equal(b:BigInt):Bool {
		if (this == null) return (b == null) ? true : false;
		if (b == null) return false;
		if (isNegative != b.isNegative) return false;
		if (length != b.length) return false;
		
		var i = length;
		while (i-- > 0) {
			if (get(i) != b.get(i)) return false;
		}
		return true;
	}
	
	@:op(A != B)
	function notEqual(b:BigInt):Bool {
		if (this == null) return (b == null) ? false : true;
		if (b == null) return true;
		if (isNegative != b.isNegative) return true;
		if (length != b.length) return true;
		
		var i = length;
		while (i-- > 0) {
			if (get(i) != b.get(i)) return true;
		}
		return false;
	}
	
	
}
