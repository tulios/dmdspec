import dmdspec;

unittest {
	assert(subject(null).should(beEqual(null)), "subject null should be equal to null");
	assert(subject(null).should(beNull()), "subject null should be null");
}
