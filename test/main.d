import std.stdio;
import dmdspec;
import std.exception;

void main() {
	describe("Matchers", {
		describe("using beTrue", {
			it("should be true when is true", {
				subject(true).should(beTrue());
			});
			it("should not be true when is false", {
				subject(false).shouldNot(beTrue());
			});
		});
		describe("using beFalse", {
			it("should be false when is false", {
				subject(false).should(beFalse());
			});
			it("should not be false when is true", {
				subject(true).shouldNot(beFalse());
			});
		});
		describe("using beEqual", {
			describe("with numbers", {
				it("should be equal to when is the same number", {
					subject(1).should(beEqualTo(1));
				});
				it("should not be equal when is a different number", {
					subject(1).shouldNot(beEqualTo(2));
				});
			});
			
			describe("with strings", {
				it("should be equal to when is the same number", {
					subject("string").should(beEqualTo("string"));
				});
				it("should not be equal when is a different number", {
					subject("string").shouldNot(beEqualTo("another string"));
				});
			});
		});
	});

	describe("Integer numbers", {
		describe("number 1", {
			it("should be equal to 1", {
				subject(1).should(beEqualTo(1));
			});
			it("should not be equal to 2", {
				subject(1).shouldNot(beEqualTo(2));
			});
		});
		describe("divided by 0", {
			it("should throw an DividedByZeroException", {
				subject( { div( 1, 0 ); } ).should( throwAnException( "main.DividedByZeroException" ) );
			});
		});
	});
}

class DividedByZeroException : Exception
{
	this(){
		super("Divided by zero exception");
	}
	this(string message){
		this();
	}
}

double div( double x, double y )
{
	throw new DividedByZeroException();
}
