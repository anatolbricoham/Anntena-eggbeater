#!/usr/bin/env python3
"""Ajuste de la Eggbeater para satelites LEO (2 m y 70 cm) con nec2c.

Criterio de satelite: un satelite LEO a 500 km esta ~3.4 veces mas lejos a 10 grados de
elevacion que en el cenit (~10.6 dB mas de perdidas de trayecto). Se busca maximizar el
PEOR margen de enlace relativo  M(el) = G_RHCP(el) - dL(el)  entre 10 y 90 grados de
elevacion (media en azimut), con ROE < 1.3 en la sub-banda de satelites.

Uso: python3 sim/optimize.py            -> escribe sim/resultados.json y tablas
"""
import json, math, os, sys, itertools, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from eggbeater import run, circ_gains, swr, C

RE, ALT = 6371.0, 500.0
BANDS = {
    '2m':   dict(f0=145.9, band=(145.8, 146.0), r=0.003, rr=0.002, dz=0.012, seg=80,
                 aspect=0.680 / 0.440, W0=0.440 * 145 / 145.9, VF=0.86, lead=0.020,
                 material='pletina de aluminio 10x2 mm (radio equivalente 3 mm)', refl='varilla de aluminio 4 mm'),
    '70cm': dict(f0=436.5, band=(435.0, 438.0), r=0.002, rr=0.002, dz=0.008, seg=240,
                 aspect=0.680 / 0.440, W0=0.440 * 145 / 436.5, VF=0.86, lead=0.010,
                 material='varilla de aluminio/latón 4 mm', refl='varilla de aluminio 4 mm'),
}


def slant(el_deg):
    e = math.radians(el_deg)
    return math.sqrt((RE + ALT) ** 2 - (RE * math.cos(e)) ** 2) - RE * math.sin(e)


def dL(el):
    return 20 * math.log10(slant(el) / ALT)


def evaluate(b, s, k, D, Lr, sense=1.0):
    f0 = b['f0']; lam = C / f0
    W = b['W0'] * s; H = W * b['aspect']
    p = dict(W=W, H=H, r=b['r'], dz=b['dz'], rr=b['rr'], seg=b['seg'], Zph=93.0,
             Lph_el=k * lam / 4, D=D * lam, Lr=Lr * lam, sense=sense)
    r, deck = run(p, f0)
    cg = circ_gains(r['pat'])
    by = collections.defaultdict(list)
    for th, ph, gr, gl in cg:
        by[90 - th].append((gr, gl))
    rhcp = {el: sum(x[0] for x in v) / len(v) for el, v in by.items()}
    lhcp = {el: sum(x[1] for x in v) / len(v) for el, v in by.items()}
    margin = min(rhcp[el] - dL(el) for el in rhcp if el >= 10)
    sw = [swr(run(p, f, pattern=False)[0]['z'][0]) for f in (b['band'][0], f0, b['band'][1])]
    return dict(p=p, rhcp=rhcp, lhcp=lhcp, margin=margin, swr=sw, deck=deck)


def tune_match(b, D, Lr):
    best = None
    for s in [0.94 + 0.01 * i for i in range(13)]:
        for k in (0.9, 0.95, 1.0, 1.05, 1.1):
            e = evaluate(b, s, k, D, Lr)
            ar0 = e['rhcp'][90] - e['lhcp'][90]          # pureza en el cenit
            cost = max(e['swr']) + (0 if ar0 > 15 else (15 - ar0) * 0.05)
            if best is None or cost < best[0]:
                best = (cost, s, k, e)
    return best


def main():
    out = {}
    for name, b in BANDS.items():
        lam = C / b['f0']
        # 1) barrido del reflector con adaptacion inicial
        s, k = 1.0, 1.0
        cands = []
        for D in (0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.5):
            for Lr in (0.45, 0.48, 0.51):
                e = evaluate(b, s, k, D, Lr)
                cands.append((e['margin'], D, Lr, e))
        cands.sort(key=lambda x: -x[0])
        _, D, Lr, _ = cands[0]
        # 2) ajuste fino de lazo (s) y linea de fase (k) con ese reflector
        cost, s, k, e = tune_match(b, D, Lr)
        # 3) comparativa: sin reflector y reflector EA5WA/K5OE (~0.5 lambda)
        ref = {
            'sin_reflector': evaluate(b, s, k, 0, 0),
            'reflector_0.5λ (EA5WA/K5OE)': evaluate(b, s, k, 0.49, 0.49),
            'optimo_satelite': e,
        }
        W, H = e['p']['W'], e['p']['H']
        Lph_phys = (e['p']['Lph_el'] - 2 * b['lead']) * b['VF']
        out[name] = dict(
            f0=b['f0'], band=b['band'], lam_mm=round(lam * 1000, 1),
            loop_W_mm=round(W * 1000, 1), loop_H_mm=round(H * 1000, 1),
            loop_perimeter_mm=round(2 * (W + H) * 1000, 1), loop_perimeter_lambda=round(2 * (W + H) / lam, 3),
            material=b['material'], wire_radius_mm=b['r'] * 1000, cross_offset_mm=b['dz'] * 1000,
            reflector_len_mm=round(Lr * lam * 1000, 1), reflector_below_mm=round(D * lam * 1000, 1),
            reflector_D_lambda=D, reflector_L_lambda=Lr, reflector_material=b['refl'],
            phasing='RG-62 (93 ohm, VF 0.86)', phasing_electrical_mm=round(e['p']['Lph_el'] * 1000, 1),
            phasing_coax_mm=round(Lph_phys * 1000, 1), phasing_leads_mm=b['lead'] * 1000,
            swr=[round(x, 2) for x in e['swr']],
            patterns={k2: dict(rhcp={int(el): round(v, 2) for el, v in sorted(r['rhcp'].items())},
                               lhcp={int(el): round(v, 2) for el, v in sorted(r['lhcp'].items())},
                               margin=round(r['margin'], 2), swr=[round(x, 2) for x in r['swr']])
                      for k2, r in ref.items()},
            path_loss_rel={int(el): round(dL(el), 2) for el in range(0, 91, 5)},
        )
        open(os.path.join(os.path.dirname(__file__), f'eggbeater_{name}.nec'), 'w').write(e['deck'])
        print(f"{name}: lazo {W*1000:.0f} x {H*1000:.0f} mm, reflector {Lr*lam*1000:.0f} mm a {D*lam*1000:.0f} mm, "
              f"fase {Lph_phys*1000:.0f} mm RG-62, ROE {['%.2f' % x for x in e['swr']]}, margen {e['margin']:.1f} dB")
    json.dump(out, open(os.path.join(os.path.dirname(__file__), 'resultados.json'), 'w'), indent=1, ensure_ascii=False)


if __name__ == '__main__':
    main()
