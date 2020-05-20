import haxe.Timer;

class Fibonacci {

    public static function main() 
	{		
		var fiboOld:BigInt = 1;
		var fibo:BigInt = 2;
		var tmp:BigInt;
		
		var time = Timer.stamp();
			
		for (i in 0...10000) {
			tmp = fibo;
			fibo = fibo + fiboOld;
			fiboOld = tmp;
		}
			
		haxe.Log.trace('Fibonacci(10000):\t' + Std.int((Timer.stamp() - time)*1000) + "\tms" , null);
	}
	
}