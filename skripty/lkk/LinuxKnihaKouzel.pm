# Linux Kniha kouzel, skript LinuxKnihaKouzel.pl
#
# To the extent possible under law, Singularis has waived all copyright
# and related or neighboring rights to the contents of this source file.
#
# Alternativně:
#
# Copyright (c) 2020 Singularis <singularis@volny.cz>
#
# Obsah tohoto souboru podléhá licenci Creative Commons CC0
# vydané neziskovou organizací Creative Commons. Text licence je přiložený
# k tomuto projektu nebo ho můžete najít na webové adrese:
#
# https://creativecommons.org/publicdomain/zero/1.0/
#
# Osoba poskytující tuto licenci se rozhodla vzdát ve vztahu k tomuto
# souboru zdrojového kódu všechna svá práva autorská a práva příbuzná
# k právu autorskému.
#
use utf8;
package LinuxKnihaKouzel;
use v5.26.0;
use strict;
use warnings;
use English;

use Carp("carp", "croak", "confess");
use Exporter("import");
use FindBin;
use List::Util("min", "max");

use constant MAIN_SCRIPT_DIR => $FindBin::Bin;

our @EXPORT = qw{
	alength array bool div fprint fprintf fput put typy
	matches next_match next_match_captures next_match_begin next_match_length
	next_match_end next_match_text
	min max
	MAIN_SCRIPT_DIR
	carp croak confess
};
our @EXPORT_OK = ();

sub alength {return scalar(@ARG)}
sub array {return @ARG}
sub bool {return pop(@ARG) ? 1 : 0}
sub div {my ($a, $b) = @ARG; use integer; return ($a / $b, $a % $b);}
sub fprint {my $soubor = shift(@ARG); return print($soubor @ARG);}
sub fprintf {my $soubor = shift(@ARG); return printf($soubor @ARG);}
sub fputs {local $OFS = undef; local $ORS = undef; my $soubor = shift(@ARG); return print($soubor @ARG);}
sub puts {local $OFS = undef; local $ORS = undef; return print(@ARG);}
sub typy {return join("", map {my $r;!defined($ARG) ? "u" : !($r = ref($ARG)) ? "s" : $r =~ /\A(SCALAR|ARRAY|HASH|CODE|Regexp)\z/ ? substr($r, 0, 1) : $r eq "GLOB" ? "F" : "<${r}>";} @ARG)}

sub matches { # ⇒ ([začátek, délka], [začátek, délka], ...) || ()
    typy(@ARG) =~ /\AsRs{0,2}\z/ or croak("matches: Chybné parametry: ".typy(@ARG));
    my @v;
    my ($s, $r, $begin, $maxlength) = @ARG;
    $begin = 0 if (!defined($begin));
    $s = substr($s, 0, $begin + $maxlength) if (defined($maxlength) && $maxlength < length($s));
    pos($s) = $begin;
    while ($s =~ /$r/gn) {
        push(@v, [$LAST_MATCH_START[0], $LAST_MATCH_END[0] - $LAST_MATCH_START[0]]);
        last if($LAST_MATCH_START[0] != $LAST_MATCH_END[0] && pos($s) == length($s));
    }
    return @v;
}

sub next_match { # ⇒ (začátek, délka) || (undef, undef)
    typy(@ARG) =~ /\AsRs{0,2}\z/ or croak("next_match: Chybné parametry: ".typy(@ARG));
    my ($s, $r, $begin, $maxlength) = @ARG;
    $begin = 0 if (!defined($begin));
    $s = substr($s, 0, $begin + $maxlength) if (defined($maxlength) && $maxlength < length($s));
    pos($s) = $begin;
    if ($s =~ /$r/gn) {
        return ($LAST_MATCH_START[0], $LAST_MATCH_END[0] - $LAST_MATCH_START[0]);
    } else {
        return (undef, undef);
    }
}

sub next_match_begin {return (next_match(@ARG))[0]}
sub next_match_end {my ($b, $l) = next_match(@ARG); return defined($b) ? $b + $l : undef;}
sub next_match_length {return (next_match(@ARG))[1]}
sub next_match_text {my ($b, $l) = next_match(@ARG); return defined($b) ? substr($ARG[0], $b, $l) : undef;}

sub next_match_captures { # ⇒ ([začátek, délka], [začátek, délka], ...) || ()
    typy(@ARG) =~ /\AsRs{0,2}\z/ or croak("next_match: Chybné parametry: ".typy(@ARG));
    my @v;
    my ($s, $r, $begin, $maxlength) = @ARG;
    $begin = 0 if (!defined($begin));
    $s = substr($s, 0, $begin + $maxlength) if (defined($maxlength) && $maxlength < length($s));
    pos($s) = $begin;
    if ($s =~ /$r/g) {
        for (my $i = 0; $i < alength(@LAST_MATCH_START); ++$i) {
            push(@v, [$LAST_MATCH_START[$i], $LAST_MATCH_END[$i] - $LAST_MATCH_START[$i]]);
        }
    }
    return @v;
}

1;
