#!/usr/bin/perl 
use strict;
use warnings;
use feature qw ( say );
use Encode;
use utf8;
use List::Util qw( max );
use FindBin;

my $maker = shift @ARGV;

unless (( $maker eq 'hatena') or ($maker eq 'wikipedia')) {
	die 'arg is wrong';
}

my $utf8_dic_dir = $FindBin::Bin . '/utf8_dic/';

my $org_text = $utf8_dic_dir . $maker . 'keyword_utf8.txt';

open my $in, '<', $org_text or die "can't open $org_text";

my $created_dic =  $utf8_dic_dir .$maker . 'keyword_utf8_dic.csv';

open my $out, '>>', $created_dic;

my $exclude_text = $utf8_dic_dir . $maker . 'keyword_exclude.txt';

open my $ext, '>>', $exclude_text;

while (<$in>){
	my $word;
	if ($maker eq 'hatena'){
		(undef,$word) = split('\t',$_) if $maker eq 'hatena';
	}else{
		$word = $_;
	}
	chomp($word);
	$word = decode('utf-8',$word);
	$word =~ s/_/ /g;
	my $length = length($word); 
#		print  "$length : $word\n";
	if ($word =~ /^\d{4}$/){
		my $str = "$word is not mutch\n";
		print $ext encode_utf8($str);
		next;
	}elsif ($word =~ /\d{1,4}\/\d{1,2}\/\d{1,2}/){
		my $str = "$word is not mutch\n";
		print $ext encode_utf8($str);
		next;
	}elsif ($word =~ /\d{1,4}-\d{1,2}-\d{1,2}/){
		my $str = "$word is not mutch\n";
		print $ext encode_utf8($str);
		next;
	}elsif ($word =~ /(\d{1,4}年|\d{1,2}月|\d{1,2}日)/){
		my $str = "$word is not mutch\n";
		print $ext encode_utf8($str);
		next;
	}elsif ($word =~ /^\d+.?/){
		my $str = "$word is not mutch\n";
		print $ext encode_utf8($str);
		next;
	}elsif ($word =~ /^\d+$/){
		my $str = "$word is not mutch\n";
		print $ext encode_utf8($str);
		next;
	}elsif ($word =~ /(\%|\$|\\|\&|\#|\/|\(|～|\"|\,|\.)/){
		my $str = "$word is not mutch\n";
		print $ext encode_utf8($str);
		next;
	}elsif ($word =~ /^(\!|\'|\*|\+|\-|\.|\@|\?|\=)/){
		my $str = "$word is not mutch\n";
		print $ext encode_utf8($str);
		next;
	}elsif ($word =~ /(^[a-zA-Z]+\s)+?/){
		my $str = "$word is not mutch\n";
		print $ext encode_utf8($str);
		next;
	}elsif ($length <2){ 
		my $str = "$word is not mutch\n";
		print $ext encode_utf8($str);
		next;
	}else{
		$word = lc($word);
#		my $cost = int(max(-36000, -400 * ($length **1.5)));
		my $cost2 = int(max(-32768, 6000-200 * ($length **1.3)));
		my $str = "$word,-1,-1,$cost2,名詞,一般,*,*,*,*,*,*,*,$maker\n";
		print $out $str;
	}
}
