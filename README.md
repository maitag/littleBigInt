# littleBigInt
another little pure haxe BigInt implementation (work in progress)

## what is implemented yet:

- string in/output for binary and hexadecimal notation
- string input for any base(<= 16)
- addition and subtraction
- multiplication (Karatsuba)
- division with remainder
- comparing (>, <, >=, <=, ==, !=)
- negation


## missing features

- string output for any base
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

- optimization (with bytearrays!)
- performance testing/optimizing for all targets