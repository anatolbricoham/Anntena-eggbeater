#!/usr/bin/env python3
"""Modelo NEC2 (nec2c) de la antena Eggbeater para satelites (2 m y 70 cm).

Geometria (inspirada en la Eggbeater V2 de EA5WA y en la Eggbeater II de K5OE):
  - Dos lazos rectangulares (ancho W x alto H) cruzados a 90 grados sobre el mastil.
    El lado inferior de cada lazo pasa por el cubo de alimentacion (alli esta el punto de
    alimentacion, en el centro). Los lazos se cruzan arriba y abajo con un desnivel `dz`
    para no tocarse (lo fija el cubo impreso).
  - Reflector: dos varillas cruzadas de longitud Lr a una distancia D bajo los lazos.
  - Arnes: linea de 93 ohm (RG-62) entre los dos puntos de alimentacion; el cable de 50 ohm
    se conecta al lazo A.

Uso como modulo (ver optimize.py) o directo:
  python3 sim/eggbeater.py 145.9
"""
import math, os, re, subprocess, tempfile, cmath

C = 299.792458  # m*MHz


def geometry_cards(p):
    """p: dict con W, H (m), r (radio hilo), dz, D, Lr, rr (radio reflector), seg (segs/m)."""
    W, H, r, dz = p['W'], p['H'], p['r'], p['dz']
    ns = lambda L: max(3, int(round(L * p['seg'])) | 1)   # impar
    cards = []
    tag = 0
    def gw(a, b, rad):
        nonlocal tag
        tag += 1
        n = ns(math.dist(a, b))
        cards.append('GW %d %d %.5f %.5f %.5f %.5f %.5f %.5f %.5f' % (tag, n, *a, *b, rad))
        return tag, n
    # lazo A en el plano XZ (z inferior 0, superior H)
    fa = gw((-W/2, 0, 0), (W/2, 0, 0), r)              # lado inferior (alimentacion en el centro)
    gw((W/2, 0, 0), (W/2, 0, H), r); gw((W/2, 0, H), (-W/2, 0, H), r); gw((-W/2, 0, H), (-W/2, 0, 0), r)
    # lazo B en el plano YZ, desplazado dz hacia arriba
    fb = gw((0, -W/2, dz), (0, W/2, dz), r)
    gw((0, W/2, dz), (0, W/2, H + dz), r); gw((0, W/2, H + dz), (0, -W/2, H + dz), r); gw((0, -W/2, H + dz), (0, -W/2, dz), r)
    if p.get('Lr', 0) > 0:
        gw((-p['Lr']/2, 0, -p['D']), (p['Lr']/2, 0, -p['D']), p['rr'])
        gw((0, -p['Lr']/2, -p['D'] - 0.01), (0, p['Lr']/2, -p['D'] - 0.01), p['rr'])
    return cards, fa, fb


def deck(p, f, mode='harness', pattern=True):
    cards, (ta, na), (tb, nb) = geometry_cards(p)
    sa, sb = na // 2 + 1, nb // 2 + 1
    out = ['CM Eggbeater satelites', 'CE'] + cards + ['GE 0']
    if mode == 'ideal':
        out += ['EX 0 %d %d 0 1.0 0.0' % (ta, sa), 'EX 0 %d %d 0 0.0 %.4f' % (tb, sb, p.get('sense', 1.0))]
    else:
        # linea de fase: Z0, longitud electrica (m) = fisica / VF (incluidas las colas)
        Le = p['Lph_el']
        # Z0 negativo = linea cruzada (vivo<->malla invertidos en el extremo B) -> invierte el sentido
        z0 = -p['Zph'] if p.get('sense', 1.0) < 0 else p['Zph']
        out += ['TL %d %d %d %d %.2f %.5f 0 0 0 0' % (ta, sa, tb, sb, z0, Le)]
        out += ['EX 0 %d %d 0 1.0 0.0' % (ta, sa)]
    out += ['FR 0 1 0 0 %.4f 0' % f]
    if pattern:
        out += ['RP 0 19 8 1000 0 0 5 45']          # theta 0..90 cada 5, phi 0..315 cada 45
    else:
        out += ['XQ']
    out += ['EN']
    return '\n'.join(out) + '\n', (ta, sa), (tb, sb)


def run(p, f, mode='harness', pattern=True):
    d, fa, fb = deck(p, f, mode, pattern)
    with tempfile.TemporaryDirectory() as td:
        i, o = os.path.join(td, 'a.nec'), os.path.join(td, 'a.out')
        open(i, 'w').write(d)
        subprocess.run(['nec2c', '-i', i, '-o', o], check=True, capture_output=True)
        txt = open(o).read()
    return parse(txt), d


def parse(txt):
    res = {'z': [], 'pat': []}
    m = txt.split('ANTENNA INPUT PARAMETERS')
    if len(m) > 1:
        for line in m[1].splitlines()[3:6]:
            v = line.split()
            if len(v) >= 11 and v[0].isdigit():
                res['z'].append(complex(float(v[6]), float(v[7])))
    if 'RADIATION PATTERNS' in txt:
        body = txt.split('RADIATION PATTERNS')[1].splitlines()[5:]
        for line in body:
            v = line.split()
            if len(v) < 11:
                if res['pat']: break
                continue
            try:
                th, ph, tot = float(v[0]), float(v[1]), float(v[4])
                et = float(v[-4]) * cmath.exp(1j * math.radians(float(v[-3])))
                ep = float(v[-2]) * cmath.exp(1j * math.radians(float(v[-1])))
            except ValueError:
                break
            res['pat'].append((th, ph, tot, et, ep, v[7] if len(v) >= 12 else ''))
    return res


def circ_gains(pat):
    """Ganancia RHCP y LHCP (dBic) para cada punto: reparte la ganancia total segun |E_R|^2/|E_L|^2.
    Convencion validada con la columna SENSE de NEC (RIGHT/LEFT)."""
    out = []
    for th, ph, tot, et, ep, sense in pat:
        er = abs(et + 1j * ep) ** 2 / 2; el = abs(et - 1j * ep) ** 2 / 2
        s = er + el
        if s <= 0 or tot < -900:
            out.append((th, ph, -99, -99)); continue
        g = 10 ** (tot / 10)
        out.append((th, ph, 10 * math.log10(max(g * er / s, 1e-10)), 10 * math.log10(max(g * el / s, 1e-10))))
    return out


def swr(z, z0=50.0):
    g = abs((z - z0) / (z + z0)); return (1 + g) / (1 - g) if g < 1 else 99


if __name__ == '__main__':
    import sys
    f = float(sys.argv[1]) if len(sys.argv) > 1 else 145.9
    lam = C / f
    p = dict(W=0.440 * 145 / f, H=0.680 * 145 / f, r=0.003, dz=0.012, D=1.0 * 145 / f, Lr=1.0 * 145 / f,
             rr=0.002, seg=80 * f / 145, Zph=93.0, Lph_el=lam / 4)
    r, _ = run(p, f)
    print('Zin', r['z'], 'SWR', swr(r['z'][0]))
    for th, ph, gr, gl in circ_gains(r['pat'])[:19]:
        print(f'theta {th:4.0f}  RHCP {gr:6.2f}  LHCP {gl:6.2f}')
