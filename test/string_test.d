import dmdspec;

unittest {
	// Boolean matcher
	assert(subject("string").should(be_true()), "subject 'string' should be true/valid");
	assert(!subject("string").should(be_false()), "subject 'string' should be false/invalid");
	
	// Type Matcher
	assert(subject("string").should(be_equal("string")), "subject 'string' should be equal to 'string'");
	assert(!subject("string").should(be_equal("another string")), "subject 'string' should not be equal to 'another string'");
}
