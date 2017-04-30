# BULLJOG

We named this challenge after BULLRUN, a NSA program where supposedly one part
of it was to backdoor DUAL\_EC\_DRBG.

We generate arbitrary curves over `Fp` such that `#E/Fp = p`, which makes the
ECDLP easy with the complex multiplication method. See `nsa.sage`.

`smart.sage` is a POC that takes the PRNG from from `bulljog.sage` and breaks
it.

We eventually had to decrease the search space from `2**16` to `2**8` because of
time constraints on the CTF challenge, but the same idea of attack still
applies, it would just take significantly longer.
