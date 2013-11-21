#!/usr/bin/perl
use strict;
use warnings;
use MP3::Tag;
use Audio::FLAC::Header;
my $FILE = $ARGV[0];

my $TITLE;
my $ARTIST;
my $ALBUM;
my $ALBUMARTIST;
my $GENRES;
my $DATE;
my $LYRICS;
my $COMMENT;
my $TRACK;
my $SAMPLERATE;
my $SAMPLERATESUM;
my $OUTF = "$FILE\.mp3";


###	Use METAFLAC to get FLAC tag info
sub get_metaflac_info{
	my $ARTIST = `metaflac \"$FILE\" --show-tag=ARTIST | sed s/.*=//g`;
	my $TITLE = `metaflac "$FILE" --show-tag=TITLE | sed s/.*=//g`;
	my $ALBUM = `metaflac "$FILE" --show-tag=ALBUM | sed s/.*=//g`;
	my $GENRE = `metaflac "$FILE" --show-tag=GENRE | sed s/.*=//g`;
	my $TRACKNUM = `metaflac "$FILE" --show-tag=TRACKNUMBER | sed s/.*=//g`;
	my $DATE = `metaflac "$FILE" --show-tag=DATE | sed s/.*=//g`;
	my $OUTF = "$FILE\.mp3";
};
sub get_flac_info{
	my $flac = Audio::FLAC::Header->new("$FILE");
		
		my $tags = $flac->tags();
        my $info = $flac->info();
        
		### Display all available file information
        #foreach (keys %$info) {
        #        print "$_: $info->{$_}\n";               
        #}

		### Display all available file tags
        #foreach (keys %$tags) {
        #        print "$_: $tags->{$_}\n";
        #}
        
        ### Take what we want... and give nothing back
        $ALBUMARTIST = "$tags->{ALBUMARTIST}";
        $DATE = "$tags->{DATE}";
        $LYRICS = "$tags->{UNSYNCEDLYRICS}";
        $ARTIST = "$tags->{ARTIST}";
        $COMMENT = "$tags->{COMMENT}";
        $TITLE = "$tags->{TITLE}";
        $ALBUM = "$tags->{ALBUM}";
        $TRACK = "$tags->{TRACKNUMBER}";
        $GENRES = "$tags->{GENRE}";
        $SAMPLERATE = "$info->{SAMPLERATE}";
        
        ### Use a higher sample rate if available
        if ($SAMPLERATE eq '48000') {
        	$SAMPLERATESUM = '48';
        } elsif ($SAMPLERATE eq '44100') {
        	$SAMPLERATESUM = '44.1';
        };
};
###	Print tag information
sub display_tag_info{
        printf "Title:\t$TITLE\n";
        printf "Artist:\t$ARTIST\n";
        printf "Album:\t$ALBUM\n";
        printf "Album Artist:\t$ALBUMARTIST\n";
        printf "Track Number:\t$TRACK\n";
        printf "Genre:\t$GENRES\n";
        printf "Sample Rate:\t$SAMPLERATE\n";
        printf "Date:\t$DATE\n";
        printf "Comment:\t$COMMENT\n";
        printf "Lyrics:\n$LYRICS\n\n\n\n";
};
### convert FLAC file to MP3
sub convert_flac{
	`rm -rf $OUTF`;
	`flac -c -d "$FILE" | lame --tt "$TITLE" --ta "$ARTIST" --tl "$ALBUM" --ty "$DATE" --tg "$GENRES" --tn "$TRACK" --tc "$COMMENT" -q 0 -b "$SAMPLERATESUM" --resample "$SAMPLERATESUM" --id3v2-only --cbr --preset insane - "$OUTF"`;
};
### Write MP3 tag information
sub write_mp3_tags{
	my $mp3 = MP3::Tag::ID3v2->new("$OUTF"); # create object 
	
	$mp3->get_tags(); # read tags
	
	if (exists $mp3->{ID3v2}) { # save track information
	$mp3->{ID3v2}->title("$TITLE");
	$mp3->{ID3v2}->artist("$ARTIST");
	$mp3->{ID3v2}->album("$ALBUM");
	$mp3->{ID3v2}->year("$DATE");
	$mp3->{ID3v2}->write_tag();
	}
	
	$mp3->close(); # destroy object
};
###	Use ID3V2 to write MP3 tags
sub use_id3v2{
#	`id3v2 -t "$TITLE" -T "$TRACKNUM" -a "$ARTIST" -A "$ALBUM" -y "$DATE" -2 -g "$GENRE" "$OUTF"`;
};
sub main{
		get_flac_info();
		#display_tag_info();
		convert_flac();
		#write_mp3_tags();
};


main();