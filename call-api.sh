#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

if [ "$1" == "" ]
then
    echo >&2 "usage: $0 body.json"
    exit 1
fi

bodyJson="$1"

emptyLineNum=$(grep -E --line-number '^$' "$bodyJson" | head -n 1 | cut -f 1 -d ':')

firstLine=$(head -n 1 "$bodyJson")
verb=$(echo -n "$firstLine" | cut -f 1 -d ' ')
url=$(echo -n "$firstLine" | cut -f 2 -d ' ')

#echo "verb=$verb"
#echo "url=$url"

headers=""
if [ "$emptyLineNum" -gt 2 ]; then
    headerLines=$(head -n $(expr $emptyLineNum - 1) "$bodyJson" | tail -n +2)
    headers=$(echo -n "$headerLines" | sed "s/^/-H '/" | sed "s/\$/'/" | tr '\012' ' ')
    #echo "headers: $headers"
fi

tmpfile=$(mktemp /tmp/XXXXXX)
function cleanup {
   rm -f "$tmpfile"
}
trap cleanup EXIT

tail -n +$(expr $emptyLineNum + 1) "$bodyJson" > "$tmpfile"

if [ "$LOAD_TEST" == 1 ]; then
    echo "$headers" | xargs hey -n "$TOTAL_REQS" -c "$CONCURRENCY" -m $verb -D "$tmpfile" "$url" 
else
    echo curl -v -w "\nHTTP %{http_code} time:%{time_total}s\n" -X $verb "$url" -d @"$tmpfile" $headers
    echo "$headers" | xargs curl -v -w "\nHTTP %{http_code} time:%{time_total}s\n" -X $verb "$url" -d @"$tmpfile"
    exit 0
    stdout=$(curl -v -w "\nHTTP %{http_code} time:%{time_total}s\n" -X $verb $headers "$url" -d @"$tmpfile")
    j=$(echo "$stdout"|tail -n2|head -n1)
    s=$(echo "$stdout"|tail -n1);
    o=$(echo "$stdout"|head -n -2);
    echo "$o"; echo "$j"|python -m json.tool 2>/dev/null; echo "$s" 
fi
