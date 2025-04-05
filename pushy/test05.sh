#! /usr/bin/env dash

# ==============================================================================
# Test the pushy-commit where commit -a with no file changes.
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

# Create a file with a non-alphanumeric filename
echo "1" > a
echo "2" > b

# Stage changes 
pushy-add a b

# Normal Commit files 
pushy-commit -m "Committed a and b" > /dev/null 2>&1

# Create some files to hold output.
expected_output="$(mktemp)"
actual_output="$(mktemp)"

# Remove the temporary directory when the test is done.
trap 'rm -f "$expected_output" "$actual_output"; rm -rf "$test_dir"' INT HUP QUIT TERM EXIT

# Attempt to commit the file with no staged changes to a and b 
pushy-commit -a -m "Committed with no change to a and b" > "$actual_output" 2>&1

# Define the expected error message
echo "nothing to commit" > "$expected_output"

# Compare the expected and actual outputs
if diff "$expected_output" "$actual_output" > /dev/null; then
    echo "Test05 (pushy-commit commit -a no change): Passed"
else
    echo "Test05 (pushy-commit commit -a no change): Failed"
fi
