package;

#if array_chunks
abstract Chunks<T>(Array<T>) from Array<T> {
	public inline function new() {
		this = new Array<T>();
	}

	public inline function set(index:Int, value:T) {
		#if cpp
		cpp.NativeArray.unsafeSet(this, index, value);
		#else
		this[index] = value;
		#end
	}
	
	public inline function get(index:Int):T {
		#if cpp
		return cpp.NativeArray.unsafeGet(this, index);
		#else 
		return this[index];
		#end
	}

	public inline function push(index:Int, value:T) {
		this.push(value);
	}

	public inline function unshift(end:Int, value:T) {
		this.unshift(value);
	}

	public inline function pop(end:Int):T {
		return this.pop();
	}

	public inline function slice(start:Int, end:Int):Chunks<T> {
		return this.slice(start, end);
	}

}

#else

// on most targets this is faster:

import haxe.ds.Vector;

abstract Chunks<T>(Vector<T>) from Vector<T> {
	public inline function new() {
		this = new Vector<T>(8);
	}

	public inline function set(index:Int, value:T) {
		this.set(index, value);
	}
	
	public inline function get(index:Int):T {
		return this.get(index);
	}

	public inline function push(index:Int, value:T) {
		if (index >= this.length) {
			var newVector = new Vector<T>(this.length<<1);
			Vector.blit(this, 0, newVector, 0, this.length);
			this = newVector;
		}
		this.set(index, value);
	}

	public inline function unshift(end:Int, value:T) {
		if (end > this.length) {
			var newVector = new Vector<T>(this.length<<1);
			Vector.blit(this, 0, newVector, 1, end-1);
			this = newVector;
		}
		else {
			// for (i in 0...end) this.set( end-i, this.get(end-i-1) );
			Vector.blit(this, 0, this, 1, end-1);
		}
		this.set(0,value);
	}

	public inline function pop(end:Int):T {
		return this.get(end);
	}

	public inline function slice(start:Int, end:Int):Chunks<T> {
		var newVector = new Vector<T>(end-start);
		Vector.blit(this, start, newVector, 0, end-start);
		return newVector;
	}

}
#end