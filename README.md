TODO: fix it!

compile: 
	chmod +x compile.sh 
	./compile.sh 
 
Run the tests: 
	chmod +x tests.sh 
	./tests.sh 
 
subject(1).should(be_true());  
subject(1).should(be_false()); 
subject(1).should(be_equal(1)); 
subject(1).should(be_equal(2)); 
 
subject("string").should(be_equal("string")); 
subject("string").should(be_equal("another string")); 
