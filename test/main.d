import std.stdio;
import dmdspec;
import std.exception;

void main() {
	describe("Integer numbers", {
		describe("number 1", {
			it("should be equal to 1", {
				subject(1).should(beEqual(1));
			});
			it("should not be equal to 2", {
				subject(1).should(beEqual(2));
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
