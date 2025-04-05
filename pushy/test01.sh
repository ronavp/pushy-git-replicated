#! /usr/bin/env dash

# ==============================================================================
# Test the pushy-add command with non-existent .pushy repository.
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

# Create some files to hold output.
expected_output="$(mktemp)"
actual_output="$(mktemp)"

# Remove the temporary directory when the test is done.
trap 'rm -f "$expected_output" "$actual_output"; rm -rf "$test_dir"' INT HUP QUIT TERM EXIT

# Create a file with a non-alphanumeric filename
file_1="a"
file_2="b"
touch "$file_1"
touch "$file_2"

# Attempt to add the file with the invalid filename to the repository staging area
pushy-add "$file_1" "file_2" > "$actual_output" 2>&1

# Define the expected error message
echo "pushy-add: error: pushy repository directory .pushy not found" > "$expected_output"

# Compare the expected and actual outputs
if diff "$expected_output" "$actual_output" > /dev/null; then
    echo "Test01 (pushy-add to non-existent .pushy): Passed"
else
    echo "Test01 (pushy-add to non-existent .pushy): Failed"
fi
