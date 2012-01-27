module dmdspec;

import std.stdio;
import std.array;
import std.traits;

import std.exception;

public import matchers;
public import dsl;

class SpecFailureException : Exception {
	this(string message) {
		super(message);
	}
}

class Subject(T) {
	private T object;
	
	this() {
		this.object = T.init; // default initializer
	}
	
	this(T object) {
		this.object = object;
	}
	
	bool should(T condition) {
		bool result = this.object == condition;
		if (!result) {
			throw new SpecFailureException("");
		}
		return result;
	}
	
	@property bool shouldThrowException( E )() {
		static if( isCallable!( T ) )
			Exception ex = collectException( object() );
		else
			Exception ex = collectException( object );
			
		if ( ( ex is null ) || ( typeid( ex ) != typeid( E ) ) ) {
			throw new SpecFailureException("");
		}
		return true;
	}
	
	void writeType()
	{
		writeln( typeof( object ).stringof );
	}
}

class ExampleResult {
	string status;
	string prefix;
	string message;
}

class Reporter {
	static int level = 0;
	static int examplesIndex = 0;
	static ExampleResult[] failures;
		
	static this() {
	}
	
	static ~this() {
		auto failuresCount = failures.length;
		writefln(
			"\nFinished! %d examples, %d %s", 
			examplesIndex, 
			failuresCount,
			failuresCount > 1 ? "failures" : "failure"
		);
	}
			
	static void report(string description, ExampleResult example) {
		examplesIndex++;
		if (example.status == "success") {
			writefln("%s%s", createLevel(), green(description));
		} else {
			failures ~= example;
			writefln("%s%s", createLevel(), red(description));
		}
	}
	
	static void report(string description, void delegate() intention) {
		writefln("%s%s", createLevel(), description);
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
	
	private static string color(string text, string colorCode) {
		return colorCode ~ text ~ "\033[0m";
	}
	
	private static string green(string text) {
		return color(text, "\033[32m");
	}
	
	private static string red(string text) {
		return color(text, "\033[31m");
	}
}


















