#!/bin/sh

WORKDIR=`pwd`

chdir ${WORKDIR}/euc-jp_dic

/usr/local/libexec/mecab/mecab-dict-index -d /usr/local/lib/mecab/dic/naist-jdic -u hatenakeyword_euc-jp_user.dic -f euc-jp -t euc-jp hatenakeyword_euc-jp_dic.csv
/usr/local/libexec/mecab/mecab-dict-index -d /usr/local/lib/mecab/dic/naist-jdic -u wikipediakeyword_euc-jp_user.dic -f euc-jp -t euc-jp wikipediakeyword_euc-jp_dic.csv
