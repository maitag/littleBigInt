import haxe.Timer;

// calculate Fibonacci number (https://en.wikipedia.org/wiki/Fibonacci_number)

class Fibonacci {
    public static function main() {
		var fiboOld:BigInt = 1;
		var fibo:BigInt = 2;
		var tmp:BigInt;
		
		var time = Timer.stamp();
			
		for (i in 0...10000) {
			tmp = fibo;
			fibo = fibo + fiboOld;
			fiboOld = tmp;
		}
		
		haxe.Log.trace('Fibonacci(10000):\t' + Std.int((Timer.stamp() - time)*1000) + "\tms" , #if (haxe_ver >= "4.0.0") null #else {fileName:"",lineNumber:0,className:"",methodName:"",customParams:[]} #end);
	}
	
}
