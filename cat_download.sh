#!/bin/sh  

#########################################################  
# 使い方  
# 1. brew install nkf でエンコードツール nkf をインストール  
# 2. apikey と engineid を設定  
# 3. .zshrc などに export PATH=$HOME/bin:$PATH でパスを通す  
# 4. imget "検索ワード" "保存するフォルダ名" で実行  
#########################################################  

apikey="AIzaSyAgUhv2GLmeWsQ5-jvqzwZTmjB6or1DB4c"
engineid="009348016860071911617:zv4bvlyufqj"

# １個目の引数にエンコード処理を施して$keywordに代入  
keyword=`cat query.txt`

# ２個目の引数の名前のディレクトリを作って移動
dir="./cat_imgs"
mkdir $dir
cd $dir

start=1
results=`mktemp`
list_url=`mktemp`

# keywordで画像検索して10回リクエストする、画像リンクを$list_urlに格納  
while [ $start -lt 100 ]
do  
    curl "https://www.googleapis.com/customsearch/v1?key=${apikey}&cx=${engineid}&searchType=image&q=${keyword}&safe=off&lr=lang_ja&num=10&start=${start}" > $results  

    cat $results | grep "link" | sed -e 's/^[ \t]*"link": "//' -e 's/",//g' | sed 1d >> $list_url  

    start=`expr $start + 10`  
done  

# 画像リンクから画像を一気にダウンロード  
wget -T 30 -t 1 -i $list_url  

# 全ての画像に実行権限を与えて、拡張子がおかしいものを直す  
chmod u+rwx *  
find . -name '*.jpg[.?]*' | sed -e "s/^\(.*\)\.jpg[.?].*$/mv '&' \1\.jpg/g" | sh  
find . -name '*.png[.?]*' | sed -e "s/^\(.*\)\.png[.?].*$/mv '&' \1\.png/g" | sh  
find . -name '*.jpeg[.?]*' | sed -e "s/^\(.*\)\.jpeg[.?].*$/mv '&' \1\.jpeg/g" | sh  
find . -name '*.gif[.?]*' | sed -e "s/^\(.*\)\.gif[.?].*$/mv '&' \1\.gif/g" | sh  

# 画像ファイル以外は削除  
find . -not -name "*.jpg" -a -not -name "*.png" -a -not -name "*.jpeg" -a -not -name "*.gif" | xargs rm  
rm $results $list_url  