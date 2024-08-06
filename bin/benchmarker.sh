#!/bin/bash

readonly DIR="$HOME/work/sunaba/private-isu"

# ログファイルを初期化
cp /dev/null $DIR/webapp/logs/nginx/access.log
cp /dev/null $DIR/webapp/logs/nginx/error.log
cp /dev/null $DIR/webapp/logs/mysql/mysql-slow.log
# 画像ファイルを初期化
rm -rf $DIR/webapp/public/image/*

echo ""
echo "----- benchmarker: start -----"
echo ""

# ベンチマークを実行
$DIR/benchmarker/bin/benchmarker -t "http://localhost" -u $DIR/benchmarker/userdata | jq | tee $DIR/webapp/logs/analysis/benchmarker/result_$(date +%Y%m%d%H%M).txt

# 計測結果を解析して、ログを出力
alp json --sort sum -r -m "/posts/[0-9]+,/@/w\+,/image/\d+" < $DIR/webapp/logs/nginx/access.log > $DIR/webapp/logs/analysis/alp/result_$(date +%Y%m%d%H%M).txt
pt-query-digest $DIR/webapp/logs/mysql/mysql-slow.log > $DIR/webapp/logs/analysis/pt-query-digest/result_$(date +%Y%m%d%H%M).txt

echo ""
echo "----- benchmarker: end -----"
echo ""
