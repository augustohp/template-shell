#!/usr/bin/env bats
#
# Ensures some "default" behavior is present on the template
# so it can be considered a "good citzen" in the shell land.

CWD=$(pwd)
PATH=$CWD:$PATH

load assertions

@test "Running without arguments" {
    run template.sh

    assert_failure
    assert_equals "Missing required parameter: param" "$output"
}

@test "Help is displayed with '-h'" {
    run template.sh -h

    assert_failure
    assert_equals "Usage: template.sh [-h] [-v] [-f] -p param_value arg1 [arg2...]" "${lines[0]}"
}

@test "Help is displayed with '--help'" {
    run template.sh --help

    assert_failure
    assert_equals "Usage: template.sh [-h] [-v] [-f] -p param_value arg1 [arg2...]" "${lines[0]}"
}

@test "Stack trace is displayed with '-v'" {
    run template.sh -v

    assert_failure
    assert_equals "+ shift" "${lines[0]}"
}
