#!/bin/bash

readonly DIR="$HOME/work/sunaba/private-isu"

cp /dev/null $DIR/webapp/logs/nginx/access.log
cp /dev/null $DIR/webapp/logs/nginx/error.log
cp /dev/null $DIR/webapp/logs/mysql/mysql-slow.log

echo ""
echo "----- benchmarker: start -----"
echo ""

$DIR/benchmarker/bin/benchmarker -t "http://localhost" -u $DIR/benchmarker/userdata | tee $DIR/webapp/logs/analysis/benchmarker/result_$(date +%Y%m%d%H%M).txt

echo ""
echo "----- analyze access-logs: start -----"
echo ""

alp json --sort sum -r -m "/posts/[0-9]+,/@/w\+,/image/\d+" < $DIR/webapp/logs/nginx/access.log | tee $DIR/webapp/logs/analysis/alp/result_$(date +%Y%m%d%H%M).txt

echo ""
echo "----- analyze slow-query-logs: start -----"
echo ""

pt-query-digest $DIR/webapp/logs/mysql/mysql-slow.log | tee $DIR/webapp/logs/analysis/pt-query-digest/result_$(date +%Y%m%d%H%M).txt

echo ""
