#!/usr/bin/env python3
"""Graficas de la Eggbeater II de K5OE (sim/k5oe_resultados.json -> docs/img/diagrama_<banda>.png):
ganancia RHCP en elevacion (con y sin reflector) y ROE frente a frecuencia."""
import json, os
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
r = json.load(open(os.path.join(ROOT, 'sim', 'k5oe_resultados.json')))
INK, INK2, GRID, BG = '#0b0b0b', '#52514e', '#e4e3df', '#fcfcfb'
C1, C2 = '#2a78d6', '#eb6834'
plt.rcParams.update({'font.size': 10, 'axes.edgecolor': GRID, 'axes.labelcolor': INK2,
                     'xtick.color': INK2, 'ytick.color': INK2, 'text.color': INK})
BANDS = {'2m': (145.8, 146.0), '70cm': (435.0, 438.0)}

for band, d in r.items():
    fig, (a1, a2) = plt.subplots(1, 2, figsize=(11, 4.2), facecolor=BG)
    for ax in (a1, a2):
        ax.set_facecolor(BG); ax.grid(True, color=GRID, lw=0.8)
        for s in ('top', 'right'): ax.spines[s].set_visible(False)
    for key, lab, col, ls in (('rhcp', 'K5OE con reflector', C1, '-'), ('rhcp_sin_reflector', 'Sin reflector', C2, '--')):
        el = sorted(int(e) for e in d[key]); y = [d[key][str(e)] for e in el]
        a1.plot(el, y, color=col, lw=2, ls=ls, label=lab)
        a1.annotate(lab, (el[-1], y[-1]), xytext=(4, 0), textcoords='offset points', color=INK2, fontsize=8, va='center')
    a1.set_xlim(0, 112); a1.set_xticks(range(0, 91, 15))
    a1.set_xlabel('Elevación (grados)'); a1.set_ylabel('dBic')
    a1.set_title(f'Ganancia RHCP (media en azimut), {band} {d["f0"]} MHz', fontsize=10, loc='left')
    a1.legend(frameon=False, fontsize=8, loc='upper right')
    f = [x[0] for x in d['sweep']]; s = [x[1] for x in d['sweep']]
    lo, hi = BANDS[band]
    a2.axvspan(lo, hi, color=GRID, alpha=0.8, lw=0)
    a2.text((lo + hi) / 2, max(s) * 0.98, 'sub-banda\nsatélite', ha='center', va='top', color=INK2, fontsize=8)
    a2.plot(f, s, color=C1, lw=2)
    a2.set_xlabel('Frecuencia (MHz)'); a2.set_ylabel('ROE (50 Ω)')
    a2.set_title('ROE simulada con la línea de fase RG-62', fontsize=10, loc='left')
    fig.tight_layout()
    out = os.path.join(ROOT, 'docs', 'img', f'diagrama_{band}.png')
    fig.savefig(out, dpi=130); plt.close(fig); print('ok', out)
