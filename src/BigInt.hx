package;

import LittleIntChunks;

/**
 * pure Haxe BigInt implementation
 * 
 * by Sylvio Sell, Rostock 2020
 * 
 */


abstract BigInt(LittleIntChunks) from LittleIntChunks {
	
	inline function new(LittleIntChunks:LittleIntChunks) {
		this = LittleIntChunks;
	}
	
	public var isNegative(get, never):Bool;
	inline function get_isNegative():Bool return this.isNegative;
	
	public var length(get, never):Int;
	inline function get_length():Int return this.length;
	
	public var isZero(get, never):Bool;
	inline function get_isZero():Bool return this.isZero;

	inline function get(i:Int):LittleInt return this.get(i);
	inline function set(i:Int, v:Int) this.set(i,v);
	inline function push(v:LittleInt) this.push(v);
	
	inline function truncateZeroChunks(remove:Bool = false) this.truncateZeroChunks(remove);
	
	inline function negate() this.isNegative = ! this.isNegative;
	//inline function setNegative() this.isNegative = true;
	
	inline function clone():BigInt return new BigInt(this.clone());

	@:from static public function fromInt(i:LittleInt):BigInt {
		return new BigInt( LittleIntChunks.createFromLittleInt(i) );
	}

	@:from static public function fromString(s:String):BigInt {
		return new BigInt( LittleIntChunks.createFromString(s) );
	}

	@:to public function toString():String return this.toString();	
	public function toHexString(spacing:Bool = true):String return this.toHexString(spacing);	
	public function toBinaryString(spacing:Bool = true):String return this.toBinaryString(spacing);	
	
	@:to public function toInt():Int       return this.toLittleInt();
	
	
	// ------- addition -----------
	
	@:op(A + B)
	function add(b:BigInt):BigInt {
		if (isNegative) {
			negate();
			if (b.isNegative) return - _add(this, -b);
			else return _subtract(b, this);
		}
		else {
			if (b.isNegative) return _subtract(this, -b);
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
	
	static inline function addAtPosition(a:BigInt, v:LittleInt, position:Int):Void {
		for (i in position...a.length) {
			var x:Int = a.get(i) + v;
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
	
	// ------- subtraction -----------
	
	@:op(A - B)
	function subtract(b:BigInt):BigInt {
		if (isNegative) {
			negate();
			if (b.isNegative) return _subtract(-b, this);
			else return - _add(this, b);
		}
		else {
			if (b.isNegative) return _add(this, b);
			else return _subtract(this, b);
		}
	}

	static inline function _subtract(a:BigInt, b:BigInt):BigInt {
		var v:BigInt;
		if (a > b) {
			v = __subtract(a.clone(), b);
			v.truncateZeroChunks();
			return v;
		}
		else {
			v = __subtract(b.clone(), a);
			v.truncateZeroChunks();
			if (v.isZero) return v else return -v;
		}
	}

	static inline function __subtract(a:BigInt, b:BigInt):BigInt {
		for (position in 0...b.length) {
			subtractAtPosition(a, b.get(position), position);
		}
		return a;
	}

	static inline function subtractAtPosition(a:BigInt, v:LittleInt, position:Int):Void {		
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
		negate();
		return this;
	}
	
	// ------- comparing -----------

	@:op(A > B)
	function greater(b:BigInt):Bool {
		if (isNegative != b.isNegative) return (isNegative) ? false : true;
		else if (length > b.length) return (isNegative) ? false : true;
		else if (length < b.length) return (isNegative) ? true : false;
		else {
			for (i in 0...length) {
				if (get(length-i-1) > b.get(length-i-1)) return (isNegative) ? false : true;
				else if (get(length-i-1) < b.get(length-i-1)) return (isNegative) ? true : false;
			}
			return false;
		}
	}
	
	@:op(A >= B)
	function greaterOrEqual(b:BigInt):Bool {
		if (isNegative != b.isNegative) return (isNegative) ? false : true;
		else if (length > b.length) return (isNegative) ? false : true;
		else if (length < b.length) return (isNegative) ? true : false;
		else {
			for (i in 0...length) {
				if (get(length-i-1) > b.get(length-i-1)) return (isNegative) ? false : true;
				else if (get(length-i-1) < b.get(length-i-1)) return (isNegative) ? true : false;
			}
			return true;
		}
	}
	
	@:op(A < B)
	function lesser(b:BigInt):Bool {
		if (isNegative != b.isNegative) return (isNegative) ? true : false;
		else if (length < b.length) return (isNegative) ? false : true;
		else if (length > b.length) return (isNegative) ? true : false;
		else {
			for (i in 0...length) {
				if (get(length-i-1) < b.get(length-i-1)) return (isNegative) ? false : true;
				else if (get(length-i-1) > b.get(length-i-1)) return (isNegative) ? true : false;
			}
			return false;
		}
	}
	
	@:op(A <= B)
	function lesserOrEqual(b:BigInt):Bool {
		if (isNegative != b.isNegative) return (isNegative) ? true : false;
		else if (length < b.length) return (isNegative) ? false : true;
		else if (length > b.length) return (isNegative) ? true : false;
		else {
			for (i in 0...length) {
				if (get(length-i-1) < b.get(length-i-1)) return (isNegative) ? false : true;
				else if (get(length-i-1) > b.get(length-i-1)) return (isNegative) ? true : false;
			}
			return true;
		}
	}
	
	@:op(A == B)
	function equal(b:BigInt):Bool {
		if (isNegative != b.isNegative) return false;
		else if (length != b.length) return false;
		else {
			for (i in 0...length) {
				if (get(length-i-1) != b.get(length-i-1)) return false;
			}
			return true;
		}
	}
	
	@:op(A != B)
	function notEqual(b:BigInt):Bool {
		if (isNegative != b.isNegative) return true;
		else if (length != b.length) return true;
		else {
			for (i in 0...length) {
				if (get(length-i-1) != b.get(length-i-1)) return true;
			}
			return false;
		}
	}
	
	
	// ------- multiplication (https://en.wikipedia.org/wiki/Karatsuba_algorithm) -----
	
	@:op(A * B)
	function multicplicate(b:BigInt):BigInt {
		if (this.length == 1 && b.length == 1) {
			var littleIntChunks = new LittleIntChunks();
			littleIntChunks.push(this.get(0) * b.get(0));
			if (isNegative != b.isNegative) littleIntChunks.isNegative = true;
			return littleIntChunks;
		}
		else return _mul(this, b);
	}
	
	static function _mul(a:BigInt, b:BigInt):BigInt {
		
		// TODO
		
		var aHigh:BigInt = a; //.splitHigh(e);
		var aLow:BigInt = a; //.splitLow(e);
		
		var bHigh:BigInt = b; //.splitHigh(e);
		var bLow:BigInt = b; //.splitLow(e);
		
		var p1:BigInt = _mul(aHigh, bHigh);
		var p2:BigInt =  _mul(aLow , bLow);
		var p3:BigInt = _mul(aHigh + aLow, bHigh + bLow );
		// join( p1, p3-(p1+p2), p2 );
		
		if (aHigh == null || bHigh == null)
		{
			//p1 = 0;
			if (aLow == null || bLow == null) {
				//p2 = 0;
				if (aHigh != null && bLow != null)
					p3 = _mul(aHigh, bLow);
				else
					p3 = _mul(aLow, bHigh);
			}
			else {
				//p2 = _mul(aLow, bLow);
				if (aHigh == null && bHigh == null)
					p3 = _mul(aLow, bLow);
				else if (aHigh == null)
					p3 = _mul(aLow, bHigh + bLow );
				else 
					p3 = _mul(aHigh + aLow, bLow  );
			}
			
		}
		else
		{			
			//p1 = _mul(aHigh, bHigh);
			if (aLow == null || bLow == null) {
				//p2 = 0;
				if (aLow == null && bLow == null)
					p3 = _mul(aHigh, bHigh );
				else if (aLow == null)
					p3 = _mul(aHigh, bHigh + bLow );
				else
					p3 = _mul(aHigh + aLow, bHigh  );
			}
			else {
				p1 = _mul(aHigh, bHigh);
				p2 = _mul(aLow, bLow);
				p3 = _mul(aHigh + aLow, bHigh + bLow);
				// ( p1, p3-(p1+p2), p2 );
			}
			
		}
		
		
		
		return 0;
	}

	
	
}
