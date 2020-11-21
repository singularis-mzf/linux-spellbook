# Linux Kniha kouzel, skript lkk-spouštěč.pl
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
#
# =================================================================================
# exec 9>&1
# p=$(perl -CSLA -Mv5.26.0 -Mstrict -Mutf8 -Mwarnings -MEnglish -- lkk-spoustec.pl [argumenty])
# exec 9>&-
# eval "$p"
#
my $proměnnáHome = proměnnáProstředí("HOME", "");
$proměnnáHome ne "" or die("Chybná hodnota proměnné \$HOME!");
my $proměnnáEditor = proměnnáProstředí("EDITOR", "sensible-editor");
my $proměnnáDataHome = proměnnáProstředí("XDG_DATA_HOME", $proměnnáHome . "/.local/share");
my $lkkCesta = proměnnáProstředí("LKKPATH", $proměnnáDataHome . "/lkk/skripty:/usr/share/lkk/skripty");

my $přepínačBash = 0;
my $přepínačSystém = 0; #=
my $přepínačJenSpustitelné = 0;

my $i = undef;
my $s = undef;

my @argumenty = @ARGV;
my $akce = "";

# 1. Zpracovat volby
while (defined($s = shift(@argumenty)) && $s ne "--")
{
    if (která($s, "-e", "--editovat")) {
        $akce = "e";
    } elsif (která($s, "-f", "--najit", "--najít")) {
        $akce = "f";
    } elsif (která($s, "-h", "--help", "--napoveda", "--nápověda")) {
        $akce = "h";
    } elsif (která($s, "-l", "--seznam")) {
        $akce = "l";
    } elsif (která($s, "-p", "--vypsat")) {
        $akce = "p";
    } elsif (která($s, "-r", "--spustit")) {
        $akce = "r";
    } elsif (která($s, "-t", "--existuje")) {
        $akce = "t";
    } elsif (která($s, "-F", "--funkce")) {
        $akce = "F";
    } elsif (která($s, "-P", "--seznam-cest")) {
        $akce = "P";
    } elsif (která($s, "--bash")) {
        ++$přepínačBash;
    } elsif (která($s, "-s", "--system", "--systém")) {
        ++$přepínačSystém; #;
    } elsif (která($s, "-x", "--jen-spustitelne", "--jen-spustitelné")) {
        ++$přepínačJenSpustitelné;
    } elsif ($s =~ /^-/) {
        die("lkk: Neznámá volba: ".$s);
    } else {
        unshift(@argumenty, $s);
        last;
    }
}

if ($akce eq "") {
    # výchozí akce (pokud není zadána)
    $akce = alength(@argumenty) > 0 ? "r" : "h";
}

# 2. Skript musí být zadán, ledaže ho akce nevyžaduje
if ($akce =~ /^[hlP]$/) {
    alength(@argumenty) == 0 or die("lkk: Chybné použití: akce -".$akce." nepřijímá název skriptu!");
} elsif ($akce =~ /^[^F]$/) {
    alength(@argumenty) != 0 && $argumenty[0] ne "" or die("Chybí název skriptu! Pro nápovědu zadejte: lkk --help");
    $argumenty[0] !~ /\// or die("lkk: Název skriptu nesmí obsahovat lomítko: ".$argumenty[0]);
}

# 3. Otevřít proudy

my $stdvýstup = undef;

otevřít(\$stdvýstup, ">&=9") or die("lkk: Nemohu otevřít standardní výstup!");
binmode($stdvýstup, ":utf8");

