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
	try {
		intention();
	} catch (Exception e) {
	}
	Reporter.report(description);
}