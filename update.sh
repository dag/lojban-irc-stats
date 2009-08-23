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

rm -f irclogs.zip all_logs.txt lojban.log index.html

echo Downloading logs...
wget -q http://lojban.org/resources/irclog/irclogs.zip

echo Extracting logs...
unzip -q irclogs.zip

echo Processing logs...
perl -ne'$_=~/(\d\d\:\d\d).*(<.+?> .+)/&&print "$1 $2\n"' < all_logs.txt > lojban.log

echo Cleaning up...
rm -f pisg-$PISG.zip irclogs.zip all_logs.txt

echo Generating statistics...
pisg/pisg -s -co $CONF

