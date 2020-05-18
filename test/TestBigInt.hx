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
	}
	
}