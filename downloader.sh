#!/usr/bin/env bash
#########################################################################
#	  2018-06-21	
#	  2021-08-23
#									#
#	script :	downloader.sh					#
#	Function : downloads top 100 - monthly songs from djpunjab 	#
#	 								#
#	- Parameters : $1 = destination folder				#
#########################################################################


dest=/volume1/music/downloads_djpunjab
if [ ! -f downloads_log ];then
        touch downloads_log
fi
curl -k -L https://djpunjab.fm/page/top20.html >> list_page
grep -oP "single.*?html" list_page > b
mv b list_page
i=1
while read list_page; do
        echo $i
        echo $list_page
        curl -k -L https://djpunjab.fm/$list_page >> song_page
        echo $song_page
        i=$((i+1))
	echo "--------------------------------------------"
done <list_page
grep -oP "........320.*?mp3" song_page > links
rm list_page
rm song_page
downloads=0
skipped=0
echo $links
while read link; do
        echo $link
        if grep -q "$link" downloads_log;then
                echo "--------------------------------"
                echo "Previously downloaded"
                echo "--------------------------------"
                skipped=$((skipped+1))
        else
                wget -nc "$link" -P "$dest"
                downloads=$((downloads+1))
                if [ $? -eq 0 ];then
                        echo $link >> downloads_log
                fi
        fi
done <links
echo "Downloads : $downloads  , Skipped : $skipped"
rm links
