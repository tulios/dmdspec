module exampleResult;

import std.variant;

class ExampleResult {
	enum STATUS {
		SUCCESS,
		FAIL
	}
		
	this(string description) {
		this.description = description;
	}
	
	string getDescription() {
		return this.description;
	}
	
	void setStatus(STATUS status) {
		this.status = status;
	}
	
	string getMessage() {
		return this.message;
	}
	
	void setMessage(string message) {
		this.message = message;
	}
	
	void pushToStack(string line) {
		this.stack ~= line;
	}
	
	string[] getStack() {
		return this.stack;
	}
	
	STATUS getStatus() {
		return this.status;
	}
	
	bool isSuccess() {
		return this.status == ExampleResult.STATUS.SUCCESS;
	}
	
	void setExpectation(Variant expectation) {
		this.expectation = expectation;
	}
	
	Variant getExpectation() {
		return this.expectation;
	}
	
	void setGot(Variant got) {
		this.got = got;
	}
	
	Variant getGot() {
		return this.got;
	}
	
	private:
		string description;
		string message;
		string[] stack;
		STATUS status;
		Variant expectation;
		Variant got;	
}
