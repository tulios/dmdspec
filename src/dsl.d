module dsl;

import std.stdio;
import dmdspec;

Subject!(T) subject(T)(T value) {
	return new Subject!(T)(value);
}

void describe(string description, void delegate() intention) {
	Reporter.report(description, intention);
}

void it(string description, void delegate() intention) {
	ExampleResult example = new ExampleResult();
	example.prefix = description;
	try {
		intention();
		example.status = "success";
	} catch (SpecFailureException e) {
		example.status = "fail";
		example.message = e.msg;
	}
	Reporter.report(description, example);
}