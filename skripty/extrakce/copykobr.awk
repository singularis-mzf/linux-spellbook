# Linux Kniha kouzel, skript extrakce/copykobr.awk
# Copyright (c) 2019 Singularis <singularis@volny.cz>
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

BEGIN {
	AKT = 0;
	split("", DOVOLENE_OBRAZKY);
	if (ARGC > 2) {
		for (i = 2; i < ARGC; ++i) {
			DOVOLENE_OBRAZKY[ARGV[i]] = 1;
		}
		ARGC = 2;
	}
}

function Uzavrit() {
	POLE = "";
	DATA[AKT ":OK"] = (DATA[AKT ":Files"] != "" && DATA[AKT ":Copyright"] != "" && DATA[AKT ":License"] != "");
	++AKT;
}

/^$/ {
	Uzavrit();
	next;
}
/^(Files|Copyright|License|Source): / {
	if (/^Files: / && !/^Files: obrazky\//) {
		next;
	}
	POLE = substr($0, 1, index($0, ":") - 1);
	match($0, /^[A-Za-z]*: */);
	$0 = substr($0, RLENGTH + 1);
}

/^ [^ ]/ {
	POLE = "Info";
	$0 = substr($0, 2);
	if ($0 == ".") {
		$0 = "";
	}
}

POLE != "" {
	if (match($0, /^ */) && RLENGTH > 0) {
		$0 = substr($0, 1 + RLENGTH);
	}
	if (DATA[AKT ":" POLE] != "") {
		DATA[AKT ":" POLE] = DATA[AKT ":" POLE] "\n";
	}
	DATA[AKT ":" POLE] = DATA[AKT ":" POLE] $0;
}


#function Tiskni(i, pole,   key) {
#	if (pole == "") {
#		print "---------";
#		Tiskni(i, "Files");
#		Tiskni(i, "Copyright");
#		Tiskni(i, "License");
#		Tiskni(i, "Info");
#		Tiskni(i, "Source");
#	} else {
#		key = i ":" pole;
#		print "DATA[" key "] = \"" DATA[key] "\"";
#	}
#}

END {
	Uzavrit();

	for (i = 0; i < AKT; ++i) {
		if (DATA[i ":OK"]) {
			split(DATA[i ":Files"], soubory, "\n");
			for (ind in soubory) {
				if (soubory[ind] in DOVOLENE_OBRAZKY) {
					OBRAZKY[soubory[ind]] = i;
				}
			}
		}
	}

	n = asorti(OBRAZKY, PODLE_ABECEDY);

	for (key in DATA) {
		gsub(/&/, "\\&amp;", DATA[key]);
		gsub(/</, "\\&lt;", DATA[key]);
		gsub(/>/, "\\&gt;", DATA[key]);
		gsub(/ /, "\\&nbsp;", DATA[key]);
	}

	for (i = 1; i <= n; ++i) {
		soubor = PODLE_ABECEDY[i];
		j = OBRAZKY[soubor];
		copyright = DATA[j ":Copyright"];
		licence = DATA[j ":License"];
		zdroj = DATA[j ":Source"];
		info = DATA[j ":Info"];

		gsub(/^|\n/, "&Copyright (c) ", copyright);

		print "<dt><a href=\"" soubor "\">" soubor "</a></dt>";
		print "<dd><pre>" copyright "\nLicence: " licence;
		if (zdroj != "") {
			print "Zdroj: " zdroj;
		}
		if (info != "") {
			print info;
		}
		print "</pre></dd>";
	}

	exit;
	for (i = 0; i < AKT; ++i) {
		if (DATA[i ":OK"]) {
			Tiskni(i);
		}
	}
}

