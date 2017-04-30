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
    b = b.zfill(nbits // 4)[-(nbits - 8) // 4:]
    return int(b, 16)

def HenselLift(P, p, prec=64):
    E = P.curve()
    Eq = E.change_ring(QQ)
    Ep = Eq.change_ring(Qp(p, prec))
    x_P, y_P = P.xy()
    x_l = ZZ(x_P)
    y_l = ZZ(y_P)
    x, y, a1, a2, a3, a4, a6 = var('x,y,a1,a2,a3,a4,a6')
    f(a1, a2, a3, a4, a6, x, y) = y^2 + a1 * x * y + a3 * y - x^3 - a2 * x^2 - a4 * x - a6
    g(y) = f(ZZ(Eq.a1()), ZZ(Eq.a2()), ZZ(Eq.a3()), ZZ(Eq.a4()), ZZ(Eq.a6()), ZZ(x_P), y)
    gd = g.diff()
    for i in xrange(1, prec):
        ui = ZZ(gd(y=y_l))
        u = ui.inverse_mod(p^i)
        y_l = y_l - u * g(y_l)
        y_l = ZZ(Mod(y_l, p ^ (i + 1)))
    y_l = y_l + O(p^prec)
    return Ep([x_l, y_l])

def Smart(P, Q, p, prec=64):
    E = P.curve()
    Eqq = E.change_ring(QQ)
    Eqp = Eqq.change_ring(Qp(p, prec))

    P_Qp = HenselLift(P, p, prec)
    Q_Qp = HenselLift(Q, p, prec)

    pP = p * P_Qp
    pQ = p * Q_Qp

    x_P, y_P = pP.xy()
    x_Q, y_Q = pQ.xy()

    phi_P = -(x_P / y_P)
    phi_Q = -(x_Q / y_Q)
    k = phi_Q / phi_P
    k = Mod(k, p)
    return ZZ(k)

Px, Py = P.xy()
Qx, Qy = Q.xy()

print "a = {}".format(A)
print "b = {}".format(B)
print "p = {}".format(p)
print "P = ({}, {})".format(Px, Py)
print "Q = ({}, {})".format(Qx, Qy)
K = GF(p)
E = EllipticCurve(K, [A, B])

l = Smart(Q, P, p, prec=128)
assert l * Q == P
r = prng()
rr = prng()
states = []
for n in xrange(2**8):
    x = 2^(nbits - 8) * n + r
    y = K(x^3 + A * x + B)
    X = hex(int(x)).replace("0x", "").replace("L", "")
    y = y.sqrt()
    if y.parent() != K:
        continue
    PP = E.point((x, y))
    QQ = l * PP
    ss, _ = QQ.xy()
    ss = ZZ(ss)
    x, y = (ss * Q).xy()
    b = hex(ZZ(x)).replace("0x", "").replace("L", "")
    # cut the 16 MSBs
    b = b.zfill(nbits // 4)[-(nbits - 8) // 4:]
    b = int(b, 16)
    if b == rr:
        states.append(ss)
        break

rr = prng()

ss = states[0]
x, y = (ss * P).xy()
x, y = (ZZ(x) * Q).xy()
b = hex(ZZ(x)).replace("0x", "").replace("L", "")
# cut the 16 MSBs
b = b.zfill(nbits // 4)[-(nbits - 8) // 4:]
b = int(b, 16)
assert b == rr
print b
