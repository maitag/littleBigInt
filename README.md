# littleBigInt
little pure haxe BigInt implementation

## what is implemented yet:

- string in/output for any base(<= 16)
- addition and subtraction
- multiplication (Karatsuba)
- division with remainder
- comparing (>, <, >=, <=, ==, !=)
- negation


## missing features

- modulo
- pow and modPow
- binary operations

- Bytes in/output (to store BigInts)


## testing

To perform benchmarks or unit-tests call the `text.hx` hxp script. 
  
install hxp via:
```
haxelib install hxp
haxelib run hxp --install-hxp-alias
```

then simple call `hpx help` into projectfolder to see options.


## todo

- optimization with bytearrays
- more unit-tests and benchmarks