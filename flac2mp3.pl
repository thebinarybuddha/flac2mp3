#!/usr/bin/perl
use strict;
use warnings;

my $FILE = $ARGV[0];
my $ARTIST = `metaflac \"$FILE\" --show-tag=ARTIST | sed s/.*=//g`;
my $TITLE = `metaflac "$FILE" --show-tag=TITLE | sed s/.*=//g`;
my $ALBUM = `metaflac "$FILE" --show-tag=ALBUM | sed s/.*=//g`;
my $GENRE = `metaflac "$FILE" --show-tag=GENRE | sed s/.*=//g`;
my $TRACKNUM = `metaflac "$FILE" --show-tag=TRACKNUMBER | sed s/.*=//g`;
my $DATE = `metaflac "$FILE" --show-tag=DATE | sed s/.*=//g`;
my $OUTF = "$FILE\.mp3";

printf "FILE:\t./$FILE\n";
printf "ARTIST:\t$ARTIST";
printf "TITLE:\t$TITLE";
printf "ALBUM:\t$ALBUM";
printf "GENRE:\t$GENRE";
printf "TRACK:\t$TRACKNUM";
printf "DATE:\t$DATE";
printf "OUT FILE:\t$OUTF\n";

`flac -c -d "$FILE" | lame -q 0 -s 48 --id3v2-only --cbr --preset insane - "$OUTF"`;
`id3v2 -t "$TITLE" -T "$TRACKNUM" -a "$ARTIST" -A "$ALBUM" -y "$DATE" -2 -g "$GENRE" "$OUTF"`;

testing from BHA