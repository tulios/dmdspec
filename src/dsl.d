module dsl;

import std.stdio;
import std.conv;

import dmdspec;
import exampleResult;

Subject!(T) subject(T)(lazy T value) {
	return new Subject!(T)(value);
}

class BaseSpec {
	private string description;
	
	this(string description) {
		this.description = description;
	}
}

T spec(T)(string description) {
	return new T(description);
}

class Describe : BaseSpec {
	this(string description) {
		super(description);
	}

	Describe opAssign(void delegate() intention) {
		Reporter.report(description, intention);
		return this;
	}
}

alias spec!(Describe) describe;

class It : BaseSpec {
	this(string description) {
		super(description);
	}

	It opAssign(void delegate() intention) {
 		ExampleResult example = new ExampleResult(description);
	
		try {	
			intention();
			example.setStatus(ExampleResult.STATUS.SUCCESS);
		
		} catch (SpecFailureException e) {
			example.setStatus(ExampleResult.STATUS.FAIL);
			example.setExpectation(e.expectation);
			example.setGot(e.got);
			example.pushToStack(to!(string)(e.file) ~ ":" ~ to!(string)(e.line));
		}
	
		Reporter.report(example);
		return this;
	}
}

alias spec!(It) it;

