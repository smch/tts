aws polly synthesize-speech \
  --output-format json \
  --voice-id "Brian" \
  --text "`cat test.txt`" \
  --speech-mark-types='["word", "sentence"]' \
 test.json

 aws polly synthesize-speech \
   --output-format mp3 \
   --voice-id "Brian" \
   --text "`cat test.txt`" \
  test.mp3
