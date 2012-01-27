#!/bin/bash

echo ""
echo "Compiling..."
dmd -unittest src/dmdspec.d src/dsl.d src/matchers.d test/null_test.d test/bool_test.d test/dsl_test.d test/int_test.d test/string_test.d test/main.d

echo ""
echo "Running... "
./dmdspec
