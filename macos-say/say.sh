#!/bin/zsh
#use macos `say` to convert speech to text with word timings
#`say` seems to have some bugs in interactive mode, where it highlights the word it is speaking
#you seem to get different errors depending on the terminal size
#various puncutation seems to throw it off highlighting the correct characters

#whenever there is punctuation on its own, it will break it

#adapted from https://stackoverflow.com/questions/33768852/can-i-interact-with-the-output-of-the-osx-say-command-in-a-bash-script
#when it is highlighting the text, the control characters are: 
#$'\033'\[7mTHE WORD IS HERE$'\033'\(B$'\033'\[m


#the following sentence breaks the interactive mode of speak:
#Living — isn’t that precisely a will to be something different from what this nature is?
#==== issues: 
# dashes, colons, ’ those kind of apostrophes instead of ' those
# you can't [easily] rebuild the source file from this, because we're stripping it of stuff...


if ! [ -x "$(command -v say)" ]; then
  echo 'Error: say is not installed' >&2
  exit 1
fi
if ! [ -x "$(command -v ffmpeg)" ]; then
  echo 'Error: ffmpeg is not installed' >&2
  exit 1
fi


rm -f output.txt

zmodload zsh/datetime
sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/ /g' -e "s/’/'/g" -e "s/ *[-,;\!\?']/ /g" test.txt | tr -cd "[:alnum:]._- ?\!;,'" | say --interactive | {
    counter=0
    while IFS= read -r -d $'\r' line; do
        (( counter++ )) || continue  # first line in the output of `say --interactive` suppresses the cursor; discard this line
        timestamp=$EPOCHREALTIME
        (( counter == 2 )) && offset=$timestamp  # set the timestamp of the actual first line at the offset
        (( timestamp -= offset ))
        #printf '%05.2f %s\n' $timestamp "${${line%$'\e[m'*}#*$'\e[7m'}"
    
        #printf "%q" "${line}" #see the control characters that we need to split on

     first=${line%$'\033'\(B$'\033'\[m*}
     last=${first#*$'\033'\[7m}

     time=$(printf "%.0f\n" $(($timestamp * 1000)))
    echo "<span class='ts-word' id='ts${time}'>${last}</span>" | tee -a output.txt

     #line delimited json in amazon polly speech marks style, missing the byte start and end positions
     #echo -e "{\"time\":${time}, \"word\":\"${last}\"}" 
    done
}

#generate the audio file
sed -e "s/’/'/g"  test.txt | tr -cd "[:alnum:]._- ?!;,'" | say -o output.aac
#convert it to mp3, delete aac after
ffmpeg -i output.aac -acodec libmp3lame test.mp3 && rm output.aac

