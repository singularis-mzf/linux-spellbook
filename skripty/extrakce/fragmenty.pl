# Linux Kniha kouzel, skript extrakce/fragmenty.pl
# Copyright (c) 2020 Singularis <singularis@volny.cz>
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

use Encode();

# Nastavení
my $stderr = \*STDERR;
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
my @omezenéId = @nedefy;
my @početŘádek = @nedefy;
my @příznaky = ("") x alength(@nedefy);
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
        $f = čístPrvníZ(qw(pořadí-kapitol.seznam pořadí-kapitol.výchozí.seznam)) // die("Nepodařilo se určit pořadí kapitol!");
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
    my $f = čístPrvníZ(qw(pořadí-kapitol.vydané.lst poradi-kapitol.vydane.lst));
    if (defined($f)) {
        my $s;
        while (defined($s = scalar(readline($f)))) {
            chomp($s);
            next if ($s !~ /\A[^# ]+\z/); # komentář
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

# Další data:
my %omezenáIdNaPlná; # slouží také ke kontrole duplicit
my %kapitolyŠtítků; # štítek => [indexy kapitol...]

for my $i (0..(alength(@všechnyFragmenty) - 1))
{
    my $id = $všechnyFragmenty[$i];
    jePlatnéId($id) or die("Chyba při čtení seznamu fragmentů: chybné ID \"${id}\"!");

    ladění("Začínám zpracování fragmentu <${id}>");

    # @omezenéId
    my $holéId = ($id =~ s!.*/!!r);
    my $plochéId = ($id =~ s!/!-!gr);
    my $omezenéId = generovatOmezenéId($id);
    !exists($omezenáIdNaPlná{$omezenéId})
        or die("Duplicita v omezeném id: " . $omezenáIdNaPlná{$omezenéId} . " x " . $id) ;
    $omezenéId[$i] = $omezenéId;
    $omezenáIdNaPlná{$omezenéId} = $id;

    ladění("${i}: ID(${id}) HOLÉ(${holéId}) PLOCHÉ(${plochéId}) OMEZENÉ(${omezenéId})");

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
    my $s; # text řádku
    my ($čSekce, $čPodsekce) = 0;
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
                vypsatPoložkuOsnovy($fOsnova, "KAPITOLA", $čísloNaVýstupu[$i] // 0, $čŘádky, $název[$i], ";");
                $čSekce = $čPodsekce = 0;
            } elsif ($s =~ /\A#{2} /) {
                vypsatPoložkuOsnovy($fOsnova, "SEKCE", ++$čSekce, $čŘádky, mdTextNaČistýText(substr($s, 3)), ";");
                $čPodsekce = 0;
            } elsif ($s =~ /\A#{3} /) {
                vypsatPoložkuOsnovy($fOsnova, "PODSEKCE", $čSekce . "x" . (++$čPodsekce), $čŘádky, mdTextNaČistýText(substr($s, 4)), ";");
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
                    my $omezenéIdŠtítku = generovatOmezenéId("s", $štítek);
                    !exists($omezenáIdNaPlná{$omezenéIdŠtítku}) || $omezenáIdNaPlná{$omezenéIdŠtítku} eq $štítek
                        or die("Konflikt štítků \"${štítek}\" a \"" . $omezenáIdNaPlná{$omezenéIdŠtítku} . "\" (omezené ID ${omezenéIdŠtítku})!");
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
            generovatOmezenéId("s", $štítek),
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
            # 8: Omezené ID
            $omezenéId[$i],
            # 9: ID nadkapitoly
            $máNadkapitolu ? $nadkapitola[$i] : "NULL",
            # 10: Název nadkapitoly
            $máNadkapitolu ? $název[$všechnyFragmenty{$nadkapitola[$i]}] : "NULL",
            # 11: Štítky v {}
            $štítky ne "" ? $štítky : "NULL",
            # 12: Ikona kapitoly (ik-výchozí.png, nebo ik/{id}.png)
            $ikona,
            # 13: Ploché ID bez diakritiky,
            bezDiakritiky($všechnyFragmenty[$i] =~ s/\//-/gr)
            );
    }
    close($f);
}

# Vypsat prémiové-kapitoly.tsv
{
    open(my $f, ">:utf8", "${soubory_překladu}/prémiové-kapitoly.tsv");

    for my $i (0..(alength(@všechnyFragmenty) - 1)) {
        if (máPříznak($i, "p")) #á
        {
            fprintf($f, "%s\t%s\n", $všechnyFragmenty[$i], $název[$i]);
        }
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

sub generovatOmezenéId {
    # ([prefix], id) => omezenéId
    typy(@ARG) =~ /\As?s\z/ or croak("Chybné typy parametrů!");
    my $id = pop(@ARG);
    my $prefix = pop(@ARG) // "";
    return $prefix . substr(lc(bezDiakritiky($id)) =~ s/[^abcdefghijklmnopqrstuvwxyz0123456789]//gr, 0, 16);
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
    my @prvky = matches($s, qr/&(blank|[lg]t|amp|apo|nbsp|quot);|\\./);
    state %překlad = ("&blank;", "␣", "&lt;", "<", "&gt;", ">",
        "&amp;", "&", "&apo;", "'", "&nbsp;", " ", "&quot;", '"');
    while (alength(@prvky) > 0) {
        my ($b, $l) = @{pop(@prvky)};
        my $token = substr($s, $b, $l);
        ladění("mdTextNaČistýText: extrahován token \"${token}\" (\"${s}\", ${b}, ${l}); --alength(\@prvky) = " . alength(@prvky));
        substr($s, $b, $l, $token =~ /\A\\.\z/ ? substr($token, 1) : ($překlad{$token} // die("Chybný token: \"${token}\" (délka " . length($token) .")!")));
    }
    return $s;
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

    $název = mdTextNaČistýText($název);
    my @x = array(unpack("U*", substr($název, 0, 32)));
    @x = array(grep {$ARG < 0xfeff} @x);
    @x = array(map {sprintf("%04X", $ARG)} @x);
    unshift(@x, "\\uFEFF");
    fprint($výstup, $typ, $id, $čŘádku, $název, join("\\u", @x), $zarážka);
    return 1;
}

sub vypsatFragment {
    local $OFS = "\t";
    local $ORS = "\n";
    state $řádka = 0;

    typy(@ARG) =~ /\AFs{13}\z/ or croak("Chybné typy parametrů!");
    ++$řádka;
    ladění("FRAG[${řádka}]/číslo-na-výstupu: " . $ARG[1]);
    ladění("FRAG[${řádka}]/úplné-ID: " . $ARG[2]);
    ladění("FRAG[${řádka}]/ploché-ID: " . $ARG[3]);
    ladění("FRAG[${řádka}]/holé-ID: " . $ARG[4]);
    ladění("FRAG[${řádka}]/název: " . $ARG[5]);
    ladění("FRAG[${řádka}]/adresář: " . $ARG[6]);
    ladění("FRAG[${řádka}]/příznaky: " . $ARG[7]);
    ladění("FRAG[${řádka}]/omezené-ID: " . $ARG[8]);
    ladění("FRAG[${řádka}]/ID-nadkapitoly: " . $ARG[9]);
    ladění("FRAG[${řádka}]/název-nadkapitoly: " . $ARG[10]);
    ladění("FRAG[${řádka}]/štítky: " . $ARG[11]);
    ladění("FRAG[${řádka}]/ikona-kapitoly: " . $ARG[12]);
    ladění("FRAG[${řádka}]/ploché-ID-bezdiakr: " . $ARG[13]);
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
