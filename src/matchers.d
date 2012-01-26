module matchers;

auto be_equal(T)(T obj) {
	return obj;
}

bool be_true() {
	return true;
}

bool be_false() {
	return false;
}