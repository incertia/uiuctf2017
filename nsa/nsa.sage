import struct
import os

def r(j, k):
    return int(os.urandom(k.nbits()).encode("hex"), 16) % (k - j) + j

def gen(nbits):
    j = -262537412640768000
    D = 163
    t = 1

    nb = ((2 ^ nbits) // D).nbits() // 2 + 2

    while True:
        s = r(2^(nb - 1), 2^(nb)) | 1
        p = (D * s^2 + t^2)

        if p % 4 != 0:
            continue

        p = p // 4

        # print "p = {}".format(p)

        if is_prime(p) and p.nbits() == nbits:
            # print "found p = {}".format(p)
            break

    k = Mod(Mod(j, p) * inverse_mod(1728 - j, p), p)
    A = 3 * k
    B = 2 * k

    E = EllipticCurve(GF(p), [A, B])
    N = E.order()

    if N != p:
        # print "twisting..."
        while True:
            c = r(1, p)
            if power_mod(c, (p - 1) // 2, p) != 1:
                break
        A = A * c^2
        B = B * c^3
        E = EllipticCurve(GF(p), [A, B])

    assert E.order() == p

    n = r(2 ^ (nbits - 1), p)
    P = E.gens()[0]
    Q = n * P
    return (A, B, P, Q, p)
