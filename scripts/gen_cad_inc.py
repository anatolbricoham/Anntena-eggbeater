#!/usr/bin/env python3
"""sim/resultados.json -> cad/gen/dimensiones.scad (medidas electricas para las piezas)."""
import json, os
root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
r = json.load(open(os.path.join(root, 'sim', 'resultados.json')))
os.makedirs(os.path.join(root, 'cad', 'gen'), exist_ok=True)
with open(os.path.join(root, 'cad', 'gen', 'dimensiones.scad'), 'w') as f:
    f.write('// GENERADO por scripts/gen_cad_inc.py desde sim/resultados.json\n')
    for b, s in (('2m', '2M'), ('70cm', '70')):
        d = r[b]
        f.write(f"LOOP_W_{s} = {d['loop_W_mm']}; LOOP_H_{s} = {d['loop_H_mm']}; DZ_{s} = {d['cross_offset_mm']};\n"
                f"REFL_L_{s} = {d['reflector_len_mm']}; REFL_D_{s} = {d['reflector_below_mm']};\n")
print('ok')
