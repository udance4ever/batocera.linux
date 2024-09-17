#!/usr/bin/env python3

# Sept 14, 2024
#
# NOTE: this script assumes a single clean build session (not a running log of multiple builds)

import sys
import os
import csv
import time

# $$ what is shortland to assign a default value if no parameter passed in?
arch = sys.argv[1]

logFile = "output/{}/build/build-time.log".format(arch)

#print("looking for", logFile)

tracker = {}
timestamp = {}

if os.path.exists(logFile):
#    print("found", logFile)
    openLogFile = open(logFile, "r")
    with openLogFile:
        timeList = csv.reader(openLogFile, delimiter=':',skipinitialspace=True)
        for entry in timeList:
#            print(entry)
            (epoch, state, phase, package) = entry;
#            print("{} in {}: {}".format(package, phase, state))
            if "build" in phase:
                tracker[package] = state
                timestamp[package] = epoch.split('.')[0]

#print(tracker)

print("active (or incomplete):")

count = 0
for package in tracker:
    if "start" in tracker[package]:
        count += 1

        # calc how many seconds ago
        diff = int(time.time()) - int(timestamp[package])
#        print(diff)

# https://www.epochconverter.com
#        date = time.strftime("%a, %d %b %Y %H:%M:%S +0000", time.localtime(epoch))
        date = time.strftime("%a, %d %b %Y %H:%M:%S", time.localtime(int(timestamp[package])))

        print("{0}. {1:43} ({2} seconds ago ({3}))".format(count,package,diff,date))