# 4. Akce "h" (vypsat nápovědu)
if ($akce eq "h") {
    fprintf($stdvýstup, "%s", "„lkk“ – užití:\n".
        "\tlkk -e {skript} :: Vytvoří uživatelovu kopii skriptu a otevře ji ve výchozím editoru (\$EDITOR, popř. sensible-editor).\n".
        "\tlkk -f {skript} :: Vypíše úplnou (absolutní) cestu k zadanému skriptu.\n".
        "\tlkk -l          :: Vypíše seznam dostupných skriptů.\n".
        "\tlkk -p {skript} :: Vypíše obsah skriptu na standardní výstup.\n".
        "\tlkk [-r] {skript} [parametry...] :: Spustí skript se zadanými parametry.\n".
        "\tlkk -t {skript} :: Jen ověří, že daný skript existuje.\n".
        "\tlkk --seznam-cest :: Vypíše seznam cest (i neexistujících), kde hledá skripty.\n".
        "\tlkk --funkce [funkce] :: Vypíše pomocnou funkci (všechny, není-li zadána konkrétní). Předponu „lkk_“ lze vynechat.\n".
        "\nDalší volby (nutno uvést před název skriptu či funkce!):\n".
        "\t--bash :: Je-li zadáno -e na neexistující skript, vytvoří skript s hlavičkou „#!/bin/bash“. Vhodné kombinovat s „-x“.\n".
        "\t-s :: Skripty hledat jen v /usr/share/lkk/skripty; ignorovat proměnnou LKKPATH a uživatelské úložiště ~/.local/share/lkk/skripty.\n".
        "\t-x :: Ignorovat nespustitelné skripty (tzv. úryvky). Je-li zadáno -e na neexistující skript, nastaví nový skript jako spustitelný.\n".
        "\nPoznámka: z technických důvodů nelze krátké volby kombinovat do jednoho parametru, musejí být uvedeny zvlášť.\n");
    exit();
}

# 5. Sestavit seznam cest k prohledání
my @cesty = split(":", $přepínačSystém ? "/usr/share/lkk/skripty" : $lkkCesta); #?


# 6. Akce "l" (vypsat seznam dostupných skriptů)
if ($akce eq "l") {
    alength(@argumenty) == 0 or die("lkk: Chybné použití: akce -l nepřijímá název skriptu!");
    alength(@cesty) > 0 or exit();
    my $příkaz = "find";

    foreach my $s (@cesty) {
        if (test("-r ".doApostrofů($s))) {
            $příkaz .= " ".doApostrofů($s);
        }
    }
    $příkaz ne "find" or exit();
    $příkaz .= " -mindepth 1 -maxdepth 1 -readable";
    $přepínačJenSpustitelné and $příkaz .= " -executable";
    $příkaz .= " -printf '%f\\n' | sort -u";
    printf("%s\n", $příkaz);
    exit();
}

# 7. Akce "P" (vypsat seznam prohledávaných cest)
if ($akce eq "P") {
    foreach my $s (@cesty) {
        fprintf($stdvýstup, "%s\n", $s);
    }
    exit();
}

# 8. Akce "F" (vypsat pomocnou funkci)
if ($akce eq "F") {unshift(@argumenty, "pomocné-funkce")}

# 9. Vyhledat skript
$i = 1;
my $skriptSCestou = vyhledatSkript($argumenty[0], @cesty);

# 10. Ostatní akce

