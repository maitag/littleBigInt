class TestBigInt extends haxe.unit.TestCase
{
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
		assertEquals( (0 : BigInt).toHexString(false), "0" );
		assertEquals( (-1 : BigInt).toHexString(false), "-1" );
		assertEquals( (16 : BigInt).toHexString(false), "10" );
		assertEquals( (255 : BigInt).toHexString(true), "00ff" );
		assertEquals( (255 : BigInt).toHexString(false), "ff" );
		assertEquals( (16777215 : BigInt).toHexString(false), "ffffff" );
		assertEquals( (16777215 : BigInt).toHexString(true), "00ff ffff" );
		assertEquals( (-16777215 : BigInt).toHexString(true), "-00ff ffff" );
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
		assertEquals( (0 : BigInt).toBinaryString(false), "0" );
		assertEquals( (-1 : BigInt).toBinaryString(false), "-1" );
		assertEquals( (16 : BigInt).toBinaryString(true), "00010000" );
		assertEquals( (127 : BigInt).toBinaryString(true), "01111111" );
		assertEquals( (127 : BigInt).toBinaryString(false), "1111111" );
		assertEquals( (16777215 : BigInt).toBinaryString(false), "111111111111111111111111" );
		assertEquals( (16777215 : BigInt).toBinaryString(true), "11111111 11111111 11111111" );
		assertEquals( (-16777215 : BigInt).toBinaryString(true), "-11111111 11111111 11111111" );
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
	
	
}