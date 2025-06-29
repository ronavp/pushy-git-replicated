#! /usr/bin/env dash

# ==============================================================================
# Test the pushy-commit invalid input of arguments (no -m).
#
# Written by: Ronav Pillay
# Date: 24/03/2024
# For COMP2041/9044 Assignment 1
# ==============================================================================

# Setup
PATH="$PATH:$(pwd)" # Add the current directory to the PATH

# Create a temporary directory for the test.
test_dir="$(mktemp -d)"
cd "$test_dir" || exit 1

# Initialise a pushy repository
pushy-init > /dev/null 2>&1

# Intialise files
file_1="a"
echo "hello" > "$file_1"

# Create some files to hold output.
expected_output="$(mktemp)"
actual_output="$(mktemp)"

pushy-add a > /dev/null 2>&1

# Remove the temporary directory when the test is done.
trap 'rm -f "$expected_output" "$actual_output"; rm -rf "$test_dir"' INT HUP QUIT TERM EXIT

# Attempt to add the file with the invalid filename to the repository staging area
pushy-commit "hello" > "$actual_output" 2>&1

# Define the expected error message
echo "usage: pushy-commit [-a] -m commit-message" > "$expected_output"

# Compare the expected and actual outputs
if diff "$expected_output" "$actual_output" > /dev/null; then
    echo "Test09 (commit no -m): Passed"
else
    echo "Test09 (commit no -m): Failed"
fi
