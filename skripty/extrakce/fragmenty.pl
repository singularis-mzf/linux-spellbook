# Linux Kniha kouzel, skript extrakce/fragmenty.pl
# Copyright (c) 2020, 2021 Singularis <singularis@volny.cz>
#
# Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
# podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
# vydané neziskovou organizací Creative Commons. Text licence je přiložený
# k tomuto projektu nebo ho můžete najít na webové adrese:
#
# https://creativecommons.org/licenses/by-sa/4.0/
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

use Digest::MD5("md5_hex");
use Encode("decode_utf8", "encode_utf8");

# Nastavení
my $stderr = \*STDERR;
my $pdfZáložkyMaxDélka = max(4, (proměnnáProstředí("PDF_ZALOZKY_MAX_DELKA") // 32) + 0);
my $soubory_překladu = proměnnáProstředí("SOUBORY_PREKLADU") // "soubory_překladu";
my $zapnutyPrémiovéKapitoly = defined(proměnnáProstředí("PREMIOVE_KAPITOLY")) && proměnnáProstředí("PREMIOVE_KAPITOLY") ne "0";
$OFS = "\t";
$ORS = "\n";

# Vytvořit adresář „soubory_překladu/osnova“, pokud neexistuje.
system("test -d ${soubory_překladu}/osnova") == 0
    or mkdir("${soubory_překladu}/osnova")
    or die("Nemohu vytvořit adresář ${soubory_překladu}/osnova!");

# načíst ze seznamů všechny fragmenty a seřadit
my %všechnyFragmenty; # úplné id fragmentu => jeho index
my @všechnyFragmenty; # index fragmentu => jeho úplné id
načístVšechnyFragmenty(\@všechnyFragmenty, \%všechnyFragmenty);

# Vlastnosti fragmentů:
my @nedefy = (undef) x alength(@všechnyFragmenty); # společná inicializace
my @adresář = @nedefy;
my @čísloNaVýstupu = @nedefy; # jen u fragmentů na výstup, jinak undef
my @nadkapitola = @nedefy; # id nadkapitoly této kapitoly; "", pokud nadkapitolu nemá
my @název = @nedefy;
my @početŘádek = @nedefy;
my @příznaky = ("") x alength(@nedefy);
my @symboly = @nedefy; # jen u fragmentů na výstup; textové číselné označení (např. „3.1“)
my @štítky = @nedefy; # => [štítky, ...]

# přečíst pořadí kapitol na výstup
my %číslaKapitol; # ID => pořadové číslo na výstupu (1, 2, ...)
{
    # "" => zkusit výchozí soubory
    # "__VŠE__" => všechny fragmenty (předmluvu jako první)
    # jinak => uvádí cestu k souboru se seznamem

    my ($nastavení, $i, $f, $s) = (proměnnáProstředí("PORADI_KAPITOL") // "", 0, undef, undef);
    ladění("Budu číst pořadí kapitol.");

    if ($nastavení eq "") {
        $f = čístPrvníZ(qw(konfigurace/pořadí-kapitol.seznam konfigurace/pořadí-kapitol.výchozí.seznam)) // die("Nepodařilo se určit pořadí kapitol!");
    } elsif ($nastavení ne "__VŠE__") {
        $f = čístPrvníZ($nastavení) // die("Nepodařilo se určit pořadí kapitol! (Nastavení: ${nastavení})");
    }

    if (defined($f)) {
        while (defined($s = scalar(readline($f)))) {
            chomp($s);
            next if ($s !~ /\A[^# ]+\z/); # komentář
            jePlatnéId($s)
                or die("Chyba syntaxe: \"${s}\" není platní ID kapitoly či dodatku!");
            my $index = $všechnyFragmenty{$s};
            defined($index)
                or die("Neznámé ID kapitoly či dodatku: ${s}");
            !defined($čísloNaVýstupu[$index])
                or die("Každá kapitola či dodatek smí být v pořadí na výstup uvedena nejvýše jednou! (ID ${s})");
            # @čísloNaVýstupu + příznak "z" — Je na výstup
            $čísloNaVýstupu[$index] = ++$i;
            nastavitPříznak($index, "z", 1);
            ladění("Pořadí kapitol[${i}] = <${s}>");
        }
        close($f);
    } else {
        my @pořadí = array(grep {$všechnyFragmenty[$ARG] ne "předmluva"} (0..(alength(@všechnyFragmenty) - 1)));
        unshift(@pořadí, $všechnyFragmenty{"předmluva"}) if (alength(@pořadí) < alength(@všechnyFragmenty));
        for my $index (@pořadí) {
            $čísloNaVýstupu[$index] = ++$i;
            nastavitPříznak($index, "z", 1);
        }
    }
    ladění("Pořadí kapitol přečteno: ${i} prvků.");
    if ($i == 0) {
        die("Alespoň jedna kapitola či dodatek musí být zahrnut do výstupu!");
    }
}

# přečíst seznam vydaných kapitol a případně nastavit příznak „p“
{
    my $f = čístPrvníZ("seznamy/vydané-fragmenty.seznam");
    if (defined($f)) {
        my $s;
        while (defined($s = scalar(readline($f)))) {
            chomp($s);
            #next if ($s !~ /\A[^# ]+\z/); # komentář
            jePlatnéId($s)
                or die("Chyba syntaxe: \"${s}\" není platní ID kapitoly či dodatku!");
            my $index = $všechnyFragmenty{$s};
            defined($všechnyFragmenty{$s})
                or die("Neznámé ID kapitoly či dodatku: ${s}");
            ladění("Vydaná kapitola: <${s}>");

            # příznak „p“
            if ($zapnutyPrémiovéKapitoly) {
                # u dodatků se tento příznak ruší dodatečně
                nastavitPříznak($index, "p", !máPříznak($index, "z")); #á
            }
            # příznak „v“
            nastavitPříznak($index, "v", 1);
        }
        close($f);
    }
}

# zkontrolovat, zda podkapitoly následují po svých základních kapitolách
# vyplnit symboly
{
    my @čísloNaIndex;
    my $záklKap;
    my $č;
    my $čZáklKap = 0;
    my $čPodkap = 0;

    for my $i (0..(alength(@všechnyFragmenty) - 1))
    {
        $čísloNaIndex[$č] = $i if (defined($č = $čísloNaVýstupu[$i]) && $č > 0);
    }
    for my $i (1..(alength(@čísloNaIndex) - 1))
    {
        my $indexFragmentu = $čísloNaIndex[$i];
        if (!defined($indexFragmentu))
            {die("Vnitřní chyba: čísloNaIndex[" . $i . "] nedefinováno.")}

        my $idFragmentu = $všechnyFragmenty[$indexFragmentu];
        if (!defined($idFragmentu))
            {die("Vnitřní chyba: idFragmentu[" . $indexFragmentu . "] nedefinováno.")}

        my @části = split(/\//, $idFragmentu, 2);
        if (alength(@části) == 1)
        {
            # základní kapitola
            $záklKap = $idFragmentu; # základní kapitola pro případné následující
            $čPodkap = 0;
            $symboly[$indexFragmentu] = ++$čZáklKap;
        }
        elsif (!defined($záklKap) || $části[0] ne $záklKap)
        {
            die("Chyba v pořadí kapitol. Podkapitoly mohou být uvedeny pouze " .
                "v souvislé řádě po jim příslušné základní kapitole. " .
                "Toto pravidlo porušuje podkapitola <" . $idFragmentu . ">.");
        }
        else
        {
            # podkapitola
            $symboly[$indexFragmentu] = $čZáklKap . "." . (++$čPodkap);
        }
    }
}

# Další data:
my %kapitolyŠtítků; # štítek => [indexy kapitol...]

for my $i (0..(alength(@všechnyFragmenty) - 1))
{
    my $id = $všechnyFragmenty[$i];
    jePlatnéId($id) or die("Chyba při čtení seznamu fragmentů: chybné ID \"${id}\"!");

    ladění("Začínám zpracování fragmentu <${id}>");

    my $holéId = ($id =~ s!.*/!!r);
    my $plochéId = ($id =~ s!/!-!gr);
    #my $xheš = xheš($id); # xheš kapitoly

    # @nadkapitola
    $nadkapitola[$i] = length($holéId) < length($id)
        ? substr($id, 0, length($id) - length($holéId) - 1)
        : "";

    # @adresář + příznak „d“ — Kapitola, nebo dodatek?
    my $existujeKapitola = !system("test -f 'kapitoly/${id}.md'");
    my $existujeDodatek = !system("test -f 'dodatky/${id}.md'");
    if ($existujeKapitola && !$existujeDodatek) {
        $adresář[$i] = "kapitoly";
    } elsif (!$existujeKapitola && $existujeDodatek) {
        $adresář[$i] = "dodatky";
        nastavitPříznak($i, "d", 1); # +d
        nastavitPříznak($i, "p", 0); # -p (dodatky nikdy nejsou prémiové)
    } elsif ($existujeKapitola && $existujeDodatek) {
        die("Existuje kapitola i dodatek s id ${id}!");
    } else {
        die("Neexistuje kapitola ani dodatek s id ${id}!");
    }

    # Jen kapitoly mají štítky
    $štítky[$i] = [] unless (máPříznak($i, "d"));

    # Sken zdrojového kódu
    my $cesta = $adresář[$i] . "/${id}.md";
    open(my $f, "<:utf8", $cesta) or die("Nemohu otevřít soubor ${cesta}!");
    open(my $fOsnova, ">:utf8", "${soubory_překladu}/osnova/${plochéId}.tsv") or die("Nemohu otevřít soubor ${soubory_překladu}/osnova/${plochéId}.tsv!");
    my $čŘádky = 0;
    my $vKomentáři = 0; # nastavuje se na 1 uvnitř víceřádkového komentáře
    my $vZaklínadle = 0; # 1 = řádky zaklínadla; 2 = za zaklínadlem (vyžadován prázdný řádek)
    my $s; # text řádku
    my ($čSekce, $čPodsekce, $názevSekce, $názevPodsekce) = (0, 0, "", "");
    my %cestyZaklínadelNaXheše;
    while (defined($s = scalar(readline($f)))) {
        chomp($s);
        ++$čŘádky;

        # Zpracovat komentáře
        if ($vKomentáři) {
            $vKomentáři = $s ne "-->";
            next;
        }
        if ($s =~ /\A<!--([^-]|-[^-])*-->\z/) {next} # jednořádkový
        if ($vKomentáři = ($s eq "<!--")) {next}

        # Zpracovat zaklínadla (jen ta s titulkem)
        if ($vZaklínadle == 0) {
            if ($s =~ /\A\*# .+\*(<br>)?\z/) {
                $s =~ /<br>\z/
                    or die("Chyba syntaxe ${id}:${čŘádky} (zkontrolujte umístění <br>!): ${s}");
                my $textZaklínadla = $názevSekce . "/" . $názevPodsekce . "/" . mdTextNaČistýText(substr($s, 3, length($s) - 8));
                while (exists($cestyZaklínadelNaXheše{$textZaklínadla})) {$textZaklínadla .= "x"}
                my $xhešZaklínadla = xheš($textZaklínadla);
                $cestyZaklínadelNaXheše{$textZaklínadla} = $xhešZaklínadla;
                vypsatPoložkuOsnovy($fOsnova, "ZAKLÍNADLO", $xhešZaklínadla, $čŘádky, $textZaklínadla, ";");
                $vZaklínadle = 1;
            }
        } elsif ($vZaklínadle == 1) {
            $s ne ""
                or die("Chyba syntaxe ${id}:${čŘádky}: ${s}");
            $s =~ /<br>\z/
                or $vZaklínadle = 2;
        } elsif ($vZaklínadle == 2) {
            $s eq ""
                or die("Chyba syntaxe ${id}:${čŘádky}: ${s}");
            $vZaklínadle = 0;
        }

        # Nadpisy:
        if ($s =~ /\A#+ \S/) {
            # @název — Název kapitoly
            if ($s =~ /\A#{1} /) {
                if (defined($název[$i])) {
                    fprintf($stderr, "VAROVÁNÍ: Soubor %s obsahuje víc nadpisů první úrovně. Pouze první bude použit jako název!\n", $cesta);
                    next;
                }
                $název[$i] = substr($s, 2);
                $název[$i] !~ /\t/ or die("Název v souboru ${cesta} obsahuje tabulátor, což není dovoleno!");
                vypsatPoložkuOsnovy($fOsnova, "KAPITOLA", $symboly[$i] // "NULL", $čŘádky, $název[$i], ";");
                $čSekce = $čPodsekce = 0;
                $názevSekce = $názevPodsekce = "";
            } elsif ($s =~ /\A#{2} /) {
                vypsatPoložkuOsnovy($fOsnova, "SEKCE", ++$čSekce, $čŘádky, $názevSekce = mdTextNaČistýText(substr($s, 3)), ";");
                $čPodsekce = 0;
                $názevPodsekce = "";
            } elsif ($s =~ /\A#{3} /) {
                vypsatPoložkuOsnovy($fOsnova, "PODSEKCE", $čSekce . "x" . (++$čPodsekce), $čŘádky, $názevPodsekce = mdTextNaČistýText(substr($s, 4)), ";");
            } else {
                die("Chyba syntaxe ${id}:${čŘádky}: ${s}");
            }
        }

        # Zpracovat štítky (jen u kapitol určených na výstup):
        if ($s =~ /\A!ŠTÍTKY:( |$)/i && defined($čísloNaVýstupu[$i])) {
            defined($štítky[$i])
                or die("Štítky v dodatcích nejsou povoleny! (Chyba v ${cesta}!)");
            $s =~ s/\A!ŠTÍTKY: ?//i;
            $s =~ /\A(\{[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789ÁČĎÉĚÍŇÓŘŠŤŮÝŽáčďéěíňóřšťůýž ]+\})*\z/ or die("Chybný formát štítků v ${cesta}: ${s}");
            my %štítkyTétoKapitoly;
            for my $štítek (split(/\}\{/, "}${s}{")) {
                if ($štítek ne "") {
                    my $omezenéIdŠtítku = xheš($štítek);
                    !exists($štítkyTétoKapitoly{$štítek})
                        or die("Duplicitní štítek ${štítek} v kapitole ${id}!");
                    push(@{$štítky[$i]}, $štítek);
                    push(@{$kapitolyŠtítků{$štítek}}, $i);
                }
            }
        }
    }
    close($f) or die("Nemohu zavřít soubor ${cesta}!");
    close($fOsnova) or die("Nemohu zavřít soubor ${soubory_překladu}/osnova/${plochéId}!");

    # @početŘádek
    $početŘádek[$i] = $čŘádky;

    ladění("Zpracování id ${id} dokončeno: ${čŘádky} řádek");
}

# Druhý průchod
for my $i (0..(alength(@všechnyFragmenty) - 1)) {
    # Příznak „N“ — Vyhledat nadkapitoly kapitol na výstup
    if ($nadkapitola[$i] ne "" && máPříznak($i, "z")) # á
        {nastavitPříznak($všechnyFragmenty{$nadkapitola[$i]}, "N", 1)}
}
ladění("Druhý průchod skončil.");

# Vypsat štítky.tsv
{
    open(my $f, ">:utf8", "${soubory_překladu}/štítky.tsv")
        or die("Nemohu otevřít soubor štítky.tsv!");
    for my $štítek (seřaditČesky(keys(%kapitolyŠtítků))) {
        vypsatŠtítek($f, $štítek,
            xheš($štítek),
            seřaditČesky(array(map {$všechnyFragmenty[$ARG]} @{$kapitolyŠtítků{$štítek}})));
    }
    close($f);
}

# Vypsat fragmenty.tsv
{
    open(my $f, ">:utf8", "${soubory_překladu}/fragmenty.tsv");

    for my $i (0..(alength(@všechnyFragmenty) - 1)) {
        my $máNadkapitolu = $nadkapitola[$i] ne "";
        my $ikona = "ik/" . ($máNadkapitolu ? $nadkapitola[$i] : $všechnyFragmenty[$i]) . ".png";
        my $štítky = "";

        if (defined($čísloNaVýstupu[$i]) && !máPříznak($i, "d") ) #á
        {
            $štítky = join("", array(map {"{${ARG}}"} seřaditČesky(@{$štítky[$i]})));
        }

        system("test -e 'obrázky/${ikona}'") == 0
            or $ikona = "ik-výchozí.png";

        vypsatFragment($f,
            # 1: Pořadové číslo na výstupu (0, pokud na výstup nepatří)
            $čísloNaVýstupu[$i] // 0,
            # 2: Úplné ID fragmentu
            $všechnyFragmenty[$i] // die("Chyba!"),
            # 3: Ploché ID
            $všechnyFragmenty[$i] =~ s/\//-/gr,
            # 4: Holé ID
            $všechnyFragmenty[$i] =~ s/^.*\///r,
            # 5: Název
            $název[$i],
            # 6: Adresář
            máPříznak($i, "d") ? "dodatky" : "kapitoly", # á
            # 7: Příznaky
            $příznaky[$i] ne "" ? $příznaky[$i] : "NULL",
            # 8: Xheš úplného ID
            xheš($všechnyFragmenty[$i]),
            # 9: ID nadkapitoly
            $máNadkapitolu ? $nadkapitola[$i] : "NULL",
            # 10: Název nadkapitoly
            $máNadkapitolu ? $název[$všechnyFragmenty{$nadkapitola[$i]}] : "NULL",
            # 11: Štítky v {}
            $štítky ne "" ? $štítky : "NULL",
            # 12: Ikona kapitoly (ik-výchozí.png, nebo ik/{id}.png)
            $ikona,
            # 13: Ploché ID bez diakritiky,
            bezDiakritiky($všechnyFragmenty[$i] =~ s/\//-/gr),
            # 14: Symbol, nebo NULL
            $symboly[$i] // "NULL"
            );
    }
    close($f);
}

sub ladění {
    typy(@ARG) =~ /\As+\z/ or croak("Chybné typy parametrů ladění!");
    #fprintf($stderr, "LADĚNÍ: %s\n", join("", @ARG));
}

##############################################################################

sub bezDiakritiky {
    typy(@ARG) =~ /\As\z/ or croak("Chybné typy parametrů!");
    state %překlad = (
        "á", "a", "Á", "A", "č", "c", "Č", "C", "ď", "d", "Ď", "D",
        "é", "e", "É", "E", "ě", "e", "Ě", "E", "í", "i", "Í", "I",
        "ň", "n", "Ň", "N", "ó", "o", "Ó", "O", "ř", "r", "Ř", "R",
        "š", "s", "Š", "S", "ť", "t", "Ť", "T", "ú", "u", "Ú", "U",
        "ů", "u", "Ů", "U", "ý", "y", "Ý", "Y", "ž", "z", "Ž", "Z",

        "-", "-", "\\", "\\", "A", "A", "B", "B", "C", "C", "D", "D",
        "E", "E", "F", "F", "G", "G", "H", "H", "I", "I", "J", "J",
        "K", "K", "L", "L", "M", "M", "N", "N", "O", "O", "P", "P",
        "Q", "Q", "R", "R", "S", "S", "T", "T", "U", "U", "V", "V",
        "W", "W", "X", "X", "Y", "Y", "Z", "Z", "a", "a", "b", "b",
        "c", "c", "d", "d", "e", "e", "f", "f", "g", "g", "h", "h",
        "i", "i", "j", "j", "k", "k", "l", "l", "m", "m", "n", "n",
        "o", "o", "p", "p", "q", "q", "r", "r", "s", "s", "t", "t",
        "u", "u", "v", "v", "w", "w", "x", "x", "y", "y", "z", "z",
        "0", "0", "1", "1", "2", "2", "3", "3", "4", "4", "5", "5",
        "6", "6", "7", "7", "8", "8", "9", "9", " ", " ", "!", "!",
        "\"", "\"", "#", "#", "\$", "\$", "%", "%", "&", "&",
        "'", "'", "(", "(", ")", ")", "*", "*", "+", "+", ",", ",",
        ".", ".", "/", "/", ":", ":", ";", ";", "<", "<", "=", "=",
        ">", ">", "?", "?", "\@", "\@", "^", "^", "_", "_", "`", "`",
        "{", "{", "}", "}", "|", "|", "~", "~", "[", "[", "]", "]");
    return join("", array(map { $překlad{$ARG} // "" } split("", $ARG[0])));
}

sub čístPrvníZ {
    typy(@ARG) =~ /\As+\z/ or croak("Chybné typy parametrů!");
    for my $cesta (@ARG) {
        if (open(my $f, "<:utf8", $cesta)) {
            return $f;
        }
    }
    return undef;
}

sub jePlatnéId {
    state $regex = qr/\A[[:alpha:]](-?[[:alnum:]])*\z/;
    typy(@ARG) =~ /\As\z/ or croak("Chybné typy parametrů!");
    my @části = split("/", $ARG[0]);
    if (alength(@části) == 1) {
        return $části[0] =~ $regex ? 1 : 0;
    } elsif (alength(@části) == 2) {
        return $části[0] =~ $regex && $části[1] =~ $regex ? 2 : 0;
    } else {
        return 0;
    }
}

sub jePříznak {
    typy(@ARG) =~ /\As\z/ or croak("Chybné typy parametrů!");
    return $ARG[0] =~ /\A[dNpvz]\z/;
    # Podporované příznaky:
    #   d = dodatek (ne kapitola)
    #   N = nadkapitola kapitoly určené na výstup
    #   p = prémiová kapitola (jen pokud jsou prémiové kapitoly zapnuty)
    #   v = vydaný fragment
    #   z = fragment určený na výstup (bude mít číslo)
}

sub máPříznak {
    typy(@ARG) =~ /\Ass\z/ or croak("Chybné typy parametrů!");
    my ($index, $příznak) = @ARG;

    $index >= 0 && $index < alength(@všechnyFragmenty)
        or croak("Index ${index} je mimo rozsah!");
    length($příznak) == 1
        or croak("Musí být zadán právě jeden příznak!");
    jePříznak($příznak)
        or croak("Neplatný nebo nepodporovaný příznak „${příznak}“!");
    return index($příznaky[$index], $příznak) >= 0;
}

sub mdTextNaČistýText {
    typy(@ARG) =~ /\As\z/ or croak("Chybné typy parametrů!");
    my $s = $ARG[0];
    my @prvky = matches($s, qr/&(blank|[lg]t|amp|apo|nbsp|quot);|\\.|\*{1,2}|\{[_*]|[*_]\}/);
    state %překlad = ("&blank;", "␣", "&lt;", "<", "&gt;", ">",
        "&amp;", "&", "&apo;", "'", "&nbsp;", " ", "&quot;", '"',
        "*", "", "**", "", "{*", "", "*}", "", "{_", "", "_}", "");
    while (alength(@prvky) > 0) {
        my ($b, $l) = @{pop(@prvky)};
        my $token = substr($s, $b, $l);
        ladění("mdTextNaČistýText: extrahován token \"${token}\" (\"${s}\", ${b}, ${l}); --alength(\@prvky) = " . alength(@prvky));
        substr($s, $b, $l, $token =~ /\A\\.\z/ ? substr($token, 1) : ($překlad{$token} // die("Chybný token: \"${token}\" (délka " . length($token) .")!")));
    }
    return $s =~ s/\s+/ /gr;
}

sub načístVšechnyFragmenty {
    typy(@ARG) eq "AH" or croak("Chybné typy parametrů!");
    my %asocPole;
    open(my $dodatky, "<:utf8", "seznamy/dodatky.seznam")
        and open(my $kapitoly, "<:utf8", "seznamy/kapitoly.seznam")
        or die("Nemohu otevřít seznamy dodatků a kapitol!");
    my @výsledek = (
        array(readline($dodatky)),
        array(readline($kapitoly))
    );
    chomp(@výsledek);
    close($kapitoly);
    close($dodatky);
    @výsledek = do { no locale; array(sort {$a cmp $b} @výsledek); };

    # kontrola duplicit a syntaxe
    for my $i (0..(alength(@výsledek) - 1)) {
        my $fragment = $výsledek[$i];
        jePlatnéId($fragment)
            or die("\"${fragment}\" není platné ID kapitoly či dodatku!");
        !exists($asocPole{$fragment})
            or die("Duplicitní fragment \"${fragment}\" v seznamu všech fragmentů!");
        $asocPole{$fragment} = $i;
        #fprintf(\*STDERR, "LADĚNÍ: [%d] = <%s>\n", $i, $fragment);
    }

    @{$ARG[0]} = @výsledek;
    %{$ARG[1]} = %asocPole;
    return alength(@výsledek);
}

sub nastavitPříznak {
    typy(@ARG) =~ /\Asss?\z/ or croak("Chybné typy parametrů!");
    my ($index, $příznak, $hodnota) = @ARG;

    $index >= 0 && $index < alength(@všechnyFragmenty)
        or croak("Index ${index} je mimo rozsah!");
    length($příznak) == 1
        or croak("Musí být zadán právě jeden příznak!");
    jePříznak($příznak)
        or croak("Neplatný nebo nepodporovaný příznak „${příznak}“!");

    my $máPříznak = bool(index($příznaky[$index], $příznak) >= 0);
    my $máMítPříznak = bool(!defined($hodnota) || $hodnota);
    if ($máPříznak != $máMítPříznak) {
        if ($máMítPříznak) {
            $příznaky[$index] .= $příznak;
        } else {
            substr($příznaky[$index], index($příznaky[$index], $příznak), 1) = "";
        }
    }
    return $hodnota;
}

sub proměnnáProstředí {
    typy(@ARG) eq "s" or croak("Chybné typy parametrů");
    my $x = $ENV{$ARG[0]};
    return defined($x) ? Encode::decode_utf8($x) : $x;
}

sub seřaditBinárně {
    my $typy = typy(@ARG);
    $typy =~ /\As*\z/ or croak("Chybné typy parametrů: ${typy}");
    return do {no locale; array(sort {$a cmp $b} @ARG);};
}

sub seřaditČesky {
    my $typy = typy(@ARG);
    $typy =~ /\As*\z/ or croak("Chybné typy parametrů: ${typy}");
    return do {use locale; array(sort {$a cmp $b} @ARG);};
}

sub vypsatPoložkuOsnovy {
    local $OFS = "\t";
    local $ORS = "\n";
    state $šablonaNázvu = "\x{1a}" x 32;

    typy(@ARG) =~ /\AFs{5}\z/ or croak("Chybné typy parametrů!");
    my ($výstup, $typ, $id, $čŘádku, $název, $zarážka) = @ARG;
    $zarážka eq ";" or croak("Chybná zarážka!");

    my $pdfZáložka = "NULL";
    if ($typ ne "ZAKLÍNADLO") { # negenerovat PDF záložku pro záklínadla
        my @x = array(grep {$ARG < 0xfeff}
            array(unpack("U*",
                $název = mdTextNaČistýText($název))));
        if (alength(@x) > $pdfZáložkyMaxDélka - 1) {
            splice(@x, $pdfZáložkyMaxDélka - 4);
            push(@x, 0x2e x 3); # "..."
        }
        @x = array(map {sprintf("%04X", $ARG)} @x);
        unshift(@x, "\\uFEFF");
        $pdfZáložka = join("\\u", @x);
    }
    fprint($výstup, $typ, $id, $čŘádku, $název, $pdfZáložka, $zarážka);
    return 1;
}

sub vypsatFragment {
    local $OFS = "\t";
    local $ORS = "\n";
    state $řádka = 0;

    typy(@ARG) =~ /\AFs{14}\z/ or croak("Chybné typy parametrů!");
    ++$řádka;
    ladění("FRAG[${řádka}]/číslo-na-výstupu: " . $ARG[1]);
    ladění("FRAG[${řádka}]/úplné-ID: " . $ARG[2]);
    ladění("FRAG[${řádka}]/ploché-ID: " . $ARG[3]);
    ladění("FRAG[${řádka}]/holé-ID: " . $ARG[4]);
    ladění("FRAG[${řádka}]/název: " . $ARG[5]);
    ladění("FRAG[${řádka}]/adresář: " . $ARG[6]);
    ladění("FRAG[${řádka}]/příznaky: " . $ARG[7]);
    ladění("FRAG[${řádka}]/xheš: " . $ARG[8]);
    ladění("FRAG[${řádka}]/ID-nadkapitoly: " . $ARG[9]);
    ladění("FRAG[${řádka}]/název-nadkapitoly: " . $ARG[10]);
    ladění("FRAG[${řádka}]/štítky: " . $ARG[11]);
    ladění("FRAG[${řádka}]/ikona-kapitoly: " . $ARG[12]);
    ladění("FRAG[${řádka}]/ploché-ID-bezdiakr: " . $ARG[13]);
    ladění("FRAG[${řádka}]/symbol: " . $ARG[14]);
    return fprint(@ARG);
}

sub vypsatŠtítek {
    local $OFS = "\t";
    local $ORS = "\n";
    state $řádek = 0;

    typy(@ARG) =~ /\AFss+\z/ or croak("Chybné typy parametrů!");
    my $f = shift(@ARG);
    my $štítek = shift(@ARG);
    my $omezenéID = shift(@ARG);
    ++$řádek;
    ladění("ŠTÍTEK[${řádek}] = <${štítek}> (omezené ID <${omezenéID}>)");

    # Pokud seznam obsahuje kapitolu a její podkapitoly, musí být
    # seřazen tak, aby kapitola bezprostředně předcházela sekvenci
    # podkapitol
    my %zavřenéNadkapitoly;
    my $otevřenáNadkapitola;
    for my $k (@ARG) {
        my $i = index($k, "/");
        if ($i < 0) {
            # není podkapitola
            !exists($zavřenéNadkapitoly{$k})
                or die("Chybné řazení seznamu štítků: ${k} je příliš pozdě (až po některé své podkapitole)!");
            $zavřenéNadkapitoly{$otevřenáNadkapitola} = 1 if (defined($otevřenáNadkapitola));
            $otevřenáNadkapitola = $k;
        } else {
            # je podkapitola
            my $nk = substr($k, 0, $i);
            !exists($zavřenéNadkapitoly{$nk})
                or die("Chybné řazení seznamu štítků: ${k} je příliš pozdě!");
            if (!defined($otevřenáNadkapitola) || $nk ne $otevřenáNadkapitola) {
                $zavřenéNadkapitoly{$otevřenáNadkapitola} = 1 if (defined($otevřenáNadkapitola));
                $otevřenáNadkapitola = $nk;
            }
        }
    }

    return fprint($f, $štítek, $omezenéID, @ARG);
}

my %xheš_keš; # řetězec -> xheš
my %xheš_revkeš; # xheš -> řetězec

sub xheš {
    typy(@ARG) =~ /\As\z/ or croak("Chybné typy parametrů!");
    my $x = $ARG[0];
    $x =~ /\A[^\t\n\0]+\z/ or croak("Řetězec pro xheš obsahuje nepovolený znak nebo je prázdný!");
    my $xheš = $xheš_keš{$x};
    if (!defined($xheš)) {
        $xheš = lc("x" . substr(md5_hex(encode_utf8($x)), 0, 7));
        !exists($xheš_revkeš{$xheš})
            or die("Detekován konflikt x-heší: " . $xheš . " pro \"" . $xheš_revkeš{$xheš} .
            "\" (MD5:" . md5_hex(encode_utf8($xheš_revkeš{$xheš})) .
            ") a pro \"" . $x . "\" (MD5:" . md5_hex(encode_utf8($x)) . ")!");
        $xheš_revkeš{$xheš} = $x;
        $xheš_keš{$x} = $xheš;
    }
    return $xheš;
}

# jen ladění
sub xheš_vypsat {
    alength(@ARG) == 0 or croak("Tato funkce nepřijímá parametry!");
    open(my $f, ">:utf8", $soubory_překladu . "/xheš.výpis") or die("Nemohu otevřít soubor!");
    for my $xheš (keys(%xheš_revkeš)) {
        fprintf("%s\t%s\n", $xheš, $xheš_revkeš{$xheš});
    }
    close($f);
    return alength(keys(%xheš_revkeš));
}
