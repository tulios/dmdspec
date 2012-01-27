import std.stdio;
import dmdspec;

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
	});
	
}
