module dmdspec;

import std.stdio;
import std.conv;
import std.array;
import std.traits;
import std.exception;
import std.variant;

import console;
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
	public:
		T object;

		this()
		{
			this.object = T.init; // default initializer
		}

		this( T object )
		{
			this.object = object;
		}

		bool should( M )( M matcher )
		{
			return testExpectation( matcher, true );
		}

		bool shouldNot( M )( M matcher )
		{
			return testExpectation( matcher, false );
		}
	
	private:	
		bool testExpectation( M )( M matcher, bool expectedMatcherRetValue )
		{
			if( matcher.evaluateWithSubject!( T )( this ) == expectedMatcherRetValue )
				return true;
			
			reportErrorForMatcher( matcher );
			return false;
		}
	
		void reportErrorForMatcher( Matcher matcher )
		{
			auto exception = new SpecFailureException( "" );
		    exception.expectation = matcher.expectation;
		    exception.got = matcher.got;
		    throw exception;
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
      writecfln(Color.RED, "%sexpectation: %s", defaultSpace, to!(string)(example.getExpectation()));
      writecfln(Color.RED, "%s        got: %s", defaultSpace, to!(string)(example.getGot()));
      foreach(string line ; example.getStack()) {
        writecfln(Color.CYAN, "%s# %s", defaultSpace, line);
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
      writef(createLevel());
      writecfln(Color.GREEN, example.getDescription());

    } else {
      example.setMessage(createContext(example.getDescription()));
      string number = to!(string)(failures.length + 1);

      writecfln(Color.RED, "%s%s - (#%s)", createLevel(), example.getDescription(), number);
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
}
