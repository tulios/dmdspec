import dmdspec;

unittest {
	assert(subject(1).should(beEqual(1)), "subject 1 should be equal to 1");
	assert(!subject(1).should(beEqual(2)), "subject 1 should not be equal to 2");
}
