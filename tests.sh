#!/bin/bash

echo ""
echo "Compiling..."
dmd -unittest src/dmdspec.d src/exceptions.d src/matchers.d test/subject_test.d test/int_test.d test/string_test.d test/main.d

echo ""
echo "Running... "
./dmdspec
