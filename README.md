# littleBigInt
pure haxe implementation for arbitrary size integer  
  
This lib was designed and optimized for fast [Karatsuba](https://en.wikipedia.org/wiki/Karatsuba_algorithm) multiplicaton.  
Works with all haxe-version greater then 3.4.4 and tested on hashlink, cpp, neko and javascript targets.  

  
## Installation
```
haxelib install littleBigInt
```

or use the latest developement version from github:
```
haxelib git littleBigInt https://github.com/maitag/littleBigInt.git
```


## Testing

To perform benchmarks or unit-tests call the `test.hx` [hxp](https://lib.haxe.org/p/hxp) script. 
  
install [hxp](https://lib.haxe.org/p/hxp) via:
```
haxelib install hxp
haxelib run hxp --install-hxp-alias
```

then simple call `hpx test hl neko ...` or  
`hpx help` into projectfolder to see more targetspecific options.
  
  
## Synopsis


### Creating BigInts
```hx
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
BigInt.fromBaseString("2010221101102", 3); // to number base 3


// you can also define values on demand inside brackets like:
var x = (2147483647:BigInt) * ("1 000 000 000   000 000 000":BigInt);
trace(x); // 2147483647000000000000000000


// from Bytes
var bytes = Bytes.ofString("A");
var a = BigInt.fromBytes(bytes);
trace(a); // 65
```


### Signing and the zero value
```hx
// signs has to be placed at first of notation
var a:BigInt = "-0xFF";

// the 'null' value is equivalent to 0
var zero:BigInt = 0;
trace( zero );         // null
trace( zero.toInt() ); // 0
```


### Different output formats
```hx
var a = BigInt.fromBaseString("01234", 5);

// convert into native integer
trace(  a.toInt()  ); // -> 194  (throws out an error if 'a' not fit into)


// convert into String for different number bases
trace( a.toString() );          // decimal:    "194"
trace( a.toBinaryString() );   // binary: "11000010"
trace( a.toOctalString() );   // octal:        "302"
trace( a.toHexString() );    // hexadecimal:    "c2"
trace( a.toBaseString(7) ); // base 7:         "365"

// create spacings
trace( a.toBinaryString(4) );   //   1100 0010
trace( a.toBinaryString(3) );   // 011 000 010


// store into Bytes
var bytes:Bytes = a.toBytes();
trace(bytes.length); // 1
```


### Arithmetic operations
```hx
var a:BigInt = 3;
var b:BigInt = 7;

// addition and subtraction
trace(a + b); // 10

// increment and decrement
trace(++a); // 3
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
```



### Comparing

All comparing operators `>`, `<`, `>=`, `<=`, `==`, `!=`  
works like default and return the expected boolean value.



### Bitwise Operations

For positive values all the operations work the same as they do with integers  
but because there is no sign-bit, with negative numbers it don't make sense outside of [two's complement](https://en.wikipedia.org/wiki/Two%27s_complement).

```hx
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
```

Let me know if something's mising ~^  
  
  
  
## Todo

- more into synopsis here
- fixing output with leading zeros
- optional exponential notation for decimals
- optional great letters for hexadecimal output
  
- more benchmarks
- optimizing division (toInt() without bitsize-check)
- optimizing with haxe.Int64 chunks
- targetspecific optimizations for the chunk-arrays
  
- make `&`, `|`, `^` bitwise operations working with negative numbers (two's complement compatible)