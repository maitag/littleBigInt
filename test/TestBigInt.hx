class TestBigInt extends haxe.unit.TestCase
{
	public function testFromHexString() {
		assertTrue( (" 0x9 " : BigInt) == 9 );
		assertTrue( ("0x ff" : BigInt) == 255 );
		assertTrue( ("0x 10 00" : BigInt) == 4096 );
		assertTrue( ("0x7f FF ffFf" : BigInt) == 2147483647 );
		assertTrue( ("-0x7f" : BigInt) == -127 );
		assertTrue( ("- 0x 80" : BigInt) == -128 );
	}
	
	public function testToHexString() {
		assertEquals( (16 : BigInt).toHexString(false), "10" );
		assertEquals( (255 : BigInt).toHexString(true), "00ff" );
		assertEquals( (255 : BigInt).toHexString(false), "ff" );
		assertEquals( (16777215 : BigInt).toHexString(false), "ffffff" );
		assertEquals( (16777215 : BigInt).toHexString(true), "00ff ffff" );
	}
	
}