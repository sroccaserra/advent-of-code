from functools import reduce


def chinese_remainder(n, a):
    """
    - https://en.wikipedia.org/wiki/Chinese_remainder_theorem
    """
    sum = 0
    prod = reduce(lambda a, b: a*b, n)
    for n_i, a_i in zip(n, a):
        p = prod // n_i
        sum += a_i * mul_inv(p, n_i) * p
    return sum % prod


def mul_inv(a, b):
    """
    - https://en.wikipedia.org/wiki/Modular_multiplicative_inverse
    - https://fr.wikipedia.org/wiki/Petit_th%C3%A9or%C3%A8me_de_Fermat
    """
    return pow(a, b-2, b)


print(chinese_remainder([19, 37, 599, 29, 17, 23, 761, 41, 13],
                        [ 0, 37-13,  599-19, 29-21, 2*17-36, 2*23-42,  761-50, 2*41-60, 5*13-63]))


##
# Autres explorations


def bezout(a, b):
    """
    Algorithme d’Euclide étendu qui, en plus du pgcd, donne des coefficients
    d’une relation de Bézout, c’est-à-dire des entiers u et v tels que

        au+bv = pgcd(a,b)

    Renvoie un tuple contenant (pgcd, u, v)

    - https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
    - https://en.wikipedia.org/wiki/B%C3%A9zout%27s_identity
    """
    s, t, u, v = 1, 0, 0, 1
    while b != 0:
        q = a // b
        a, s, t, b, u, v = b, u, v, a - q * b, s - q * u, t - q * v
    return (a, s, t) if a > 0 else (-a, -s, -t)     # Le pgcd doit être positif
