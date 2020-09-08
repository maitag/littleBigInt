class TestBigInt extends haxe.unit.TestCase
{
	public function testFromToInt() {
		assertEquals( (0 : BigInt).toInt(), 0 );
		assertEquals( (-1 : BigInt).toInt(), -1 );
		assertEquals( (0x7FFFFFFF : BigInt).toInt(), 0x7FFFFFFF );
		assertEquals( ("0x7FFFFFFF" : BigInt).toInt(), 0x7FFFFFFF );
		assertEquals( (-0x7FFFFFFF : BigInt).toInt(), -0x7FFFFFFF );
		assertEquals( ("-0x7FFFFFFF" : BigInt).toInt(), -0x7FFFFFFF );
		#if neko
		assertTrue( try { ("0x80000000" : BigInt).toInt(); false; } catch (e:Dynamic) true );
		#end
	}
	
	public function testFromString() {
		assertTrue( (" 0 " : BigInt) == 0 );
		assertTrue( (" -0 " : BigInt) == 0 );
		assertTrue( (" -0 000 " : BigInt) == 0 );
		assertTrue( (" -  5" : BigInt) == -5 );
		assertTrue( ("9 " : BigInt) == 9 );
		assertTrue( ("255" : BigInt) == 255 );
		assertTrue( ("1 000" : BigInt) == 1000 );
		assertTrue( ("2147483647" : BigInt) == 2147483647 );
		assertTrue( ("-2147483647" : BigInt) == -2147483647 );
		assertTrue( ("-127" : BigInt) == -127 );
		assertTrue( ("- 128" : BigInt) == -128 );
	}
	
	public function testFromBaseString() {
		assertTrue( BigInt.fromBaseString("0", 10) == 0 );
		assertTrue( BigInt.fromBaseString(" - 0", 10) == 0 );
		assertTrue( BigInt.fromBaseString("-54321", 10) == -54321 );
		assertTrue( BigInt.fromBaseString("12345", 10) == 12345 );
		assertTrue( BigInt.fromBaseString("25", 8) == 21 );
		assertTrue( BigInt.fromBaseString("-100", 8) == -64 );
		assertTrue( BigInt.fromBaseString("7FFFFFFF", 16) == 0x7FFFFFFF );
		assertTrue( BigInt.fromBaseString("12", 3) == 5 );
	}
	
	public function testToBaseString() {
		assertEquals( (0 : BigInt).toBaseString(2), "0" );
		assertEquals( (-1 : BigInt).toBaseString(10), "-1" );
		assertEquals( (8 : BigInt).toBaseString(8), "10" );
		assertEquals( (255 : BigInt).toBaseString(16, 2), "ff" );
		assertEquals( (255 : BigInt).toBaseString(16), "ff" );
		assertEquals( (256 : BigInt).toBaseString(16, 4, true), "0100" );
		assertEquals( (256 : BigInt).toBaseString(16), "100" );
		assertEquals( (16777215 : BigInt).toBaseString(16), "ffffff" );
		assertEquals( (16777215 : BigInt).toBaseString(16, 4), "ff ffff" );
		assertEquals( (-16777215 : BigInt).toBaseString(16, 8, true), "-00ffffff" );
	}

	public function testFromOctalString() {
		assertTrue( (" 0o 0" : BigInt) == 0 );
		assertTrue( (" -0o0" : BigInt) == 0 );
		assertTrue( ("0o10" : BigInt) == 8 );
		assertTrue( ("0o 24" : BigInt) == 20 );
	}
	
	public function testFromHexString() {
		assertTrue( (" 0x 0 " : BigInt) == 0 );
		assertTrue( (" -0x 0 " : BigInt) == 0 );
		assertTrue( (" -0 x 00 " : BigInt) == 0 );
		assertTrue( (" - 0x 5" : BigInt) == -5 );
		assertTrue( (" 0x9 " : BigInt) == 9 );
		assertTrue( ("0x ff" : BigInt) == 255 );
		assertTrue( ("0x 10 00" : BigInt) == 4096 );
		assertTrue( ("0x7f FF ffFf" : BigInt) == 2147483647 );
		assertTrue( ("-0x7f FF ffFf" : BigInt) == -2147483647 );
		assertTrue( ("-0x7f" : BigInt) == -127 );
		assertTrue( ("- 0x 80" : BigInt) == -128 );
	}
	
	public function testToHexString() {
		assertEquals( (0 : BigInt).toHexString(), "0" );
		assertEquals( (-1 : BigInt).toHexString(), "-1" );
		assertEquals( (16 : BigInt).toHexString(), "10" );
		assertEquals( (255 : BigInt).toHexString(2), "ff" );
		assertEquals( (255 : BigInt).toHexString(), "ff" );
		assertEquals( (256 : BigInt).toHexString(4), "0100" );
		assertEquals( (256 : BigInt).toHexString(), "100" );
		assertEquals( (16777215 : BigInt).toHexString(), "ffffff" );
		assertEquals( (16777215 : BigInt).toHexString(4), "00ff ffff" );
		assertEquals( (-16777215 : BigInt).toHexString(8), "-00ffffff" );
	}

	public function testFromBinaryString() {
		assertTrue( ("0b 0 " : BigInt) == 0 );
		assertTrue( ("-0b0" : BigInt) == 0 );
		assertTrue( ("  -0 b 00 00  " : BigInt) == 0 );
		assertTrue( ("- 0b 00101 " : BigInt) == -5 );
		assertTrue( ("  0b 1001" : BigInt) == 9 );
		assertTrue( ("0b 11111111" : BigInt) == 255 );
		assertTrue( ("0b 1 0000 0000 0000" : BigInt) == 4096 );
		assertTrue( ("0b1111111111111111111111111111111" : BigInt) == 2147483647 );
		assertTrue( ("-0b 01111111 11111111 11111111 11111111" : BigInt) == -2147483647 );
		assertTrue( ("-0b 111 1111" : BigInt) == -127 );
		assertTrue( ("- 0b 1000 0000" : BigInt) == -128 );
	}

	public function testToBinaryString() {
		assertEquals( (0 : BigInt).toBinaryString(), "0" );
		assertEquals( (-1 : BigInt).toBinaryString(), "-1" );
		assertEquals( (16 : BigInt).toBinaryString(8), "00010000" );
		assertEquals( (127 : BigInt).toBinaryString(4), "0111 1111" );
		assertEquals( (127 : BigInt).toBinaryString(), "1111111" );
		assertEquals( (128 : BigInt).toBinaryString(), "10000000" );
		assertEquals( (16777215 : BigInt).toBinaryString(), "111111111111111111111111" );
		assertEquals( (16777215 : BigInt).toBinaryString(8), "11111111 11111111 11111111" );
		assertEquals( (-16777215 : BigInt).toBinaryString(8), "-11111111 11111111 11111111" );
	}

	public function testComparing() {
		assertTrue( ("-0x 0" : BigInt) == ("0x 0" : BigInt) );
		assertTrue( ("0x 10" : BigInt) == ("0x 10" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) == ("0x ff ffff" : BigInt) );
		assertTrue( ("-0x ff ffff" : BigInt) == ("-0x ff ffff" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) <= ("0x ff ffff" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) <= ("0x 100 0000" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) < ("0x 100 0000" : BigInt) );
		assertTrue( ("-0x ff ffff" : BigInt) < ("0x 100 0000" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) >= ("0x ff ffff" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) >= ("0x ff ffff" : BigInt) );
		assertTrue( ("0x 100 0000" : BigInt) >= ("0x ff ffff" : BigInt) );
		assertTrue( ("-0x ff ffff" : BigInt) >= ("-0x ff ffff" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) >= ("-0x 0" : BigInt) );
		assertTrue( ("-0x ff ffff" : BigInt) > ("-0x 100 0000" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) > ("-0x 100 0000" : BigInt) );
		assertTrue( ("0x ff ffff" : BigInt) > ("-0x ff fffe" : BigInt) );
		assertTrue( ("-0x 100 0000" : BigInt) != ("0x 100 0000" : BigInt) );
		assertTrue( ("0x 100 0001" : BigInt) != ("0x 100 0000" : BigInt) );

		var a:BigInt = 1;
		var	b:BigInt = 2;
		assertTrue(a < b);
		assertTrue(a <= b);
		assertTrue(a <= a);		
		assertTrue(b > a);
		assertTrue(b >= a);
		assertTrue(b >= b);
		assertTrue(b <= b);
		
		a = "-333333333333333333333";
		b = "111111111111111111111111111111111111111";		
		assertTrue(a < b);
		assertTrue(a <= b);
		assertTrue(a <= a);		
		assertTrue(b > a);
		assertTrue(b >= a);
		assertTrue(b >= b);
		assertTrue(b <= b);
		
		a = "-37037037037037037036999999999999999999962962962962962962963";
		b = "-333333333333333333333";		
		assertTrue(a < b);
		assertTrue(a <= b);
		assertTrue(a <= a);		
		assertTrue(b > a);
		assertTrue(b >= a);
		assertTrue(b >= b);
		assertTrue(b <= b);
	}

	public function testNegation() {
		var a:BigInt = 0;
		assertTrue(-a == a);
		
		a = 1;
		assertTrue(-a == -1);
		assertTrue(-(-a) == a);
		
		a = -1234;
		assertTrue(-a == 1234);
		assertTrue(-(-a) == a);
		
		a = "-192395858359234934684359234";
		var b:BigInt = "192395858359234934684359234";
		assertTrue(-b == a);
		assertTrue( b == -a);
	}

   public function testAbs() {
		assertTrue((0 : BigInt).abs() == 0);
		assertTrue(("-0" : BigInt).abs() == 0);
		assertTrue((54 : BigInt).abs() == 54);
		assertTrue((-54 : BigInt).abs() == 54);
		assertTrue(("13412564654613034984065434" : BigInt).abs() == "13412564654613034984065434");
		assertTrue(("-13412564654613034984065434" : BigInt).abs() == "13412564654613034984065434");
   }

	public function testAddition() {
		assertTrue( (0 : BigInt) + (0 : BigInt) == (0 : BigInt) );
		assertTrue( (1 : BigInt) + (0 : BigInt) == (1 : BigInt) );
		assertTrue( (1 : BigInt) + (1 : BigInt) == (2 : BigInt) );
		assertTrue( (-1 : BigInt) + (0 : BigInt) == (-1 : BigInt) );
		assertTrue( (0 : BigInt) + (-1 : BigInt) == (-1 : BigInt) );
		assertTrue( (1 : BigInt) + (-1 : BigInt) == (0 : BigInt) );
		assertTrue( (2 : BigInt) + (-1 : BigInt) == (1 : BigInt) );
		assertTrue( (-1 : BigInt) + (-1 : BigInt) == (-2 : BigInt) );
		assertTrue( (-1 : BigInt) + (3 : BigInt) == (2 : BigInt) );
		assertTrue( (-2 : BigInt) + (-1 : BigInt) == (-3 : BigInt) );
		assertTrue( ("0x ffff ffff" : BigInt) + (1 : BigInt) == ("0x 1 0000 0000" : BigInt) );
		assertTrue( ("0x 1 0000 0000" : BigInt) + ("0x ffff ffff" : BigInt) == ("0x 1 ffff ffff" : BigInt) );
	}
	
	public function testSubtraction() {
		assertTrue( (0 : BigInt) - (0 : BigInt) == (0 : BigInt) );
		assertTrue( (1 : BigInt) - (0 : BigInt) == (1 : BigInt) );
		assertTrue( (1 : BigInt) - (1 : BigInt) == (0 : BigInt) );
		assertTrue( (-1 : BigInt) - (0 : BigInt) == (-1 : BigInt) );
		assertTrue( (1 : BigInt) - (-1 : BigInt) == (2 : BigInt) );
		assertTrue( (-1 : BigInt) - (-1 : BigInt) == (0 : BigInt) );
		assertTrue( (-2 : BigInt) - (-1 : BigInt) == (-1 : BigInt) );
		assertTrue( (-1 : BigInt) - (-3 : BigInt) == (2 : BigInt) );
		assertTrue( ("0x ffff ffff" : BigInt) - (1 : BigInt) == ("0x ffff fffe" : BigInt) );
		assertTrue( ("0x 1 0000 0000" : BigInt) - ("0x ffff ffff" : BigInt) == ( 1 : BigInt) );
		assertTrue( ("0x ffff ffff" : BigInt) - ("0x 1 0000 0000" : BigInt) == ( -1 : BigInt) );
		assertTrue( ("0x ffff ffff" : BigInt) - ("0x 2 0000 0000" : BigInt) == ( "-0x 1 0000 0001" : BigInt) );
		assertTrue( ("-0x 1 0000 0000" : BigInt) - ("0x ffff ffff" : BigInt) == ( "-0x 1 ffff ffff" : BigInt) );
		assertTrue( ("-0x 1 0000 0000" : BigInt) - ("0x 0" : BigInt) == ( "-0x 1 0000 0000" : BigInt) );
	}
	
	public function testMultiplication() {
		assertEquals( ( (0 : BigInt) * (0 : BigInt) ).toInt(), 0 );
		assertEquals( ( (1 : BigInt) * (0 : BigInt) ).toInt(), 0 );
		assertEquals( ( (0 : BigInt) * (1 : BigInt) ).toInt(), 0 );
		assertEquals( ( (1 : BigInt) * (1 : BigInt) ).toInt(), 1 );
		assertEquals( ( (2 : BigInt) * (2 : BigInt) ).toInt(), 4 );
		assertEquals( ( (6 : BigInt) * (7 : BigInt) ).toInt(), 42 );
		assertEquals( ( (12 : BigInt) * (-9 : BigInt) ).toInt(), -108 );
		assertEquals( ( (-8 : BigInt) * (111 : BigInt) ).toInt(), -888 );
		assertEquals( ( ( -14 : BigInt) * ( -23 : BigInt) ).toInt(), 322 );
		var a:BigInt = "0x123456789abcdef112233445566778899aabbccddeeff987654321fedcba987654321";
		var b:BigInt = "0x73b5c003fe76cc41a904bcd6f325e56cd974bb1a8e653e0ff76cf3b1936cde63110af";
		var c:BigInt = "0x83a6f80da5817994858b95127c284366b38bc087d0f522993e797cb39a6b7a70ec441e6fc8853782d1c4fe22ecf3f93fd26f0eaa57f9c785f5a44581cecd96d7861bbf38f";
		assertEquals( ( a * b ).toString(), c.toString() );
		assertTrue( a * b == (a-3) * b + (b * 3) );
		var d:BigInt = 0;
		for (i in 0...1234) d += c;
		assertEquals( ( c * 1234 ).toString(), d.toString() );
		
		var m : BigInt;

		a = 12347; b = 0;
		assertTrue(a*b == b);
		assertTrue(b*a == b);

		a = -99999; b = 1;
		assertTrue(a*b == a);
		assertTrue(b*a == a);

		a = 1235; b = 44; c = 54340;
		assertTrue(a*b == c);
		assertTrue(b*a == c);

		a = -11; b = -9; c = 99;
		assertTrue(a*b == c);

		a = 55; b = 200395; c = 11021725;
		assertTrue(a*b == c);

		a = "111111111111111111111111111111111111111";
		b = "-333333333333333333333";
		c = "-37037037037037037036999999999999999999962962962962962962963";
		assertTrue(a * b == c);
	}
	
	public function testModulo() {
		assertEquals( ( (0 : BigInt) % (10 : BigInt) ).toInt(), 0 );
		assertEquals( ( (0 : BigInt) % (-10 : BigInt) ).toInt(), 0 );
		
		assertEquals( ( (1 : BigInt) % ( 10 : BigInt) ).toInt(), 1 );
		assertEquals( ( (1 : BigInt) % (-10 : BigInt) ).toInt(), 1 );
		assertEquals( ( (-1 : BigInt) % ( 10 : BigInt) ).toInt(), -1 );
		assertEquals( ( (-1 : BigInt) % (-10 : BigInt) ).toInt(), -1 );
		
		assertEquals( ( (11 : BigInt) % ( 10 : BigInt) ).toInt(), 1 );
		assertEquals( ( (11 : BigInt) % (-10 : BigInt) ).toInt(), 1 );
		assertEquals( ( (-11 : BigInt) % ( 10 : BigInt) ).toInt(), -1 );
		assertEquals( ( (-11 : BigInt) % (-10 : BigInt) ).toInt(), -1 );
		
		assertEquals( ( ( "234566742345367567353452" : BigInt) % (1 : BigInt) ).toInt(), 0 );
		assertEquals( ( ( "2938289887273578834588723405828340070292347195862712329756482349" : BigInt) % (2 : BigInt) ).toInt(), 1 );
		assertEquals( ( ( "2938289887273578834588723405828340070292347195862712329756482349" : BigInt) % ( "2938289887273578834588723405828340070292347195862712329756482300" : BigInt) ).toInt(), 49 );
		assertEquals( ( ( "2938289887273578834588723405828340070292347195862712329756482349" : BigInt) % ("-2938289887273578834588723405828340070292347195862712329756482300" : BigInt) ).toInt(), 49 );
		assertEquals( ( ("-2938289887273578834588723405828340070292347195862712329756482349" : BigInt) % ( "2938289887273578834588723405828340070292347195862712329756482300" : BigInt) ).toInt(),-49 );
		assertEquals( ( ("-2938289887273578834588723405828340070292347195862712329756482349" : BigInt) % ("-2938289887273578834588723405828340070292347195862712329756482300" : BigInt) ).toInt(),-49 );
	}
	
	public function testDivision() {
		assertEquals( ( (0 : BigInt) / (10 : BigInt) ).toInt(), 0 );
		
		var result = BigInt.divMod( 9, 4 );
		assertEquals( result.quotient.toInt(), 2 );
		assertEquals( result.remainder.toInt(), 1 );
		
		result = BigInt.divMod( -9, 4 );
		assertEquals( result.quotient.toInt(), -2 );
		assertEquals( result.remainder.toInt(), -1 );
		
		result = BigInt.divMod( 9, -4 );
		assertEquals( result.quotient.toInt(), -2 );
		assertEquals( result.remainder.toInt(), 1 );
		
		result = BigInt.divMod( -9, -4 );
		assertEquals( result.quotient.toInt(), 2 );
		assertEquals( result.remainder.toInt(), -1 );
		
		// divModLittle
		
		result = BigInt.divMod( "0x ff ffff ffff", "0x 33" );
		assertEquals( result.quotient.toHexString(), "505050505");
		assertEquals( result.remainder.toInt(), 0 );
		
		result = BigInt.divMod( "0x 100 0000 0000", "0x 33" );
		assertEquals( result.quotient.toHexString(), "505050505");
		assertEquals( result.remainder.toInt(), 1 );
		
		// divModLong
		var divident:Array<BigInt>= [-9,-9, 9, 9, "-0xffffffffff", "-0xffffffffff", "0xffffffffff", "0xffffffffff" ];
		var divisor:Array<BigInt> = [-4, 4,-4, 4,          -0x34 ,           0x34 ,         -0x34 ,          0x34  ];
		
		divident = divident.concat( [-4, 4,-4, 4,          -0x34 ,           0x34 ,         -0x34 ,          0x34  ] );
		divisor  = divisor.concat ( [-9,-9, 9, 9, "-0xffffffffff", "-0xffffffffff", "0xffffffffff", "0xffffffffff" ] );
		
		divident = divident.concat( ["-0x 123456789", " 0x 123456789", "-0x 123456789", "0x 123456789" ] );
		divisor  = divisor.concat ( ["-0xffffffffff", "-0xffffffffff", " 0xffffffffff", "0xffffffffff" ] );
		
		divident = divident.concat( ["-0xffffffffff", "-0xffffffffff", " 0xffffffffff", "0xffffffffff" ] );
		divisor  = divisor.concat ( ["-0x 123456789", " 0x 123456789", "-0x 123456789", "0x 123456789" ] );
		
		divident = divident.concat( ["0x 15fe4f603a4dfabffcf78f709fbdcebf04", "0x a5f44f603a4abfcbf738f7089fbdcebf0" ] );
		divisor  = divisor.concat ( ["0x  12cf34ae567d85aaf803bc9e35db7aa08", "0x                     37f70cbbcf604" ] );
		
		divident = divident.concat( ["0x  12cf34ae567d85aaf803bc9e35db7aa08", "0x a5f44f603a4abfcbf738f7089fbdcebf0" ] );
		divisor  = divisor.concat ( ["0x 15fe4f603a4dfabffcf78f709fbdcebf04", "0x                            3f5fb4" ] );
		
		for (i in 0...divident.length) {
			var a = divident[i];
			var b = divisor[i];
			var result = BigInt.divMod(a, b);
			assertTrue( result.quotient * b + result.remainder == a );
		}		
	}
	
	public function testPow() {
		assertEquals( ( (0 : BigInt).pow("9844190321790980841789") ).toInt(), 0 );
		assertEquals( ( (1 : BigInt).pow("9844190321790980841789") ).toInt(), 1 );
		assertTrue(("9844190321790980841789" : BigInt).pow(0) == 1);
		assertTrue(("9844190321790980841789" : BigInt).pow(1) == "9844190321790980841789");
		assertTrue((252 : BigInt).pow(124) == "5938367311357894783707160053746995174420310205828475852414076013938629891503128283948631773358868260990930862750953888472307867713712589898179153244476868510006056477315240397220674879224085413293137093058033640525738900314887652830363105200755814422450693335653967468344026614374568850656084361216");
		assertTrue((-252 : BigInt).pow(14) == "4164928698882469942515671324688384");
		assertTrue((-252 : BigInt).pow(13) == "-16527494836835198184585997320192");
	}
	
	public function testPowMod() {
		assertEquals( ( (0 : BigInt).powMod("9844190321790980841789","20194965098495006574") ).toInt(), 0 );
		assertEquals( ( (1 : BigInt).powMod("9844190321790980841789","20194965098495006574") ).toInt(), 1 );
		assertEquals( ( ( 4 : BigInt).powMod(13,  497) ).toInt(),  445 );
		assertEquals( ( ( 4 : BigInt).powMod(13, -497) ).toInt(),  445 );
		assertEquals( ( (-4 : BigInt).powMod(13,  497) ).toInt(), -445 );
		assertEquals( ( (-4 : BigInt).powMod(13, -497) ).toInt(), -445 );
		assertTrue(("9844190321790980841789" : BigInt).powMod(1,"20194965098495006574") == "9242318823912640251");
		assertTrue(("4139543763576876256978864589462346353452" : BigInt).powMod("1322448978334799562386783579042534564354","19096727818566719527493245743456") == "17450867125893875188144890320704");
		assertTrue(("-4139543763576876256978864589462346353452" : BigInt).powMod("1322448978334799562386783579042534564354","19096727818566719527493245743456") == "17450867125893875188144890320704");
		assertTrue(("163353452" : BigInt).powMod("37904",1) == 0);
		assertTrue(("163353452" : BigInt).powMod(0, 1) == 0);
		assertTrue(("163353452" : BigInt).powMod(0, 14) == 1);
	}
	
	public function testDivisionBy1IsTheIdentity() {
		assertTrue((1 : BigInt) / 1 == 1);
		assertTrue((-1 : BigInt) / 1 == -1);
		assertTrue((1 : BigInt) / -1 == -1);
		assertTrue((153 : BigInt) / 1 == 153);
		assertTrue((-153 : BigInt) / 1 == -153);
		assertTrue(("9844190321790980841789" : BigInt) / 1 == "9844190321790980841789");
		assertTrue(("-9844190321790980841789" : BigInt) / 1 == "-9844190321790980841789");
	}

	public function testDivisionBySelfIs1() {
		assertTrue((5 : BigInt) / 5 == 1);
		assertTrue((-5 : BigInt) / -5 == 1);
		assertTrue(("20194965098495006574" : BigInt) / "20194965098495006574" == 1);
		assertTrue(("-20194965098495006574" : BigInt) / "-20194965098495006574" == 1);
	}

	public function testDivisionOf0Equals0() {
		assertTrue((0 : BigInt) / 1 == 0);
		assertTrue((-0 : BigInt) / 1 == 0);
		assertTrue((-0 : BigInt) / "1234567890987654321" == 0);
		assertTrue((0 : BigInt) / "-1234567890987654321" == 0);
	}

   public function testCanHandleLargeNumbers() {
		var tenFactorial:BigInt = "3628800";
		var hundredFactorial:BigInt = "93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000";
		var threeToTenThousand:BigInt = "1631350185342625874303256729181154716812132453582537993934820326191825730814319078748015563084784830967325204522323579543340558299917720385238147914536811250"
			+"14531923551662243910254236288435566865596596450120141774482755299903732744254464257512355373418673876078136199372256168728620165048055931740599095204616685006631189269115717734522558"
			+"50626968526251879139867085080472539640933730243410152186914328917354576854457274195562218013337745628502470673059426999114202540773175988199842487276183685299388927825296786440252999"
			+"44478569418367532352170443219578580627012338838293177019899084130086150699610894478206501516341034489494580933768915680768667346256303816479219066534012434413398076320559436475496345"
			+"15640723405026063777905851141238149190016371770344573850199390602329251944711142358929785653224156283441421848428920834662278757605012760098015307030375258391578938757411924977053004"
			+"69691062454369926795975456340236777734354667139072601574969834312769653557184396147587071260443947944862235744459711204473062937764153770030210332183635531818173456618022745975055313"
			+"21259851442958754554729653460959719483603654687049177192762521435295750345494840363582234572877488517580950015845183738941379809532971199309210141742840677432612645000546788873654625"
			+"49486586024844945359388886565427469774243683853354960831649213186019349770250957803701043079802763568573503492058660783718060655423935361016734020179809515989469806643303915058458036"
			+"74248348878071010412918667335823849899623486215050304052577789848512410263834811719236949311423411823585316405085306164936671137456985394285677324771775046050970865520893596151687017"
			+"15385575519734819965907019295477130834762711105247113447632598636283858595955220964538208905518287185486674463373753321752488011840178759509406085571701014408713649553241854424148943"
			+"70800747161584048959141364518020324467079610587576333456916967432938696237454108700518515906728593470612125734465720450884654606168260825797316860045852182843334523961577300363063794"
			+"21822435818001505905203918209206969662326706952623512427380240468784114535101496733983401240219840048956733689309620321613793757156727562461651933397540266795963865921590913322060572"
			+"67334984925330339787424238196077533718273003778369870874878173841974769888032160118631050633286970493130307683944479096833930630127337101408724806094685179369797311443270675928854607"
			+"76228310025268005548496968677102809459466036695937973546421366222311926950273212295119129529403208797631231517605559594969611631414556882788429495872883991002736918800187741475688926"
			+"50186152065335219113072582417699616901995530249937735219099786758954892534365835235843156112799728164123461219817343904782402517111603206575330527850752564642995318064985900815557979"
			+"94588593112435130325281125525429579708228194665879870597907749246984964418316658595084495316472689614616829780817839847045156132052618054231084074484310746936895970772683660847181706"
			+"05987717301707554464734407740313712274376510484216062247575270859585159472731510274006629481611112847778281035314994889136728007831678880511771554272851038617366580694047976959007588"
			+"20465238673970882660162285107599221418743657006872537842677883708807515850397691812433880561772652364847297019508025848964833883225165668986935081274596293983121864046277268590401580"
			+"20905998850051126247016715049526190813668869386132408155904633628896303709031203352240072236088249492818280907540691431995704492750442079727811783767743144697908575643299075358258810"
			+"24402406110390845164010899488684333537484441046397340745191650676329414193479856244355673420728159107544841238129174873129382806704032281888130039783840813322424846465714175744048529"
			+"62675165616101527367425654869508712001788393846171780457455963045764943565964887518396481296159902471996735508854292964536796779404377230965723361625182030798297734785854606060323419"
			+"09164671113867849092884010744992345683476376311422600077031693124366669942569482818115504884316138083206784548056975845775109064099600724201825540062727690818808260179552016705470132"
			+"78023669897470828354811055438784468898962306960918816435474761549985740159073960594786849785741804867989184386431646185413516892583790423264876694797333847129967542517038080378286365"
			+"99654447727795924596382283226723503386540591321268603222892807562509801015765174359627788357881606366119032951829868274617539946921221330284257027058653162292482686679275266764009881"
			+"98559064853454493922429668979119535578320596849242263627765673533848829910423806028920939065446731629159121971286605266134702685526128938123688106306821924906476708649518417681662907"
			+"71036671315050649641909104501965021789724773618813006086885937825097937814571703968974969088618930346348957151171146015146543813471390923458334722264936569309960450163558081629849652"
			+"03661519182202145414866559662218796964329217241498105206552200001";
		
		function factorial(n:BigInt):BigInt {
			if (n == 0 || n == 1) {
				return 1;
			}
			return factorial(n-1) * n;
		}
		
		assertTrue(factorial(10) == tenFactorial);
		assertTrue(factorial(100) == hundredFactorial);
		
		var a:BigInt = 1;
		for (i in 0...10000) a = a * 3;
		assertTrue(a == threeToTenThousand);
   }

	public function testCarriesOverCorrectly() {
		assertTrue(("9007199254740991" : BigInt) + 1 == "9007199254740992");
		assertTrue(("-9007199254740983" : BigInt) + "-9999999999999998" == "-19007199254740981");
		assertTrue(("100000000000000000000000000000000000" : BigInt) - "999999999999999999" == "99999999999999999000000000000000001");
		assertTrue(("50000005000000" : BigInt) * "10000001" == "500000100000005000000");
	}

	public function testMisc() {
		assertTrue(("10" : BigInt) + 10 == "20");
		assertTrue(("-10000000000000000" : BigInt) + "0" == "-10000000000000000");
		assertTrue(("0" : BigInt) + "10000000000000000" == "10000000000000000");
		assertTrue((9999999 : BigInt) + 1 == 10000000);
		assertTrue((10000000 : BigInt) - 1 == 9999999);
		assertTrue(("-1000000000000000000000000000000000001" : BigInt) + "1000000000000000000000000000000000000" == -1);
		assertTrue(("100000000000000000002222222222222222222" : BigInt) - "100000000000000000001111111111111111111" == "1111111111111111111");
		assertTrue(("1" : BigInt) + "0" == "1");
		assertTrue(("10" : BigInt) + "10000000000000000" == "10000000000000010");
		assertTrue(("10000000000000000" : BigInt) + "10" == "10000000000000010");
		assertTrue(("10000000000000000" : BigInt) + "10000000000000000" == "20000000000000000");
	}
   
   public function testShiftingLeftAndRight() {
		assertTrue((-5 : BigInt) >> 2 == -1);
		assertTrue((5 : BigInt) >> -2 == 20);
		assertTrue((5 : BigInt) << -2 == 1);
		assertTrue((1024 : BigInt) << 100 == "1298074214633706907132624082305024");
		assertTrue(("2596148429267413814265248164610049" : BigInt) >> 100 == 2048);
		assertTrue(("8589934592" : BigInt) >> -50 == "9671406556917033397649408");
		assertTrue(("38685626227668133590597632" : BigInt) << -50 == "34359738368");
   }

   public function testBitwiseOperations() {
		assertTrue(("435783453" : BigInt) & "902345074" == "298352912");
		assertTrue(("435783453" : BigInt) | "902345074" == "1039775615");
		assertTrue(("435783453" : BigInt) ^ "902345074" == "741422703");
		assertTrue(("12" : BigInt) ^ -5 == "-9");
   }
   
}