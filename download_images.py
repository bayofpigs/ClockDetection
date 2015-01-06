#!/usr/bin/env python
#NOTE: This file is not actually being used right now to download images. Oh well...

import os
import urllib
import sys
import re

#Read URL's line by line from stdin, up to MAX_URLs, and save the result to OUTPUT_DIRECTORY with names like 57.jpg
#Note that you must make the OUTPUT_DIRECTORY before running

MAX_URLs = 10
OUTPUT_DIRECTORY = './images/'

for i in range(MAX_URLs):
	url = sys.stdin.readline()
	if url == '':
		break
	file_name = OUTPUT_DIRECTORY + ('%03d' % i) + re.findall('\.[^/]+$', url)[0]
	print url, file_name
	urllib.urlretrieve(url, file_name.strip())
