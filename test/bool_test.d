import dmdspec;

unittest {
	assert(subject(true).should(beTrue()), "subject true should be true");
	assert(subject(false).should(beFalse()), "subject false should be false");
}
