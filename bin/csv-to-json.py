#!/usr/bin/env python
import csv, json, sys;

reader = csv.DictReader(sys.stdin)

for r in reader:
    print(dict(r))
    print(json.dumps([dict(r)]))
