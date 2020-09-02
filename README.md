# littleBigInt
little pure haxe BigInt implementation

## what is implemented yet:

- string in/output for any base(<= 16)
- addition and subtraction
- multiplication (Karatsuba)
- division with remainder
- modulo
- comparing (>, <, >=, <=, ==, !=)
- negation


## missing features

- binary operations
- pow and modPow

- Bytes in/output for storing BigInts


## testing

To perform benchmarks or unit-tests call the `text.hx` [hxp](https://lib.haxe.org/p/hxp) script. 
  
install [hxp](https://lib.haxe.org/p/hxp) via:
```
haxelib install hxp
haxelib run hxp --install-hxp-alias
```

then simple call `hpx help` into projectfolder to see options.


## todo

- optimization with bytearrays
- more unit-tests and benchmarks