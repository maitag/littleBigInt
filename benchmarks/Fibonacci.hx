class Fibonacci {

    public static function main() 
	{		
		var fiboOld:BigInt = 1;
		var fibo:BigInt = 2;
		var tmp:BigInt;
		
		for (i in 0...10000) {
			tmp = fibo;
			fibo = fibo + fiboOld;
			fiboOld = tmp;
		}	
	}
	
}