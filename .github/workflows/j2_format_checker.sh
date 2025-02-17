#!/bin/bash
PATH=$1

# Filter out indention errors that are prevalent throughout repository
j2lint $PATH --extensions json --json | jq '.ERRORS |= map(select(.severity == "HIGH" and (.message | contains("Bad Indentation") | not)))' > output.json

# See ERRORS and WARNINGS
cat j2_format_check_output.json

# Check high severity count. We only fail on high severity counts that are not idention issues
high_severity_count=$(jq '.ERRORS | length' j2_format_check_output.json)
if [ "$high_severity_count" -gt 0 ]; then
echo "Found $high_severity_count high severity issues. Failing check. Please address the Jinja2 formatting issues with the above files"
exit 1
else
echo "No high severity issues found. Passing check :)"
exit 0
fi