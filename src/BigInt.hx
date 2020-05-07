package;

import SmallIntChunks;

/**
 * pure Haxe BigInt implementation
 * 
 * by Sylvio Sell, Rostock 2020
 * 
 */


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