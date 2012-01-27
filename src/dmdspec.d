module dmdspec;

import std.stdio;
import std.variant;

public import matchers;

Subject!(T) subject(T)(T value) {
	return new Subject!(T)(value);
}

class Subject(T) {
	private T object;
	
	this() {
		this.object = T.init;
	}
	
	this(T object) {
		this.object = object;
	}
	
	bool should(T condition) {
		return this.object == condition;
	}
}