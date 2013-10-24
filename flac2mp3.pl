#!/usr/bin/perl
use strict;
use warnings;
use MP3::Info;
use MP3::Tag;
use Audio::FLAC::Header;


###	Use METAFLAC to get FLAC tag info
my $FILE = $ARGV[0];
my $ARTIST = `metaflac \"$FILE\" --show-tag=ARTIST | sed s/.*=//g`;
my $TITLE = `metaflac "$FILE" --show-tag=TITLE | sed s/.*=//g`;
my $ALBUM = `metaflac "$FILE" --show-tag=ALBUM | sed s/.*=//g`;
my $GENRE = `metaflac "$FILE" --show-tag=GENRE | sed s/.*=//g`;
my $TRACKNUM = `metaflac "$FILE" --show-tag=TRACKNUMBER | sed s/.*=//g`;
my $DATE = `metaflac "$FILE" --show-tag=DATE | sed s/.*=//g`;
my $OUTF = "$FILE\.mp3";


###	Print tag information
printf "FILE:\t./$FILE\n";
printf "ARTIST:\t$ARTIST";
printf "TITLE:\t$TITLE";
printf "ALBUM:\t$ALBUM";
printf "GENRE:\t$GENRE";
printf "TRACK:\t$TRACKNUM";
printf "DATE:\t$DATE";
printf "OUT FILE:\t$OUTF\n";

### convert FLAC file to MP3
`flac -c -d "$FILE" | lame -q 0 -s 48 --id3v2-only --cbr --preset insane - "$OUTF"`;


### Write MP3 tag information
$mp3 = MP3::Tag->new("$OUTF"); # create object 

$mp3->get_tags(); # read tags

if (exists $mp3->{ID3v1}) { # save track information
$mp3->{ID3v1}->title("$TITLE");
$mp3->{ID3v1}->artist("$ARTIST");
$mp3->{ID3v1}->album("$ALBUM");
$mp3->{ID3v1}->year("$DATE");
$mp3->{ID3v1}->write_tag();
}

$mp3->close(); # destroy object


###	Use ID3V2 to write MP3 tags
#`id3v2 -t "$TITLE" -T "$TRACKNUM" -a "$ARTIST" -A "$ALBUM" -y "$DATE" -2 -g "$GENRE" "$OUTF"`;