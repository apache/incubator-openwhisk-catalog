##!/bin/bash
#
# use the command line interface to install Watson package.
#
: ${WHISK_SYSTEM_AUTH:?"WHISK_SYSTEM_AUTH must be set and non-empty"}
AUTH_KEY=$WHISK_SYSTEM_AUTH

SCRIPTDIR="$(cd $(dirname "$0")/ && pwd)"
PACKAGE_HOME=$SCRIPTDIR
source "$PACKAGE_HOME/util.sh"

echo Installing Watson packages.

createPackage watson-NLU \
    -a description "Actions for the Watson Natural Language Understanding service" \
    -a parameters '[ {"name":"bluemixServiceName", "required":false, "bindTime":true}, {"name":"username", "required":false}, {"name":"password", "required":false, "type":"password"} ]' \
	  -a tags '["watson"]' \
	  -p bluemixServiceName 'natural_language_understanding'

createPackage watson-translator \
    -a description "Actions for the Watson Natural Language Translator service" \
    -a parameters '[ {"name":"bluemixServiceName", "required":false, "bindTime":true}, {"name":"username", "required":false}, {"name":"password", "required":false, "type":"password"} ]' \
	  -a tags '["watson"]' \
	  -p bluemixServiceName 'language_translator'

createPackage watson-speechToText \
    -a description "Actions for the Watson Speech to Text service" \
    -a parameters '[ {"name":"bluemixServiceName", "required":false, "bindTime":true}, {"name":"username", "required":false}, {"name":"password", "required":false, "type":"password"} ]' \
	  -a tags '["watson"]' \
	  -p bluemixServiceName 'speech_to_text'

createPackage watson-textToSpeech \
    -a description "Actions for the Watson Text to Speech service" \
    -a parameters '[ {"name":"bluemixServiceName", "required":false, "bindTime":true}, {"name":"username", "required":false}, {"name":"password", "required":false, "type":"password"} ]' \
	  -a tags '["watson"]' \
	  -p bluemixServiceName 'text_to_speech'

waitForAll

install "$PACKAGE_HOME/watson-speechToText/speechToText.js" \
    watson-speechToText/speechToText \
    -a description 'Convert speech to text' \
    -a parameters '[
  {
    "name": "content_type",
    "required": true,
    "description": "The MIME type of the audio"
  },
  {
    "name": "model",
    "required": false,
    "description": "The identifier of the model to be used for the recognition request"
  },
  {
    "name": "continuous",
    "required": false,
    "description": "Indicates whether multiple final results that represent consecutive phrases separated by long pauses are returned"
  },
  {
    "name": "inactivity_timeout",
    "required": false,
    "description": "The time in seconds after which, if only silence (no speech) is detected in submitted audio, the connection is closed"
  },
  {
    "name": "interim_results",
    "required": false,
    "description": "Indicates whether the service is to return interim results"
  },
  {
    "name": "keywords",
    "required": false,
    "description": "A list of keywords to spot in the audio"
  },
  {
    "name": "keywords_threshold",
    "required": false,
    "description": "A confidence value that is the lower bound for spotting a keyword"
  },
  {
    "name": "max_alternatives",
    "required": false,
    "description": "The maximum number of alternative transcripts to be returned"
  },
  {
    "name": "word_alternatives_threshold",
    "required": false,
    "description": "A confidence value that is the lower bound for identifying a hypothesis as a possible word alternative"
  },
  {
    "name": "word_confidence",
    "required": false,
    "description": "Indicates whether a confidence measure in the range of 0 to 1 is to be returned for each word"
  },
  {
    "name": "timestamps",
    "required": false,
    "description": "Indicates whether time alignment is returned for each word"
  },
  {
    "name": "X-Watson-Learning-Opt-Out",
    "required": false,
    "description": "Indicates whether to opt out of data collection for the call"
  },
  {
    "name": "watson-token",
    "required": false,
    "description": "Provides an authentication token for the service as an alternative to providing service credentials"
  },
  {
    "name": "encoding",
    "required": true,
    "description": "The encoding of the speech binary data"
  },
  {
    "name": "payload",
    "required": true,
    "description": "The encoding of the speech binary data"
  },
  {
    "name": "username",
    "required": true,
    "bindTime": true,
    "description": "The Watson service username"
  },
  {
    "name": "password",
    "required": true,
    "type": "password",
    "bindTime": true,
    "description": "The Watson service password"
  }
]' \
    -a sampleInput '{"payload":"<base64 encoding of a wav file>", "encoding":"base64", "content_type":"audio/wav", "username":"XXX", "password":"XXX"}' \
    -a sampleOutput '{"data":"Hello."}'

