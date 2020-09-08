# littleBigInt
little pure haxe BigInt implementation

Tested on hashlink, cpp, neko and javascript targets  
works with haxe > 3.4.4  

## what is implemented yet:

- string in/output for any base(<= 16)
- addition and subtraction
- multiplication (Karatsuba)
- division with remainder
- modulo
- pow and powMod
- comparing (>, <, >=, <=, ==, !=)
- negation, abs
- binary operations (&, |, ^)
- Bytes in/output for storing BigInts


Please tell me if you miss something ~^ 
  
  
## testing

To perform benchmarks or unit-tests call the `text.hx` [hxp](https://lib.haxe.org/p/hxp) script. 
  
install [hxp](https://lib.haxe.org/p/hxp) via:
```
haxelib install hxp
haxelib run hxp --install-hxp-alias
```

then simple call `hpx test hl neko ...` or  
`hpx help` into projectfolder to see more targetspecific options.


## todo

- fixing bugs for larger chunk-BITSIZEs
- more unit-tests and benchmarks
  
- js optimization to work with fully 2^53 precision
- trying all targets with haxe.Int64 chunks
- more targetspecific optimization