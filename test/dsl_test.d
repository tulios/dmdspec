import dmdspec;

unittest {
	// Subject
	assert(
		subject(1).classinfo.toString() == "dmdspec.Subject!int.Subject",
		"method subject should instantiate an object of type Subject!int when receive an int value"
	);
	assert(
		subject("string").classinfo.toString() == "dmdspec.Subject!string.Subject",
		"method subject should instantiate an object of type Subject!string when receive a string value"
	);
	assert(
		subject(null).classinfo.toString() == "dmdspec.Subject!(typeof(null)).Subject",
		"method subject should instantiate an object of type Subject!(typeof(null)) when receive a null value"
	);
	
	// Describe
	
}
