#!/bin/bash

echo "Content-type: text/html"
echo ""



echo "<pre>"

printf "%b " $(cat | sed 's/^code=//' | sed 's/+/ /g' | sed 's/%0D%0A/%0A/g' | sed 's/%/\\x/g') | ./compiler

echo "</pre>"
