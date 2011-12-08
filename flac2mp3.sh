#!/bin/bash

for a in *.flac

do
OUTF=`echo "$a" | sed s/\.flac$/.mp3/g`

ARTIST=`metaflac "$a" --show-tag=ARTIST | sed s/.*=//g`
TITLE=`metaflac "$a" --show-tag=TITLE | sed s/.*=//g`
ALBUM=`metaflac "$a" --show-tag=ALBUM | sed s/.*=//g`
GENRE=`metaflac "$a" --show-tag=GENRE | sed s/.*=//g`
TRACKNUMBER=`metaflac "$a" --show-tag=TRACKNUMBER | sed s/.*=//g`
DATE=`metaflac "$a" --show-tag=DATE | sed s/.*=//g`

flac -c -d "$a" | lame -q 0 --preset insane - "$OUTF"
id3v2 -t "$TITLE" -T "${TRACKNUMBER:-0}" -a "$ARTIST" -A "$ALBUM" -y "$DATE" -2 -g "${GENRE:-12}" "$OUTF"

done
