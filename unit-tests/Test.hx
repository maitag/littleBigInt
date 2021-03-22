class Test {
	
	static function main(){
		var r = new haxe.unit.TestRunner();
		
		r.add(new TestBigInt());
		
		// run the tests
		r.run();
	}
}
