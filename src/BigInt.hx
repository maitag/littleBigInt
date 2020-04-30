import haxe.ds.IntMap;

typedef SmallInt = Int;
typedef SmallIntArray = Array<SmallInt>; // TODO: can be optimized later for JS here (UInt32Array for example)


class SmallIntChunks {
	
	// save for multiplication is 15 Bit per SmallInt on all platforms
	static public inline var UPPESTBIT:Int = 0x8000;
	static public inline var BITMASK:Int = 0x7FFF;
	//static public inline var UPPEST:Int = 0x80000000;
	//static public inline var MASK:Int = 0x7FFFFFFF;

	var chunks:SmallIntArray;
	var isNegative:Bool = false;
	var start:Int = 0;
	var end:Int = 0;
	public var length(get, never):Int;
	inline function get_length():Int return end-start;
	
	
	public inline function new() {
		chunks = new SmallIntArray();
	}
		
	public inline function clone():SmallIntChunks {
		var smallIntChunks = new SmallIntChunks();
		for (v in this.chunks) smallIntChunks.push(v);
		return smallIntChunks;
	}
	
	public inline function get(i:Int):SmallInt {
		return chunks[i];
	}
	
	public inline function set(i:Int, v:SmallInt) {
		chunks[i] = v;
	}
	
	public inline function push(v:SmallInt) {
		chunks.push(v);
		end++;
	}
	
	public inline function fromSmallInt(i:SmallInt):SmallIntChunks {
		push(i);
		isNegative = (i < 0) ? true : false;
		return this;
	}

	public inline function toSmallInt():SmallInt {
		if (length == 0) return 0;
		else if (length > 1) throw("Error, BigInt is to Big for one Int");
		else return (isNegative) ? -get(0) : get(0);
	}	
	
	
	public inline function fromString(s:String):SmallIntChunks {
		
		//TODO parsing
		
		return this;
	}

	
	public inline function toString():String {
		// traverse
		var s = "";
		
		for (i in start...end) {
			stringAdd(s, get(i));
		}
		
		return s;
	}
	
	static inline function stringAdd(s:String, a:Int):String {
		
		// TODO
		// zifferlaenge von a holen und auf die max-laenge weteitern
		// analog wie bei addAtPosition
		
		return s;
	}
}

abstract BigInt(SmallIntChunks) {
	
	inline function new(SmallIntChunks:SmallIntChunks) {
		this = SmallIntChunks;
	}
	
	public var length(get, never):Int;
	inline function get_length():Int return this.length;
	
	inline function get(i:Int):SmallInt return this.get(i);
	
	@:from static public function fromInt(i:SmallInt):BigInt {
		return new BigInt( new SmallIntChunks().fromSmallInt(i) );
	}

	@:from static public function fromString(s:String):BigInt {
		return new BigInt( new SmallIntChunks().fromString(s) );
	}

	@:to public function toString():String return this.toString();	
	@:to public function toInt():Int       return this.toSmallInt();
	
	
	@:op(A + B)
	public function add(rhs:BigInt):BigInt {
		var result = this.clone();
		for (i in 0...rhs.length) {
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
		if (a > 0) result.push(a);
	}
	
	
	
}