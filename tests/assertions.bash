#!/usr/bin/env bash

log()
{
    echo "$*" >&2
}

fail()
{
    log "$*"
    return 1
}

assert_equals()
{
    expected=$1
    given=$2
    given_message=$3
    default_message="Expected strings to be equal."
    message="${given_message:=$default_message}"

    if [ -n "$output" ]
    then
        log "Output  : $output"
    fi

    if [ "$given" != "$expected" ]
    then
        log "Expected: $1"
        log "Result  : $2"
        fail "$message"
    fi
}

assert_not_equals()
{
    expected=$1
    given=$2
    given_message=$3
    default_message="Expected strings to be different."
    message=${given_message:=$default_message}

    if [ ! -z "$output" ]
    then
        log "Output: $output"
    fi

    if [ "$given" = "$expected" ]
    then
        log "Result: $2"
        fail "$message"
    fi
}

assert_failure()
{
    assert_not_equals 0 "$status" "Command should fail execution."
}

assert_success()
{
    assert_equals 0 "$status" "Command should have successfull execution."
}
