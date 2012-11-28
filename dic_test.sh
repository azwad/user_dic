#!/bin/sh

DICDIR='/usr/local/lib/mecab/dic/naist-jdic'
WORKDIR=`pwd`

chdir '/usr/local/etc/'

#cp -f mecabrc mecabrc.ipa
cp -f mecabrc mecabrc.org
if [ -e mecabrc.naist ]; then
	rm mecabrc.naist
fi

echo 'dicdir = /usr/local/lib/mecab/dic/naist-jdic' >> mecabrc.naist
echo 'userdic = /usr/local/lib/mecab/dic/naist-jdic/hatenakeyword_euc-jp_user.dic, /usr/local/lib/mecab/dic/naist-jdic/wikipediakeyword_euc-jp_user.dic' >> mecabrc.naist

#test
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
