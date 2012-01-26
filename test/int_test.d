import dmdspec;

unittest {
	// Boolean matcher
	assert(subject(1).should(be_true()), "subject 1 should be true/valid");
	assert(!subject(1).should(be_false()), "subject 1 should be false/invalid");
	
	// Type Matcher
	assert(subject(1).should(be_equal(1)), "subject 1 should be equal to 1");
	assert(!subject(1).should(be_equal(2)), "subject 1 should not be equal to 2");
}
