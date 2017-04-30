import os
import signal
import sys

os.system("sage --preparse nsa.sage")
os.system("cp nsa.sage.py nsa.py")

import nsa

nbits = 512

print "Generating your SUPER SECURE CURVE"
sys.stdout.flush()
A, B, P, Q, p = nsa.gen(nbits)

s = nsa.r(1, p)

def prng():
    global s
    global P
    global Q
    x, y = (s * P).xy()
    s = ZZ(x)
    x, y = (s * Q).xy()
    b = hex(ZZ(x)).replace("0x", "").replace("L", "")
    # cut the 8 MSBs
    b = b.zfill(nbits // 4)[-(nbits - 8) // 4:]
    return int(b, 16)

print "PRNG parameters for E/Fp:"
print "a = {}".format(A)
print "b = {}".format(B)
print "p = {}".format(p)
print "P = {}".format(P.xy())
print "Q = {}".format(Q.xy())
print ""
sys.stdout.flush()

signal.alarm(600)

try:
    while True:
        sys.stdout.write("Would you like a random number? (y/n) ")
        sys.stdout.flush()
        inp = raw_input()
        if inp == "y":
            print prng()
        elif inp == "n":
            break
        else:
            sys.stdout.write("Please enter only 'y' or 'n'")
            sys.stdout.flush()
    sys.stdout.write("What number am I thinking of? ")
    sys.stdout.flush()
    rr = prng()
    print rr
    guess = int(raw_input())
    if guess == rr:
        print "You win!"
        with open("flag.txt", "r") as f:
            print f.readline()
            sys.stdout.flush()
    else:
        print "You lose! :("
        sys.stdout.flush()
except AlarmInterrupt:
    print "You're too slow!"
    sys.stdout.flush()
