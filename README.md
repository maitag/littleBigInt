# littleBigInt
pure haxe implementation for arbitrary size integer

Tested on hashlink, cpp, neko and javascript targets  
and works with haxe > 3.4.4  

## What is implemented yet:

- string in/output for any base(<= 16)
- addition and subtraction (+, -)
- multiplication (Karatsuba) (*)
- division (/)
- division with remainder (divmod)
- modulo (%)
- pow and powMod
- comparing (>, <, >=, <=, ==, !=)
- negation (-)
- absolute value (abs)
- binary operations (&, |, ^)
- bitshifting (>>>, >>, <<)
- Bytes in/output to store BigInts


Please tell me if you miss something ~^ 
  
  
## Testing

To perform benchmarks or unit-tests call the `text.hx` [hxp](https://lib.haxe.org/p/hxp) script. 
  
install [hxp](https://lib.haxe.org/p/hxp) via:
```
haxelib install hxp
haxelib run hxp --install-hxp-alias
```

then simple call `hpx test hl neko ...` or  
`hpx help` into projectfolder to see more targetspecific options.


## Synopsis


### Creating BigInts
```
// from an Integer
var a:BigInt = 5;

// from a String
var b:BigInt = "127";

// or defining values on demand inside brackets-definition like:
var x = (2147483647:BigInt) * ("1 000 000 000   000 000 000" : BigInt);

trace(x); // -> 2147483647000000000000000000
```


### Number formats
```
// use a prefix to define numberformat
var a:BigInt = "0x ffff 0000";   // hexadecimal
var b:BigInt = "0o 01234567 10"; // octal
var c:BigInt = "0b 00111010";    // binary  

// if there is a sign, it has to be at placed at first
var d:BigInt = "-0xFF";

// helper functions to create into various notations
var i = BigInt.fromInt(127);
x = BigInt.fromString("0x aabb");
a = BigInt.fromHexString("aaFF 01e3");
b = BigInt.fromOctalString("7724 1160");
c = BigInt.fromBinaryString("0010 1101");


// to output into different formats
trace(  i.toBinaryString(8) );   // -> 01111111
trace(  i.toBinaryString()  );   // -> 1111111
trace(  x.toOctalString(3)  );   // -> 125 273
trace( (a+b+c).toHexString(4) ); // -> abfc 4480

```




## Todo

- more into synopsis here
- optional great letters for hexadecimal output

- more benchmarks
- optimizing division (toInt() without bitsize-check)
- optimizing with haxe.Int64 chunks
- targetspecific optimizations for the chunk-arrays

- make `&`, `|`, `^` bitwise operations working with negative numbers (two's complement compatible)