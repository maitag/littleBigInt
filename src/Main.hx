package;
import haxe.Timer;
import haxe.io.Bytes;

/**
 * by Sylvio Sell, Rostock 2020
 * 
 */
@:access(BigInt)
class Main {

    public static function main() {

		var a:BigInt = "0x10000000FFFF";
		var b:BigInt = "0x100000000000";
		var x:BigInt = "0xFFFF";
		var c = a - b - x;
		trace(c);
		c.truncateZeroChunks(true);
		trace(c);

		/*
		var a:BigInt = "84208796048855839819007233267578572713237678851941598859969313";
		trace(a);
		var b:BigInt = '-1';trace("-----------------------",b.length);
		var c:BigInt = a/b;
		trace( a,b,  c );
		*/

		

/*		var a:BigInt = '1761804960632708497166197429';
		var b:BigInt = '170141183460469231731687303715884105709';

		var c:BigInt = a*b;
		trace(c);
		if (c != ("299755581028574428885627854637518938878751711898852594203800022161":BigInt)) trace("WRONG");
*/
/*	
	// issue 1
		//var a = BigInt.fromHexString('2D5D4921855F54C2323C4D040454522543B23EF8B58223A11E959D5');
		// var b = BigInt.fromHexString('7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFED');
		var a = BigInt.fromHexString('D5D4921855F54CC4D0EC0E0CBEF8B582A11E959D54243145088DEF36C75886EEBAE84160B64E011F6B9AD301F1D3466E247FC2ACF7B5DF1798D72918C459CF0');
		var b = BigInt.fromHexString('7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED');
		trace("a",a);
		trace("b",b);
		//var a:BigInt = "100 000 000 000 000 000 000 000 000 000 000 000 000";
		//var b:BigInt = "300 000 000 123";
		var c = a % b;
		trace(c);
	
*/

		
/*		trace(((
			("0b 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111100 11100101 11001110 10111001 11010111" : BigInt) &
			("0b 00101000" : BigInt)
		) == null));
		
		trace((
			("0b 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111100 11100101 11001110 10111001 11010111" : BigInt) &
			("0b 00101000" : BigInt)
		).chunksLength);
		
		trace(((
			("0b 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111100 11100101 11001110 10111001 11010111" : BigInt) ^
			("0b 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111100 11100101 11001110 10111001 11010111" : BigInt)
		) == null));// toBinaryString(8));
*/		
/*
		trace((
			("0b 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111100 11100101 11001110 10111001 11010111" : BigInt) ^
			("0b 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111100 11100101 11001110 10111001 11010111" : BigInt)
		).chunksLength);// toBinaryString(8));
		
		trace((
			("0b 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111100 11100101 11001110 10111001 11010110" : BigInt) ^
			("0b 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111111 11111100 11100101 11001110 10111001 11010111" : BigInt)
		).chunksLength);// toBinaryString(8));
*/	
		
		
/*		var gethx = function(s:String):String 
		{
			var key = "nex;a^*lhAiZu?oFc~OmCTBt)zPqGSrIYD!WHpLb_VMvUw.QRg(jEXKsJyd:kfN";
			var n = BigInt.fromBaseString(s, key);
			
			var result = "";
			
			while (n > 1) 
			{		
				if (n & 1 == 0) n = n >> 1;
				else n = 3 * n + 1;
				//trace(n.toBaseString(key));
				result += n.toBaseString(key);
			}
			
			return result.substr(-4);
		}
		
		//trace( gethx("writtn into...") );
		//trace( gethx("faforite language ;") );
		trace( gethx("np") );
*/				
		
/*		trace( ("92880732102545363":BigInt).toHexString() );
		trace( ("0x149FA88A3734FD3":BigInt).toBaseString("aeFox_hvr(^)") );

		return;
		
		var n:BigInt = 0;
		trace(n++);
		trace(n);
		
		var n:BigInt = -1;
		trace(n++);
		trace(n);
*/		
		
/*		//var n:BigInt = (10:BigInt).pow(299) / (10:BigInt).pow(10);
		var r:BigInt = "10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000195193276309135075023284912102116616768613765187463511927839869094134045055764247";
		
		var a:BigInt = (10:BigInt).pow(299);
		var b:BigInt = (10:BigInt).pow(10);
		
		trace((r*b));
		trace(a/b);
*/		
		
// -----------------------------------------------
// ----------------- SYNOPSIS --------------------
// -----------------------------------------------
/*
// ------------- Creating BigInts ----------------
// from Integers
var a:BigInt = 5;
var b = BigInt.fromInt(5);


// from Strings
var a:BigInt = "127"; // default is in decimal notation
var b = BigInt.fromString("127");

// or use a prefix to define the number format
var a:BigInt = "0x ffff 0000";   // hexadecimal
var b:BigInt = "0o 01234567 10"; // octal
var c:BigInt = "0b 00111010";    // binary  

// helpers to create from different formats
BigInt.fromHexString("aaFF 01e3");
BigInt.fromOctalString("7724 1160");
BigInt.fromBinaryString("0010 1101");
BigInt.fromBaseString("2010221101102", 3); // to default digits and numberbase of 3

// use a custom string of digit chars for number representation (also need for a base > 16)
BigInt.fromBaseString("hello", 5, "0helo1234567"); // using the first 5 digits of digitChars
BigInt.fromBaseString("haxe", "abcdefgh123xyz"); // base is set to length of digitChars


// you can also define values on demand inside brackets like:
var x = (2147483647:BigInt) * ("1 000 000 000   000 000 000":BigInt);
trace(x); // 2147483647000000000000000000


// from Bytes
var bytes = Bytes.ofString("A");
var a = BigInt.fromBytes(bytes);
trace(a); // 65


// ------------- Signing and the zero value -------------
// signs has to be placed at first of notation
var a:BigInt = "-0xFF";

// the 'null' value is equivalent to 0
var zero:BigInt = 0;
trace( zero );         // null
trace( zero.toInt() ); // 0



// ------------- Different output formats ---------------
var a = BigInt.fromBaseString("01234", 5);

// convert into native integer
trace(  a.toInt()  ); // -> 194  (throws out an error if 'a' not fit into)


// convert into String for different number bases
trace( a.toString() );           // decimal:    "194"
trace( a.toBinaryString() );    // binary: "11000010"
trace( a.toOctalString() );    // octal:        "302"
trace( a.toHexString() );     // hexadecimal:    "C2"
trace( a.toHexString(false));// hexa-lowercase:  "c2"
trace( a.toBaseString(7) ); // base 7:          "365"

// create spacings
trace( a.toBinaryString(4) );        //   "1100 0010"
trace( a.toBinaryString(3) );        // "011 000 010"
trace( a.toBinaryString(3, false) ); //  "11 000 010" (no leading zeros!)

// use a custom digit string for number-representation
trace( (969:BigInt).toBaseString(5, "0helo1234567") ); // "hello"
trace( (19366:BigInt).toBaseString("abcdefgh123xyz") ); // "haxe"


// store into Bytes
var bytes:Bytes = a.toBytes();
trace(bytes.length); // 1



// ------------- Arithmetic operations -------------
var a:BigInt = 3;
var b:BigInt = 7;

// addition and subtraction
trace(a + b); // 10

// increment and decrement
trace(++a); // 4
trace(a++); // 4
trace( a ); // 5

// negation
trace( -a ); // -5

// multiplication
trace( a * b ); // 35

// division with remainder
a = 64;
b = 30;
var result = BigInt.divMod(a, b);
trace( result.quotient, result.remainder ); // 2, 4

// integer division
trace( a / b); // 3 (same as result.quotient)

// modulo
trace( a % b); // 4 (same as result.remainder)

// power
trace( a.pow(b) ); // 1532495540865888858358347027150309183618739122183602176

// power modulo
trace( a.powMod(b, 10000) ); // 2176

// absolute value
a = -5;
b = 3;
trace( a.abs() ); // 5
trace( b.abs() ); // 3



// ------------- Comparing -------------

//  (>, <, >=, <=, ==, !=)



// ------------- Bitwise Operations -------------
var a:BigInt = "0b 01010111";
var b:BigInt = "0b 11001100";

// bitwise AND
trace( (a & b).toBinaryString(8) ); // 01000100

// bitwise OR
trace( (a | b).toBinaryString(8) ); // 11011111

// bitwise XOR
trace( (a ^ b).toBinaryString(8) ); // 10011011

//complement (NOT)
trace( (~a).toBinaryString(8) );    //-01011000

// bitshifting left
trace( (a << 2).toBinaryString(8, false) );  // 1 01011100

// bitshifting right
trace( (a >>  3).toBinaryString() ); // 1010
trace( (a >>> 3).toBinaryString() ); // 1010


trace("------------------------------------------");
*/

/*		var a:BigInt;
		var b:BigInt;
		var c:BigInt;
		
		for (i in -5...6) {
			var a:BigInt = i;
			//trace("a=" + a, "i=" + i);
			//trace("i="+i, ~i, -(i+1), ~a, " n="+n, ~n, (-n-1), ~b );
			//trace("i="+i, i>>1, a>>1 );
			//trace("n="+n, " ~n="+(~n), " ~b="+(~b), n>>1,  ~( (~n)>>1 ),  ~( (-n-1)>>1 ) , b>>1 );
						
			//trace( i>>(-1), a>>(-1), "      ", i<<(-1),  a<<(-1) );
			//trace( i>>(2), a>>(2), "      ", i<<(2),  a<<(2) );
			
			//for (j in -15...6) 
				//if (i>=0 || j<0) trace('i=$i j=$j  :', i>>>j, a>>>j );
				//if (i>=0) trace('i=$i j=$j  :', i>>>j, a>>>j );
			
			//for (j in -5...6) 
				//if (i>=0) trace('i=$i j=$j  :', i>>>j, a>>>j );

			for (j in -5...6) 
				if (i>=0 && j>=0) trace('$i & $j   :   ', i & j, " --- ", a & j );
				//if (i<0 || j<0) trace('$i & $j   :   ', i & j, (~(-i-1) & ~(-j-1)), " --- ", a & j );

			//trace('"$i>>2"',  i>>2, i>>>2, " neg:", n>>2, ~((-n-1)>>2));
			//trace('"$i>>(-1)"', i>>>(-1)); // allwys 0 if neg-shiftvalue and error if there is negative i for >>>
			
		}
		
		trace("----------------");
*/		
/*		a = "0x1FFFFFF";
		b = "0x1FFFFFF";
		c = "0x3FFFFFC000001";		
		trace( ( a * b ) == c );
		trace( ( a * b ).toBinaryString(), c.toBinaryString() );
*/		
		//var a:BigInt = "0b 01111011 10111111 00101010 01110110 00101010011101";
		//a.toBytes();
		
		//trace( ((  ("0xaabbccddeeff":BigInt) * (3:BigInt) )) , "should be: 563170718108925");
		
/*		var a:BigInt = "0b 111010110 00001111";
		trace(a.toBinaryString(8));
		//trace(a.toBytes());
		trace( BigInt.fromBytes( a.toBytes() ).toBinaryString(8) );
*/
		
/*		var a:BigInt = "0b 10 100111100011100 111111110111100";
		
		var shift = 8;
		trace(  a.toBinaryString(45) );
		trace(  ((a >> shift):BigInt).toBinaryString(45-shift) );
		
		shift = 18;
		trace(  a.toBinaryString(50-shift) );
		trace(  ((a << shift):BigInt).toBinaryString(50) );
*/		
		
/*		var a:BigInt = "0b 1111 1111 1111 1111 1111 1111 1011 1100";
		var b:BigInt = "0b 1011 1010";
		
		trace(  ((a ^ b):BigInt).toBinaryString(4) );
*/		
/*		var a:BigInt = "4139543763576876256978864589462346353452";
		var e:BigInt = "1322448978334799562386783579042534564354";
		var m:BigInt = "19096727818566719527493245743456";
		
		var c = a.powMod(e, m);
		trace(c.toString());
*/
		//c = a.pow(e);
		//trace(c.toString());
		
/*		for (i in 0...10) trace( i, IntUtil.bitsize(i, 8), IntUtil.nextPowerOfTwo(i, 8) );
		
		trace ( (0x80000000:UInt) );
		
		trace ( (0x7fffffff:UInt), IntUtil.bitsize(0x7fffffff, 32), IntUtil.nextPowerOfTwo(0x7fffffff, 32) );
		trace ( (0x80000000:UInt), IntUtil.bitsize(0x80000000, 32), IntUtil.nextPowerOfTwo(0x80000000, 32) );
		trace ( (0x80000001:UInt), IntUtil.bitsize(0x80000001, 32), "2 ^ 32 outside of maxBitsize Error");
*/		
		// -> throws error for reaching maxBitsize 32
		//trace ( Util.nextPowerOfTwo(0x80000001, 32) );

/*		var a:BigInt = 0;
		var time = haxe.Timer.stamp();
		for (i in 0...1000) {
			a = i;
			a = a + "999999999999999999999999999999999999999999999999999999999999999999999";
		}
		for (i in 0...1000) {
			a = i+"999999999999999999999999999999999999999999999999999999999999999999999";
			a = a + "99";
		}
		trace( Std.int((haxe.Timer.stamp() - time) * 1000) + "\tms" );
		trace(a);
	
		trace(" ------------------------------- ");
*/		
		
/*		var a:BigInt = "-0x ffffffffff";
		trace(a.toBaseString(10, 4), a);
		
		var a:BigInt = -9;
		var b:BigInt = -4;
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = -9;
		var b:BigInt = 4;
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = 9;
		var b:BigInt = -4;
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = 9;
		var b:BigInt = 4;
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		trace("------------");
		
		var a:BigInt = "-0x ffffffffff";
		var b:BigInt = "-0x  34";		
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = "-0x ffffffffff";
		var b:BigInt = "0x  34";		
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = "0x ffffffffff";
		var b:BigInt = "-0x  34";		
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = "0x ffffffffff";
		var b:BigInt = "0x  34";		
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		trace("-------------------------------------------------------------------------------------");
		
		var a:BigInt = -4;
		var b:BigInt = -9;
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = 4;
		var b:BigInt = -9;
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = -4;
		var b:BigInt = 9;
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = 4;
		var b:BigInt = 9;
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		trace("------------");
		
		var a:BigInt = "-0x  34";		
		var b:BigInt = "-0x ffffffffff";
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = "0x  34";		
		var b:BigInt = "-0x ffffffffff";
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = "-0x  34";		
		var b:BigInt = "0x ffffffffff";
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = "0x  34";		
		var b:BigInt = "0x ffffffffff";
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		trace("------------");
		
		var a:BigInt = "-0x  123456789";		
		var b:BigInt = "-0x ffffffffff";
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = " 0x  123456789";		
		var b:BigInt = "-0x ffffffffff";
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = "-0x  123456789";		
		var b:BigInt = " 0x ffffffffff";
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = "0x  123456789";		
		var b:BigInt = "0x ffffffffff";
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		trace("------------");
		
		var a:BigInt = "-0x ffffffffff";
		var b:BigInt = "-0x  123456789";		
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = "-0x ffffffffff";
		var b:BigInt = " 0x  123456789";		
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = " 0x ffffffffff";
		var b:BigInt = "-0x  123456789";		
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
		var a:BigInt = "0x ffffffffff";
		var b:BigInt = "0x  123456789";		
		var c = BigInt.divMod(a, b);
		trace( a.toString() + " / " + b.toString() + " = " + c.quotient + "  rest " + c.remainder, c.quotient * b + c.remainder == a );
		
*/
		
/*		// from integer
		
		var i:BigInt = 0x7FFFFFFF;
		trace('i = $i');

		i = i + 1;
		trace('i+1 = $i');
		
		// mhm, why 1 + i not work ?
		// i = 1 + i;

		
		
		// from decimal string
		
		var x:BigInt = "255";
		trace('x = $x');
		
		
		// from octal string
		
		var y:BigInt = "0o10";
		trace('y = $y');
		
		
		
		// from binary
		
		var a:BigInt = "0b 1111 1111";
		trace('a = $a');
		
		
		
		// from hexadecimal
		
		var b:BigInt = "0x aa bb";
		trace('b = $b');
		
		
		
		// ------- Addition -------

		var c:BigInt = a + b;
		trace('a+b = $c');
		
		
		// ------- Subtraction -----
		trace('a-b', a - b);
		trace('b-a', b - a);
		
		
		// comparing
		trace('a>b', (a > b));
		trace('a<b', (a < b));
		
		// ------- Multiplication -----
		trace( ((  ("0xaabbccddeeff":BigInt) * (3:BigInt) )) , "should be: 200336699CCFD");
		trace( ((  (171:BigInt) * (205:BigInt) ):Int) , "should be: 35055");
		trace( (("0xAB":BigInt) * ("0xCD":BigInt)).toHexString() , "should be: 88EF");
		trace( (("0xABC":BigInt) * ("0xDEF":BigInt)).toHexString() , "should be: 959184");
		
		
		
		
		// sample
		
		//var metersOfLightyear:BigInt = "9 460 730 472 580 800";
		//var lightyearDistanceToAndromeda:BigInt = "2 537 000";


		// Fibonacci
		var fiboOld:BigInt = 1;
		var fibo:BigInt = 2;
		var tmp:BigInt;
		
		for (i in 0...1000) {
			tmp = fibo;
			fibo = fibo + fiboOld;
			fiboOld = tmp;
		}
		trace('Fibonacci(1000) : 0x $fibo');
		
        trace("--------------------------------------------");
*/		
		
/* 		
		// old tests with thx.core's BigInts
		
  		var b:BigInt;
		var n:BigInt;
		
		a = BigInt.fromInt(2);
		b = BigInt.fromInt(8);
		
		//n = BigInt.fromString("ff", 16, "0123456789abcdef");

		n = a.modPow(b, BigInt.fromInt(256) );
	
		var n:BigInt;

  		n = BigInt.fromStringWithBase(
			"00c037c37588b4329887e61c2da332"+
			"4b1ba4b81a63f9748fed2d8a410c2f"+
			"c21b1232f0d3bfa024276cfd884481"+
			"97aae486a63bfca7b8bf7754dfb327"+
			"c7201f6fd17fd7fd74158bd31ce772"+
			"c9f5f8ab584548a99a759b5a2c0532"+
			"162b7b6218e8f142bce2c30d778468"+
			"9a483e095e701618437913a8c39c3d"+
			"d0d4ca3c500b885fe3",
			16);

		//n = BigInt.fromStringWithBase("0102",16);
		//n = n.modPow( BigInt.fromInt(23), BigInt.fromInt(0xffff) );
		//n = BigInt.fromInt(2).modPow( BigInt.fromStringWithBase("3cf286a6de3b0a166c3375ac2fb009a87d9fcc23",16), n );
		
		n = BigInt.fromInt(0x10000) * BigInt.fromInt(0x10000);
		n = n / BigInt.fromInt(0x1000);
		//trace(n.toString());
		trace(n.toStringWithBase(16));
		trace( ((9999999 : BigInt) + 1 == 10000000) );
		trace( ((10000000 : BigInt) - 1 == 9999999) );
 */ 		
    }

}