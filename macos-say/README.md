<div id="stage">

<div id="playback-controls">

Reading rate:

1×

</div>

<div id="text">

<div id="original-text">

</div>

</div>

<div id="word">

</div>

</div>

## Notes

First you generate the mp3 from the source file `test.txt` with MacOS
`say`.

The trouble is it has to read the entire file out loud in real time when
generating the word timestamps.

There are bugs with MacOS `Say`'s interactive mode where certain
punctuation throws off the word-highlighting. To get around this, I have
stripped out most non-alphanumeric characters, leaving only a few that
don't seem to cause problems. This means that the text above isn't the
same as the source text. You also lose line breaks.