if ($akce eq "r") { # spustit skript
    $skriptSCestou ne "" or die("lkk: Skript či úryvek ".$argumenty[0]." nenalezen!");
    printf("exec %s", $skriptSCestou);
    shift(@argumenty);
    foreach my $parametr (@argumenty) {
        printf(" %s", doApostrofů($parametr));
    }
    put("\n");

} elsif ($akce eq "e") { # editovat skript
    if ($skriptSCestou ne ($proměnnáDataHome."/lkk/skripty/".$argumenty[0])) {
        printf("mkdir -pv %s && ", doApostrofů($proměnnáDataHome."/lkk/skripty"));
        if ($skriptSCestou ne "") {
            # skript nalezen => zkopírovat se zachováním práv
            printf("cp -T -- %s %s && ", doApostrofů($skriptSCestou), doApostrofů($proměnnáDataHome."/lkk/skripty/".$argumenty[0]));
            $skriptSCestou = $proměnnáDataHome."/lkk/skripty/".$argumenty[0];
        } elsif (!test("-e ".doApostrofů($proměnnáDataHome."/lkk/skripty/".$argumenty[0]))) {
            # skript neexistuje
            $skriptSCestou = $proměnnáDataHome."/lkk/skripty/".$argumenty[0];
            printf("%s %s && ", $přepínačBash ? "printf '#!/bin/bash\\n' >" : "touch --" , doApostrofů($skriptSCestou));
            $přepínačJenSpustitelné and printf("chmod a+x -- %s && ", doApostrofů($skriptSCestou));
        } else {
            $skriptSCestou = $proměnnáDataHome."/lkk/skripty/".$argumenty[0];
        }
    }
    printf("exec %s %s\n", doApostrofů($proměnnáEditor), doApostrofů($skriptSCestou));

} elsif ($akce eq "f") { # najít skript
    $skriptSCestou ne "" or exit(1);
    fprintf($stdvýstup, "%s\n", $skriptSCestou);

} elsif ($akce eq "p") { # vypsat skript
    $skriptSCestou ne "" or die("lkk: Skript či úryvek ".$argumenty[0]." nenalezen!");
    printf("exec cat %s\n", doApostrofů($skriptSCestou));

} elsif ($akce eq "F") { # vypsat pomocnou funkci
    $skriptSCestou ne "" or die("lkk: Skript \"pomocné-funkce\" nenalezen!");
    if (!defined($argumenty[1]) || $argumenty[1] eq "") {
        # vypsat všechny pomocné funkce
        printf("exec egrep -v '^#' %s\n", doApostrofů($skriptSCestou));
    } else {
        # vypsat jednu pomocnou funkci
        $argumenty[1] =~ /^lkk_/ or $argumenty[1] = "lkk_".$argumenty[1];
        $i = 1;
        my ($začátek, $konec) = (-1, -1);
        my $f = undef;
        otevřít(\$f, $skriptSCestou) or die("lkk: Nemohu otevřít ".$skriptSCestou);
        binmode($f, ":utf8");
        while (defined($s = readline($f))) {
            chomp($s);
            $začátek == -1 && $s eq ("#začátek ".$argumenty[1]) and $začátek = $i;
            if ($konec == -1 && $s eq ("#konec ".$argumenty[1])) {
                $konec = $i;
                $konec - $začátek > 1 or die("lkk: Pomocná funkce ".$argumenty[1]." je prázdná!");
                printf("exec sed -n %d,%dp %s\n", $začátek + 1, $konec - 1, doApostrofů($skriptSCestou));
                close($f);
                exit();
            }
            ++$i;
        }
        close($f);
        die("lkk: Pomocná funkce ".$argumenty[1]." nenalezena!");
    }

} elsif ($akce eq "t") { # existuje skript?
    exit($skriptSCestou eq "" ? 1 : 0);

} else {
    die("lkk: Nepodporovaná akce \"".$akce."\"!");
}

# Obecné funkce
sub alength {return scalar(@ARG)}
sub fprint {my $soubor = shift(@ARG); return print($soubor @ARG);}
sub fprintf {my $soubor = shift(@ARG); return printf($soubor @ARG);}
sub fput {local $OFS = ""; local $ORS = ""; my $soubor = shift(@ARG); return print($soubor @ARG);}
sub put {local $OFS = ""; local $ORS = ""; return print(@ARG);}

sub typy
{
    return join("", map {
        my $r;
        return !defined($ARG) ? "u" :
            !($r = ref($ARG)) ? "s" :
            $r =~ /^(SCALAR|ARRAY|HASH|CODE|Regexp)$/ ? substr($r, 0, 1) :
            $r eq "GLOB" ? "F" :
            ":${r}:";
    } @ARG);
}

# Konkrétní funkce

# doApostrofů(s) => nahradí v řetězci apostrofy za „'\''“ a celý řetězec umístí do apostrofů.
sub doApostrofů {
    typy(@ARG) eq "s" or die("Chybné parametry: " . typy(@ARG));
    return "'".($ARG[0] =~ s/'/'\\''/r)."'";
}

