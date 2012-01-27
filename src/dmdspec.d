module dmdspec;

import std.stdio;
import std.array;

public import matchers;
public import dsl;

class Subject(T) {
	private T object;
	
	this() {
		this.object = T.init; // default initializer
	}
	
	this(T object) {
		this.object = object;
	}
	
	bool should(T condition) {
		return this.object == condition;
	}
}

class Reporter {
	static int level = 0;
		
	static void report(string description) {
		writefln("%s%s", createLevel(), description);
	}
	
	static void report(string description, void delegate() intention) {
		report(description);
		level++;
		intention();
		level--;
	}
		
	private static string createLevel() {
		string[] str = [];
		auto app = appender(str);
		for (int x = 0; x < level; x++) {
			app.put("  ");
		}
		return join(app.data);
	}	
}


















