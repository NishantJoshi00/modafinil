#!/usr/bin/env bats
#
# Smoke tests for modafinil. These exercise only the paths that never change
# system sleep state, so they are safe to run in CI without sudo.

setup() {
  MODAFINIL="${BATS_TEST_DIRNAME}/../modafinil"
}

@test "--version prints the program name and a version" {
  run "${MODAFINIL}" --version
  [ "${status}" -eq 0 ]
  [[ "${output}" =~ ^modafinil\ [0-9]+\.[0-9]+\.[0-9]+$ ]]
}

@test "-v is an alias for --version" {
  run "${MODAFINIL}" -v
  [ "${status}" -eq 0 ]
  [[ "${output}" =~ ^modafinil\ [0-9] ]]
}

@test "-h prints usage" {
  run "${MODAFINIL}" -h
  [ "${status}" -eq 0 ]
  [[ "${output}" == *"keep a Mac awake"* ]]
  [[ "${output}" == *"Usage:"* ]]
}

@test "completions zsh emits a compdef block" {
  run "${MODAFINIL}" completions zsh
  [ "${status}" -eq 0 ]
  [[ "${output}" == *"#compdef modafinil"* ]]
}

@test "unknown completion shell fails" {
  run "${MODAFINIL}" completions fish
  [ "${status}" -ne 0 ]
  [[ "${output}" == *"unsupported completion shell"* ]]
}

@test "unknown option fails with a message" {
  run "${MODAFINIL}" --bogus
  [ "${status}" -ne 0 ]
  [[ "${output}" == *"unknown option"* ]]
}

@test "-- with no command fails before changing anything" {
  run "${MODAFINIL}" --
  [ "${status}" -ne 0 ]
  [[ "${output}" == *"needs a command"* ]]
}

@test "-w rejects a non-numeric pid" {
  run "${MODAFINIL}" -w notapid
  [ "${status}" -ne 0 ]
  [[ "${output}" == *"numeric pid"* ]]
}

@test "-w with no value fails" {
  run "${MODAFINIL}" -w
  [ "${status}" -ne 0 ]
  [[ "${output}" == *"needs a value"* ]]
}
