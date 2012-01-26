module dmdspec;

import std.stdio;
import std.variant;

public import exceptions;
public import matchers;

Subject subject(T)(T obj) {	
	Variant object = obj;
	string type = typeid(obj).toString();
	
	switch(type) {
		case "int": return new IntSubject(object);
		// String
		case "immutable(char)[]": return new StringSubject(object);
		default: throw new SubjectNotSupportedException(type ~ " is not supported yet!");
	}
	return null;
}

class GenSubject( T )
{
	T subject;
	
	this()
	{
		subject = T.init;
	}
	
	this( T init )
	{
		subject = init;
	}
	
	void print()
	{
		writeln( typeid( subject ).toString() );
	}
}

GenSubject!( T ) subjectFactory( T )( T value )
{
	return new GenSubject!( T )( value );
}


interface Subject {
	bool should(bool condition);
	bool should(int condition);
	bool should(string condition);
}

mixin template RespondToShould(T) {
	bool should(T condition) {
		return false;
	}
}

class IntSubject : Subject {
	mixin RespondToShould!string;
	int subject;
	
	this(Variant obj) {
		this.subject = obj.get!(int);
	}
		
	override bool should(bool condition) {
		return this.subject == condition;
	}
	
	bool should(int condition) {
		return this.subject == condition;
	}	
}

class StringSubject : Subject {
	mixin RespondToShould!int;	
	string subject;
	
	this(Variant obj) {
		this.subject = obj.get!(string);;
	}
	
	override bool should(bool condition) {
		return (this.subject != null) == condition;
	}
	
	bool should(string condition) {
		return this.subject == condition;
	}	
}
