module dsl;

import std.stdio;
import dmdspec;
import exampleResult;

Subject!(T) subject(T)(T value) {
	return new Subject!(T)(value);
}

void describe(string description, void delegate() intention) {
	Reporter.report(description, intention);
}

void it(string description, void delegate() intention) {
	ExampleResult example = new ExampleResult(description);
	
	try {	
		intention();
		example.setStatus(ExampleResult.STATUS.SUCCESS);
		
	} catch (SpecFailureException e) {
		example.setStatus(ExampleResult.STATUS.FAIL);
		example.setExpectation(e.expectation);
		example.setGot(e.got);
	}
	
	Reporter.report(example);
}