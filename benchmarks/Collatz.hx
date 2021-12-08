import haxe.Timer;

class Collatz {

    public static function main() 
	{
		var n:BigInt = "0x d4f2 3342 f301 5a44 8334 acb2 3942 43fb 12cc df3a 377e 14aa";
		n = n.pow(3);
		var result:String = "";
		
		var time = Timer.stamp();
		
		while (n > 1) 
		{		
			if (n & 1 == 0) n = n >> 1;
			else n = 3 * n + 1;
			
			result += n;
		}
		time = Std.int((Timer.stamp() - time)*1000);
		
		haxe.Log.trace('Collatz(${result.substr(-3)}):\t${time}\tms' , #if (haxe_ver >= "4.0.0") null #else {fileName:"",lineNumber:0,className:"",methodName:"",customParams:[]} #end);
	}
	
}
