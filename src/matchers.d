module matchers;

bool beTrue() {
	return true;
}

bool beFalse() {
	return false;
}

auto beNull() {
	return beEqual(null);
}

auto beEqual(T)(T obj) {
	return obj;
}

/*throwException(T)(T ex) {

}*/

