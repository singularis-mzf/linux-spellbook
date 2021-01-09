# Linux Kniha kouzel, Dockerfile
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

FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive TZ=Europe/Prague
WORKDIR /root
RUN printf -- 'deb http://%s/ubuntu/ focal%s main universe\n' archive.ubuntu.com '' security.ubuntu.com -security cz.archive.ubuntu.com -updates >/etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y apt-utils perl-modules-5.30 perl-base && \
  apt-get upgrade -y && \
  apt-get install -y git make gawk xxd imagemagick librsvg2-bin qrencode texlive-xetex texlive-lang-czechslovak t1-cyrillic lmodern language-pack-cs
ENV LANG=cs_CZ.UTF-8
RUN git clone -b stabilní https://github.com/singularis-mzf/linux-spellbook.git && \
  git -C linux-spellbook config --local core.quotePath false
# odkomentujte a doplňte svoje oblíbené textové editory a další potřebné pomůcky:
#RUN apt-get install -y vim
WORKDIR /root/linux-spellbook
