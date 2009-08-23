#!/bin/sh

PISG=0.72
CONF=pisg.cfg

if [ ! -d pisg ]; then
    echo Downloading pisg...
    wget -q http://downloads.sourceforge.net/project/pisg/pisg/$PISG/pisg-$PISG.zip
    echo Extracting pisg...
    unzip -q pisg-$PISG.zip
    mv pisg-$PISG pisg
fi

rm -f index.html

echo Downloading logs...
rm -rf logs
mkdir -p logs
wget -q -O - "http://lojban.org/resources/irclog/lojban/$(date +%Y_%m)" |
    perl -ne'$_=~/href="(.+?\.txt)"/&&print"http://lojban.org/resources/irclog/lojban/$1\n"' |
    xargs wget -q -P logs

echo Processing logs...
for f in logs/*; do
    cut -d' ' -f4- $f > $f.tmp
    mv $f.tmp $f
done

echo Cleaning up...
rm -f pisg-$PISG.zip

echo Generating statistics...
pisg/pisg -s -co $CONF

