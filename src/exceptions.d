module exceptions;

class SubjectNotSupportedException : Exception {
	this(string s) {
		super(s); 
	}
}