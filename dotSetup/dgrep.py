#!/usr/bin/python

from subprocess import check_output
import argparse
import sys
import re


parser = argparse.ArgumentParser(description="grep for docker containers by name")
parser.add_argument('name', action="store", help="name of the container to search for")
args = parser.parse_args()

lines = check_output('docker ps', shell=True).split("\n")
matching_lines = []
for line in lines:
    if args.name in line:
        matching_lines.append(line)

for line in matching_lines:
    print(re.match(r"(\S*)\s+.*", line).groups(0)[0])
