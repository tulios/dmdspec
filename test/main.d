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
				subject(false).should(beTrue());
			});
		});
		describe("using beFalse", {
			it("should be false when is false", {
				subject(false).should(beFalse());
			});
			it("should not be false when is true", {
				subject(true).should(beFalse());
			});
		});
		describe("using beEqual", {
			describe("with numbers", {
				it("should be equal to when is the same number", {
					subject(1).should(beEqual(1));
				});
				it("should not be equal when is a different number", {
					subject(1).should(beEqual(2));
				});
			});
			
			describe("with strings", {
				it("should be equal to when is the same number", {
					subject("string").should(beEqual("string"));
				});
				it("should not be equal when is a different number", {
					subject("string").should(beEqual("another string"));
				});
			});
		});
		
		describe("divided by 0", {
			it("should throw an DividedByZeroException", {
				
				subject( { div( 1, 0 ); } ).shouldThrowException!DividedByZeroException;
				
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

double div( double x, double y ) {
	throw new DividedByZeroException();
}
