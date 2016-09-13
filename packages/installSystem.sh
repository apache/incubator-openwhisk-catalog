#!/bin/bash
#
# use the command line interface to install standard actions deployed
# automatically.
#
: ${WHISK_SYSTEM_AUTH:?"WHISK_SYSTEM_AUTH must be set and non-empty"}
AUTH_KEY=$WHISK_SYSTEM_AUTH

SCRIPTDIR="$(cd $(dirname "$0")/ && pwd)"
PACKAGE_HOME=$SCRIPTDIR
source "$PACKAGE_HOME/util.sh"

echo Installing whisk.system entities.

createPackage system -a description "Low-level OpenWhisk utilities"
createPackage utils -a description "Building blocks that format and assemble data"
createPackage samples -a description "A suite of simple actions to help you get started with OpenWhisk"

waitForAll

install "$PACKAGE_HOME/system/pipe.js" \
     system/pipe \
     -a system true

install "$PACKAGE_HOME/utils/echo.js" \
    utils/echo \
    -a description 'Returns the input' -a parameters '[{"name": "payload", "required":false, "description": "Any JSON entity"}]' \
    -a sampleInput '{ "payload": "Five fuzzy felines"}' \
    -a sampleOutput '{ "payload": "Five fuzzy felines"}'

install "$PACKAGE_HOME/utils/cat.js" \
     utils/cat \
     -a description 'Concatenates input into a string' \
     -a parameters '[ { "name": "lines", "required": true, "type": "array", "description": "An array of strings or numbers" } ]' \
     -a sampleInput '{ "lines": [4, 2, 3] }' \
     -a sampleOutput '{ "lines": [4, 2, 3] }'

install "$PACKAGE_HOME/utils/split.js" \
     utils/split \
     -a description 'Split a string into an array' \
     -a parameters '[{"name": "payload", "required":true, "description":"A string"}, { "name": "separator", "required": false, "description": "The character, or the regular expression, to use for splitting the string" }]' \
     -a sampleInput '{ "payload": "one,two,three", "separator": "," }' \
     -a sampleOutput '{ "lines": ["one", "two", "three"], "payload": "one,two,three"}'

install "$PACKAGE_HOME/utils/sort.js" \
     utils/sort \
     -a description 'Sorts an array' \
     -a parameters '[ { "name": "lines", "required": true, "type": "array", "description": "An array of strings" } ]' \
     -a sampleInput '{ "lines": [4, 2, 3] }' \
     -a sampleOutput '{ "lines": [2, 3, 4], "length": 3 }'

install "$PACKAGE_HOME/utils/head.js" \
     utils/head \
     -a description 'Extract prefix of an array' \
     -a parameters '[ { "name": "lines", "required": true, "type": "array", "description": "An array of strings" }, { "name": "num", "required": false, "type": "integer", "description": "The length of the prefix" }]' \
     -a sampleInput '{ "lines": [4, 2, 3], "num": 2 }' \
     -a sampleOutput '{ "lines": [4, 2], "num": 2 }'

install "$PACKAGE_HOME/utils/date.js" \
     utils/date \
     -a description 'Current date and time' \
     -a sampleOutput '{ "date": "2016-03-22T00:59:55.961Z" }'

install "$PACKAGE_HOME/samples/hello/javascript/hello.js" \
     samples/helloWorld \
     -a description 'Demonstrates logging facilities' -a parameters '[{"name": "payload", "required":false, "description":"The string to be included in the log record"}]' \
     -a sampleInput '{ "payload": "Cat" }' \
     -a sampleOutput '{ }' \
     -a sampleLogOutput '2016-03-22T01:02:26.387624916Z stdout: hello Cat!'

install "$PACKAGE_HOME/samples/greeting/javascript/greeting.js" \
     samples/greeting \
     -a description 'Returns a friendly greeting' \
     -a parameters '[{"name": "name", "required":false}, {"name": "place", "required":false, "description":"The string to be included in the return value"}]' \
     -a sampleInput '{ "payload": "Cat", "place": "Narrowsburg" }' \
     -a sampleOutput '{ "payload": "Hello, Cat from Narrowsburg!" }' \
     -a sampleLogOutput "2016-03-22T01:07:08.384982272Z stdout: params: { place: 'Narrowsburg', payload: 'Cat' }"

install "$PACKAGE_HOME/samples/wordcount/javascript/wordcount.js" \
     samples/wordCount \
     -a description 'Count words in a string' -a parameters '[{"name": "payload", "required":true, "description":"A string"}]' \
     -a sampleInput '{ "payload": "Five fuzzy felines"}' \
     -a sampleOutput '{ "count": 3 }' \
     -a sampleLogOutput "2016-03-22T01:10:07.361649586Z stdout: The message 'Five fuzzy felines' has 3 words"

install "$PACKAGE_HOME/samples/curl/javascript/curl.js" \
     samples/curl \
     -a description 'Curl a host url' -a parameters '[{"name": "payload", "required":true, "description":"A host url"}]' \
	 -a sampleInput '{ "payload": "google.com"}' \
     -a sampleOutput '{ "msg": "content returned from google.com" }'

#needed temporarily until all existing actions that reference echo are updated to reflect the new location for echo
install "$PACKAGE_HOME/utils/echo.js" \
    samples/echo \
    -a description 'Returns the input' -a parameters '[{"name": "payload", "required":false, "description": "Any JSON entity"}]' \
    -a sampleInput '{ "payload": "Five fuzzy felines"}' \
    -a sampleOutput '{ "payload": "Five fuzzy felines"}'

waitForAll

echo whisk.system entities ERRORS = $ERRORS
exit $ERRORS