install "$PACKAGE_HOME/watson-translator/translator.js" \
    watson-translator/translator \
    -a description 'Translate text' \
    -a parameters '[ {"name":"translateFrom", "required":false}, {"name":"translateTo", "required":false}, {"name":"payload", "required":false}, {"name":"username", "required":true, "bindTime":true}, {"name":"password", "required":true, "type":"password", "bindTime":true} ]' \
    -a sampleInput '{"translateFrom":"en", "translateTo":"fr", "payload":"Hello", "username":"XXX", "password":"XXX"}' \
    -a sampleOutput '{"payload":"Bonjour"}'

install "$PACKAGE_HOME/watson-translator/languageId.js" \
    watson-translator/languageId \
    -a description 'Identify language' \
    -a parameters '[ {"name":"username", "required":true, "bindTime":true}, {"name":"password", "required":true, "type":"password", "bindTime":true}, {"name":"payload", "required":true} ]' \
    -a sampleInput '{"payload": "Bonjour", "username":"XXX", "password":"XXX"}' \
    -a sampleOutput '{"language": "French", "confidence": 1}'

install "$PACKAGE_HOME/watson-textToSpeech/textToSpeech.js" \
    watson-textToSpeech/textToSpeech \
    -a description 'Synthesize text to spoken audio' \
    -a parameters '[ {"name":"username", "required":true, "bindTime":true, "description":"The Watson service username"}, {"name":"password", "required":true, "type":"password", "bindTime":true, "description":"The Watson service password"}, {"name":"payload", "required":true, "description":"The text to be synthesized"}, {"name":"voice", "required":false, "description":"The voice to be used for synthesis"}, {"name":"accept", "required":false, "description":"The requested MIME type of the audio"}, {"name":"encoding", "required":false, "description":"The encoding of the speech binary data"}]' \
    -a sampleInput '{"payload":"Hello, world.", "encoding":"base64", "accept":"audio/wav", "voice":"en-US_MichaelVoice", "username":"XXX", "password":"XXX" }' \
    -a sampleOutput '{"payload":"<base64 encoding of a .wav file>", "encoding":"base64", "mimetype":"audio/wav"}'

install "$PACKAGE_HOME/watson-natural-language-understanding/analyze.js" \
    watson-NLU/analyze \
    --main analyze \
    -a description 'Perform natural language understanding analysis' \
    -a parameters '[ {"name":"username", "required":true, "bindTime":true, "description":"The Watson service username"}, {"name":"password", "required":true, "type":"password", "bindTime":true, "description":"The Watson service password"}, {"name":"text", "required":true, "description":"The text to analyze"}, {"name":"features", "required":true, "description":"features as expected by the NLU service /analyze API"} ]' \
    -a sampleInput '{"text":"Leonardo DiCaprio won Best Actor in a Leading Role for his performance", "features":{ "concepts": {}, "keywords": {}}, "username":"XXX", "password":"XXX" }' \
    -a sampleOutput '{"response":{"entities":[{"type":"Person","text":"Leonardo DiCaprio","relevance":0.33,"disambiguation":{"subtype":["Actor","AwardNominee","AwardWinner","Celebrity","FilmActor","FilmProducer","TVActor","TVProducer"],"name":"Leonardo DiCaprio","dbpedia_resource":"http://dbpedia.org/resource/Leonardo_DiCaprio"},"count":1}],"language":"en"}}'

install "$PACKAGE_HOME/watson-natural-language-understanding/analyze.js" \
    watson-NLU/analyzeOneFeature \
    --main analyzeOneFeature \
    -a description 'Perform natural language understanding analysis for one feature only' \
    -a parameters '[ {"name":"username", "required":true, "bindTime":true, "description":"The Watson service username"}, {"name":"password", "required":true, "type":"password", "bindTime":true, "description":"The Watson service password"}, {"name":"text", "required":true, "description":"The text to analyze"}, {"name":"limit", "required":true, "description":"the limit on the number of results to return"}, {"name":"feature", "required":false, "description":"the single NLU feature to analyze for"}  ]' \
    -a sampleInput '{"text":"Leonardo DiCaprio won Best Actor in a Leading Role for his performance", "feature":"entities", "username":"XXX", "password":"XXX" }' \
    -a sampleOutput '{"response":{"entities":[{"type":"Person","text":"Leonardo DiCaprio","relevance":0.33,"disambiguation":{"subtype":["Actor","AwardNominee","AwardWinner","Celebrity","FilmActor","FilmProducer","TVActor","TVProducer"],"name":"Leonardo DiCaprio","dbpedia_resource":"http://dbpedia.org/resource/Leonardo_DiCaprio"},"count":1}],"language":"en"}}'

waitForAll

echo Watson package ERRORS = $ERRORS
exit $ERRORS