# která(vzor, ...) => vrátí index prvního parametru po vzoru, který se s ním textově shoduje, nebo 0, pokud takový nebude nalezen
sub která {
    typy(@ARG) =~ /^s+$/ or die("Chybné parametry: " . typy(@ARG));
    my $vzor = shift(@ARG);
    my $i;
    for ($i = 0; $i < alength(@ARG); ++$i) {
        if ($vzor eq $ARG[$i]) {return $i + 1}
    }
    return 0;
}

# načíst(příkaz) => vrátí dvojici (návratová hodnota, výstup) získanou spuštěním zadaného příkazu
sub načíst {
    typy(@ARG) eq "s" or die("Chybné parametry: " . typy(@ARG));
    local $RS = undef;
    my $f;
    otevřít(\$f, "-|:utf8", "sh", "-c", $ARG[0]) or die("lkk: Chyba při spouštění příkazu \"".$ARG[0]."\"");
    my $výsledek = readline($f);
    $RS = "\n";
    while ($ARG[1] and chomp($výsledek)) {}
    close($f);
    return ($CHILD_ERROR >> 8, $výsledek);
}

# otevřít(\$proměnná, ...) => Zavolá interní funkci „open“ a získaný odkaz na soubor přiřadí do odkazované proměnné.
sub otevřít {
    typy(@ARG) =~ /^S(s([sS].*)?)?/ or die("Chybné parametry: " . typy(@ARG));
    my $uk = shift(@ARG);
    my $vysledek;
    if (alength(@ARG) == 0) {
        $vysledek = open(my $f);
        $$uk = $f;
    } else {
        my $p1 = shift(@ARG);
        if (alength(@ARG) == 0) {
            $vysledek = open(my $f, $p1);
            $$uk = $f;
        } else {
            my $p2 = shift(@ARG);
            if (alength(@ARG) == 0) {
                $vysledek = open(my $f, $p1, $p2);
                $$uk = $f;
            } else {
                $vysledek = open(my $f, $p1, $p2, @ARG);
                $$uk = $f;
            }
        }
    }
    return $vysledek;
}

# proměnnáProstředí(proměnná, náhradníHodnota?) => načte hodnotu proměnné prostředí; pokud taková neexistuje nebo je prázdná, vrátí náhradní hodnotu
sub proměnnáProstředí {
    typy(@ARG) =~ /^s[su]?$/ or die("Chybné parametry: " . typy(@ARG));
    return exists($ENV{$ARG[0]}) && $ENV{$ARG[0]} ne "" ? $ENV{$ARG[0]} : $ARG[1];
}

# test(text) => spustí v bashi příkaz „test“ s uvedenými parametry a vrátí invertovanou návratovou hodnotu (tzn. 1, pokud test uspěje)
sub test {
    typy(@ARG) eq "s" or die("Chybné parametry: " . typy(@ARG));
    return !(system("test ".$ARG[0]) >> 8);
}

# vyhledatSkript(skript, cesty...) => prochází uvedené cesty a snaží se najít vyhovující skript;
#       pokud ho najde, vrátí jeho absolutní cestu; pokud ne, vrátí prázdný řetězec
sub vyhledatSkript {
    typy(@ARG) =~ /^s+$/ or die("Chybné parametry: " . typy(@ARG));
    my $skript = shift(@ARG);
    foreach my $cesta (@ARG) {
        my ($kód, $výstup) = načíst(($cesta ne "" ? "cd ".doApostrofů($cesta)." 2>/dev/null && " : "")."realpath -eq ".doApostrofů($skript), 1);
        my $nováCesta = doApostrofů($výstup);
        if ($kód == 0 && test("-f ".$nováCesta." -a -r ".$nováCesta.($přepínačJenSpustitelné ? " -a -x ".$nováCesta : ""))) {
            return $výstup;
        }
    }
    return "";
}
