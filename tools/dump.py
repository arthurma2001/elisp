#! /usr/bin/python

import sys
import time
def test01 ():
    k = 0
    try:
        buff = ''
        while True:
            buff += sys.stdin.read(1)
            if buff.endswith('\n'):
                print "XXXX: " + buff[:-1]
                buff = ''
                k = k + 1
    except KeyboardInterrupt:
        sys.stdout.flush()
        pass
    print k

def test02 ():
    for line in sys.stdin:
        line = line.replace ('\n', '');
        print "XXXX: " + line

# test01 ();        
test02 ();        
