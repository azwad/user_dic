#!/bin/sh

DICDIR='/usr/local/lib/mecab/dic/naist-jdic'
WORKDIR=`pwd`
rm -f ${WORKDIR}/download_dic/*
rm -f ${WORKDIR}/utf8_dic/*
rm -f ${WORKDIR}/euc-jp_dic/*
chdir ${WORKDIR}/download_dic

wget  http://download.wikimedia.org/jawiki/latest/jawiki-latest-all-titles-in-ns0.gz -O jawiki-latest-all-titles-in-ns0.gz
wget  http://d.hatena.ne.jp/images/keyword/keywordlist_furigana.csv -O keywordlist_furigana.csv 

gzip -df jawiki-latest-all-titles-in-ns0.gz

cp jawiki-latest-all-titles-in-ns0 ${WORKDIR}/utf8_dic/wikipediakeyword_utf8.txt
cat keywordlist_furigana.csv | nkf -Ew > ${WORKDIR}/utf8_dic/hatenakeyword_utf8.txt

chdir ${WORKDIR}

perl  KeyWordCreat2Dic.pl 'hatena'
perl  KeyWordCreat2Dic.pl 'wikipedia'

chdir ${WORKDIR}/utf8_dic

#convert to EUC-JP

cat hatenakeyword_utf8_dic.csv | nkf -We > ${WORKDIR}/euc-jp_dic/hatenakeyword_euc-jp_dic.csv
cat wikipediakeyword_utf8_dic.csv | nkf -We > ${WORKDIR}/euc-jp_dic/wikipediakeyword_euc-jp_dic.csv

#compile http://mecab.googlecode.com/svn/trunk/mecab/doc/dic.html

chdir ${WORKDIR}/euc-jp_dic

/usr/local/libexec/mecab/mecab-dict-index -d /usr/local/lib/mecab/dic/naist-jdic -u hatenakeyword_euc-jp_user.dic -f euc-jp -t euc-jp hatenakeyword_euc-jp_dic.csv
/usr/local/libexec/mecab/mecab-dict-index -d /usr/local/lib/mecab/dic/naist-jdic -u wikipediakeyword_euc-jp_user.dic -f euc-jp -t euc-jp wikipediakeyword_euc-jp_dic.csv

chdir ${DICDIR}

if [ -e hatenakeyword_euc-jp_user.dic ]; then
	mv hatenakeyword_euc-jp_user.dic hatenakeyword_euc-jp_user.dic.old
fi

if [ -e wikipediakeyword_euc-jp_user.dic ]; then
	mv wikipediakeyword_euc-jp_user.dic wikipediakeyword_euc-jp_user.dic.old
fi

chdir ${WORKDIR}/euc-jp_dic

cp hatenakeyword_euc-jp_user.dic wikipediakeyword_euc-jp_user.dic ${DICDIR}

chdir '/usr/local/etc/'

#cp -f mecabrc mecabrc.ipa
cp -f mecabrc mecabrc.org
if [ -e mecabrc.naist ]; then
	rm mecabrc.naist↲
fi

echo 'dicdir = /usr/local/lib/mecab/dic/naist-jdic' >> mecabrc.naist
echo 'userdic = /usr/local/lib/mecab/dic/naist-jdic/hatenakeyword_euc-jp_user.dic, /usr/local/lib/mecab/dic/naist-jdic/wikipediakeyword_euc-jp_user.dic' >> mecabrc.naist

#test↲
TESTWORD="今日もよい天気 a-10が空を飛んでいる。JR東日本の電車が走っている。　あきる野市民球場では愛国者の日が祝われている。"

cp -f mecabrc.ipa mecabrc

echo "TEST\n" >> ${WORKDIR}/test
echo "original ipadic\n" >> ${WORKDIR}/test
echo ${TESTWORD} | nkf -We | mecab | nkf -Ew >> ${WORKDIR}/test

cp -f mecabrc.naist mecabrc
echo "use naist-jdic with user dic\n" >> ${WORKDIR}/test
echo ${TESTWORD} | nkf -We | mecab | nkf -Ew >> ${WORKDIR}/test

cp -f mecabrc.org mecabrc

chdir ${WORKDIR}

cat test | less


