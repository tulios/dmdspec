module dmdspec;

import std.stdio;
import std.conv;
import std.array;
import std.traits;
import std.exception;
import std.Variant;

import exampleResult;
public import matchers;
public import dsl;

class SpecFailureException : Exception {
	Variant expectation;
	Variant got;
	
	this(string message) {
		super(message);
	}
}

class Subject( T )
{
	T object;
	
	this() {
		this.object = T.init; // default initializer
	}
	
	this(T object) {
		this.object = object;
	}
	
	bool should( M )( M matcher )
	{
		if( !matcher.evaluateWithSubject!( T )( this ) )
		{
			auto exception = new SpecFailureException("");
			exception.expectation = this.object;
			exception.got = condition;
			throw exception;
		}
		return true;
	}

	bool shouldNot( M )( M matcher )
	{
		if( matcher.evaluateWithSubject!( T )( this ) )
		{
			auto exception = new SpecFailureException("");
			exception.expectation = this.object;
			exception.got = condition;
			throw exception;
		}
		return true;
	}
	
	void writeObjectType()
	{
		writeln( typeof( object ).stringof );
	}
}

class Reporter {
	static int level = 0;
	static int examplesIndex = 0;
	static ExampleResult[] failures;
	static string[] describes;
		
	static this() {
		write("\n");
	}
	
	static ~this() {
		auto failuresCount = failures.length;
		
		writeln("\nFailures:");
		auto defaultSpace = "     ";
		foreach(int i, ExampleResult example ; failures) {
			writefln("\n  %d) %s", i + 1, example.getMessage());
			writefln(red("%sexpectation: %s"), defaultSpace, to!(string)(example.getExpectation()));
			writefln(red("%s        got: %s"), defaultSpace, to!(string)(example.getGot()));
			foreach(string line ; example.getStack()) {
				writefln(grey("%s# %s"), defaultSpace, line);
			}
		}
		
		writefln(
			"\nFinished! %d examples, %d %s", 
			examplesIndex, 
			failuresCount,
			failuresCount > 1 ? "failures" : "failure"
		);
	}
			
	static void report(ExampleResult example) {
		examplesIndex++;
		if (example.isSuccess()) {
			writefln("%s%s", createLevel(), green(example.getDescription()));
			
		} else {
			example.setMessage(createContext(example.getDescription()));
			string number = to!(string)(failures.length + 1);
			
			writefln(red("%s%s - (#%s)"), createLevel(), example.getDescription(), number);
			failures ~= example;
		}
	}
	
	static void report(string description, void delegate() intention) {
		describes ~= description;
		
		writefln("%s%s", createLevel(), description);
		level++;
		intention();
		level--;
	}
	
	private:
		static string createContext(string description) {
			string[] prefix;			
			for(int i = 0; i < level - 1; i++) {
				prefix ~= describes[i];
			}
			
			return join(appender(prefix).data, " ") ~ " " ~ description;
		}
		
		static string createLevel() {
			string[] str = [];
			auto app = appender(str);
			for (int x = 0; x < level; x++) {
				app.put("  ");
			}
			return join(app.data);
		}
		
		static string color(string text, string colorCode) {
			return colorCode ~ text ~ "\033[0m";
		}
	
		static string green(string text) {
			return color(text, "\033[32m");
		}
	
		static string red(string text) {
			return color(text, "\033[31m");
		}
	
		static string grey(string text) {
			return color(text, "\033[36m");
		}
}
