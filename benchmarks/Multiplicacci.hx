import haxe.Timer;

class Multiplicacci {

    public static function main() 
	{		
		var multiOld:BigInt = 1;
		var multi:BigInt = 2;
		var tmp:BigInt;
		
		var time = Timer.stamp();
			
		for (i in 0...40) {
			tmp = multi;
			multi = multi * multiOld;
			multiOld = tmp;
		}
			
		haxe.Log.trace('Multiplicacci(40):\t' + Std.int((Timer.stamp() - time)*1000) + "\tms" , #if (haxe_ver >= "4.0.0") null #else {fileName:"",lineNumber:0,className:"",methodName:"",customParams:[]} #end);
	}
	
}