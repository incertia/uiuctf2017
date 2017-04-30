msg = "this challenge was supposed to be babyrsa but i screwed up and now i have to redo the challenge.\nhopefully this challenge proves to be more worthy of 250 points compared to the 200 points i gave out for babyrsa :D :D :D\nyour super secret flag is: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nyou know what i'm going to add an extra line here just to make your life miserable so deal with it"
flag = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
m = int(msg.encode("hex"), 16)
f = int(flag.encode("hex"), 16)
index = msg.find(flag)
shift = len(msg) - index - len(flag)
shift *= 8

execfile("paparsa.txt")
mm = m - 2^shift * f

x, = PolynomialRing(Zmod(n), 'x', implementation='NTL').gens()
poly = (mm + 2^shift * x)^e - c
poly = poly.monic()

r = poly.small_roots(epsilon=1/25, algorithm='fpLLL:proved', fp='rr')[0]
mm += 2^shift * r
print hex(int(mm)).replace("0x", "").replace("L", "").decode("hex")
