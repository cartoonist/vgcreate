#!/bin/bash
PARALLEL=parallel.pl

if [ -z "$1" ]; then
	echo "[ERROR] too few argument."
	echo "Usage: $0 TEXT_FILE [TEXT_FILE ...]"
	exit 1
fi

echo -n "$@" | $PARALLEL -d" " 'protoc --encode=vg.Graph vg.proto < {} > .{.}.pb'
echo -n "$@" | $PARALLEL -d" " 'cat <( varint encode $(stat --printf="%s" .{.}.pb) ) .{.}.pb > .{.}.un.vg'
echo -n "$@" | $PARALLEL -d" " 'cat .{.}.un.vg >> .all.un.vg'
cat <( varint encode "$#" ) .all.un.vg | gzip -c - > all.vg
rm -f .*.pb .*.un.vg
