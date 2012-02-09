module matchers;

// Lib
import dmdspec;

// D
import std.conv;
import std.exception;
import std.format;
import std.range;
import std.traits;

interface Matcher
{
	@property string expectation();
	@property string got();
	
	// We cannot override template methods
	// (see http://www.digitalmars.com/pnews/read.php?server=news.digitalmars.com&group=digitalmars.D.learn&artnum=32033 for an explanation)
	// We also can't get Subject!(N) in the matcher constructor, because we would screw the sintax up
	// A solution would be to force a 'setSubject( N )( Subject!( N ) s )' by convention, not by interface (since, as I said before, 
	// we cannot override template methods). But, if we did it, we were just going to add another method to the interface which is not
	// necessary.
	// So, the aproach chosen is to force bool evaluateWithSubject( N )( Subject!( N ) s ) by convention
	// The code will not compile if the user creates a Matcher without this method, since class Subject demands it
	//bool evaluateWithSubject( N )( Subject!( N ) s )
}

class BeEqualTo( T ) : Matcher
{
	private T subjectValue = T.init;
	private T valueToTestForEquality = T.init;

	this( T valueToTestForEquality )
	{
		this.valueToTestForEquality = valueToTestForEquality;
	}
	
	bool evaluateWithSubject( N )( Subject!( N ) s )
	{
		subjectValue = s.object;
		return subjectValue == valueToTestForEquality;
	}
	
	@property string expectation()
	{
		static if( is( T == typeof( null )))
		{
			return "null";
		}
		else
		{
			auto writer = appender!string();
			formattedWrite( writer, "%s", valueToTestForEquality );
			return writer.data;
		}
	}
	
	@property string got()
	{
		static if( is( T == typeof( null )))
		{
			return "null";
		}
		else
		{
			auto writer = appender!string();
			formattedWrite( writer, "%s", subjectValue );
			return writer.data;
		}
	}
}

class ThrowAnException : Matcher
{
	private string subjectExceptionName;
	private Exception exceptionToMatch;
	
	this( string exceptionTypeName )
	{
		auto ex = cast( Exception ) Object.factory( exceptionTypeName );
		if( ex is null )
			throw new Exception( "Invalid exception type name '" ~ exceptionTypeName ~ "'" );
		
		this.exceptionToMatch = ex;
	}
	
	bool evaluateWithSubject( N )( Subject!( N ) s )
	{
		static if( isCallable!( N ) )
			Exception ex = collectException( s.object() );
		else
			Exception ex = collectException( s.object );
			
		if( ex !is null )
		{
			subjectExceptionName = ex.classinfo.name;
			return typeid( ex ) == typeid( this.exceptionToMatch );
		}
		
		subjectExceptionName = "null";
		return false;
	}
	
	@property string expectation()
	{
		return exceptionToMatch.classinfo.name;
	}
	
	@property string got()
	{
		return subjectExceptionName;
	}
}

abstract class Have : Matcher
{
	public:
		bool evaluateWithSubject( N )( Subject!( N ) s )
		{
			subjectLength = s.object.length;
			return haveTest();
		}
		
		@property string expectation()
		{
			auto haveQualifier = expectationHaveQualifier;
			if( haveQualifier.length )
				haveQualifier ~= " ";
				
			auto sugarMethod = lastSugarMethodCalled;
			if( sugarMethod.length )
				sugarMethod = " " ~ sugarMethod;
		
			auto writer = appender!string();
			formattedWrite( writer, "have %s%s%s", haveQualifier, lengthToTest, sugarMethod );
			return writer.data;
		}

		@property string got()
		{
			return to!string( subjectLength );
		}

	protected:
		size_t lengthToTest;
		size_t subjectLength;
		
		string lastSugarMethodCalled;
		
		this( size_t lengthToTest )
		{
			this.lengthToTest = lengthToTest;
		}
		
		bool haveTest()
		{
			return false;
		}
		
		@property string expectationHaveQualifier()
		{
			return "";
		}
		
		// Provides have with syntatic sugar
		Have opDispatch( string m, Args... )( Args  args )
		{
			lastSugarMethodCalled = m;
			return this;
		}
}

class HaveExactly : Have
{
	public:
		this( size_t lengthToTest )
		{
			super( lengthToTest );
		}
		
	protected:
		override bool haveTest()
		{
			return subjectLength == lengthToTest;
		}
		
		override @property string expectationHaveQualifier()
		{
			return "exactly";
		}
}

class HaveAtLeast : Have
{
	public:
		this( size_t lengthToTest )
		{
			super( lengthToTest );
		}
		
	protected:
		override bool haveTest()
		{
			return subjectLength >= lengthToTest;
		}
		
		override @property string expectationHaveQualifier()
		{
			return "at least";
		}
}

class HaveAtMost : Have
{
	public:
		this( size_t lengthToTest )
		{
			super( lengthToTest );
		}
		
	protected:
		override bool haveTest()
		{
			return subjectLength <= lengthToTest;
		}
		
		override @property string expectationHaveQualifier()
		{
			return "at most";
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
	return new ThrowAnException( exceptionTypeName );
}

auto haveExactly( size_t lengthToTest )
{
	return new HaveExactly( lengthToTest );
}

auto haveAtLeast( size_t lengthToTest )
{
	return new HaveAtLeast( lengthToTest );
}

auto haveAtMost( size_t lengthToTest )
{
	return new HaveAtMost( lengthToTest );
}

