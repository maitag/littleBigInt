# littleBigInt
pure haxe implementation for arbitrary size integer
  
  
## Testing

Needs a haxe-version greater then 3.4.4 and  
can be test for hashlink, cpp, neko and javascript targets.  
  
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

// or use a prefix to define number format
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
trace(  a.toInt()  ); // -> 194  (throws out an error if 'a' not fit into Int size)


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


### Math functions and expressions
```
- addition and subtraction (+, -)
- multiplication (Karatsuba) (*)
- division (/)
- division with remainder (divmod)
- modulo (%)
- pow and powMod
- comparing (>, <, >=, <=, ==, !=)
- negation (-)
- absolute value (abs)
- binary operations (~, &, |, ^)
- bitshifting (>>>, >>, <<)
- Bytes in/output to store BigInts

Please tell me if you miss something ~^ 

```



## Todo

- more into synopsis here
- fixing output with leading zeros
- optional great letters for hexadecimal output

- more benchmarks
- optimizing division (toInt() without bitsize-check)
- optimizing with haxe.Int64 chunks
- targetspecific optimizations for the chunk-arrays

- make `&`, `|`, `^` bitwise operations working with negative numbers (two's complement compatible)