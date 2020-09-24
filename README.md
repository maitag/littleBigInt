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


## Todo

- make all bitwise-ops two's complement compatible
- optional great letters for hexadecimal output

- more benchmarks
- optimizing division (toInt() without bitsize-check)
- optimizing with haxe.Int64 chunks
- targetspecific optimizations for the chunk-arrays