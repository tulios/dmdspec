module matchers;

import dmdspec;
import std.exception;
import std.stdio;
import std.traits;

class BeEqualTo( T )
{
	private T valueToTestForEquality = T.init;

	this( T valueToTestForEquality )
	{
		this.valueToTestForEquality = valueToTestForEquality;
	}
	
	bool evaluateWithSubject( N )( Subject!( N ) s )
	{
		return s.object == valueToTestForEquality;
	}
}

class ThrowAnException
{
	private Exception exceptionToMatch;
	
	this( Exception exceptionToMatch )
	{
		this.exceptionToMatch = exceptionToMatch;
	}
	
	bool evaluateWithSubject( N )( Subject!( N ) s )
	{
		static if( isCallable!( N ) )
			Exception ex = collectException( s.object() );
		else
			Exception ex = collectException( s.object );
		
		return ( ex !is null ) && ( typeid( ex ) == typeid( this.exceptionToMatch ) );
	}
}

auto beTrue()
{
	return new BeEqualTo!( bool )( true );
}

auto beFalse()
{
	return new BeEqualTo!( bool )( false );
}

auto beNull()
{
	return new BeEqualTo!( typeof( null ) )( null );
}

auto beEqualTo( T )( T value )
{
	return new BeEqualTo!( T )( value );
}

auto throwAnException( string exceptionTypeName )
{
	auto ex = cast( Exception ) Object.factory( exceptionTypeName );
	if( ex is null )
		throw new Exception( "Invalid exceptionTypeName" );

	return new ThrowAnException( ex );
}

