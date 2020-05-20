#! /usr/local/bin/hxp
import hxp.*;
import haxe.Timer;

/*
 * HXP script for crossplatform testing little BigInt
 * (https://github.com/openfl/hxp) 
 * 
 * install with:
 * 
 * haxelib install hxp
 * haxelib run hxp --install-hxp-alias
 * 
*/

class Test extends hxp.Script {
	
	public function new()
	{
		super();

		var targets:Array<String>;
		
		if (commandArgs.length == 0) targets = ['all'];
		else targets = commandArgs;
		
		// replace 'all' with all available targets
		if (targets.indexOf('all') != -1) {
			targets[targets.indexOf('all')] = 'neko';
			targets = targets.concat(['hl','js','cpp']);
		}
		
		// remove double targets
		targets = removeDoubles(targets);
				
		switch (command) {
			
			case "h"|"help": 
				Log.info("\nunit tests:");
				Log.info(" 'hxp test <targets>'\n");
				
				Log.info("performance benchmark:");
				Log.info(" 'hxp bench <targets>' or 'hxp benchmark <targets>'\n");
			
				Log.info("<targets> can be one or combination of: 'neko hl js cpp'");
				Log.info(" or simple leave it empty for 'all' targets\n");
				
			case "test":
				test(targets);
				
			case "bench" | "benchmark":
				benchmark(targets);
			
			default:
				Log.error("Expected \"hxp <test|(bench|benchmark)> <all|neko|hl|js|cpp>\"");
		}
		
	}


	private function test (targets:Array<String>) {
		
		Log.info("unit tests for targets: " + targets.join(", ") + "\n");
		
		var base = new HXML ({
			cp: [ "src", "unit-tests" ],
			#if (haxe_ver >= "4.0.0")
			libs: [ "hx3compat" ],
			#end
			main: "Test",
			debug: false
		});
		
		for (target in targets) {
			Log.info("build " + target + " target...");
			build(target, base);
		}
			
		for (target in targets) {
			Log.info("\n------------ "+target.toUpperCase()+" ---------------------");
			run(target, base);
		}
	}

	
	private function benchmark (targets:Array<String>) {
		
		Log.info("perform benchmark tests for targets: " + targets.join(", ") + "\n");
		
		var base = new HXML ({
			cp: [ "src", "benchmarks" ],
			debug: false
		});
		
		for (target in targets)
		{
			base.main = "Fibonacci";
			Log.info("build " + target + " target...");
			
			build(target, base);
		}
		
		for (target in targets)
		{
			base.main = "Fibonacci";
			Log.info("\n------------ run "+target.toUpperCase()+" -------------------");
			
			var time = Timer.stamp();
			
			run(target, base);
			
			Log.info('Fibonacci(10000):\t' + Std.int(Timer.stamp() - time*1000) + "\tms");
		}
		
	}

	
	private function build (target:String, base:HXML) {

		switch (target) {
			
			case "neko":
				var neko = base.clone();
				neko.neko = 'bin/neko/${base.main.toLowerCase()}.n';
				neko.build();
			
			case "hl":
				var hl = base.clone();
				hl.hl = 'bin/hl/${base.main.toLowerCase()}.hl';
				hl.build();				
			
			case "node"|"js":
				var node = base.clone();
				node.js = 'bin/node/${base.main.toLowerCase()}.js';
				node.build();
			
			case "cpp":
				var cpp = base.clone();
				cpp.cpp = "bin/cpp";
				cpp.build();
			
			default: Log.error ("Unknown target \"" + target + "\"");
			
		}
		
	}

	private function run (target:String, base:HXML) {

		switch (target) {
			
			case "neko":
				System.runCommand ("bin/neko", "neko", [ '${base.main.toLowerCase()}.n' ]);
			
			case "hl":
				var hlPath = Sys.getEnv ("HLPATH");
				
				// using hl from lime ;) ... TODO!
				if (hlPath == null) {
					hlPath = Path.combine (Sys.getEnv ("HAXEPATH"), "lib/lime/7,7,0/templates/bin/hl/windows/");
				}
				
				System.runCommand ("bin/hl", Path.combine (hlPath, "hl"), [ '${base.main.toLowerCase()}.hl' ]);
			
			case "node"|"js":
				System.runCommand ("bin/node", "node", [ '${base.main.toLowerCase()}.js' ]);
			
			case "cpp":
				if (System.hostPlatform == WINDOWS) {
					System.runCommand ("bin/cpp",  '${base.main}-debug.exe', []);
				}
				else System.runCommand ("bin/cpp",  './${base.main}-debug', []);
			
			default: Log.error ("Unknown target \"" + target + "\"");
			
		}
		
	}

	
	private function removeDoubles(a:Array<String>)
	{
		var i = a.length;
		var j:Int;
		while (i-- > 0) {
			j = 0;
			while (j < i)
				if (a[j++] == a[i]) {
					a.splice(i,1);
					break;
				}
		}
		return a;
	}
	
}