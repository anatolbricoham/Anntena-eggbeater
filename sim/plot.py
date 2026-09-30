#!/usr/bin/env python3
"""Graficas de diagrama en elevacion (RHCP) y margen de enlace a satelite LEO.
Lee sim/resultados.json y escribe docs/img/diagrama_<banda>.png"""
import json, os
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
r = json.load(open(os.path.join(ROOT, 'sim', 'resultados.json')))
SERIES = [('optimo_satelite', 'Optimizada satélite', '#2a78d6', '-'),
          ('reflector_0.5λ (EA5WA/K5OE)', 'Reflector 0.5 λ (EA5WA/K5OE)', '#eb6834', '--'),
          ('sin_reflector', 'Sin reflector', '#1baf7a', ':')]
INK, INK2, GRID = '#0b0b0b', '#52514e', '#e4e3df'
plt.rcParams.update({'font.size': 10, 'axes.edgecolor': GRID, 'axes.labelcolor': INK2,
                     'xtick.color': INK2, 'ytick.color': INK2, 'text.color': INK})

for band, d in r.items():
    fig, axes = plt.subplots(1, 2, figsize=(11, 4.2), facecolor='#fcfcfb')
    pl = {int(k): v for k, v in d['path_loss_rel'].items()}
    for ax, what, title in ((axes[0], 'g', f'Ganancia RHCP (media en azimut), {band} {d["f0"]} MHz'),
                            (axes[1], 'm', 'Margen relativo = G_RHCP − pérdida extra de trayecto (LEO 500 km)')):
        ax.set_facecolor('#fcfcfb')
        for key, label, col, ls in SERIES:
            p = d['patterns'][key]['rhcp']
            el = sorted(int(e) for e in p)
            y = [p[str(e)] - (pl[e] if what == 'm' else 0) for e in el]
            ax.plot(el, y, color=col, lw=2, ls=ls, label=label)
            ax.annotate(label.split(' (')[0], (el[-1], y[-1]), xytext=(4, 0), textcoords='offset points',
                        color=INK2, fontsize=8, va='center')
        if what == 'm':
            ax.axvspan(0, 10, color=GRID, alpha=0.6, lw=0)
            ax.text(5, ax.get_ylim()[0] + 0.5, '< 10°', ha='center', color=INK2, fontsize=8)
        ax.set_xlim(0, 105); ax.set_xticks(range(0, 91, 15))
        ax.set_xlabel('Elevación (grados)'); ax.set_ylabel('dBic' if what == 'g' else 'dB')
        ax.grid(True, color=GRID, lw=0.8); ax.set_title(title, fontsize=10, color=INK, loc='left')
        for s in ('top', 'right'): ax.spines[s].set_visible(False)
    axes[0].legend(frameon=False, fontsize=8, loc='lower center')
    fig.tight_layout()
    out = os.path.join(ROOT, 'docs', 'img', f'diagrama_{band}.png')
    fig.savefig(out, dpi=130); plt.close(fig); print('ok', out)
