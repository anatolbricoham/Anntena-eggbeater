#!/usr/bin/env python3
"""Verificacion NEC2 (nec2c) de la Eggbeater II ORIGINAL de K5OE, sin cambiar sus medidas.

Medidas de K5OE (segun las reconstrucciones publicadas de su articulo):
  2 m : lazos 51 x 63 cm, hilo #8 AWG; reflectores 100.5 cm a 101 cm bajo los lazos;
        linea de fase RG-62 de 41.5 cm (+2.5 cm pelados en cada extremo)
  70cm: lazos 17.1 x 20.9 cm; reflectores 33.5 cm a 33 cm bajo los lazos;
        linea de fase RG-62 de 13.5 cm (+2.5 cm pelados en cada extremo)
  Alimentacion en el tapon superior del mastil; los lados inferiores atraviesan el mastil.

Uso: python3 sim/k5oe.py   -> sim/k5oe_resultados.json + tablas
"""
import json, os, sys, collections
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from eggbeater import run, circ_gains, swr

VF = 0.84   # RG-62A/U
K5OE = {
    '2m':   dict(f0=145.9, band=(145.8, 146.0), W=0.510, H=0.630, r=0.00163, dz=0.006,
                 D=1.010, Lr=1.005, rr=0.00318, coax=0.415, lead=0.025, seg=80),
    '70cm': dict(f0=436.5, band=(435.0, 438.0), W=0.171, H=0.209, r=0.00163, dz=0.005,
                 D=0.330, Lr=0.335, rr=0.00318, coax=0.135, lead=0.025, seg=240),
}


def params(k, sense=1.0, refl=True):
    return dict(W=k['W'], H=k['H'], r=k['r'], dz=k['dz'], D=k['D'] if refl else 0, Lr=k['Lr'] if refl else 0,
                rr=k['rr'], seg=k['seg'], Zph=93.0, Lph_el=k['coax'] / VF + 2 * k['lead'], feed='top', sense=sense)


def pattern(p, f):
    r, deck = run(p, f)
    by = collections.defaultdict(list)
    for th, ph, gr, gl in circ_gains(r['pat']):
        by[int(round(90 - th))].append((gr, gl))
    return ({el: round(sum(x[0] for x in v) / len(v), 2) for el, v in sorted(by.items())},
            {el: round(sum(x[1] for x in v) / len(v), 2) for el, v in sorted(by.items())}, deck)


def main():
    out = {}
    for b, k in K5OE.items():
        p = params(k)
        fs = np.round(np.linspace(k['f0'] * 0.93, k['f0'] * 1.07, 29), 2)
        sweep = [(float(f), round(swr(run(p, f, pattern=False)[0]['z'][0]), 3)) for f in fs]
        zin = run(p, k['f0'], pattern=False)[0]['z'][0]
        rh, lh, deck = pattern(p, k['f0'])
        rh0, lh0, _ = pattern(params(k, refl=False), k['f0'])
        open(os.path.join(os.path.dirname(__file__), f'k5oe_{b}.nec'), 'w').write(deck)
        band = [round(swr(run(p, f, pattern=False)[0]['z'][0]), 2) for f in (k['band'][0], k['f0'], k['band'][1])]
        out[b] = dict(k5oe={x: k[x] for x in ('W', 'H', 'D', 'Lr', 'coax', 'lead')}, f0=k['f0'],
                      zin=[round(zin.real, 1), round(zin.imag, 1)], swr_band=band, sweep=sweep,
                      rhcp=rh, lhcp=lh, rhcp_sin_reflector=rh0)
        print(f"{b}: Zin {zin.real:.1f}{zin.imag:+.1f}j  ROE sub-banda {band}  "
              f"RHCP el10 {rh[10]:+.1f} el30 {rh[30]:+.1f} el60 {rh[60]:+.1f} el90 {rh[90]:+.1f} dBic "
              f"(LHCP cenit {lh[90]:+.1f})")
    json.dump(out, open(os.path.join(os.path.dirname(__file__), 'k5oe_resultados.json'), 'w'), indent=1)


if __name__ == '__main__':
    main()
