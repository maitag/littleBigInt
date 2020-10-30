import haxe.Timer;

// calculate Pi with https://en.wikipedia.org/wiki/Machin-like_formula
class CalcPi {
    static public function main():Void {
        var digits:Int = 300;
		var time = Timer.stamp();
	    var pi:BigInt = calc(digits);
		haxe.Log.trace('Pi = 3.${pi.toString().substr(1)}\n\t\t\t' + Std.int((Timer.stamp() - time)*1000) + "\tms" , #if (haxe_ver >= "4.0.0") null #else {fileName:"",lineNumber:0,className:"",methodName:"",customParams:[]} #end);
    }

    static public function calc(digits:Int):BigInt {
        digits += 10;
        var calcpi:BigInt = 4 * ( 4 * arctanbyd(5, digits) - arctanbyd(239, digits) );
        calcpi = calcpi / ("10000000000":BigInt);
        return(calcpi);
    }

    static public function arctanbyd(d:Int, digits:Int):BigInt {
        // calculate arctan(1/d) = 1/d - 1/(3*d^3) + 1/(5*d^5) - 1/(7*d^7) + ...
        var arc:BigInt = (10:BigInt).pow(digits) / d;
        var part:BigInt = arc;
        var n:BigInt = 0;
		var dd:Int = -d * d;
        while (part != 0) {
            n++;
			part = part / dd;
            arc = arc + part / (n*2 + 1);
        }
        return(arc);
    }

}
