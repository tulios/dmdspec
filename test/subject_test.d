import dmdspec;

unittest {	
	assert(
		subject(1).classinfo.toString() == "dmdspec.Subject", 
		"method subject should instantiate an object of type Subject when receive value 1"
	);
	assert(
		subject("string").classinfo.toString() == "dmdspec.Subject", 
		"method subject should instantiate an object of type Subject when receive value 'string'"
	);
	assert(
		(cast(IntSubject)subject(1)).classinfo.toString() == "dmdspec.IntSubject", 
		"method subject should instantiate an IntSubject when receive value 1"
	);
	assert(
		(cast(StringSubject)subject("string")).classinfo.toString() == "dmdspec.StringSubject", 
		"method subject should instantiate a StringSubject when receive value 'string'"
	);
	try {
		subject(null); 
		assert(false, "method subject should raise SubjectNotSupportedException if a type that it does not handle is passed as an argument");
	} catch (SubjectNotSupportedException e) {
		assert(true);
	}
}
